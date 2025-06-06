local uiOpen = false

print("^2[PROP MANAGER]^7 client.lua Loading completed")

RegisterCommand("propmenu", function()
    print("[PROP MANAGER] พิมพ์ /propmenu แล้ว")
    if not uiOpen then
        openPropUI()
    else
        closePropUI()
    end
end)

function openPropUI()
    print("[PROP MANAGER] Open UI now")
    SetNuiFocus(true, true)
    SendNUIMessage({ type = "open" })
    uiOpen = true
end

function closePropUI()
    print("[PROP MANAGER] Close the UI.")
    SetNuiFocus(false, false)
    SendNUIMessage({ type = "close" })
    uiOpen = false
end

RegisterNUICallback("closeUI", function(_, cb)
    closePropUI()
    cb("ok")
end)

RegisterNUICallback("deleteProp", function(_, cb)
    print("[PROP MANAGER] Receive command to delete prop")
    deletePlayerProps()
    cb("ok")
end)

function deletePlayerProps()
    local playerPed = PlayerPedId()
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
        SetEntityAsMissionEntity(object, true, true)
        DeleteObject(object)
        print("[PROP MANAGER] Remove allowed props")
    end

    if #attachedEntities == 0 then
        print("[PROP MANAGER] There is no prop that allows deletion.")
    end
end

function EnumerateObjects()
    return coroutine.wrap(function()
        local handle, object = FindFirstObject()
        if not handle or handle == -1 then return end

        local success
        repeat
            coroutine.yield(object)
            success, object = FindNextObject(handle)
        until not success

        EndFindObject(handle)
    end)
end
