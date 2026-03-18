local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP")
SFclient = Tunnel.getInterface("shirouz-safezone")

SFzone = {}
Proxy.addInterface("shirouz-safezone", SFzone)
Tunnel.bindInterface("shirouz-safezone", SFzone)

local RESOURCE_NAME = GetCurrentResourceName()
local CUSTOM_SAFEZONES_FILE = "safezones_custom.json"

local cachedZones = nil
local adminCooldowns = {}

-- Carrega safezones customizadas (com Cache p/ Performance)
local function loadCustomSafezones()
    if cachedZones then return cachedZones end
    
    local content = LoadResourceFile(RESOURCE_NAME, CUSTOM_SAFEZONES_FILE)
    if not content or content == "" then 
        cachedZones = {}
        return cachedZones 
    end
    
    local ok, tab = pcall(json.decode, content)
    if not ok or type(tab) ~= "table" then 
        cachedZones = {}
        return cachedZones 
    end
    
    cachedZones = tab
    return cachedZones
end

-- Salva safezones (Atualiza Cache e Arquivo)
local function saveCustomSafezones(fields)
    cachedZones = fields
    local content = json.encode(fields)
    if content then
        SaveResourceFile(RESOURCE_NAME, CUSTOM_SAFEZONES_FILE, content, #content)
    end
end

-- Proteção Anti-Spam (Segurança)
local function checkCooldown(user_id)
    local now = GetGameTimer()
    if not adminCooldowns[user_id] or now > adminCooldowns[user_id] then
        adminCooldowns[user_id] = now + 2000 -- 2 segundos de cooldown
        return true
    end
    return false
end

-- Comando Dinâmico: Inicia o setup visual no cliente
RegisterCommand(Config.Command, function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if not user_id or not vRP.hasPermission(user_id, Config.Permission) then
        TriggerClientEvent("Notify", source, "negado", "Sem permissão.", 5000)
        return
    end

    TriggerClientEvent("shirouz-safezone:startSetup", source)
end, false)

-- Evento final de criação: recebe todos os pontos e salva
RegisterNetEvent("shirouz-safezone:finishSetup")
AddEventHandler("shirouz-safezone:finishSetup", function(points, name)
    local src = source
    local user_id = vRP.getUserId(src)
    
    if not user_id or not vRP.hasPermission(user_id, Config.Permission) then return end
    if not checkCooldown(user_id) then return end
    if not points or #points < 3 then return end
    if not name or name == "" then name = "Nova Safezone" end

    local edges = {}
    for i, p in ipairs(points) do
        edges[#edges + 1] = { name = "pt_" .. i, x = p.x, y = p.y, z = p.z }
    end

    local custom = loadCustomSafezones()
    custom[#custom + 1] = { name = name, edges = edges }
    saveCustomSafezones(custom)
    
    TriggerClientEvent("Notify", src, "sucesso", "Safezone '" .. name .. "' criada!", 8000)
    TriggerClientEvent("shirouz-safezone:receiveCustomSafezones", -1, cachedZones)
    TriggerClientEvent("shirouz-safezone:sendZones", src, cachedZones)
end)

-- ─── Gerenciamento (NUI Callbacks via Client) ─────────────────────────────────

-- Envia lista de zonas para o NUI
RegisterNetEvent("shirouz-safezone:requestZones")
AddEventHandler("shirouz-safezone:requestZones", function()
    local src = source
    local user_id = vRP.getUserId(src)
    if not user_id or not vRP.hasPermission(user_id, Config.Permission) then return end
    
    TriggerClientEvent("shirouz-safezone:sendZones", src, loadCustomSafezones())
end)

-- Teleportar para zona
RegisterNetEvent("shirouz-safezone:teleportToZone")
AddEventHandler("shirouz-safezone:teleportToZone", function(index)
    local src = source
    local user_id = vRP.getUserId(src)
    if not user_id or not vRP.hasPermission(user_id, Config.Permission) or not Config.AllowTeleport then return end
    if not checkCooldown(user_id) then return end

    local zones = loadCustomSafezones()
    local zone = zones[index + 1]
    if zone and zone.edges[1] then
        vRPclient.teleport(src, zone.edges[1].x, zone.edges[1].y, zone.edges[1].z)
        TriggerClientEvent("Notify", src, "sucesso", "Teleportado para " .. zone.name)
    end
end)

-- Deletar zona
RegisterNetEvent("shirouz-safezone:deleteZone")
AddEventHandler("shirouz-safezone:deleteZone", function(index)
    local src = source
    local user_id = vRP.getUserId(src)
    if not user_id or not vRP.hasPermission(user_id, Config.Permission) or not Config.AllowDelete then return end
    if not checkCooldown(user_id) then return end

    local zones = loadCustomSafezones()
    local zoneName = zones[index + 1] and zones[index + 1].name or "Zona"
    table.remove(zones, index + 1)
    saveCustomSafezones(zones)
    
    TriggerClientEvent("Notify", src, "sucesso", "Safezone '" .. zoneName .. "' removida!")
    TriggerClientEvent("shirouz-safezone:receiveCustomSafezones", -1, cachedZones)
    TriggerClientEvent("shirouz-safezone:sendZones", src, cachedZones)
end)

-- Renomear zona
RegisterNetEvent("shirouz-safezone:renameZone")
AddEventHandler("shirouz-safezone:renameZone", function(index, newName)
    local src = source
    local user_id = vRP.getUserId(src)
    if not user_id or not vRP.hasPermission(user_id, Config.Permission) or not Config.AllowRename then return end
    if not checkCooldown(user_id) then return end

    local zones = loadCustomSafezones()
    if zones[index + 1] then
        local oldName = zones[index + 1].name
        zones[index + 1].name = newName
        saveCustomSafezones(zones)
        
        TriggerClientEvent("Notify", src, "sucesso", "Safezone '" .. oldName .. "' renomeada para '" .. newName .. "'")
        TriggerClientEvent("shirouz-safezone:receiveCustomSafezones", -1, cachedZones)
        TriggerClientEvent("shirouz-safezone:sendZones", src, cachedZones)
    end
end)

-- Cliente pede as safezones customizadas (ao conectar)
RegisterNetEvent("shirouz-safezone:requestCustomSafezones")
AddEventHandler("shirouz-safezone:requestCustomSafezones", function()
    local src = source
    TriggerClientEvent("shirouz-safezone:receiveCustomSafezones", src, loadCustomSafezones())
end)

-- Inicializa Cache no Start
loadCustomSafezones()
print('^2[' .. RESOURCE_NAME .. '] ^7Otimizado e Iniciado.')
