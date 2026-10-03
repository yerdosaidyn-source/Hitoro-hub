local C=game:GetService("CoreGui")local P=game:GetService("Players")local R=game:GetService("RunService")local U=game:GetService("UserInputService")local W=game:GetService("Workspace")local L=game:GetService("Lighting")local LP=P.LocalPlayer local CAM=W.CurrentCamera
if C:FindFirstChild("HitoroHub")then C.HitoroHub:Destroy()end
local F={ESP=false,EB=true,EN=true,ET=true,AIM=false,FOV=120,SM=0.25,TGT="Murderer",VIS=true,WS=false,WSV=40,JP=false,JPV=120,IJ=false,FB=false,AP=false,NC=false,AM=false}
local function GR(p)local c=p.Character if c then for _,o in ipairs(c:GetChildren())do local n=o.Name if n=="Murderer"or n=="Sheriff"or n=="Hero"or n=="Innocent"then return n end end end for _,o in ipairs(p:GetChildren())do local n=o.Name if n=="Murderer"or n=="Sheriff"or n=="Hero"or n=="Innocent"then return n end end return "Innocent"end
local function RC(r)if r=="Murderer"then return Color3.fromRGB(255,40,40)elseif r=="Sheriff"then return Color3.fromRGB(40,130,255)elseif r=="Hero"then return Color3.fromRGB(255,210,0)end return Color3.fromRGB(40,220,90)end
local G=Instance.new("ScreenGui")G.Name="HitoroHub"G.ResetOnSpawn=false G.ZIndexBehavior=Enum.ZIndexBehavior.Sibling G.Parent=C
local M=Instance.new("Frame")M.Size=UDim2.new(0,520,0,360)M.Position=UDim2.new(0.5,-260,0.5,-180)M.BackgroundColor3=Color3.fromRGB(18,18,22)M.BorderSizePixel=0 M.Active=true M.Draggable=true M.Parent=G
Instance.new("UICorner",M).CornerRadius=UDim.new(0,10)
local MS=Instance.new("UIStroke",M)MS.Color=Color3.fromRGB(255,60,60)MS.Thickness=1.5
local T=Instance.new("Frame",M)T.Size=UDim2.new(1,0,0,38)T.BackgroundColor3=Color3.fromRGB(25,25,30)T.BorderSizePixel=0 Instance.new("UICorner",T).CornerRadius=UDim.new(0,10)
local TT=Instance.new("TextLabel",T)TT.Size=UDim2.new(1,-90,1,0)TT.Position=UDim2.new(0,14,0,0)TT.BackgroundTransparency=1 TT.Text="Hitoro Hub | MM2"TT.TextColor3=Color3.fromRGB(255,255,255)TT.Font=Enum.Font.GothamBold TT.TextSize=16 TT.TextXAlignment=Enum.TextXAlignment.Left
local MB=Instance.new("TextButton",T)MB.Size=UDim2.new(0,28,0,28)MB.Position=UDim2.new(1,-68,0,5)MB.BackgroundColor3=Color3.fromRGB(60,60,70)MB.Text="-"MB.TextColor3=Color3.fromRGB(255,255,255)MB.Font=Enum.Font.GothamBold MB.TextSize=14 MB.BorderSizePixel=0 Instance.new("UICorner",MB).CornerRadius=UDim.new(0,6)
local CB=Instance.new("TextButton",T)CB.Size=UDim2.new(0,28,0,28)CB.Position=UDim2.new(1,-34,0,5)CB.BackgroundColor3=Color3.fromRGB(255,60,60)CB.Text="X"CB.TextColor3=Color3.fromRGB(255,255,255)CB.Font=Enum.Font.GothamBold CB.TextSize=14 CB.BorderSizePixel=0 Instance.new("UICorner",CB).CornerRadius=UDim.new(0,6)
CB.MouseButton1Click:Connect(function()G:Destroy()end)
local TB=Instance.new("Frame",M)TB.Size=UDim2.new(1,-20,0,30)TB.Position=UDim2.new(0,10,0,46)TB.BackgroundTransparency=1
local TL=Instance.new("UIListLayout",TB)TL.FillDirection=Enum.FillDirection.Horizontal TL.Padding=UDim.new(0,6)
local CT=Instance.new("Frame",M)CT.Size=UDim2.new(1,-20,1,-90)CT.Position=UDim2.new(0,10,0,82)CT.BackgroundColor3=Color3.fromRGB(22,22,27)CT.BorderSizePixel=0 Instance.new("UICorner",CT).CornerRadius=UDim.new(0,8)
local TABS={}local PGS={}local CUR=nil
local function mTab(n,o)local b=Instance.new("TextButton",TB)b.Size=UDim2.new(0,95,0,30)b.BackgroundColor3=Color3.fromRGB(35,35,42)b.Text=n b.TextColor3=Color3.fromRGB(220,220,220)b.Font=Enum.Font.GothamSemibold b.TextSize=13 b.BorderSizePixel=0 b.LayoutOrder=o Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
local pg=Instance.new("ScrollingFrame",CT)pg.Size=UDim2.new(1,-16,1,-16)pg.Position=UDim2.new(0,8,0,8)pg.BackgroundTransparency=1 pg.BorderSizePixel=0 pg.ScrollBarThickness=4 pg.ScrollBarImageColor3=Color3.fromRGB(255,60,60)pg.CanvasSize=UDim2.new(0,0,0,0)pg.Visible=false
local ly=Instance.new("UIListLayout",pg)ly.Padding=UDim.new(0,6)ly.SortOrder=Enum.SortOrder.LayoutOrder
ly:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()pg.CanvasSize=UDim2.new(0,0,0,ly.AbsoluteContentSize.Y+10)end)
TABS[n]=b PGS[n]=pg
b.MouseButton1Click:Connect(function()for k,v in pairs(PGS)do v.Visible=(k==n)TABS[k].BackgroundColor3=(k==n)and Color3.fromRGB(255,60,60)or Color3.fromRGB(35,35,42)end CUR=n end)
if not CUR then CUR=n pg.Visible=true b.BackgroundColor3=Color3.fromRGB(255,60,60)end return pg end
local function mTg(par,txt,def,cb)local r=Instance.new("Frame",par)r.Size=UDim2.new(1,-4,0,32)r.BackgroundColor3=Color3.fromRGB(30,30,36)r.BorderSizePixel=0 Instance.new("UICorner",r).CornerRadius=UDim.new(0,6)
local lb=Instance.new("TextLabel",r)lb.Size=UDim2.new(1,-70,1,0)lb.Position=UDim2.new(0,12,0,0)lb.BackgroundTransparency=1 lb.Text=txt lb.TextColor3=Color3.fromRGB(230,230,230)lb.Font=Enum.Font.Gotham lb.TextSize=13 lb.TextXAlignment=Enum.TextXAlignment.Left
local bt=Instance.new("TextButton",r)bt.Size=UDim2.new(0,50,0,22)bt.Position=UDim2.new(1,-60,0.5,-11)bt.BackgroundColor3=def and Color3.fromRGB(255,60,60)or Color3.fromRGB(55,55,65)bt.Text=def and"ON"or"OFF"bt.TextColor3=Color3.fromRGB(255,255,255)bt.Font=Enum.Font.GothamBold bt.TextSize=12 bt.BorderSizePixel=0 Instance.new("UICorner",bt).CornerRadius=UDim.new(0,5)
local s=def bt.MouseButton1Click:Connect(function()s=not s bt.BackgroundColor3=s and Color3.fromRGB(255,60,60)or Color3.fromRGB(55,55,65)bt.Text=s and"ON"or"OFF"cb(s)end)end
local function mSl(par,txt,mn,mx,def,cb)local r=Instance.new("Frame",par)r.Size=UDim2.new(1,-4,0,46)r.BackgroundColor3=Color3.fromRGB(30,30,36)r.BorderSizePixel=0 Instance.new("UICorner",r).CornerRadius=UDim.new(0,6)
local lb=Instance.new("TextLabel",r)lb.Size=UDim2.new(1,-20,0,18)lb.Position=UDim2.new(0,12,0,4)lb.BackgroundTransparency=1 lb.Text=txt..": "..def lb.TextColor3=Color3.fromRGB(230,230,230)lb.Font=Enum.Font.Gotham lb.TextSize=13 lb.TextXAlignment=Enum.TextXAlignment.Left
local br=Instance.new("Frame",r)br.Size=UDim2.new(1,-24,0,8)br.Position=UDim2.new(0,12,0,28)br.BackgroundColor3=Color3.fromRGB(55,55,65)br.BorderSizePixel=0 Instance.new("UICorner",br).CornerRadius=UDim.new(1,0)
local fl=Instance.new("Frame",br)fl.Size=UDim2.new((def-mn)/(mx-mn),0,1,0)fl.BackgroundColor3=Color3.fromRGB(255,60,60)fl.BorderSizePixel=0 Instance.new("UICorner",fl).CornerRadius=UDim.new(1,0)
local dg=false local function up(i)local rl=math.clamp((i.Position.X-br.AbsolutePosition.X)/br.AbsoluteSize.X,0,1)local v=math.floor(mn+(mx-mn)*rl+0.5)fl.Size=UDim2.new(rl,0,1,0)lb.Text=txt..": "..v cb(v)end
br.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dg=true up(i)end end)
br.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dg=false end end)
U.InputChanged:Connect(function(i)if dg and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then up(i)end end)end
local function mDd(par,txt,opts,def,cb)local r=Instance.new("Frame",par)r.Size=UDim2.new(1,-4,0,32)r.BackgroundColor3=Color3.fromRGB(30,30,36)r.BorderSizePixel=0 Instance.new("UICorner",r).CornerRadius=UDim.new(0,6)
local lb=Instance.new("TextLabel",r)lb.Size=UDim2.new(0,120,1,0)lb.Position=UDim2.new(0,12,0,0)lb.BackgroundTransparency=1 lb.Text=txt lb.TextColor3=Color3.fromRGB(230,230,230)lb.Font=Enum.Font.Gotham lb.TextSize=13 lb.TextXAlignment=Enum.TextXAlignment.Left
local bt=Instance.new("TextButton",r)bt.Size=UDim2.new(0,150,0,24)bt.Position=UDim2.new(1,-162,0.5,-12)bt.BackgroundColor3=Color3.fromRGB(45,45,55)bt.Text=def bt.TextColor3=Color3.fromRGB(255,255,255)bt.Font=Enum.Font.Gotham bt.TextSize=12 bt.BorderSizePixel=0 Instance.new("UICorner",bt).CornerRadius=UDim.new(0,5)
local ls=Instance.new("Frame",r)ls.Size=UDim2.new(0,150,0,#opts*24)ls.Position=UDim2.new(1,-162,1,4)ls.BackgroundColor3=Color3.fromRGB(35,35,42)ls.BorderSizePixel=0 ls.Visible=false ls.ZIndex=10 Instance.new("UICorner",ls).CornerRadius=UDim.new(0,5)Instance.new("UIListLayout",ls)
for _,o in ipairs(opts)do local ob=Instance.new("TextButton",ls)ob.Size=UDim2.new(1,0,0,24)ob.BackgroundTransparency=1 ob.Text=o ob.TextColor3=Color3.fromRGB(230,230,230)ob.Font=Enum.Font.Gotham ob.TextSize=12 ob.MouseButton1Click:Connect(function()bt.Text=o ls.Visible=false cb(o)end)end
bt.MouseButton1Click:Connect(function()ls.Visible=not ls.Visible end)end
local AP=mTab("Aim",1)local VP=mTab("Visual",2)local MP=mTab("Movement",3)local XP=mTab("Misc",4)local NP=mTab("Anti",5)
mTg(AP,"Aimbot",F.AIM,function(v)F.AIM=v end)
mSl(AP,"Aimbot FOV",10,500,F.FOV,function(v)F.FOV=v end)
mSl(AP,"Smooth",1,100,math.floor(F.SM*100),function(v)F.SM=v/100 end)
mDd(AP,"Target",{"Murderer","All","Closest"},F.TGT,function(v)F.TGT=v end)
mTg(AP,"Visible Check",F.VIS,function(v)F.VIS=v end)
mTg(VP,"ESP",F.ESP,function(v)F.ESP=v end)
mTg(VP,"ESP Box",F.EB,function(v)F.EB=v end)
mTg(VP,"ESP Name",F.EN,function(v)F.EN=v end)
mTg(VP,"ESP Tracer",F.ET,function(v)F.ET=v end)
mTg(VP,"Fullbright",F.FB,function(v)F.FB=v if v then L.Brightness=3 L.ClockTime=14 L.FogEnd=1e5 L.GlobalShadows=false L.OutdoorAmbient=Color3.fromRGB(180,180,180)else L.Brightness=1 L.ClockTime=14 L.FogEnd=1e5 L.GlobalShadows=true L.OutdoorAmbient=Color3.fromRGB(70,70,70)end end)
mTg(MP,"Walkspeed",F.WS,function(v)F.WS=v end)
mSl(MP,"WSpeed Value",16,200,F.WSV,function(v)F.WSV=v end)
mTg(MP,"JumpPower",F.JP,function(v)F.JP=v end)
mSl(MP,"JP Value",50,300,F.JPV,function(v)F.JPV=v end)
mTg(MP,"Infinite Jump",F.IJ,function(v)F.IJ=v end)
mTg(XP,"Auto Pickup Gun",F.AP,function(v)F.AP=v end)
mTg(XP,"NoClip",F.NC,function(v)F.NC=v end)
mTg(NP,"Anti Murderer (Teleport)",F.AM,function(v)F.AM=v end)
local EF=Instance.new("Folder",C)EF.Name="HitoroESP"local ED={}
local function cESP(p)local b=Instance.new("BoxHandleAdornment",EF)b.Name="b_"..p.Name b.AlwaysOnTop=true b.ZIndex=5 b.Size=Vector3.new(2,2,1)b.Transparency=0.4
local bb=Instance.new("BillboardGui",EF)bb.Name="bb_"..p.Name bb.Size=UDim2.new(0,200,0,30)bb.StudsOffset=Vector3.new(0,3,0)bb.AlwaysOnTop=true
local lb=Instance.new("TextLabel",bb)lb.Size=UDim2.new(1,0,1,0)lb.BackgroundTransparency=1 lb.TextStrokeTransparency=0 lb.TextScaled=true lb.Font=Enum.Font.SourceSansBold
local tr=Instance.new("LineHandleAdornment",EF)tr.Name="t_"..p.Name tr.AlwaysOnTop=true tr.ZIndex=4 tr.Thickness=2
return b,bb,lb,tr end
local function uESP()for _,p in ipairs(P:GetPlayers())do if p==LP then continue end if not ED[p]then ED[p]={cESP(p)}end local b,bb,lb,tr=table.unpack(ED[p])local ch=p.Character local al=ch and ch:FindFirstChild("HumanoidRootPart")and ch:FindFirstChildOfClass("Humanoid")and ch:FindFirstChildOfClass("Humanoid").Health>0
if F.ESP and al then local r=GR(p)local c=RC(r)b.Adornee=ch.HumanoidRootPart b.Color3=c b.Visible=F.EB bb.Adornee=ch.Head bb.Enabled=F.EN lb.TextColor3=c lb.Text=p.Name.." ["..r.."]"tr.Adornee=ch.HumanoidRootPart tr.Color3=c tr.Visible=F.ET
else b.Adornee=nil b.Visible=false bb.Adornee=nil bb.Enabled=false tr.Adornee=nil tr.Visible=false end end end
P.PlayerRemoving:Connect(function(p)if ED[p]then for _,o in ipairs(ED[p])do if o then o:Destroy()end end ED[p]=nil end end)
local function gT()local l={}for _,p in ipairs(P:GetPlayers())do if p==LP then continue end local c=p.Character if not c then continue end local h=c:FindFirstChild("HumanoidRootPart")local hu=c:FindFirstChildOfClass("Humanoid")if not h or not hu or hu.Health<=0 then continue end local r=GR(p)if F.TGT=="Murderer"and r~="Murderer"then continue end table.insert(l,{player=p,hrp=h,role=r})end return l end
local function gF()local mc=LP.Character if not mc or not mc:FindFirstChild("HumanoidRootPart")then return nil end local cp=CAM.CFrame.Position local ce=Vector2.new(CAM.ViewportSize.X/2,CAM.ViewportSize.Y/2)local cl,cd=nil,math.huge
for _,t in ipairs(gT())do local sp,on=CAM:WorldToViewportPoint(t.hrp.Position)if not on then continue end local sv=Vector2.new(sp.X,sp.Y)local d=(sv-ce).Magnitude if d<=F.FOV and d<cd then if F.VIS then local ry=Ray.new(cp,(t.hrp.Position-cp).Unit*500)local ht=W:FindPartOnRayWithIgnoreList(ry,{mc,CAM})if ht and not ht:IsDescendantOf(t.player.Character)then continue end end cl=t.hrp cd=d end end return cl end
local function aM()local c=LP.Character if not c then return end local h=c:FindFirstChildOfClass("Humanoid")if not h then return end if F.WS then h.WalkSpeed=F.WSV end if F.JP then h.JumpPower=F.JPV h.UseJumpPower=true end end
LP.CharacterAdded:Connect(function()task.wait(0.3)aM()end)
U.JumpRequest:Connect(function()if F.IJ then local c=LP.Character if c and c:FindFirstChildOfClass("Humanoid")then c:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)end end end)
local function tP()if not F.AP then return end local c=LP.Character if not c or not c:FindFirstChild("HumanoidRootPart")then return end local mp=c.HumanoidRootPart.Position for _,o in ipairs(W:GetDescendants())do if o:IsA("Tool")then local n=o.Name:lower()if n:find("gun")or n:find("revolver")or n:find("knife")then local hd=o:FindFirstChild("Handle")if hd and(hd.Position-mp).Magnitude<15 then if not o.Parent:IsA("Player")and not o.Parent:IsA("Backpack")then local h=c:FindFirstChildOfClass("Humanoid")if h then h:EquipTool(o)end end end end end end end
R.Stepped:Connect(function()if not F.NC then return end local c=LP.Character if not c then return end for _,p in ipairs(c:GetDescendants())do if p:IsA("BasePart")and p.CanCollide then p.CanCollide=false end end end)
R.Heartbeat:Connect(function()if not F.AM then return end local c=LP.Character if not c or not c:FindFirstChild("HumanoidRootPart")then return end local mp=c.HumanoidRootPart.Position for _,p in ipairs(P:GetPlayers())do if p==LP then continue end if GR(p)~="Murderer"then continue end local ch=p.Character if not ch then continue end local h=ch:FindFirstChild("HumanoidRootPart")if not h then continue end if(h.Position-mp).Magnitude<20 then local a=math.random()*math.pi*2 local of=Vector3.new(math.cos(a)*60,5,math.sin(a)*60)c.HumanoidRootPart.CFrame=CFrame.new(mp+of)end end end)
local FG=Instance.new("ScreenGui",C)FG.Name="HitoroFOV"FG.ResetOnSpawn=false FG.IgnoreGuiInset=true
local FC=Instance.new("Frame",FG)FC.BackgroundTransparency=1 FC.AnchorPoint=Vector2.new(0.5,0.5)FC.Position=UDim2.new(0.5,0,0.5,0)FC.Visible=false Instance.new("UICorner",FC).CornerRadius=UDim.new(1,0)
local FS=Instance.new("UIStroke",FC)FS.Color=Color3.fromRGB(255,60,60)FS.Thickness=1.5 FS.Transparency=0.2
R.RenderStepped:Connect(function()pcall(uESP)FC.Visible=F.AIM local d=F.FOV*2 FC.Size=UDim2.new(0,d,0,d)if F.AIM then local t=gF()if t then local cp=CAM.CFrame.Position local gl=CFrame.new(cp,t.Position)CAM.CFrame=CAM.CFrame:Lerp(gl,F.SM)end end end)
task.spawn(function()while task.wait(0.2)do pcall(aM)pcall(tP)end end)
local mn=false MB.MouseButton1Click:Connect(function()mn=not mn CT.Visible=not mn TB.Visible=not mn M.Size=mn and UDim2.new(0,520,0,38)or UDim2.new(0,520,0,360)end)
U.InputBegan:Connect(function(i,g)if g then return end if i.KeyCode==Enum.KeyCode.RightShift then M.Visible=not M.Visible end end)
print("[Hitoro Hub] Loaded")
