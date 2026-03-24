-- ════════════════════════════════════════════════
--  ModernNoir UI Library v0.3.2
--  Executores Roblox: gethui / CoreGui / PlayerGui
--  Zero memory leaks | Alpha no ColorPicker | Show/Hide animados
-- ════════════════════════════════════════════════

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local LocalPlayer      = Players.LocalPlayer

local function getContainer()
    if gethui then return gethui() end
    local ok, cg = pcall(game.GetService, game, "CoreGui")
    if ok and cg then return cg end
    return LocalPlayer:WaitForChild("PlayerGui", 10) or error("ModernNoir: container not found")
end
local GuiParent = getContainer()

-- ── TEMA ─────────────────────────────────────────────────────────────────────
local Theme = {
    Background     = Color3.fromHex("#1A1C1E"), Surface        = Color3.fromHex("#22252A"),
    SurfaceAlt     = Color3.fromHex("#2A2E33"), SurfaceHover   = Color3.fromHex("#2E323A"),
    Border         = Color3.fromHex("#32363A"), Accent         = Color3.fromHex("#D4AF37"),
    AccentDim      = Color3.fromHex("#9E8229"), AccentGlow     = Color3.fromHex("#F0CE5E"),
    TextPrimary    = Color3.fromHex("#E8E6E1"), TextSecondary  = Color3.fromHex("#9A9590"),
    TextDisabled   = Color3.fromHex("#555555"), CloseRed       = Color3.fromHex("#C0392B"),
    CloseRedHover  = Color3.fromHex("#E74C3C"), ScrollBar      = Color3.fromHex("#3E4248"),
    ScrollBarHover = Color3.fromHex("#D4AF37"), WidgetBg       = Color3.fromHex("#212427"),
    WidgetBgHover  = Color3.fromHex("#272B2F"), WidgetBgPress  = Color3.fromHex("#1C1F22"),
    ToggleOffTrack = Color3.fromHex("#252930"), ToggleKnob     = Color3.fromHex("#D0CEC9"),
    ToggleKnobOn   = Color3.fromHex("#FFFFFF"), SliderTrack    = Color3.fromHex("#252930"),
    SliderKnob     = Color3.fromHex("#F0CE5E"), NotifyBg       = Color3.fromHex("#1E2124"),
    NotifyBarBg    = Color3.fromHex("#2A2E33"), NotifySuccess  = Color3.fromHex("#27AE60"),
    NotifyError    = Color3.fromHex("#C0392B"), NotifyWarning  = Color3.fromHex("#E67E22"),
    NotifyInfo     = Color3.fromHex("#2980B9"), SectionLine    = Color3.fromHex("#2A2E33"),
    SectionText    = Color3.fromHex("#6B6560"), InputBg        = Color3.fromHex("#191C1F"),
    InputBorder    = Color3.fromHex("#32363A"), InputText      = Color3.fromHex("#E8E6E1"),
    DropdownArrow  = Color3.fromHex("#9A9590"), KeybindBg      = Color3.fromHex("#191C1F"),
    KeybindBorder  = Color3.fromHex("#32363A"), KeybindActive  = Color3.fromHex("#D4AF37"),
    ProgressTrack  = Color3.fromHex("#252930"), ProgressFill   = Color3.fromHex("#D4AF37"),
    PickerBorder   = Color3.fromHex("#32363A"), SearchBg       = Color3.fromHex("#191C1F"),
    SearchBorder   = Color3.fromHex("#2A2E33"),
}

