#include "GraphObject.mqh"


enum LevelType {
   Level = 0, // Level
   RoundLevel = 1  // Round Level
};



class CLevel : public CGraphObject
  {
private:

public:
                           CLevel(string name);
                           CLevel(void);
                          ~CLevel();
      double               Price();
      void                 Price(double new_price);
      //int                  TimesBrokenOnTF(double price_level, int StartingBar, int period, int &LastBrokenBytBarIndex);
      bool                 IsHorizontal();
      bool                 HasRay();
      LevelType            Type;
      TradeDirectionType   TradeDirection;    
      TradeDirectionType   GetTradeDirection();   
      void                 UpdateLabel(StrategyID strategy, DayPriorityID Day_Priority);
      bool                 DeleteLabels();
      string               LevelTimesBrokenLabelName();
      string               DirectionLabelName();
      string               PriceLabelName();
      int                  y(); // y ccordinate of the level
      string               RoundLevel_Minus1_Name;
      string               RoundLevel_Minus2_Name;
      string               RoundLevel_Plus1_Name;
      string               RoundLevel_Plus2_Name;
      string               ExtToTakeOutLabelName();
      double               DistanceToCurrentPrice();
      bool                 IsBodyLevel();
      string               LowerLevel_Name(int period, double price); // can be made private
      string               UpperLevel_Name(int period, double price); // can be made private
      bool                 CreateLevel(StrategyID strategy, double price, datetime time1, datetime time2, color clr, int period);
      bool                 CreateRectLevel(int mouse_x, int mouse_y);
      bool                 CreateRect(string name, datetime DateTime1, double Price1, datetime DateTime2, double Price2);
      bool                 CreateH1Level(int D1_Bar, TradeDirectionType type);
      void                 AutoColor(bool is_S_Version);
      static short         GetClosestLevelIndexInArray(CLevel &array[]);
      static void          DrawUpdateRoundLevelsD1();
      void                 DeleteD1RoundLevels();
  };



CLevel::CLevel(string name) {
   CLevel();
   Name = name;
   if (ObjectTypeMQL4(name) == OBJ_TREND) Type = Level;
   else if (ObjectTypeMQL4(name) == OBJ_HLINE) Type = RoundLevel;
      
   TradeDirection = GetTradeDirection();
   
}

string CLevel::ExtToTakeOutLabelName() {

   return "TakeOutExtr for " + this.Name + " Lbl";

}

CLevel::CLevel(void) {
   RoundLevel_Minus1_Name = "RoundLevelD1 -1";
   RoundLevel_Minus2_Name = "RoundLevelD1 -2";
   RoundLevel_Plus1_Name = "RoundLevelD1 +1";
   RoundLevel_Plus2_Name = "RoundLevelD1 +2";
}

CLevel::~CLevel()
  {
  }
//+------------------------------------------------------------------+





void CLevel::DeleteD1RoundLevels(void) {
   Print(__FUNCTION__);
   ObjectDelete(0,RoundLevel_Minus1_Name);
   ObjectDelete(0,RoundLevel_Minus2_Name);
   ObjectDelete(0,RoundLevel_Plus1_Name);
   ObjectDelete(0,RoundLevel_Plus2_Name);

}


double CLevel::DistanceToCurrentPrice(void) {

   double distance = 0; 
   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(_Symbol ,Latest_Price); // Assign current prices to structure 

   if (TradeDirection == Buy_Level && Latest_Price.ask > Price()) {
      // measuring from level to Ask price
      distance = (double)MathAbs(Latest_Price.ask - Price()) / _Point;
   } 
   else if (TradeDirection == Sell_Level && Latest_Price.bid < Price()) {
      // measuring from level to Bid price
      distance = (double)MathAbs(Latest_Price.bid - Price()) / _Point;
   }
   else 
      distance = 0;
      
   //Print("distance from level '" + Name + "' = ", distance);
   return distance;
}


   

double CLevel::Price() {
   return Price1();
}

void CLevel::Price(double new_price) {
   Price1(new_price);
}







