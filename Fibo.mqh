#include "GraphObject.mqh"

class CFibo : public CGraphObject {
   
public:
                     CFibo(string name) : CGraphObject(name){;}
                     CFibo()            : CGraphObject(){;}
                    ~CFibo();
   void              UpdateLevels();
   void              ExtendFibo();
   void              ResetLevelsToDefault();
   bool              Create(int mouse_x, int mouse_y); 
   void              AutoColor(); 
   void              CreateFibosForYesterday(TradeDir Direction = TradeDir_NONE);
   double            GetPriceOfFiboLevel(double FiboLevel);
   double            FiboRetracement(bool CheckbyClosePrice=false);
   int               RetracementStartBarIndex();
   void              DeleteLinkedFibo();
   string            FourStrings_BigFiboName(); 
   string            FourStrings_SmallFiboName();
   
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//CFibo::CFibo(string name) {
//   
//}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CFibo::~CFibo() {

   //Print("Fibo destructor");

}





bool CFibo::Create(int mouse_x,int mouse_y) {

   Name = "Fibo Created by MetaTools #" + IntegerToString(MathRand());

   // cursor coordinates
   datetime Mouse_DateTime;
   double   Mouse_Price;
   
   int fake_int;
   
   // coordinates of the new Fibo
   datetime DateTime1;
   datetime DateTime2;
   double   Price1;
   double   Price2;
   
   // cursor x, y -> cursor datetime and price
   ChartXYToTimePrice(ChartID(),mouse_x, mouse_y,fake_int,Mouse_DateTime,Mouse_Price);
   
   DateTime1 = Mouse_DateTime;
   
   // set width of the object depending on the current chart Period
   if (Period() == PERIOD_M1) {
      //DateTime1 = Mouse_DateTime - 3000;
      DateTime2 = Mouse_DateTime + 3000;
   }
   else if (Period() == PERIOD_M5) {
      //DateTime1 = Mouse_DateTime - 6000;
      DateTime2 = Mouse_DateTime + 6000;
   }
   else if (Period() == PERIOD_M15) {
      //DateTime1 = Mouse_DateTime - 20000;
      DateTime2 = Mouse_DateTime + 20000;
   }
   else if (Period() == PERIOD_M30) {
      //DateTime1 = Mouse_DateTime - 50000;
      DateTime2 = Mouse_DateTime + 50000;
   }
   else if (Period() == PERIOD_H1) {
      //DateTime1 = Mouse_DateTime - HR2400;
      //DateTime2 = Mouse_DateTime + HR2400;
      DateTime2 = Mouse_DateTime + 30000;
   }
   else if (Period() == PERIOD_H4) {
      //DateTime1 = Mouse_DateTime - 500000;
      DateTime2 = Mouse_DateTime + 500000;
   }
   else if (Period() == PERIOD_D1) {
      //DateTime1 = Mouse_DateTime - 1500000;
      DateTime2 = Mouse_DateTime + 1500000;
   }
   else if (Period() == PERIOD_W1) {
      //DateTime1 = Mouse_DateTime - 5000000;
      DateTime2 = Mouse_DateTime + 5000000;
   }
   else if (Period() == PERIOD_MN1) {
      //DateTime1 = Mouse_DateTime - 20000000;
      DateTime2 = Mouse_DateTime + 20000000;
   }
   else {
      //DateTime1 = Mouse_DateTime - HR2400;
      DateTime2 = Mouse_DateTime + HR2400;
   }   
   
   //double screen_height = ChartGetDouble(0,CHART_PRICE_MAX,0) - ChartGetDouble(0,CHART_PRICE_MIN,0);
   
   Price1 = Mouse_Price;
   Price2 = Price1;
   
   
   ResetLastError();
   if(!ObjectCreate(ChartID(),Name,OBJ_FIBO,0,DateTime1,Price1,DateTime2,Price2))
     {
      Print(__FUNCTION__,
            ": failed to create new Fibo '" + Name + "'! Error code = ",GetLastError());
      return(false);
     }
   
   AutoColor();
   ObjectSetInteger(0,Name,OBJPROP_RAY_RIGHT,false);
   ObjectSetMQL4(Name,OBJPROP_LEVELSTYLE,STYLE_DOT);

   Print("Fibo '" + Name + "' is created");
   return true;

}



