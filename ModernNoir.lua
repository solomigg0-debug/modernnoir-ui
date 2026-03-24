-- ════════════════════════════════════════════════
--  SERVIÇOS
-- ════════════════════════════════════════════════
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local function getContainer()
    if gethui then return gethui() end
    local ok, cg = pcall(game.GetService, game, "CoreGui")
    if ok and cg then return cg end
    return LocalPlayer:WaitForChild("PlayerGui", 10) or error("ModernNoir: container not found")
end
local GuiParent = getContainer()

-- ════════════════════════════════════════════════
--  PALETA
-- ════════════════════════════════════════════════
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
}

-- ════════════════════════════════════════════════
--  CONFIG
-- ════════════════════════════════════════════════
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
}

-- ════════════════════════════════════════════════
--  UTILITÁRIOS
-- ════════════════════════════════════════════════
local Util = {}

-- FIX: _activeTweens para cancelar tweens anteriores no mesmo objeto
local _activeTweens = {}

function Util.Tween(obj, info, props)
    local key = tostring(obj)
    if _activeTweens[key] then
        _activeTweens[key]:Cancel()
    end
    local t = TweenService:Create(obj, info, props)
    _activeTweens[key] = t
    t:Play()
    t.Completed:Connect(function()
        if _activeTweens[key] == t then
            _activeTweens[key] = nil
        end
    end)
    return t
end

-- FIX: clamp dentro de Util por consistência
function Util.Clamp(v, lo, hi)
    return math.max(lo, math.min(hi, v))
end

function Util.Corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = r or Config.Corner
    c.Parent = obj
    return c
end

function Util.Stroke(obj, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color           = color     or Theme.Border
    s.Thickness       = thickness or Config.BorderW
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = obj
    return s
end

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

-- ════════════════════════════════════════════════
--  WIDGETS
-- ════════════════════════════════════════════════
local Widgets = {}

-- ────────────────────────────────────────────────
--  BUTTON
-- ────────────────────────────────────────────────
function Widgets.Button(scroll, text, order, cb)
    local wrap = Instance.new("Frame")
    wrap.Size = UDim2.new(1,0,0,Config.WidgetH)
    wrap.BackgroundTransparency = 1; wrap.BorderSizePixel = 0
    wrap.LayoutOrder = order; wrap.Parent = scroll

    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,1,0)
    f.BackgroundColor3 = Theme.WidgetBg; f.BorderSizePixel = 0
    f.Parent = wrap
    Util.Corner(f, Config.WidgetCorner)
    local stroke = Util.Stroke(f, Theme.Border, Config.WidgetBorderW)

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
        Util.Tween(scale, tRelease, {Scale = 1})
        Util.Tween(f,     tRelease, {BackgroundColor3 = hovered and Theme.WidgetBgHover or Theme.WidgetBg})
        Util.Tween(stroke,tRelease, {Color = hovered and Theme.Accent or Theme.Border})
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
        Util.Tween(lbl,   Config.TweenFast, {TextColor3 = e and Theme.TextPrimary or Theme.TextDisabled})
        Util.Tween(stroke,Config.TweenFast, {Color = e and Theme.Border or Theme.TextDisabled})
    end
    return obj
end

