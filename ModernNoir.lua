-- ════════════════════════════════════════════════
--  ModernNoir UI Library v0.3.1
--  Compatível com executores Roblox (gethui/CoreGui/PlayerGui)
--  Otimizado para baixo uso de memória e sem memory leaks
-- ════════════════════════════════════════════════

-- ────────────────────────────────────────────────
--  SERVIÇOS
-- ────────────────────────────────────────────────
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Seleciona o container de GUI compatível com executores
local function getContainer()
    if gethui then return gethui() end
    local ok, cg = pcall(game.GetService, game, "CoreGui")
    if ok and cg then return cg end
    return LocalPlayer:WaitForChild("PlayerGui", 10) or error("ModernNoir: container not found")
end
local GuiParent = getContainer()

-- ────────────────────────────────────────────────
--  PALETA DE CORES
-- ────────────────────────────────────────────────
local Theme = {
    Background     = Color3.fromHex("#1A1C1E"),
    Surface        = Color3.fromHex("#22252A"),
    SurfaceAlt     = Color3.fromHex("#2A2E33"),
    SurfaceHover   = Color3.fromHex("#2E323A"),
    Border         = Color3.fromHex("#32363A"),
    Accent         = Color3.fromHex("#D4AF37"),
    AccentDim      = Color3.fromHex("#9E8229"),
    AccentGlow     = Color3.fromHex("#F0CE5E"),
    TextPrimary    = Color3.fromHex("#E8E6E1"),
    TextSecondary  = Color3.fromHex("#9A9590"),
    TextDisabled   = Color3.fromHex("#555555"),
    CloseRed       = Color3.fromHex("#C0392B"),
    CloseRedHover  = Color3.fromHex("#E74C3C"),
    ScrollBar      = Color3.fromHex("#3E4248"),
    ScrollBarHover = Color3.fromHex("#D4AF37"),
    WidgetBg       = Color3.fromHex("#212427"),
    WidgetBgHover  = Color3.fromHex("#272B2F"),
    WidgetBgPress  = Color3.fromHex("#1C1F22"),
    ToggleOffTrack = Color3.fromHex("#252930"),
    ToggleKnob     = Color3.fromHex("#D0CEC9"),
    ToggleKnobOn   = Color3.fromHex("#FFFFFF"),
    SliderTrack    = Color3.fromHex("#252930"),
    SliderKnob     = Color3.fromHex("#F0CE5E"),
    NotifyBg       = Color3.fromHex("#1E2124"),
    NotifyBarBg    = Color3.fromHex("#2A2E33"),
    NotifySuccess  = Color3.fromHex("#27AE60"),
    NotifyError    = Color3.fromHex("#C0392B"),
    NotifyWarning  = Color3.fromHex("#E67E22"),
    NotifyInfo     = Color3.fromHex("#2980B9"),
    SectionLine    = Color3.fromHex("#2A2E33"),
    SectionText    = Color3.fromHex("#6B6560"),
    InputBg        = Color3.fromHex("#191C1F"),
    InputBorder    = Color3.fromHex("#32363A"),
    InputText      = Color3.fromHex("#E8E6E1"),
    DropdownArrow  = Color3.fromHex("#9A9590"),
    KeybindBg      = Color3.fromHex("#191C1F"),
    KeybindBorder  = Color3.fromHex("#32363A"),
    KeybindActive  = Color3.fromHex("#D4AF37"),
    ProgressTrack  = Color3.fromHex("#252930"),
    ProgressFill   = Color3.fromHex("#D4AF37"),
    PickerBg       = Color3.fromHex("#191C1F"),
    PickerBorder   = Color3.fromHex("#32363A"),
    SearchBg       = Color3.fromHex("#191C1F"),
    SearchBorder   = Color3.fromHex("#2A2E33"),
}

-- ────────────────────────────────────────────────
--  CONFIGURAÇÕES DE LAYOUT E ANIMAÇÃO
-- ────────────────────────────────────────────────
local Config = {
    WindowWidth   = 620,
    WindowHeight  = 420,
    HeaderHeight  = 38,
    SidebarWidth  = 140,
    Corner        = UDim.new(0, 8),
    BorderW       = 1.5,
    DragSmooth    = 0.12,
    MinimizeH     = 38,

    TweenFast   = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    TweenMedium = TweenInfo.new(0.30, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),

    TabH          = 34,
    TabIndW       = 2,
    TabIndActive  = 3,
    TabFadeT      = 0.20,
    TabIndT       = 0.22,
    ScrollBarW    = 3,

    WidgetH       = 36,
    WidgetCorner  = UDim.new(0, 8),
    WidgetBorderW = 1,
    PressScale    = 0.97,
    PressT        = 0.10,
    ReleaseT      = 0.20,
    WidgetGap     = 6,

    ToggleW       = 38,
    ToggleH       = 20,
    KnobSize      = 14,
    KnobPad       = 3,
    ToggleMoveT   = TweenInfo.new(0.20, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    ToggleColorT  = TweenInfo.new(0.20, Enum.EasingStyle.Quad,  Enum.EasingDirection.InOut),

    SliderH       = 52,
    SliderTrackH  = 6,
    SliderKnobS   = 16,

    NotifyW       = 300,
    NotifyH       = 72,
    NotifyPadR    = 16,
    NotifyPadB    = 16,
    NotifyGap     = 8,
    NotifyBarH    = 3,
    NotifySlideT  = 0.30,
    NotifyFadeT   = 0.22,
    NotifyDur     = 4,

    SectionH      = 28,
    SeparatorH    = 18,
    LabelH        = 28,
    TextboxH      = 36,
    DropdownH     = 36,
    DropdownItemH = 30,
    DropdownMaxH  = 150,
    KeybindH      = 36,
    KeybindW      = 80,

    ProgressH     = 44,
    ProgressBarH  = 6,

    -- ColorPicker: svSize é calculado em runtime, mas guardamos o painel base
    ColorPickerH  = 36,
    ColorPanelW   = 180,
    -- svSize = ColorPanelW - 16 (padding) - 20 (hue slider) = 144
    ColorSVSize   = 144,
    ColorHueW     = 14,
    ColorHueGap   = 6,

    SearchH       = 28,
}

-- ────────────────────────────────────────────────
--  UTILITÁRIOS
-- ────────────────────────────────────────────────
local Util = {}

-- Weak table para não segurar referências de objetos destruídos
-- Chave = instância (weak), valor = tween ativo
local _tweenCache = setmetatable({}, {__mode = "k"})

-- Cancela tween anterior do mesmo objeto e inicia novo
function Util.Tween(obj, info, props)
    local prev = _tweenCache[obj]
    if prev then prev:Cancel() end
    local t = TweenService:Create(obj, info, props)
    _tweenCache[obj] = t
    t:Play()
    return t
end

function Util.Clamp(v, lo, hi)
    return math.max(lo, math.min(hi, v))
end

-- Adiciona UICorner à instância
function Util.Corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = r or Config.Corner
    c.Parent = obj
    return c
end

-- Adiciona UIStroke à instância
function Util.Stroke(obj, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color           = color     or Theme.Border
    s.Thickness       = thickness or Config.BorderW
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = obj
    return s
end

-- Conversões HSV ↔ Color3 ↔ Hex
function Util.HSVtoColor3(h, s, v) return Color3.fromHSV(h, s, v) end
function Util.Color3toHSV(color)   return Color3.toHSV(color) end
function Util.Color3toHex(color)
    return string.format("%02X%02X%02X",
        math.floor(color.R * 255 + 0.5),
        math.floor(color.G * 255 + 0.5),
        math.floor(color.B * 255 + 0.5))
end

-- Cria botão circular no header (close/minimize)
function Util.HeaderButton(parent, pos, colNorm, colHover, sym)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,14,0,14); btn.Position = pos
    btn.AnchorPoint = Vector2.new(0, 0.5)
    btn.BackgroundColor3 = colNorm; btn.BorderSizePixel = 0
    btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 10
    btn.Parent = parent
    Util.Corner(btn, UDim.new(1,0))

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1
    lbl.Text = sym; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 8
    lbl.TextColor3 = Color3.fromHex("#1A1C1E"); lbl.TextTransparency = 1
    lbl.ZIndex = 11; lbl.Parent = btn

    btn.MouseEnter:Connect(function()
        Util.Tween(btn, Config.TweenFast, {BackgroundColor3 = colHover})
        Util.Tween(lbl, Config.TweenFast, {TextTransparency = 0})
    end)
    btn.MouseLeave:Connect(function()
        Util.Tween(btn, Config.TweenFast, {BackgroundColor3 = colNorm})
        Util.Tween(lbl, Config.TweenFast, {TextTransparency = 1})
    end)
    return btn
end

-- Helper: cria frame base de widget com corner e stroke
function Util.WidgetBase(parent, order, h)
    local wrap = Instance.new("Frame")
    wrap.Size = UDim2.new(1,0,0, h or Config.WidgetH)
    wrap.BackgroundTransparency = 1; wrap.BorderSizePixel = 0
    wrap.LayoutOrder = order; wrap.Parent = parent

    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,1,0)
    f.BackgroundColor3 = Theme.WidgetBg; f.BorderSizePixel = 0
    f.Parent = wrap
    Util.Corner(f, Config.WidgetCorner)
    local stroke = Util.Stroke(f, Theme.Border, Config.WidgetBorderW)

    return wrap, f, stroke
end

-- Helper: adiciona hover simples em frame com stroke
function Util.HoverEffect(hit, f, stroke, strokeHover, strokeNorm)
    strokeHover = strokeHover or Theme.Accent
    strokeNorm  = strokeNorm  or Theme.Border
    hit.MouseEnter:Connect(function()
        Util.Tween(f,      Config.TweenFast, {BackgroundColor3 = Theme.WidgetBgHover})
        Util.Tween(stroke, Config.TweenFast, {Color = strokeHover})
    end)
    hit.MouseLeave:Connect(function()
        Util.Tween(f,      Config.TweenFast, {BackgroundColor3 = Theme.WidgetBg})
        Util.Tween(stroke, Config.TweenFast, {Color = strokeNorm})
    end)
end

-- Desconecta lista de RBXScriptConnections com segurança
function Util.DisconnectAll(list)
    for _, c in ipairs(list) do
        if typeof(c) == "RBXScriptConnection" and c.Connected then
            c:Disconnect()
        end
    end
    table.clear(list)
end

-- ════════════════════════════════════════════════
--  WIDGETS
-- ════════════════════════════════════════════════
local Widgets = {}