//int CLevel::TimesBrokenOnTF(int period) {
//
//   int StartingBar = 0; // first bar (from the left), from which check will start, and continue to the right
//   if (Type == RoundLevel)
//       // round levels are used in D1 strategy only and on H1 TF only. So, we are searching for breaks from the begining of the day only.
//       StartingBar = iBarShift(Symbol(),period,Today()); // first bar of the day
//   else 
//      // all other cases - searching from the left (first) control point + 1 bar to the right
//      StartingBar = iBarShift(Symbol(),period,DateTime1()) - 1; // shift 1 bar to the right to avoid situations when near-by bar from the left counts as break
//
//   int i_fake=0;
//   return TimesBrokenOnTF(Price(), StartingBar, period, i_fake);
//
//}



//int CLevel::TimesBrokenOnTF(double price_level, int StartingBar, int period, int &LastBrokenByBarIndex) {
//
//   int TimesBrokenCounter=0;
//   // getting index of the first bar of the day.
//   // we will scan from the 1st bar until latest closed bar (index = 1) (from left to the right of the chart)
//   
//   double Thicker = _Point * 15;
//   bool   BreakOuts[];
//   ArrayResize(BreakOuts,StartingBar+1); // array size is equal to the count of bars to be processed
//   
//   for (int i = StartingBar; i > 0; i--) {
//      // cycle from the left to the right
//      // проверка на прямой пробой одний баром: открылся с одной стороны, закрылся с другой
//      // Case #1 - direct break out
//      if (iOpen(Symbol(),period,i) > price_level+Thicker && iClose(Symbol(),period,i) < price_level-Thicker) { TimesBrokenCounter++; BreakOuts[i] = true; LastBrokenByBarIndex = i; continue; }
//      if (iOpen(Symbol(),period,i) < price_level-Thicker && iClose(Symbol(),period,i) > price_level+Thicker) { TimesBrokenCounter++; BreakOuts[i] = true; LastBrokenByBarIndex = i; continue; }
//   
//      if (i < StartingBar && !BreakOuts[i+1]) { // starting from the 2nd bar in sequence of bars; and if Break was not already found on the previous bar
//         if (iClose(Symbol(),period,i+1)  < price_level-Thicker && iOpen(Symbol(),period,i) > price_level+Thicker) { TimesBrokenCounter++; LastBrokenByBarIndex = i; continue; }
//         if (iClose(Symbol(),period,i+1)  > price_level+Thicker && iOpen(Symbol(),period,i) < price_level-Thicker) { TimesBrokenCounter++; LastBrokenByBarIndex = i; continue; }
//         if (iOpen(Symbol(), period,i+1)  > price_level+Thicker && iClose(Symbol(),period,i)< price_level-Thicker) { TimesBrokenCounter++; LastBrokenByBarIndex = i; continue; }
//         if (iOpen(Symbol(), period,i+1)  < price_level-Thicker && iClose(Symbol(),period,i)> price_level+Thicker) { TimesBrokenCounter++; LastBrokenByBarIndex = i; continue; }
//      }
//   }
//   return TimesBrokenCounter;
//
//}








string CLevel::DirectionLabelName() {
   return Name + " Direction Label";
}


string CLevel::PriceLabelName() {
   return Name + " Price Arrow";
}



