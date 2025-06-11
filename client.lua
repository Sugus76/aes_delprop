local uiOpen = false
local DEBUG = true -- เปลี่ยนเป็น true หากต้องการดูข้อความ log

local function log(msg)
    if DEBUG then
        print(msg)
    end
end

log("^5[PROP MANAGER]^2 client.lua Loading completed")

RegisterCommand("propmenu", function()
    log("^5[PROP MANAGER]^2 Type /propmenu to open the menu.")
    if not uiOpen then
        openPropUI()
    else
        closePropUI()
    end
end)

function openPropUI()
    log("^5[PROP MANAGER]^2 Open UI now")
    SetNuiFocus(true, true)
    SendNUIMessage({ type = "open" })
    uiOpen = true
end

function closePropUI()
    log("^5[PROP MANAGER]^9 Close the UI.")
    SetNuiFocus(false, false)
    SendNUIMessage({ type = "close" })
    uiOpen = false
end

RegisterNUICallback("closeUI", function(_, cb)
    closePropUI()
    cb("ok")
end)

RegisterNUICallback("deleteProp", function(_, cb)
    log("^5[PROP MANAGER]^2 Receive command to delete prop")
    deletePlayerProps()
    cb("ok")
end)

function deletePlayerProps()
    local playerPed = PlayerPedId()
    if not DoesEntityExist(playerPed) then return end
    for animDict, animList in pairs(Config.BlacklistedAnimations) do
        for _, animName in ipairs(animList) do
            if IsEntityPlayingAnim(playerPed, animDict, animName, 3) then
                log("^1[PROP MANAGER]^1 Animation is blacklisted")
                TriggerEvent("chat:addMessage", {
                    color = {255, 0, 0},
                    args = {"[PROP MANAGER]", "Cannot delete prop while using suspended pose!"}
                })
                return
            end
        end
    end
    local hasAttachedProp = false
    for object in EnumerateObjects() do
        if IsEntityAttachedToEntity(object, playerPed) then
            hasAttachedProp = true
            break
        end
    end

    if not hasAttachedProp then
        log("^5[PROP MANAGER]^3 No attached props to check.")
        return
    end
    local attachedEntities = {}
    for object in EnumerateObjects() do
        if DoesEntityExist(object) and IsEntityAttachedToEntity(object, playerPed) then
            local model = GetEntityModel(object)
            if Config.AllowedProps[model] then
                table.insert(attachedEntities, object)
            end
        end
    end

    for _, object in ipairs(attachedEntities) do
        local model = GetEntityModel(object)
        log(string.format("^5[PROP MANAGER]^2 Removed allowed prop with model hash: %d", model))
        SetEntityAsMissionEntity(object, true, true)
        DeleteObject(object)
    end

    if #attachedEntities == 0 then
        log("^5[PROP MANAGER]^3 There is no prop that allows deletion.")
    end
end

function EnumerateObjects()
    return coroutine.wrap(function()
        local handle, object = FindFirstObject()
        if not handle or handle == -1 or not object or object == 0 then return end

        local success
        repeat
            coroutine.yield(object)
            success, object = FindNextObject(handle)
        until not success

        EndFindObject(handle)
    end)
end
