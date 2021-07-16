--Myutant ST-46
--scripted by XyLeN
local s,id=c8200556,8200556
function s.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(id,1)) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1,id+1)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.thfilter(c)
	return c:IsSetCard(0x157) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.spcostfilter(c,e,tp) 
	if not (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToRemoveAsCost() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then return false end
	return ((c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,e,tp,34695290)) --Myutant Beast
		or (c:IsType(TYPE_SPELL) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,e,tp,61089209)) --Myutant Mist
		or (c:IsType(TYPE_TRAP) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,e,tp,7574904))) --Myutant Arsenal
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return e:GetHandler():IsReleasable() and Duel.IsExistingMatchingCard(s.spcostfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,e,tp) end
	Duel.Release(e:GetHandler(),REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cost=Duel.SelectMatchingCard(tp,s.spcostfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,e,tp):GetFirst()
	e:SetLabel(cost:GetType())
	Duel.Remove(cost,POS_FACEUP,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(100)
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local types=e:GetLabel()
	local get,id={},1
	if types&TYPE_MONSTER>0 then get[id]=34695290 end --Myutant Beast
	if types&TYPE_SPELL>0 then get[id]=61089209 end --Myutant Mist
	if types&TYPE_TRAP>0 then get[id]=7574904 end --Myutant Arsenal
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,e:GetHandler(),e,tp,table.unpack(get))
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