void CLevel::UpdateLabel(StrategyID strategy, DayPriorityID Day_Priority) {

   
   // Trade Direction Label
   string sDirectionLabel  = DirectionLabelName();
   string sPriceLabel      = PriceLabelName();
   ObjectDeleteSilent(0,sDirectionLabel);
   ObjectDeleteSilent(0,sPriceLabel);
   
   if (strategy == BF) return; // no labels for BF strategy
   
   bool selectable = false;
   
   datetime datetime2 = DateTime2();
   
   if (datetime2 == 0) datetime2 = Tomorrow(); // provision for round level case
   
   ObjectCreate(0,sDirectionLabel,OBJ_TEXT,0,datetime(datetime2+3500),Price2()+0*_Point);
   if (Strategy == S3) {
      ObjectSetMQL4(sDirectionLabel,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1|OBJ_PERIOD_H4);
   }
   else
      ObjectSetMQL4(sDirectionLabel,OBJPROP_TIMEFRAMES,ObjectGetMQL4(Name,OBJPROP_TIMEFRAMES));
   ObjectSetInteger(0,sDirectionLabel,OBJPROP_SELECTABLE,selectable);
   ObjectSetInteger(0,sDirectionLabel,OBJPROP_ANCHOR,ANCHOR_LEFT);
   
   
   if (S_Version && Strategy == S3) {
      // для S3-обзоров Сергея
      ObjectCreate(0,sPriceLabel,OBJ_ARROW_RIGHT_PRICE,0,datetime(datetime2+11000),Price2()+0*_Point);
      //ObjectSetMQL4(sPriceLabel,OBJPROP_TIMEFRAMES,ObjectGetMQL4(Name,OBJPROP_TIMEFRAMES)); // setting same visibility TF's to the label the level has
      ObjectSetMQL4(sPriceLabel,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1);
      ObjectSetInteger(0,sPriceLabel,OBJPROP_SELECTABLE,true);
      ObjectSetInteger(0,sPriceLabel,OBJPROP_ANCHOR,ANCHOR_LEFT);
   }
      
   if (TradeDirection == Buy_Level) {
      ObjectSetTextMQL4(sDirectionLabel,CharToString(225),9,"Wingdings",clrGreen);
      ObjectSetString(0,sDirectionLabel,OBJPROP_TOOLTIP,"Buy");
      if (S_Version && Strategy == S3) ObjectSetInteger(0,sPriceLabel,OBJPROP_COLOR,clrGreen);
   }
   else if (TradeDirection == Sell_Level) {
      ObjectSetTextMQL4(sDirectionLabel,CharToString(226),9,"Wingdings",clrRed);
      ObjectSetString(0,sDirectionLabel,OBJPROP_TOOLTIP,"Sell");
      if (S_Version && Strategy == S3) ObjectSetInteger(0,sPriceLabel,OBJPROP_COLOR,clrRed);
   }
   else {
      ObjectSetTextMQL4(sDirectionLabel,CharToString(251),12,"Wingdings",clrBlack);
      ObjectSetString(0,sDirectionLabel,OBJPROP_TOOLTIP,"Create Arrow in Yesterday to Set Direction");
   }
   
   bool DirectionAndDayPrioMatch = false;
   if (TradeDirection == Buy_Level  && Day_Priority == Buy)  DirectionAndDayPrioMatch = true;
   if (TradeDirection == Sell_Level && Day_Priority == Sell) DirectionAndDayPrioMatch = true;
   
   
   // Times Broken Label
   string LabelName = LevelTimesBrokenLabelName();   
   if (DirectionAndDayPrioMatch || strategy != S3) {
      ENUM_TIMEFRAMES broken_on_TF; // which TF to use when calculating number of breaks
      if (IsVisibleOnTF(PERIOD_D1)) broken_on_TF = PERIOD_D1;
      else broken_on_TF = PERIOD_H1;
      int LastBrokenByBarIndex;
      string LabelText = IntegerToString(TimesBroken(broken_on_TF,LastBrokenByBarIndex));
      ObjectDeleteSilent(0,LabelName);
      ObjectCreate(0,LabelName,OBJ_TEXT,0, DateTime2() + Period()*120,Price2()+0*_Point);
      ObjectSetTextMQL4(LabelName,LabelText,8,"Arial",clrGray);
      ObjectSetMQL4(LabelName,OBJPROP_TIMEFRAMES,ObjectGetMQL4(Name,OBJPROP_TIMEFRAMES));
      ObjectSetInteger(0,LabelName,OBJPROP_SELECTABLE,selectable);
      ObjectSetInteger(0,LabelName,OBJPROP_ANCHOR,ANCHOR_LEFT);
      ObjectSetString(0,LabelName,OBJPROP_TOOLTIP,"Times Broken");
   }
   else if (!DirectionAndDayPrioMatch && strategy != S3) { 
      ObjectDeleteSilent(0,LabelName);
      ObjectCreate(0,LabelName,OBJ_TEXT,0,DateTime2()+8000,Price2()+0*_Point);
      string msg;
      int day_of_week = TimeDayOfWeekMQL4(TimeLocal());
      if (day_of_week == 0 || day_of_week == 6)
         msg = "Check again on Monday";
      else
         msg = "Day Priority and Level Type Do Not Match";
      ObjectSetTextMQL4(LabelName,msg,8,"Arial",clrBlack);
      ObjectSetMQL4(LabelName,OBJPROP_TIMEFRAMES,ObjectGetMQL4(Name,OBJPROP_TIMEFRAMES));
      ObjectSetInteger(0,LabelName,OBJPROP_SELECTABLE,selectable);
      ObjectSetInteger(0,LabelName,OBJPROP_ANCHOR,ANCHOR_LEFT);
      ObjectSetString(0,LabelName,OBJPROP_TOOLTIP,"Error");
   }
}