void CFibo::AutoColor() {

   // Randomize color
   color clr;
   int num = 1 + 4*MathRand()/32768; // random number between 1-4
   if (num == 1) clr = clrGray;
   else if (num == 2) clr = clrDarkGoldenrod;
   else if (num == 3) clr = clrDeepSkyBlue;
   else if (num == 4) clr = clrLimeGreen;
   else if (num == 5) clr = clrDarkSalmon;
   else if (num == 6) clr = clrPlum;
   else if (num == 7) clr = clrYellowGreen;
   else clr = clrBlack;

   Color(clr);
   ObjectSetInteger(0,Name,OBJPROP_COLOR,clrLightPink);
   
   #ifdef __MQL5__
      ObjectSetInteger(0,Name,OBJPROP_LEVELCOLOR, clr);
   #endif 
}





void CFibo::UpdateLevels() {
   if(!IsVisibleOnTF(_Period)) return;

   double Retracement = FiboRetracement(false);
   double RetracementWithClose = FiboRetracement(true);

   string NewFiboName="FiboFromCode "+IntegerToString(MathRand());

   double values[8];
   ArrayInitialize(values,0);
   int levels = 0;
// array for value of each level
   if(Retracement>=0 && Retracement<30) 
     {
      values[0] = 0;
      values[1] = 0.236;
      values[2] = 0.382;
      values[3] = 0.5;
      values[4] = 0.618;
      values[5] = 1;
      values[6] = 1.618;
      levels=7;
     }
   else
   if(Retracement>=30 && Retracement<48) 
     {
      values[0] = 0;
      values[1] = 0.382;
      values[2] = 0.5;
      values[3] = 0.618;
      values[4] = 1;
      values[5] = 1.618;
      levels=6;
     }
   else
   if(Retracement>=48 && Retracement<60) 
     {
      values[0] = 0;
      values[1] = 0.5;
      values[2] = 0.618;
      values[3] = 1;
      values[4] = 1.618;
      levels=5;
     }
   else
   if(Retracement>=60 && Retracement<65) 
     {
      values[0] = 0;
      values[1] = 0.618;
      values[2] = 1;
      values[3] = 1.618;
      levels=4;
     }
   else
   if(Retracement>=65 && RetracementWithClose>=65) 
     {
      //Print("Too deep retracement - deleting the old Fibo, not creating the new one");
      //if (AutoDeleteBrokenFibos) 
      //   ObjectDeleteSilent(0,Name);
      //   return;
     }
   else
   if(Retracement>=65 && RetracementWithClose<65) 
     {
      values[0] = 0;
      values[1] = 0.618;
      values[2] = 1;
      values[3] = 1.618;
      levels=4;
     }

//if we reached up to here - creating the new Fibo
   datetime time1 = (datetime)ObjectGetMQL4(Name,OBJPROP_TIME1);
   datetime time2 = (datetime)ObjectGetMQL4(Name,OBJPROP_TIME2);
   ChartSetInteger(ChartID(),CHART_EVENT_OBJECT_CREATE,false); // disabling object-creation detection, so that main even processing (in main file) will not be triggered - that causes circular calls
   ObjectCreate(0,NewFiboName,OBJ_FIBO,0,time1,ObjectGetDouble(0,Name,OBJPROP_PRICE,0),time2,ObjectGetDouble(0,Name,OBJPROP_PRICE,1));
   ChartSetInteger(ChartID(),CHART_EVENT_OBJECT_CREATE,true);  // re-enabling object-creation detection
   ObjectSetMQL4(NewFiboName,OBJPROP_LEVELCOLOR,ObjectGetMQL4(Name,OBJPROP_LEVELCOLOR));
   ObjectSetInteger(0,NewFiboName,OBJPROP_RAY_RIGHT,false);
   ObjectSetMQL4(NewFiboName,OBJPROP_LEVELSTYLE,ObjectGetMQL4(Name,OBJPROP_LEVELSTYLE));
   ObjectSetMQL4(NewFiboName,OBJPROP_LEVELWIDTH,ObjectGetMQL4(Name,OBJPROP_LEVELWIDTH));
   ObjectSetMQL4(NewFiboName,OBJPROP_TIMEFRAMES,ObjectGetMQL4(Name,OBJPROP_TIMEFRAMES));
   ObjectSetInteger(0,NewFiboName,OBJPROP_SELECTABLE, true);

// setting up levels for the new Fibo         
   ObjectSetInteger(0,NewFiboName,OBJPROP_LEVELS,levels);
   for(int i=0;i<levels;i++) 
     {
      ObjectSetDouble(0,NewFiboName,OBJPROP_LEVELVALUE,i,values[i]);
      ObjectSetString(0,NewFiboName,OBJPROP_LEVELTEXT,i,DoubleToString(100*values[i],1));
     }


   if(ObjectGetMQL4(Name,OBJPROP_SELECTED))
      ObjectSetMQL4(NewFiboName,OBJPROP_SELECTED,1);
   else
      ObjectSetMQL4(NewFiboName,OBJPROP_SELECTED,0);

   UpdateToolTip();

//Print("Deleting the old Fibo ", OldFiboName);
   ObjectDeleteSilent(0,Name);
   Name = NewFiboName;
}






