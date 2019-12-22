//Create Text Elem for Client
createText(font,fontscale,align,relative,x,y,color,alpha,glowColor,glowAlpha,text)
{
    textElem = self createFontString(font,fontscale);
    textElem setPoint(align,relative,x,y);
    textElem.sort      = 0;
    textElem.type      = "text";
    textElem.color     = color;
    textElem.alpha     = alpha;
    textElem.glowColor = glowColor;
    textElem.glowAlpha = glowAlpha;
    if(isDefined(text))
    {
        textElem _setText(text);
    }
    textElem.hideWhenInMenu = false;
    return textElem;
}

//Create Text Elem for Server
createServerText(font,fontscale,align,relative,x,y,color,alpha,glowColor,glowAlpha,text)
{
    textElem = createServerFontString(font,fontscale);
    textElem setPoint(align,relative,x,y);
    textElem.sort      = 0;
    textElem.type      = "text";
    textElem.color     = color;
    textElem.alpha     = alpha;
    textElem.glowColor = glowColor;
    textElem.glowAlpha = glowAlpha;
    if(isDefined(text))
    {
        textElem _setText(text);
    }
    textElem.hideWhenInMenu = false;
    return textElem;
}

//Create Shader/Texture Elem for Client
createRectangle(align,relative,x,y,width,height,color,alpha,shadero)
{
    rect_elem          = newClientHudElem(self);
    rect_elem.width    = width;
    rect_elem.height   = height;
    rect_elem.align    = align;
    rect_elem.relative = relative;
    rect_elem.xOffset  = 0;
    rect_elem.yOffset  = 0;
    rect_elem.children = [];
    rect_elem.color             = color;
    if(isDefined(alpha))
    {
        rect_elem.alpha = alpha;
    }
    else
    {
        rect_elem.alpha = 1;
    }
    rect_elem setShader(shadero,width,height);
    rect_elem.hidden = false;
    rect_elem.sort            = 0;
    rect_elem setPoint(align,relative,x,y);
    rect_elem.hideWhenInMenu = false;
    return rect_elem;
}

//Create Old Shool/Basic Shader for Client --- setPoint not used
createShaderBasic(h_aling,v_aling,x,y,width,height,shader,color,alpha)
{
    basic_elem           = newClientHudElem(self);
    basic_elem.x         = x;
    basic_elem.y         = y;
    basic_elem.horzAlign = h_aling;
    basic_elem.vertAlign = v_aling;
    basic_elem setShader(shader,width,height);
    basic_elem.color = color;
    basic_elem.alpha = alpha;
    return basic_elem;
}

//Change Elem stuff over time Functions
elemFadeOverTime(time,alpha)
{
    self fadeovertime(time);
    self.alpha = alpha;
}
elemMoveOverTimeY(time,y)
{
    self moveovertime(time);
    self.y = y;
}
elemMoveOverTimeX(time,x)
{
    self moveovertime(time);
    self.x = x;
}
elemScaleOverTime(time,width,height)
{
    self scaleovertime(time,width,height);
}
elemSetSort(val)
{
    self.sort = val;
}
elemGlow(time)
{
    self endon("end_glow");
    while(isDefined(self))
    {
        self fadeOverTime(time);
        self.alpha = randomFloatRange(0.3,1);
        wait time;
    }
}
elemBlink()
{
    self notify("Update_Blink");
    self endon("Update_Blink");
    while(isDefined(self))
    {
        self elemFadeOverTime(.3,0.3);
        wait .3;
        self elemFadeOverTime(.3,1);
        wait .3;
    }
}