bool CLevel::DeleteLabels() {
   bool b1 = ObjectDeleteSilent(0,LevelTimesBrokenLabelName());
   bool b2 = ObjectDeleteSilent(0,DirectionLabelName());
   bool b3 = ObjectDeleteSilent(0,PriceLabelName());
   
   if (!b1 || !b2) return false;
   else return true;  

}



string CLevel::LevelTimesBrokenLabelName() {
   return Name + " Times Broken";

}



bool CLevel::IsHorizontal(void) {

   //double Price1 = ObjectGetMQL4(Name,OBJPROP_PRICE1);
   //double Price2 = ObjectGetMQL4(Name,OBJPROP_PRICE2);
   
   if (Price1() == Price2()) return true;
   else return false;
}

bool CLevel::HasRay() {

   if (ObjectGetMQL4(Name,OBJPROP_RAY_RIGHT)) return true;
   
   else return false;
}





int CLevel::y() {
   
   return y1();

}






bool CLevel::IsBodyLevel() {

   int obj_type = ObjectTypeMQL4(Name);

   if ( obj_type != OBJ_TREND && obj_type != OBJ_RECTANGLE ) return false;
   if ( StringFind(Name, "Lwr.") == -1 && StringFind(Name, "Upr.") == -1) return false;
   
   // checks specific to trend
   if (obj_type == OBJ_TREND) {
      if ( Style() != STYLE_SOLID) return false;
      if ( Price1() != Price2() ) return false; // should be horizontal
      if ( Color() != clrRed && Color() != clrGreen ) return false;
   }
   
   return true;
}







string CLevel::LowerLevel_Name(int period, double price) {
   return("Lwr. " + TimeframeToString(period) + " | price " + DoubleToString(price,_Digits));
}

string CLevel::UpperLevel_Name(int period, double price) {
   return "Upr. " + TimeframeToString(period) + " | price " + DoubleToString(price,_Digits);
}




bool CLevel::CreateLevel(StrategyID strategy, double price, datetime time1, datetime time2, color clr, int period) {
   
   ObjectDeleteSilent(Name);
   bool created;
   if (strategy == BF || strategy == S3) {   
      // creating level as rectangles  
      datetime DateTime1 = time1;
      datetime DateTime2 = time2;
      double   Price1 = price;
      double   Price2 = price;
      double   screen_height = ChartGetDouble(0,CHART_PRICE_MAX,0) - ChartGetDouble(0,CHART_PRICE_MIN,0);
      
      if (TradeDirection == Buy_Level)
         Price2 = Price2 - screen_height * 0.0025;
      else
         Price2 = Price2 + screen_height * 0.0025;

      created = CreateRect(Name,DateTime1,Price1,DateTime2,Price2);
      if (!created)
         Print("Could not create new level of type 'Rectangle' named '" + Name + "'");
      AutoColor(S_Version);
      SetDefaultVisibility(); // BUG!!! Не понятно почему эта строчка приводит к невозможности создать уровни-прямоугольники на Н1 для стретегий S3 и БФ
   }
   else { // for all other strategies
      // creating levels as lines
      created = ObjectCreate(ChartID(),Name,OBJ_TREND,0,time1,price,time2,price);
      if (!created) {
         Print("Could not create new level of type 'Trend' named '" + Name + "'");
         return false;
      }
      else
         //Print("Level '" + Name + "' created");
      ObjectSetInteger(ChartID(),Name,OBJPROP_COLOR,clr);
      ObjectSetInteger(ChartID(),Name,OBJPROP_STYLE,STYLE_SOLID);
      ObjectSetInteger(ChartID(),Name,OBJPROP_WIDTH,1);
      ObjectSetInteger(ChartID(),Name,OBJPROP_RAY_RIGHT,false);
      ObjectSetInteger(ChartID(),Name,OBJPROP_TIMEFRAMES,TimeFrameToObjPropTimeFrame(period));
   }
      
   return true;
}





