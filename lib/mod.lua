
local mod = require 'core/mods'

if note_players == nil then
    note_players = {}
end

local function add_ex_params(i)
    local param_offset = 11 * i
    params:add_group("ex_voice_" .. i, "ex macro voice " .. i + 1, 9)

    params:add_number("model_" .. i, "model", 0, 23, 0)
    params:set_action("model_" .. i, function(n)
        crow.ii.disting.parameter(param_offset + 7, n)
    end)

    params:add_number("harmonics_" .. i, "harmonics", 0, 127, 64)
    params:set_action("harmonics_" .. i, function(n)
        crow.ii.disting.parameter(param_offset + 10, n)
    end)

    params:add_number("timbre_" .. i, "timbre", 0, 127, 64)
    params:set_action("timbre_" .. i, function(n)
        crow.ii.disting.parameter(param_offset + 11, n)
    end)   

   params:add_number("morph_" .. i, "morph", 0, 127, 64)
   params:set_action("morph_" .. i, function(n)
        crow.ii.disting.parameter(param_offset + 12, n)
    end)

    params:add_number("fm_" .. i, "FM Depth", -100, 100, 0)
    params:set_action("fm_" .. i, function(n)
        crow.ii.disting.parameter(param_offset + 13, n)
    end)

    params:add_number("timbre_mod_" .. i, "Timbre Mod", -100, 100, 0)
    params:set_action("timbre_mod_" .. i, function(n)
        crow.ii.disting.parameter(param_offset + 14, n)
    end)

    params:add_number("morph_mod_" .. i, "Morphe Mod", -100, 100, 0)
    params:set_action("morph_mod_" .. i, function(n)
        crow.ii.disting.parameter(param_offset + 15, n)
    end)

    params:add_number("low_pass_gate_" .. i, "LPG", 0, 127, 127)
    params:set_action("low_pass_gate_" .. i, function(n)
        crow.ii.disting.parameter(param_offset + 16, n)
    end)

    params:add_number("time_" .. i, "Time/decay", 0, 127, 64)
    params:set_action("time_" .. i, function(n)
        crow.ii.disting.parameter(param_offset + 17, n)
    end)


    params:hide("ex_voice_" .. i)
end

local function add_mono_player(idx)
    local player = {
        count = 0 -- TODO: I'm not sure why this is here but it shows up in other places
    }

    function player:note_on(note, vel)
        local v_vel = vel * 10
        local v8 = (note - 60)/12        
        crow.ii.disting.voice_pitch(idx, v8)
        crow.ii.disting.voice_on(idx, v_vel)
    end

    function player:pitch_bend(note, amount)
        local v8 = (note + amount - 60)/12
        crow.ii.disting.voice_pitch(note, v8)
    end

    function player:note_off(note)
        crow.ii.disting.voice_off(idx)
    end
    
    function player:describe()
        return {
            name = "ex n " ..idx,
            supports_bend = true,
            supports_slew = false,
            modulate_description = "unsupported",
        }
    end

    function player:stop_all()
        crow.ii.disting.voice_off(idx)
    end

    function player:active()
        params:show("ex_voice_" .. idx)
        _menu.rebuild_params()
    end

    function player:inactive()
        params:hide("ex_voice_" .. idx)
        _menu.rebuild_params()
    end

    function player:add_params()
        add_ex_params(idx)
    end

    note_players['ex macro 2 '..idx + 1] = player
end

mod.hook.register("script_pre_init", "nb ex macro 2 pre init", function()
    for n=0,3 do
        add_mono_player(n)
    end
end)