-- ────────────────────────────────────────────────
--  BUTTON
-- ────────────────────────────────────────────────
function Widgets.Button(scroll, text, order, cb)
    local wrap, f, stroke = Util.WidgetBase(scroll, order)

    local scale = Instance.new("UIScale"); scale.Scale = 1; scale.Parent = f

    local ico = Instance.new("TextLabel")
    ico.Size = UDim2.new(0,28,1,0); ico.Position = UDim2.new(0,8,0,0)
    ico.BackgroundTransparency = 1; ico.Text = "◆"
    ico.Font = Enum.Font.GothamBold; ico.TextSize = 8
    ico.TextColor3 = Theme.AccentDim; ico.ZIndex = 2; ico.Parent = f

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-42,1,0); lbl.Position = UDim2.new(0,32,0,0)
    lbl.BackgroundTransparency = 1; lbl.Text = text
    lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 12
    lbl.TextColor3 = Theme.TextPrimary
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 2; lbl.Parent = f

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0,20,1,0); arrow.Position = UDim2.new(1,-24,0,0)
    arrow.BackgroundTransparency = 1; arrow.Text = "›"
    arrow.Font = Enum.Font.GothamBold; arrow.TextSize = 16
    arrow.TextColor3 = Theme.TextDisabled; arrow.TextTransparency = 0.4
    arrow.ZIndex = 2; arrow.Parent = f

    local hit = Instance.new("TextButton")
    hit.Size = UDim2.new(1,0,1,0); hit.BackgroundTransparency = 1
    hit.Text = ""; hit.ZIndex = 5; hit.AutoButtonColor = false; hit.Parent = f

    local tPress   = TweenInfo.new(Config.PressT,   Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tRelease = TweenInfo.new(Config.ReleaseT,  Enum.EasingStyle.Back,  Enum.EasingDirection.Out)
    local hovered  = false

    hit.MouseEnter:Connect(function()
        hovered = true
        Util.Tween(f,      Config.TweenFast, {BackgroundColor3 = Theme.WidgetBgHover})
        Util.Tween(stroke, Config.TweenFast, {Color = Theme.Accent, Thickness = 1.5})
        Util.Tween(ico,    Config.TweenFast, {TextColor3 = Theme.Accent})
        Util.Tween(lbl,    Config.TweenFast, {TextColor3 = Theme.AccentGlow})
        Util.Tween(arrow,  Config.TweenFast, {TextColor3 = Theme.AccentGlow, TextTransparency = 0})
    end)
    hit.MouseLeave:Connect(function()
        hovered = false
        Util.Tween(f,      Config.TweenFast, {BackgroundColor3 = Theme.WidgetBg})
        Util.Tween(stroke, Config.TweenFast, {Color = Theme.Border, Thickness = Config.WidgetBorderW})
        Util.Tween(ico,    Config.TweenFast, {TextColor3 = Theme.AccentDim})
        Util.Tween(lbl,    Config.TweenFast, {TextColor3 = Theme.TextPrimary})
        Util.Tween(arrow,  Config.TweenFast, {TextColor3 = Theme.TextDisabled, TextTransparency = 0.4})
    end)
    hit.MouseButton1Down:Connect(function()
        Util.Tween(scale,  tPress, {Scale = Config.PressScale})
        Util.Tween(f,      tPress, {BackgroundColor3 = Theme.WidgetBgPress})
        Util.Tween(stroke, tPress, {Color = Theme.AccentDim})
    end)
    hit.MouseButton1Up:Connect(function()
        Util.Tween(scale,  tRelease, {Scale = 1})
        Util.Tween(f,      tRelease, {BackgroundColor3 = hovered and Theme.WidgetBgHover or Theme.WidgetBg})
        Util.Tween(stroke, tRelease, {Color = hovered and Theme.Accent or Theme.Border})
    end)
    hit.MouseButton1Click:Connect(function()
        task.delay(Config.ReleaseT * 0.5, function()
            if cb then pcall(cb) end
        end)
    end)

    local obj = {}
    function obj:SetText(t) lbl.Text = t end
    function obj:SetEnabled(e)
        hit.Active = e
        Util.Tween(lbl,    Config.TweenFast, {TextColor3 = e and Theme.TextPrimary or Theme.TextDisabled})
        Util.Tween(stroke, Config.TweenFast, {Color = e and Theme.Border or Theme.TextDisabled})
    end
    return obj
end

-- ────────────────────────────────────────────────
--  TOGGLE
-- ────────────────────────────────────────────────
function Widgets.Toggle(scroll, text, default, order, cb)
    local state = (default == true)

    local wrap, f, _ = Util.WidgetBase(scroll, order)

    local sico = Instance.new("TextLabel")
    sico.Size = UDim2.new(0,16,1,0); sico.Position = UDim2.new(0,10,0,0)
    sico.BackgroundTransparency = 1
    sico.Text = state and "●" or "○"
    sico.Font = Enum.Font.GothamBold; sico.TextSize = 9
    sico.TextColor3 = state and Theme.Accent or Theme.TextDisabled
    sico.ZIndex = 2; sico.Parent = f

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-(Config.ToggleW + 36), 1, 0)
    lbl.Position = UDim2.new(0,30,0,0)
    lbl.BackgroundTransparency = 1; lbl.Text = text
    lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 12
    lbl.TextColor3 = Theme.TextPrimary
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 2; lbl.Parent = f

    local tW = Config.ToggleW
    local tH = Config.ToggleH

    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, tW, 0, tH)
    track.Position = UDim2.new(1, -(tW + 10), 0.5, -tH / 2)
    track.BackgroundColor3 = state and Theme.Accent or Theme.ToggleOffTrack
    track.BorderSizePixel = 0; track.ZIndex = 3; track.Parent = f
    Util.Corner(track, UDim.new(1,0))
    local trackStroke = Util.Stroke(track, Theme.Accent, Config.WidgetBorderW)
    trackStroke.Transparency = state and 0 or 1

    local kS   = Config.KnobSize
    local kPad = Config.KnobPad
    local knobOffX = kPad
    local knobOnX  = tW - kS - kPad

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, kS, 0, kS)
    knob.Position = UDim2.new(0, state and knobOnX or knobOffX, 0.5, -kS / 2)
    knob.BackgroundColor3 = state and Theme.ToggleKnobOn or Theme.ToggleKnob
    knob.BorderSizePixel = 0; knob.ZIndex = 5; knob.Parent = track
    Util.Corner(knob, UDim.new(1,0))

    local function applyState(s, animate)
        local tMove  = animate and Config.ToggleMoveT  or TweenInfo.new(0)
        local tColor = animate and Config.ToggleColorT or TweenInfo.new(0)
        if s then
            Util.Tween(track,       tColor, {BackgroundColor3 = Theme.Accent})
            Util.Tween(trackStroke, tColor, {Transparency = 0})
            Util.Tween(knob, tMove, {Position = UDim2.new(0, knobOnX, 0.5, -kS/2), BackgroundColor3 = Theme.ToggleKnobOn})
            Util.Tween(sico, tColor, {TextColor3 = Theme.Accent})
            sico.Text = "●"
        else
            Util.Tween(track,       tColor, {BackgroundColor3 = Theme.ToggleOffTrack})
            Util.Tween(trackStroke, tColor, {Transparency = 1})
            Util.Tween(knob, tMove, {Position = UDim2.new(0, knobOffX, 0.5, -kS/2), BackgroundColor3 = Theme.ToggleKnob})
            Util.Tween(sico, tColor, {TextColor3 = Theme.TextDisabled})
            sico.Text = "○"
        end
    end
    applyState(state, false)

    local hit = Instance.new("TextButton")
    hit.Size = UDim2.new(1,0,1,0); hit.BackgroundTransparency = 1
    hit.Text = ""; hit.ZIndex = 6; hit.AutoButtonColor = false; hit.Parent = f

    hit.MouseEnter:Connect(function()
        Util.Tween(f, Config.TweenFast, {BackgroundColor3 = Theme.WidgetBgHover})
    end)
    hit.MouseLeave:Connect(function()
        Util.Tween(f, Config.TweenFast, {BackgroundColor3 = Theme.WidgetBg})
    end)
    hit.MouseButton1Click:Connect(function()
        state = not state
        applyState(state, true)
        if cb then pcall(cb, state) end
    end)

    local obj = {}
    function obj:GetState() return state end
    function obj:SetState(s, silent)
        state = s; applyState(state, true)
        if not silent and cb then pcall(cb, state) end
    end
    function obj:SetText(t) lbl.Text = t end
    return obj
end

-- ────────────────────────────────────────────────
--  SLIDER
-- ────────────────────────────────────────────────
function Widgets.Slider(scroll, text, minV, maxV, default, order, cb)
    minV    = minV or 0
    maxV    = maxV or 100
    default = Util.Clamp(default or minV, minV, maxV)

    -- BUG FIX: força inteiro se AMBOS min e max forem inteiros
    local isInt = (math.floor(minV) == minV) and (math.floor(maxV) == maxV)
    if isInt then default = math.round(default) end

    local value = default

    local wrap, f, _ = Util.WidgetBase(scroll, order, Config.SliderH)

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft   = UDim.new(0,10); pad.PaddingRight  = UDim.new(0,10)
    pad.PaddingTop    = UDim.new(0,7);  pad.PaddingBottom = UDim.new(0,7)
    pad.Parent = f

    local topRow = Instance.new("Frame")
    topRow.Size = UDim2.new(1,0,0,16)
    topRow.BackgroundTransparency = 1; topRow.BorderSizePixel = 0
    topRow.Parent = f

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1,-50,1,0)
    nameLbl.BackgroundTransparency = 1; nameLbl.Text = text
    nameLbl.Font = Enum.Font.GothamSemibold; nameLbl.TextSize = 12
    nameLbl.TextColor3 = Theme.TextPrimary
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 2; nameLbl.Parent = topRow

    local badge = Instance.new("Frame")
    badge.Size = UDim2.new(0,44,1,0); badge.Position = UDim2.new(1,-44,0,0)
    badge.BackgroundColor3 = Theme.Surface; badge.BorderSizePixel = 0
    badge.ZIndex = 2; badge.Parent = topRow
    Util.Corner(badge, UDim.new(0,4))
    Util.Stroke(badge, Theme.Border, 1)

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(1,0,1,0); valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(isInt and math.round(value) or value)
    valLbl.Font = Enum.Font.GothamBold; valLbl.TextSize = 11
    valLbl.TextColor3 = Theme.Accent
    valLbl.TextXAlignment = Enum.TextXAlignment.Center
    valLbl.ZIndex = 3; valLbl.Parent = badge

    local tH = Config.SliderTrackH

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1,0,0,tH)
    track.Position = UDim2.new(0,0,0,20)
    track.BackgroundColor3 = Theme.SliderTrack
    track.BorderSizePixel = 0; track.ZIndex = 2; track.Parent = f
    Util.Corner(track, UDim.new(1,0))

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0,0,1,0)
    fill.BackgroundColor3 = Theme.Accent
    fill.BorderSizePixel = 0; fill.ZIndex = 3; fill.Parent = track
    Util.Corner(fill, UDim.new(1,0))

    local kS = Config.SliderKnobS

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, kS, 0, kS)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(0,0,0.5,0)
    knob.BackgroundColor3 = Theme.SliderKnob
    knob.BorderSizePixel = 0; knob.ZIndex = 5; knob.Parent = track
    Util.Corner(knob, UDim.new(1,0))
    local knobStroke = Util.Stroke(knob, Theme.Accent, 1.5)

    local minLbl = Instance.new("TextLabel")
    minLbl.Size = UDim2.new(0,30,0,10)
    minLbl.Position = UDim2.new(0,0,0,26)
    minLbl.BackgroundTransparency = 1; minLbl.Text = tostring(minV)
    minLbl.Font = Enum.Font.Gotham; minLbl.TextSize = 9
    minLbl.TextColor3 = Theme.TextDisabled
    minLbl.TextXAlignment = Enum.TextXAlignment.Left
    minLbl.ZIndex = 2; minLbl.Parent = f

    local maxLbl = Instance.new("TextLabel")
    maxLbl.Size = UDim2.new(0,30,0,10)
    maxLbl.Position = UDim2.new(1,-30,0,26)
    maxLbl.BackgroundTransparency = 1; maxLbl.Text = tostring(maxV)
    maxLbl.Font = Enum.Font.Gotham; maxLbl.TextSize = 9
    maxLbl.TextColor3 = Theme.TextDisabled
    maxLbl.TextXAlignment = Enum.TextXAlignment.Right
    maxLbl.ZIndex = 2; maxLbl.Parent = f

    local function applyValue(v)
        value = Util.Clamp(v, minV, maxV)
        if isInt then value = math.round(value) end  -- BUG FIX: garante inteiro
        local ratio = (value - minV) / (maxV - minV)
        fill.Size     = UDim2.new(ratio, 0, 1, 0)
        knob.Position = UDim2.new(ratio, 0, 0.5, 0)
        valLbl.Text   = tostring(value)
    end
    applyValue(value)

    local hitbox = Instance.new("TextButton")
    hitbox.Size = UDim2.new(1,0,0, tH + 20)
    hitbox.Position = UDim2.new(0,0,0,10)
    hitbox.BackgroundTransparency = 1; hitbox.Text = ""
    hitbox.ZIndex = 7; hitbox.AutoButtonColor = false; hitbox.Parent = f

    local dragging  = false
    local conns     = {}  -- lista de conexões do drag

    local function applyFromX(absX)
        local trackW = track.AbsoluteSize.X
        if trackW == 0 then return end
        local relX = Util.Clamp(absX - track.AbsolutePosition.X, 0, trackW)
        local v = minV + (relX / trackW) * (maxV - minV)
        if isInt then v = math.round(v) end
        v = Util.Clamp(v, minV, maxV)
        if v ~= value then
            applyValue(v)
            if cb then pcall(cb, value) end
        end
    end

    local function stopDrag()
        if not dragging then return end
        dragging = false
        Util.DisconnectAll(conns)
        Util.Tween(knob,       Config.TweenFast, {BackgroundColor3 = Theme.SliderKnob})
        Util.Tween(knobStroke, Config.TweenFast, {Color = Theme.Accent, Thickness = 1.5})
        Util.Tween(f,          Config.TweenFast, {BackgroundColor3 = Theme.WidgetBg})
    end

    hitbox.MouseEnter:Connect(function()
        Util.Tween(f, Config.TweenFast, {BackgroundColor3 = Theme.WidgetBgHover})
    end)
    hitbox.MouseLeave:Connect(function()
        if not dragging then
            Util.Tween(f, Config.TweenFast, {BackgroundColor3 = Theme.WidgetBg})
        end
    end)

    hitbox.MouseButton1Down:Connect(function()
        dragging = true
        Util.Tween(knob,       Config.TweenFast, {BackgroundColor3 = Theme.AccentGlow})
        Util.Tween(knobStroke, Config.TweenFast, {Color = Theme.AccentGlow, Thickness = 2})
        applyFromX(UserInputService:GetMouseLocation().X)

        conns[1] = UserInputService.InputChanged:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseMovement then
                applyFromX(inp.Position.X)
            end
        end)
        conns[2] = UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                stopDrag()
            end
        end)
    end)

    -- Limpa drag se widget for removido da hierarquia
    wrap.AncestryChanged:Connect(function()
        if not wrap.Parent then stopDrag() end
    end)

    local obj = {}
    function obj:GetValue() return value end
    function obj:SetValue(v, silent)
        applyValue(v)
        if not silent and cb then pcall(cb, value) end
    end
    function obj:SetText(t) nameLbl.Text = t end
    return obj
