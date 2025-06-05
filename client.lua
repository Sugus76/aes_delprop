local uiOpen = false

print("^2[PROP MANAGER]^7 client.lua โหลดแล้ว")

RegisterCommand("propmenu", function()
    print("[PROP MANAGER] พิมพ์ /propmenu แล้ว")
    if not uiOpen then
        openPropUI()
    else
        closePropUI()
    end
end)

function openPropUI()
    print("[PROP MANAGER] เปิด UI แล้ว")
    SetNuiFocus(true, true)
    SendNUIMessage({ type = "open" })
    uiOpen = true
end

function closePropUI()
    print("[PROP MANAGER] ปิด UI แล้ว")
    SetNuiFocus(false, false)
    SendNUIMessage({ type = "close" })
    uiOpen = false
end

RegisterNUICallback("closeUI", function(_, cb)
    closePropUI()
    cb("ok")
end)

RegisterNUICallback("deleteProp", function(_, cb)
    print("[PROP MANAGER] รับคำสั่งลบ prop")
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
        print("[PROP MANAGER] ลบ prop ที่อนุญาตแล้ว")
    end

    if #attachedEntities == 0 then
        print("[PROP MANAGER] ไม่มี prop ที่อนุญาตให้ลบ")
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
