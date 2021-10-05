local achit = {}
achit.break_nospread = true
achit.break_nospread_spreadadd = 0.7
--Hide ESP Menu if shit rendering
achit.break_render = true
--Bhop detect, from the first jump
achit.detect_bunnyhop = true
--sv function
achit.detect_bunnyhop_nakazanie = function(b)
	b:Kick("disable")
end
local c=FindMetaTable"Entity"
if SERVER then
	util.AddNetworkString"shitac"
	net.Receive("shitac",function(_,b)
		local reason = net.ReadString()
		if reason=="bhop"then
			achit.detect_bunnyhop_nakazanie(b)
		end 
	end)
	--https://github.com/C0nw0nk/Garrys-Mod-Anti-Cheat/blob/master/garrysmod/lua/autorun/server/anti-nospread.lua
	c.OldFireBullets = c.OldFireBullets or c.FireBullets
	local function f()return math.random()*5-1 end
	function c:FireBullets(g,h)
		local i=g.Spread
		if achit.break_nospread and type(i)=="Vector"then
			g.Spread=vector_origin
			math.randomseed(CurTime()+math.sqrt(g.Dir.x^2*g.Dir.y^2*g.Dir.z^2))
			g.Dir=g.Dir+Vector(i.x*f(),i.y*f(),i.z*f())
		end
		self:OldFireBullets(g,h)
	end
	return
end
local j={}
local k=table.insert
local l=string.char
local m=math.random
local n=hook.Add
local o=ScrW
local p=ScrH
local q=os.time
local r=GetRenderTarget
local s=nil
local t=render.RenderView
local u=render.CopyTexture
local v=render.SetRenderTarget
local w=Vector
local x=Color
local y=Angle
local z=gui.IsGameUIVisible
local A=gui.IsConsoleVisible
local B=input.IsKeyDown
local C=FindMetaTable
local D=C"Player"
local E=D.GetActiveWeapon
local F=c.GetClass
local G=D.IsTyping
local H=c.OnGround
local I=c.GetMoveType
local J=net.Start
local K=net.WriteString
local L=net.SendToServer
local M=cam.Start3D
local N=cam.End3D
local O=render.DrawWireframeBox
local P,Q,R=0,0,0
local S={}
local T=r(q(),o(),p())
for U=65,90 do k(j,l(U))end;
for U=97,122 do k(j,l(U))end;
local function V()
	local W=""
	for d=1,m(20)do
		W=W..j[m(1,#j)]
	end
	return W 
end
local function hook(Y,Z)n(Y,V(),Z)end
local _={x=0,y=0,w=o(),h=p(),dopostprocess=true,drawhud=true,drawmonitors=true,drawviewmodel=true}
hook("RenderScene",function()
	if achit.break_render then
		t(_)
		u(nil,T)
		v(T)
		return 
		true 
	end 
end)
hook("ShutDown",function()
	if achit.break_render then
		v()
	end
end)
hook("DrawOverlay",function()
	if achit.break_render then
		M()
		O(w(0,0,0),y(0,0,0),w(0,0,0),w(0,0,0),x(0,0,0,0))
		N()
	end
end)
hook("Think",function()
	if s==nil then s=LocalPlayer()return end
	if achit.break_nospread then
		local a0=E(s)
		if a0 then
			local a1=a0.CurCone
			if a1 then
				local a2=F(a0)
				if not S[a2]or not S[a2]==a1 then
					S[a2]=a1+achit.break_nospread_spreadadd
				end
				if S[a2]then
					E(s).CurCone=S[a2]
				end
			end
		end
	end
	if achit.detect_bunnyhop then
		if z()or A()or G(s)or not I(s)==2 then return end
		if B(65)then
			P=P+1
		else
			P=0
		end
		if not H(s)then
			R=R+1
		else
			R=0
		end
		if P>100 and R<30 and R>1 then
			J"shitac"
			K"bhop"
			L()
			achit.detect_bunnyhop=false
		end
	end
end)