end

-- ────────────────────────────────────────────────
--  SECTION
-- ────────────────────────────────────────────────
function Widgets.Section(scroll, text, order)
    local wrap = Instance.new("Frame")
    wrap.Size = UDim2.new(1,0,0,Config.SectionH)
    wrap.BackgroundTransparency = 1; wrap.BorderSizePixel = 0
    wrap.LayoutOrder = order; wrap.Parent = scroll

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1,0,0,1)
    line.Position = UDim2.new(0,0,0.5,0)
    line.BackgroundColor3 = Theme.SectionLine; line.BorderSizePixel = 0
    line.ZIndex = 1; line.Parent = wrap

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-28,1,0)
    lbl.Position = UDim2.new(0,14,0,0)
    lbl.BackgroundTransparency = 1; lbl.Text = string.upper(text or "SECTION")
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 9
    lbl.TextColor3 = Theme.SectionText
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    -- Fundo para "cortar" a linha atrás do texto
    lbl.BackgroundColor3 = Theme.Background
    lbl.BackgroundTransparency = 0
    lbl.ZIndex = 2; lbl.Parent = wrap

    local obj = {}
    function obj:SetText(t) lbl.Text = string.upper(t or "") end
    return obj
end

-- ────────────────────────────────────────────────
--  SEPARATOR
-- ────────────────────────────────────────────────
function Widgets.Separator(scroll, order)
    local wrap = Instance.new("Frame")
    wrap.Size = UDim2.new(1,0,0,Config.SeparatorH)
    wrap.BackgroundTransparency = 1; wrap.BorderSizePixel = 0
    wrap.LayoutOrder = order; wrap.Parent = scroll

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1,0,0,1)
    line.Position = UDim2.new(0,0,0.5,0)
    line.BackgroundColor3 = Theme.SectionLine; line.BorderSizePixel = 0
    line.Parent = wrap
end

-- ────────────────────────────────────────────────
--  LABEL
-- ────────────────────────────────────────────────
function Widgets.Label(scroll, text, order)
    local wrap, f, _ = Util.WidgetBase(scroll, order, Config.LabelH)

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft  = UDim.new(0,12); pad.PaddingRight = UDim.new(0,12)
    pad.Parent = f

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,0,1,0)
    lbl.BackgroundTransparency = 1; lbl.Text = text or ""
    lbl.Font = Enum.Font.Gotham; lbl.TextSize = 11
    lbl.TextColor3 = Theme.TextSecondary
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true
    lbl.ZIndex = 2; lbl.Parent = f

    local obj = {}
    function obj:SetText(t)  lbl.Text = t or "" end
    function obj:SetColor(c) Util.Tween(lbl, Config.TweenFast, {TextColor3 = c}) end
    return obj
end

-- ────────────────────────────────────────────────
--  TEXTBOX
-- ────────────────────────────────────────────────
function Widgets.Textbox(scroll, text, placeholder, default, order, cb)
    local wrap, f, stroke = Util.WidgetBase(scroll, order, Config.TextboxH)

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0.45,0,1,0); nameLbl.Position = UDim2.new(0,12,0,0)
    nameLbl.BackgroundTransparency = 1; nameLbl.Text = text or ""
    nameLbl.Font = Enum.Font.GothamSemibold; nameLbl.TextSize = 12
    nameLbl.TextColor3 = Theme.TextPrimary
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 2; nameLbl.Parent = f

    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(0.52,0,0,24)
    inputFrame.Position = UDim2.new(1,-8,0.5,0)
    inputFrame.AnchorPoint = Vector2.new(1,0.5)
    inputFrame.BackgroundColor3 = Theme.InputBg; inputFrame.BorderSizePixel = 0
    inputFrame.ZIndex = 3; inputFrame.Parent = f
    Util.Corner(inputFrame, UDim.new(0,5))
    local inputStroke = Util.Stroke(inputFrame, Theme.InputBorder, 1)

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1,-12,1,0); box.Position = UDim2.new(0,6,0,0)
    box.BackgroundTransparency = 1
    box.Text = default or ""
    box.PlaceholderText = placeholder or ""
    box.PlaceholderColor3 = Theme.TextDisabled
    box.Font = Enum.Font.Gotham; box.TextSize = 11
    box.TextColor3 = Theme.InputText
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.ClearTextOnFocus = false
    box.ZIndex = 4; box.Parent = inputFrame

    box.Focused:Connect(function()
        Util.Tween(inputStroke, Config.TweenFast, {Color = Theme.Accent})
        Util.Tween(stroke,      Config.TweenFast, {Color = Theme.Accent})
        Util.Tween(f,           Config.TweenFast, {BackgroundColor3 = Theme.WidgetBgHover})
    end)
    box.FocusLost:Connect(function(enterPressed)
        Util.Tween(inputStroke, Config.TweenFast, {Color = Theme.InputBorder})
        Util.Tween(stroke,      Config.TweenFast, {Color = Theme.Border})
        Util.Tween(f,           Config.TweenFast, {BackgroundColor3 = Theme.WidgetBg})
        if cb then pcall(cb, box.Text, enterPressed) end
    end)

    local obj = {}
    function obj:GetText()   return box.Text end
    function obj:SetText(t)  box.Text = t or "" end
    function obj:SetLabel(t) nameLbl.Text = t or "" end
    return obj
end

-- ────────────────────────────────────────────────
--  DROPDOWN
-- BUG FIX: SetOptions agora reseta selected corretamente
-- BUG FIX: outsideConn desconectado via AncestryChanged
-- ────────────────────────────────────────────────
local _openDropdownClose = nil

