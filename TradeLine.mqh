#include "GraphObject.mqh"

class CTradeLine : public CGraphObject
  {
public:
                     //CTradeLine(string name) : CGraphObject(name){;}
                     CTradeLine(string name);
                     CTradeLine();
                    ~CTradeLine();
          void       AlignEntryLine();
          void       AlignSLLine(DayPriorityID day_priority);
          void       AlignTPLine();
   static string     AutoSLMarkName;
   static void       Delete_AutoSLMark();
          void       TPLineToOtherSideIfRequired();
          void       TPtoSL_Ratio_Keep();
//          double     SLTP_Multiplier();
          bool       CreateBreakEvenLine(ulong ticket);
          bool       CreateBackwardsBreakLine(ulong ticket);
          void       UpdateBreakEvenLine(ulong ticket);
          void       UpdateBackwardsBreakLine();
          void       BreakEvenLineSet(int BE_PP, int BE_Percent);
          void       BackwardsBreakLineSet();
          void       BreakEvenLineEdit();
          void       BackwardsBreakLineEdit();
          void       Price(double new_price);
          double     Price();
                    
private:
          string     m_BELineName;
          double     GetBreakEvenPrice(ulong ticket);
          
          color      m_BreakEvenLineSetColor;
          color      m_BreakEvenLineEditColor;
          
          color      m_BackwardsBreakLineSetColor;
          color      m_BackwardsBreakLineEditColor;
          bool       CreateAutoSLMark(short D1_bar_index, double price); // to mark for user which high or low is used for auto-SL calculation
  };


string CTradeLine::AutoSLMarkName = "AutoSLMark";

static void CTradeLine::Delete_AutoSLMark(void) {

   ObjectDeleteSilent(AutoSLMarkName);

}


CTradeLine::CTradeLine(void) {


}


CTradeLine::CTradeLine(string name) : CGraphObject(name) {

   this.Name = name;

   m_BreakEvenLineSetColor  = clrSilver;
   m_BreakEvenLineEditColor = clrGreen;
   
   m_BackwardsBreakLineSetColor = clrPink;
   m_BackwardsBreakLineEditColor = clrMagenta;
   //Print(__FUNCTION__ + ": ",name," is initialized!");

}



void CTradeLine::Price(double new_price) {
   this.Price1(new_price);
}


double CTradeLine::Price() {

   return this.Price1();

}




CTradeLine::~CTradeLine(){
   //Print("CTrend destructor");
}