-- ── CONFIG ────────────────────────────────────────────────────────────────────
local Config = {
    WindowWidth = 620, WindowHeight = 420, HeaderHeight = 38,
    SidebarWidth = 140, Corner = UDim.new(0,8), BorderW = 1.5,
    DragSmooth = 0.12, MinimizeH = 38,

    TweenFast   = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    TweenMedium = TweenInfo.new(0.30, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    TweenShow   = TweenInfo.new(0.25, Enum.EasingStyle.Back,  Enum.EasingDirection.Out),
    TweenHide   = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In),

    TabH=34, TabIndW=2, TabIndActive=3, TabFadeT=0.20, TabIndT=0.22, ScrollBarW=3,
    WidgetH=36, WidgetCorner=UDim.new(0,8), WidgetBorderW=1,
    PressScale=0.97, PressT=0.10, ReleaseT=0.20, WidgetGap=6,

    ToggleW=38, ToggleH=20, KnobSize=14, KnobPad=3,
    ToggleMoveT  = TweenInfo.new(0.20, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    ToggleColorT = TweenInfo.new(0.20, Enum.EasingStyle.Quad,  Enum.EasingDirection.InOut),

    SliderH=52, SliderTrackH=6, SliderKnobS=16,
    NotifyW=300, NotifyH=72, NotifyPadR=16, NotifyPadB=16,
    NotifyGap=8, NotifyBarH=3, NotifySlideT=0.30, NotifyFadeT=0.22, NotifyDur=4,
    SectionH=28, SeparatorH=18, LabelH=28, TextboxH=36,
    DropdownH=36, DropdownItemH=30, DropdownMaxH=150,
    KeybindH=36, KeybindW=80, ProgressH=44, ProgressBarH=6,
    ColorPickerH=36, ColorPanelW=180, ColorHueW=14, ColorHueGap=6,
    ColorAlphaW=14, ColorAlphaGap=6, SearchH=28,
}

-- ── UTILITÁRIOS ───────────────────────────────────────────────────────────────
local Util = {}

local _tweenCache = setmetatable({}, {__mode="k"}) -- weak: GC libera sozinho

function Util.Tween(obj, info, props)
    local p = _tweenCache[obj]; if p then p:Cancel() end
    local t = TweenService:Create(obj, info, props)
    _tweenCache[obj] = t; t:Play(); return t
end

function Util.Clamp(v,lo,hi) return math.max(lo, math.min(hi,v)) end

function Util.Corner(obj, r)
    local c = Instance.new("UICorner"); c.CornerRadius = r or Config.Corner; c.Parent = obj; return c
end

function Util.Stroke(obj, color, thick)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Border; s.Thickness = thick or Config.BorderW
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = obj; return s
end

function Util.Color3toHSV(c)  return Color3.toHSV(c) end
function Util.Color3toHex(c)
    return string.format("%02X%02X%02X",
        math.floor(c.R*255+.5), math.floor(c.G*255+.5), math.floor(c.B*255+.5))
end

function Util.DisconnectAll(t)
    for _,c in ipairs(t) do if typeof(c)=="RBXScriptConnection" and c.Connected then c:Disconnect() end end
    table.clear(t)
end

-- Frame base de widget: wrap + frame estilizado + stroke
function Util.WidgetBase(parent, order, h)
    local wrap = Instance.new("Frame")
    wrap.Size = UDim2.new(1,0,0,h or Config.WidgetH)
    wrap.BackgroundTransparency=1; wrap.BorderSizePixel=0
    wrap.LayoutOrder=order; wrap.Parent=parent
    local f = Instance.new("Frame")
    f.Size=UDim2.new(1,0,1,0); f.BackgroundColor3=Theme.WidgetBg; f.BorderSizePixel=0; f.Parent=wrap
    Util.Corner(f, Config.WidgetCorner)
    local stroke = Util.Stroke(f, Theme.Border, Config.WidgetBorderW)
    return wrap, f, stroke
end

-- Hover padrão reutilizável: MouseEnter/Leave sobre hitbox animam frame + stroke
function Util.HoverEffect(hit, f, stroke, hoverStroke, normStroke)
    hoverStroke = hoverStroke or Theme.Accent
    normStroke  = normStroke  or Theme.Border
    hit.MouseEnter:Connect(function()
        Util.Tween(f,      Config.TweenFast, {BackgroundColor3=Theme.WidgetBgHover})
        if stroke then Util.Tween(stroke, Config.TweenFast, {Color=hoverStroke}) end
    end)
    hit.MouseLeave:Connect(function()
        Util.Tween(f,      Config.TweenFast, {BackgroundColor3=Theme.WidgetBg})
        if stroke then Util.Tween(stroke, Config.TweenFast, {Color=normStroke}) end
    end)
end

-- Botão de header (close / minimize)
function Util.HeaderButton(parent, pos, colNorm, colHover, sym)
    local btn = Instance.new("TextButton")
    btn.Size=UDim2.new(0,14,0,14); btn.Position=pos; btn.AnchorPoint=Vector2.new(0,.5)
    btn.BackgroundColor3=colNorm; btn.BorderSizePixel=0
    btn.Text=""; btn.AutoButtonColor=false; btn.ZIndex=10; btn.Parent=parent
    Util.Corner(btn, UDim.new(1,0))
    local lbl = Instance.new("TextLabel")
    lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1
    lbl.Text=sym; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=8
    lbl.TextColor3=Color3.fromHex("#1A1C1E"); lbl.TextTransparency=1; lbl.ZIndex=11; lbl.Parent=btn
    btn.MouseEnter:Connect(function()
        Util.Tween(btn,Config.TweenFast,{BackgroundColor3=colHover})
        Util.Tween(lbl,Config.TweenFast,{TextTransparency=0})
    end)
    btn.MouseLeave:Connect(function()
        Util.Tween(btn,Config.TweenFast,{BackgroundColor3=colNorm})
        Util.Tween(lbl,Config.TweenFast,{TextTransparency=1})
    end)
    return btn
end

-- ── WIDGETS ───────────────────────────────────────────────────────────────────
local Widgets = {}

-- ── BUTTON ───────────────────────────────────────────────────────────────────
function Widgets.Button(scroll, text, order, cb)
    local wrap, f, stroke = Util.WidgetBase(scroll, order)
    local scale = Instance.new("UIScale"); scale.Scale=1; scale.Parent=f

    local ico = Instance.new("TextLabel")
    ico.Size=UDim2.new(0,28,1,0); ico.Position=UDim2.new(0,8,0,0)
    ico.BackgroundTransparency=1; ico.Text="◆"; ico.Font=Enum.Font.GothamBold; ico.TextSize=8
    ico.TextColor3=Theme.AccentDim; ico.ZIndex=2; ico.Parent=f

    local lbl = Instance.new("TextLabel")
    lbl.Size=UDim2.new(1,-42,1,0); lbl.Position=UDim2.new(0,32,0,0)
    lbl.BackgroundTransparency=1; lbl.Text=text; lbl.Font=Enum.Font.GothamSemibold; lbl.TextSize=12
    lbl.TextColor3=Theme.TextPrimary; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=2; lbl.Parent=f

    local arrow = Instance.new("TextLabel")
    arrow.Size=UDim2.new(0,20,1,0); arrow.Position=UDim2.new(1,-24,0,0)
    arrow.BackgroundTransparency=1; arrow.Text="›"; arrow.Font=Enum.Font.GothamBold; arrow.TextSize=16
    arrow.TextColor3=Theme.TextDisabled; arrow.TextTransparency=0.4; arrow.ZIndex=2; arrow.Parent=f

    local hit = Instance.new("TextButton")
    hit.Size=UDim2.new(1,0,1,0); hit.BackgroundTransparency=1
    hit.Text=""; hit.ZIndex=5; hit.AutoButtonColor=false; hit.Parent=f

    local tPress   = TweenInfo.new(Config.PressT,  Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tRelease = TweenInfo.new(Config.ReleaseT, Enum.EasingStyle.Back,  Enum.EasingDirection.Out)
    local hovered  = false

    hit.MouseEnter:Connect(function()
        hovered=true
        Util.Tween(f,     Config.TweenFast,{BackgroundColor3=Theme.WidgetBgHover})
        Util.Tween(stroke,Config.TweenFast,{Color=Theme.Accent,Thickness=1.5})
        Util.Tween(ico,   Config.TweenFast,{TextColor3=Theme.Accent})
        Util.Tween(lbl,   Config.TweenFast,{TextColor3=Theme.AccentGlow})
        Util.Tween(arrow, Config.TweenFast,{TextColor3=Theme.AccentGlow,TextTransparency=0})
    end)
    hit.MouseLeave:Connect(function()
        hovered=false
        Util.Tween(f,     Config.TweenFast,{BackgroundColor3=Theme.WidgetBg})
        Util.Tween(stroke,Config.TweenFast,{Color=Theme.Border,Thickness=Config.WidgetBorderW})
        Util.Tween(ico,   Config.TweenFast,{TextColor3=Theme.AccentDim})
        Util.Tween(lbl,   Config.TweenFast,{TextColor3=Theme.TextPrimary})
        Util.Tween(arrow, Config.TweenFast,{TextColor3=Theme.TextDisabled,TextTransparency=0.4})
    end)
    hit.MouseButton1Down:Connect(function()
        Util.Tween(scale, tPress,{Scale=Config.PressScale})
        Util.Tween(f,     tPress,{BackgroundColor3=Theme.WidgetBgPress})
        Util.Tween(stroke,tPress,{Color=Theme.AccentDim})
    end)
    hit.MouseButton1Up:Connect(function()
        Util.Tween(scale, tRelease,{Scale=1})
        Util.Tween(f,     tRelease,{BackgroundColor3=hovered and Theme.WidgetBgHover or Theme.WidgetBg})
        Util.Tween(stroke,tRelease,{Color=hovered and Theme.Accent or Theme.Border})
    end)
    hit.MouseButton1Click:Connect(function()
        task.delay(Config.ReleaseT*.5, function() if cb then pcall(cb) end end)
    end)

    local obj={}
    function obj:SetText(t) lbl.Text=t end
    function obj:SetEnabled(e)
        hit.Active=e
        Util.Tween(lbl,   Config.TweenFast,{TextColor3=e and Theme.TextPrimary or Theme.TextDisabled})
        Util.Tween(stroke,Config.TweenFast,{Color=e and Theme.Border or Theme.TextDisabled})
    end
    return obj
end

-- ── TOGGLE ────────────────────────────────────────────────────────────────────
function Widgets.Toggle(scroll, text, default, order, cb)
    local state = (default==true)
    local wrap, f, _ = Util.WidgetBase(scroll, order)

    local sico = Instance.new("TextLabel")
    sico.Size=UDim2.new(0,16,1,0); sico.Position=UDim2.new(0,10,0,0)
    sico.BackgroundTransparency=1; sico.Text=state and "●" or "○"
    sico.Font=Enum.Font.GothamBold; sico.TextSize=9
    sico.TextColor3=state and Theme.Accent or Theme.TextDisabled; sico.ZIndex=2; sico.Parent=f

    local lbl = Instance.new("TextLabel")
    lbl.Size=UDim2.new(1,-(Config.ToggleW+36),1,0); lbl.Position=UDim2.new(0,30,0,0)
    lbl.BackgroundTransparency=1; lbl.Text=text; lbl.Font=Enum.Font.GothamSemibold; lbl.TextSize=12
    lbl.TextColor3=Theme.TextPrimary; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=2; lbl.Parent=f

    local tW,tH = Config.ToggleW, Config.ToggleH
    local track = Instance.new("Frame")
    track.Size=UDim2.new(0,tW,0,tH); track.Position=UDim2.new(1,-(tW+10),.5,-tH/2)
    track.BackgroundColor3=state and Theme.Accent or Theme.ToggleOffTrack
    track.BorderSizePixel=0; track.ZIndex=3; track.Parent=f
    Util.Corner(track,UDim.new(1,0))
    local trackStroke = Util.Stroke(track,Theme.Accent,Config.WidgetBorderW)
    trackStroke.Transparency = state and 0 or 1

    local kS,kPad = Config.KnobSize, Config.KnobPad
    local knobOffX, knobOnX = kPad, tW-kS-kPad
    local knob = Instance.new("Frame")
    knob.Size=UDim2.new(0,kS,0,kS); knob.Position=UDim2.new(0,state and knobOnX or knobOffX,.5,-kS/2)
    knob.BackgroundColor3=state and Theme.ToggleKnobOn or Theme.ToggleKnob
    knob.BorderSizePixel=0; knob.ZIndex=5; knob.Parent=track
    Util.Corner(knob,UDim.new(1,0))

    local function applyState(s,animate)
        local tM = animate and Config.ToggleMoveT  or TweenInfo.new(0)
        local tC = animate and Config.ToggleColorT or TweenInfo.new(0)
        if s then
            Util.Tween(track,      tC,{BackgroundColor3=Theme.Accent})
            Util.Tween(trackStroke,tC,{Transparency=0})
            Util.Tween(knob,tM,{Position=UDim2.new(0,knobOnX,.5,-kS/2),BackgroundColor3=Theme.ToggleKnobOn})
            Util.Tween(sico,tC,{TextColor3=Theme.Accent}); sico.Text="●"
        else
            Util.Tween(track,      tC,{BackgroundColor3=Theme.ToggleOffTrack})
            Util.Tween(trackStroke,tC,{Transparency=1})
            Util.Tween(knob,tM,{Position=UDim2.new(0,knobOffX,.5,-kS/2),BackgroundColor3=Theme.ToggleKnob})
            Util.Tween(sico,tC,{TextColor3=Theme.TextDisabled}); sico.Text="○"
        end
    end
    applyState(state,false)

    local hit = Instance.new("TextButton")
    hit.Size=UDim2.new(1,0,1,0); hit.BackgroundTransparency=1; hit.Text=""; hit.ZIndex=6; hit.AutoButtonColor=false; hit.Parent=f
    -- Hover simples sem stroke (toggle não tem stroke primário)
    hit.MouseEnter:Connect(function() Util.Tween(f,Config.TweenFast,{BackgroundColor3=Theme.WidgetBgHover}) end)
    hit.MouseLeave:Connect(function() Util.Tween(f,Config.TweenFast,{BackgroundColor3=Theme.WidgetBg}) end)
    hit.MouseButton1Click:Connect(function()
        state=not state; applyState(state,true)
        if cb then pcall(cb,state) end
    end)

    local obj={}
    function obj:GetState() return state end
    function obj:SetState(s,silent) state=s; applyState(state,true); if not silent and cb then pcall(cb,state) end end
    function obj:SetText(t) lbl.Text=t end
    return obj
end

-- ── SLIDER ────────────────────────────────────────────────────────────────────
function Widgets.Slider(scroll, text, minV, maxV, default, order, cb)
    minV=minV or 0; maxV=maxV or 100; default=Util.Clamp(default or minV,minV,maxV)
    local isInt = math.floor(minV)==minV and math.floor(maxV)==maxV
    if isInt then default=math.round(default) end
    local value=default

    local wrap,f,_ = Util.WidgetBase(scroll,order,Config.SliderH)
    local pad=Instance.new("UIPadding")
    pad.PaddingLeft=UDim.new(0,10); pad.PaddingRight=UDim.new(0,10)
    pad.PaddingTop=UDim.new(0,7);   pad.PaddingBottom=UDim.new(0,7); pad.Parent=f

    local topRow=Instance.new("Frame"); topRow.Size=UDim2.new(1,0,0,16)
    topRow.BackgroundTransparency=1; topRow.BorderSizePixel=0; topRow.Parent=f

    local nameLbl=Instance.new("TextLabel"); nameLbl.Size=UDim2.new(1,-50,1,0)
    nameLbl.BackgroundTransparency=1; nameLbl.Text=text; nameLbl.Font=Enum.Font.GothamSemibold; nameLbl.TextSize=12
    nameLbl.TextColor3=Theme.TextPrimary; nameLbl.TextXAlignment=Enum.TextXAlignment.Left; nameLbl.ZIndex=2; nameLbl.Parent=topRow

    local badge=Instance.new("Frame"); badge.Size=UDim2.new(0,44,1,0); badge.Position=UDim2.new(1,-44,0,0)
    badge.BackgroundColor3=Theme.Surface; badge.BorderSizePixel=0; badge.ZIndex=2; badge.Parent=topRow
    Util.Corner(badge,UDim.new(0,4)); Util.Stroke(badge,Theme.Border,1)

    local valLbl=Instance.new("TextLabel"); valLbl.Size=UDim2.new(1,0,1,0); valLbl.BackgroundTransparency=1
    valLbl.Text=tostring(value); valLbl.Font=Enum.Font.GothamBold; valLbl.TextSize=11
    valLbl.TextColor3=Theme.Accent; valLbl.TextXAlignment=Enum.TextXAlignment.Center; valLbl.ZIndex=3; valLbl.Parent=badge

    local tH=Config.SliderTrackH
    local track=Instance.new("Frame"); track.Size=UDim2.new(1,0,0,tH); track.Position=UDim2.new(0,0,0,20)
    track.BackgroundColor3=Theme.SliderTrack; track.BorderSizePixel=0; track.ZIndex=2; track.Parent=f
    Util.Corner(track,UDim.new(1,0))

    local fill=Instance.new("Frame"); fill.Size=UDim2.new(0,0,1,0); fill.BackgroundColor3=Theme.Accent
    fill.BorderSizePixel=0; fill.ZIndex=3; fill.Parent=track; Util.Corner(fill,UDim.new(1,0))

    local kS=Config.SliderKnobS
    local knob=Instance.new("Frame"); knob.Size=UDim2.new(0,kS,0,kS); knob.AnchorPoint=Vector2.new(.5,.5)
    knob.Position=UDim2.new(0,0,.5,0); knob.BackgroundColor3=Theme.SliderKnob
    knob.BorderSizePixel=0; knob.ZIndex=5; knob.Parent=track; Util.Corner(knob,UDim.new(1,0))
    local knobStroke=Util.Stroke(knob,Theme.Accent,1.5)

    local function mkRangeLbl(xa,txt)
        local l=Instance.new("TextLabel"); l.Size=UDim2.new(0,30,0,10); l.Position=UDim2.new(xa,xa==0 and 0 or -30,0,26)
        l.BackgroundTransparency=1; l.Text=txt; l.Font=Enum.Font.Gotham; l.TextSize=9
        l.TextColor3=Theme.TextDisabled; l.TextXAlignment=xa==0 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right
        l.ZIndex=2; l.Parent=f
    end
    mkRangeLbl(0,tostring(minV)); mkRangeLbl(1,tostring(maxV))

    local function applyValue(v)
        value=Util.Clamp(v,minV,maxV); if isInt then value=math.round(value) end
        local ratio=(value-minV)/(maxV-minV)
        fill.Size=UDim2.new(ratio,0,1,0); knob.Position=UDim2.new(ratio,0,.5,0); valLbl.Text=tostring(value)
    end
    applyValue(value)

    local hitbox=Instance.new("TextButton"); hitbox.Size=UDim2.new(1,0,0,tH+20); hitbox.Position=UDim2.new(0,0,0,10)
    hitbox.BackgroundTransparency=1; hitbox.Text=""; hitbox.ZIndex=7; hitbox.AutoButtonColor=false; hitbox.Parent=f

    local dragging=false; local conns={}
    local function applyFromX(absX)
        local tw=track.AbsoluteSize.X; if tw==0 then return end
        local v=minV+(Util.Clamp(absX-track.AbsolutePosition.X,0,tw)/tw)*(maxV-minV)
        if isInt then v=math.round(v) end; v=Util.Clamp(v,minV,maxV)
        if v~=value then applyValue(v); if cb then pcall(cb,value) end end
    end
    local function stopDrag()
        if not dragging then return end; dragging=false; Util.DisconnectAll(conns)
        Util.Tween(knob,      Config.TweenFast,{BackgroundColor3=Theme.SliderKnob})
        Util.Tween(knobStroke,Config.TweenFast,{Color=Theme.Accent,Thickness=1.5})
        Util.Tween(f,         Config.TweenFast,{BackgroundColor3=Theme.WidgetBg})
    end

    hitbox.MouseEnter:Connect(function() Util.Tween(f,Config.TweenFast,{BackgroundColor3=Theme.WidgetBgHover}) end)
    hitbox.MouseLeave:Connect(function() if not dragging then Util.Tween(f,Config.TweenFast,{BackgroundColor3=Theme.WidgetBg}) end end)
    hitbox.MouseButton1Down:Connect(function()
        dragging=true
        Util.Tween(knob,      Config.TweenFast,{BackgroundColor3=Theme.AccentGlow})
        Util.Tween(knobStroke,Config.TweenFast,{Color=Theme.AccentGlow,Thickness=2})
        applyFromX(UserInputService:GetMouseLocation().X)
        conns[1]=UserInputService.InputChanged:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseMovement then applyFromX(i.Position.X) end
        end)
        conns[2]=UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then stopDrag() end
        end)
    end)
    wrap.AncestryChanged:Connect(function() if not wrap.Parent then stopDrag() end end)

    local obj={}
    function obj:GetValue() return value end
    function obj:SetValue(v,silent) applyValue(v); if not silent and cb then pcall(cb,value) end end
    function obj:SetText(t) nameLbl.Text=t end
    return obj
