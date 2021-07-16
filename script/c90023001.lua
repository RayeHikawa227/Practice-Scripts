--Gundam - Strike Freedom!
--scripted by XyLeN
local s,id=c90023001,90023001
function s.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.sprcon)
	e2:SetOperation(s.sprop)
	c:RegisterEffect(e2)
	--indes battle
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	e3:SetCondition(s.matcheck(1))
	c:RegisterEffect(e3)
	--indes effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(aux.indoval)
	e4:SetCondition(s.matcheck(2))
	c:RegisterEffect(e4)
	--cannot target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(aux.tgoval)
	e5:SetCondition(s.matcheck(3))
	c:RegisterEffect(e5)
	--multi attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_ATTACK_ALL)
	e6:SetValue(1)
	e6:SetCondition(s.matcheck(4))
	c:RegisterEffect(e6)
	--to deck
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,0))
	e7:SetCategory(CATEGORY_TODECK)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetCountLimit(1)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(s.tdtg)
	e7:SetOperation(s.tdop)
	e7:SetCondition(s.matcheck(5))
	c:RegisterEffect(e7)
end
function s.matcheck(value)
	return function(e,tp,eg,ep,ev,re,r,rp)
			return e:GetHandler():GetOverlayCount()>=value
		end
end
function s.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsCanOverlay() 
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Group.CreateGroup()
	local og=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_MZONE,0,nil)
	local tc=og:GetFirst() 
	while tc do
		g:Merge(tc:GetOverlayGroup()) 
		tc=g:GetNext() 
	end
	return #g>0
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Group.CreateGroup()
	local og=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_MZONE,0,nil)
	local tc=og:GetFirst() 
	while tc do
		g:Merge(tc:GetOverlayGroup()) 
		tc=g:GetNext() 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=g:Select(tp,1,#g,nil)
	Duel.Overlay(c,sg)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
