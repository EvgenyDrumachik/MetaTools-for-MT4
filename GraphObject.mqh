


class CGraphObject
  {
protected:
   double            m_Price1;
   double            m_Price2;
   double            m_Price3;
   datetime          m_DateTime1;
   datetime          m_DateTime2;
   datetime          m_DateTime3;
   color             m_color;
   int               NextMonth(int curr_month);

private:
   bool              GetLinePrices (string TrendName, ENUM_TIMEFRAMES period, double &array[], int &EndingBar, int StartingBar = -1,  double price =-1);
   bool              GetClosePrices(string TrendName, ENUM_TIMEFRAMES period, double &array[], int StartingBar = -1, double price = -1);
   bool              IsQualifiedLevel(int StartingBar, int EndingBar, double price, int i);


public:
                     CGraphObject(string name);
                     CGraphObject();
                    ~CGraphObject();
   string            Name;
   string            LastError;
   double            Price1();
   void              Price1(double NewPrice1);
   double            Price2();
   void              Price2(double NewPrice2);
   double            Price3();
   void              Price3(double NewPrice3); 
   color             Color();
   void              Color(color clr);
   void              Thickness(int thickness);
   
   int               x1();
   int               y1();
   int               x2();
   int               y2();
   int               x3();
   int               y3();        
  
   
   ENUM_OBJECT       Type(); 
   ENUM_LINE_STYLE   Style(); 
   void              Style(ENUM_LINE_STYLE style);
   
   void              Fill(bool fill = true);
     
   datetime          DateTime1();
   void              DateTime1(datetime NewDateTime1);
   datetime          DateTime2();
   void              DateTime2(datetime NewDateTime2);
   datetime          DateTime3();
   void              DateTime3(datetime NewDateTime3);
   
   int               BarIndexOfDateTime1();
   int               BarIndexOfDateTime2();
   
   double            HoursBetweenControlPoints();
   
   color             GetColor();
   
   bool              IsExist();
   bool              IsVisibleOnTF(int TimeFrame);
   void              SetDefaultVisibility();
   bool              IsSelected();
   bool              IsS3Level();
   bool              IsBFGraphObject();
      
   void              ShowOnAllTimeframes(bool show);
   void              UpdateToolTip();
   void              SetToolTip(string text);
   void              SetText(string text);
   
   string            Description();
   bool              Description(string NewDescription);
   void              ExtendPoint2();
   
   void              Hide();
   void              Select(bool select = true);
   void              Selectable(bool selectable = true);
   void              Delete();
   
   string            CreateCopy();
   
   int               TimesBroken(ENUM_TIMEFRAMES period, int &LastBrokenByBarIndex, double price = -1, int StartingBar = -1);
   
   void              SnapTo(SnapTo snapto);
   double            GetSnappingDistance(string symbol, int period);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CGraphObject::CGraphObject(string name) {
   Name             = name;
   //m_Price1         = ObjectGetMQL4(name,OBJPROP_PRICE1);
   //m_Price2         = ObjectGetMQL4(name,OBJPROP_PRICE2);
   //m_DateTime1      = (datetime)ObjectGetMQL4(name,OBJPROP_TIME1);
   //m_DateTime2      = (datetime)ObjectGetMQL4(name,OBJPROP_TIME2);
   //m_color          = (color)ObjectGetMQL4(name,OBJPROP_COLOR);
  }

CGraphObject::CGraphObject() {

}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CGraphObject::~CGraphObject()
  {
  }
//+------------------------------------------------------------------+


color CGraphObject::Color(void) {
   return (color)ObjectGetMQL4(Name,OBJPROP_COLOR);
}


void CGraphObject::Color(color clr) {

   if (ObjectTypeMQL4(Name) == OBJ_FIBO) {
      Print(__FUNCTION__ + ": coloring fibo levels");
      ObjectSetMQL4(Name,OBJPROP_LEVELCOLOR,clr);
   }
   else
      ObjectSetMQL4(Name,OBJPROP_COLOR,clr);
   
   
   m_color = clr;
}





void CGraphObject::ShowOnAllTimeframes(bool show) {
   if (show)
      ObjectSetInteger(0,Name,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
   else
      ObjectSetInteger(0,Name,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
}


bool CGraphObject::IsVisibleOnTF(int TimeFrame) {

   long objTimeframes=0;
   //ENUM_TIMEFRAMES period=(ENUM_TIMEFRAMES)Period();

//--- Get visibility property of the object
   if(ObjectGetInteger(0,Name,OBJPROP_TIMEFRAMES,0,objTimeframes)) {
      long mask=-1;
      //--- set mask from period
      switch(TimeFrame) {
         case PERIOD_M1 : mask=0x0001; break;         // The object is drawn in 1-minute chart
         case PERIOD_M5 : mask=0x0002; break;         // The object is drawn in 5-minute chart
         case PERIOD_M15: mask=0x0004; break;         // The object is drawn in 15-minute chart
         case PERIOD_M30: mask=0x0008; break;         // The object is drawn in 30-minute chart
         case PERIOD_H1 : mask=0x0010; break;         // The object is drawn in 1-hour chart
         case PERIOD_H4 : mask=0x0020; break;         // The object is drawn in 4-hour chart
         case PERIOD_D1 : mask=0x0040; break;         // The object is drawn in day charts
         case PERIOD_W1 : mask=0x0080; break;         // The object is drawn in week charts
         case PERIOD_MN1: mask=0x0100; break;         // The object is drawn in month charts     
         default:
            break;
      }
      //--- check mask. Special cases : 
      //---    1° BUG 1: if "Show on all timeframes" is enabled, objTimeframes=0 is returned and not '0x01ff' as stated in documentation.
      //---    2° BUG 2: it's not possible with MT4 to disable "Show on all timeframes" without enabled at least 1 period ;
      //---              but it's possible to set it to -1 with mql4. In this case, MT4 object properties window will display erroneously "Show on all timeframes" enabled.
      if(objTimeframes==0 || (objTimeframes!=-1 && (objTimeframes&mask)==mask)) {
         //printf("Object %s is visible on this chart %s",ObjectName,EnumToString(period));
         return true;
        }
      else {
         //printf("Object %s exists but is not visible on this chart %s",ObjectName,EnumToString(period));
         return false;
        }
     } // if(ObjectGetInteger...
   //--- ObjectGetInteger error processing
   else {
      int err=GetLastError();
      if(err==ERR_OBJECT_DOES_NOT_EXIST) {
         //printf("Object %s doesn't exist!",ObjectName);
         return false;
        }
      else {
         //printf("Error(%i) while getting properties of %s",err,ObjectName);
         return false;
        }
     }
}



void CGraphObject::Price1(double NewPrice1) {
   
   if (ObjectTypeMQL4(Name) == OBJ_HLINE) 
      ObjectSetDouble(0,Name,OBJPROP_PRICE,NewPrice1);
   else {
      //ObjectSetDouble(0,Name,OBJPROP_PRICE1,NewPrice1);
      ObjectMove(0,Name,0,ObjectGetInteger(0,Name,OBJPROP_TIME,0),NewPrice1);
   }
   m_Price1 = NewPrice1;
}


void CGraphObject::Price2(double NewPrice2) {
   ObjectMove(0,Name,1,ObjectGetInteger(0,Name,OBJPROP_TIME,1),NewPrice2);
   m_Price2 = NewPrice2;
}

void CGraphObject::Price3(double NewPrice3) {
   ObjectSetMQL4(Name,OBJPROP_PRICE3,NewPrice3);
   m_Price3 = NewPrice3;
}


double CGraphObject::Price1() {
   m_Price1 = ObjectGetMQL4(Name,OBJPROP_PRICE1);
   return m_Price1;
}


double CGraphObject::Price2() {
   double price2 = ObjectGetMQL4(Name,OBJPROP_PRICE2);
   if (price2 == 0)
      m_Price2 = Price1();
   else
      m_Price2 = price2;
   
   return m_Price2;
}

double CGraphObject::Price3() {
   m_Price3 = ObjectGetMQL4(Name,OBJPROP_PRICE3);
   return m_Price3;
}






void CGraphObject::DateTime1(datetime NewDateTime1) {
   ObjectSetMQL4(Name,OBJPROP_TIME1,NewDateTime1);
   m_DateTime1 = NewDateTime1;
}


void CGraphObject::DateTime2(datetime NewDateTime2) {
   ObjectSetMQL4(Name,OBJPROP_TIME2,NewDateTime2);
   m_DateTime2 = NewDateTime2;
}

void CGraphObject::DateTime3(datetime NewDateTime3) {
   ObjectSetMQL4(Name,OBJPROP_TIME3,NewDateTime3);
   m_DateTime3 = NewDateTime3;
}


datetime CGraphObject::DateTime1() {
   m_DateTime1 = (datetime)ObjectGetMQL4(Name,OBJPROP_TIME1);
   return m_DateTime1;
}


datetime CGraphObject::DateTime2() {
   m_DateTime2 = (datetime)ObjectGetMQL4(Name,OBJPROP_TIME2);
   return m_DateTime2;
}

datetime CGraphObject::DateTime3() {
   m_DateTime3 = (datetime)ObjectGetMQL4(Name,OBJPROP_TIME3);
   return m_DateTime3;
}







bool CGraphObject::IsSelected(void) {
   if(ObjectGetMQL4(Name,OBJPROP_SELECTED)) return true;
   else return false;
}



void CGraphObject::UpdateToolTip() {

   if(ObjectTypeMQL4(Name) == 25) return;
   if(Type() == OBJ_LABEL) return;
   if(Type() == OBJ_TEXT) return;

   string ToolTip;
   ToolTip=Name;

   if(ObjectTypeMQL4(Name)==OBJ_TREND || ObjectTypeMQL4(Name)==OBJ_CHANNEL) {
      CTrend trend(Name);
      ToolTip=ToolTip+" / "+string(NormalizeDouble(trend.Angle(),3))+"°";
   }

   ToolTip=ToolTip+CharToString(10)+"Visible on: ";

   bool VisM1  = IsVisibleOnTF(PERIOD_M1);
   bool VisM5  = IsVisibleOnTF(PERIOD_M5);
   bool VisM15 = IsVisibleOnTF(PERIOD_M15);
   bool VisM30 = IsVisibleOnTF(PERIOD_M30);
   bool VisH1  = IsVisibleOnTF(PERIOD_H1);
   bool VisH4  = IsVisibleOnTF(PERIOD_H4);
   bool VisD1  = IsVisibleOnTF(PERIOD_D1);
   bool VisW1  = IsVisibleOnTF(PERIOD_W1);
   bool VisMN1 = IsVisibleOnTF(PERIOD_MN1);

   if(VisM1 && VisM5 && VisM15 && VisM30 && VisH1 && VisH4 && VisD1 && VisW1 && VisMN1) ToolTip=ToolTip+"On all timeframes";
   else if(VisM1  &&  VisM5  &&  VisM15 && VisM30 && VisH1 && !VisH4 && !VisD1 && !VisW1 && !VisMN1) ToolTip=ToolTip+"Н1 and below";
   else if(!VisM1 && !VisM5 && !VisM15 && !VisM30 && VisH1 && !VisH4 && !VisD1 && !VisW1 && !VisMN1) ToolTip=ToolTip+"Н1 Only";
   else 
     {
      if(VisM1) ToolTip = ToolTip + "M1  ";
      if(VisM5) ToolTip = ToolTip + "M5  ";
      if(VisM15) ToolTip = ToolTip + "M15  ";
      if(VisM30) ToolTip = ToolTip + "M30  ";
      if(VisH1) ToolTip = ToolTip + "H1  ";
      if(VisH4) ToolTip = ToolTip + "H4  ";
      if(VisD1) ToolTip = ToolTip + "D1  ";
      if(VisW1) ToolTip = ToolTip + "W1  ";
      if(VisMN1) ToolTip= ToolTip+"MN1  ";
     }
   
   string s_color;
   if (Type() == OBJ_FIBO)
      s_color = ColorToString((color)ObjectGetInteger(ChartID(),Name,OBJPROP_LEVELCOLOR),true);
   else s_color = ColorToString(Color(),true);
   

   ToolTip=ToolTip+CharToString(10)+ "Color: " + StringSubstr(s_color,3,StringLen(s_color));
   
   string times_broken;
   if (Type() == OBJ_TREND) {
      CTrend trend(Name);
      int LastBrokenByBarIndex;
      times_broken = IntegerToString(trend.TimesBroken(PERIOD_H1,LastBrokenByBarIndex));
      ToolTip= ToolTip + CharToString(10) + "Broken on H1: " + times_broken + " time(s)";
      times_broken = IntegerToString(trend.TimesBroken(PERIOD_D1,LastBrokenByBarIndex));
      ToolTip= ToolTip + CharToString(10) + "Broken on D1: " + times_broken + " time(s)";
   }
   
   
   if(StringLen(ObjectDescriptionMQL4(Name))>0) {
      ToolTip=ToolTip+CharToString(10)+CharToString(10)+"Description"+CharToString(10)+ObjectDescriptionMQL4(Name);
   }

   SetToolTip(ToolTip);
   //Print("Tooltip updated for object ", Name);
}

void CGraphObject::SetToolTip(string text) {

   ObjectSetString(ChartID(),Name,OBJPROP_TOOLTIP,text);

}




void CGraphObject::SetText(string text) {

   ObjectSetTextMQL4(Name,text,12);

}




color CGraphObject::GetColor(void){
   return (color)ObjectGetInteger(ChartID(),Name,OBJPROP_COLOR);
}

string CGraphObject::Description() {
   return(ObjectGetString(0,Name,OBJPROP_TEXT));
}


bool CGraphObject::Description(string NewDescription) {
   if (ObjectSetString(0,Name,OBJPROP_TEXT,NewDescription)) return true;
   else return false;
}
   
   
   
ENUM_OBJECT CGraphObject::Type(){
   return ObjectTypeMQL4(Name);
}   


ENUM_LINE_STYLE CGraphObject::Style() {
   return (ENUM_LINE_STYLE)ObjectGetInteger(0,Name,OBJPROP_STYLE);
}

void CGraphObject::Style(ENUM_LINE_STYLE style) {

   ObjectSetMQL4(Name,OBJPROP_STYLE,style);

}



int CGraphObject::BarIndexOfDateTime1() {
 return iBarShift(Symbol(),Period(),DateTime1());
}

int CGraphObject::BarIndexOfDateTime2() {
   return iBarShift(Symbol(),Period(),DateTime2());
}


void CGraphObject::ExtendPoint2() {
   // This method extends already flat line or rectangle further into the future
   // how much into the future depends on the color of the object and current day of week and day of month
   // See full depiction of this function in the "UI and Shortcuts.pptx"

   int type = Type();
   color clr = Color();
   datetime today = DateOfDay(iTime(_Symbol,PERIOD_H1,0));;

   // *** PROTECTION OF OTHER OBJECT TYPES AND COLORS ***
   if (type != OBJ_TREND && type != OBJ_RECTANGLE) return;
   if (type == OBJ_TREND) {
      if (Price1() != Price2()) return; // if this is non horizontal line - skipping this, because it may harm some graphical setup
   }

   if (clr != clrBlue && clr != clrPowderBlue && clr != clrPink && clr != clrLightPink && clr != clrLightGray && clr != clrGreen && clr != clrRed) return; // protect objects of other colors
   //  *** END OF PROTECTION BLOCK ***
   // ====================================================


   int DayOfTomorrow = TimeDay(today)+1; // will not work correctly, if today is the last day of the month!!!
   datetime NewDateTime2 = iTime(_Symbol,PERIOD_H1,0);
   int i_today = TimeDayOfWeekMQL4(TimeLocal());
   if (SimulatorMode) i_today = TimeDayOfWeekMQL4(iTime(_Symbol,PERIOD_H1,0));
   
   // *** START OF PROCESSING ***
   
   if (clr == clrGreen || clr == clrRed) {
   // Case 1) day-levels
            if(i_today==6 || i_today == 0) { // Saturday or Sunday
               NewDateTime2 = StringToTime(string(today + HR2400*2)+"00:00"); // to the end of Monday
            }
            else { // today is week day
               NewDateTime2 = StringToTime((string) TimeYear(today) + "." + (string)TimeMonth(today) + "." + (string)(TimeDay(today)+1) + " "+" 00:00");
            }
   
   }
   else if (Period() == PERIOD_H1 || Period() == PERIOD_H4) {
   // Case 2) week-levels
            if(i_today==1) { // Monday 
               NewDateTime2 = StringToTime(string(today + HR2400*2)+"00:00"); // to the end of Monday
               Print("Monday");
            }
            else if(i_today==2) { // Tuesday 
               NewDateTime2 = StringToTime(string(today + HR2400*2)+"00:00"); // to the end of Monday
               Print("Tuesday");
            }
            else if(i_today==3) { // Wednesday 
               NewDateTime2 = StringToTime(string(today + HR2400*2)+"00:00"); // to the end of Monday
               Print("Wednesday");
            }
            else if(i_today==4) { // Thursday 
               NewDateTime2 = StringToTime(string(today + HR2400*2)+"00:00"); // to the end of Monday
               Print("Thursday");
            }
            else if(i_today==5) { // Friday 
               NewDateTime2 = StringToTime(string(today + HR2400*2)+"00:00"); // to the end of Monday
               Print("Friday");
            }
            else if(i_today==6 || i_today == 0) { // Saturday or Sunday
               NewDateTime2 = StringToTime(string(today + HR2400*2)+"00:00"); // to the end of Monday
               Print("Saturday or Sunday");
            }
            else { // today is week day - until the end of tomorrow
               string s_year  = IntegerToString(TimeYear(today));
               string m_month = IntegerToString(TimeMonth(today));
               string m_day   = IntegerToString(DayOfTomorrow);
               NewDateTime2 = StringToTime(s_year+"."+m_month+"."+m_day+" "+" 00:00");
               Print("Unknown week day: i_today = ", IntegerToString(i_today));
            }
   }   
   else if (Period() == PERIOD_D1 || Period() == PERIOD_W1 || Period() == PERIOD_MN1) {
   // Case 3) month - levels
            if (Period() == PERIOD_D1 ) {
               if (TimeDay(today) < 23) {
                  string s_year  = IntegerToString(TimeYear(today));
                  string s_month = IntegerToString(TimeMonth(today));
                  string s_day   = IntegerToString(DaysInMonth(TimeMonth(today)));
                  NewDateTime2 = StringToTime(s_year+"."+s_month+"."+s_day+" "+" 00:00");
               }
               else { // it is the 25th of the month or later
                  //Print("extending to the next month");
                  int year;
                  if (TimeMonth(today) == 12) 
                     year = TimeYear(today) + 1;
                  else
                     year = TimeYear(today);

                  string s_year = IntegerToString(year);;
                  string s_month = IntegerToString(NextMonth(TimeMonth(today)));
                  string s_day = IntegerToString(DaysInMonth(NextMonth(TimeMonth(today))));
                  NewDateTime2 = StringToTime(s_year+"."+s_month+"."+s_day+" "+" 00:00");
               }
            }
            else if (Period() == PERIOD_W1 || Period() == PERIOD_MN1) {
               string s_year = IntegerToString(TimeYear(today));;
               string s_month = IntegerToString(NextMonth((TimeMonth(today))));
               string s_day = IntegerToString(DaysInMonth(NextMonth(TimeMonth(today))));
               NewDateTime2 = StringToTime(s_year+"."+s_month+"."+s_day+" "+" 00:00");
            }
   
   }
      
   DateTime2(NewDateTime2);
   if (!SimulatorMode) ObjectSetTextMQL4(Name,"Extended on " + TimeToString(TimeLocal(),TIME_DATE|TIME_MINUTES));
}







int CGraphObject::NextMonth(int curr_month) {
   if (curr_month == 12) return 1;
   else curr_month++;
   return curr_month;
}


int CGraphObject::x1() {
   int x,y;
   ChartTimePriceToXY(0,0,DateTime1(),Price1(),x,y);
   return x;
}

int CGraphObject::x2() {
   int x,y;
   ChartTimePriceToXY(0,0,DateTime2(),Price2(),x,y);
   return x;
}

int CGraphObject::x3() {
   int x,y;
   ChartTimePriceToXY(0,0,DateTime3(),Price3(),x,y);
   return x;
}


int CGraphObject::y1() {
   int x,y;
   ChartTimePriceToXY(0,0,DateTime1(),Price1(),x,y);
   return y;
}

int CGraphObject::y2() {
   int x,y;
   ChartTimePriceToXY(0,0,DateTime2(),Price2(),x,y);
   return y;
}

int CGraphObject::y3() {
   int x,y;
   ChartTimePriceToXY(0,0,DateTime3(),Price3(),x,y);
   return y;
}


bool CGraphObject::IsExist(void) {

   if (ObjectFindMQL4(Name) < 0) return false;
   else return true;

}

void CGraphObject::Hide() {

   ObjectSetMQL4(Name,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);

}


void CGraphObject::Delete() {

   ObjectDeleteSilent(ChartID(),Name);

}


void CGraphObject::Select(bool select = true) {

   if (select)
      ObjectSetMQL4(Name,OBJPROP_SELECTED,1);
   else
      ObjectSetMQL4(Name,OBJPROP_SELECTED,0);
      
}

void CGraphObject::Selectable(bool selectable=true) {

   if (selectable)
      ObjectSetInteger(0,Name,OBJPROP_SELECTABLE,true);
   else
      ObjectSetInteger(0,Name,OBJPROP_SELECTABLE,false);
}


string CGraphObject::CreateCopy() {

   string NewObjectName = "Copied by Meta Tools " + " #" + IntegerToString(MathRand()) + "-" + IntegerToString(MathRand());
   
   if (ObjectTypeMQL4(Name)==OBJ_TREND) {
      if (!ObjectCreate(0,NewObjectName,OBJ_TREND,0,DateTime1(),Price1(),DateTime2(),Price2())) return "";
   }
   else if (ObjectTypeMQL4(Name)==OBJ_RECTANGLE) {
      if (!ObjectCreate(0,NewObjectName,OBJ_RECTANGLE,0,DateTime1(),Price1(),DateTime2(),Price2())) return "";
   }
   else 
      return "";
   
   ObjectSetMQL4(Name,OBJPROP_SELECTED,false);
   //ObjectSetMQL4(NewObjectName,OBJPROP_SELECTED,true);

   ObjectSetMQL4(NewObjectName,OBJPROP_TIMEFRAMES,ObjectGetMQL4(Name,OBJPROP_TIMEFRAMES));
   ObjectSetMQL4(NewObjectName,OBJPROP_COLOR,ObjectGetMQL4(Name,OBJPROP_COLOR));
   ObjectSetMQL4(NewObjectName,OBJPROP_STYLE,ObjectGetMQL4(Name,OBJPROP_STYLE));
   ObjectSetMQL4(NewObjectName,OBJPROP_WIDTH,ObjectGetMQL4(Name,OBJPROP_WIDTH));
   ObjectSetMQL4(NewObjectName,OBJPROP_RAY_RIGHT,ObjectGetMQL4(Name,OBJPROP_RAY_RIGHT));
   ObjectSetMQL4(NewObjectName,OBJPROP_RAY,ObjectGetMQL4(Name,OBJPROP_RAY));

   return NewObjectName;

}




bool CGraphObject::IsS3Level(void) {

   // OBJ_HLINE = 1
   // OBJ_TREND = 2
   // OBJ_RECTANGLE = 16

   int obj_type;
   obj_type = ObjectTypeMQL4(Name);


   if ( obj_type == OBJ_HLINE ) { // HLINE
      if ( this.Style() != STYLE_SOLID ) 
         return false;
      else
         return true;
   }
   else if ( obj_type == OBJ_TREND ) {
      CLevel level(Name);
      if ( level.HasRay() ) return false;
      if ( level.HoursBetweenControlPoints() < 24 ) return false; // these could be small marks with trade information
      if ( !level.IsHorizontal() ) return false;
      if ( !level.Style() == STYLE_SOLID ) return false;
      
      return true;      
   }
   else if ( obj_type == OBJ_RECTANGLE ) {
      return false;
   }
   else
      return false;
}


bool CGraphObject::IsBFGraphObject() {

   int obj_type;
   obj_type = ObjectTypeMQL4(Name);

   if ( obj_type == OBJ_TREND ) {
      CTrend trend(Name);
      if ( !trend.HasRay() ) return false;
      if ( trend.HoursBetweenControlPoints() < 4 ) return false; // these could be small marks with trade information
      if ( trend.IsHorizontal() ) return false;
      //if ( !trend.Style() == STYLE_SOLID ) return false;
      
      return true;      
   }
   else if ( obj_type == OBJ_RECTANGLE ) {
      // rectangles are counted as levels, if they are wide (not tall)
      // first time width and height, then ratio
      // then we can tell if it is wide or tall
      int x1, x2, y1, y2;
      
      ChartTimePriceToXY(0,0,DateTime1(),Price1(),x1,y1);
      ChartTimePriceToXY(0,0,DateTime2(),Price2(),x2,y2);
      
      // dimensions of the rectangle
      int width  = MathAbs(x1-x2);
      int height = MathAbs(y1-y2);
      
      if ( width > height * 2 ) // it is twice wider than taller
         return true;
      else 
         return false;
   }
   else if ( obj_type == OBJ_FIBO ) {
      return true;
   }
   else
      return false;

}







void CGraphObject::Thickness(int thickness) {

   ObjectSetInteger(0,Name,OBJPROP_WIDTH,thickness);

}


void CGraphObject::Fill(bool fill=true) {

   ObjectSetInteger(0,Name,OBJPROP_FILL,fill);
   ObjectSetInteger(0,Name,OBJPROP_BACK,fill);

}



void CGraphObject::SetDefaultVisibility() {

   ENUM_OBJECT type = Type();
   
   if (type != OBJ_TREND && type != OBJ_ARROW && type != OBJ_FIBO && type != OBJ_HLINE 
      && type != OBJ_LABEL && type != OBJ_RECTANGLE && type != OBJ_TREND 
      && type != OBJ_TRIANGLE && type != OBJ_CHANNEL)
      return;
      
    if (StringFind(Name,"PSC") != -1) return;
      
      Print(__FUNCTION__ + ": setting default visibility for object '" + Name + "'");
   
   if (Period() == PERIOD_H1 || Period() == PERIOD_M1 || Period() == PERIOD_M5 || Period() == PERIOD_M15 || Period() == PERIOD_M30) {
      //Print(Name);
      ObjectSetMQL4(Name, OBJPROP_TIMEFRAMES, OBJ_PERIOD_H1 | OBJ_PERIOD_M30 | OBJ_PERIOD_M15 | OBJ_PERIOD_M5 | OBJ_PERIOD_M1);
      //Print(Name + " exists: " + ObjectFind(0,Name));
   }
   if (Period() == PERIOD_H1) {
      if (this.Type() == OBJ_TREND) {
         double dist = double(this.DateTime2() - this.DateTime1()) / 60/60;
         if ( dist > 40 ) // if distance btw control points is more than 40 hrs - show this line also on H4
            ObjectSetMQL4(Name, OBJPROP_TIMEFRAMES, OBJ_PERIOD_H1 | OBJ_PERIOD_H4);
      }
   }
   else if (Period() == PERIOD_H4) {
      if (ObjectTypeMQL4(Name) == OBJ_RECTANGLE || ObjectTypeMQL4(Name) == OBJ_ARROW || ObjectTypeMQL4(Name) == OBJ_TEXT) 
         ObjectSetMQL4(Name, OBJPROP_TIMEFRAMES, OBJ_PERIOD_H4); // rectanges and arrows created on H4 have visibility H4 only.
      else
         ObjectSetMQL4(Name, OBJPROP_TIMEFRAMES, OBJ_PERIOD_H1 | OBJ_PERIOD_H4 | OBJ_PERIOD_D1); // other objects - H1, H4, D1
   }
   else if (Period() == PERIOD_D1) {
      if (ObjectTypeMQL4(Name) == OBJ_RECTANGLE) {
         ObjectSetMQL4(Name, OBJPROP_TIMEFRAMES, OBJ_PERIOD_H1 | OBJ_PERIOD_H4 | OBJ_PERIOD_D1); // for D1-levels
      }
   }

}



int CGraphObject::TimesBroken(ENUM_TIMEFRAMES period, int &LastBrokenByBarIndex, double price = -1, int StartingBar = -1) {
   // New version 23.01.2021
   // Universal - should work with both: horizontal and non-horizontal lines
   // See "Times Broken" PPT slide with graphical representation of used arrays
   // LastBrokenByBarIndex - index of the last (closer to the right of the chart) bar that has broken the line
   // if price is indicated - function is called to check # of breaks of that specific price, so, we do not check, if Name is really a qualified object.
   // if StartingBar is indicated that check for breaks will start only from that bar and proceed to the right. If not indicated - this method will detect appropriate starting bar itself depending on the type of object being checked (level or trend)

   //if (!IsVisibleOnTF(Period())) return -1; // if this trend is not visible on the current TF - do not check how many times it is broken, otherwise, bugs / abmiguities are possible (it may be broken on one TF and not broken on another)
   if (price == -1) { // check type of object only when specific price is not indicated
      int object_type = (int)ObjectGetInteger(0,Name,OBJPROP_TYPE);
      if (object_type != OBJ_TREND && object_type != OBJ_HLINE) {
         Print(__FUNCTION__ + ": '" + Name + "' is not a trend and not a horizontal line. Not checking for number of breaks");
         return -1;
      }
   }
   
   double   LinePrices[];
   double   ClosePrices[];
   bool     changes[];
   int      EndingBar=0; // pass EndingBar as reference to one fo the following method to know absolute index of the ending bar - necessary to then detect what was the index of the last bar which broken the line 
   bool LinePricesReceived  = GetLinePrices(Name,period,LinePrices, EndingBar, StartingBar, price);
   bool ClosePricesReceived = GetClosePrices(Name,period,ClosePrices, StartingBar, price);
   
   if (!LinePricesReceived || !ClosePricesReceived) {
      Print(__FUNCTION__, ": Either Line Prices or Closing Prices were not received. Not counting times '"+Name+"' is broken.");
      return -1;
   }
   
   int count = 0;
   LastBrokenByBarIndex =-1;
   
   // forming array of changes
   for (int i=0; i < ArraySize(LinePrices); i++) {
       if (ClosePrices[i] > LinePrices[i]) {
           ArrayResize(changes,ArraySize(changes)+1);
           changes[ArraySize(changes)-1] = true;
       }
       if (ClosePrices[i] < LinePrices[i]) {
           ArrayResize(changes,ArraySize(changes)+1);
           changes[ArraySize(changes)-1] = false;
       }
       // checking, if this the last bar that has broken the line (first one in this cycle, as we're scanning from right to the left
       if (i>0 && LastBrokenByBarIndex == -1 && ArraySize(changes)>1 && (changes[ArraySize(changes)-1] != changes[ArraySize(changes)-2]) )
         LastBrokenByBarIndex = i + EndingBar - 1; // this is the last bar that has broken the line!
   }
   
   // counting number of changes = number of breaks
   for (int i=0; i < ArraySize(changes)-1; i++) {
       if (changes[i] == changes[i+1])
           continue;
       else
           count += 1;
   }
   
   return count;
}





bool CGraphObject::GetLinePrices(string TrendName, ENUM_TIMEFRAMES period, double &array[], int &EndingBar, int StartingBar = -1,  double price =-1) {
   // returns array with price value on the line for each bar between control points of the horizontal trend; OR
   //                                                         between 2nd control point-1 and the last closed bar
   // MQL5 compapible
   datetime    time1;
   datetime    time2;
   double      price1;
   double      price2;

   int object_type = (int)ObjectGetInteger(0,Name,OBJPROP_TYPE);
   if (price != -1) { // specific level to be checked is requested
      price1 = price;
      price2 = price;
      EndingBar = 1;   
   }
   else if (object_type == OBJ_TREND) {
      time1          = (datetime)ObjectGetInteger(0,TrendName,OBJPROP_TIME);   // time of the Control Point 1
      time2          = (datetime)ObjectGetInteger(0,TrendName,OBJPROP_TIME,1); // time of the Control Point 2
      if (price == -1) {
         price1         = ObjectGetDouble(0,TrendName,OBJPROP_PRICE);
         price2         = ObjectGetDouble(0,TrendName,OBJPROP_PRICE,1);
      }
      else {
         price1 = price;
         price2 = price;
      }
      if (StartingBar == -1)
         StartingBar    = iBarShift(Symbol(),period,time1);                   // bar # of the Control Point 1 (global chart bar index)
      EndingBar      = iBarShift(Symbol(),period,(time2));                   // bar # of the Control Point 2 (global chart bar index)
      if (EndingBar == 0) EndingBar = 1;
   }
   else if (object_type == OBJ_HLINE) {
      // used only for D1 Strategy and for H1 period
      if (period != PERIOD_H1) return false;
      time1          = iTime(Symbol(),PERIOD_D1,0);
      time2          = iTime(Symbol(),PERIOD_H1,1);
      if (price == -1) {
         price1         = ObjectGetDouble(0,TrendName,OBJPROP_PRICE);
         price2         = price1;
      }
      else {
         price1 = price;
         price2 = price;
      }
      if (StartingBar == -1)
         StartingBar    = iBarShift(Symbol(),period,time1); // first bar of the day
      EndingBar      = 1;
   }
   else {
      Print(__FUNCTION__ + "'" + TrendName + "' is not a trend!");
      return false;
   }


   if (price1 == price2) { // line is horizontal - fill array with same values
      ArrayResize(array, StartingBar-EndingBar+1);
      ArrayInitialize(array,0);
      for (int i = ArraySize(array)-1; i >= 0; i--) {
         array[i] = price1;
      }
   }
   else { // line is not horizontal - fill array with calculated touch price 
      StartingBar = EndingBar; // start checking from the 2nd control point
      EndingBar = 1; // check breaks until previous closed bar
      ArrayResize(array,StartingBar-EndingBar+1);
      ArrayInitialize(array,0);
      for (int i = StartingBar; i >= EndingBar; i--) {
         array[i-1] = ObjectGetValueByShiftMQL4(TrendName,i,period);
      }
   }
   return true;
}



bool CGraphObject::GetClosePrices(string TrendName, ENUM_TIMEFRAMES period, double &array[], int StartingBar = -1, double price = -1) {
   // returns array with close prices of bars between control points of the horizontal trend; OR
   //                                         between 2nd control point-1 and last closed bar on the chart
   // MQL5 compapible

   datetime    time1;
   datetime    time2;
   double      price1;
   double      price2;
   int         EndingBar;

   int object_type = (int)ObjectGetInteger(0,Name,OBJPROP_TYPE);
      if (price != -1) { // specific level to be checked is requested
      price1 = price;
      price2 = price;
      EndingBar = 1;   
   }
   else if (object_type == OBJ_TREND) {
      time1          = (datetime)ObjectGetInteger(0,TrendName,OBJPROP_TIME);   // time of the Control Point 1
      time2          = (datetime)ObjectGetInteger(0,TrendName,OBJPROP_TIME,1); // time of the Control Point 2
      if (price == -1) {
         price1         = ObjectGetDouble(0,TrendName,OBJPROP_PRICE);
         price2         = ObjectGetDouble(0,TrendName,OBJPROP_PRICE,1);
      }
      else {
         price1 = price;
         price2 = price;
      }
      if (StartingBar == -1)
         StartingBar    = iBarShift(Symbol(),period,time1);                   // bar # of the Control Point 1 (global chart bar index)
      EndingBar     = iBarShift(Symbol(),period,(time2));                   // bar # of the Control Point 2 (global chart bar index)
      if (EndingBar == 0) EndingBar = 1;
   }
   else if (object_type == OBJ_HLINE) {
      // used only for D1 Strategy and for H1 period
      if (period != PERIOD_H1) return false;
      time1          = iTime(Symbol(),PERIOD_D1,0);
      time2          = iTime(Symbol(),PERIOD_H1,1);
      if (price == -1) {
         price1         = ObjectGetDouble(0,TrendName,OBJPROP_PRICE);
         price2         = price1;
      }
      else {
         price1 = price;
         price2 = price;
      }
      if (StartingBar == -1)
         StartingBar    = iBarShift(Symbol(),period,time1); // first bar of the day
      EndingBar     = 1;
   }
   else {
      Print(__FUNCTION__ + "'" + TrendName + "' is not a trend!");
      return false;
   }
   

   if (price1 == price2) { // line is horizontal - fill array with close prices between trend control points
      ArrayResize(array, StartingBar-EndingBar+1);
      ArrayInitialize(array,0);
      int n = ArraySize(array)-1;
      for (int i = StartingBar; i >= EndingBar; i--) {
         array[n] = iClose(Symbol(),period,i);
         n--;
         if (n < 0) break;
      }
   }
   else { // line is not horizontal - fill array with close prices between 2nd control point-1 and last closed bar
      StartingBar = EndingBar; // start checking from the 2nd control point
      EndingBar   = 1; // check breaks until previous closed bar
      ArrayResize(array,StartingBar-EndingBar+1);
      ArrayInitialize(array,0);
      for (int i = StartingBar; i >= EndingBar; i--) {
         array[i-1] = iClose(Symbol(),period,i);
      }
   }
   return true;
}




double CGraphObject::GetSnappingDistance(string symbol, int period) {

   //bool jpy    = StringFind(_Symbol,"JPY")!=-1;
   bool btc = StringFind(_Symbol,"BTC")!=-1;
   bool eth = StringFind(_Symbol,"ETH")!=-1;
   bool oil    = _Symbol == "BRN" || _Symbol == "WTI" || _Symbol == "BRENT";
   bool gold   = StringFind(_Symbol,"XAU")!=-1;

   double dist = 50;

   if(Period() == PERIOD_M1) dist = 10;
   if(Period() == PERIOD_M5) dist = 20;
   if(Period() == PERIOD_M15) dist = 25;
   if(Period() == PERIOD_M30) dist = 30;
   if(Period() == PERIOD_H1) { 
      dist = 50;
      if (eth) dist = dist * 25;
      else if (btc) dist = dist * 300;
      else if (_Symbol == "GBPJPY") dist = 120;
      else if (gold) dist = dist * 2;
   }
   if(Period() == PERIOD_H4) {
      dist = 100;
      if (_Symbol == "GBPJPY") dist = 200;
   }
   if(Period() == PERIOD_D1) { 
      dist = 250;
      if (eth)       dist = dist * 10;
      else if (btc)  dist = dist * 150;
      else if (oil)  dist = dist / 10;
      else if (gold) dist = dist * 2;
      else if (_Symbol == "EURGBP") dist = 150;
      else if (_Symbol == "EURCHF") dist = dist / 3;
      else if (_Symbol == "GBPJPY") dist = 500;
      else if (_Symbol == "NQ100") dist  = 500;
   }
   if(Period() == PERIOD_W1) dist = 250;
   if(Period() == PERIOD_MN1) dist = 500;
   
   return dist;

}


double CGraphObject::HoursBetweenControlPoints() {

   return double(MathAbs( (DateTime1() - DateTime2()) /3600 ));

}




void CGraphObject::SnapTo(SnapTo snapto) {
   Print("Starting snapping...");
   if (snapto == NoSnapping) return;

   // find where the line starts and where it ends
   datetime time1  = this.DateTime1();
   datetime time2  = this.DateTime2();
   double   Price1 = this.Price1();
   double   Price2 = this.Price2();
   double   RectHeight = 0;
   
   // **************** START OF CHECK ************************************************
   // checking if this is a trading / signal level;
   // in which case we will not need to check, if it aligns to qualitied (round) level
   // we will snap it to closest bars (extremums or bodies) instead
   bool     isHorizontal = this.Price1() == this.Price2();
   bool     isTrend      = this.Type() == OBJ_TREND;
   bool     BuySellLevel = false;
   if (isTrend && isHorizontal)
      BuySellLevel = this.Color() == clrGreen || this.Color() == clrRed;
   //Print("BuySellLevel = ", BuySellLevel);
   // **************** END OF CHECK ************************************************
   
   if (ObjectTypeMQL4(this.Name) == OBJ_RECTANGLE) RectHeight = MathAbs(Price1 - Price2);
   
   int StartingBar = iBarShift(_Symbol,_Period,time1);
   int EndingBar   = iBarShift(_Symbol,_Period,time2);
   if ( StartingBar < EndingBar ) { // in case if user create this trend line from right to left when drawing manually on the chart
      // switching places
      int tmp_bar = StartingBar;
      StartingBar = EndingBar;
      EndingBar   = tmp_bar;
   }
   
   //Print("EndingBar = ", EndingBar);
   if (EndingBar == 0) EndingBar = 1; // если этого не сделать, то выравнивание тренда снизу по экстремуму иногда работает неверное

   double SnappingDistance = this.GetSnappingDistance(_Symbol, _Period);
   //Print("SnappingDistance = ", SnappingDistance);

   double ClosestPriceAbove = Price1 + _Point*SnappingDistance;
   double ClosestPriceBelow = Price2 - _Point*SnappingDistance;
   
   //Print("ClosestPriceAbove = ", ClosestPriceAbove);
   //Print("ClosestPriceBelow = ", ClosestPriceBelow);

   bool SnapIsON=false;

   for(int i=StartingBar; i>=EndingBar; i--) { // cycle through all the bars from left end of level to the right end
      // Check, if (after previous cycle) the line already sits on the Open or Close (High/Low for S3) price. Then exit function
      if (snapto == Bodies) {
         if(Price1 == Open[i] || Price1 == Close[i]) return;
         if(Price2 == Open[i] || Price2 == Close[i]) return;
      }
      else if (snapto == Extremums) {
         if(Price1 == High[i] || Price1 == Low[i]) return;
         if(Price2 == High[i] || Price2 == Low[i]) return;
      }
      // check is finished ***********************************


      // ******************* THE CYCLE *********************
      if(snapto == Extremums) {
         //// checking bars above the line
         if(High[i]>Price1 && High[i]<ClosestPriceAbove) {
            if (this.IsQualifiedLevel(StartingBar,EndingBar,High[i],i) || BuySellLevel)
               ClosestPriceAbove=High[i]; SnapIsON=true; 
           }
         if(Low[i]>Price1 && Low[i]<ClosestPriceAbove)  {
            if (this.IsQualifiedLevel(StartingBar,EndingBar,Low[i],i) || BuySellLevel)
               ClosestPriceAbove=Low[i]; SnapIsON=true; 
           }

         // checking below the line
         if(High[i]<Price1 && High[i]>ClosestPriceBelow) {
            if (this.IsQualifiedLevel(StartingBar,EndingBar,High[i],i) || BuySellLevel)
               ClosestPriceBelow=High[i]; SnapIsON=true; 
           }

         if(Low[i]<Price1 && Low[i]>ClosestPriceBelow) {
            if (this.IsQualifiedLevel(StartingBar,EndingBar,High[i],i || BuySellLevel))
               ClosestPriceBelow=High[i]; SnapIsON=true; 
           }
        }
      else if (snapto == Bodies) { 
         //// checking above the line
         if(Open[i]>Price1 && Open[i]<ClosestPriceAbove) {
            if (this.IsQualifiedLevel(StartingBar,EndingBar,Open[i],i))
               ClosestPriceAbove=Open[i]; SnapIsON=true; 
           }
         if(Close[i]>Price1 && Close[i]<ClosestPriceAbove) {
            if (this.IsQualifiedLevel(StartingBar,EndingBar,Close[i],i))
               ClosestPriceAbove=Close[i]; SnapIsON=true; 
           }

         // checking below the line
         if(Open[i]<Price2 && Open[i]>ClosestPriceBelow) {
            if (this.IsQualifiedLevel(StartingBar,EndingBar,Open[i],i))
               ClosestPriceBelow=Open[i]; SnapIsON=true; 
           }

         if(Close[i]<Price2 && Close[i]>ClosestPriceBelow) {
            if (this.IsQualifiedLevel(StartingBar,EndingBar,Close[i],i))
               ClosestPriceBelow=Close[i]; SnapIsON=true; 
           }
        }
        else return;
     } // *******************  end of for-cycle *******************

   if(SnapIsON) {
      double h1 = ClosestPriceAbove - Price1; // расстояние от Price1 до ClosestPriceAbove
      double h2 = Price2 - ClosestPriceBelow; // расстояние от Price1 до ClosestPriceBelow
      if(h1==h2) return;

      if(h1<h2) { // level is below the closest price - moving level higher
         this.Price1(ClosestPriceAbove);
         this.Price2(ClosestPriceAbove - RectHeight);
        }
      else { // level is above the closest price - moving level lower
         this.Price1(ClosestPriceBelow + RectHeight);
         this.Price2(ClosestPriceBelow);
        }
     }
}


bool CGraphObject::IsQualifiedLevel(int StartingBar, int EndingBar, double price, int i) {
   if (price <= 0) { Print(__FUNCTION__ + ": error - price <= 0"); return false; }
   
   
   // qualification flags
   bool lower_left  = false;
   bool lower_right = false;
   bool upper_left  = false;
   bool upper_right = false;
   
   // checking of this price correponds to real level
   // 'real' level should have no wicks and bodies to the left and to the right from index
   
   // LOWER LEVEL
      // checking disconnection to the left from the i
      // disqualify level, if open or close price is lower than price
      // qualify level, if low is above the price
      for (int n = i+1; n <= StartingBar; n++) {
         if (iLow(  _Symbol, _Period,n) > price) { lower_left = true;  break; }
         if (iOpen( _Symbol, _Period,n) < price) { lower_left = false; break; }
         if (iClose(_Symbol, _Period,n) < price) { lower_left = false; break; }
      }
      
      // checking disconnection to the right of the i
      for (int n = i-1; n >= EndingBar; n--) {
         if (n == 0) { lower_right = true; break; }
         if (iLow(  _Symbol, _Period,n) > price) { lower_right = true;  break; }
         if (iOpen( _Symbol, _Period,n) < price) { lower_right = false; break; }
         if (iClose(_Symbol, _Period,n) < price) { lower_right = false; break; }
      }
   
   
   // UPPER LEVEL
      // checking disconnection to the left of the i
      // disqualify level, if open or close price is lower than price
      // qualify level, if low is above the price
      for (int n = i+1; n <= StartingBar; n++) {
         if (iHigh(  _Symbol, _Period,n) < price) { upper_left = true;  break; }
         if (iOpen( _Symbol, _Period,n) > price) { upper_left = false; break; }
         if (iClose(_Symbol, _Period,n) > price) { upper_left = false; break; }
      }
      
      // checking disconnection to the right of the i
      for (int n = i-1; n >= EndingBar; n--) {
         if (n == 0) { upper_right = true; break; }
         if (iHigh(  _Symbol, _Period,n) < price) { upper_right = true;  break; }
         if (iOpen( _Symbol, _Period,n) > price) { upper_right = false; break; }
         if (iClose(_Symbol, _Period,n) > price) { upper_right = false; break; }
      }

   //Print("price = " + DoubleToString(price,5));
   //Print("Bar of the level = " + i);
   //Print("StartingBar = " + StartingBar + " | EngingBar = " + EndingBar);
   //Print("lower_left = " + lower_left);
   //Print("lower_right = " + lower_right);
   //Print("upper_left = " + upper_left);
   //Print("upper_right = " + upper_right);

   if (lower_left && lower_right) return true;
   if (upper_left && upper_right) return true;
   
   return false;

}

