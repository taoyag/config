local function keyStroke(mods, key)
  return function() hs.eventtap.keyStroke(mods, key, 0) end
end

local function remap(mods, key, fn)
  return hs.hotkey.bind(mods, key, fn, nil, fn)
end

-- global
remap({'ctrl'}, 'm', keyStroke({}, 'return'))
remap({'ctrl'}, 'h', keyStroke({}, 'delete'))
