
local questions = {}

for i = 1, 20 do
  local category = {}
  
  category.category = "Category " .. tostring(i)
  category.questions = {}
  
  for j = 1, 4 do
    local question = {}
    question.text = category.category .. " question " .. tostring(j)
    question.answers = { "correct", "wrong1", "wrong2", "wrong3" }
    table.insert( category.questions, question )
  end
  
  table.insert( questions, category )
end


return questions

--[[
local questions = {
  {
    category = "A",
    questions = {
      {
        text = "a1 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      },
      {
        text = "a2 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      },
      {
        text = "a3 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      },
      {
        text = "a4 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      }
    }
  },

  {
    category = "B",
    questions = {
      {
        text = "b1 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      },
      {
        text = "b2 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      },
      {
        text = "b3 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      },
      {
        text = "b4 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      }
    }
  },

  {
    category = "C",
    questions = {
      {
        text = "c1 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      },
      {
        text = "c2 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      },
      {
        text = "c3 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      },
      {
        text = "c4 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      }
    }
  },

  {
    category = "D",
    questions = {
      {
        text = "d1 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      },
      {
        text = "d2 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      },
      {
        text = "d3 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      },
      {
        text = "d4 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      }
    }
  },

  {
    category = "E",
    questions = {
      {
        text = "e1 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      },
      {
        text = "e2 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      },
      {
        text = "e3 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      },
      {
        text = "e4 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      }
    }
  },

  {
    category = "F",
    questions = {
      {
        text = "f1 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      },
      {
        text = "f2 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      },
      {
        text = "f3 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      },
      {
        text = "f4 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      },
      {
        text = "f question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      }
    }
  },

  {
    category = "G",
    questions = {
      {
        text = "g1 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      },
      {
        text = "g2 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      },
      {
        text = "g3 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      },
      {
        text = "g4 question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      },
      {
        text = "g question text?",
        answers = {
          "correct",
          "wrong1",
          "wrong2",
          "wrong3"
        }
      }
    }
  },
}

return questions

--]]