void CTradeLine::AlignEntryLine(void) {
   // assuming current instance is Entry Line

   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(Symbol() ,Latest_Price); // Assign current prices to structure 

   // dist btw current price and current position of Entry Line (as remained from the last time)
   double distance = MathAbs((this.Price1() - Latest_Price.bid) / _Point)/10; 

   if (distance > ATR14/2) this.Price1(Latest_Price.bid);
   
   // if there are trade levels (red or green) nearby - align entry line closer to that level
   if ( ArraySize(Levels) > 0 ) {
      short cli = CLevel::GetClosestLevelIndexInArray(Levels); // closest level index
      if (cli != -1) { // levels exist and closest one is detected
         TradeDirectionType trade_dir = Levels[cli].GetTradeDirection();
         
         double Dist_to_CL = DistFromCurrentPriceToLevel(trade_dir, Levels[cli].Price()); // distance to closest level in points

         //Print("Dist_to_CL = " + Dist_to_CL);
         //Print("ATR14 = " + ATR14);
         //Print("5% of ATR14 = " + ATR14*0.05);
                  
         if ( Dist_to_CL <= ATR14/2 ) { // distance btw price and level is close enough
            
            // additionally - depends on it is buy or sell; is price over level or under level; and how far from the level - adjusting entry line
            if ( trade_dir == Sell_Level) {
               
               if (Strategy == Stratezhka) {
                  if ( Dist_to_CL < ATR14*0.05 ) { // if dist to closest level is less than 2 x spreads
                     if (!EventChartCustom(ChartID(),PSC_SET_ENTRY_TYPE_INSTANT,0,0,"")) Print("Couldn't send custom event 'PSC_SET_ENTRY_TYPE_INSTANT'");
                  }
                  else {
                     // switching to Pending mode
                     // setting Entry Line Directly on the level minus spread
                     if (!EventChartCustom(ChartID(),PSC_SET_ENTRY_TYPE_PENDING,0,0,"")) Print("Couldn't send custom event 'PSC_SET_ENTRY_TYPE_PENDING'");
                     this.Price(Levels[cli].Price() - (Ask-Bid) );
                  }
               }
               else { // for all other strategies...
                  // SELL SITUATION WITH RED LEVEL NEARBY
                  if ( Latest_Price.bid > Levels[cli].Price() || Dist_to_CL <= ATR14/10 ) {
                     // Price is above the level (we have pull-back) OR price is below level, but very close
                     // THEN: switch to instant market entry
                     this.Price(Latest_Price.bid);
                     if (!EventChartCustom(ChartID(),PSC_SET_ENTRY_TYPE_INSTANT,0,0,"")) Print("Couldn't send custom event 'PSC_SET_ENTRY_TYPE_INSTANT'");
                  }
                  else {
                     // distance is farther than ATR14/10
                     if (!EventChartCustom(ChartID(),PSC_SET_ENTRY_TYPE_PENDING,0,0,"")) Print("Couldn't send custom event 'PSC_SET_ENTRY_TYPE_PENDING'");
                     this.Price1( (Latest_Price.bid + Levels[cli].Price()) / 2 );
                  }
               }
            }
            else {
               if (Strategy == Stratezhka) {
                  if ( Dist_to_CL < ATR14*0.05 ) { // if dist to closest level is less than 2 x spreads
                     if (!EventChartCustom(ChartID(),PSC_SET_ENTRY_TYPE_INSTANT,0,0,"")) Print("Couldn't send custom event 'PSC_SET_ENTRY_TYPE_INSTANT'");
                  }
                  else {
                     // switching to Pending mode
                     // setting Entry Line Directly on the level plus spread
                     if (!EventChartCustom(ChartID(),PSC_SET_ENTRY_TYPE_PENDING,0,0,"")) Print("Couldn't send custom event 'PSC_SET_ENTRY_TYPE_PENDING'");
                     this.Price(Levels[cli].Price() + (Ask-Bid) );
                  }
               }
               else { // for all other strategies...
                  // BUY SITUATION WITH GREEN LEVEL NEARBY
                  if ( Latest_Price.bid < Levels[cli].Price() || Dist_to_CL <= ATR14/10 ) {
                     // Price is below the level (we have pull-back) OR price is above level, but very close
                     // THEN: switch to instant market entry
                     this.Price(Latest_Price.ask);
                     if (!EventChartCustom(ChartID(),PSC_SET_ENTRY_TYPE_INSTANT,0,0,"")) Print(__FUNCTION__ + ": Couldn't send custom event 'PSC_SET_ENTRY_TYPE_INSTANT'");
                  }
                  else {
                     // distance is farther than ATR14/10
                     if (!EventChartCustom(ChartID(),PSC_SET_ENTRY_TYPE_PENDING,0,0,"")) Print(__FUNCTION__ + ": Couldn't send custom event 'PSC_SET_ENTRY_TYPE_PENDING'");
                     this.Price1( (Latest_Price.bid + Levels[cli].Price()) / 2 );
                  }
               }
            }
            
         }
         else {
            // Distance to closest level > ATR14/2
            // do nothing
         }
      }
   }
}
  
