--サイバース・クロック・ドラゴン
--Cyberse Clock Dragon
--Scripted by Eerie Code
function c42717221.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddFusionProcMixRep(c,true,true,aux.FilterBoolFunctionEx(Card.IsType,TYPE_LINK),1,99,21830679)
    --mill and atk
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE+CATEGORY_DECKDES)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c42717221.gycon)
    e1:SetTarget(c42717221.gytg)
    e1:SetOperation(c42717221.gyop)
    c:RegisterEffect(e1)
    --cannot be target
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetCondition(c42717221.tgcon)
    e2:SetTarget(c42717221.tgtg)
    e2:SetValue(aux.tgoval)
    c:RegisterEffect(e2)
    --atk limit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0,LOCATION_MZONE)
    e3:SetCondition(c42717221.tgcon)
    e3:SetValue(c42717221.tgtg)
    c:RegisterEffect(e3)
    --spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCondition(c42717221.thcon)
    e4:SetTarget(c42717221.thtg)
    e4:SetOperation(c42717221.thop)
    c:RegisterEffect(e4)
end
function c42717221.gycon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c42717221.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local ct=c:GetMaterial():Filter(Card.IsType,nil,TYPE_LINK):GetSum(Card.GetLink)
    if chk==0 then return ct>0 and Duel.IsPlayerCanDiscardDeck(tp,ct) end
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
    Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,c,1,tp,ct*1000)
end
function c42717221.gyop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=c:GetMaterial():Filter(Card.IsType,nil,TYPE_LINK):GetSum(Card.GetLink)
    if Duel.DiscardDeck(tp,ct,REASON_EFFECT)>0 and c:IsRelateToEffect(e) and c:IsFaceup() then
        local atk=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)*1000
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(atk)
        e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,2)
        c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c42717221.ftarget)
	e2:SetLabel(c:GetFieldID())
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
    end
end
function c42717221.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c42717221.tgcon(e)
    return Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,TYPE_LINK)
end
function c42717221.tgtg(e,c)
    return c~=e:GetHandler()
end
function c42717221.thcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsSummonType(SUMMON_TYPE_FUSION) and rp~=tp and c:IsReason(REASON_EFFECT)
end
function c42717221.thfilter(c)
    return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c42717221.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c42717221.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c42717221.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c42717221.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