-- ────────────────────────────────────────────────
--  TOGGLE
-- ────────────────────────────────────────────────
function Widgets.Toggle(scroll, text, default, order, cb)
    local state = (default == true)

    local wrap = Instance.new("Frame")
    wrap.Size = UDim2.new(1,0,0,Config.WidgetH)
    wrap.BackgroundTransparency = 1; wrap.BorderSizePixel = 0
    wrap.LayoutOrder = order; wrap.Parent = scroll

    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,1,0)
    f.BackgroundColor3 = Theme.WidgetBg; f.BorderSizePixel = 0
    f.Parent = wrap
    Util.Corner(f, Config.WidgetCorner)
    Util.Stroke(f, Theme.Border, Config.WidgetBorderW)

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

    local toggleWidth  = Config.ToggleW
    local toggleHeight = Config.ToggleH

    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, toggleWidth, 0, toggleHeight)
    track.Position = UDim2.new(1, -(toggleWidth + 10), 0.5, -toggleHeight / 2)
    track.BackgroundColor3 = state and Theme.Accent or Theme.ToggleOffTrack
    track.BorderSizePixel = 0; track.ZIndex = 3; track.Parent = f
    Util.Corner(track, UDim.new(1,0))
    local trackStroke = Util.Stroke(track, Theme.Accent, Config.WidgetBorderW)
    trackStroke.Transparency = state and 0 or 1

    local knobSize = Config.KnobSize
    local knobPad  = Config.KnobPad
    local knobOffX = knobPad
    local knobOnX  = toggleWidth - knobSize - knobPad

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, knobSize, 0, knobSize)
    knob.Position = UDim2.new(0, state and knobOnX or knobOffX, 0.5, -knobSize / 2)
    knob.BackgroundColor3 = state and Theme.ToggleKnobOn or Theme.ToggleKnob
    knob.BorderSizePixel = 0; knob.ZIndex = 5; knob.Parent = track
    Util.Corner(knob, UDim.new(1,0))

    local function apply(s, animate)
        local tweenMove  = animate and Config.ToggleMoveT  or TweenInfo.new(0)
        local tweenColor = animate and Config.ToggleColorT or TweenInfo.new(0)
        if s then
            Util.Tween(track,       tweenColor, {BackgroundColor3 = Theme.Accent})
            Util.Tween(trackStroke, tweenColor, {Transparency = 0})
            Util.Tween(knob, tweenMove, {
                Position         = UDim2.new(0, knobOnX, 0.5, -knobSize / 2),
                BackgroundColor3 = Theme.ToggleKnobOn,
            })
            Util.Tween(sico, tweenColor, {TextColor3 = Theme.Accent})
            sico.Text = "●"
        else
            Util.Tween(track,       tweenColor, {BackgroundColor3 = Theme.ToggleOffTrack})
            Util.Tween(trackStroke, tweenColor, {Transparency = 1})
            Util.Tween(knob, tweenMove, {
                Position         = UDim2.new(0, knobOffX, 0.5, -knobSize / 2),
                BackgroundColor3 = Theme.ToggleKnob,
            })
            Util.Tween(sico, tweenColor, {TextColor3 = Theme.TextDisabled})
            sico.Text = "○"
        end
    end
    apply(state, false)

    local hit = Instance.new("TextButton")
    hit.Size = UDim2.new(1,0,1,0); hit.BackgroundTransparency = 1
    hit.Text = ""; hit.ZIndex = 6; hit.AutoButtonColor = false; hit.Parent = f

    -- FIX: hover consistente em ambos os estados
    hit.MouseEnter:Connect(function()
        Util.Tween(f, Config.TweenFast, {BackgroundColor3 = Theme.WidgetBgHover})
    end)
    hit.MouseLeave:Connect(function()
        Util.Tween(f, Config.TweenFast, {BackgroundColor3 = Theme.WidgetBg})
    end)
    hit.MouseButton1Click:Connect(function()
        state = not state
        apply(state, true)
        if cb then pcall(cb, state) end
    end)

    local obj = {}
    function obj:GetState() return state end
    function obj:SetState(s, silent)
        state = s; apply(state, true)
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
    local value = default

    local wrap = Instance.new("Frame")
    wrap.Size = UDim2.new(1,0,0,Config.SliderH)
    wrap.BackgroundTransparency = 1; wrap.BorderSizePixel = 0
    wrap.LayoutOrder = order; wrap.Parent = scroll

    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,1,0)
    f.BackgroundColor3 = Theme.WidgetBg; f.BorderSizePixel = 0
    f.Parent = wrap
    Util.Corner(f, Config.WidgetCorner)
    Util.Stroke(f, Theme.Border, Config.WidgetBorderW)

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
    valLbl.Text = tostring(math.round(value))
    valLbl.Font = Enum.Font.GothamBold; valLbl.TextSize = 11
    valLbl.TextColor3 = Theme.Accent
    valLbl.TextXAlignment = Enum.TextXAlignment.Center
    valLbl.ZIndex = 3; valLbl.Parent = badge

    local trackHeight = Config.SliderTrackH

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1,0,0,trackHeight)
    track.Position = UDim2.new(0,0,0,20)
    track.BackgroundColor3 = Theme.SliderTrack
    track.BorderSizePixel = 0; track.ZIndex = 2; track.Parent = f
    Util.Corner(track, UDim.new(1,0))

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0,0,1,0)
    fill.BackgroundColor3 = Theme.Accent
    fill.BorderSizePixel = 0; fill.ZIndex = 3; fill.Parent = track
    Util.Corner(fill, UDim.new(1,0))

    local knobSize = Config.SliderKnobS

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, knobSize, 0, knobSize)
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
        local ratio = (value - minV) / (maxV - minV)
        fill.Size     = UDim2.new(ratio, 0, 1, 0)
        knob.Position = UDim2.new(ratio, 0, 0.5, 0)
        valLbl.Text   = tostring(math.round(value))
    end
    applyValue(value)

    local hitbox = Instance.new("TextButton")
    hitbox.Size = UDim2.new(1,0,0, trackHeight + 20)
    hitbox.Position = UDim2.new(0,0,0,10)
    hitbox.BackgroundTransparency = 1; hitbox.Text = ""
    hitbox.ZIndex = 7; hitbox.AutoButtonColor = false; hitbox.Parent = f

    local dragging  = false
    local moveConn  = nil
    local endedConn = nil

    local isInt = (math.floor(minV) == minV) and (math.floor(maxV) == maxV)

    local function applyFromX(absX)
        local trackWidth = track.AbsoluteSize.X
        if trackWidth == 0 then return end
        local relX = Util.Clamp(absX - track.AbsolutePosition.X, 0, trackWidth)
        local v = minV + (relX / trackWidth) * (maxV - minV)
        v = isInt and math.round(v) or (math.floor(v * 100 + 0.5) / 100)
        v = Util.Clamp(v, minV, maxV)
        if v ~= value then
            applyValue(v)
            if cb then pcall(cb, value) end
        end
    end

    -- FIX: cleanup das conexões se widget for destruído durante drag
    local function cleanupDrag()
        dragging = false
        if moveConn  then moveConn:Disconnect();  moveConn  = nil end
        if endedConn then endedConn:Disconnect(); endedConn = nil end
    end

    wrap.AncestryChanged:Connect(function()
        if not wrap.Parent then
            cleanupDrag()
        end
    end)

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

        moveConn = UserInputService.InputChanged:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseMovement then
                applyFromX(inp.Position.X)
            end
        end)

        endedConn = UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                cleanupDrag()
                Util.Tween(knob,       Config.TweenFast, {BackgroundColor3 = Theme.SliderKnob})
                Util.Tween(knobStroke, Config.TweenFast, {Color = Theme.Accent, Thickness = 1.5})
                Util.Tween(f,          Config.TweenFast, {BackgroundColor3 = Theme.WidgetBg})
            end
        end)
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