function Widgets.Dropdown(scroll, text, options, default, order, cb)
    options = options or {}
    local selected = default or (options[1] or "")

    local wrap = Instance.new("Frame")
    wrap.Size = UDim2.new(1,0,0,Config.DropdownH)
    wrap.BackgroundTransparency = 1; wrap.BorderSizePixel = 0
    wrap.LayoutOrder = order; wrap.ClipsDescendants = false
    wrap.Parent = scroll

    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,1,0)
    f.BackgroundColor3 = Theme.WidgetBg; f.BorderSizePixel = 0
    f.ZIndex = 2; f.Parent = wrap
    Util.Corner(f, Config.WidgetCorner)
    local stroke = Util.Stroke(f, Theme.Border, Config.WidgetBorderW)

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0.45,0,1,0); nameLbl.Position = UDim2.new(0,12,0,0)
    nameLbl.BackgroundTransparency = 1; nameLbl.Text = text or ""
    nameLbl.Font = Enum.Font.GothamSemibold; nameLbl.TextSize = 12
    nameLbl.TextColor3 = Theme.TextPrimary
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 3; nameLbl.Parent = f

    local valBtn = Instance.new("TextButton")
    valBtn.Size = UDim2.new(0.52,0,0,24)
    valBtn.Position = UDim2.new(1,-8,0.5,0)
    valBtn.AnchorPoint = Vector2.new(1,0.5)
    valBtn.BackgroundColor3 = Theme.InputBg; valBtn.BorderSizePixel = 0
    valBtn.Text = ""; valBtn.AutoButtonColor = false
    valBtn.ZIndex = 3; valBtn.Parent = f
    Util.Corner(valBtn, UDim.new(0,5))
    local valStroke = Util.Stroke(valBtn, Theme.InputBorder, 1)

    local selLbl = Instance.new("TextLabel")
    selLbl.Size = UDim2.new(1,-22,1,0); selLbl.Position = UDim2.new(0,8,0,0)
    selLbl.BackgroundTransparency = 1; selLbl.Text = tostring(selected)
    selLbl.Font = Enum.Font.Gotham; selLbl.TextSize = 11
    selLbl.TextColor3 = Theme.InputText
    selLbl.TextXAlignment = Enum.TextXAlignment.Left
    selLbl.TextTruncate = Enum.TextTruncate.AtEnd
    selLbl.ZIndex = 4; selLbl.Parent = valBtn

    local arrowLbl = Instance.new("TextLabel")
    arrowLbl.Size = UDim2.new(0,18,1,0); arrowLbl.Position = UDim2.new(1,-18,0,0)
    arrowLbl.BackgroundTransparency = 1; arrowLbl.Text = "▾"
    arrowLbl.Font = Enum.Font.GothamBold; arrowLbl.TextSize = 10
    arrowLbl.TextColor3 = Theme.DropdownArrow
    arrowLbl.ZIndex = 4; arrowLbl.Parent = valBtn

    local listFrame = Instance.new("Frame")
    listFrame.Size = UDim2.new(0.52,0,0,0)
    listFrame.Position = UDim2.new(1,-8,1,4)
    listFrame.AnchorPoint = Vector2.new(1,0)
    listFrame.BackgroundColor3 = Theme.Surface; listFrame.BorderSizePixel = 0
    listFrame.ClipsDescendants = true
    listFrame.Visible = false
    listFrame.ZIndex = 20; listFrame.Parent = f
    Util.Corner(listFrame, UDim.new(0,6))
    Util.Stroke(listFrame, Theme.Border, 1)

    local listScroll = Instance.new("ScrollingFrame")
    listScroll.Size = UDim2.new(1,0,1,0)
    listScroll.BackgroundTransparency = 1; listScroll.BorderSizePixel = 0
    listScroll.ScrollBarThickness = 2
    listScroll.ScrollBarImageColor3 = Theme.ScrollBar
    listScroll.CanvasSize = UDim2.new(0,0,0,0)
    listScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    listScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    listScroll.ZIndex = 21; listScroll.Parent = listFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0,0)
    listLayout.Parent = listScroll

    local listPad = Instance.new("UIPadding")
    listPad.PaddingTop    = UDim.new(0,4); listPad.PaddingBottom = UDim.new(0,4)
    listPad.PaddingLeft   = UDim.new(0,4); listPad.PaddingRight  = UDim.new(0,4)
    listPad.Parent = listScroll

    local isOpen = false

    local function closeList()
        if not isOpen then return end
        isOpen = false
        if _openDropdownClose == closeList then _openDropdownClose = nil end
        Util.Tween(listFrame, Config.TweenFast, {Size = UDim2.new(0.52,0,0,0)})
        Util.Tween(arrowLbl,  Config.TweenFast, {TextColor3 = Theme.DropdownArrow})
        Util.Tween(valStroke, Config.TweenFast, {Color = Theme.InputBorder})
        Util.Tween(stroke,    Config.TweenFast, {Color = Theme.Border})
        task.delay(Config.TweenFast.Time + 0.02, function()
            if not isOpen then listFrame.Visible = false end
        end)
    end

    local function openList()
        if _openDropdownClose then _openDropdownClose() end
        _openDropdownClose = closeList
        isOpen = true
        local clampedH = math.min(#options * Config.DropdownItemH + 8, Config.DropdownMaxH)
        listFrame.Visible = true
        listFrame.Size    = UDim2.new(0.52,0,0,0)
        Util.Tween(listFrame, Config.TweenFast, {Size = UDim2.new(0.52,0,0,clampedH)})
        Util.Tween(arrowLbl,  Config.TweenFast, {TextColor3 = Theme.Accent})
        Util.Tween(valStroke, Config.TweenFast, {Color = Theme.Accent})
        Util.Tween(stroke,    Config.TweenFast, {Color = Theme.Accent})
    end

    -- BUG FIX: populateItems agora remove corretamente todos os filhos antes de repopular
    local function populateItems()
        for _, child in ipairs(listScroll:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        for i, opt in ipairs(options) do
            local itemBtn = Instance.new("TextButton")
            itemBtn.Size = UDim2.new(1,0,0,Config.DropdownItemH)
            itemBtn.BackgroundColor3 = Theme.Surface; itemBtn.BorderSizePixel = 0
            itemBtn.Text = ""; itemBtn.AutoButtonColor = false
            itemBtn.LayoutOrder = i; itemBtn.ZIndex = 22
            itemBtn.Parent = listScroll
            Util.Corner(itemBtn, UDim.new(0,4))

            local optLbl = Instance.new("TextLabel")
            optLbl.Size = UDim2.new(1,-16,1,0); optLbl.Position = UDim2.new(0,8,0,0)
            optLbl.BackgroundTransparency = 1; optLbl.Text = tostring(opt)
            optLbl.Font = Enum.Font.Gotham; optLbl.TextSize = 11
            optLbl.TextColor3 = (opt == selected) and Theme.AccentGlow or Theme.TextSecondary
            optLbl.TextXAlignment = Enum.TextXAlignment.Left
            optLbl.ZIndex = 23; optLbl.Parent = itemBtn

            local checkLbl = Instance.new("TextLabel")
            checkLbl.Name = "checkLbl"
            checkLbl.Size = UDim2.new(0,14,1,0); checkLbl.Position = UDim2.new(1,-16,0,0)
            checkLbl.BackgroundTransparency = 1
            checkLbl.Text = (opt == selected) and "✓" or ""
            checkLbl.Font = Enum.Font.GothamBold; checkLbl.TextSize = 9
            checkLbl.TextColor3 = Theme.Accent
            checkLbl.ZIndex = 23; checkLbl.Parent = itemBtn

            itemBtn.MouseEnter:Connect(function()
                Util.Tween(itemBtn, Config.TweenFast, {BackgroundColor3 = Theme.SurfaceHover})
                Util.Tween(optLbl,  Config.TweenFast, {TextColor3 = Theme.TextPrimary})
            end)
            itemBtn.MouseLeave:Connect(function()
                Util.Tween(itemBtn, Config.TweenFast, {BackgroundColor3 = Theme.Surface})
                Util.Tween(optLbl,  Config.TweenFast, {
                    TextColor3 = (opt == selected) and Theme.AccentGlow or Theme.TextSecondary
                })
            end)
            itemBtn.MouseButton1Click:Connect(function()
                -- Reseta visual de todos os itens
                for _, child2 in ipairs(listScroll:GetChildren()) do
                    if child2:IsA("TextButton") then
                        local cl = child2:FindFirstChild("checkLbl")
                        if cl then cl.Text = "" end
                        for _, lc in ipairs(child2:GetChildren()) do
                            if lc:IsA("TextLabel") and lc.Name ~= "checkLbl" then
                                Util.Tween(lc, Config.TweenFast, {TextColor3 = Theme.TextSecondary})
                            end
                        end
                    end
                end
                optLbl.TextColor3 = Theme.AccentGlow
                checkLbl.Text     = "✓"
                selected          = opt
                selLbl.Text       = tostring(opt)
                closeList()
                if cb then pcall(cb, selected) end
            end)
        end
    end
    populateItems()

    valBtn.MouseButton1Click:Connect(function()
        if isOpen then closeList() else openList() end
    end)

    -- BUG FIX: usa 1 conexão guardada para fechar ao clicar fora
    local outsideConn = UserInputService.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 and isOpen then
            task.defer(function()
                if isOpen then closeList() end
            end)
        end
    end)

    wrap.AncestryChanged:Connect(function()
        if not wrap.Parent then
            if isOpen then closeList() end
            outsideConn:Disconnect()
        end
    end)

    local obj = {}
    function obj:GetSelected() return selected end
    function obj:SetSelected(opt, silent)
        if table.find(options, opt) then
            selected    = opt
            selLbl.Text = tostring(opt)
            if not silent and cb then pcall(cb, selected) end
        end
    end
    -- BUG FIX: SetOptions fecha lista aberta, reseta selected e repopula items
    function obj:SetOptions(newOptions, newDefault)
        if isOpen then closeList() end
        options  = newOptions or {}
        selected = newDefault or options[1] or ""
        selLbl.Text = tostring(selected)
        populateItems()
    end
    function obj:SetLabel(t) nameLbl.Text = t or "" end
    return obj
end

-- ────────────────────────────────────────────────
--  KEYBIND
-- BUG FIX: agora permite bindar MouseButton1/2/3
-- BUG FIX: limpeza de inputConn via lista de conexões
-- ────────────────────────────────────────────────
function Widgets.Keybind(scroll, text, default, order, cb)
    local boundKey  = default or nil  -- pode ser KeyCode ou UserInputType (para mouse)
    local listening = false

    local wrap, f, stroke = Util.WidgetBase(scroll, order, Config.KeybindH)

    local sico = Instance.new("TextLabel")
    sico.Size = UDim2.new(0,16,1,0); sico.Position = UDim2.new(0,10,0,0)
    sico.BackgroundTransparency = 1; sico.Text = "⌨"
    sico.Font = Enum.Font.GothamBold; sico.TextSize = 10
    sico.TextColor3 = Theme.AccentDim; sico.ZIndex = 2; sico.Parent = f

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1,-(Config.KeybindW + 24),1,0)
    nameLbl.Position = UDim2.new(0,30,0,0)
    nameLbl.BackgroundTransparency = 1; nameLbl.Text = text or ""
    nameLbl.Font = Enum.Font.GothamSemibold; nameLbl.TextSize = 12
    nameLbl.TextColor3 = Theme.TextPrimary
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 2; nameLbl.Parent = f

    local keyBtn = Instance.new("TextButton")
    keyBtn.Size = UDim2.new(0, Config.KeybindW, 0, 22)
    keyBtn.Position = UDim2.new(1,-8,0.5,0)
    keyBtn.AnchorPoint = Vector2.new(1,0.5)
    keyBtn.BackgroundColor3 = Theme.KeybindBg; keyBtn.BorderSizePixel = 0
    keyBtn.Text = ""; keyBtn.AutoButtonColor = false
    keyBtn.ZIndex = 3; keyBtn.Parent = f
    Util.Corner(keyBtn, UDim.new(0,5))
    local keyStroke = Util.Stroke(keyBtn, Theme.KeybindBorder, 1)

    -- Retorna nome legível para qualquer tipo de bind
    local function getBindName(bind)
        if bind == nil then return "None" end
        if typeof(bind) == "EnumItem" then
            if bind.EnumType == Enum.KeyCode then
                return bind.Name
            elseif bind.EnumType == Enum.UserInputType then
                -- Nomes amigáveis para botões do mouse
                if bind == Enum.UserInputType.MouseButton1 then return "M1" end
                if bind == Enum.UserInputType.MouseButton2 then return "M2" end
                if bind == Enum.UserInputType.MouseButton3 then return "M3" end
                return bind.Name
            end
        end
        return "None"
    end

    local keyLbl = Instance.new("TextLabel")
    keyLbl.Size = UDim2.new(1,0,1,0)
    keyLbl.BackgroundTransparency = 1
    keyLbl.Text = getBindName(boundKey)
    keyLbl.Font = Enum.Font.GothamBold; keyLbl.TextSize = 10
    keyLbl.TextColor3 = boundKey and Theme.Accent or Theme.TextDisabled
    keyLbl.TextXAlignment = Enum.TextXAlignment.Center
    keyLbl.ZIndex = 4; keyLbl.Parent = keyBtn

    local inputConn = nil

    local function stopListening()
        listening = false
        if inputConn then inputConn:Disconnect(); inputConn = nil end
        Util.Tween(keyStroke, Config.TweenFast, {Color = Theme.KeybindBorder})
        Util.Tween(stroke,    Config.TweenFast, {Color = Theme.Border})
        Util.Tween(f,         Config.TweenFast, {BackgroundColor3 = Theme.WidgetBg})
        Util.Tween(keyLbl,    Config.TweenFast, {TextColor3 = boundKey and Theme.Accent or Theme.TextDisabled})
        keyLbl.Text = getBindName(boundKey)
    end

    local function startListening()
        listening   = true
        keyLbl.Text = "..."
        Util.Tween(keyStroke, Config.TweenFast, {Color = Theme.KeybindActive})
        Util.Tween(stroke,    Config.TweenFast, {Color = Theme.Accent})
        Util.Tween(f,         Config.TweenFast, {BackgroundColor3 = Theme.WidgetBgHover})
        Util.Tween(keyLbl,    Config.TweenFast, {TextColor3 = Theme.AccentGlow})

        inputConn = UserInputService.InputBegan:Connect(function(inp, gameProcessed)
            if not listening then return end

            -- BUG FIX: aceita MouseButton1/2/3 como bind
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.MouseButton2
            or inp.UserInputType == Enum.UserInputType.MouseButton3 then
                -- Ignora clique no próprio botão de keybind ao iniciar listening
                -- (o clique que ativou o listening)
                -- usa task.defer para evitar capturar o mesmo clique
                task.defer(function()
                    if not listening then return end
                    boundKey = inp.UserInputType
                    stopListening()
                    if cb then pcall(cb, boundKey) end
                end)
                return
            end

            if inp.UserInputType == Enum.UserInputType.Keyboard then
                if inp.KeyCode == Enum.KeyCode.Escape then
                    stopListening(); return
                end
                boundKey = inp.KeyCode
                stopListening()
                if cb then pcall(cb, boundKey) end
            end
        end)
    end

    keyBtn.MouseEnter:Connect(function()
        if listening then return end
        Util.Tween(f,      Config.TweenFast, {BackgroundColor3 = Theme.WidgetBgHover})
        Util.Tween(stroke, Config.TweenFast, {Color = Theme.AccentDim})
    end)
    keyBtn.MouseLeave:Connect(function()
        if listening then return end
        Util.Tween(f,      Config.TweenFast, {BackgroundColor3 = Theme.WidgetBg})
        Util.Tween(stroke, Config.TweenFast, {Color = Theme.Border})
    end)
    keyBtn.MouseButton1Click:Connect(function()
        if listening then stopListening() else startListening() end
    end)

    wrap.AncestryChanged:Connect(function()
        if not wrap.Parent then stopListening() end
    end)

    local obj = {}
    function obj:GetKey()   return boundKey end
    function obj:SetKey(k, silent)
        boundKey = k; stopListening()
        if not silent and cb then pcall(cb, boundKey) end
    end
    function obj:SetText(t) nameLbl.Text = t or "" end
    return obj
end

-- ────────────────────────────────────────────────
--  PROGRESS BAR
-- ────────────────────────────────────────────────
function Widgets.ProgressBar(scroll, text, initialValue, order)
    local value = Util.Clamp(initialValue or 0, 0, 1)

    local wrap, f, _ = Util.WidgetBase(scroll, order, Config.ProgressH)

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft   = UDim.new(0,10); pad.PaddingRight  = UDim.new(0,10)
    pad.PaddingTop    = UDim.new(0,6);  pad.PaddingBottom = UDim.new(0,6)
    pad.Parent = f

    local topRow = Instance.new("Frame")
    topRow.Size = UDim2.new(1,0,0,14)
    topRow.BackgroundTransparency = 1; topRow.BorderSizePixel = 0
    topRow.Parent = f

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1,-36,1,0)
    nameLbl.BackgroundTransparency = 1; nameLbl.Text = text or ""
    nameLbl.Font = Enum.Font.GothamSemibold; nameLbl.TextSize = 11
    nameLbl.TextColor3 = Theme.TextPrimary
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 2; nameLbl.Parent = topRow

    local pctLbl = Instance.new("TextLabel")
    pctLbl.Size = UDim2.new(0,34,1,0); pctLbl.Position = UDim2.new(1,-34,0,0)
    pctLbl.BackgroundTransparency = 1
    pctLbl.Text = math.floor(value * 100) .. "%"
    pctLbl.Font = Enum.Font.GothamBold; pctLbl.TextSize = 10
    pctLbl.TextColor3 = Theme.Accent
    pctLbl.TextXAlignment = Enum.TextXAlignment.Right
    pctLbl.ZIndex = 2; pctLbl.Parent = topRow

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1,0,0,Config.ProgressBarH)
    track.Position = UDim2.new(0,0,0,18)
    track.BackgroundColor3 = Theme.ProgressTrack
    track.BorderSizePixel = 0; track.ZIndex = 2; track.Parent = f
    Util.Corner(track, UDim.new(1,0))

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(value, 0, 1, 0)
    fill.BackgroundColor3 = Theme.ProgressFill
    fill.BorderSizePixel = 0; fill.ZIndex = 3; fill.Parent = track
    Util.Corner(fill, UDim.new(1,0))

    -- Shimmer sutil no lado direito do fill
    local shimmer = Instance.new("Frame")
    shimmer.Size = UDim2.new(0.4,0,1,0)
    shimmer.Position = UDim2.new(0.6,0,0,0)
    shimmer.BackgroundColor3 = Color3.new(1,1,1)
    shimmer.BackgroundTransparency = 0.85
    shimmer.BorderSizePixel = 0; shimmer.ZIndex = 4; shimmer.Parent = fill
    Util.Corner(shimmer, UDim.new(1,0))

    local function applyValue(v, animate)
        value = Util.Clamp(v, 0, 1)
        pctLbl.Text = math.floor(value * 100) .. "%"
        local newSize = UDim2.new(value, 0, 1, 0)
        if animate then
            local info = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            Util.Tween(fill, info, {Size = newSize})
        else
            fill.Size = newSize
        end
        local fillColor = value >= 1 and Theme.NotifySuccess or Theme.ProgressFill
        Util.Tween(fill, Config.TweenFast, {BackgroundColor3 = fillColor})
    end
    applyValue(value, false)

    local obj = {}
    function obj:GetValue() return value end
    function obj:SetValue(v, animate)
        applyValue(v, animate ~= false)
    end
    function obj:SetText(t) nameLbl.Text = t or "" end
    return obj
