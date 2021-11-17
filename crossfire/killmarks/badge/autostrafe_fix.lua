local tables = {}

client.add_callback('create_move', function()
  local player = entitylist.get_local_player()
  if not player then return end

  -- ! inserting mask through table
  if not tables.autostrafe then tables.autostrafe = {} end
  if not tables.autostrafe.land then tables.autostrafe.land = 0.0 end

  if player:get_prop_bool('CBasePlayer', 'm_hGroundEntity') then
    tables.autostrafe.land = 1.0
  else
    tables.autostrafe.land = math.max(tables.autostrafe.land - 0.2, 0.0)
  end

  if tables.autostrafe.land ~= 0 then
    if not tables.autostrafe.autostop then
      tables.autostrafe.autostop = menu.get_bool('misc.fast_stop')
      menu.set_bool('misc.fast_stop', false)
    end
    if not tables.autostrafe.backup then
      tables.autostrafe.backup = menu.get_int('misc.smoothing')
    end
    menu.set_int('misc.smoothing', math.max(100 - math.floor(player:get_velocity():length_2d() /2), tables.autostrafe.backup))
  else
    if tables.autostrafe.autostop then
      menu.set_bool('misc.fast_stop', tables.autostrafe.autostop)
      tables.autostrafe.autostop = nil
    end
    if tables.autostrafe.backup then
      menu.set_int('misc.smoothing', tables.autostrafe.backup)
      tables.autostrafe.backup = nil
    end
  end
end)

client.add_callback('unload', function()
  if tables.autostrafe.autostop then
    menu.set_bool('misc.fast_stop', tables.autostrafe.autostop)
  end
  if tables.autostrafe.backup then
    menu.set_int('misc.smoothing', tables.autostrafe.backup)
  end
end)