end

-- ── SECTION (sem hack de BackgroundColor3) ────────────────────────────────────
function Widgets.Section(scroll, text, order)
    local wrap=Instance.new("Frame"); wrap.Size=UDim2.new(1,0,0,Config.SectionH)
    wrap.BackgroundTransparency=1; wrap.BorderSizePixel=0; wrap.LayoutOrder=order; wrap.Parent=scroll

    -- Duas linhas laterais curtas + texto centralizado sem fundo: limpo e sem hack
    local function mkLine(anchor,posX)
        local l=Instance.new("Frame"); l.AnchorPoint=Vector2.new(anchor,.5)
        l.Position=UDim2.new(posX,0,.5,0); l.Size=UDim2.new(0.08,0,0,1)
        l.BackgroundColor3=Theme.SectionLine; l.BorderSizePixel=0; l.ZIndex=1; l.Parent=wrap
    end
    mkLine(0,0); mkLine(1,1)

    local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(0.8,0,1,0)
    lbl.AnchorPoint=Vector2.new(.5,.5); lbl.Position=UDim2.new(.5,0,.5,0)
    lbl.BackgroundTransparency=1; lbl.Text=string.upper(text or "SECTION")
    lbl.Font=Enum.Font.GothamBold; lbl.TextSize=9; lbl.TextColor3=Theme.SectionText
    lbl.TextXAlignment=Enum.TextXAlignment.Center; lbl.ZIndex=2; lbl.Parent=wrap

    local obj={}; function obj:SetText(t) lbl.Text=string.upper(t or "") end; return obj
end

-- ── SEPARATOR ─────────────────────────────────────────────────────────────────
function Widgets.Separator(scroll, order)
    local wrap=Instance.new("Frame"); wrap.Size=UDim2.new(1,0,0,Config.SeparatorH)
    wrap.BackgroundTransparency=1; wrap.BorderSizePixel=0; wrap.LayoutOrder=order; wrap.Parent=scroll
    local l=Instance.new("Frame"); l.Size=UDim2.new(1,0,0,1); l.Position=UDim2.new(0,0,.5,0)
    l.BackgroundColor3=Theme.SectionLine; l.BorderSizePixel=0; l.Parent=wrap
end

-- ── LABEL ─────────────────────────────────────────────────────────────────────
function Widgets.Label(scroll, text, order)
    local wrap,f,_ = Util.WidgetBase(scroll,order,Config.LabelH)
    local pad=Instance.new("UIPadding"); pad.PaddingLeft=UDim.new(0,12); pad.PaddingRight=UDim.new(0,12); pad.Parent=f
    local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1
    lbl.Text=text or ""; lbl.Font=Enum.Font.Gotham; lbl.TextSize=11; lbl.TextColor3=Theme.TextSecondary
    lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.TextWrapped=true; lbl.ZIndex=2; lbl.Parent=f
    local obj={}
    function obj:SetText(t) lbl.Text=t or "" end
    function obj:SetColor(c) Util.Tween(lbl,Config.TweenFast,{TextColor3=c}) end
    return obj
end

-- ── TEXTBOX ───────────────────────────────────────────────────────────────────
function Widgets.Textbox(scroll, text, placeholder, default, order, cb)
    local wrap,f,stroke = Util.WidgetBase(scroll,order,Config.TextboxH)
    local nameLbl=Instance.new("TextLabel"); nameLbl.Size=UDim2.new(.45,0,1,0); nameLbl.Position=UDim2.new(0,12,0,0)
    nameLbl.BackgroundTransparency=1; nameLbl.Text=text or ""; nameLbl.Font=Enum.Font.GothamSemibold; nameLbl.TextSize=12
    nameLbl.TextColor3=Theme.TextPrimary; nameLbl.TextXAlignment=Enum.TextXAlignment.Left; nameLbl.ZIndex=2; nameLbl.Parent=f

    local iF=Instance.new("Frame"); iF.Size=UDim2.new(.52,0,0,24); iF.Position=UDim2.new(1,-8,.5,0)
    iF.AnchorPoint=Vector2.new(1,.5); iF.BackgroundColor3=Theme.InputBg; iF.BorderSizePixel=0; iF.ZIndex=3; iF.Parent=f
    Util.Corner(iF,UDim.new(0,5)); local iS=Util.Stroke(iF,Theme.InputBorder,1)

    local box=Instance.new("TextBox"); box.Size=UDim2.new(1,-12,1,0); box.Position=UDim2.new(0,6,0,0)
    box.BackgroundTransparency=1; box.Text=default or ""; box.PlaceholderText=placeholder or ""
    box.PlaceholderColor3=Theme.TextDisabled; box.Font=Enum.Font.Gotham; box.TextSize=11
    box.TextColor3=Theme.InputText; box.TextXAlignment=Enum.TextXAlignment.Left
    box.ClearTextOnFocus=false; box.ZIndex=4; box.Parent=iF

    box.Focused:Connect(function()
        Util.Tween(iS,Config.TweenFast,{Color=Theme.Accent}); Util.Tween(stroke,Config.TweenFast,{Color=Theme.Accent})
        Util.Tween(f,Config.TweenFast,{BackgroundColor3=Theme.WidgetBgHover})
    end)
    box.FocusLost:Connect(function(enter)
        Util.Tween(iS,Config.TweenFast,{Color=Theme.InputBorder}); Util.Tween(stroke,Config.TweenFast,{Color=Theme.Border})
        Util.Tween(f,Config.TweenFast,{BackgroundColor3=Theme.WidgetBg}); if cb then pcall(cb,box.Text,enter) end
    end)

    local obj={}
    function obj:GetText()   return box.Text end
    function obj:SetText(t)  box.Text=t or "" end
    function obj:SetLabel(t) nameLbl.Text=t or "" end
    return obj
end

-- ── DROPDOWN ──────────────────────────────────────────────────────────────────
local _openDropdownClose=nil

function Widgets.Dropdown(scroll, text, options, default, order, cb)
    options=options or {}; local selected=default or options[1] or ""

    local wrap=Instance.new("Frame"); wrap.Size=UDim2.new(1,0,0,Config.DropdownH)
    wrap.BackgroundTransparency=1; wrap.BorderSizePixel=0; wrap.LayoutOrder=order
    wrap.ClipsDescendants=false; wrap.Parent=scroll

    local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,1,0); f.BackgroundColor3=Theme.WidgetBg
    f.BorderSizePixel=0; f.ZIndex=2; f.Parent=wrap; Util.Corner(f,Config.WidgetCorner)
    local stroke=Util.Stroke(f,Theme.Border,Config.WidgetBorderW)

    local nameLbl=Instance.new("TextLabel"); nameLbl.Size=UDim2.new(.45,0,1,0); nameLbl.Position=UDim2.new(0,12,0,0)
    nameLbl.BackgroundTransparency=1; nameLbl.Text=text or ""; nameLbl.Font=Enum.Font.GothamSemibold; nameLbl.TextSize=12
    nameLbl.TextColor3=Theme.TextPrimary; nameLbl.TextXAlignment=Enum.TextXAlignment.Left; nameLbl.ZIndex=3; nameLbl.Parent=f

    local valBtn=Instance.new("TextButton"); valBtn.Size=UDim2.new(.52,0,0,24); valBtn.Position=UDim2.new(1,-8,.5,0)
    valBtn.AnchorPoint=Vector2.new(1,.5); valBtn.BackgroundColor3=Theme.InputBg; valBtn.BorderSizePixel=0
    valBtn.Text=""; valBtn.AutoButtonColor=false; valBtn.ZIndex=3; valBtn.Parent=f
    Util.Corner(valBtn,UDim.new(0,5)); local valStroke=Util.Stroke(valBtn,Theme.InputBorder,1)

    local selLbl=Instance.new("TextLabel"); selLbl.Size=UDim2.new(1,-22,1,0); selLbl.Position=UDim2.new(0,8,0,0)
    selLbl.BackgroundTransparency=1; selLbl.Text=tostring(selected); selLbl.Font=Enum.Font.Gotham; selLbl.TextSize=11
    selLbl.TextColor3=Theme.InputText; selLbl.TextXAlignment=Enum.TextXAlignment.Left
    selLbl.TextTruncate=Enum.TextTruncate.AtEnd; selLbl.ZIndex=4; selLbl.Parent=valBtn

    local arrowLbl=Instance.new("TextLabel"); arrowLbl.Size=UDim2.new(0,18,1,0); arrowLbl.Position=UDim2.new(1,-18,0,0)
    arrowLbl.BackgroundTransparency=1; arrowLbl.Text="▾"; arrowLbl.Font=Enum.Font.GothamBold; arrowLbl.TextSize=10
    arrowLbl.TextColor3=Theme.DropdownArrow; arrowLbl.ZIndex=4; arrowLbl.Parent=valBtn

    local listFrame=Instance.new("Frame"); listFrame.Size=UDim2.new(.52,0,0,0); listFrame.Position=UDim2.new(1,-8,1,4)
    listFrame.AnchorPoint=Vector2.new(1,0); listFrame.BackgroundColor3=Theme.Surface; listFrame.BorderSizePixel=0
    listFrame.ClipsDescendants=true; listFrame.Visible=false; listFrame.ZIndex=20; listFrame.Parent=f
    Util.Corner(listFrame,UDim.new(0,6)); Util.Stroke(listFrame,Theme.Border,1)

    local listScroll=Instance.new("ScrollingFrame"); listScroll.Size=UDim2.new(1,0,1,0)
    listScroll.BackgroundTransparency=1; listScroll.BorderSizePixel=0; listScroll.ScrollBarThickness=2
    listScroll.ScrollBarImageColor3=Theme.ScrollBar; listScroll.CanvasSize=UDim2.new(0,0,0,0)
    listScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; listScroll.ScrollingDirection=Enum.ScrollingDirection.Y
    listScroll.ZIndex=21; listScroll.Parent=listFrame
    local ll=Instance.new("UIListLayout"); ll.SortOrder=Enum.SortOrder.LayoutOrder; ll.Padding=UDim.new(0,0); ll.Parent=listScroll
    local lp=Instance.new("UIPadding"); lp.PaddingTop=UDim.new(0,4); lp.PaddingBottom=UDim.new(0,4)
    lp.PaddingLeft=UDim.new(0,4); lp.PaddingRight=UDim.new(0,4); lp.Parent=listScroll

    local isOpen=false
    local function closeList()
        if not isOpen then return end; isOpen=false
        if _openDropdownClose==closeList then _openDropdownClose=nil end
        Util.Tween(listFrame,Config.TweenFast,{Size=UDim2.new(.52,0,0,0)})
        Util.Tween(arrowLbl, Config.TweenFast,{TextColor3=Theme.DropdownArrow})
        Util.Tween(valStroke,Config.TweenFast,{Color=Theme.InputBorder})
        Util.Tween(stroke,   Config.TweenFast,{Color=Theme.Border})
        task.delay(Config.TweenFast.Time+.02,function() if not isOpen then listFrame.Visible=false end end)
    end
    local function openList()
        if _openDropdownClose then _openDropdownClose() end; _openDropdownClose=closeList; isOpen=true
        local ch=math.min(#options*Config.DropdownItemH+8,Config.DropdownMaxH)
        listFrame.Visible=true; listFrame.Size=UDim2.new(.52,0,0,0)
        Util.Tween(listFrame,Config.TweenFast,{Size=UDim2.new(.52,0,0,ch)})
        Util.Tween(arrowLbl, Config.TweenFast,{TextColor3=Theme.Accent})
        Util.Tween(valStroke,Config.TweenFast,{Color=Theme.Accent})
        Util.Tween(stroke,   Config.TweenFast,{Color=Theme.Accent})
    end
    local function populateItems()
        for _,ch in ipairs(listScroll:GetChildren()) do if ch:IsA("TextButton") then ch:Destroy() end end
        for i,opt in ipairs(options) do
            local ib=Instance.new("TextButton"); ib.Size=UDim2.new(1,0,0,Config.DropdownItemH)
            ib.BackgroundColor3=Theme.Surface; ib.BorderSizePixel=0; ib.Text=""; ib.AutoButtonColor=false
            ib.LayoutOrder=i; ib.ZIndex=22; ib.Parent=listScroll; Util.Corner(ib,UDim.new(0,4))
            local ol=Instance.new("TextLabel"); ol.Size=UDim2.new(1,-16,1,0); ol.Position=UDim2.new(0,8,0,0)
            ol.BackgroundTransparency=1; ol.Text=tostring(opt); ol.Font=Enum.Font.Gotham; ol.TextSize=11
            ol.TextColor3=(opt==selected) and Theme.AccentGlow or Theme.TextSecondary
            ol.TextXAlignment=Enum.TextXAlignment.Left; ol.ZIndex=23; ol.Parent=ib
            local cl=Instance.new("TextLabel"); cl.Name="checkLbl"; cl.Size=UDim2.new(0,14,1,0); cl.Position=UDim2.new(1,-16,0,0)
            cl.BackgroundTransparency=1; cl.Text=(opt==selected) and "✓" or ""; cl.Font=Enum.Font.GothamBold
            cl.TextSize=9; cl.TextColor3=Theme.Accent; cl.ZIndex=23; cl.Parent=ib
            ib.MouseEnter:Connect(function()
                Util.Tween(ib,Config.TweenFast,{BackgroundColor3=Theme.SurfaceHover})
                Util.Tween(ol,Config.TweenFast,{TextColor3=Theme.TextPrimary})
            end)
            ib.MouseLeave:Connect(function()
                Util.Tween(ib,Config.TweenFast,{BackgroundColor3=Theme.Surface})
                Util.Tween(ol,Config.TweenFast,{TextColor3=(opt==selected) and Theme.AccentGlow or Theme.TextSecondary})
            end)
            ib.MouseButton1Click:Connect(function()
                for _,c2 in ipairs(listScroll:GetChildren()) do
                    if c2:IsA("TextButton") then
                        local ck=c2:FindFirstChild("checkLbl"); if ck then ck.Text="" end
                        for _,lc in ipairs(c2:GetChildren()) do
                            if lc:IsA("TextLabel") and lc.Name~="checkLbl" then
                                Util.Tween(lc,Config.TweenFast,{TextColor3=Theme.TextSecondary})
                            end
                        end
                    end
                end
                ol.TextColor3=Theme.AccentGlow; cl.Text="✓"; selected=opt; selLbl.Text=tostring(opt)
                closeList(); if cb then pcall(cb,selected) end
            end)
        end
    end
    populateItems()
    valBtn.MouseButton1Click:Connect(function() if isOpen then closeList() else openList() end end)
    local outsideConn=UserInputService.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 and isOpen then
            task.defer(function() if isOpen then closeList() end end)
        end
    end)
    wrap.AncestryChanged:Connect(function()
        if not wrap.Parent then if isOpen then closeList() end; outsideConn:Disconnect() end
    end)

    local obj={}
    function obj:GetSelected() return selected end
    function obj:SetSelected(opt,silent)
        if table.find(options,opt) then selected=opt; selLbl.Text=tostring(opt); if not silent and cb then pcall(cb,selected) end end
    end
    function obj:SetOptions(newOpts,newDefault)
        if isOpen then closeList() end; options=newOpts or {}; selected=newDefault or options[1] or ""
        selLbl.Text=tostring(selected); populateItems()
    end
    function obj:SetLabel(t) nameLbl.Text=t or "" end
    return obj
