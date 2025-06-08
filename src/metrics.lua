-- Fetch and print prometheus metrics for the current game state.

-- Helper ― escape " and \ inside label values so Prom/Influx scrapers
-- do not break.
local function esc(s)
    return tostring(s):gsub("\\", "\\\\"):gsub("\"", "\\\"")
end

-- Outputs formatted labels for one or two tables
local function build_labels(table1, table2)
  local mergedTable = {}
  for k, v in pairs(table1) do
    mergedTable[k] = v
  end
  if table2 then
    for k, v in pairs(table2) do
      mergedTable[k] = v
    end
  end

  local parts = {}
  for k, v in pairs(mergedTable) do
    table.insert(parts, string.format('%s="%s"', k, esc(v)))
  end
  return table.concat(parts, ', ')
end

local function metric_from_flow_statistics(metric_name, labels, statistics, inverted)
    -- If inverted is true, swap input and output counts
    if inverted then
        statistics = {
            input_counts = statistics.output_counts,
            output_counts = statistics.input_counts
        }
    end

    for item, amt in pairs(statistics.input_counts) do
        rcon.print('factorio_' .. metric_name .. '_production{' .. build_labels(labels, {name = item}) .. '} ' .. amt)
    end
    for item, amt in pairs(statistics.output_counts) do
        rcon.print('factorio_' .. metric_name .. '_consumption{' .. build_labels(labels, {name = item}) .. '} ' .. amt)
    end
end

rcon.print('factorio_ticks{} '        .. game.tick)
rcon.print('factorio_ticks_played{} ' .. game.ticks_played)

--------------------------------------------------------------------
-- Players
--------------------------------------------------------------------
for _, p in pairs(game.players) do
    local playerLabels = 'name="' .. esc(p.name) .. '"'
    rcon.print('factorio_player_connected{'     .. playerLabels .. '} ' .. (p.connected and 1 or 0))
    rcon.print('factorio_player_afk_time{'      .. playerLabels .. '} ' .. p.afk_time)
    rcon.print('factorio_player_online_time{'   .. playerLabels .. '} ' .. p.online_time)
end

for surfaceName, surface in pairs(game.surfaces) do

  --------------------------------------------------------------------
  -- Pollution
  --------------------------------------------------------------------
  metric_from_flow_statistics('pollution', {
      surface=surface.name
  }, surface.pollution_statistics)

  --------------------------------------------------------------------
  -- Electricity
  --------------------------------------------------------------------

  -- Find all unique electric networks by iterating all the poles
  local poles = surface.find_entities_filtered{type = "electric-pole"}
  local tracked_network_ids = {}
  for _, pole in pairs(poles) do
    local net_id = pole.electric_network_id
    if net_id and not tracked_network_ids[net_id] then
      tracked_network_ids[net_id] = true

      local network = pole.electric_network_statistics
      metric_from_flow_statistics('electricity', {
        surface=surface.name,
        network_id=net_id
      }, network, true)
    end
  end

  --------------------------------------------------------------------
  -- Item production
  --------------------------------------------------------------------
  local itemStatistics = game.forces.player.get_item_production_statistics(surfaceName)
  metric_from_flow_statistics('item', {
    surface=surface.name,
  }, itemStatistics)

  --------------------------------------------------------------------
  -- Fluid production
  --------------------------------------------------------------------
  local fluidStatistics = game.forces.player.get_fluid_production_statistics(surfaceName)
  metric_from_flow_statistics('fluid', {
    surface=surface.name,
  }, fluidStatistics)

  --------------------------------------------------------------------
  -- Placed buildings.
  -- Currently placed buildings = production minus consumption
  --------------------------------------------------------------------
  local buildCountStatistics = game.forces.player.get_entity_build_count_statistics(surfaceName)
  metric_from_flow_statistics('placement', {
    surface=surface.name,
  }, buildCountStatistics)

end