-- ════════════════════════════════════════════════
--  NOTIFICAÇÕES
-- ════════════════════════════════════════════════
local _notifyGui   = nil
local _notifyStack = {}

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
    -- FIX: verificação de CurrentCamera antes de acessar ViewportSize
    local cam = workspace.CurrentCamera
    if not cam then return end
    local vp  = cam.ViewportSize
    local cumY = Config.NotifyPadB

    for i = #_notifyStack, 1, -1 do
        local entry = _notifyStack[i]
        if entry and entry.card and entry.card.Parent then
            local h       = Config.NotifyH
            local targetY = vp.Y - cumY - h
            local targetX = vp.X - Config.NotifyW - Config.NotifyPadR
            Util.Tween(entry.card, Config.TweenMedium, {
                Position = UDim2.new(0, targetX, 0, targetY)
            })
            entry.targetY = targetY
            cumY = cumY + h + Config.NotifyGap
        end
    end
end

local function createNotify(title, body, duration)
    local ng  = getNotifyGui()
    -- FIX: verificação de CurrentCamera
    local cam = workspace.CurrentCamera
    if not cam then return end
    local vp  = cam.ViewportSize

    local w    = Config.NotifyW
    local h    = Config.NotifyH
    local padR = Config.NotifyPadR
    local padB = Config.NotifyPadB

    local card = Instance.new("Frame")
    card.Name             = "NotifyCard"
    card.Size             = UDim2.new(0, w, 0, h)
    card.Position         = UDim2.new(0, vp.X + w + 10, 0, vp.Y - padB - h)
    card.BackgroundColor3 = Theme.NotifyBg
    card.BorderSizePixel  = 0
    card.ClipsDescendants = true
    card.ZIndex           = 10
    card.Parent           = ng
    Util.Corner(card, UDim.new(0,8))
    Util.Stroke(card, Theme.Border, 1)

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0,3,1,0)
    accentBar.BackgroundColor3 = Theme.Accent; accentBar.BorderSizePixel = 0
    accentBar.ZIndex = 11; accentBar.Parent = card
    Util.Corner(accentBar, UDim.new(0,2))

    local ico = Instance.new("TextLabel")
    ico.Size = UDim2.new(0,18,0,18); ico.Position = UDim2.new(0,12,0,10)
    ico.BackgroundTransparency = 1; ico.Text = "◈"
    ico.Font = Enum.Font.GothamBold; ico.TextSize = 13
    ico.TextColor3 = Theme.Accent; ico.ZIndex = 12; ico.Parent = card

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
    barFill.BackgroundColor3 = Theme.Accent; barFill.BorderSizePixel = 0
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
            Position = UDim2.new(0, vp.X - w - padR, 0, entry.targetY or vp.Y - padB - h)
        })
    end)

    local dur = duration or Config.NotifyDur
    local barInfo = TweenInfo.new(dur, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    task.delay(Config.NotifySlideT * 0.6, function()
        if barFill.Parent then
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
        -- FIX: guarda referência local antes do Completed disparar
        local prevCanvas = prev._Canvas
        fo.Completed:Connect(function()
            if prevCanvas and prevCanvas.Parent then
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
--  LIBRARY
-- ════════════════════════════════════════════════
local ModernNoir = {}
ModernNoir._Version = "0.1.0"
ModernNoir._Windows = {}

function ModernNoir:Notify(title, text, duration)
    createNotify(title, text, duration)
end

function ModernNoir.CreateWindow(title)

    local sg = Instance.new("ScreenGui")
    sg.Name = "ModernNoir_" .. (title or "Window")
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

    local function updateScale()
        local cam = workspace.CurrentCamera
        if not cam then return end
        local vp = cam.ViewportSize
        uiScale.Scale = math.min(vp.X / Config.WindowWidth, vp.Y / Config.WindowHeight, 1)
    end
    updateScale()
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)

    -- Sombra
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
    htitle.BackgroundTransparency = 1; htitle.Text = title or "Modern Noir"
    htitle.Font = Enum.Font.GothamSemibold; htitle.TextSize = 13
    htitle.TextColor3 = Theme.TextPrimary
    htitle.TextXAlignment = Enum.TextXAlignment.Left
    htitle.ZIndex = 5; htitle.Parent = hdr

    local closeBtn    = Util.HeaderButton(hdr, UDim2.new(1,-18,0.5,0), Theme.CloseRed,  Theme.CloseRedHover, "×")
    local minimizeBtn = Util.HeaderButton(hdr, UDim2.new(1,-38,0.5,0), Theme.Accent,    Theme.AccentGlow,    "−")

    -- ── Drag suave ───────────────────────────────────────────
    local dragging  = false
    local dragInput = nil
    local dragStart = nil
    local startPos  = nil
    local targetPos = mf.Position

    local function updateDrag(inp)
        local delta = inp.Position - dragStart
        local cam   = workspace.CurrentCamera
        if not cam then return end
        local vp = cam.ViewportSize
        local halfW = (Config.WindowWidth  * uiScale.Scale) / 2
        local halfH = (Config.WindowHeight * uiScale.Scale) / 2
        local newX  = Util.Clamp(startPos.X.Offset + delta.X, halfW - vp.X/2, vp.X/2 - halfW)
        local newY  = Util.Clamp(startPos.Y.Offset + delta.Y, halfH - vp.Y/2, vp.Y/2 - halfH)
        targetPos   = UDim2.new(0.5, newX, 0.5, newY)
    end

    -- FIX: renderConn só existe durante o drag, não eternamente
    local renderConn = nil

    hdr.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = i.Position
            startPos  = mf.Position

            -- FIX: Heartbeat com delta time para lerp frame-rate independent
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
                    if renderConn then
                        renderConn:Disconnect()
                        renderConn = nil
                    end
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

    -- FIX: uiChangedConn guardado junto com as outras conexões para cleanup centralizado
    local uiChangedConn = UserInputService.InputChanged:Connect(function(i)
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

    local sbScroll = Instance.new("ScrollingFrame")
    sbScroll.Size = UDim2.new(1,-1,1,-28)
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
    sPad.PaddingTop   = UDim.new(0,10); sPad.PaddingLeft  = UDim.new(0,0)
    sPad.PaddingRight = UDim.new(0,6);  sPad.Parent = sbScroll

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

    -- animação de entrada via UIScale em vez de Size (não conflita com o sistema de responsividade)
    -- guarda o scale alvo calculado por updateScale() antes de sobrescrever
    local targetScale = uiScale.Scale
    uiScale.Scale = 0.88
    mf.BackgroundTransparency = 1
    TweenService:Create(uiScale, Config.TweenMedium, {Scale = targetScale}):Play()
    TweenService:Create(mf,      Config.TweenMedium, {BackgroundTransparency = 0}):Play()

    -- ── Destroy centralizado ──────────────────────────────────
    local destroyed = false
    local function doDestroy()
        if destroyed then return end
        destroyed = true

        -- FIX: todas as conexões globais desconectadas aqui
        uiChangedConn:Disconnect()
        if renderConn then renderConn:Disconnect(); renderConn = nil end

        -- FIX: remove da lista _Windows
        for i, w in ipairs(ModernNoir._Windows) do
            if w == Window then table.remove(ModernNoir._Windows, i); break end
        end

        Util.Tween(mf, Config.TweenFast, {BackgroundTransparency = 1})
        task.delay(Config.TweenFast.Time + 0.05, function()
            if sg.Parent then sg:Destroy() end
        end)
    end

    closeBtn.MouseButton1Click:Connect(doDestroy)

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

    -- ── Window ────────────────────────────────────────────────
    local Window = {}
    Window.Frame      = mf
    Window.Sidebar    = sb
    Window.Content    = cf
    Window._Tabs      = {}
    Window._ActiveTab = nil

    function Window:Destroy() doDestroy() end

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

        -- FIX: validação mais robusta de iconID
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

        function Tab:AddButton(text, cb)
            self._Count += 1
            return Widgets.Button(self.ScrollFrame, text, self._Count, cb)
        end

        function Tab:AddToggle(text, default, cb)
            self._Count += 1
            return Widgets.Toggle(self.ScrollFrame, text, default, self._Count, cb)
        end

        function Tab:AddSlider(text, minV, maxV, def, cb)
            self._Count += 1
            return Widgets.Slider(self.ScrollFrame, text, minV, maxV, def, self._Count, cb)
        end

        table.insert(self._Tabs, Tab)

        if #self._Tabs == 1 then
            task.delay(Config.TweenMedium.Time, function()
                SwitchTab(self, Tab)
            end)
        end

        return Tab
    end

    -- FIX: insere na lista depois que Window está definido
    table.insert(ModernNoir._Windows, Window)
    return Window
end

return ModernNoir