end

-- ── KEYBIND ───────────────────────────────────────────────────────────────────
function Widgets.Keybind(scroll, text, default, order, cb)
    local boundKey=default; local listening=false
    local wrap,f,stroke = Util.WidgetBase(scroll,order,Config.KeybindH)

    local sico=Instance.new("TextLabel"); sico.Size=UDim2.new(0,16,1,0); sico.Position=UDim2.new(0,10,0,0)
    sico.BackgroundTransparency=1; sico.Text="⌨"; sico.Font=Enum.Font.GothamBold; sico.TextSize=10
    sico.TextColor3=Theme.AccentDim; sico.ZIndex=2; sico.Parent=f

    local nameLbl=Instance.new("TextLabel"); nameLbl.Size=UDim2.new(1,-(Config.KeybindW+24),1,0); nameLbl.Position=UDim2.new(0,30,0,0)
    nameLbl.BackgroundTransparency=1; nameLbl.Text=text or ""; nameLbl.Font=Enum.Font.GothamSemibold; nameLbl.TextSize=12
    nameLbl.TextColor3=Theme.TextPrimary; nameLbl.TextXAlignment=Enum.TextXAlignment.Left; nameLbl.ZIndex=2; nameLbl.Parent=f

    local keyBtn=Instance.new("TextButton"); keyBtn.Size=UDim2.new(0,Config.KeybindW,0,22); keyBtn.Position=UDim2.new(1,-8,.5,0)
    keyBtn.AnchorPoint=Vector2.new(1,.5); keyBtn.BackgroundColor3=Theme.KeybindBg; keyBtn.BorderSizePixel=0
    keyBtn.Text=""; keyBtn.AutoButtonColor=false; keyBtn.ZIndex=3; keyBtn.Parent=f
    Util.Corner(keyBtn,UDim.new(0,5)); local keyStroke=Util.Stroke(keyBtn,Theme.KeybindBorder,1)

    local function bindName(b)
        if b==nil then return "None" end
        if typeof(b)=="EnumItem" then
            if b.EnumType==Enum.KeyCode then return b.Name end
            if b==Enum.UserInputType.MouseButton1 then return "M1" end
            if b==Enum.UserInputType.MouseButton2 then return "M2" end
            if b==Enum.UserInputType.MouseButton3 then return "M3" end
            return b.Name
        end
        return "None"
    end

    local keyLbl=Instance.new("TextLabel"); keyLbl.Size=UDim2.new(1,0,1,0); keyLbl.BackgroundTransparency=1
    keyLbl.Text=bindName(boundKey); keyLbl.Font=Enum.Font.GothamBold; keyLbl.TextSize=10
    keyLbl.TextColor3=boundKey and Theme.Accent or Theme.TextDisabled
    keyLbl.TextXAlignment=Enum.TextXAlignment.Center; keyLbl.ZIndex=4; keyLbl.Parent=keyBtn

    local inputConn=nil
    local function stopListening()
        listening=false; if inputConn then inputConn:Disconnect(); inputConn=nil end
        Util.Tween(keyStroke,Config.TweenFast,{Color=Theme.KeybindBorder})
        Util.Tween(stroke,   Config.TweenFast,{Color=Theme.Border})
        Util.Tween(f,        Config.TweenFast,{BackgroundColor3=Theme.WidgetBg})
        Util.Tween(keyLbl,   Config.TweenFast,{TextColor3=boundKey and Theme.Accent or Theme.TextDisabled})
        keyLbl.Text=bindName(boundKey)
    end
    local function startListening()
        listening=true; keyLbl.Text="..."
        Util.Tween(keyStroke,Config.TweenFast,{Color=Theme.KeybindActive})
        Util.Tween(stroke,   Config.TweenFast,{Color=Theme.Accent})
        Util.Tween(f,        Config.TweenFast,{BackgroundColor3=Theme.WidgetBgHover})
        Util.Tween(keyLbl,   Config.TweenFast,{TextColor3=Theme.AccentGlow})
        inputConn=UserInputService.InputBegan:Connect(function(inp,_)
            if not listening then return end
            if inp.UserInputType==Enum.UserInputType.MouseButton1
            or inp.UserInputType==Enum.UserInputType.MouseButton2
            or inp.UserInputType==Enum.UserInputType.MouseButton3 then
                task.defer(function()
                    if not listening then return end
                    boundKey=inp.UserInputType; stopListening(); if cb then pcall(cb,boundKey) end
                end); return
            end
            if inp.UserInputType==Enum.UserInputType.Keyboard then
                if inp.KeyCode==Enum.KeyCode.Escape then stopListening(); return end
                boundKey=inp.KeyCode; stopListening(); if cb then pcall(cb,boundKey) end
            end
        end)
    end

    -- Hover respeitando modo listening
    keyBtn.MouseEnter:Connect(function()
        if listening then return end
        Util.Tween(f,      Config.TweenFast,{BackgroundColor3=Theme.WidgetBgHover})
        Util.Tween(stroke, Config.TweenFast,{Color=Theme.AccentDim})
    end)
    keyBtn.MouseLeave:Connect(function()
        if listening then return end
        Util.Tween(f,      Config.TweenFast,{BackgroundColor3=Theme.WidgetBg})
        Util.Tween(stroke, Config.TweenFast,{Color=Theme.Border})
    end)
    keyBtn.MouseButton1Click:Connect(function() if listening then stopListening() else startListening() end end)
    wrap.AncestryChanged:Connect(function() if not wrap.Parent then stopListening() end end)

    local obj={}
    function obj:GetKey() return boundKey end
    function obj:SetKey(k,silent) boundKey=k; stopListening(); if not silent and cb then pcall(cb,boundKey) end end
    function obj:SetText(t) nameLbl.Text=t or "" end
    return obj
end

-- ── PROGRESS BAR ──────────────────────────────────────────────────────────────
function Widgets.ProgressBar(scroll, text, initialValue, order)
    local value=Util.Clamp(initialValue or 0,0,1)
    local wrap,f,_ = Util.WidgetBase(scroll,order,Config.ProgressH)
    local pad=Instance.new("UIPadding")
    pad.PaddingLeft=UDim.new(0,10); pad.PaddingRight=UDim.new(0,10)
    pad.PaddingTop=UDim.new(0,6);   pad.PaddingBottom=UDim.new(0,6); pad.Parent=f

    local topRow=Instance.new("Frame"); topRow.Size=UDim2.new(1,0,0,14)
    topRow.BackgroundTransparency=1; topRow.BorderSizePixel=0; topRow.Parent=f

    local nameLbl=Instance.new("TextLabel"); nameLbl.Size=UDim2.new(1,-36,1,0)
    nameLbl.BackgroundTransparency=1; nameLbl.Text=text or ""; nameLbl.Font=Enum.Font.GothamSemibold; nameLbl.TextSize=11
    nameLbl.TextColor3=Theme.TextPrimary; nameLbl.TextXAlignment=Enum.TextXAlignment.Left; nameLbl.ZIndex=2; nameLbl.Parent=topRow

    local pctLbl=Instance.new("TextLabel"); pctLbl.Size=UDim2.new(0,34,1,0); pctLbl.Position=UDim2.new(1,-34,0,0)
    pctLbl.BackgroundTransparency=1; pctLbl.Text=math.floor(value*100).."%"; pctLbl.Font=Enum.Font.GothamBold; pctLbl.TextSize=10
    pctLbl.TextColor3=Theme.Accent; pctLbl.TextXAlignment=Enum.TextXAlignment.Right; pctLbl.ZIndex=2; pctLbl.Parent=topRow

    local track=Instance.new("Frame"); track.Size=UDim2.new(1,0,0,Config.ProgressBarH); track.Position=UDim2.new(0,0,0,18)
    track.BackgroundColor3=Theme.ProgressTrack; track.BorderSizePixel=0; track.ZIndex=2; track.Parent=f; Util.Corner(track,UDim.new(1,0))

    local fill=Instance.new("Frame"); fill.Size=UDim2.new(value,0,1,0); fill.BackgroundColor3=Theme.ProgressFill
    fill.BorderSizePixel=0; fill.ZIndex=3; fill.Parent=track; Util.Corner(fill,UDim.new(1,0))

    local shimmer=Instance.new("Frame"); shimmer.Size=UDim2.new(.4,0,1,0); shimmer.Position=UDim2.new(.6,0,0,0)
    shimmer.BackgroundColor3=Color3.new(1,1,1); shimmer.BackgroundTransparency=0.85
    shimmer.BorderSizePixel=0; shimmer.ZIndex=4; shimmer.Parent=fill; Util.Corner(shimmer,UDim.new(1,0))

    local function applyValue(v,animate)
        value=Util.Clamp(v,0,1); pctLbl.Text=math.floor(value*100).."%"
        local ns=UDim2.new(value,0,1,0)
        if animate then Util.Tween(fill,TweenInfo.new(.35,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=ns})
        else fill.Size=ns end
        Util.Tween(fill,Config.TweenFast,{BackgroundColor3=value>=1 and Theme.NotifySuccess or Theme.ProgressFill})
    end
    applyValue(value,false)

    local obj={}
    function obj:GetValue() return value end
    function obj:SetValue(v,animate) applyValue(v,animate~=false) end
    function obj:SetText(t) nameLbl.Text=t or "" end
    return obj
