-- =============================================
-- ModernNoir UI - Example.lua
-- Exemplo completo e bem organizado
-- =============================================

local ModernNoir = loadstring(game:HttpGet("https://raw.githubusercontent.com/solomigg0-debug/modernnoir-ui/refs/heads/main/ModernNoir.lua"))()

-- ================== CRIA A JANELA ==================
local Window = ModernNoir.CreateWindow({
    Title = "ModernNoir Example",
    ToggleKey = Enum.KeyCode.RightShift
})

-- ================== ABA PRINCIPAL ==================
local Main = Window:AddTab("Principal", 0)

Main:AddSection("Controles Básicos")

Main:AddButton("Botão Simples", function()
    ModernNoir:Notify("Botão", "Você clicou no botão simples!", 4, "success")
end)

Main:AddToggle("Ativar ESP", true, function(state)
    ModernNoir:Notify("ESP", "ESP " .. (state and "ativado" or "desativado"), 3, state and "success" or "warning")
end)

Main:AddSlider("Velocidade", 0, 200, 80, function(value)
    -- Aqui você colocaria sua lógica de velocidade
end)

Main:AddKeybind("Ativar Hack", Enum.KeyCode.F, function(key)
    ModernNoir:Notify("Keybind", "Tecla alterada para: " .. tostring(key), 3, "info")
end)

-- ================== ABA VISUAL ==================
local Visual = Window:AddTab("Visual", 0)

Visual:AddSection("Cores e Aparência")

Visual:AddColorPicker("Cor do ESP", Color3.fromHex("#D4AF37"), function(color)
    -- Aqui você aplicaria a cor no seu ESP
end)

Visual:AddColorPicker("Cor do Aimbot", Color3.fromHex("#FF0000"), function(color)
    -- Aqui você aplicaria a cor no aimbot
end)

Visual:AddSlider("Transparência ESP", 0, 100, 70, function(value)
    -- value de 0 a 100
end)

-- ================== ABA CONFIG ==================
local Config = Window:AddTab("Configurações", 0)

Config:AddSection("Opções Gerais")

Config:AddDropdown("Modo de Jogo", {"Legit", "Rage", "Blatant"}, "Legit", function(selected)
    ModernNoir:Notify("Modo", "Modo alterado para: " .. selected, 4, "info")
end)

Config:AddTextbox("Nome do Jogador", "Digite o nome...", "", function(text, enterPressed)
    if enterPressed then
        ModernNoir:Notify("Textbox", "Nome definido: " .. text, 3, "default")
    end
end)

Config:AddToggle("Anti-AFK", false, function(state)
    -- Lógica Anti-AFK aqui
end)

Config:AddToggle("Auto Farm", false, function(state)
    -- Lógica Auto Farm aqui
end)

-- ================== ABA CREDITS ==================
local Credits = Window:AddTab("Créditos", 0)

Credits:AddSection("Agradecimentos")

Credits:AddLabel("ModernNoir UI Library feita por solomigg0-debug")
Credits:AddLabel("Exemplo criado para demonstração")
Credits:AddLabel("Obrigado por usar!")

-- ================== NOTIFICAÇÃO INICIAL ==================
task.wait(1)
ModernNoir:Notify("ModernNoir", "Interface carregada com sucesso!\nExemplo pronto para uso.", 6, "success")

print("✅ ModernNoir Example carregado com sucesso!")
