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

function CategoryCollection:getCategoryNames()
  return self.categories.keys
end

function CategoryCollection:getNextCategorySelection( old_categories )
  return self:getCategoryNames():filter( function(v) return old_categories[v] ~= true end )
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

function Challenge:_init( player1, player2 )
  self.players = { player1, player2 }
  self.current_player = 1
  self.rounds = List.new()
end

function Challenge:getAlreadyPlayedCategories()
  return Set( self.rounds:map(function(e) return e.category end) )
end

Round = class()

function Round:_init( num, category )
  self.num = num
  self.category = category
end

local function main()
  local categories = CategoryCollection.from_questions_file( questions )

  local player1 = Player( "1" )
  local player2 = Player( "2" )

  local chal = Challenge( player1, player2 )
  chal.rounds:append( Round( 1, "A" ) )

  local played_categories = chal:getAlreadyPlayedCategories()

  print(categories:getNextCategorySelection( played_categories ))


end


main()