end

-- ── COLOR PICKER (com suporte opcional a Alpha) ───────────────────────────────
-- cb(Color3, alpha)  — alpha é sempre retornado (1.0 se useAlpha=false)
local _openPickerClose=nil

function Widgets.ColorPicker(scroll, text, default, order, cb, defaultAlpha, useAlpha)
    local currentColor=default or Color3.fromHex("#D4AF37")
    local hue,sat,val = Util.Color3toHSV(currentColor)
    local alpha = (useAlpha and defaultAlpha) and Util.Clamp(defaultAlpha,0,1) or 1

    local wrap=Instance.new("Frame"); wrap.Size=UDim2.new(1,0,0,Config.ColorPickerH)
    wrap.BackgroundTransparency=1; wrap.BorderSizePixel=0; wrap.LayoutOrder=order
    wrap.ClipsDescendants=false; wrap.Parent=scroll

    local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,1,0); f.BackgroundColor3=Theme.WidgetBg
    f.BorderSizePixel=0; f.ZIndex=2; f.Parent=wrap; Util.Corner(f,Config.WidgetCorner)
    local stroke=Util.Stroke(f,Theme.Border,Config.WidgetBorderW)

    local nameLbl=Instance.new("TextLabel"); nameLbl.Size=UDim2.new(.55,0,1,0); nameLbl.Position=UDim2.new(0,12,0,0)
    nameLbl.BackgroundTransparency=1; nameLbl.Text=text or ""; nameLbl.Font=Enum.Font.GothamSemibold; nameLbl.TextSize=12
    nameLbl.TextColor3=Theme.TextPrimary; nameLbl.TextXAlignment=Enum.TextXAlignment.Left; nameLbl.ZIndex=3; nameLbl.Parent=f

    local prevBtn=Instance.new("TextButton"); prevBtn.Size=UDim2.new(0,52,0,22); prevBtn.Position=UDim2.new(1,-8,.5,0)
    prevBtn.AnchorPoint=Vector2.new(1,.5); prevBtn.BackgroundColor3=currentColor; prevBtn.BorderSizePixel=0
    prevBtn.Text=""; prevBtn.AutoButtonColor=false; prevBtn.ZIndex=3; prevBtn.Parent=f
    Util.Corner(prevBtn,UDim.new(0,5)); local prevStroke=Util.Stroke(prevBtn,Theme.PickerBorder,1)

    local hexLbl=Instance.new("TextLabel"); hexLbl.Size=UDim2.new(1,0,1,0); hexLbl.BackgroundTransparency=1
    hexLbl.Text="#"..Util.Color3toHex(currentColor); hexLbl.Font=Enum.Font.GothamBold; hexLbl.TextSize=8
    hexLbl.TextColor3=Color3.new(1,1,1); hexLbl.TextXAlignment=Enum.TextXAlignment.Center; hexLbl.ZIndex=4; hexLbl.Parent=prevBtn

    -- Layout do painel: sv | hue | [alpha se useAlpha]
    local pW,pPad = Config.ColorPanelW, 8
    local alphaExtra = useAlpha and (Config.ColorAlphaW+Config.ColorAlphaGap) or 0
    local svSize = pW-(pPad*2)-Config.ColorHueW-Config.ColorHueGap-alphaExtra
    local totalH = pPad+svSize+14+28+pPad

    local panel=Instance.new("Frame"); panel.Size=UDim2.new(0,pW,0,0); panel.Position=UDim2.new(1,-pW,1,4)
    panel.AnchorPoint=Vector2.new(1,0); panel.BackgroundColor3=Theme.Surface; panel.BorderSizePixel=0
    panel.ClipsDescendants=true; panel.Visible=false; panel.ZIndex=30; panel.Parent=f
    Util.Corner(panel,UDim.new(0,8)); Util.Stroke(panel,Theme.Border,1)
    local pp=Instance.new("UIPadding"); pp.PaddingTop=UDim.new(0,pPad); pp.PaddingBottom=UDim.new(0,pPad)
    pp.PaddingLeft=UDim.new(0,pPad); pp.PaddingRight=UDim.new(0,pPad); pp.Parent=panel

    -- SV picker
    local svPick=Instance.new("ImageLabel"); svPick.Size=UDim2.new(0,svSize,0,svSize); svPick.Position=UDim2.new(0,0,0,0)
    svPick.BackgroundColor3=Color3.fromHSV(hue,1,1); svPick.BorderSizePixel=0; svPick.ZIndex=31; svPick.Parent=panel
    Util.Corner(svPick,UDim.new(0,4))
    local svGW=Instance.new("UIGradient"); svGW.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(1,Color3.new(1,1,1))}
    svGW.Transparency=NumberSequence.new{NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)}; svGW.Parent=svPick
    local svGB=Instance.new("Frame"); svGB.Size=UDim2.new(1,0,1,0); svGB.BackgroundTransparency=1; svGB.BorderSizePixel=0; svGB.ZIndex=32; svGB.Parent=svPick; Util.Corner(svGB,UDim.new(0,4))
    local svGBg=Instance.new("UIGradient"); svGBg.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(1,Color3.new(0,0,0))}
    svGBg.Transparency=NumberSequence.new{NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)}; svGBg.Rotation=90; svGBg.Parent=svGB
    local svCur=Instance.new("Frame"); svCur.Size=UDim2.new(0,10,0,10); svCur.AnchorPoint=Vector2.new(.5,.5)
    svCur.Position=UDim2.new(sat,0,1-val,0); svCur.BackgroundColor3=Color3.new(1,1,1); svCur.BorderSizePixel=0; svCur.ZIndex=34; svCur.Parent=svPick
    Util.Corner(svCur,UDim.new(1,0)); Util.Stroke(svCur,Color3.new(0,0,0),1.5)

    -- Hue slider
    local hueSlider=Instance.new("Frame"); hueSlider.Size=UDim2.new(0,Config.ColorHueW,0,svSize)
    hueSlider.Position=UDim2.new(0,svSize+Config.ColorHueGap,0,0); hueSlider.BackgroundColor3=Color3.new(1,1,1)
    hueSlider.BorderSizePixel=0; hueSlider.ZIndex=31; hueSlider.Parent=panel; Util.Corner(hueSlider,UDim.new(0,4))
    local hGrad=Instance.new("UIGradient"); hGrad.Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0,Color3.fromHSV(0,1,1)),ColorSequenceKeypoint.new(0.17,Color3.fromHSV(.17,1,1)),
        ColorSequenceKeypoint.new(0.33,Color3.fromHSV(.33,1,1)),ColorSequenceKeypoint.new(0.5,Color3.fromHSV(.5,1,1)),
        ColorSequenceKeypoint.new(0.67,Color3.fromHSV(.67,1,1)),ColorSequenceKeypoint.new(0.83,Color3.fromHSV(.83,1,1)),
        ColorSequenceKeypoint.new(1,Color3.fromHSV(1,1,1)),
    }; hGrad.Rotation=90; hGrad.Parent=hueSlider
    local hueCur=Instance.new("Frame"); hueCur.Size=UDim2.new(1,4,0,4); hueCur.AnchorPoint=Vector2.new(.5,.5)
    hueCur.Position=UDim2.new(.5,0,hue,0); hueCur.BackgroundColor3=Color3.new(1,1,1); hueCur.BorderSizePixel=0; hueCur.ZIndex=33; hueCur.Parent=hueSlider
    Util.Corner(hueCur,UDim.new(0,2)); Util.Stroke(hueCur,Color3.new(0,0,0),1)

    -- Alpha slider (opcional)
    local alphaSlider,alphaCur,alphaGrad
    if useAlpha then
        local aX=svSize+Config.ColorHueGap+Config.ColorHueW+Config.ColorAlphaGap
        alphaSlider=Instance.new("Frame"); alphaSlider.Size=UDim2.new(0,Config.ColorAlphaW,0,svSize)
        alphaSlider.Position=UDim2.new(0,aX,0,0); alphaSlider.BackgroundColor3=Color3.new(1,1,1)
        alphaSlider.BorderSizePixel=0; alphaSlider.ZIndex=31; alphaSlider.Parent=panel; Util.Corner(alphaSlider,UDim.new(0,4))
        alphaGrad=Instance.new("UIGradient"); alphaGrad.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,currentColor),ColorSequenceKeypoint.new(1,Color3.new(.12,.12,.12))}
        alphaGrad.Rotation=90; alphaGrad.Parent=alphaSlider
        alphaCur=Instance.new("Frame"); alphaCur.Size=UDim2.new(1,4,0,4); alphaCur.AnchorPoint=Vector2.new(.5,.5)
        alphaCur.Position=UDim2.new(.5,0,1-alpha,0); alphaCur.BackgroundColor3=Color3.new(1,1,1); alphaCur.BorderSizePixel=0; alphaCur.ZIndex=33; alphaCur.Parent=alphaSlider
        Util.Corner(alphaCur,UDim.new(0,2)); Util.Stroke(alphaCur,Color3.new(0,0,0),1)
    end

    -- Separador
    local sep=Instance.new("Frame"); sep.Size=UDim2.new(1,0,0,1); sep.Position=UDim2.new(0,0,0,svSize+12)
    sep.BackgroundColor3=Theme.SectionLine; sep.BorderSizePixel=0; sep.ZIndex=31; sep.Parent=panel

    -- Linha inferior
    local botRow=Instance.new("Frame"); botRow.Size=UDim2.new(1,0,0,28); botRow.Position=UDim2.new(0,0,0,svSize+27)
    botRow.BackgroundTransparency=1; botRow.BorderSizePixel=0; botRow.ZIndex=31; botRow.Parent=panel
    local colPrev=Instance.new("Frame"); colPrev.Size=UDim2.new(0,28,1,0); colPrev.BackgroundColor3=currentColor
    colPrev.BorderSizePixel=0; colPrev.ZIndex=32; colPrev.Parent=botRow; Util.Corner(colPrev,UDim.new(0,5)); Util.Stroke(colPrev,Theme.Border,1)

    local alphaLbl
    if useAlpha then
        alphaLbl=Instance.new("TextLabel"); alphaLbl.Size=UDim2.new(0,30,1,0); alphaLbl.Position=UDim2.new(0,32,0,0)
        alphaLbl.BackgroundTransparency=1; alphaLbl.Text=math.floor(alpha*100).."%"
        alphaLbl.Font=Enum.Font.GothamBold; alphaLbl.TextSize=9; alphaLbl.TextColor3=Theme.TextSecondary; alphaLbl.ZIndex=32; alphaLbl.Parent=botRow
    end

    local hexOff=useAlpha and 66 or 34
    local hexBox=Instance.new("TextBox"); hexBox.Size=UDim2.new(1,-hexOff,1,0); hexBox.Position=UDim2.new(0,hexOff-2,0,0)
    hexBox.BackgroundColor3=Theme.InputBg; hexBox.BorderSizePixel=0; hexBox.Text=Util.Color3toHex(currentColor)
    hexBox.PlaceholderText="RRGGBB"; hexBox.PlaceholderColor3=Theme.TextDisabled
    hexBox.Font=Enum.Font.GothamBold; hexBox.TextSize=10; hexBox.TextColor3=Theme.InputText
    hexBox.TextXAlignment=Enum.TextXAlignment.Center; hexBox.ClearTextOnFocus=false; hexBox.ZIndex=32; hexBox.Parent=botRow
    Util.Corner(hexBox,UDim.new(0,5)); Util.Stroke(hexBox,Theme.InputBorder,1)

    -- Lógica de cor
    local function applyHSV(h,s,v,fromHex)
        hue=Util.Clamp(h,0,1); sat=Util.Clamp(s,0,1); val=Util.Clamp(v,0,1)
        currentColor=Color3.fromHSV(hue,sat,val)
        svPick.BackgroundColor3=Color3.fromHSV(hue,1,1)
        svCur.Position=UDim2.new(sat,0,1-val,0); hueCur.Position=UDim2.new(.5,0,hue,0)
        if alphaGrad then alphaGrad.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,currentColor),ColorSequenceKeypoint.new(1,Color3.new(.12,.12,.12))} end
        colPrev.BackgroundColor3=currentColor; prevBtn.BackgroundColor3=currentColor
        local hs=Util.Color3toHex(currentColor); if not fromHex then hexBox.Text=hs end; hexLbl.Text="#"..hs
        local bright=currentColor.R*.299+currentColor.G*.587+currentColor.B*.114
        hexLbl.TextColor3=bright>.5 and Color3.new(0,0,0) or Color3.new(1,1,1)
        if cb then pcall(cb,currentColor,alpha) end
    end
    local function applyAlpha(a)
        alpha=Util.Clamp(a,0,1)
        if alphaCur then alphaCur.Position=UDim2.new(.5,0,1-alpha,0) end
        if alphaLbl then alphaLbl.Text=math.floor(alpha*100).."%" end
        if cb then pcall(cb,currentColor,alpha) end
    end

    -- Drag helpers
    local function makeDragSlider(hitParent,zIdx,onMove,endBtn)
        local h=Instance.new("TextButton"); h.Size=UDim2.new(1,0,1,0); h.BackgroundTransparency=1
        h.Text=""; h.ZIndex=zIdx; h.AutoButtonColor=false; h.Parent=hitParent
        local conns={}
        h.MouseButton1Down:Connect(function()
            onMove(UserInputService:GetMouseLocation())
            Util.DisconnectAll(conns)
            conns[1]=UserInputService.InputChanged:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseMovement then onMove(i.Position) end
            end)
            conns[2]=UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType==endBtn then Util.DisconnectAll(conns) end
            end)
        end)
        return conns
    end

    local svConns  = makeDragSlider(svPick,35,function(pos)
        local w=svPick.AbsoluteSize.X; local hh=svPick.AbsoluteSize.Y; if w==0 or hh==0 then return end
        applyHSV(hue, Util.Clamp(pos.X-svPick.AbsolutePosition.X,0,w)/w,
                      1-Util.Clamp(pos.Y-svPick.AbsolutePosition.Y,0,hh)/hh, false)
    end, Enum.UserInputType.MouseButton1)

    local hueConns = makeDragSlider(hueSlider,34,function(pos)
        local hh=hueSlider.AbsoluteSize.Y; if hh==0 then return end
        applyHSV(Util.Clamp(pos.Y-hueSlider.AbsolutePosition.Y,0,hh)/hh, sat, val, false)
    end, Enum.UserInputType.MouseButton1)

    local alphaConns={}
    if useAlpha and alphaSlider then
        alphaConns = makeDragSlider(alphaSlider,34,function(pos)
            local hh=alphaSlider.AbsoluteSize.Y; if hh==0 then return end
            applyAlpha(1-Util.Clamp(pos.Y-alphaSlider.AbsolutePosition.Y,0,hh)/hh)
        end, Enum.UserInputType.MouseButton1)
    end

    hexBox.FocusLost:Connect(function()
        local raw=hexBox.Text:gsub("#",""):upper()
        if #raw==6 then
            local ok,p=pcall(Color3.fromHex,"#"..raw)
            if ok and p then local h2,s2,v2=Util.Color3toHSV(p); applyHSV(h2,s2,v2,true); hexBox.Text=Util.Color3toHex(currentColor) end
        end
    end)

    local isOpen=false
    local function closePanel()
        if not isOpen then return end; isOpen=false
        if _openPickerClose==closePanel then _openPickerClose=nil end
        Util.Tween(panel,     Config.TweenFast,{Size=UDim2.new(0,pW,0,0)})
        Util.Tween(stroke,    Config.TweenFast,{Color=Theme.Border})
        Util.Tween(prevStroke,Config.TweenFast,{Color=Theme.PickerBorder})
        task.delay(Config.TweenFast.Time+.02,function() if not isOpen then panel.Visible=false end end)
    end
    local function openPanel()
        if _openPickerClose then _openPickerClose() end; _openPickerClose=closePanel; isOpen=true
        panel.Visible=true; panel.Size=UDim2.new(0,pW,0,0)
        Util.Tween(panel,     Config.TweenFast,{Size=UDim2.new(0,pW,0,totalH)})
        Util.Tween(stroke,    Config.TweenFast,{Color=Theme.Accent})
        Util.Tween(prevStroke,Config.TweenFast,{Color=Theme.Accent})
    end
    prevBtn.MouseButton1Click:Connect(function() if isOpen then closePanel() else openPanel() end end)
    local outsideConn=UserInputService.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 and isOpen then
            task.defer(function() if isOpen then closePanel() end end) end
    end)
    wrap.AncestryChanged:Connect(function()
        if not wrap.Parent then
            Util.DisconnectAll(svConns); Util.DisconnectAll(hueConns); Util.DisconnectAll(alphaConns)
            if isOpen then closePanel() end; outsideConn:Disconnect()
        end
    end)

    local obj={}
    function obj:GetColor() return currentColor end
    function obj:GetAlpha() return alpha end
    function obj:SetColor(c,silent)
        local h2,s2,v2=Util.Color3toHSV(c)
        if silent then local sv=cb;cb=nil; applyHSV(h2,s2,v2,false); cb=sv else applyHSV(h2,s2,v2,false) end
    end
    function obj:SetAlpha(a,silent)
        if silent then local sv=cb;cb=nil; applyAlpha(a); cb=sv else applyAlpha(a) end
    end
    function obj:SetText(t) nameLbl.Text=t or "" end
    return obj
