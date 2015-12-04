#!/usr/bin/env lua

require 'pl'

local utils = require 'utils'

local questions = require "questions"

--- Category collection
CategoryCollection = class()

function CategoryCollection.from_questions_file( questions )
  local categories = CategoryCollection()

  for _, cat_table in ipairs(questions) do
    local category = Category(cat_table.category)

    for _, ques_table in ipairs(cat_table.questions) do
      category:addQuestion( ques_table.text, ques_table.answers )
    end
  
    if category.questions:len() < 3 then
      error( "category " .. category.name .. " has too few questions. (" .. category.questions:len() .. "/3)" )
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

  return utils.selectRandomSublist( unused_categories, num_categories )
end

--- Category
Category = class()

function Category:_init( name )
  self.name = name
  self.questions = List()
end

function Category:addQuestion( text, answers )
  self.questions:append( Question( text, answers ) )
end

function Category:getRandomQuestions( num_questions )
  num_questions = num_questions or 3
  
  return utils.selectRandomSublist( self.questions, num_questions )
end

function Category:__tostring()
  return self.name .. ": " .. tostring(self.questions)
end

--- Question
Question = class()

function Question:_init( text, answers )
  self.text = text
  self.answers = List()
  
  for i, answer_text in ipairs(answers) do
    self.answers:append( Answer( answer_text, i == 1 ) )
  end
  
  if self.answers:len() ~= 4 then
    error( "not enough answers in question '" .. text .. "' (" .. self.answers:len() .. "/4)" )
  end
end

function Question:__tostring()
  return self.text .. ": " .. tostring(self.answers)
end

--- Answer
Answer = class()

function Answer:_init( text, correct )
  self.text = text
  self.correct = correct
end

function Answer:__tostring()
  return "{" .. self.text .. " = " .. (self.correct and "correct" or "wrong") .. "}"
end

Player = class()

function Player:_init( name )
  self.name = name
end

--- Challenge
Challenge = class()

function Challenge:_init( categories, player1, player2 )
  self.categories = categories
  self.players = { player1, player2 }
  self.current_player = 1
  self.rounds = List()
end

function Challenge:getAlreadyPlayedCategories()
  return Set( self.rounds:map(function(e) return e.category end) )
end

function Challenge:isRunning()
  return self.rounds:len() < 6
end

function Challenge:selectNextRound()
  local played_categories = self:getAlreadyPlayedCategories()
  local next_categories = self.categories:getNextCategorySelection( played_categories )

  local selected_category = utils.menu( next_categories, {header = "Player " .. self.current_player .. ", select the next category"} )

  local round = Round( self.rounds:len() + 1, self.categories:getCategoryByName(selected_category) )

  self.rounds:append( round )

  return round
end

--- Round
Round = class()

function Round:_init( num, category )
  self.num = num
  self.category = category
  self.questions = category:getRandomQuestions()
end


--- Main
local function main()
  local categories = CategoryCollection.from_questions_file( questions )

  local player1 = Player( "1" )
  local player2 = Player( "2" )

  local challenge = Challenge( categories, player1, player2 )

  local round = challenge:selectNextRound()

  print(round.num, round.category.name, round.questions)
end

main()

