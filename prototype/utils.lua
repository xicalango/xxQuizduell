require 'pl'

local utils = {}

function utils.shuffle( list )
  for i = 1, list:len() * 2 do
    local idx1 = math.random(1, list:len())
    local idx2 = math.random(1, list:len())
    
    list[idx1], list[idx2] = list[idx2], list[idx1]
  end
end

function utils.randomSeq( num, from, to )
  if num > (to-from) then
    error( num .. " elements requested, but range is only " .. (to - from) .. " elements long" )
  end
  
  local seqList = List(seq.range( from, to ))
  
  utils.shuffle( seqList )
  
  return seqList:slice(1, num)
end

function utils.selectFromList( list, index_list )
  return index_list:map( function(v) return list[v] end )
end

function utils.selectRandomSublist( list, num_elements )
  if list:len() < num_elements then
    error( num_elements .. " elements requested, but list is only " .. list:len() .. " elements long" )
  end
  
  local seqList = utils.randomSeq( num_elements, 1, list:len() )
  return utils.selectFromList( list, seqList )
end

function utils.menu(list, options)
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


return utils