end

-- ────────────────────────────────────────────────
--  COLOR PICKER
-- BUG FIX: totalPanelH e svSize calculados corretamente
-- BUG FIX: conexões de drag limpas via lista
-- ────────────────────────────────────────────────
local _openPickerClose = nil

function Widgets.ColorPicker(scroll, text, default, order, cb)
    local currentColor = default or Color3.fromHex("#D4AF37")
    local hue, sat, val = Util.Color3toHSV(currentColor)

    local wrap = Instance.new("Frame")
    wrap.Size = UDim2.new(1,0,0,Config.ColorPickerH)
    wrap.BackgroundTransparency = 1; wrap.BorderSizePixel = 0
    wrap.LayoutOrder = order; wrap.ClipsDescendants = false
    wrap.Parent = scroll

    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,1,0)
    f.BackgroundColor3 = Theme.WidgetBg; f.BorderSizePixel = 0
    f.ZIndex = 2; f.Parent = wrap
    Util.Corner(f, Config.WidgetCorner)
    local stroke = Util.Stroke(f, Theme.Border, Config.WidgetBorderW)

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0.55,0,1,0); nameLbl.Position = UDim2.new(0,12,0,0)
    nameLbl.BackgroundTransparency = 1; nameLbl.Text = text or ""
    nameLbl.Font = Enum.Font.GothamSemibold; nameLbl.TextSize = 12
    nameLbl.TextColor3 = Theme.TextPrimary
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 3; nameLbl.Parent = f

    local previewBtn = Instance.new("TextButton")
    previewBtn.Size = UDim2.new(0,52,0,22)
    previewBtn.Position = UDim2.new(1,-8,0.5,0)
    previewBtn.AnchorPoint = Vector2.new(1,0.5)
    previewBtn.BackgroundColor3 = currentColor
    previewBtn.BorderSizePixel = 0
    previewBtn.Text = ""; previewBtn.AutoButtonColor = false
    previewBtn.ZIndex = 3; previewBtn.Parent = f
    Util.Corner(previewBtn, UDim.new(0,5))
    local previewStroke = Util.Stroke(previewBtn, Theme.PickerBorder, 1)

    local hexLbl = Instance.new("TextLabel")
    hexLbl.Size = UDim2.new(1,0,1,0)
    hexLbl.BackgroundTransparency = 1
    hexLbl.Text = "#" .. Util.Color3toHex(currentColor)
    hexLbl.Font = Enum.Font.GothamBold; hexLbl.TextSize = 8
    hexLbl.TextColor3 = Color3.new(1,1,1)
    hexLbl.TextXAlignment = Enum.TextXAlignment.Center
    hexLbl.ZIndex = 4; hexLbl.Parent = previewBtn

    -- ── Painel flutuante ──────────────────────────────────────
    local panelW  = Config.ColorPanelW
    -- BUG FIX: svSize = panelW - padding(8*2) - hue(14) - hueGap(6) = panelW - 36
    -- Porém usamos Config.ColorSVSize que já está precalculado: 144
    local svSize  = Config.ColorSVSize
    local hueW    = Config.ColorHueW
    local hueGap  = Config.ColorHueGap
    local panelPadding = 8  -- UIPadding em cada lado

    -- Altura total: padding_top + svSize + 2(sep gap) + 1(sep) + 2(sep gap) + 28(bottom) + padding_bottom
    local totalPanelH = panelPadding + svSize + 14 + 1 + 14 + 28 + panelPadding

    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0, panelW, 0, 0)
    panel.Position = UDim2.new(1, -panelW, 1, 4)
    panel.AnchorPoint = Vector2.new(1, 0)
    panel.BackgroundColor3 = Theme.Surface
    panel.BorderSizePixel = 0
    panel.ClipsDescendants = true
    panel.Visible = false
    panel.ZIndex = 30; panel.Parent = f
    Util.Corner(panel, UDim.new(0,8))
    Util.Stroke(panel, Theme.Border, 1)

    local panelPad = Instance.new("UIPadding")
    panelPad.PaddingTop    = UDim.new(0, panelPadding)
    panelPad.PaddingBottom = UDim.new(0, panelPadding)
    panelPad.PaddingLeft   = UDim.new(0, panelPadding)
    panelPad.PaddingRight  = UDim.new(0, panelPadding)
    panelPad.Parent = panel

    -- SV picker (saturation = X, value = Y invertido)
    local svPicker = Instance.new("ImageLabel")
    svPicker.Size = UDim2.new(0, svSize, 0, svSize)
    svPicker.Position = UDim2.new(0,0,0,0)
    svPicker.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
    svPicker.BorderSizePixel = 0
    svPicker.ZIndex = 31; svPicker.Parent = panel
    Util.Corner(svPicker, UDim.new(0,4))

    -- Gradiente branco horizontal (esquerda = branco opaco, direita = transparente)
    local svGradW = Instance.new("UIGradient")
    svGradW.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.new(1,1,1)),
        ColorSequenceKeypoint.new(1, Color3.new(1,1,1)),
    }
    svGradW.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1),
    }
    svGradW.Rotation = 0
    svGradW.Parent = svPicker

    -- Gradiente preto vertical (topo = transparente, baixo = preto)
    local svGradB = Instance.new("Frame")
    svGradB.Size = UDim2.new(1,0,1,0)
    svGradB.BackgroundTransparency = 1
    svGradB.BorderSizePixel = 0
    svGradB.ZIndex = 32; svGradB.Parent = svPicker
    Util.Corner(svGradB, UDim.new(0,4))

    local svGradBGrad = Instance.new("UIGradient")
    svGradBGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.new(0,0,0)),
        ColorSequenceKeypoint.new(1, Color3.new(0,0,0)),
    }
    svGradBGrad.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0),
    }
    svGradBGrad.Rotation = 90
    svGradBGrad.Parent = svGradB

    -- Cursor do SV picker
    local svCursor = Instance.new("Frame")
    svCursor.Size = UDim2.new(0,10,0,10)
    svCursor.AnchorPoint = Vector2.new(0.5,0.5)
    svCursor.Position = UDim2.new(sat, 0, 1 - val, 0)
    svCursor.BackgroundColor3 = Color3.new(1,1,1)
    svCursor.BorderSizePixel = 0
    svCursor.ZIndex = 34; svCursor.Parent = svPicker
    Util.Corner(svCursor, UDim.new(1,0))
    Util.Stroke(svCursor, Color3.new(0,0,0), 1.5)

    -- Hue slider vertical (à direita do SV picker)
    local hueSlider = Instance.new("Frame")
    hueSlider.Size = UDim2.new(0, hueW, 0, svSize)
    hueSlider.Position = UDim2.new(0, svSize + hueGap, 0, 0)
    hueSlider.BackgroundColor3 = Color3.new(1,1,1)
    hueSlider.BorderSizePixel = 0
    hueSlider.ZIndex = 31; hueSlider.Parent = panel
    Util.Corner(hueSlider, UDim.new(0,4))

    local hueGrad = Instance.new("UIGradient")
    hueGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,    Color3.fromHSV(0,    1, 1)),
        ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17, 1, 1)),
        ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
        ColorSequenceKeypoint.new(0.5,  Color3.fromHSV(0.5,  1, 1)),
        ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67, 1, 1)),
        ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
        ColorSequenceKeypoint.new(1,    Color3.fromHSV(1,    1, 1)),
    }
    hueGrad.Rotation = 90
    hueGrad.Parent = hueSlider

    local hueCursor = Instance.new("Frame")
    hueCursor.Size = UDim2.new(1,4,0,4)
    hueCursor.AnchorPoint = Vector2.new(0.5,0.5)
    hueCursor.Position = UDim2.new(0.5, 0, hue, 0)
    hueCursor.BackgroundColor3 = Color3.new(1,1,1)
    hueCursor.BorderSizePixel = 0
    hueCursor.ZIndex = 33; hueCursor.Parent = hueSlider
    Util.Corner(hueCursor, UDim.new(0,2))
    Util.Stroke(hueCursor, Color3.new(0,0,0), 1)

    -- Separador
    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1,0,0,1)
    sep.Position = UDim2.new(0,0,0, svSize + 12)
    sep.BackgroundColor3 = Theme.SectionLine; sep.BorderSizePixel = 0
    sep.ZIndex = 31; sep.Parent = panel

    -- Linha inferior: preview + input hex
    local bottomRow = Instance.new("Frame")
    bottomRow.Size = UDim2.new(1,0,0,28)
    bottomRow.Position = UDim2.new(0,0,0, svSize + 14 + 1 + 12)
    bottomRow.BackgroundTransparency = 1; bottomRow.BorderSizePixel = 0
    bottomRow.ZIndex = 31; bottomRow.Parent = panel

    local colorPreview = Instance.new("Frame")
    colorPreview.Size = UDim2.new(0,28,1,0)
    colorPreview.BackgroundColor3 = currentColor; colorPreview.BorderSizePixel = 0
    colorPreview.ZIndex = 32; colorPreview.Parent = bottomRow
    Util.Corner(colorPreview, UDim.new(0,5))
    Util.Stroke(colorPreview, Theme.Border, 1)

    local hexBox = Instance.new("TextBox")
    hexBox.Size = UDim2.new(1,-36,1,0); hexBox.Position = UDim2.new(0,34,0,0)
    hexBox.BackgroundColor3 = Theme.InputBg; hexBox.BorderSizePixel = 0
    hexBox.Text = Util.Color3toHex(currentColor)
    hexBox.PlaceholderText = "RRGGBB"
    hexBox.PlaceholderColor3 = Theme.TextDisabled
    hexBox.Font = Enum.Font.GothamBold; hexBox.TextSize = 10
    hexBox.TextColor3 = Theme.InputText
    hexBox.TextXAlignment = Enum.TextXAlignment.Center
    hexBox.ClearTextOnFocus = false
    hexBox.ZIndex = 32; hexBox.Parent = bottomRow
    Util.Corner(hexBox, UDim.new(0,5))
    Util.Stroke(hexBox, Theme.InputBorder, 1)

    -- ── Lógica de cor ─────────────────────────────────────────
    local function applyHSV(h, s, v, fromHex)
        hue = Util.Clamp(h, 0, 1)
        sat = Util.Clamp(s, 0, 1)
        val = Util.Clamp(v, 0, 1)
        currentColor = Color3.fromHSV(hue, sat, val)

        svPicker.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
        svCursor.Position  = UDim2.new(sat, 0, 1 - val, 0)
        hueCursor.Position = UDim2.new(0.5, 0, hue, 0)

        colorPreview.BackgroundColor3 = currentColor
        previewBtn.BackgroundColor3   = currentColor
        local hexStr = Util.Color3toHex(currentColor)
        if not fromHex then hexBox.Text = hexStr end
        hexLbl.Text = "#" .. hexStr

        -- Contraste automático do texto no preview
        local brightness = currentColor.R * 0.299 + currentColor.G * 0.587 + currentColor.B * 0.114
        hexLbl.TextColor3 = brightness > 0.5 and Color3.new(0,0,0) or Color3.new(1,1,1)

        if cb then pcall(cb, currentColor) end
    end

    -- ── Drag no SV picker ─────────────────────────────────────
    local svConns = {}

    local function applyFromSVPos(absX, absY)
        local w2 = svPicker.AbsoluteSize.X
        local h2 = svPicker.AbsoluteSize.Y
        if w2 == 0 or h2 == 0 then return end
        local s2 = Util.Clamp(absX - svPicker.AbsolutePosition.X, 0, w2) / w2
        local v2 = 1 - Util.Clamp(absY - svPicker.AbsolutePosition.Y, 0, h2) / h2
        applyHSV(hue, s2, v2, false)
    end

    local function stopSVDrag()
        Util.DisconnectAll(svConns)
    end

    local svHit = Instance.new("TextButton")
    svHit.Size = UDim2.new(1,0,1,0); svHit.BackgroundTransparency = 1
    svHit.Text = ""; svHit.ZIndex = 35; svHit.AutoButtonColor = false
    svHit.Parent = svPicker

    svHit.MouseButton1Down:Connect(function()
        local mouse = UserInputService:GetMouseLocation()
        applyFromSVPos(mouse.X, mouse.Y)
        Util.DisconnectAll(svConns)

        svConns[1] = UserInputService.InputChanged:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseMovement then
                applyFromSVPos(inp.Position.X, inp.Position.Y)
            end
        end)
        svConns[2] = UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                stopSVDrag()
            end
        end)
    end)

    -- ── Drag no hue slider ────────────────────────────────────
    local hueConns = {}

    local function applyFromHuePos(absY)
        local h2 = hueSlider.AbsoluteSize.Y
        if h2 == 0 then return end
        local newH = Util.Clamp(absY - hueSlider.AbsolutePosition.Y, 0, h2) / h2
        applyHSV(newH, sat, val, false)
    end

    local function stopHueDrag()
        Util.DisconnectAll(hueConns)
    end

    local hueHit = Instance.new("TextButton")
    hueHit.Size = UDim2.new(1,0,1,0); hueHit.BackgroundTransparency = 1
    hueHit.Text = ""; hueHit.ZIndex = 34; hueHit.AutoButtonColor = false
    hueHit.Parent = hueSlider

    hueHit.MouseButton1Down:Connect(function()
        applyFromHuePos(UserInputService:GetMouseLocation().Y)
        Util.DisconnectAll(hueConns)

        hueConns[1] = UserInputService.InputChanged:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseMovement then
                applyFromHuePos(inp.Position.Y)
            end
        end)
        hueConns[2] = UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                stopHueDrag()
            end
        end)
    end)

    -- ── Input hex ─────────────────────────────────────────────
    hexBox.FocusLost:Connect(function()
        local raw = hexBox.Text:gsub("#",""):upper()
        if #raw == 6 then
            local ok, parsed = pcall(Color3.fromHex, "#" .. raw)
            if ok and parsed then
                local h2, s2, v2 = Util.Color3toHSV(parsed)
                applyHSV(h2, s2, v2, true)
                hexBox.Text = Util.Color3toHex(currentColor)
            end
        end
    end)

    -- ── Abrir/fechar painel ───────────────────────────────────
    local isOpen = false

    local function closePanel()
        if not isOpen then return end
        isOpen = false
        if _openPickerClose == closePanel then _openPickerClose = nil end
        Util.Tween(panel,         Config.TweenFast, {Size = UDim2.new(0, panelW, 0, 0)})
        Util.Tween(stroke,        Config.TweenFast, {Color = Theme.Border})
        Util.Tween(previewStroke, Config.TweenFast, {Color = Theme.PickerBorder})
        task.delay(Config.TweenFast.Time + 0.02, function()
            if not isOpen then panel.Visible = false end
        end)
    end

    local function openPanel()
        if _openPickerClose then _openPickerClose() end
        _openPickerClose = closePanel
        isOpen = true
        panel.Visible = true
        panel.Size = UDim2.new(0, panelW, 0, 0)
        Util.Tween(panel,         Config.TweenFast, {Size = UDim2.new(0, panelW, 0, totalPanelH)})
        Util.Tween(stroke,        Config.TweenFast, {Color = Theme.Accent})
        Util.Tween(previewStroke, Config.TweenFast, {Color = Theme.Accent})
    end

    previewBtn.MouseButton1Click:Connect(function()
        if isOpen then closePanel() else openPanel() end
    end)

    local outsideConn = UserInputService.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 and isOpen then
            task.defer(function()
                if isOpen then closePanel() end
            end)
        end
    end)

    -- Limpeza completa ao remover da hierarquia
    wrap.AncestryChanged:Connect(function()
        if not wrap.Parent then
            stopSVDrag()
            stopHueDrag()
            if isOpen then closePanel() end
            outsideConn:Disconnect()
        end
    end)

    local obj = {}
    function obj:GetColor() return currentColor end
    function obj:SetColor(c, silent)
        local h2, s2, v2 = Util.Color3toHSV(c)
        if silent then
            -- Aplica sem disparar callback
            local savedCb = cb; cb = nil
            applyHSV(h2, s2, v2, false)
            cb = savedCb
        else
            applyHSV(h2, s2, v2, false)
        end
    end
    function obj:SetText(t) nameLbl.Text = t or "" end
    return obj