end

-- ── NOTIFICAÇÕES ─────────────────────────────────────────────────────────────
local _notifyGui=nil; local _notifyStack={}

local NotifyTypes={
    info    ={color=Theme.NotifyInfo,   icon="ℹ"},
    success ={color=Theme.NotifySuccess,icon="✓"},
    warning ={color=Theme.NotifyWarning,icon="⚠"},
    error   ={color=Theme.NotifyError,  icon="✕"},
    default ={color=Theme.Accent,       icon="◈"},
}

local ModernNoir={_Version="0.3.2", _Windows={}}  -- declarado cedo para cleanupNotifyGui

local function cleanupNotifyGui()
    if #_notifyStack>0 or #ModernNoir._Windows>0 then return end
    if _notifyGui and _notifyGui.Parent then _notifyGui:Destroy(); _notifyGui=nil end
end

local function getNotifyGui()
    if _notifyGui and _notifyGui.Parent then return _notifyGui end
    local ng=Instance.new("ScreenGui"); ng.Name="ModernNoir_Notify"; ng.ResetOnSpawn=false
    ng.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; ng.DisplayOrder=200; ng.IgnoreGuiInset=false; ng.Parent=GuiParent
    _notifyGui=ng; return ng
end

local function reshuffleNotify()
    local cam=workspace.CurrentCamera; if not cam then return end
    local vp=cam.ViewportSize; local cumY=Config.NotifyPadB
    for i=#_notifyStack,1,-1 do
        local e=_notifyStack[i]
        if e and e.card and e.card.Parent then
            local ty=vp.Y-cumY-Config.NotifyH; local tx=vp.X-Config.NotifyW-Config.NotifyPadR
            Util.Tween(e.card,Config.TweenMedium,{Position=UDim2.new(0,tx,0,ty)}); e.targetY=ty
            cumY=cumY+Config.NotifyH+Config.NotifyGap
        end
    end
end

local function createNotify(title,body,duration,notifyType)
    local ng=getNotifyGui(); local cam=workspace.CurrentCamera; if not cam then return end
    local vp=cam.ViewportSize; local td=NotifyTypes[notifyType] or NotifyTypes.default
    local w,h=Config.NotifyW,Config.NotifyH

    local card=Instance.new("Frame"); card.Name="NotifyCard"; card.Size=UDim2.new(0,w,0,h)
    card.Position=UDim2.new(0,vp.X+w+10,0,vp.Y-Config.NotifyPadB-h); card.BackgroundColor3=Theme.NotifyBg
    card.BorderSizePixel=0; card.ClipsDescendants=true; card.ZIndex=10; card.Parent=ng
    Util.Corner(card,UDim.new(0,8)); Util.Stroke(card,Theme.Border,1)

    local ab=Instance.new("Frame"); ab.Size=UDim2.new(0,3,1,0); ab.BackgroundColor3=td.color
    ab.BorderSizePixel=0; ab.ZIndex=11; ab.Parent=card; Util.Corner(ab,UDim.new(0,2))
    local ico=Instance.new("TextLabel"); ico.Size=UDim2.new(0,18,0,18); ico.Position=UDim2.new(0,12,0,10)
    ico.BackgroundTransparency=1; ico.Text=td.icon; ico.Font=Enum.Font.GothamBold; ico.TextSize=12; ico.TextColor3=td.color; ico.ZIndex=12; ico.Parent=card
    local titL=Instance.new("TextLabel"); titL.Size=UDim2.new(1,-38,0,18); titL.Position=UDim2.new(0,34,0,10)
    titL.BackgroundTransparency=1; titL.Text=title or "Notificação"; titL.Font=Enum.Font.GothamBold; titL.TextSize=12
    titL.TextColor3=Theme.TextPrimary; titL.TextXAlignment=Enum.TextXAlignment.Left; titL.TextTruncate=Enum.TextTruncate.AtEnd; titL.ZIndex=12; titL.Parent=card
    local bodL=Instance.new("TextLabel"); bodL.Size=UDim2.new(1,-20,0,26); bodL.Position=UDim2.new(0,12,0,32)
    bodL.BackgroundTransparency=1; bodL.Text=body or ""; bodL.Font=Enum.Font.Gotham; bodL.TextSize=11
    bodL.TextColor3=Theme.TextSecondary; bodL.TextXAlignment=Enum.TextXAlignment.Left; bodL.TextWrapped=true; bodL.TextTruncate=Enum.TextTruncate.AtEnd; bodL.ZIndex=12; bodL.Parent=card
    local barBg=Instance.new("Frame"); barBg.Size=UDim2.new(1,0,0,Config.NotifyBarH); barBg.Position=UDim2.new(0,0,0,h-Config.NotifyBarH)
    barBg.BackgroundColor3=Theme.NotifyBarBg; barBg.BorderSizePixel=0; barBg.ZIndex=11; barBg.Parent=card
    local barF=Instance.new("Frame"); barF.Size=UDim2.new(1,0,1,0); barF.BackgroundColor3=td.color; barF.BorderSizePixel=0; barF.ZIndex=12; barF.Parent=barBg
    local cx=Instance.new("TextButton"); cx.Size=UDim2.new(0,16,0,16); cx.Position=UDim2.new(1,-20,0,7)
    cx.BackgroundTransparency=1; cx.Text="×"; cx.Font=Enum.Font.GothamBold; cx.TextSize=13; cx.TextColor3=Theme.TextDisabled; cx.ZIndex=13; cx.Parent=card
    cx.MouseEnter:Connect(function() Util.Tween(cx,Config.TweenFast,{TextColor3=Theme.CloseRedHover}) end)
    cx.MouseLeave:Connect(function() Util.Tween(cx,Config.TweenFast,{TextColor3=Theme.TextDisabled}) end)

    local entry={card=card}; table.insert(_notifyStack,entry)
    task.defer(function()
        reshuffleNotify()
        Util.Tween(card,TweenInfo.new(Config.NotifySlideT,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),
            {Position=UDim2.new(0,vp.X-w-Config.NotifyPadR,0,entry.targetY or vp.Y-Config.NotifyPadB-h)})
    end)
    local dur=duration or Config.NotifyDur
    task.delay(Config.NotifySlideT*.6,function()
        if barF.Parent then Util.Tween(barF,TweenInfo.new(dur,Enum.EasingStyle.Linear,Enum.EasingDirection.Out),{Size=UDim2.new(0,0,1,0)}) end
    end)
    local gone=false
    local function dismiss()
        if gone then return end; gone=true
        for i,e in ipairs(_notifyStack) do if e==entry then table.remove(_notifyStack,i); break end end
        reshuffleNotify()
        Util.Tween(card,TweenInfo.new(Config.NotifyFadeT,Enum.EasingStyle.Quart,Enum.EasingDirection.In),
            {Position=UDim2.new(0,vp.X+20,0,card.Position.Y.Offset),BackgroundTransparency=1})
        task.delay(Config.NotifyFadeT+.05,function()
            if card.Parent then card:Destroy() end; cleanupNotifyGui()
        end)
    end
    task.delay(dur+Config.NotifySlideT,dismiss); cx.MouseButton1Click:Connect(dismiss)
