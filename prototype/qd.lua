#!/usr/bin/env lua

require 'pl'

local questions = require "questions"

CategoryCollection = class()

function CategoryCollection.from_questions_file( questions )
  local categories = CategoryCollection()

  for _, cat_table in ipairs(questions) do
    local category = Category(cat_table.category)

    for _, ques_table in ipairs(cat_table.questions) do
      category:addQuestion( ques_table.text, ques_table.answers )
    end

    categories:addCategory( category )
  end

  return categories
end

function CategoryCollection:_init()
  self.categories = Map()
end

function CategoryCollection:addCategory( category )
  self.categories:set( category.name, category )
end

function CategoryCollection:getCategoryByName( category_name )
  return self.categories[category_name]
end

function CategoryCollection:getCategoryNames()
  return self.categories:keys()
end

function CategoryCollection:getNextCategorySelection( old_categories, num_categories )
  num_categories = num_categories or 3

  local unused_categories = self:getCategoryNames():filter( function(v) return old_categories[v] ~= true end )

  while unused_categories:len() > num_categories do
    unused_categories:remove( math.random(1, unused_categories:len()) )
  end

  return unused_categories
end

Category = class()

function Category:_init( name )
  self.name = name
  self.questions = List.new()
end

function Category:addQuestion( text, answers )
  self.questions:append( Question( text, answers ) )
end

function Category:__tostring()
  return self.name .. ": " .. tostring(self.questions)
end

Question = class()

function Question:_init( text, answers )
  self.text = text
  self.answers = List.new( answers )
end

function Question:__tostring()
  return self.text .. ": " .. tostring(self.answers)
end

Player = class()

function Player:_init( name )
  self.name = name
end

Challenge = class()

function Challenge:_init( categories, player1, player2 )
  self.categories = categories
  self.players = { player1, player2 }
  self.current_player = 1
  self.rounds = List.new()
  self.current_round = 1
end

function Challenge:getAlreadyPlayedCategories()
  return Set( self.rounds:map(function(e) return e.category end) )
end

function Challenge:selectNextRound()
  local played_categories = self:getAlreadyPlayedCategories()
  local next_categories = self.categories:getNextCategorySelection( played_categories )

  local selected_category = selectList( next_categories, {header = "Player " .. self.current_player .. ", select the next category"} )

  local round = Round( self.rounds:len() + 1, self.categories:getCategoryByName(selected_category) )

  self.rounds:append( round )

  return round
end

Round = class()

function Round:_init( num, category )
  self.num = num
  self.category = category
end

function selectList(list, options)
  options = options or {}
  options.prompt = options.prompt or "> "
  local selection = nil

  repeat
    if options.header then
      print(options.header)
    end

    local i = 1
    for v in list:iter() do
      print(i, v)
      i = i + 1
    end

    if options.prompt then
      io.write(options.prompt)
    end

    selection = tonumber( io.read() )

  until selection ~= nil or options.repeats

  return list[selection], selection
end

local function main()
  local categories = CategoryCollection.from_questions_file( questions )

  local player1 = Player( "1" )
  local player2 = Player( "2" )

  local challenge = Challenge( categories, player1, player2 )

  local round = challenge:selectNextRound()

  print(round.num, round.category.name)
end

main()