end

-- ════════════════════════════════════════════════
--  NOTIFICAÇÕES
-- ════════════════════════════════════════════════
local _notifyGui   = nil
local _notifyStack = {}

local NotifyTypes = {
    info    = { color = Theme.NotifyInfo,    icon = "ℹ" },
    success = { color = Theme.NotifySuccess, icon = "✓" },
    warning = { color = Theme.NotifyWarning, icon = "⚠" },
    error   = { color = Theme.NotifyError,   icon = "✕" },
    default = { color = Theme.Accent,        icon = "◈" },
}

local function getNotifyGui()
    if _notifyGui and _notifyGui.Parent then return _notifyGui end
    local ng = Instance.new("ScreenGui")
    ng.Name = "ModernNoir_Notify"; ng.ResetOnSpawn = false
    ng.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ng.DisplayOrder = 200
    ng.IgnoreGuiInset = false
    ng.Parent = GuiParent
    _notifyGui = ng
    return ng
end

local function reshuffleNotify()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local vp   = cam.ViewportSize
    local cumY = Config.NotifyPadB

    for i = #_notifyStack, 1, -1 do
        local entry = _notifyStack[i]
        if entry and entry.card and entry.card.Parent then
            local targetY = vp.Y - cumY - Config.NotifyH
            local targetX = vp.X - Config.NotifyW - Config.NotifyPadR
            Util.Tween(entry.card, Config.TweenMedium, {
                Position = UDim2.new(0, targetX, 0, targetY)
            })
            entry.targetY = targetY
            cumY = cumY + Config.NotifyH + Config.NotifyGap
        end
    end
end