void CTradeLine::AlignSLLine(DayPriorityID day_priority) {
   // assuming current instance is SL Line



   if ( Strategy == Stratezhka ) {
      // complete own rules for Stratezhka

      double low  = iLow(_Symbol,PERIOD_H1,0);
      double high = iHigh(_Symbol,PERIOD_H1,0);
      double mid  = high - (high - low)/2;
      //Print("low = ", low);
      //Print("high = ", high);
      //Print("mid = ", mid);
      //Print("high - low = ", high - low);
      double prev_low  = iLow(_Symbol,PERIOD_H1,1);
      double prev_high = iHigh(_Symbol,PERIOD_H1,1);
      double sl_price;
      double spread = Ask-Bid;
      
      int ClosestLevelIndex = CLevel::GetClosestLevelIndexInArray(Levels);
      if (ClosestLevelIndex == -1) {
         sl_price = Bid;
         return;
      }
      double ClosestLevelPrice = Levels[ClosestLevelIndex].Price();
      TradeDirectionType trade_dir = Levels[ClosestLevelIndex].GetTradeDirection();
      
      if ( trade_dir == Buy_Level ) {
         if ( high <= ClosestLevelPrice)  // current candle didn't yet brake the level
            sl_price = high - spread;
         else {
            if ( mid > ClosestLevelPrice )  // more than half of bar is below the level
               sl_price = prev_low - spread;
            else
               sl_price = low - spread;
         }            
      }
      else { // sell level
         if ( low >= ClosestLevelPrice) // current candle didn't yet brake the level
            sl_price = high + spread*1.5;
         else {
            if ( mid < ClosestLevelPrice )  // more than half of bar is below the level
               sl_price = prev_high + spread*1.5;
            else
               sl_price = high + spread*1.5;
         }
      }
      
      this.Price1(sl_price);
      return;
   }
   


   CTradeLine entry(EntryLineName);
   double distance = MathAbs((this.Price1() - entry.Price1()) / _Point)/10; // distance from the current SL line until the entry line
   
   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(_Symbol ,Latest_Price); // Assign current prices to structure
   
   //Print("distance = ", distance);
   
   //if (Symbol() == "XAUUSD") distance = distance * 10;
   
   //Print("distance = ", distance);
   if (distance > 50 || distance < 10) { // case when SL is out of normal distance - we align it IAW day priority
   
      double multiplier = 10;
      if (Symbol() == "XAUUSD") multiplier = 1;
      else if (Symbol() == "BRN") multiplier = 2;
      else if (Symbol() == "BRENT") multiplier = 2;
      else if (Symbol() == "WTI") multiplier = 2;
      else if (Symbol() == "NQ100") multiplier = 1.5;
      else if (Symbol() == "SPX500") multiplier = 1.5;
      else if (Symbol() == "ETHBTC") multiplier = 100;
      
      //Print("_Point = ", _Point);
      
      if (day_priority == Sell) {
         Print(1);
         this.Price1(entry.Price1() + ATR14/2.5*multiplier*_Point);
      }
      else { // priority is none or buy then
         Print(2);
         this.Price1(entry.Price1() - ATR14/2.5*multiplier*_Point);
      }
   }
   
   // adjusting SL to be behind latest extremum
   double spread = (Latest_Price.ask-Latest_Price.bid) / _Point;
   
   if (day_priority == Sell) {
      // evaluating today's maximum
      double H1 = iHigh(Symbol(),PERIOD_D1,0) + 1.1*spread * _Point;
      double dist = MathAbs( H1 - entry.Price() ) / _Point / 10;
      
      //Print("H1 = " + H1);
      //Print("entry.Price() = " + entry.Price());
      
      //Print(__FUNCTION__ + ": dist to H1 = " + DoubleToString(dist,2) + " | " + DoubleToString(dist/ATR14*100,1) + "% of ATR14 = " + DoubleToString(ATR14,1));
      
      if ( dist >= 0.25*ATR14 && dist <= 0.4*ATR14 ) {
         Print("Setting SL to H1");
         this.Price(H1);
         this.CreateAutoSLMark(0,iHigh(Symbol(),PERIOD_D1,0));
      }
      else {
         // evaluating yesterday's maximum
         double H2 = iHigh(Symbol(),PERIOD_D1,1) + 1.1*spread * _Point;
         dist = MathAbs( H2 - entry.Price() ) / _Point / 10;
         //Print(__FUNCTION__ + ": dist to H2 = " + DoubleToString(dist,2) + " | " + DoubleToString(dist/ATR14*100,1) + "% of ATR14 = " + DoubleToString(ATR14,1));
         if ( dist >= 0.25*ATR14 && dist <= 0.4*ATR14 ) {
            Print("Setting SL to H2");
            this.Price(H2);
            this.CreateAutoSLMark(1,iHigh(Symbol(),PERIOD_D1,1));
         }
         else {
            // evaluating day-before-yesterday's maximum
            double H3 = iHigh(Symbol(),PERIOD_D1,2) + 1.1*spread * _Point;
            dist = MathAbs( H3 - entry.Price() ) / _Point / 10;
            //Print(__FUNCTION__ + ": dist to H3 = " + DoubleToString(dist,2) + " | " + DoubleToString(dist/ATR14*100,1) + "% of ATR14 = " + DoubleToString(ATR14,1));
            if ( dist >= 0.25*ATR14 && dist <= 0.4*ATR14 ) {
               Print("Setting SL to H3");
               this.Price(H3);
               this.CreateAutoSLMark(2,iHigh(Symbol(),PERIOD_D1,2));
            }
            else { // good place for SL is not found - just setting it on distance of 30% from ATR14
               Print("No better place for SL found automatically - setting it to 30% from ATR14");
               this.Price1(entry.Price() + ATR14*0.3 * _Point*10);
            }
         }
      }
   }
   else { // priority is none or buy 
      // evaluating today's minimum
      double H1 = iLow(Symbol(),PERIOD_D1,0) - spread * _Point;
      double dist = MathAbs( H1 - entry.Price() ) / _Point / 10;
      
      //Print("dist to H1 = " + DoubleToString(dist,2) + " | " + DoubleToString(dist/ATR14*100,1) + "% of ATR14 = " + DoubleToString(ATR14,1));
      
      if ( dist >= 0.25*ATR14 && dist <= 0.4*ATR14 ) {
         Print("Setting SL to H1");
         this.Price(H1);
         this.CreateAutoSLMark(0,iLow(Symbol(),PERIOD_D1,0));
      }
      else {
         // evaluating yesterday's maximum
         double H2 = iLow(Symbol(),PERIOD_D1,1) - spread * _Point;
         dist = MathAbs( H2 - entry.Price() ) / _Point / 10;
         //Print("dist to H2 = " + DoubleToString(dist,2) + " | " + DoubleToString(dist/ATR14*100,1) + "% of ATR14 = " + DoubleToString(ATR14,1));
         if ( dist >= 0.25*ATR14 && dist <= 0.4*ATR14 ) {
            Print("Setting SL to H2");
            this.Price(H2);
            this.CreateAutoSLMark(1,iLow(Symbol(),PERIOD_D1,1));
         }
         else {
            // evaluating day-before-yesterday's maximum
            double H3 = iLow(Symbol(),PERIOD_D1,2) - spread * _Point;
            dist = MathAbs( H3 - entry.Price() ) / _Point / 10;
            //Print("dist to H3 = " + DoubleToString(dist,2) + " | " + DoubleToString(dist/ATR14*100,1) + "% of ATR14 = " + DoubleToString(ATR14,1));
            if ( dist >= 0.25*ATR14 && dist <= 0.4*ATR14 ) {
               Print("Setting SL to H3");
               this.Price(H3);
               this.CreateAutoSLMark(2,iLow(Symbol(),PERIOD_D1,2));
            }
            else { // good place for SL is not found - just setting it on distance of 30% from ATR14
               Print("No better place for SL found automatically - setting it to 30% from ATR14");
               this.Price(entry.Price() - ATR14*0.3 * _Point*10);
            }
         }
      }
   }   
   
   // ********* Additional Checks *******************************************************
   // what is now SL is lower than Entry? (for Sell situation as example?) - checking it
   //Print("this.Price() = " + this.Price() + "  |  entry.Price() = " + entry.Price());
   //Print("SL Price: " + ObjectGetDouble(0,StopLossLineName,OBJPROP_PRICE) );
   //Print("Entry Price: " + ObjectGetDouble(0,EntryLineName,OBJPROP_PRICE) );
   //Print("day_priority = " + EnumToString(day_priority));
   if (day_priority == Sell) {
      if ( this.Price() <= entry.Price() ) {
         Print("Entry is higher than calculated SL - setting SL to 30% from ATR14 above Entry; switching to Pending mode");
         CTradeLine::Delete_AutoSLMark();
         if (!EventChartCustom(ChartID(),PSC_SET_ENTRY_TYPE_PENDING,0,0,"")) Print("Couldn't send custom event 'PSC_SET_ENTRY_TYPE_PENDING'");
         this.Price(entry.Price() + ATR14*0.3 * _Point*10);
      }
   }
   else { // priority is none or buy 
      if ( this.Price() >= entry.Price() ) {
         Print("Entry is lower than calculated SL - setting SL to 30% from ATR14 below Entry; switching to Pending mode");
         CTradeLine::Delete_AutoSLMark();
         if (!EventChartCustom(ChartID(),PSC_SET_ENTRY_TYPE_PENDING,0,0,"")) Print("Couldn't send custom event 'PSC_SET_ENTRY_TYPE_PENDING'");
         this.Price(entry.Price() - ATR14*0.3 * _Point*10);
      }
   }
   //*************************************************************************************
}