end

-- ── SWITCH TAB ────────────────────────────────────────────────────────────────
local function SwitchTab(win,newTab)
    if win._ActiveTab==newTab then return end
    local tFade=TweenInfo.new(Config.TabFadeT,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
    local tInd =TweenInfo.new(Config.TabIndT, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local prev=win._ActiveTab
    if prev then
        local fo=Util.Tween(prev._Canvas,tFade,{GroupTransparency=1})
        Util.Tween(prev._Button,Config.TweenFast,{BackgroundColor3=Theme.Surface})
        Util.Tween(prev._Label, Config.TweenFast,{TextColor3=Theme.TextSecondary})
        Util.Tween(prev._Ind,tInd,{Size=UDim2.new(0,Config.TabIndW,1,-10),BackgroundTransparency=0.5})
        local pc=prev._Canvas
        fo.Completed:Connect(function()
            if pc and pc.Parent and not(win._ActiveTab and win._ActiveTab._Canvas==pc) then pc.Visible=false end
        end)
    end
    newTab._Canvas.GroupTransparency=1; newTab._Canvas.Visible=true
    Util.Tween(newTab._Canvas,tFade,{GroupTransparency=0})
    Util.Tween(newTab._Button,Config.TweenFast,{BackgroundColor3=Theme.SurfaceAlt})
    Util.Tween(newTab._Label, Config.TweenFast,{TextColor3=Theme.AccentGlow})
    Util.Tween(newTab._Ind,tInd,{Size=UDim2.new(0,Config.TabIndActive,1,-6),BackgroundTransparency=0})
    win._ActiveTab=newTab
end

-- ── LIBRARY API ───────────────────────────────────────────────────────────────
function ModernNoir:Notify(title,text,duration,notifyType)
    createNotify(title,text,duration,notifyType or "default")
end

function ModernNoir:SetTheme(t)
    if type(t)~="table" then return end
    for k,v in pairs(t) do if Theme[k]~=nil and typeof(v)=="Color3" then Theme[k]=v end end
    NotifyTypes.info.color=Theme.NotifyInfo; NotifyTypes.success.color=Theme.NotifySuccess
    NotifyTypes.warning.color=Theme.NotifyWarning; NotifyTypes.error.color=Theme.NotifyError
    NotifyTypes.default.color=Theme.Accent
end

function ModernNoir.CreateWindow(opts)
    local title     = type(opts)=="string" and opts or (opts and opts.Title or "Modern Noir")
    local toggleKey = type(opts)=="table"  and opts.ToggleKey or nil

    local sg=Instance.new("ScreenGui"); sg.Name="ModernNoir_"..title; sg.ResetOnSpawn=false
    sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; sg.DisplayOrder=100; sg.IgnoreGuiInset=false; sg.Parent=GuiParent

    local mf=Instance.new("Frame"); mf.Name="MainFrame"
    mf.Size=UDim2.new(0,Config.WindowWidth,0,Config.WindowHeight)
    mf.AnchorPoint=Vector2.new(.5,.5); mf.Position=UDim2.new(.5,0,.5,0)
    mf.BackgroundColor3=Theme.Background; mf.BorderSizePixel=0; mf.ClipsDescendants=true; mf.Parent=sg
    Util.Corner(mf); Util.Stroke(mf,Theme.Border,Config.BorderW)

    local uiScale=Instance.new("UIScale"); uiScale.Scale=1; uiScale.Parent=mf
    local function getNativeScale()
        local cam=workspace.CurrentCamera; if not cam then return 1 end
        local vp=cam.ViewportSize
        return math.min(vp.X/Config.WindowWidth, vp.Y/Config.WindowHeight, 1)
    end
    local vpConn; uiScale.Scale=getNativeScale()
    vpConn=workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() uiScale.Scale=getNativeScale() end)

    local sh=Instance.new("ImageLabel"); sh.Size=UDim2.new(1,40,1,40); sh.Position=UDim2.new(0,-20,0,-10)
    sh.BackgroundTransparency=1; sh.Image="rbxassetid://6014261993"; sh.ImageColor3=Color3.new(0,0,0); sh.ImageTransparency=0.6
    sh.ScaleType=Enum.ScaleType.Slice; sh.SliceCenter=Rect.new(49,49,450,450); sh.ZIndex=-1; sh.Parent=mf

    local topLine=Instance.new("Frame"); topLine.Size=UDim2.new(1,0,0,2); topLine.BackgroundColor3=Theme.Accent
    topLine.BorderSizePixel=0; topLine.ZIndex=5; topLine.Parent=mf

    local hdr=Instance.new("Frame"); hdr.Name="Header"; hdr.Size=UDim2.new(1,0,0,Config.HeaderHeight)
    hdr.BackgroundColor3=Theme.Surface; hdr.BorderSizePixel=0; hdr.ZIndex=4; hdr.Parent=mf
    local hdiv=Instance.new("Frame"); hdiv.Size=UDim2.new(1,0,0,1); hdiv.Position=UDim2.new(0,0,1,0)
    hdiv.BackgroundColor3=Theme.Border; hdiv.BorderSizePixel=0; hdiv.Parent=hdr

    local hico=Instance.new("TextLabel"); hico.Size=UDim2.new(0,Config.HeaderHeight,1,0); hico.Position=UDim2.new(0,32,0,0)
    hico.BackgroundTransparency=1; hico.Text="◈"; hico.Font=Enum.Font.GothamBold; hico.TextSize=13
    hico.TextColor3=Theme.Accent; hico.ZIndex=5; hico.Parent=hdr
    local htitle=Instance.new("TextLabel"); htitle.Size=UDim2.new(1,-120,1,0); htitle.Position=UDim2.new(0,58,0,0)
    htitle.BackgroundTransparency=1; htitle.Text=title; htitle.Font=Enum.Font.GothamSemibold; htitle.TextSize=13
    htitle.TextColor3=Theme.TextPrimary; htitle.TextXAlignment=Enum.TextXAlignment.Left; htitle.ZIndex=5; htitle.Parent=hdr

    local closeBtn    = Util.HeaderButton(hdr,UDim2.new(1,-18,.5,0),Theme.CloseRed, Theme.CloseRedHover,"×")
    local minimizeBtn = Util.HeaderButton(hdr,UDim2.new(1,-38,.5,0),Theme.Accent,   Theme.AccentGlow,   "−")

    -- Drag suave
    local dragging=false; local dragInput=nil; local dragStart=nil; local startPos=nil
    local targetPos=mf.Position; local renderConn=nil; local inputChangedConn=nil

    local function updateDrag(inp)
        local delta=inp.Position-dragStart; local cam=workspace.CurrentCamera; if not cam then return end
        local vp=cam.ViewportSize; local s=uiScale.Scale
        local halfW=(Config.WindowWidth*s)/2; local halfH=(Config.WindowHeight*s)/2
        targetPos=UDim2.new(.5,Util.Clamp(startPos.X.Offset+delta.X,halfW-vp.X/2,vp.X/2-halfW),
                             .5,Util.Clamp(startPos.Y.Offset+delta.Y,halfH-vp.Y/2,vp.Y/2-halfH))
    end
    hdr.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=i.Position; startPos=mf.Position
            renderConn=RunService.Heartbeat:Connect(function(dt)
                local a=1-math.pow(1-Config.DragSmooth,dt*60); local c=mf.Position
                mf.Position=UDim2.new(.5,c.X.Offset+(targetPos.X.Offset-c.X.Offset)*a,
                                      .5,c.Y.Offset+(targetPos.Y.Offset-c.Y.Offset)*a)
            end)
            i.Changed:Connect(function()
                if i.UserInputState==Enum.UserInputState.End then dragging=false
                    if renderConn then renderConn:Disconnect(); renderConn=nil end end
            end)
        end
    end)
    hdr.InputChanged:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then dragInput=i end
    end)
    inputChangedConn=UserInputService.InputChanged:Connect(function(i) if dragging and i==dragInput then updateDrag(i) end end)

    -- Sidebar
    local sb=Instance.new("Frame"); sb.Name="Sidebar"
    sb.Size=UDim2.new(0,Config.SidebarWidth,1,-(Config.HeaderHeight+1)); sb.Position=UDim2.new(0,0,0,Config.HeaderHeight+1)
    sb.BackgroundColor3=Theme.Surface; sb.BorderSizePixel=0; sb.ClipsDescendants=true; sb.Parent=mf
    local sdiv=Instance.new("Frame"); sdiv.Size=UDim2.new(0,1,1,0); sdiv.Position=UDim2.new(1,0,0,0)
    sdiv.BackgroundColor3=Theme.Border; sdiv.BorderSizePixel=0; sdiv.Parent=sb

    -- Search bar
    local sFr=Instance.new("Frame"); sFr.Size=UDim2.new(1,-8,0,Config.SearchH); sFr.Position=UDim2.new(0,4,0,6)
    sFr.BackgroundColor3=Theme.SearchBg; sFr.BorderSizePixel=0; sFr.ZIndex=3; sFr.Parent=sb
    Util.Corner(sFr,UDim.new(0,5)); local sStroke=Util.Stroke(sFr,Theme.SearchBorder,1)
    local sIco=Instance.new("TextLabel"); sIco.Size=UDim2.new(0,18,1,0); sIco.Position=UDim2.new(0,4,0,0)
    sIco.BackgroundTransparency=1; sIco.Text="⌕"; sIco.Font=Enum.Font.GothamBold; sIco.TextSize=11
    sIco.TextColor3=Theme.TextDisabled; sIco.ZIndex=4; sIco.Parent=sFr
    local sBox=Instance.new("TextBox"); sBox.Size=UDim2.new(1,-24,1,0); sBox.Position=UDim2.new(0,20,0,0)
    sBox.BackgroundTransparency=1; sBox.Text=""; sBox.PlaceholderText="Buscar..."; sBox.PlaceholderColor3=Theme.TextDisabled
    sBox.Font=Enum.Font.Gotham; sBox.TextSize=10; sBox.TextColor3=Theme.TextSecondary
    sBox.TextXAlignment=Enum.TextXAlignment.Left; sBox.ClearTextOnFocus=false; sBox.ZIndex=4; sBox.Parent=sFr
    sBox.Focused:Connect(function() Util.Tween(sStroke,Config.TweenFast,{Color=Theme.Accent}); Util.Tween(sIco,Config.TweenFast,{TextColor3=Theme.Accent}) end)
    sBox.FocusLost:Connect(function()
        if sBox.Text=="" then Util.Tween(sStroke,Config.TweenFast,{Color=Theme.SearchBorder}); Util.Tween(sIco,Config.TweenFast,{TextColor3=Theme.TextDisabled}) end
    end)

    local sbScroll=Instance.new("ScrollingFrame"); sbScroll.Size=UDim2.new(1,-1,1,-(Config.SearchH+12+28))
    sbScroll.Position=UDim2.new(0,0,0,Config.SearchH+12); sbScroll.BackgroundTransparency=1; sbScroll.BorderSizePixel=0
    sbScroll.ScrollBarThickness=0; sbScroll.CanvasSize=UDim2.new(0,0,0,0); sbScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
    sbScroll.ScrollingDirection=Enum.ScrollingDirection.Y; sbScroll.ClipsDescendants=true; sbScroll.Parent=sb
    local tList=Instance.new("UIListLayout"); tList.SortOrder=Enum.SortOrder.LayoutOrder; tList.Padding=UDim.new(0,3); tList.Parent=sbScroll
    local sPad=Instance.new("UIPadding"); sPad.PaddingTop=UDim.new(0,4); sPad.PaddingLeft=UDim.new(0,0); sPad.PaddingRight=UDim.new(0,6); sPad.Parent=sbScroll

    local brandF=Instance.new("Frame"); brandF.Size=UDim2.new(1,-1,0,28); brandF.Position=UDim2.new(0,0,1,-28)
    brandF.BackgroundColor3=Theme.Surface; brandF.BorderSizePixel=0; brandF.ZIndex=2; brandF.Parent=sb
    local brand=Instance.new("TextLabel"); brand.Size=UDim2.new(1,0,1,0); brand.BackgroundTransparency=1
    brand.Text="◈ v"..ModernNoir._Version; brand.Font=Enum.Font.Gotham; brand.TextSize=9
    brand.TextColor3=Theme.AccentDim; brand.TextXAlignment=Enum.TextXAlignment.Center; brand.Parent=brandF

    local cf=Instance.new("Frame"); cf.Name="Content"
    cf.Size=UDim2.new(1,-Config.SidebarWidth,1,-(Config.HeaderHeight+1)); cf.Position=UDim2.new(0,Config.SidebarWidth,0,Config.HeaderHeight+1)
    cf.BackgroundColor3=Theme.Background; cf.BorderSizePixel=0; cf.ClipsDescendants=true; cf.Parent=mf

    -- Animação de entrada
    local ns=getNativeScale(); uiScale.Scale=0.88; mf.BackgroundTransparency=1
    TweenService:Create(uiScale,Config.TweenMedium,{Scale=ns}):Play()
    TweenService:Create(mf,     Config.TweenMedium,{BackgroundTransparency=0}):Play()

    local visible=true; local toggleConn=nil
    if toggleKey then
        toggleConn=UserInputService.InputBegan:Connect(function(inp,gp)
            if gp then return end
            if inp.KeyCode==toggleKey then visible=not visible; mf.Visible=visible end
        end)
    end

    -- MELHORIA: 1 única conexão de search na window (não por aba)
    local _tabRegistry={}
    local searchConn=sBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q=sBox.Text:lower()
        for _,e in ipairs(_tabRegistry) do
            e.button.Visible = q=="" or (e.name:lower():find(q,1,true)~=nil)
        end
    end)

    -- MELHORIA: minimize/restore com Util.Tween para consistência
    local minimized=false
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized=not minimized
        if minimized then
            Util.Tween(mf,Config.TweenMedium,{Size=UDim2.new(0,Config.WindowWidth,0,Config.MinimizeH)})
            Util.Tween(sb,Config.TweenFast,  {BackgroundTransparency=1})
            Util.Tween(cf,Config.TweenFast,  {BackgroundTransparency=1})
        else
            Util.Tween(mf,Config.TweenMedium,{Size=UDim2.new(0,Config.WindowWidth,0,Config.WindowHeight)})
            Util.Tween(sb,Config.TweenMedium,{BackgroundTransparency=0})
            Util.Tween(cf,Config.TweenMedium,{BackgroundTransparency=0})
        end
    end)

    -- Destroy centralizado: limpa TUDO
    local destroyed=false
    local function doDestroy()
        if destroyed then return end; destroyed=true
        inputChangedConn:Disconnect()
        searchConn:Disconnect()  -- MELHORIA: searchConn desconectado aqui
        vpConn:Disconnect()
        if renderConn then renderConn:Disconnect(); renderConn=nil end
        if toggleConn then toggleConn:Disconnect(); toggleConn=nil end
        if _openDropdownClose then _openDropdownClose(); _openDropdownClose=nil end
        if _openPickerClose   then _openPickerClose();   _openPickerClose=nil end
        for i,w in ipairs(ModernNoir._Windows) do if w==Window then table.remove(ModernNoir._Windows,i); break end end
        table.clear(_tabRegistry)
        Util.Tween(mf,Config.TweenFast,{BackgroundTransparency=1})
        task.delay(Config.TweenFast.Time+.05,function()
            if sg.Parent then sg:Destroy() end
            cleanupNotifyGui()  -- MELHORIA: limpa _notifyGui se não há mais janelas
        end)
    end
    closeBtn.MouseButton1Click:Connect(doDestroy)

    local Window={}
    Window.Frame=mf; Window.Sidebar=sb; Window.Content=cf
    Window._Tabs={}; Window._ActiveTab=nil

    function Window:Destroy()     doDestroy() end
    function Window:SetTitle(t)   htitle.Text=t or "" end
    function Window:SetVisible(v) visible=v; mf.Visible=v end

    -- MELHORIA: Show() com animação suave de escala + transparência
    function Window:Show()
        if visible then return end; visible=true; mf.Visible=true
        uiScale.Scale=0.92; mf.BackgroundTransparency=1
        Util.Tween(uiScale,Config.TweenShow,{Scale=getNativeScale()})
        Util.Tween(mf,     Config.TweenShow,{BackgroundTransparency=0})
    end

    -- MELHORIA: Hide() com animação suave, esconde após conclusão
    function Window:Hide()
        if not visible then return end; visible=false
        local t=Util.Tween(uiScale,Config.TweenHide,{Scale=0.92})
        Util.Tween(mf,Config.TweenHide,{BackgroundTransparency=1})
        t.Completed:Connect(function() if not visible then mf.Visible=false end end)
    end

    function Window:AddTab(name, iconID)
        name=name or ("Aba "..#self._Tabs+1); local idx=#self._Tabs+1

        local tbtn=Instance.new("TextButton"); tbtn.Size=UDim2.new(1,0,0,Config.TabH)
        tbtn.BackgroundColor3=Theme.Surface; tbtn.BorderSizePixel=0; tbtn.Text=""; tbtn.AutoButtonColor=false
        tbtn.LayoutOrder=idx; tbtn.ClipsDescendants=false; tbtn.Parent=sbScroll; Util.Corner(tbtn,UDim.new(0,5))

        local ind=Instance.new("Frame"); ind.AnchorPoint=Vector2.new(0,.5)
        ind.Size=UDim2.new(0,Config.TabIndW,1,-10); ind.Position=UDim2.new(0,0,.5,0)
        ind.BackgroundColor3=Theme.Accent; ind.BackgroundTransparency=0.5; ind.BorderSizePixel=0; ind.ZIndex=2; ind.Parent=tbtn
        Util.Corner(ind,UDim.new(0,2))

        local tIco=Instance.new("ImageLabel"); tIco.Size=UDim2.new(0,14,0,14); tIco.Position=UDim2.new(0,14,.5,-7)
        tIco.BackgroundTransparency=1; tIco.ZIndex=3
        local iconValid=iconID and tostring(iconID)~="" and tostring(iconID)~="0"
        if iconValid then tIco.Image="rbxassetid://"..tostring(iconID); tIco.ImageColor3=Theme.TextSecondary
        else tIco.Image=""
            local it=Instance.new("TextLabel"); it.Size=UDim2.new(1,0,1,0); it.BackgroundTransparency=1
            it.Text="◆"; it.Font=Enum.Font.GothamBold; it.TextSize=9; it.TextColor3=Theme.TextSecondary; it.ZIndex=4; it.Parent=tIco
        end
        tIco.Parent=tbtn

        local tlbl=Instance.new("TextLabel"); tlbl.Size=UDim2.new(1,-36,1,0); tlbl.Position=UDim2.new(0,34,0,0)
        tlbl.BackgroundTransparency=1; tlbl.Text=name; tlbl.Font=Enum.Font.GothamSemibold; tlbl.TextSize=11
        tlbl.TextColor3=Theme.TextSecondary; tlbl.TextXAlignment=Enum.TextXAlignment.Left; tlbl.ZIndex=3; tlbl.Parent=tbtn

        tbtn.MouseEnter:Connect(function()
            if self._ActiveTab and self._ActiveTab._Button==tbtn then return end
            Util.Tween(tbtn,Config.TweenFast,{BackgroundColor3=Theme.SurfaceHover})
            Util.Tween(tlbl,Config.TweenFast,{TextColor3=Theme.TextPrimary})
        end)
        tbtn.MouseLeave:Connect(function()
            if self._ActiveTab and self._ActiveTab._Button==tbtn then return end
            Util.Tween(tbtn,Config.TweenFast,{BackgroundColor3=Theme.Surface})
            Util.Tween(tlbl,Config.TweenFast,{TextColor3=Theme.TextSecondary})
        end)

        -- MELHORIA: registra para filtro central (sem conexão individual por aba)
        table.insert(_tabRegistry,{button=tbtn, name=name})

        local canvas=Instance.new("CanvasGroup"); canvas.Size=UDim2.new(1,0,1,0)
        canvas.BackgroundTransparency=1; canvas.GroupTransparency=1; canvas.BorderSizePixel=0
        canvas.Visible=false; canvas.ZIndex=2; canvas.Parent=cf

        local scrl=Instance.new("ScrollingFrame"); scrl.Size=UDim2.new(1,0,1,0)
        scrl.BackgroundTransparency=1; scrl.BorderSizePixel=0; scrl.CanvasSize=UDim2.new(0,0,0,0)
        scrl.AutomaticCanvasSize=Enum.AutomaticSize.Y; scrl.ScrollBarThickness=Config.ScrollBarW
        scrl.ScrollBarImageColor3=Theme.ScrollBar; scrl.ScrollingDirection=Enum.ScrollingDirection.Y
        scrl.ElasticBehavior=Enum.ElasticBehavior.WhenScrollable; scrl.ZIndex=3; scrl.Parent=canvas
        local sp=Instance.new("UIPadding"); sp.PaddingTop=UDim.new(0,8); sp.PaddingBottom=UDim.new(0,12)
        sp.PaddingLeft=UDim.new(0,10); sp.PaddingRight=UDim.new(0,14); sp.Parent=scrl
        local wl=Instance.new("UIListLayout"); wl.SortOrder=Enum.SortOrder.LayoutOrder
        wl.Padding=UDim.new(0,Config.WidgetGap); wl.FillDirection=Enum.FillDirection.Vertical
        wl.HorizontalAlignment=Enum.HorizontalAlignment.Center; wl.Parent=scrl
        scrl.MouseEnter:Connect(function() Util.Tween(scrl,Config.TweenFast,{ScrollBarImageColor3=Theme.ScrollBarHover}) end)
        scrl.MouseLeave:Connect(function() Util.Tween(scrl,Config.TweenFast,{ScrollBarImageColor3=Theme.ScrollBar}) end)

        local Tab={Name=name,ScrollFrame=scrl,_Canvas=canvas,_Button=tbtn,_Label=tlbl,_Ind=ind,_Window=self,_Count=0}
        function Tab:Select() SwitchTab(self._Window,self) end
        tbtn.MouseButton1Click:Connect(function() SwitchTab(self,Tab) end)

        function Tab:AddButton(t,c)        self._Count+=1; return Widgets.Button(     self.ScrollFrame,t,          self._Count,c) end
        function Tab:AddToggle(t,d,c)      self._Count+=1; return Widgets.Toggle(     self.ScrollFrame,t,d,        self._Count,c) end
        function Tab:AddSlider(t,mn,mx,d,c)self._Count+=1; return Widgets.Slider(     self.ScrollFrame,t,mn,mx,d,  self._Count,c) end
        function Tab:AddSection(t)         self._Count+=1; return Widgets.Section(    self.ScrollFrame,t,          self._Count)   end
        function Tab:AddSeparator()        self._Count+=1; return Widgets.Separator(  self.ScrollFrame,            self._Count)   end
        function Tab:AddLabel(t)           self._Count+=1; return Widgets.Label(      self.ScrollFrame,t,          self._Count)   end
        function Tab:AddTextbox(t,ph,d,c)  self._Count+=1; return Widgets.Textbox(    self.ScrollFrame,t,ph,d,     self._Count,c) end
        function Tab:AddDropdown(t,o,d,c)  self._Count+=1; return Widgets.Dropdown(   self.ScrollFrame,t,o,d,      self._Count,c) end
        function Tab:AddKeybind(t,d,c)     self._Count+=1; return Widgets.Keybind(    self.ScrollFrame,t,d,        self._Count,c) end
        function Tab:AddProgressBar(t,v)   self._Count+=1; return Widgets.ProgressBar(self.ScrollFrame,t,v,        self._Count)   end
        -- MELHORIA: aceita alpha opcional — AddColorPicker(text, default, cb, defaultAlpha, useAlpha)
        function Tab:AddColorPicker(t,d,c,da,ua) self._Count+=1; return Widgets.ColorPicker(self.ScrollFrame,t,d,self._Count,c,da,ua) end

        table.insert(self._Tabs,Tab)
        if #self._Tabs==1 then
            task.delay(Config.TweenMedium.Time,function() SwitchTab(self,Tab) end)
        end
        return Tab
    end

    table.insert(ModernNoir._Windows,Window)
    return Window
end

return ModernNoir