double CFibo::FiboRetracement(bool CheckbyClosePrice=false) {
   // returns achieved retracement by the price of this fibo

   if (ArraySize(High) == 0 || ArraySize(Low) == 0) return 0;

   double Price1 = Price1();
   double Price2 = Price2();
   double maxRetracementPrice;
//if (Price1>Price2)  // downwards fibo
   maxRetracementPrice=Price2;
//else // upwards fibo
//   maxRetracementPrice = Price2;

   int a = RetracementStartBarIndex();
   if (a < 0) return 0;

   for(int i = a; i>=0; i--)  { // cycle for each bar after retracement starts
      if(Price1>Price2) {  // downwards fibo\\
         if(CheckbyClosePrice) {
            if(Close[i]>maxRetracementPrice)  {
               maxRetracementPrice=Close[i];
              }
           }
         else  {
            //Print("i 1 = ", i, " ArraySize(High) = ", ArraySize(High));
            if(High[i]>maxRetracementPrice) maxRetracementPrice=High[i];
         }
      }
      else   {// upwards fibo
         if(CheckbyClosePrice)  {
            if(Close[i]<maxRetracementPrice) 
               maxRetracementPrice=Close[i];
            }
         else  {
            //Print("i 2 = ", i, " ArraySize(Low) = ", ArraySize(Low));
            if(Low[i]<maxRetracementPrice) {
               maxRetracementPrice=Low[i];
            }
         }
      }
   } // for

//maxRetracementPrice
   double FiboHeight=MathAbs(NormalizeDouble(Price2-Price1,_Digits)/_Point);
   if (FiboHeight == 0) return 0; // to avoid divide by zero below

   double RetracementPips=MathAbs(NormalizeDouble(Price2-maxRetracementPrice,_Digits)/_Point);
//Print("maxRetracementPrice = ", maxRetracementPrice);
//Print("Retracement in pips = ", RetracementPips);
//Print("Height of " + objectName + " = " + FiboHeight);
   double RetracementPerCent=RetracementPips/FiboHeight*100;
   return RetracementPerCent;
//Print("Retracement = ", DoubleToStr(RetracementPerCent,1), "%");
}