bool CTradeLine::CreateAutoSLMark(short D1_bar_index, double price) {

   // marks high or low, which is used for setting up the SL
   // the mark is a small rectangle attached to the selected high / low

   // is this max or min that we're going to mark? 
   bool max = false;
   if (iHigh(Symbol(),PERIOD_D1,D1_bar_index) == price) max = true;
   

   //Print("max = " + (string)max);
   
   // find H1 bar which corresponds to this max or min
   // time of the first H1 bar
   datetime first_h1_bar_time = iTime(Symbol(),PERIOD_D1,D1_bar_index);
   datetime last_h1_bar_time;
   if (D1_bar_index == 0) // if D1 bar is current day
      last_h1_bar_time = iTime(Symbol(),PERIOD_H1,0); 
   else // D1 bar is not current day
      last_h1_bar_time = iTime(Symbol(),PERIOD_D1,D1_bar_index - 1) - 60*60; // then it is H1 bar of the next day minus 1 hour

   //Print("first_h1_bar_time = " + (string)first_h1_bar_time);
   //Print("last_h1_bar_time = " + (string)last_h1_bar_time);
   
   short first_h1_bar_index = (short)iBarShift(Symbol(),PERIOD_H1,first_h1_bar_time);
   short last_h1_bar_index  = (short)iBarShift(Symbol(),PERIOD_H1,last_h1_bar_time);

   short  H1_extremum_bar_index = - 1;
   double H1_extremum_bar_price;

   // find that H1 bar which has extremum value (high or low)
   if (max) {
      // going via highs
      H1_extremum_bar_price = iLow(Symbol(),PERIOD_D1,D1_bar_index); // setting initial value
      for (short i = first_h1_bar_index; i >= last_h1_bar_index; i--) {
         if ( iHigh(Symbol(),PERIOD_H1,i) >= H1_extremum_bar_price) { 
            H1_extremum_bar_price = iHigh(Symbol(),PERIOD_H1,i);
            H1_extremum_bar_index = i;
         }
      }
   }
   else {
      // going via lows
      H1_extremum_bar_price = iHigh(Symbol(),PERIOD_D1,D1_bar_index); // setting initial value
      for (short i = first_h1_bar_index; i >= last_h1_bar_index; i--) {
         if ( iLow(Symbol(),PERIOD_H1,i) <= H1_extremum_bar_price) {
            H1_extremum_bar_price = iLow(Symbol(),PERIOD_H1,i);
            H1_extremum_bar_index = i;
         }
      }
   }
   // ************************************************************************************************************************
   
   if ( H1_extremum_bar_index == -1 ) {
      Print(__FUNCTION__ + ": Error! Could not find H1 bar with extremum of " + DoubleToString(price,5));
      return false;
   }
   
   //Print("H1_extremum_bar_index = " + IntegerToString(H1_extremum_bar_index) + "; H1_extremum_bar_price = " + DoubleToString(H1_extremum_bar_price,5));
   
   // extremum H1 bar is found;

   ObjectDeleteSilent(AutoSLMarkName);
   
   
   datetime time1 = iTime(Symbol(),PERIOD_H1,H1_extremum_bar_index) - 60*120;
   datetime time2 = iTime(Symbol(),PERIOD_H1,H1_extremum_bar_index) + 60*120;
   
   CTrend sl_mark(AutoSLMarkName);
   ObjectCreate(ChartID(),sl_mark.Name,OBJ_TREND,0,time1,price,time2,price);
   sl_mark.Color(clrRed);
   sl_mark.Thickness(1);
   sl_mark.Ray(false);
   sl_mark.SetText("SL Reference Mark");
   return true;

}







