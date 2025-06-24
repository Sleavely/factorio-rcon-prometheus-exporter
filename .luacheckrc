-- Define globals for the luacheck linter
-- https://luacheck.readthedocs.io/en/stable/index.html

-- Factorio uses Lua 5.2 with some additions
-- https://lua-api.factorio.com/2.0.55/auxiliary/libraries.html
std = "lua52"

max_line_length = false

read_globals = {"game", "rcon"}
