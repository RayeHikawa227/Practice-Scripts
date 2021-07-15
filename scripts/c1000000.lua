--Test Card
--myutant script
function c1000000.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1000000,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c1000000.spcost)
	e1:SetTarget(c1000000.sptg)
	e1:SetOperation(c1000000.spop)
	c:RegisterEffect(e1)
end
function c1000000.spfilter(c,e,tp,code) 
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c1000000.rmfilter(c,e,tp)
	if not c:IsAbleToRemoveAsCost() then return false end
	return ((c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c1000000.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,7574904)) 
		or (c:IsType(TYPE_SPELL) and Duel.IsExistingMatchingCard(c1000000.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,61089209))
		or (c:IsType(TYPE_TRAP) and Duel.IsExistingMatchingCard(c1000000.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,34695290)))
end
function c1000000.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000000.rmfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c1000000.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	e:SetLabel(tc:GetType())
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
end
function c1000000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c1000000.spop(e,tp,eg,ep,ev,re,r,rp)
	local types=e:GetLabel()
	local get,id={},1
	if types&TYPE_MONSTER>0 then get[id]=7574904 end
	if types&TYPE_SPELL>0 then get[id]=61089209 end
	if types&TYPE_TRAP>0 then get[id]=34695290 end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1000000.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,table.unpack(get))
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