void CTradeLine::AlignTPLine(void) {
   // assuming current instance is TP Line
   //Print("Aliging TP line");
   
   
   CTradeLine entry(EntryLineName);
   CTradeLine sl(StopLossLineName);
   
   //Print("sl.Price1() = ", sl.Price1());
   //Print("entry.Price1() = ", entry.Price1());
   double SL = MathAbs(sl.Price1() - entry.Price1()) / _Point; 
   double tp_price = this.Price1();
   double sl_price = sl.Price1();
   double el_price = entry.Price1();

   // нужно научиться брать умножитель для TP из Position Size Calculator
   //Trying to read TP multiplier value from the PSC "Take profit x " button
   //string TakeProfitX_ButtonName = FindEditObjectByPostfix("m_BtnTakeProfit");
   //string TakeProfitButtonText = ObjectGetString(0, TakeProfitX_ButtonName, OBJPROP_TEXT);  // NOT WORKING!
   //Print("TakeProfitButtonText = ", TakeProfitButtonText); 

   double max = ChartGetDouble(0,CHART_PRICE_MAX,0);
   double min = ChartGetDouble(0,CHART_PRICE_MIN,0);
   
   if (sl_price < el_price) { // buy setup
      if (tp_price > max || tp_price < min) {
         this.Price1(el_price + 2 * SL * _Point);
      }
   }
   else if (sl_price > el_price) { // sell setup
      if (tp_price > max || tp_price < min) {
         this.Price1(el_price - 2 * SL * _Point);
      }
   }
   else return;
}