void CFibo::ExtendFibo() {
   m_Price1 = this.Price1();
   m_Price2 = this.Price2();
   if (m_Price1 == m_Price2) return;
   
   m_DateTime1 = this.DateTime1();

   //datetime time1 = (datetime)ObjectGetMQL4(Name,OBJPROP_TIME1);
   int StartingBar=iBarShift(_Symbol,_Period,m_DateTime1,false);
   if(StartingBar>Bars(_Symbol,_Period)) 
     {
      Print("First point is further than available bars. Load more history. Not calculating if line is broken.");
      return;
     }
   //Print("Checking from starting bar # ", StartingBar);
   double new_Price2 = m_Price2;
   
   
   #ifdef __MQL5__
      InitHighLowOpenCloseArrays(StartingBar); // initialize Open, Close, High, Low arrays for MQL5
   #endif 
   
   // downwards fibo
   if(m_Price1 > m_Price2) {
      for(int i=StartingBar-1; i>=0; i--) { // checking all the bars till the end
         if(iLow(_Symbol,_Period,i) < new_Price2) {
            new_Price2 = iLow(_Symbol,_Period,i);
         }
      } 
   }
   else { // upwards fibo
      for(int i=StartingBar-1; i>=0; i--) { // checking all the bars till the end
         if(iHigh(_Symbol,_Period,i) > new_Price2) {
            new_Price2 = iHigh(_Symbol,_Period,i);
         }
      }   
   }
   
   this.Price2(new_Price2);  
   ChartRedraw();
}


int CFibo::RetracementStartBarIndex() {

   if(ArraySize(Low) == 0 || ArraySize(High) == 0) return 0;

   double Price1 = Price1();
   double Price2 = Price2();

   datetime Time1= DateTime1();
   int Bar1=iBarShift(Symbol(),Period(),Time1,false);

   #ifdef __MQL5__
      InitHighLowOpenCloseArrays(Bar1); // initialize Open, Close, High, Low arrays for MQL5
   #endif 

   if (ArraySize(Low) < Bar1) return 0;

   for(int i=Bar1; i>=0; i--)  {
      
      if(Price1>Price2) {// downwards fibo
         if(Low[i] == Price2) return i-1;
        }
      else {         // upward fibo
         if(High[i] == Price2) return i-1;
        }
     }
   return 0;
  }


void CFibo::ResetLevelsToDefault() {
   //Print("Creating a new fibo...");
   datetime time1  = DateTime1();
   datetime time2  = DateTime2();
   double   price1 = Price1();
   double   price2 = Price2();
   string NewFiboName = "FiboFromCode " + IntegerToString(MathRand());
   
   // 1) Create new fibo and copy properties of the old one
   ObjectCreate(0,NewFiboName,OBJ_FIBO,0,time1,price1,time2,price2);
   
   
   ObjectSetMQL4(NewFiboName,OBJPROP_LEVELCOLOR,ObjectGetMQL4(Name,OBJPROP_LEVELCOLOR));
   ObjectSetInteger(0,NewFiboName,OBJPROP_RAY_RIGHT,false);
   ObjectSetMQL4(NewFiboName,OBJPROP_LEVELSTYLE,ObjectGetMQL4(Name,OBJPROP_LEVELSTYLE));
   ObjectSetMQL4(NewFiboName, OBJPROP_LEVELWIDTH,ObjectGetMQL4(Name,OBJPROP_LEVELWIDTH));
   ObjectSetMQL4(NewFiboName, OBJPROP_SELECTED, 1);
   
   // 2) Delete the old one
   ObjectDeleteSilent(0,Name);
}




