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

-- Keep track of whether we printed the metadata for a metric.
-- Prometheus only allows one TYPE line to exist for a given metric name.
local printedMetrics = {}
local function metric_type_and_help(metric_name, metric_type, help_text)
  if not printedMetrics[metric_name] then
    rcon.print('# TYPE ' .. metric_name .. ' ' .. metric_type)
    if (help_text and help_text ~= '') then
      rcon.print('# HELP ' .. metric_name .. ' ' .. help_text)
    end
    printedMetrics[metric_name] = true
  end
end

local function metric_from_flow_statistics(metric_name, labels, statistics, inverted, help_text)
    -- If inverted is true, swap input and output counts
    if inverted then
        statistics = {
            input_counts = statistics.output_counts,
            output_counts = statistics.input_counts
        }
    end

    metric_type_and_help('factorio_' .. metric_name .. '_production', 'counter', help_text)
    for item, amt in pairs(statistics.input_counts) do
        rcon.print('factorio_' .. metric_name .. '_production{' .. build_labels(labels, {name = item}) .. '} ' .. amt)
    end
    rcon.print('')
    metric_type_and_help('factorio_' .. metric_name .. '_consumption', 'counter', help_text)
    for item, amt in pairs(statistics.output_counts) do
        rcon.print('factorio_' .. metric_name .. '_consumption{' .. build_labels(labels, {name = item}) .. '} ' .. amt)
    end
    rcon.print('')
end

metric_type_and_help('factorio_ticks', 'counter')
rcon.print('factorio_ticks{} '        .. game.tick)
rcon.print('')

metric_type_and_help('factorio_ticks_played', 'counter')
rcon.print('factorio_ticks_played{} ' .. game.ticks_played)
rcon.print('')

--------------------------------------------------------------------
-- Players
--------------------------------------------------------------------
metric_type_and_help('factorio_player_connected', 'gauge', 'Whether the player is connected to the server. 1 or 0.')
for _, p in pairs(game.players) do
    local playerLabels = 'name="' .. esc(p.name) .. '"'
    rcon.print('factorio_player_connected{'     .. playerLabels .. '} ' .. (p.connected and 1 or 0))
end
rcon.print('')

metric_type_and_help('factorio_player_afk_time', 'gauge', 'How many ticks since the last action of this player.')
for _, p in pairs(game.players) do
    local playerLabels = 'name="' .. esc(p.name) .. '"'
    rcon.print('factorio_player_afk_time{'      .. playerLabels .. '} ' .. p.afk_time)
end
rcon.print('')

metric_type_and_help('factorio_player_online_time', 'counter', 'How many ticks did this player spend playing this save (all sessions combined).')
for _, p in pairs(game.players) do
    local playerLabels = 'name="' .. esc(p.name) .. '"'
    rcon.print('factorio_player_online_time{'   .. playerLabels .. '} ' .. p.online_time)
end
rcon.print('')


--------------------------------------------------------------------
-- Pollution
--------------------------------------------------------------------
for surfaceName, surface in pairs(game.surfaces) do
  metric_from_flow_statistics('pollution', {
      surface=surface.name
  }, surface.pollution_statistics)
end

--------------------------------------------------------------------
-- Electricity
--------------------------------------------------------------------
for surfaceName, surface in pairs(game.surfaces) do
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
end

--------------------------------------------------------------------
-- Crafted items and consumed components during crafting.
--------------------------------------------------------------------
for surfaceName, surface in pairs(game.surfaces) do
  local itemStatistics = game.forces.player.get_item_production_statistics(surfaceName)
  metric_from_flow_statistics('item', {
    surface=surface.name,
  }, itemStatistics, false, 'Crafted items and consumed components during crafting.')
end

--------------------------------------------------------------------
-- Fluid production
--------------------------------------------------------------------
for surfaceName, surface in pairs(game.surfaces) do
  local fluidStatistics = game.forces.player.get_fluid_production_statistics(surfaceName)
  metric_from_flow_statistics('fluid', {
    surface=surface.name,
  }, fluidStatistics, false, 'Produced fluids and consumed fluids during crafting.')
end

--------------------------------------------------------------------
-- Placed and demolished buildings.
-- Currently placed buildings = production minus consumption
--------------------------------------------------------------------
for surfaceName, surface in pairs(game.surfaces) do
  local buildCountStatistics = game.forces.player.get_entity_build_count_statistics(surfaceName)
  metric_from_flow_statistics('placement', {
    surface=surface.name,
  }, buildCountStatistics, false, 'Placed and demolished buildings. Currently placed buildings = production minus consumption.')
end