//New setPoint function(from COD5??)
setPoint(point,relativePoint,xOffset,yOffset,moveTime)
{
    if(!isDefined(moveTime))moveTime = 0;
    element = self getParent();
    if(moveTime)self moveOverTime(moveTime);
    if(!isDefined(xOffset))xOffset = 0;
    self.xOffset = xOffset;
    if(!isDefined(yOffset))yOffset = 0;
    self.yOffset = yOffset;
    self.point = point;
    self.alignX = "center";
    self.alignY = "middle";
    if(isSubStr(point,"TOP"))self.alignY = "top";
    if(isSubStr(point,"BOTTOM"))self.alignY = "bottom";
    if(isSubStr(point,"LEFT"))self.alignX = "left";
    if(isSubStr(point,"RIGHT"))self.alignX = "right";
    if(!isDefined(relativePoint))relativePoint = point;
    self.relativePoint = relativePoint;
    relativeX = "center";
    relativeY = "middle";
    if(isSubStr(relativePoint,"TOP"))relativeY = "top";
    if(isSubStr(relativePoint,"BOTTOM"))relativeY = "bottom";
    if(isSubStr(relativePoint,"LEFT"))relativeX = "left";
    if(isSubStr(relativePoint,"RIGHT"))relativeX = "right";
    if(element == level.uiParent)
    {
        self.horzAlign = relativeX;
        self.vertAlign = relativeY;
    }
    else
    {
        self.horzAlign = element.horzAlign;
        self.vertAlign = element.vertAlign;
    }
    if(relativeX == element.alignX)
    {
        offsetX = 0;
        xFactor = 0;
    }
    else if(relativeX == "center" || element.alignX == "center")
    {
        offsetX = int(element.width / 2);
        if(relativeX == "left" || element.alignX == "right")xFactor = -1;
        else xFactor = 1;
    }
    else
    {
        offsetX = element.width;
        if(relativeX == "left")xFactor = -1;
        else xFactor = 1;
    }
    self.x = element.x +(offsetX * xFactor);
    if(relativeY == element.alignY)
    {
        offsetY = 0;
        yFactor = 0;
    }
    else if(relativeY == "middle" || element.alignY == "middle")
    {
        offsetY = int(element.height / 2);
        if(relativeY == "top" || element.alignY == "bottom")yFactor = -1;
        else yFactor = 1;
    }
    else
    {
        offsetY = element.height;
        if(relativeY == "top")yFactor = -1;
        else yFactor = 1;
    }
    self.y = element.y +(offsetY * yFactor);
    self.x += self.xOffset;
    self.y += self.yOffset;
    switch(self.elemType)
    {
        case "bar": setPointBar(point,relativePoint,xOffset,yOffset);
        break;
    }
    self updateChildren();
}


//NONE
NONE()
{
    //NOTHING
}

//Platform Checks
isConsole()
{
    if(isXbox()||isPs3())
    {
        return true;
    }
    return false;
}
isXbox()
{
    if(level.xenon)
    {
        return true;
    }
    return false;
}
isPs3()
{
    if(level.ps3)
    {
        return true;
    }
    return false;
}

//Get Player Cursor Position
getCursorPos(multiplier)
{
    if(!isDefined(multiplier))
    {
        multiplier = 1000000;
    }
    angle_forward      = AnglesToForward(self getPlayerAngles());
    multiplied_vector3 = angle_forward * multiplier;
    return BulletTrace(self getTagOrigin("tag_eye"),multiplied_vector3,0,self)["position"];
}

//Delete or Destroy Entity after some time
removeEntityOverTime(time,type = "delete")
{
    wait time;
    if(type == "delete")
    {
        self delete();
    }
    else
    {
        self destroy();
    }
}

//HeadIcon function for Crates/Shops
SetEntHeadIcon(offset,shader,keepPosition)
{
    if(isDefined(offset)) 
    {
        self.entityHeadIconOffset = offset;
    }
    else
    {
        self.entityHeadIconOffset = (0,0,0);
    }
    headIcon                  = newHudElem();
    headIcon.archived         = true;
    headIcon.x                = self.origin[0] + self.entityHeadIconOffset[0];
    headIcon.y                = self.origin[1] + self.entityHeadIconOffset[1];
    headIcon.z                = self.origin[2] + self.entityHeadIconOffset[2];
    headIcon.alpha            = 0.8;
    headIcon setShader(shader,10,10);
    headIcon setWaypoint(true,true);
    self.entityHeadIcon = headIcon;
    if(isdefined(keepPosition)&&keepPosition==true)
    {
        self thread maps\mp\_entityheadicons::keepIconPositioned();
    }
}