net.Receive("memesfryingpan_ragdoll", function(len)
    if len > 0 then
        LocalPlayer():SetNWBool("memesfryingpan_ragdolled",true)
        LocalPlayer():SetNWEntity("memesfryingpan_ragdoll",ragdoll)
    end
end)


net.Receive("memesfryingpan_unragdoll", function(len)
    if len > 0 then
        LocalPlayer():SetNWBool("memesfryingpan_ragdolled",not net.ReadBool())
    end
end)

net.Receive("memesfryingpan_updateragdollcolor",function(len)
    if len > 0 then
        local ragdoll = net.ReadEntity()
        local colorVector = net.ReadVector()
        ragdoll.GetPlayerColor = function() return colorVector end
    end
end)