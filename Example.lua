local ModernNoir = loadstring(game:HttpGet("https://raw.githubusercontent.com/solomigg0-debug/modernnoir-ui/refs/heads/main/ModernNoir.lua"))()

local Window = ModernNoir.CreateWindow({
    Title = "ModernNoir Example",
    ToggleKey = Enum.KeyCode.RightShift
})

local Main = Window:AddTab("Principal", 0)

Main:AddSection("Controles Básicos")

Main:AddButton("Botão Simples", function()
    ModernNoir:Notify("Botão", "Você clicou no botão simples!", 4, "success")
end)

local espEnabled = true
local espToggle = Main:AddToggle("Ativar ESP", espEnabled, function(state)
    espEnabled = state
    ModernNoir:Notify("ESP", "ESP " .. (state and "ativado" or "desativado"), 3, state and "success" or "warning")
end)
espToggle:SetState(false, true)

local speed = 80
Main:AddSlider("Velocidade", 0, 200, speed, function(value)
    speed = value
end)

local hackActive = false
Main:AddKeybind("Ativar Hack", Enum.KeyCode.F, function()
    hackActive = not hackActive
    ModernNoir:Notify("Hack", hackActive and "Ativado" or "Desativado", 3, hackActive and "success" or "warning")
end)

local Visual = Window:AddTab("Visual", 0)

Visual:AddSection("Cores e Aparência")

local espColor = Color3.fromHex("#D4AF37")
Visual:AddColorPicker("Cor do ESP", espColor, function(color)
    espColor = color
end)

local aimbotColor = Color3.fromHex("#FF0000")
Visual:AddColorPicker("Cor do Aimbot", aimbotColor, function(color)
    aimbotColor = color
end)

local espTransparency = 70
Visual:AddSlider("Transparência ESP", 0, 100, espTransparency, function(value)
    espTransparency = value
end)

local Config = Window:AddTab("Configurações", 0)

Config:AddSection("Opções Gerais")

local mode = "Legit"
Config:AddDropdown("Modo de Jogo", {"Legit", "Rage", "Blatant"}, mode, function(selected)
    mode = selected
    ModernNoir:Notify("Modo", "Modo alterado para: " .. selected, 4, "info")
end)

local playerName = ""
Config:AddTextbox("Nome do Jogador", "Digite o nome...", playerName, function(text, enterPressed)
    playerName = text
    if enterPressed then
        ModernNoir:Notify("Textbox", "Nome definido: " .. text, 3, "default")
    end
end)

local antiAfk = false
Config:AddToggle("Anti-AFK", antiAfk, function(state)
    antiAfk = state
end)

local autoFarm = false
Config:AddToggle("Auto Farm", autoFarm, function(state)
    autoFarm = state
end)

local Credits = Window:AddTab("Créditos", 0)

Credits:AddSection("Agradecimentos")

Credits:AddLabel("ModernNoir UI Library feita por solomigg0-debug")
Credits:AddLabel("Exemplo criado para demonstração")
Credits:AddLabel("Obrigado por usar!")

ModernNoir:Notify("ModernNoir", "Interface carregada com sucesso!\nExemplo pronto para uso.", 6, "success")

print("ModernNoir Example carregado com sucesso!")
