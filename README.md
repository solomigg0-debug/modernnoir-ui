ModernNoir UI Library
Uma interface dark/noir premium com acento dourado, animações suaves e totalmente otimizada para executores Roblox.
Recursos

Design moderno estilo Noir com acento dourado
Animações fluidas (Quart + Back easing)
Sidebar com busca integrada
Drag suave com limite automático de tela
Botão de minimizar
Keybinds com suporte total a mouse (M1, M2, M3)
Color Picker completo (SV + Hue + Hex input)
Notificações com barra de progresso e ícones
Totalmente otimizada (weak tables, limpeza automática de conexões, sem memory leaks)
Compatível com gethui, CoreGui e PlayerGui

Instalação
local ModernNoir = loadstring(game:HttpGet("https://raw.githubusercontent.com/solomigg0-debug/modernnoir-ui/refs/heads/main/ModernNoir.lua"))()
Criando a Janela
local Window = ModernNoir.CreateWindow({
Title = "Nome do Seu Hub",
ToggleKey = Enum.KeyCode.RightShift   -- tecla para abrir/fechar (opcional)
})
-- Ou versão simples:
-- local Window = ModernNoir.CreateWindow("Nome do Seu Hub")
Métodos da Janela
Window:SetTitle("Novo Título")
Window:SetVisible(true/false)
Window:Destroy()
Window:AddTab("Nome da Aba", iconID)   -- iconID = 0 ou nil para sem ícone
Criando Abas
local Tab = Window:AddTab("Principal", 0)
Widgets (Elementos)
Button
Tab:AddButton("Texto do Botão", function()
-- código executado ao clicar
end)
Toggle
Tab:AddToggle("Nome do Toggle", false, function(state)
-- state = true ou false
end)
-- O objeto retornado tem: :GetState() e :SetState(novoEstado, silent)
Slider
Tab:AddSlider("Nome", min, max, default, function(value)
-- value = número atual
end)
-- O objeto retornado tem: :GetValue() e :SetValue(novoValor, silent)
Section
Tab:AddSection("Título da Seção")
Separator
Tab:AddSeparator()
Label
local Label = Tab:AddLabel("Texto aqui")
Label:SetText("Novo texto")
Label:SetColor(Color3.fromRGB(255, 100, 100))
Textbox
Tab:AddTextbox("Label", "Placeholder", "Valor inicial", function(text, enterPressed)
-- text = conteúdo
-- enterPressed = true se apertou Enter
end)
-- O objeto retornado tem: :GetText() e :SetText(novoTexto)
Dropdown
Tab:AddDropdown("Label", {"Opção1", "Opção2", "Opção3"}, "Opção1", function(selected)
-- selected = item escolhido
end)
-- O objeto retornado tem:
-- :GetSelected()
-- :SetSelected(novoItem, silent)
-- :SetOptions(novaTabela, novoDefault)
Keybind
Tab:AddKeybind("Label", Enum.KeyCode.F, function(key)
-- key = nova tecla (KeyCode ou UserInputType)
end)
-- O objeto retornado tem: :GetKey() e :SetKey(novaTecla, silent)
ProgressBar
local Progress = Tab:AddProgressBar("Nome", 0.65)
Progress:SetValue(0.85, true)   -- true = animação
ColorPicker
Tab:AddColorPicker("Cor do ESP", Color3.fromHex("#D4AF37"), function(color)
-- color = Color3 nova
end)
-- O objeto retornado tem: :GetColor() e :SetColor(novaCor, silent)
Notificações
ModernNoir:Notify("Título", "Mensagem", tempo_em_segundos, tipo)
Tipos disponíveis:
success, error, warning, info, default
Exemplos:
ModernNoir:Notify("Sucesso", "Hub carregado corretamente!", 5, "success")
ModernNoir:Notify("Erro", "Algo deu errado...", 4, "error")
Mudar Tema (Avançado)
ModernNoir:SetTheme({
Accent = Color3.fromHex("#FF00FF"),
Background = Color3.fromHex("#0F0F0F"),
-- pode mudar qualquer cor que existe no Theme da library
})
Exemplo Completo
local ModernNoir = loadstring(game:HttpGet("https://raw.githubusercontent.com/solomigg0-debug/modernnoir-ui/refs/heads/main/ModernNoir.lua"))()
local Window = ModernNoir.CreateWindow("Meu Hub Premium")
local Main = Window:AddTab("Principal")
Main:AddSection("Controles Básicos")
Main:AddToggle("Ativar ESP", true, function(v) ... end)
Main:AddSlider("Distância", 0, 500, 100, function(v) ... end)
Main:AddButton("Executar Ação", function() ... end)
ModernNoir:Notify("ModernNoir", "Interface carregada com sucesso!", 6, "success")
Créditos
ModernNoir UI Library criada por solomigg0-debug
Repositório oficial: https://github.com/solomigg0-debug/modernnoir-ui
Feito com ❤️ para a comunidade Roblox.