void CFibo::CreateFibosForYesterday(TradeDir Direction = TradeDir_NONE) {
   // Special function for "Four Strings" Strategy

   if (Direction == TradeDir_NONE) {
      Print(__FUNCTION__ + ": Error - Direction = TradeDir_NONE");
      return;
   }
   
   
   double   Price1;
   double   Price2; 
   datetime DateTime1;
   datetime DateTime2;
   // find index of lowest and highest bars within yesterday
   int LastH1BarOfYesterday_Index = iBarShift(Symbol(),PERIOD_H1,iTime(Symbol(), PERIOD_D1, 0) + 1);
   int H1_Low_bar_index  = iLowest (Symbol(),PERIOD_H1,MODE_LOW, 23,LastH1BarOfYesterday_Index);
   int H1_High_bar_index = iHighest(Symbol(),PERIOD_H1,MODE_HIGH,23,LastH1BarOfYesterday_Index);
   
   
   if (Direction == TradeDir_BUY) {
      Price1 = iLow(Symbol(),PERIOD_D1,1);
      Price2 = iHigh(Symbol(),PERIOD_D1,1);
      DateTime1 = iTime(Symbol(),PERIOD_H1,H1_Low_bar_index);
      DateTime2 = iTime(Symbol(),PERIOD_H1,H1_Low_bar_index - 5);
   }
   else {
      Price1 = iHigh(Symbol(),PERIOD_D1,1);
      Price2 = iLow(Symbol(),PERIOD_D1,1);
      DateTime1 = iTime(Symbol(),PERIOD_H1,H1_High_bar_index);
      DateTime2 = iTime(Symbol(),PERIOD_H1,H1_High_bar_index - 5);
   }
   
   
   
   ResetLastError();
   if(!ObjectCreate(ChartID(),Name,OBJ_FIBO,0,DateTime1,Price1,DateTime2,Price2))
     {
      Print(__FUNCTION__,
            ": failed to create new Big Fibo '" + Name + "'! Error code = ",GetLastError());
      return;
     }
   
   Color(clrGray);
   ObjectSetInteger(0,Name,OBJPROP_RAY_RIGHT,false);
   ObjectSetMQL4(Name,OBJPROP_LEVELSTYLE,STYLE_DOT);
   ObjectSetInteger(0,Name,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1);
   double big_values[6];
   int big_levels = 6;
   big_values[0] = 1;
   big_values[1] = 0.618;
   big_values[2] = 0.5;
   big_values[3] = 0.382;
   big_values[4] = 0.236;
   big_values[5] = 0;
   ObjectSetInteger(0,Name,OBJPROP_LEVELS,big_levels);
   for(int i=0;i<big_levels;i++) {
      ObjectSetDouble(0,Name,OBJPROP_LEVELVALUE,i,big_values[i]);
      ObjectSetString(0,Name,OBJPROP_LEVELTEXT,i,DoubleToString(100*big_values[i],1));
   }
   // Big Fibo Created
   
   
   
   // Check distance between 61.8 and 100% of Big Fibo
   double dist_btw_618_and_100 = MathAbs(GetPriceOfFiboLevel(61.8) - GetPriceOfFiboLevel(100)) / _Point;
   if (dist_btw_618_and_100 < MinDistBigFibo618_100_ForSL_pp) {
      string txt_label_name = "FourStrings Dist Label for " + TimeToString(TimeCurrent(),TIME_DATE);
      datetime date_coord = iTime(Symbol(),PERIOD_D1,0)+60*60*12;
      double price_coord;
      ObjectDeleteSilent(txt_label_name);
      if (Direction == TradeDir_BUY) 
         price_coord = GetPriceOfFiboLevel(61.8);
      else // sell case
         price_coord = GetPriceOfFiboLevel(100);
         
      ObjectCreate(ChartID(),txt_label_name,OBJ_TEXT,0,date_coord,price_coord);
      ObjectSetString(ChartID(),txt_label_name,OBJPROP_TEXT,"61.8 - 100% < " + DoubleToString(MinDistBigFibo618_100_ForSL_pp/10,0) + "pp");
      ObjectSetInteger(ChartID(),txt_label_name,OBJPROP_FONTSIZE,8);
      ObjectSetInteger(ChartID(),txt_label_name,OBJPROP_COLOR,clrGray);
      ObjectSetInteger(0,txt_label_name,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1);
      // no need to create small fibo - but we still create it
      //return;
   }
   
   
   
   
   
   // Creating Small Fibo for SL
   string SmallFiboName = "SmallFibo " + TimeToString(TimeCurrent(),TIME_DATE); //"yyyy.mm.dd" - unique name for fibo for today
   CFibo SmallFibo(SmallFiboName);
   SmallFibo.Delete();
   // Price 1 remains from large fibo
   Price2 = GetPriceOfFiboLevel(61.8);
   DateTime1 = iTime(Symbol(),PERIOD_D1,0);
   DateTime2 = iTime(Symbol(),PERIOD_D1,0)+120*60;
   ResetLastError();
   if(!ObjectCreate(ChartID(),SmallFiboName,OBJ_FIBO,0,DateTime1,Price1,DateTime2,Price2)) {
      Print(__FUNCTION__,
            ": failed to create new Small Fibo '" + SmallFiboName + "'! Error code = ",GetLastError());
      return;
     }
   
   SmallFibo.Color(clrGray);
   ObjectSetInteger(0,SmallFiboName,OBJPROP_RAY_RIGHT,false);
   ObjectSetMQL4(SmallFiboName,OBJPROP_LEVELSTYLE,STYLE_DOT);
   ObjectSetInteger(0,SmallFiboName,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1);
   double values[3];
   int levels = 0;
   values[0] = 0.618;
   levels = 1;
   ObjectSetInteger(0,SmallFiboName,OBJPROP_LEVELS,levels);
   for(int i=0;i<levels;i++) {
      ObjectSetDouble(0,SmallFiboName,OBJPROP_LEVELVALUE,i,values[i]);
      ObjectSetString(0,SmallFiboName,OBJPROP_LEVELTEXT,i,DoubleToString(100*values[i],1));
   }
   // SMALL FIBO CREATED
}