bool CLevel::CreateH1Level(int D1_Bar, TradeDirectionType type) {

   int random_int = MathRand();
   Name = "Auto H1-level # " + IntegerToString(random_int);
   
   while (ObjectFindMQL4(Name) >= 0)
      Name = "Auto H1-level # " + IntegerToString(random_int);


   datetime time1 = iTime(Symbol(),PERIOD_D1,D1_Bar);
   datetime time2 = iTime(Symbol(),PERIOD_D1,0);
   double   price;
   
   if (type == Buy_Level) {
      price = iLow(Symbol(),PERIOD_D1,D1_Bar);
   }
   else { // sell level
      price = iHigh(Symbol(),PERIOD_D1,D1_Bar);
   }
   
   
   
   // ======================== Check if such level already exists ========================
	int obj_total = ObjectsTotalMQL4();
	string name = "";
	bool found = false;
	for (int i = 0; i < obj_total; i++)
	{
		name = ObjectNameMQL4(i);
		if (ObjectGetMQL4(name,OBJPROP_PRICE1) == price && (datetime)ObjectGetMQL4(name,OBJPROP_TIME1) == time1) {
		   found = true;
		   Name = name;
		}
	}
	// ====================================================================================
   
   
   if (!found) {
      // creating the level as trend
      bool created = ObjectCreate(ChartID(),Name,OBJ_TREND,0,time1,price,time2,price);
      if (!created) {
         Print("Could not create new H1-level named '" + Name + "'");
         return false;
      }
   }
   else {
      //Print(EnumToString(type) + " already exists. Updating...");
   }

   Price2(Price1());
   ExtendPoint2();

   if (type == Buy_Level) 
      ObjectSetInteger(ChartID(),Name,OBJPROP_COLOR,clrGreen);
   else
      ObjectSetInteger(ChartID(),Name,OBJPROP_COLOR,clrRed);
   ObjectSetInteger(ChartID(),Name,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(ChartID(),Name,OBJPROP_WIDTH,1);
   ObjectSetInteger(ChartID(),Name,OBJPROP_RAY_RIGHT,false);
   ObjectSetInteger(ChartID(),Name,OBJPROP_TIMEFRAMES,PERIOD_D1|PERIOD_H4|PERIOD_H1|PERIOD_M30|PERIOD_M15|PERIOD_M5|PERIOD_M1);
   if (!SimulatorMode) ObjectSetTextMQL4(Name,"Created on " + TimeToString(TimeLocal(),TIME_DATE|TIME_MINUTES));
   return true;
}






bool CLevel::CreateRectLevel(int mouse_x, int mouse_y){

   Name = "Level Created by MetaTools #" + IntegerToString(MathRand());
   
   // cursor coordinates
   datetime Mouse_DateTime;
   double   Mouse_Price;
   
   int fake_int;
   
   // coordinates of the new rectangle
   datetime DateTime1;
   datetime DateTime2;
   double   Price1;
   double   Price2;
   
   // cursor x, y -> cursor datetime and price
   ChartXYToTimePrice(ChartID(),mouse_x, mouse_y,fake_int,Mouse_DateTime,Mouse_Price);
   
   // set width of the object depending on the current chart Period
   if (Period() == PERIOD_M1) {
      DateTime1 = Mouse_DateTime - 3000;
      DateTime2 = Mouse_DateTime + 3000;
   }
   else if (Period() == PERIOD_M5) {
      DateTime1 = Mouse_DateTime - 6000;
      DateTime2 = Mouse_DateTime + 6000;
   }
   else if (Period() == PERIOD_M15) {
      DateTime1 = Mouse_DateTime - 20000;
      DateTime2 = Mouse_DateTime + 20000;
   }
   else if (Period() == PERIOD_M30) {
      DateTime1 = Mouse_DateTime - 50000;
      DateTime2 = Mouse_DateTime + 50000;
   }
   else if (Period() == PERIOD_H1) {
      DateTime1 = Mouse_DateTime - HR2400;
      DateTime2 = Mouse_DateTime + HR2400;
   }
   else if (Period() == PERIOD_H4) {
      DateTime1 = Mouse_DateTime - 500000;
      DateTime2 = Mouse_DateTime + 500000;
   }
   else if (Period() == PERIOD_D1) {
      DateTime1 = Mouse_DateTime - 1500000;
      DateTime2 = Mouse_DateTime + 1500000;
   }
   else if (Period() == PERIOD_W1) {
      DateTime1 = Mouse_DateTime - 5000000;
      DateTime2 = Mouse_DateTime + 5000000;
   }
   else if (Period() == PERIOD_MN1) {
      DateTime1 = Mouse_DateTime - 20000000;
      DateTime2 = Mouse_DateTime + 20000000;
   }
   else {
      DateTime1 = Mouse_DateTime - HR2400;
      DateTime2 = Mouse_DateTime + HR2400;
   }   
   
   double screen_height = ChartGetDouble(0,CHART_PRICE_MAX,0) - ChartGetDouble(0,CHART_PRICE_MIN,0);
   
   Price1 = Mouse_Price + screen_height * 0.0025;
   Price2 = Mouse_Price - screen_height * 0.0025;
   
   bool created = CreateRect(Name,DateTime1,Price1,DateTime2,Price2);
   if (!created) {
      Print(__FUNCTION__ + ": could not create rect level");
      return false;
   }
   
   ObjectSetInteger(0,Name,OBJPROP_SELECTABLE,true);
   return true;
}






bool CLevel::CreateRect(string name, datetime DateTime1, double Price1, datetime DateTime2, double Price2) {

   ResetLastError();
   if(!ObjectCreate(ChartID(),name,OBJ_RECTANGLE,0,DateTime1,Price1,DateTime2,Price2))
     {
      Print(__FUNCTION__,
            ": failed to create new rectangle '" + name + "'! Error code = ",GetLastError());
      return(false);
     }

   //Print("Level '" + name + "' is created");
   return true;

}


void CLevel::AutoColor(bool is_S_Version) {

   // if this level is made as rectangle - color it as rectangle
   if (ObjectTypeMQL4(Name) == OBJ_RECTANGLE) {
      CRectangle rect(Name);
      rect.AutoColor(is_S_Version);
   }
   else {
      string msg = "No special auto-coloring for non-rectangles";
      MessageOnChart(msg, MessageOnChartAppearTime);
      Print(msg);
   }
}



TradeDirectionType CLevel::GetTradeDirection() {

   if (Color() == clrRed) return Sell_Level;
   else if (Color() == clrGreen) return Buy_Level;
   else return None_Level;

}



short CLevel::GetClosestLevelIndexInArray(CLevel &array[]) {

   short array_size = (short)ArraySize(array);

   if ( array_size == 0 ) { 
      if (DebugMode) Print(__FUNCTION__ + ": array is empty. Returning -1");
      return -1;
   }

   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(_Symbol ,Latest_Price); // Assign current prices to structure 
   
   short closest_level_index = 0; // if no other levels will be found to be closer that the zero-level; the zero-level will remain the closest
   double dist_to_closest_level = MathAbs(Latest_Price.bid - array[0].Price()) / _Point;


   if ( array_size > 1) {
      for ( short i=1; i < ArraySize(Levels); i++ ) {
         if ( MathAbs(Latest_Price.bid - array[i].Price()) / _Point < dist_to_closest_level ) {
            dist_to_closest_level = MathAbs(Latest_Price.bid - array[i].Price()) / _Point;
            closest_level_index = i;
         }
      }
   }
   return closest_level_index;
}




void CLevel::DrawUpdateRoundLevelsD1() {


   // first we delete all existing round levels
   CLevel lvl();
   lvl.DeleteD1RoundLevels();

   if (Strategy != D1) return;
   if (_Symbol != "EURAUD" && _Symbol != "GBPAUD") return;
   if (_Period != PERIOD_H1) return;
   
   // now draw new levels
   
   
   // *** move this price and name forming functions to CLevel class ***
   // first we find opening price of the current day
   int day_shift = 0; // today
   MqlRates rate[];
   CopyRates(_Symbol,PERIOD_D1,day_shift,1,rate);
   //Print("Today's Opening Price is: ",rate[0].open);
   
   double TodayOpenPrice = rate[0].open;
   
   //1) Find third digit after comma in open price of the day
   string third_digit = StringSubstr(DoubleToString(TodayOpenPrice,5),4,1);
   int third_int = int(StringToInteger(third_digit));
   
   double RoundLevel_Minus1 = MathFloor(TodayOpenPrice*100) / 100; // trimming double value
   
   // if that digit is 5 or more we add 0.005 to the Minus1 level; all other levels will be calculated from this first level
   if (third_int >= 5) {
      RoundLevel_Minus1 = RoundLevel_Minus1 + 0.005;
   }
   
   double RoundLevel_Minus2 = RoundLevel_Minus1 - 0.005;
   double RoundLevel_Plus1 = RoundLevel_Minus1 + 0.005;
   double RoundLevel_Plus2 = RoundLevel_Plus1 + 0.005;
   // *** end of code to move ***


   // *** consider moving this entire function to CLevel
   ObjectCreate(0,lvl.RoundLevel_Minus1_Name,OBJ_HLINE,0,0,RoundLevel_Minus1);
   ObjectCreate(0,lvl.RoundLevel_Minus2_Name,OBJ_HLINE,0,0,RoundLevel_Minus2);
   ObjectCreate(0,lvl.RoundLevel_Plus1_Name,OBJ_HLINE,0,0,RoundLevel_Plus1);
   ObjectCreate(0,lvl.RoundLevel_Plus2_Name,OBJ_HLINE,0,0,RoundLevel_Plus2);
   
   ObjectSetInteger(0,lvl.RoundLevel_Minus1_Name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,lvl.RoundLevel_Minus2_Name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,lvl.RoundLevel_Plus1_Name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,lvl.RoundLevel_Plus2_Name,OBJPROP_SELECTABLE,false);
   
   // coloring levels
   color TradeLelevsColor; // only for +/-1 levels
   if (DayPriority == Buy) TradeLelevsColor = clrGreen;
   else if (DayPriority == Sell) TradeLelevsColor = clrRed;
   else TradeLelevsColor = clrGray;
   
   ObjectSetMQL4(lvl.RoundLevel_Minus1_Name,OBJPROP_COLOR, TradeLelevsColor);
   ObjectSetMQL4(lvl.RoundLevel_Minus2_Name,OBJPROP_COLOR, clrGray);
   ObjectSetMQL4(lvl.RoundLevel_Plus1_Name,OBJPROP_COLOR, TradeLelevsColor);
   ObjectSetMQL4(lvl.RoundLevel_Plus2_Name,OBJPROP_COLOR, clrGray);
   // coloring done
   
   ObjectSetMQL4(lvl.RoundLevel_Minus1_Name,OBJPROP_STYLE, STYLE_DOT);
   ObjectSetMQL4(lvl.RoundLevel_Minus2_Name,OBJPROP_STYLE, STYLE_DOT);
   ObjectSetMQL4(lvl.RoundLevel_Plus1_Name,OBJPROP_STYLE, STYLE_DOT);
   ObjectSetMQL4(lvl.RoundLevel_Plus2_Name,OBJPROP_STYLE, STYLE_DOT);
   
   ObjectSetInteger(0,lvl.RoundLevel_Minus1_Name,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1);
   ObjectSetInteger(0,lvl.RoundLevel_Minus2_Name,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1);
   ObjectSetInteger(0,lvl.RoundLevel_Plus1_Name,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1);
   ObjectSetInteger(0,lvl.RoundLevel_Plus2_Name,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1);
   
}