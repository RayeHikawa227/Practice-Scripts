function Auxiliary.VG_Enable(c)
	--start up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCountLimit(1)
	e1:SetOperation(Auxiliary.executeop)
	c:RegisterEffect(e1)
end
function Auxiliary.executeop(e,tp,eg,ep,ev,re,r,rp)
	--banish itself during in standby phase
	local c=e:GetHandler()
	local res=false
	if c:IsLocation(LOCATION_DECK) then
		res=true
	end
	--if this card is in the hand it draw 1 card
	if not res and c:IsLocation(LOCATION_HAND) then
		Duel.Draw(tp,1,REASON_EFFECT) 
	end
	if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)>0 then
		--side of the M and S/T zones becomes null
		local filter_zone_1=0
		for i=1,4 do
			if Duel.CheckLocation(tp,LOCATION_MZONE+LOCATION_SZONE,i) then
				filter_zone_1=filter_zone_1|1<<i
			end
		end
		local res2=Duel.SelectDisableField(tp,2,LOCATION_MZONE+LOCATION_SZONE,0,filter_zone_1)
		if res2 then
			--select unit
			local group_unit=Duel.GetMatchingGroup(Auxiliary.UnitFilter,tp,LOCATION_DECK,0,nil)
			if #group_unit>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				group_unit=group_unit:Select(tp,1,1,nil)
			end
			--only choose in the middle zone
			local filter_zone_2=0
			for i=2,2 do
				if Duel.CheckLocation(tp,LOCATION_MZONE,i) then
					filter_zone_2=filter_zone_2|1<<i
				end
			end
			if filter_zone_2==0 then return end
			local tc_card=group_unit:GetFirst() 
			Duel.MoveToField(tc_card,tp,tp,LOCATION_MZONE,POS_FACEDOWN,true,filter_zone_2)
		end
	end
end