void CTradeLine::TPLineToOtherSideIfRequired(void) {

   if (SimulatorMode) return; // Forex Simulator does it by itself

   CTradeLine entry(EntryLineName);
   CTradeLine sl(StopLossLineName);
   double SL = MathAbs(sl.Price1() - entry.Price1()) / _Point; 
   
//   double multiplier = this.SLTP_Multiplier(); // TP = SL * multiplier
   
   if (sl.Price1() < entry.Price1() && this.Price1() < entry.Price1()){
      this.Price1(entry.Price1() + 1 * SL * _Point);
      sets.TP_Manual_Control = false;
      sets.SaveSettingsOnDisk();
   }
   else if (sl.Price1() > entry.Price1() && this.Price1() > entry.Price1()) {
      this.Price1(entry.Price1() - 1 * SL * _Point);
      sets.TP_Manual_Control = false;
      sets.SaveSettingsOnDisk();
   }
   
   if (!sets.TP_Manual_Control) TPtoSL_Ratio_Keep();
}



void CTradeLine::TPtoSL_Ratio_Keep() {


   // generating custom event which will force PSC to press TP Multiplier button
   if (!EventChartCustom(ChartID(),PSC_TP_MULT_ALIGN,0,0,"m_BtnLines")) 
      Print("Couldn't generate a custom event. Error code: ", GetLastError(), ": ", ErrorDescription(GetLastError()));
   //else 
   //   Print(__FUNCTION__ + ": 'PSC_TP_MULT_ALIGN' is sent");



   // OLD WAY - before this was done in PSC
//   CTradeLine entry(EntryLineName);
//   CTradeLine sl(StopLossLineName);
//   double SL = MathAbs(sl.Price1() - entry.Price1()) / _Point; // SL size in PP
//   
//   double multiplier = this.SLTP_Multiplier(); // TP = SL * multiplier
//   
//   if (sl.Price1() < entry.Price1()) // buy setup
//      this.Price1(entry.Price1() + multiplier * SL * _Point);
//   else if (sl.Price1() > entry.Price1())
//      this.Price1(entry.Price1() - multiplier * SL * _Point);

}


