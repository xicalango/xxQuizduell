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
  
  utils.shuffle( self.answers )
end

function Question:__tostring()
  return self.text .. ": " .. tostring(self.answers)
end

function Question:inputAnswer()
  return utils.menu( self.answers, { header = self.text } )
end

--- Answer
Answer = class()

function Answer:_init( text, correct )
  self.text = text
  self.correct = correct
end

function Answer:__tostring()
  return self.text
end

Player = class()

function Player:_init( name )
  self.name = name
end

function Player:__tostring()
  return self.name
end

--- Challenge
Challenge = class()

function Challenge:_init( categories, player1, player2 )
  self.categories = categories
  self.players = { player1, player2 }
  self.current_player = 1
  self.rounds = List()
  self.currentRound = 1
  self.numRounds = 6
end

function Challenge:getAlreadyPlayedCategories()
  return Set( self.rounds:map(function(e) return e.category.name end) )
end

function Challenge:isRunning()
  return self.currentRound <= self.numRounds
end

function Challenge:selectNextRound()
  if not self:isRunning() then
    error("Game is over")
  end
  
  local played_categories = self:getAlreadyPlayedCategories()
  local next_categories = self.categories:getNextCategorySelection( played_categories )

  local selected_category = utils.menu( next_categories, {header = "Player " .. self.current_player .. ", select the next category"} )

  local round = Round( self.rounds:len() + 1, self.categories:getCategoryByName(selected_category) )

  self.rounds:append( round )

  return round
end

function Challenge:getCurrentRound()
  return self.rounds[ self.currentRound ]
end

function Challenge:playRound()
  if not self:isRunning() then
    error( "Game is over" )
  end
  
  local round = self:getCurrentRound()
  
  if round.playerAnswers[ self.current_player ]:len() ~= 0 then
    error("Round already played")
  end
  
  print("It's " .. tostring(self.players[ self.current_player ]) .. " turn")
  
  for question in round.questions:iter() do
    local answer = question:inputAnswer()
    
    round.playerAnswers[ self.current_player ]:append(answer.correct)
  end
  
end

function Challenge:switchPlayers()
  self.current_player = 3 - self.current_player
end

function Challenge:prepareNextRound()
  self.currentRound = self.currentRound + 1
end

function Challenge:play()
  while self:isRunning() do
    print("Start round " .. tostring(self.currentRound))
    self:selectNextRound()
    self:playRound()
    self:switchPlayers()
    self:playRound()
    print("Score of player " .. tostring(self.current_player) .. ": " .. self:getPlayerScore( self.current_player ))
    self:prepareNextRound()
  end
  
  for round in self.rounds:iter() do
    print(tostring(round))
  end
  
  for i,v in ipairs(self.players) do
    print("Player " .. v.name .. " score: " .. self:getPlayerScore( i ))
  end
end

function Challenge:getPlayerScore( player_number )
  return self.rounds
    :map( function(round) return round:sumCorrectAnswers( player_number ) end )
    :reduce('+')
end

--- Round
Round = class()

function Round:_init( num, category )
  self.num = num
  self.category = category
  self.questions = category:getRandomQuestions()
  self.playerAnswers = List{ List(), List() }
end

function Round:sumCorrectAnswers( player_number )
  return self.playerAnswers[player_number]:count( true )
end

function Round:__tostring()
  return "{round " .. tostring(self.num) .. " category '" .. self.category.name .. "' answers " .. tostring(self.playerAnswers) .. "}"
end

--- Main
local function main()
  local categories = CategoryCollection.from_questions_file( questions )

  local player1 = Player( "1" )
  local player2 = Player( "2" )

  local challenge = Challenge( categories, player1, player2 )

  challenge:play()
end

main()

