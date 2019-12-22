setMoney(value)
{
    self.Money = value;
    if(isDefined(self.Hud["main_money"]))
    {
        self.Hud["main_money"] setValue(self.Money);
    }
}

giveMoney(value,headShotValue)
{
    if(isDefined(headShotValue))
    {
        self thread mainHudMoneyNotify(value,&"MP_PLUS",(0,1,0));
        self thread mainHudHeadShotMoneyNotify(headShotValue);
        self.Money += value+headShotValue;
    }
    else
    {
        self thread mainHudMoneyNotify(value,&"MP_PLUS",(0,1,0));
        self.Money += value;
    }
    self.Hud["main_money"] setValue(self.Money);
}

takeMoney(value)
{
    self thread mainHudMoneyNotify(value,&"MP_MINUS",(1,0,0));
    endValue = self.Money - value;
    if(endValue<0)
    {
        self.Money = 0;
    }
    else
    {
        self.Money -= value;
    }
    self.Hud["main_money"] setValue(self.Money);
}

hasEnoughMoney(price)
{
    if(self.Money>=price)
    {
        return true;
    }
    return false;
}