double CFibo::GetPriceOfFiboLevel(double FiboLevel) {

   if (FiboLevel == 0) return Price2();
   
   string direction;
   if (Price1() < Price2())
      direction = "up";
   else if (Price1() > Price2())
      direction = "down";
   else
      return -1;
   
   double diff = MathAbs(Price1() - Price2());
   
   if (direction == "up") {
      return Price2() - diff * FiboLevel/100;
   }
   else {
      return Price2() + diff * FiboLevel/100;
   }
   
}



void CFibo::DeleteLinkedFibo(void) {
   //Print(__FUNCTION__);

   if (StringFind(Name,"BigFibo") != -1) {
      // delete linked SmallFibo
      string SmallFiboName = "SmallFibo " + StringSubstr(Name,8);
      // Print("Deleting also linked small fibo '" + SmallFiboName + "'");
      ObjectDeleteSilent(SmallFiboName);
   }
   
   //"BigFibo 2021.01.17"
   
   if (StringFind(Name,"SmallFibo") != -1) {
      // delete linked BigFibo
      string BigFiboName = "BigFibo " + StringSubstr(Name,10);
      //SmallFibo 2021.01.17
      // Print("Deleting also linked big fibo '" + BigFiboName + "'");
      ObjectDeleteSilent(BigFiboName);
   }

}




string CFibo::FourStrings_BigFiboName() {
   string date_time;
   datetime empty_datetime = D'1970.01.01 00:00';
   if ( Price1() > empty_datetime ) date_time = TimeToString(DateTime1(), TIME_DATE);
   else date_time = TimeToString(TimeCurrent(),TIME_DATE);
   return "BigFibo " + date_time;
}




string CFibo::FourStrings_SmallFiboName() {
   string date_time;
   datetime empty_datetime = D'1970.01.01 00:00';
   if ( Price1() > empty_datetime ) date_time = TimeToString(DateTime1(), TIME_DATE);
   else date_time = TimeToString(TimeCurrent(),TIME_DATE);
   return "SmallFibo " + date_time;
}