//double CTradeLine::SLTP_Multiplier() {
//
//   if (Strategy == BF) return 2;
//   else return 3;
//
//}





// ******************************************************
// *********** BREAK EVEN LINE FUNCTIONS ****************
// ******************************************************
bool CTradeLine::CreateBreakEvenLine(ulong ticket) {

   CMetaTrade trade(ticket);
   double price = trade.GetBreakEvenPrice();
   if (!ObjectCreateMQL4(this.Name,OBJ_HLINE,0,0,price)) {
      string msg = "Cannot create Break Even Line named '" + this.Name + "'. Error: " + IntegerToString(GetLastError());
      Print(msg);
      MessageOnChart(msg, MessageOnChartAppearTime);
      return false;
   }
   this.Color(this.m_BreakEvenLineEditColor);
   ObjectSetMQL4(this.Name,OBJPROP_STYLE,STYLE_DASH);
   this.ShowOnAllTimeframes(true); 
   this.SetToolTip("Break Even Line");
   this.Select();
   return true;
}


void CTradeLine::UpdateBreakEvenLine(ulong ticket) {

   CMetaTrade trade(ticket);
   double price = trade.GetBreakEvenPrice();
   this.Price1(price);
   this.ShowOnAllTimeframes(true);
   this.Color(this.m_BreakEvenLineEditColor);
   this.Select();
}


void CTradeLine::BreakEvenLineSet(int BE_PP, int BE_Percent) {

   this.Select(false);
   this.Color(this.m_BreakEvenLineSetColor);
   ObjectSetTextMQL4(this.Name,"BE: " + IntegerToString(BE_PP/10) + "pp | " + IntegerToString(BE_Percent) + "% of TP",10);
   this.UpdateToolTip();
}




void CTradeLine::BreakEvenLineEdit() {

   this.Select();
   this.Color(this.m_BreakEvenLineEditColor);
}

// ******************************************************
// ******************************************************
// ******************************************************






// ******************************************************
// *********** BACKWARDS BREAK LINE FUNCTIONS ***********
// ******************************************************
bool CTradeLine::CreateBackwardsBreakLine(ulong ticket) {
   CMetaTrade trade(ticket);
   double price = trade.GetBackwardsBreakPriceDefault(0);

   if (!ObjectCreateMQL4(this.Name,OBJ_HLINE,0,0,price)) {
      Print("Cannot create Break Even Line named '", this.Name, "'. Error: " + IntegerToString(GetLastError()));
      return false;
   }
   this.Color(this.m_BackwardsBreakLineEditColor);
   ObjectSetMQL4(this.Name,OBJPROP_STYLE,STYLE_DASH);
   this.BackwardsBreakLineEdit();
   //ObjectSetInteger(0,this.Name,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1|OBJ_PERIOD_H4|OBJ_PERIOD_M15);
   this.SetToolTip("Backwards Break Line");
   //this.Select();
   return true;
   // leave BB line in edit mode
}



void CTradeLine::BackwardsBreakLineSet() {
   this.Select(false);
   this.Color(this.m_BackwardsBreakLineSetColor);
   ObjectSetInteger(0,this.Name,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1|OBJ_PERIOD_H4|OBJ_PERIOD_M15);
}


void CTradeLine::UpdateBackwardsBreakLine() { 
   // how this function is different from BackwardsBreakLineEdit()???
   // what exactly are we doing here?
   this.ShowOnAllTimeframes(true);
   this.Color(this.m_BackwardsBreakLineEditColor);
   this.Select();
   ObjectSetInteger(0,this.Name,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1|OBJ_PERIOD_H4|OBJ_PERIOD_M15);
}

void CTradeLine::BackwardsBreakLineEdit() {
   // set Backwards Break Line into editing mode
   this.Color(this.m_BackwardsBreakLineEditColor);
   this.Select();
   ObjectSetInteger(0,this.Name,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1|OBJ_PERIOD_H4|OBJ_PERIOD_M15);
}

// ******************************************************
// ******************************************************
// ******************************************************