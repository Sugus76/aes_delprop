Config = {}

Config.AllowedProps = {
    [GetHashKey("p_shovel02x")] = true,
    [GetHashKey("p_ambpack04x")] = false,
}

Config.BlacklistedAnimations = {
    ["amb_work@world_human_gravedig@working@male_b@idle_a"] = { "idle_a" },
    ["amb_work@world_human_farmer_weeding@male_a@idle_c"] = { "idle_g" },
    ["amb_work@world_human_gravedig@working@male_b@react_look@loop@generic"] = { "react_look_front_loop" }
}