local function createNotify(title, body, duration, notifyType)
    local ng  = getNotifyGui()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local vp  = cam.ViewportSize

    local typeData    = NotifyTypes[notifyType] or NotifyTypes.default
    local accentColor = typeData.color
    local iconChar    = typeData.icon

    local w = Config.NotifyW
    local h = Config.NotifyH

    local card = Instance.new("Frame")
    card.Name             = "NotifyCard"
    card.Size             = UDim2.new(0, w, 0, h)
    card.Position         = UDim2.new(0, vp.X + w + 10, 0, vp.Y - Config.NotifyPadB - h)
    card.BackgroundColor3 = Theme.NotifyBg
    card.BorderSizePixel  = 0
    card.ClipsDescendants = true
    card.ZIndex           = 10
    card.Parent           = ng
    Util.Corner(card, UDim.new(0,8))
    Util.Stroke(card, Theme.Border, 1)

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0,3,1,0)
    accentBar.BackgroundColor3 = accentColor; accentBar.BorderSizePixel = 0
    accentBar.ZIndex = 11; accentBar.Parent = card
    Util.Corner(accentBar, UDim.new(0,2))

    local ico = Instance.new("TextLabel")
    ico.Size = UDim2.new(0,18,0,18); ico.Position = UDim2.new(0,12,0,10)
    ico.BackgroundTransparency = 1; ico.Text = iconChar
    ico.Font = Enum.Font.GothamBold; ico.TextSize = 12
    ico.TextColor3 = accentColor; ico.ZIndex = 12; ico.Parent = card

    local titLbl = Instance.new("TextLabel")
    titLbl.Size = UDim2.new(1,-38,0,18); titLbl.Position = UDim2.new(0,34,0,10)
    titLbl.BackgroundTransparency = 1; titLbl.Text = title or "Notificação"
    titLbl.Font = Enum.Font.GothamBold; titLbl.TextSize = 12
    titLbl.TextColor3 = Theme.TextPrimary
    titLbl.TextXAlignment = Enum.TextXAlignment.Left
    titLbl.TextTruncate = Enum.TextTruncate.AtEnd
    titLbl.ZIndex = 12; titLbl.Parent = card

    local bodyLbl = Instance.new("TextLabel")
    bodyLbl.Size = UDim2.new(1,-20,0,26); bodyLbl.Position = UDim2.new(0,12,0,32)
    bodyLbl.BackgroundTransparency = 1; bodyLbl.Text = body or ""
    bodyLbl.Font = Enum.Font.Gotham; bodyLbl.TextSize = 11
    bodyLbl.TextColor3 = Theme.TextSecondary
    bodyLbl.TextXAlignment = Enum.TextXAlignment.Left
    bodyLbl.TextWrapped = true; bodyLbl.TextTruncate = Enum.TextTruncate.AtEnd
    bodyLbl.ZIndex = 12; bodyLbl.Parent = card

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1,0,0,Config.NotifyBarH)
    barBg.Position = UDim2.new(0,0,0, h - Config.NotifyBarH)
    barBg.BackgroundColor3 = Theme.NotifyBarBg; barBg.BorderSizePixel = 0
    barBg.ZIndex = 11; barBg.Parent = card

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(1,0,1,0)
    barFill.BackgroundColor3 = accentColor; barFill.BorderSizePixel = 0
    barFill.ZIndex = 12; barFill.Parent = barBg

    local closeX = Instance.new("TextButton")
    closeX.Size = UDim2.new(0,16,0,16); closeX.Position = UDim2.new(1,-20,0,7)
    closeX.BackgroundTransparency = 1; closeX.Text = "×"
    closeX.Font = Enum.Font.GothamBold; closeX.TextSize = 13
    closeX.TextColor3 = Theme.TextDisabled; closeX.ZIndex = 13; closeX.Parent = card

    closeX.MouseEnter:Connect(function()
        Util.Tween(closeX, Config.TweenFast, {TextColor3 = Theme.CloseRedHover})
    end)
    closeX.MouseLeave:Connect(function()
        Util.Tween(closeX, Config.TweenFast, {TextColor3 = Theme.TextDisabled})
    end)

    local entry = {card = card}
    table.insert(_notifyStack, entry)

    task.defer(function()
        reshuffleNotify()
        local slideInfo = TweenInfo.new(Config.NotifySlideT, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        Util.Tween(card, slideInfo, {
            Position = UDim2.new(0, vp.X - w - Config.NotifyPadR, 0, entry.targetY or vp.Y - Config.NotifyPadB - h)
        })
    end)

    local dur = duration or Config.NotifyDur
    task.delay(Config.NotifySlideT * 0.6, function()
        if barFill.Parent then
            local barInfo = TweenInfo.new(dur, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            Util.Tween(barFill, barInfo, {Size = UDim2.new(0,0,1,0)})
        end
    end)

    local gone = false
    local function dismiss()
        if gone then return end
        gone = true
        for i, e in ipairs(_notifyStack) do
            if e == entry then table.remove(_notifyStack, i); break end
        end
        reshuffleNotify()
        local fadeI = TweenInfo.new(Config.NotifyFadeT, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        Util.Tween(card, fadeI, {
            Position = UDim2.new(0, vp.X + 20, 0, card.Position.Y.Offset),
            BackgroundTransparency = 1,
        })
        task.delay(Config.NotifyFadeT + 0.05, function()
            if card.Parent then card:Destroy() end
        end)
    end

    task.delay(dur + Config.NotifySlideT, dismiss)
    closeX.MouseButton1Click:Connect(dismiss)
end

-- ════════════════════════════════════════════════
--  SWITCH TAB
-- ════════════════════════════════════════════════
local function SwitchTab(win, newTab)
    if win._ActiveTab == newTab then return end

    local tFade = TweenInfo.new(Config.TabFadeT, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tInd  = TweenInfo.new(Config.TabIndT,  Enum.EasingStyle.Back,  Enum.EasingDirection.Out)

    local prev = win._ActiveTab
    if prev then
        local fo = Util.Tween(prev._Canvas, tFade, {GroupTransparency = 1})
        Util.Tween(prev._Button, Config.TweenFast, {BackgroundColor3 = Theme.Surface})
        Util.Tween(prev._Label,  Config.TweenFast, {TextColor3 = Theme.TextSecondary})
        Util.Tween(prev._Ind, tInd, {
            Size = UDim2.new(0, Config.TabIndW, 1, -10),
            BackgroundTransparency = 0.5,
        })
        local prevCanvas = prev._Canvas
        fo.Completed:Connect(function()
            if prevCanvas and prevCanvas.Parent and not (win._ActiveTab and win._ActiveTab._Canvas == prevCanvas) then
                prevCanvas.Visible = false
            end
        end)
    end

    newTab._Canvas.GroupTransparency = 1
    newTab._Canvas.Visible = true
    Util.Tween(newTab._Canvas, tFade, {GroupTransparency = 0})
    Util.Tween(newTab._Button, Config.TweenFast, {BackgroundColor3 = Theme.SurfaceAlt})
    Util.Tween(newTab._Label,  Config.TweenFast, {TextColor3 = Theme.AccentGlow})
    Util.Tween(newTab._Ind, tInd, {
        Size = UDim2.new(0, Config.TabIndActive, 1, -6),
        BackgroundTransparency = 0,
    })

    win._ActiveTab = newTab
end

-- ════════════════════════════════════════════════
--  LIBRARY PRINCIPAL
-- ════════════════════════════════════════════════
local ModernNoir = {}
ModernNoir._Version = "0.3.1"
ModernNoir._Windows = {}

function ModernNoir:Notify(title, text, duration, notifyType)
    createNotify(title, text, duration, notifyType or "default")
end

-- Troca cores do tema em runtime.
-- Janelas existentes NÃO são recoloridas (widgets capturam na criação).
function ModernNoir:SetTheme(newTheme)
    if type(newTheme) ~= "table" then return end
    for k, v in pairs(newTheme) do
        if Theme[k] ~= nil and typeof(v) == "Color3" then
            Theme[k] = v
        end
    end
    -- Sincroniza NotifyTypes com o novo tema
    NotifyTypes.info.color    = Theme.NotifyInfo
    NotifyTypes.success.color = Theme.NotifySuccess
    NotifyTypes.warning.color = Theme.NotifyWarning
    NotifyTypes.error.color   = Theme.NotifyError
    NotifyTypes.default.color = Theme.Accent
end

-- ────────────────────────────────────────────────
--  CREATE WINDOW
-- ────────────────────────────────────────────────
function ModernNoir.CreateWindow(opts)
    local title     = type(opts) == "string" and opts or (opts and opts.Title or "Modern Noir")
    local toggleKey = type(opts) == "table"  and opts.ToggleKey or nil

    local sg = Instance.new("ScreenGui")
    sg.Name = "ModernNoir_" .. title
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 100
    sg.IgnoreGuiInset = false
    sg.Parent = GuiParent

    local mf = Instance.new("Frame")
    mf.Name = "MainFrame"
    mf.Size = UDim2.new(0, Config.WindowWidth, 0, Config.WindowHeight)
    mf.AnchorPoint = Vector2.new(0.5, 0.5)
    mf.Position    = UDim2.new(0.5, 0, 0.5, 0)
    mf.BackgroundColor3 = Theme.Background; mf.BorderSizePixel = 0
    mf.ClipsDescendants = true; mf.Parent = sg
    Util.Corner(mf); Util.Stroke(mf, Theme.Border, Config.BorderW)

    local uiScale = Instance.new("UIScale")
    uiScale.Scale  = 1
    uiScale.Parent = mf

    -- Ajuste de escala por viewport
    local vpConn
    local function updateScale()
        local cam = workspace.CurrentCamera
        if not cam then return end
        local vp = cam.ViewportSize
        uiScale.Scale = math.min(vp.X / Config.WindowWidth, vp.Y / Config.WindowHeight, 1)
    end
    updateScale()
    vpConn = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)

    -- Sombra decorativa
    local sh = Instance.new("ImageLabel")
    sh.Size = UDim2.new(1,40,1,40); sh.Position = UDim2.new(0,-20,0,-10)
    sh.BackgroundTransparency = 1; sh.Image = "rbxassetid://6014261993"
    sh.ImageColor3 = Color3.new(0,0,0); sh.ImageTransparency = 0.6
    sh.ScaleType = Enum.ScaleType.Slice; sh.SliceCenter = Rect.new(49,49,450,450)
    sh.ZIndex = -1; sh.Parent = mf

    -- Linha dourada no topo
    local topLine = Instance.new("Frame")
    topLine.Size = UDim2.new(1,0,0,2); topLine.BackgroundColor3 = Theme.Accent
    topLine.BorderSizePixel = 0; topLine.ZIndex = 5; topLine.Parent = mf

    -- Header
    local hdr = Instance.new("Frame")
    hdr.Name = "Header"; hdr.Size = UDim2.new(1,0,0,Config.HeaderHeight)
    hdr.BackgroundColor3 = Theme.Surface; hdr.BorderSizePixel = 0
    hdr.ZIndex = 4; hdr.Parent = mf

    local hdiv = Instance.new("Frame")
    hdiv.Size = UDim2.new(1,0,0,1); hdiv.Position = UDim2.new(0,0,1,0)
    hdiv.BackgroundColor3 = Theme.Border; hdiv.BorderSizePixel = 0; hdiv.Parent = hdr

    local hico = Instance.new("TextLabel")
    hico.Size = UDim2.new(0,Config.HeaderHeight,1,0); hico.Position = UDim2.new(0,32,0,0)
    hico.BackgroundTransparency = 1; hico.Text = "◈"
    hico.Font = Enum.Font.GothamBold; hico.TextSize = 13
    hico.TextColor3 = Theme.Accent; hico.ZIndex = 5; hico.Parent = hdr

    local htitle = Instance.new("TextLabel")
    htitle.Size = UDim2.new(1,-120,1,0); htitle.Position = UDim2.new(0,58,0,0)
    htitle.BackgroundTransparency = 1; htitle.Text = title
    htitle.Font = Enum.Font.GothamSemibold; htitle.TextSize = 13
    htitle.TextColor3 = Theme.TextPrimary
    htitle.TextXAlignment = Enum.TextXAlignment.Left
    htitle.ZIndex = 5; htitle.Parent = hdr

    local closeBtn    = Util.HeaderButton(hdr, UDim2.new(1,-18,0.5,0), Theme.CloseRed,  Theme.CloseRedHover, "×")
    local minimizeBtn = Util.HeaderButton(hdr, UDim2.new(1,-38,0.5,0), Theme.Accent,    Theme.AccentGlow,    "−")

    -- ── Drag suave com Heartbeat ──────────────────────────────
    local dragging   = false
    local dragInput  = nil
    local dragStart  = nil
    local startPos   = nil
    local targetPos  = mf.Position
    local renderConn = nil
    local inputChangedConn = nil

    local function updateDrag(inp)
        local delta = inp.Position - dragStart
        local cam   = workspace.CurrentCamera
        if not cam then return end
        local vp    = cam.ViewportSize
        local halfW = (Config.WindowWidth  * uiScale.Scale) / 2
        local halfH = (Config.WindowHeight * uiScale.Scale) / 2
        local newX  = Util.Clamp(startPos.X.Offset + delta.X, halfW - vp.X/2, vp.X/2 - halfW)
        local newY  = Util.Clamp(startPos.Y.Offset + delta.Y, halfH - vp.Y/2, vp.Y/2 - halfH)
        targetPos   = UDim2.new(0.5, newX, 0.5, newY)
    end

    hdr.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = i.Position
            startPos  = mf.Position

            renderConn = RunService.Heartbeat:Connect(function(dt)
                local alpha = 1 - math.pow(1 - Config.DragSmooth, dt * 60)
                local c     = mf.Position
                local nx    = c.X.Offset + (targetPos.X.Offset - c.X.Offset) * alpha
                local ny    = c.Y.Offset + (targetPos.Y.Offset - c.Y.Offset) * alpha
                mf.Position = UDim2.new(0.5, nx, 0.5, ny)
            end)

            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if renderConn then renderConn:Disconnect(); renderConn = nil end
                end
            end)
        end
    end)

    hdr.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement
            or i.UserInputType == Enum.UserInputType.Touch then
            dragInput = i
        end
    end)

    inputChangedConn = UserInputService.InputChanged:Connect(function(i)
        if dragging and i == dragInput then updateDrag(i) end
    end)

    -- ── Sidebar ───────────────────────────────────────────────
    local sb = Instance.new("Frame")
    sb.Name = "Sidebar"
    sb.Size = UDim2.new(0, Config.SidebarWidth, 1, -(Config.HeaderHeight + 1))
    sb.Position = UDim2.new(0, 0, 0, Config.HeaderHeight + 1)
    sb.BackgroundColor3 = Theme.Surface; sb.BorderSizePixel = 0
    sb.ClipsDescendants = true; sb.Parent = mf

    local sdiv = Instance.new("Frame")
    sdiv.Size = UDim2.new(0,1,1,0); sdiv.Position = UDim2.new(1,0,0,0)
    sdiv.BackgroundColor3 = Theme.Border; sdiv.BorderSizePixel = 0; sdiv.Parent = sb

    -- Search bar
    local searchFrame = Instance.new("Frame")
    searchFrame.Size = UDim2.new(1,-8,0,Config.SearchH)
    searchFrame.Position = UDim2.new(0,4,0,6)
    searchFrame.BackgroundColor3 = Theme.SearchBg; searchFrame.BorderSizePixel = 0
    searchFrame.ZIndex = 3; searchFrame.Parent = sb
    Util.Corner(searchFrame, UDim.new(0,5))
    local searchStroke = Util.Stroke(searchFrame, Theme.SearchBorder, 1)

    local searchIco = Instance.new("TextLabel")
    searchIco.Size = UDim2.new(0,18,1,0); searchIco.Position = UDim2.new(0,4,0,0)
    searchIco.BackgroundTransparency = 1; searchIco.Text = "⌕"
    searchIco.Font = Enum.Font.GothamBold; searchIco.TextSize = 11
    searchIco.TextColor3 = Theme.TextDisabled; searchIco.ZIndex = 4; searchIco.Parent = searchFrame

    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1,-24,1,0); searchBox.Position = UDim2.new(0,20,0,0)
    searchBox.BackgroundTransparency = 1
    searchBox.Text = ""
    searchBox.PlaceholderText = "Buscar..."
    searchBox.PlaceholderColor3 = Theme.TextDisabled
    searchBox.Font = Enum.Font.Gotham; searchBox.TextSize = 10
    searchBox.TextColor3 = Theme.TextSecondary
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.ClearTextOnFocus = false
    searchBox.ZIndex = 4; searchBox.Parent = searchFrame

    searchBox.Focused:Connect(function()
        Util.Tween(searchStroke, Config.TweenFast, {Color = Theme.Accent})
        Util.Tween(searchIco,    Config.TweenFast, {TextColor3 = Theme.Accent})
    end)
    searchBox.FocusLost:Connect(function()
        if searchBox.Text == "" then
            Util.Tween(searchStroke, Config.TweenFast, {Color = Theme.SearchBorder})
            Util.Tween(searchIco,    Config.TweenFast, {TextColor3 = Theme.TextDisabled})
        end
    end)

    local sidebarTopOffset = Config.SearchH + 12

    local sbScroll = Instance.new("ScrollingFrame")
    sbScroll.Size = UDim2.new(1,-1,1,-(sidebarTopOffset + 28))
    sbScroll.Position = UDim2.new(0,0,0,sidebarTopOffset)
    sbScroll.BackgroundTransparency = 1; sbScroll.BorderSizePixel = 0
    sbScroll.ScrollBarThickness = 0
    sbScroll.CanvasSize = UDim2.new(0,0,0,0)
    sbScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sbScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    sbScroll.ClipsDescendants = true
    sbScroll.Parent = sb

    local tList = Instance.new("UIListLayout")
    tList.SortOrder = Enum.SortOrder.LayoutOrder
    tList.Padding = UDim.new(0,3); tList.Parent = sbScroll

    local sPad = Instance.new("UIPadding")
    sPad.PaddingTop   = UDim.new(0,4); sPad.PaddingLeft  = UDim.new(0,0)
    sPad.PaddingRight = UDim.new(0,6); sPad.Parent = sbScroll

    local brandFrame = Instance.new("Frame")
    brandFrame.Size = UDim2.new(1,-1,0,28); brandFrame.Position = UDim2.new(0,0,1,-28)
    brandFrame.BackgroundColor3 = Theme.Surface; brandFrame.BorderSizePixel = 0
    brandFrame.ZIndex = 2; brandFrame.Parent = sb

    local brand = Instance.new("TextLabel")
    brand.Size = UDim2.new(1,0,1,0)
    brand.BackgroundTransparency = 1
    brand.Text = "◈ v" .. ModernNoir._Version
    brand.Font = Enum.Font.Gotham; brand.TextSize = 9
    brand.TextColor3 = Theme.AccentDim
    brand.TextXAlignment = Enum.TextXAlignment.Center
    brand.Parent = brandFrame

    -- ── Content ───────────────────────────────────────────────
    local cf = Instance.new("Frame")
    cf.Name = "Content"
    cf.Size = UDim2.new(1, -Config.SidebarWidth, 1, -(Config.HeaderHeight + 1))
    cf.Position = UDim2.new(0, Config.SidebarWidth, 0, Config.HeaderHeight + 1)
    cf.BackgroundColor3 = Theme.Background; cf.BorderSizePixel = 0
    cf.ClipsDescendants = true; cf.Parent = mf

    -- Animação de entrada
    local targetScale = uiScale.Scale
    uiScale.Scale = 0.88
    mf.BackgroundTransparency = 1
    TweenService:Create(uiScale, Config.TweenMedium, {Scale = targetScale}):Play()
    TweenService:Create(mf,      Config.TweenMedium, {BackgroundTransparency = 0}):Play()

    -- Toggle de visibilidade por tecla
    local visible    = true
    local toggleConn = nil

    if toggleKey then
        toggleConn = UserInputService.InputBegan:Connect(function(inp, gameProcessed)
            if gameProcessed then return end
            if inp.KeyCode == toggleKey then
                visible    = not visible
                mf.Visible = visible
            end
        end)
    end

    -- ── Registro de abas para filtro de search ────────────────
    -- OTIMIZAÇÃO: 1 única conexão no searchBox, centralizada na window
    local _tabRegistry = {}  -- {button = tbtn, name = name}

    local searchConn = searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = searchBox.Text:lower()
        for _, entry in ipairs(_tabRegistry) do
            if query == "" then
                entry.button.Visible = true
            else
                entry.button.Visible = entry.name:lower():find(query, 1, true) ~= nil
            end
        end
    end)

    -- ── Destroy centralizado ──────────────────────────────────
    local destroyed = false
    local function doDestroy()
        if destroyed then return end
        destroyed = true

        -- Desconecta todas as conexões da window
        inputChangedConn:Disconnect()
        searchConn:Disconnect()
        vpConn:Disconnect()
        if renderConn  then renderConn:Disconnect();  renderConn  = nil end
        if toggleConn  then toggleConn:Disconnect();  toggleConn  = nil end

        -- Fecha dropdowns/pickers abertos pertencentes a esta window
        if _openDropdownClose then _openDropdownClose(); _openDropdownClose = nil end
        if _openPickerClose   then _openPickerClose();   _openPickerClose   = nil end

        -- Remove da lista global
        for i, w in ipairs(ModernNoir._Windows) do
            if w == Window then table.remove(ModernNoir._Windows, i); break end
        end

        table.clear(_tabRegistry)

        Util.Tween(mf, Config.TweenFast, {BackgroundTransparency = 1})
        task.delay(Config.TweenFast.Time + 0.05, function()
            if sg.Parent then sg:Destroy() end
        end)
    end

    closeBtn.MouseButton1Click:Connect(doDestroy)

    -- Minimize/restore
    local minimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            TweenService:Create(mf, Config.TweenMedium, {Size = UDim2.new(0, Config.WindowWidth, 0, Config.MinimizeH)}):Play()
            TweenService:Create(sb, Config.TweenFast,   {BackgroundTransparency = 1}):Play()
            TweenService:Create(cf, Config.TweenFast,   {BackgroundTransparency = 1}):Play()
        else
            TweenService:Create(mf, Config.TweenMedium, {Size = UDim2.new(0, Config.WindowWidth, 0, Config.WindowHeight)}):Play()
            TweenService:Create(sb, Config.TweenMedium, {BackgroundTransparency = 0}):Play()
            TweenService:Create(cf, Config.TweenMedium, {BackgroundTransparency = 0}):Play()
        end
    end)

    -- ── Window API pública ────────────────────────────────────
    local Window = {}
    Window.Frame      = mf
    Window.Sidebar    = sb
    Window.Content    = cf
    Window._Tabs      = {}
    Window._ActiveTab = nil

    function Window:Destroy()     doDestroy() end
    function Window:SetVisible(v) visible = v; mf.Visible = v end
    function Window:SetTitle(t)   htitle.Text = t or "" end

    function Window:AddTab(name, iconID)
        name = name or ("Aba " .. (#self._Tabs + 1))
        local idx = #self._Tabs + 1

        local tbtn = Instance.new("TextButton")
        tbtn.Size = UDim2.new(1,0,0,Config.TabH)
        tbtn.BackgroundColor3 = Theme.Surface; tbtn.BorderSizePixel = 0
        tbtn.Text = ""; tbtn.AutoButtonColor = false
        tbtn.LayoutOrder = idx; tbtn.ClipsDescendants = false
        tbtn.Parent = sbScroll
        Util.Corner(tbtn, UDim.new(0,5))

        local ind = Instance.new("Frame")
        ind.AnchorPoint = Vector2.new(0,0.5)
        ind.Size = UDim2.new(0, Config.TabIndW, 1, -10)
        ind.Position = UDim2.new(0,0,0.5,0)
        ind.BackgroundColor3 = Theme.Accent; ind.BackgroundTransparency = 0.5
        ind.BorderSizePixel = 0; ind.ZIndex = 2; ind.Parent = tbtn
        Util.Corner(ind, UDim.new(0,2))

        local tIco = Instance.new("ImageLabel")
        tIco.Size = UDim2.new(0,14,0,14); tIco.Position = UDim2.new(0,14,0.5,-7)
        tIco.BackgroundTransparency = 1; tIco.ZIndex = 3

        local iconIDValid = iconID and tostring(iconID) ~= "" and tostring(iconID) ~= "0"
        if iconIDValid then
            tIco.Image = "rbxassetid://" .. tostring(iconID)
            tIco.ImageColor3 = Theme.TextSecondary
        else
            tIco.Image = ""
            local itxt = Instance.new("TextLabel")
            itxt.Size = UDim2.new(1,0,1,0); itxt.BackgroundTransparency = 1
            itxt.Text = "◆"; itxt.Font = Enum.Font.GothamBold; itxt.TextSize = 9
            itxt.TextColor3 = Theme.TextSecondary; itxt.ZIndex = 4; itxt.Parent = tIco
        end
        tIco.Parent = tbtn

        local tlbl = Instance.new("TextLabel")
        tlbl.Size = UDim2.new(1,-36,1,0); tlbl.Position = UDim2.new(0,34,0,0)
        tlbl.BackgroundTransparency = 1; tlbl.Text = name
        tlbl.Font = Enum.Font.GothamSemibold; tlbl.TextSize = 11
        tlbl.TextColor3 = Theme.TextSecondary
        tlbl.TextXAlignment = Enum.TextXAlignment.Left
        tlbl.ZIndex = 3; tlbl.Parent = tbtn

        tbtn.MouseEnter:Connect(function()
            if self._ActiveTab and self._ActiveTab._Button == tbtn then return end
            Util.Tween(tbtn, Config.TweenFast, {BackgroundColor3 = Theme.SurfaceHover})
            Util.Tween(tlbl, Config.TweenFast, {TextColor3 = Theme.TextPrimary})
        end)
        tbtn.MouseLeave:Connect(function()
            if self._ActiveTab and self._ActiveTab._Button == tbtn then return end
            Util.Tween(tbtn, Config.TweenFast, {BackgroundColor3 = Theme.Surface})
            Util.Tween(tlbl, Config.TweenFast, {TextColor3 = Theme.TextSecondary})
        end)

        -- OTIMIZAÇÃO: registra aba no _tabRegistry para ser filtrada pela conexão central
        table.insert(_tabRegistry, {button = tbtn, name = name})

        local canvas = Instance.new("CanvasGroup")
        canvas.Size = UDim2.new(1,0,1,0)
        canvas.BackgroundTransparency = 1; canvas.GroupTransparency = 1
        canvas.BorderSizePixel = 0; canvas.Visible = false; canvas.ZIndex = 2
        canvas.Parent = cf

        local scrl = Instance.new("ScrollingFrame")
        scrl.Size = UDim2.new(1,0,1,0)
        scrl.BackgroundTransparency = 1; scrl.BorderSizePixel = 0
        scrl.CanvasSize = UDim2.new(0,0,0,0)
        scrl.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scrl.ScrollBarThickness = Config.ScrollBarW
        scrl.ScrollBarImageColor3 = Theme.ScrollBar
        scrl.ScrollingDirection = Enum.ScrollingDirection.Y
        scrl.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
        scrl.ZIndex = 3; scrl.Parent = canvas

        local sp = Instance.new("UIPadding")
        sp.PaddingTop    = UDim.new(0,8);  sp.PaddingBottom = UDim.new(0,12)
        sp.PaddingLeft   = UDim.new(0,10); sp.PaddingRight  = UDim.new(0,14)
        sp.Parent = scrl

        local wList = Instance.new("UIListLayout")
        wList.SortOrder = Enum.SortOrder.LayoutOrder
        wList.Padding = UDim.new(0, Config.WidgetGap)
        wList.FillDirection = Enum.FillDirection.Vertical
        wList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        wList.Parent = scrl

        scrl.MouseEnter:Connect(function()
            Util.Tween(scrl, Config.TweenFast, {ScrollBarImageColor3 = Theme.ScrollBarHover})
        end)
        scrl.MouseLeave:Connect(function()
            Util.Tween(scrl, Config.TweenFast, {ScrollBarImageColor3 = Theme.ScrollBar})
        end)

        local Tab = {}
        Tab.Name        = name
        Tab.ScrollFrame = scrl
        Tab._Canvas     = canvas
        Tab._Button     = tbtn
        Tab._Label      = tlbl
        Tab._Ind        = ind
        Tab._Window     = self
        Tab._Count      = 0

        function Tab:Select() SwitchTab(self._Window, self) end

        tbtn.MouseButton1Click:Connect(function()
            SwitchTab(self, Tab)
        end)

        -- Métodos de adição de widgets
        function Tab:AddButton(ltext, lcb)
            self._Count += 1
            return Widgets.Button(self.ScrollFrame, ltext, self._Count, lcb)
        end
        function Tab:AddToggle(ltext, ldefault, lcb)
            self._Count += 1
            return Widgets.Toggle(self.ScrollFrame, ltext, ldefault, self._Count, lcb)
        end
        function Tab:AddSlider(ltext, lmin, lmax, ldef, lcb)
            self._Count += 1
            return Widgets.Slider(self.ScrollFrame, ltext, lmin, lmax, ldef, self._Count, lcb)
        end
        function Tab:AddSection(ltext)
            self._Count += 1
            return Widgets.Section(self.ScrollFrame, ltext, self._Count)
        end
        function Tab:AddSeparator()
            self._Count += 1
            return Widgets.Separator(self.ScrollFrame, self._Count)
        end
        function Tab:AddLabel(ltext)
            self._Count += 1
            return Widgets.Label(self.ScrollFrame, ltext, self._Count)
        end
        function Tab:AddTextbox(ltext, lplaceholder, ldefault, lcb)
            self._Count += 1
            return Widgets.Textbox(self.ScrollFrame, ltext, lplaceholder, ldefault, self._Count, lcb)
        end
        function Tab:AddDropdown(ltext, loptions, ldefault, lcb)
            self._Count += 1
            return Widgets.Dropdown(self.ScrollFrame, ltext, loptions, ldefault, self._Count, lcb)
        end
        function Tab:AddKeybind(ltext, ldefault, lcb)
            self._Count += 1
            return Widgets.Keybind(self.ScrollFrame, ltext, ldefault, self._Count, lcb)
        end
        function Tab:AddProgressBar(ltext, lvalue)
            self._Count += 1
            return Widgets.ProgressBar(self.ScrollFrame, ltext, lvalue, self._Count)
        end
        function Tab:AddColorPicker(ltext, ldefault, lcb)
            self._Count += 1
            return Widgets.ColorPicker(self.ScrollFrame, ltext, ldefault, self._Count, lcb)
        end

        table.insert(self._Tabs, Tab)

        -- Seleciona automaticamente a primeira aba criada
        if #self._Tabs == 1 then
            task.delay(Config.TweenMedium.Time, function()
                SwitchTab(self, Tab)
            end)
        end

        return Tab
    end

    table.insert(ModernNoir._Windows, Window)
    return Window
end

return ModernNoir
