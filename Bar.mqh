#property strict


class CBar
  {
private:
   int                m_index;
   string             m_symbol;
   long               m_chartid;
   ENUM_TIMEFRAMES    m_period;
   ImpulseType        IsS3ImpulsefFromLevel(CLevel &level);
   bool               MarkBarAfterImpulseNotification(long chartid, int barNumber, ImpulseType impulse_type);
   bool               IsExtremumTakenOut(TradeDirectionType trade_direction);
   int                GetClosestLevelIndex(CLevel &levels[]);
   bool               S3_Impulse_Condition_3(TradeDirectionType trade_dir);
   MqlDateTime        CurrentTime;
   bool               IsTooSmallForImpulse(double ATR);



public:
                        //CBar(int index);
                        CBar(int index, ENUM_TIMEFRAMES period);
                       ~CBar();
   string      BarSymbol();
   double      HighPrice();
   double      LowPrice();
   double      ClosePrice();
   double      OpenPrice();
   int         Index();
   datetime    OpenTime();
   double      Height();
   double      Body();
   double      UpperWick();
   double      LowerWick();
   bool        IsBodyBlack();
   bool        IsBodyWhite();
   void        Alert_and_Sound_for_S3_Impulse(CLevel &levels[], double ATR, bool SoundEffect = false);
   
   PinBarType  PinBar_Type();
   void        HighlightBar(color clr, string Description);
   void        BarInfoIcon(int arrow_code, color clr, string Description);
   void        DeleteDebugIcon();
   
   // Pin Bar Detection Methods
   PinBarType  GetPinBarType(int BarShift);
   string      PinBarTouchesLine(int BarShift,PinBarType _PinBarType);
   bool        IsPinBarSizeOK(int PinBarShift);
   bool        IsPossibleThreat(double ATR, CMetaTrade &trades_array_on_symbol[]);
   void        PinBarDetector(int hours_delay);
   //bool        InformedAboutPinBar();
   //void        InformedAboutPinBarSet();
   //void        Reset_InformedAboutPinBar();
   //string      m_InfAbPinBar_g_var_name;
   
   // S3-impulse detection
   //bool         InformedAboutPossibleS3Impulse();
   //void         InformedAboutPossibleS3ImpulseSet();
   //string       m_InfAbPossS3Imp_g_var_name;
   //void         Reset_InformedAboutPossibleS3Impulse();
   
   // Threat-bar detection
   //bool         InformedAboutPossibleThreat();
   //void         InformedAboutPossibleThreatSet();
   //string       m_InfAbPossThreat_g_var_name;
   //void         Reset_InformedAboutPossibleThreat();
   
   // False Break Detector for D1 strategy
   void        LevelFalseBreakDetectorD1();
   // ***************************

  };


CBar::CBar(int index, ENUM_TIMEFRAMES period)
  {
  // option to create bar on specific time period
  m_index = index;
  m_symbol = _Symbol; // symbol is always current
  m_period = period;
  m_chartid = ChartID();
  TimeCurrent(CurrentTime);
  //m_InfAbPinBar_g_var_name       = "InfAbPinBar-" + this.m_symbol + "-" + IntegerToString(ChartID());
  //m_InfAbPossS3Imp_g_var_name    = "InfAbS3imp-" + this.m_symbol + "-" + IntegerToString(ChartID());
  //m_InfAbPossThreat_g_var_name   = "InfAbThreat-" + this.m_symbol + "-" + IntegerToString(ChartID());
  }
  
  
  
CBar::~CBar()
  {
  }
//+------------------------------------------------------------------+


string CBar::BarSymbol(void) {

   return m_symbol;

}


double CBar::HighPrice() {
   return iHigh(m_symbol,m_period,m_index);
}

double CBar::LowPrice() {
   return iLow(m_symbol,m_period,m_index);
}

double CBar::ClosePrice() {
   return iClose(m_symbol,m_period,m_index);
}

double CBar::OpenPrice() {
   return iOpen(m_symbol,m_period,m_index);
}

int CBar::Index() {

   return m_index;

}


datetime CBar::OpenTime() {
   return iTime(m_symbol,m_period,m_index);
}



double CBar::Height() {
   // bar size in pips
   return (MathAbs(this.HighPrice() - this.LowPrice())) / _Point;
}


double CBar::Body() {

   return (MathAbs(this.OpenPrice() - this.ClosePrice())) / _Point;

}


double CBar::UpperWick() {
   if (this.ClosePrice() >= this.OpenPrice()) 
      // bullish case
      return (this.HighPrice() - this.ClosePrice()) / _Point;
   else
      // bearish case
      return (this.HighPrice() - this.OpenPrice()) / _Point;
}

double CBar::LowerWick() {
   if (this.ClosePrice() >= this.OpenPrice()) 
      return (this.OpenPrice() - this.LowPrice()) / _Point;
   else
      return (this.ClosePrice() - this.LowPrice()) / _Point;
}


ImpulseType CBar::IsS3ImpulsefFromLevel(CLevel &level) {

   double gap = _Point*10; // if the bar is on this distance (or closer) from the level - still consider it is touching that level
   if (_Symbol == "BRN" || _Symbol == "WTI" || _Symbol == "BRENT") gap = _Point*3;
   //Print("gap = ", gap);
   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(_Symbol ,Latest_Price); // Assign current prices to structure 

   this.DeleteDebugIcon();   

   if(level.TradeDirection == Buy_Level) {
   
      if ( !IsExtremumTakenOut(level.TradeDirection) ) return No_Impulse;
      
      // Check if it closes above level
      if (Latest_Price.bid >= level.Price()) {
         //Print(1);
         if (DebugMode) this.BarInfoIcon(129,clrGray,"Condition 1 met for S3-impulse");
         
         // 2) This or previous bar touches the level (even if gap away - we consider that as touch as well)
         if(this.LowPrice()-gap <= level.Price() || iLow(this.m_symbol,this.m_period,this.m_index+1)-gap <= level.Price()) { // 
            //Print(2);
            if (DebugMode) this.BarInfoIcon(130,clrGray,"Condition 2 met for S3-impulse");
            
            // 3) if body is black, its size may not be more than 25% of the whole bar size
            if (this.S3_Impulse_Condition_3(Buy_Level)) {
               //Print(3);
               if (DebugMode) this.BarInfoIcon(131,clrGray,"Condition 3 met for S3-impulse");
               // 4) Upper wick is not longer than 30% of the whole bar length
               if (this.UpperWick() <= this.Height()*0.4) {
                  //Print(4);
                  if (DebugMode) this.BarInfoIcon(132,clrGray,"Condition 4 met for S3-impulse");
                  return Buy_Impulse;
               }
               else return No_Impulse;
            }
            else return No_Impulse;
         }
         else  return No_Impulse; 
      }
      else {
         if (DebugMode) this.BarInfoIcon(128,clrGray,"No conditions met for S3-impulse (buy 1)");
         return No_Impulse;     
      } 
   }
   
   else if (level.TradeDirection == Sell_Level) {
   
      if ( !IsExtremumTakenOut(level.TradeDirection) ) return No_Impulse;
   
      // 1) Closes below level
      if (Latest_Price.bid <= level.Price()) {
         //Print(1);
         if (DebugMode) this.BarInfoIcon(129,clrGray,"Condition 1 met for S3-impulse");
         
         // 2 )This or previous bar touches the level (even if gap away - we consider that as touch as well)
         if(this.HighPrice()+gap >= level.Price() || iHigh(this.m_symbol,this.m_period,this.m_index+1)+gap >= level.Price()) { 
            //Print(2);
            if (DebugMode) this.BarInfoIcon(130,clrGray,"Condition 2 met for S3-impulse");
            
            // 3) if body is white, its size may not be more than 25% of the whole bar size
            if (this.S3_Impulse_Condition_3(Sell_Level)) {
               //Print(3);
               if (DebugMode) this.BarInfoIcon(131,clrGray,"Condition 3 met for S3-impulse");
               
               // 4) Lower wick is not longer than 30% of the whole bar length
               if (this.LowerWick() <= this.Height()*0.4) {
                  //Print(4);
                  if (DebugMode) this.BarInfoIcon(132,clrGray,"Condition 4 met for S3-impulse");
                  return Sell_Impulse;
               }
               else return No_Impulse;  
            }
            else return No_Impulse;  
         }
         else return No_Impulse;  
      }
      else {
         if (DebugMode) this.BarInfoIcon(128,clrGray,"No conditions met for S3-impulse (sell 1)");
         return No_Impulse;  
      }
   }
   else 
      return No_Impulse;
}



bool CBar::IsExtremumTakenOut(TradeDirectionType trade_direction) {

   string trend_name = "";
   CTrend trend(trend_name);

   if (trade_direction == Sell_Level) {
      // checking if high was taken out
      trend.Name = "HighToTakeOut";
      if (ObjectFind(ChartID(),trend.Name) == -1) {
         Print(__FUNCTION__ + ": No high mark to take out");
         return true; // if this trend-mark does not exist - assuming the extremum was taken out
      }
   }
   
   else if (trade_direction == Buy_Level) {
      // checking if low was taken out
      trend.Name = "LowToTakeOut";
      if (ObjectFind(ChartID(),trend.Name) == -1) {
         Print(__FUNCTION__ + ": No low mark to take out");
         return true; // if this trend-mark does not exist - assuming the extremum was taken out
      }
   }
   
   // *********************************************************************************
   // check if that 'trend_name' was set today, i.e., price 2 is in the end of today
   // so, we do not take into account 'trend_name' that were set previous days
   // otherwise, if we do, we can under-report impulses of today
   datetime time2 = trend.DateTime2();
   datetime DateTime2 = StringToTime(string(Today() + HR2400)+"00:00");
   if (time2 < DateTime2) {
      Print("Extremum to take out exist, but in the past. Ignoring it.");
      return true;
   }
   // that found 'trend_name' is in the past, we should not take it into consideration
   // *********************************************************************************
   
   
   double TrendPrice = trend.Price1();
   if (TrendPrice == 0) {
      Print(__FUNCTION__ + ": Error! Extremum price to be taken out is 0!");
      return true;
   }
   
   datetime BarTime = (datetime)ObjectGetInteger(ChartID(),trend.Name,OBJPROP_TIME1);   
   int BarIndex = iBarShift(_Symbol,PERIOD_H1,BarTime);
   
   if (trade_direction == Sell_Level) {
      for (int i = BarIndex; i >= 0; i--) { // scan all bars from the beginning of the trend line until the current bar
         // check if high was taken out
         if (iHigh(_Symbol,PERIOD_H1,i) > TrendPrice) {
            Print("High was taken out!");
            return true;
         }
      }
    }
    else if (trade_direction == Buy_Level) {
      for (int i = BarIndex; i >= 0; i--) { // scan all bars from the beginning of the trend line until the current bar
         // check if low was taken out
         if (iLow(_Symbol,PERIOD_H1,i) < TrendPrice) {
            Print("Low was taken out!");
            return true;
         }
      }
    }
    
    if (trade_direction == Sell_Level) 
      Print("High was NOT taken out");
    else if (trade_direction == Buy_Level)
      Print("Low was NOT taken out");
    
    return false;
}




bool CBar::S3_Impulse_Condition_3(TradeDirectionType trade_dir) {
   // making sure the body is white - for buy impulse; and black for sell impulse
   //Print("trade_dir = ", EnumToString(trade_dir));
   
   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(_Symbol ,Latest_Price); // Assign current prices to structure 
   
   if (trade_dir  == Buy_Level) {
      if (Latest_Price.bid >= this.OpenPrice()) return true; // body is white, or no body
      if (this.Body() < this.Height() * 0.25) return true;
      else return false;
   }
   else if (trade_dir  == Sell_Level) {
      if (Latest_Price.bid <= this.OpenPrice()) return true; // body is black, or no body
      if (this.Body() < this.Height() * 0.25) return true;
      else return false;
   }
   else {
      Print("Error: unknown TradeDirectionType: " + EnumToString(trade_dir));
      return false;
   }
}



int CBar::GetClosestLevelIndex(CLevel &levels[]) {
   // returns array index of the closest level to the current price
   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(_Symbol ,Latest_Price); // Assign current prices to structure 
   
   int array_size = ArraySize(levels);
   
   if (array_size == 0) return -1; // no levels in the array
   if (array_size == 1) return 0; // there is only one level in the array
   
   // beyond this point - there is 2 or more levels in the array

   int closest_level_index = 0;
   double shortest_distance;
   
   shortest_distance = ( MathAbs(Latest_Price.bid - levels[0].Price()) ) / _Point; // distance to the 1st level
   closest_level_index = 0;

   for (int i=1; i<ArraySize(levels); i++) { // checking levels starting from the 2nd in the array
      double new_distance = ( MathAbs(Latest_Price.bid - levels[i].Price()) ) / _Point;
      if (new_distance < shortest_distance) {
         shortest_distance = new_distance;
         closest_level_index = i;
      }
   }
   return closest_level_index;
}



bool CBar::IsTooSmallForImpulse(double ATR) {

   // *** CHECKS SIZE OF THIS BAR - IF IT IS TOO SMALL *** // SMALL means less than 10% of the ATR
   
   double h = this.Height(); // height of this bar.
   if (_Symbol != "BRN" || _Symbol != "WTI" || _Symbol != "BRENT") h = h / 10;
   if (_Symbol == "BRN" || _Symbol == "WTI" || _Symbol == "BRENT") h = h * 10;
   if (_Symbol == "XAUUSD" || _Symbol == "XAGUSD") h = h * 10;
   
   //if (DebugMode) Print("h = ", h, "; min allowed bar size is = ", ATR*0.1, " (ATR*0.1)");
   

   if (h < ATR*0.1) {// too small bar
      //if (DebugMode) Print("Too small bar, only: " + DoubleToString(h,1) + "pp / " + DoubleToString(h/ATR*100,1) + "% of ATR5 | ATR5 = " + DoubleToString(ATR,0));
      return true; 
   }
   else {
      //if (DebugMode) Print("Bar size: " + DoubleToString(this.Height()/10,1) + "pp / " + DoubleToString(h/ATR*100,1) + "% of ATR5 | ATR5 = " + DoubleToString(ATR,0));
      return false;
   }
}




void CBar::Alert_and_Sound_for_S3_Impulse(CLevel &levels[], double ATR, bool SoundEffect = false) {

   // *** CHECKS SIZE OF THIS BAR - IF IT IS TOO SMALL *** //
   if (this.IsTooSmallForImpulse(ATR)) return;

   // *** CHECK IF THERE ARE LEVELS ***
   if (ArraySize(levels) == 0) {
      if (DebugMode) this.BarInfoIcon(127,clrGray,"No levels found");
      return;
   }
   
   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(_Symbol ,Latest_Price); // Assign current prices to structure
   
   string msg, dir, probability;
   
   //int i = this.GetClosestLevelIndex(levels); 
   //if (i < 0) return; // there are no levels
   //- it is incorrect to check impulse from the cloosedt level!
   // because, e.g. in an example of two sell-level close to each other and price between them. There can be no 
   // impulse from the "closest" of theem, but it can be from the 2nd closest - and this approach would then give 
   // no S3-impulse alert.
   // that's why we should check all levels one by one - if there is S3-impulse from each of them or not.
   
   for (int i=0; i<ArraySize(levels); i++) {
   
      // *********************************************************
      // ***** checking for 4 impulse criteria for this level ****
      // *********************************************************
         
      ImpulseType impulse_type = this.IsS3ImpulsefFromLevel(levels[i]); // All the impulse detection logic is in this method
      
      if (impulse_type == No_Impulse) { // no impulse
         //Print("(1) Levels checked: ", levels_checked);
         continue;
      }
      else if (impulse_type == Buy_Impulse) { // buy impulse
         dir = "buy";
      }
      else if (impulse_type == Sell_Impulse) { // sell impulse
         dir = "sell";
      }
      // ***********************************************
      // *** impulse search finished for this level ****
      // ***********************************************
   
   
      // ***********************************************
      // ****  informing with sound and push     *******
      // ***********************************************
      if (impulse_type == Buy_Impulse || impulse_type == Sell_Impulse) {
         // there is an impulse at this point!
         // informing with sound and push
         if (SecondsSinceLastSoundAlarm >= 3) { // release sound alert once each 3 sec at most
            if (SoundEffect){
               if (!PlaySound("tick.wav")) Print("Sound Alert file not found");
               else Print("Sound from ", this.m_symbol);
               SecondsSinceLastSoundAlarm = 0;
            }
         }
         else SecondsSinceLastSoundAlarm++;
            
         
         if (!sets.InformedAbS3imp) { // not yet notified about possible S3 impulse
            double d_size; // size of the current bar as %% of ATR5
            string s_size; // size of the current bar as %% of ATR5
            d_size = this.Height() / ATR5 * 100;
            if (_Symbol != "WTI" && _Symbol != "BRN" && _Symbol != "BRENT") d_size = d_size / 10;
            s_size = DoubleToString(d_size,0);
         
            ChartCheckNeededSet(S3_Impulse,this.m_symbol,this.m_chartid);
            if (!S_Version) MarkBarAfterImpulseNotification(ChartID(), 0, impulse_type); // create a small dot under or above the impulse 
            
            Probability prob = ProbabilityInWatchList(ChartID());
            if (prob == HighProbability) probability = "HIGH";
            else probability = "LOW";
            
            msg = EnumToString(Strategy) + "-" + this.m_symbol + ": "+ dir +" imp.poss. Size: " + s_size + "% of ATR5. Dist: " 
               + DoubleToString((MathAbs(Latest_Price.bid-levels[i].Price()))/_Point/10,0) 
               + "pp. Probab.: " + probability;
             
            if (IsPushControlON()){      
               if (!SendNotification(msg)) Print("Error sending push notification '"+ msg +"'");
               else {
                  Print("Push Notification Sent: " + msg);
                  //this.InformedAboutPossibleS3ImpulseSet(); 
                  sets.InformedAbS3imp = true;
                  sets.SaveSettingsOnDisk();    
               }
             }
         }
         return;
      } 
      // ***********************************************
      // ** END OF  informing with sound and push  *****
      // ***********************************************
   }

}




bool CBar::MarkBarAfterImpulseNotification(long chartid, int barNumber, ImpulseType impulse_type) {
    // Set up the parameters for the object
    string symbol = ChartSymbol(chartid);
    datetime time = iTime(symbol,PERIOD_H1,barNumber);
    double price;
    int fontSize = 18;
    color clr = clrGreen;
    uchar arrow_code = 159;
    string name = "InformedAboutImpulse" + TimeToString(time);
    string tooltip;
    
    if (impulse_type == Buy_Impulse) {
      tooltip = "Buy impulse notification on watch list";
      price   = iLow(symbol,PERIOD_H1,barNumber) - (Ask - Bid);
    }
    else {
      tooltip = "Sell impulse notification on watch list";
      price   = iHigh(symbol,PERIOD_H1,barNumber) + (Ask - Bid);
    }
    
    
   ResetLastError();
   ObjectDeleteSilent(name);
   if(!ObjectCreate(chartid,name,OBJ_ARROW,0,time,price)) {
      Print(__FUNCTION__, ": failed to create icon! Error code = ",GetLastError());
      return false;
   }
   else {
      ObjectSetInteger(chartid,name,OBJPROP_SELECTABLE,true);
      //ObjectSetInteger(chartid,name,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
      ObjectSetMQL4(name, OBJPROP_TIMEFRAMES, PERIOD_M30 | PERIOD_M15 | PERIOD_M5 | PERIOD_M1);
      ObjectSetInteger(0,name,OBJPROP_ARROWCODE,arrow_code);
      ObjectSetTextMQL4(name,CharToString(arrow_code),10,"Wingdings",clr);   
      ObjectSetInteger(chartid,name,OBJPROP_COLOR,clr);     
      ObjectSetTextMQL4(name,tooltip,10);
      
      if (impulse_type == Buy_Impulse) 
         ObjectSetInteger(chartid,name,OBJPROP_ANCHOR,ANCHOR_TOP);
      else
         ObjectSetInteger(chartid,name,OBJPROP_ANCHOR,ANCHOR_BOTTOM);
   }
   return true;
}




//bool CBar::InformedAboutPossibleS3Impulse() {
//
//   if (GlobalVariableGet(this.m_InfAbPossS3Imp_g_var_name) == 1) return true;
//   else return false;
//
//}
//
//void CBar::InformedAboutPossibleS3ImpulseSet() {
//
//   if (GlobalVariableSet(this.m_InfAbPossS3Imp_g_var_name,1) == 0) 
//      Print(__FUNCTION__,": couldn't set global variable '",this.m_InfAbPossS3Imp_g_var_name,"' to '1'");
//}
//
//
//void CBar::Reset_InformedAboutPossibleS3Impulse() {
//
//   if (GlobalVariableSet(this.m_InfAbPossS3Imp_g_var_name,0) == 0)
//      Print(__FUNCTION__,": couldn't set global variable '",this.m_InfAbPossS3Imp_g_var_name,"' to '0'");
//}
//





//bool CBar::InformedAboutPinBar() {
//
//   if (GlobalVariableGet(this.m_InfAbPinBar_g_var_name) == 1) return true;
//   else return false;
//
//}
//
//void CBar::InformedAboutPinBarSet() {
//
//   if (GlobalVariableSet(this.m_InfAbPinBar_g_var_name,1) == 0) 
//      Print(__FUNCTION__,": couldn't set global variable '",this.m_InfAbPinBar_g_var_name,"' to '1'");
//}
//
//
//void CBar::Reset_InformedAboutPinBar() {
//
//   if (GlobalVariableSet(this.m_InfAbPinBar_g_var_name,0) == 0)
//      Print(__FUNCTION__,": couldn't set global variable '",this.m_InfAbPinBar_g_var_name,"' to '0'");
//}
//









//bool CBar::InformedAboutPossibleThreat() {
//
//   if (GlobalVariableGet(this.m_InfAbPossThreat_g_var_name) == 1) return true;
//   else return false;
//
//}
//
//void CBar::InformedAboutPossibleThreatSet() {
//
//   if (GlobalVariableSet(this.m_InfAbPossThreat_g_var_name,1) == 0) 
//      Print(__FUNCTION__,": couldn't set global variable '",this.m_InfAbPossThreat_g_var_name,"' to '1'");
//}
//
//
//void CBar::Reset_InformedAboutPossibleThreat() {
//
//   if (GlobalVariableSet(this.m_InfAbPossThreat_g_var_name,0) == 0)
//      Print(__FUNCTION__,": couldn't set global variable '",this.m_InfAbPossThreat_g_var_name,"' to '0'");
//
//}











PinBarType CBar::PinBar_Type() {

   int    i_MinPinBarSize = 40; 
   int    i_MaxPinBarSize = 800;
   double d_ShortShadowToLongShadow = 0.7;
   double d_BodyToLongShadow = 0.6;
   
   
   #ifdef __MQL5__
      InitHighLowOpenCloseArrays(this.Index());
   #endif 
   
   for ( int i = 0; i < ArraySize(High); i++ )
      //Print("High[" + IntegerToString(i) + "] = " + DoubleToString(High[i],5));
  
   // checking if pin bar size is OK first
   // array-out-of-range protection
   if ( ArraySize(High) <= this.Index() ) {
      Print(__FUNCTION__ + ": Size of High[] array is " + IntegerToString(ArraySize(High)) + " while bar index is " 
         + IntegerToString(this.Index()) + " - possible out-of-range error. Interrupting function...");
      return NotPinBar;
   }   
   if ( ArraySize(Low) <= this.Index() ) {
      Print(__FUNCTION__ + ": Size of Low[] array is " + IntegerToString(ArraySize(High)) + " while bar index is " 
         + IntegerToString(this.Index()) + " - possible out-of-range error. Interrupting function...");
      return NotPinBar;
   }
   if(
         (High[this.Index()] - Low[this.Index()]) < i_MinPinBarSize * _Point 
      && (High[this.Index()] - Low[this.Index()]) > i_MaxPinBarSize * _Point 
      )
      return NotPinBar;
   // pin bar size is ok, so we continue
   

   double LowerShadow= MathMin(Open[this.Index()],Close[this.Index()])-Low[this.Index()];
   if(LowerShadow == 0) LowerShadow = _Point;
   double UpperShadow= High[this.Index()]-MathMax(Open[this.Index()],Close[this.Index()]);
   if(UpperShadow == 0) UpperShadow = _Point;
   double PinBody= MathAbs(Open[this.Index()]-Close[this.Index()]);
   if(PinBody == 0) PinBody = _Point;
   
   //Print("LowerShadow = " + LowerShadow);
   //Print("UpperShadow = " + UpperShadow);

   if(LowerShadow/UpperShadow <= d_ShortShadowToLongShadow) 
     {
      if(PinBody / UpperShadow <= d_BodyToLongShadow) return Bearish;
      else return NotPinBar;
     }
   else 
     {
      if(PinBody / LowerShadow <= d_BodyToLongShadow) return Bullish;
      else return NotPinBar;
     }
}



void CBar::HighlightBar(color clr, string Description) {

   int random_int = MathRand();
   datetime bar_time = iTime(m_symbol,m_period,m_index);
   string rect_name = "Highlighted for Bar #" + TimeToString(bar_time) + ")";
   datetime time1 = bar_time - 60*60; // two hours back
   datetime time2;
   if (this.m_period == PERIOD_D1)
      time2 = bar_time + 60*60*24;
   else
      time2 = bar_time + 60*60;
   double price1 = iHigh(m_symbol,m_period,m_index);
   double price2 = iLow(m_symbol,m_period,m_index);

   ObjectDeleteSilent(rect_name);
   if(!ObjectCreate(ChartID(),rect_name,OBJ_RECTANGLE,0,time1,price1,time2,price2))
   {
      Print(__FUNCTION__,": failed to create a rectangle! Error code = ",GetLastError());
      return;
   }
   else {
      ObjectSetInteger(ChartID(),rect_name,OBJPROP_COLOR,clr);
      if (this.m_period == PERIOD_D1)
         ObjectSetInteger(0,rect_name,OBJPROP_TIMEFRAMES,OBJ_PERIOD_D1);
      else
         ObjectSetInteger(0,rect_name,OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4);
      ObjectSetTextMQL4(rect_name,Description,12);
      return;
   }

}



void CBar::DeleteDebugIcon(void) {
   datetime bar_time = iTime(m_symbol,m_period,m_index);
   string icon_name = "BarInfoIcon #" + IntegerToString(int(bar_time));
   if (ObjectFindMQL4(icon_name) >= 0) { 
      ObjectDeleteSilent(icon_name);
   }
}



void CBar::BarInfoIcon(int arrow_code, color clr, string Description) {

   datetime bar_time;
   // time of the icon depends, if this is the current bar, or not
   // if current - its time coordinate is exactly current server time
   // otherwise, it is opening time of that bar.
   bool s3_icon = false;
   if (arrow_code >= 127 && arrow_code <= 132) s3_icon = true;
   
   if (m_index == 0 && !s3_icon)
      bar_time = TimeCurrent(); // current bar
   else
      bar_time = iTime(m_symbol,m_period,m_index); // a bar somewhere in the past; or this is S3 icon
      
   int random_int = MathRand();  
   string icon_name = "BarInfoIcon #" + IntegerToString(random_int) + ")"; // this enables to have multiple icons for one bar.
   double price = iHigh(m_symbol,m_period,m_index);
   Description = s_TimeCurrent() + " " + Description;
   


   if (s3_icon) {
      // but if this is one of these icons - only 1 such icons can be created per bar
      icon_name = "BarInfoIcon #" + IntegerToString(int(bar_time)); // this makes each icon personal to each bar
      // first we seach, if such icon was already created for this bar; if yes - delete it before creating the new one
      if (ObjectFindMQL4(icon_name) >= 0) { // such icon already exists for this bar
         ObjectDeleteSilent(icon_name);
      }
      price = iLow(m_symbol,m_period,m_index);
   }
   
   
   bool created = false;
   
   if (s3_icon)
      created = ObjectCreate(ChartID(),icon_name,OBJ_TEXT,0,bar_time,price);
   else
      created = ObjectCreate(ChartID(),icon_name,OBJ_ARROW,0,bar_time,price);
      
      

   if( !created )
   {
      Print(__FUNCTION__,": failed to create a BarInfoArrow! Error code = ",GetLastError());
      return;
   }
   else {
      
      ObjectSetInteger(0,icon_name,OBJPROP_COLOR,clr);
      ObjectSetString(0,icon_name,OBJPROP_TOOLTIP,Description);
      ObjectSetInteger(0,icon_name,OBJPROP_SELECTABLE,true);
      ObjectSetInteger(0,icon_name,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1|OBJ_PERIOD_M30|OBJ_PERIOD_M15|OBJ_PERIOD_M5|OBJ_PERIOD_M1);
      
      if (s3_icon) {
         string txt;
         if (arrow_code == 127) txt = "x";
         else if (arrow_code == 128) txt = "0";
         else if (arrow_code == 129) txt = "1";
         else if (arrow_code == 130) txt = "2";
         else if (arrow_code == 131) txt = "3";
         else if (arrow_code == 132) txt = "4";
         ObjectSetInteger(0,icon_name,OBJPROP_ANCHOR,ANCHOR_UPPER);
         ObjectSetInteger(0,icon_name,OBJPROP_FONTSIZE,8);
         ObjectSetString(0,icon_name,OBJPROP_FONT,"Courier New");
         ObjectSetString(0,icon_name,OBJPROP_TEXT,txt);
      }
      else {
         ObjectSetInteger(0,icon_name,OBJPROP_ANCHOR,ANCHOR_BOTTOM);
         ObjectSetInteger(0,icon_name,OBJPROP_ARROWCODE,arrow_code);
         ObjectSetTextMQL4(icon_name,Description,10);
      }
      //Print("BarInfoArrow is created with description: ", Description);
   }
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
PinBarType CBar::GetPinBarType(int BarShift) 
  {
   double LowerShadow= MathMin(Open[BarShift],Close[BarShift])-Low[BarShift];
   if(LowerShadow == 0) LowerShadow = _Point;
   double UpperShadow= High[BarShift]-MathMax(Open[BarShift],Close[BarShift]);
   if(UpperShadow == 0) UpperShadow = _Point;
   double PinBody= MathAbs(Open[BarShift]-Close[BarShift]);
   if(PinBody == 0) PinBody = _Point;

   if(LowerShadow/UpperShadow<=ShortShadowToLongShadow) 
     {
      if(PinBody / UpperShadow <= BodyToLongShadow) return Bearish;
      else return NotPinBar;
     }
   else 
     {
      if(PinBody / LowerShadow <= BodyToLongShadow) return Bullish;
      else return NotPinBar;
     }
  }
  
  
  
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CBar::PinBarTouchesLine(int BarShift,PinBarType _PinBarType) 
  {
// functions detects whether a bar (not necessarily a pin bar) touches a line (close proximity also qualifies as "touch"); if yes, it returns name of that line, otherwise returns ""
// if it touches more than 1 line, only 1 (first in sequence) will be detected. This may need to change, in the future when this function will be used for full EA automation


   for(int i=0; i<ObjectsTotalMQL4(); i++) { // going through all the objects
      CTrend trend(ObjectNameMQL4(i));

      if(!((trend.Type() == OBJ_TREND || trend.Type() == OBJ_CHANNEL)
         && trend.Style() == STYLE_SOLID && trend.IsVisibleOnTF(PERIOD_H1) && trend.HasRay())
         ) continue;

      // qualified line is found; then we check distance of Pin Bar tail to this line
      if(_PinBarType==Bearish) 
        { // in bearish case: from High to Trend
         // check: High is higher than Trend (or directly on the line), or distance between Trend and High is 6 pips or less
         if(High[BarShift]>=ObjectGetValueByShiftMQL4(trend.Name,BarShift,PERIOD_CURRENT) || (ObjectGetValueByShiftMQL4(trend.Name,BarShift,PERIOD_CURRENT)-High[BarShift]<=10*point_global)) 
           {
            // now, check if Close price is on acceptable distance from Trend
            if((ObjectGetValueByShiftMQL4(trend.Name,BarShift,PERIOD_CURRENT)-Close[BarShift])<=100*point_global
               && Close[BarShift]<ObjectGetValueByShiftMQL4(trend.Name,BarShift,PERIOD_CURRENT)
               && Open[BarShift]<ObjectGetValueByShiftMQL4(trend.Name,BarShift,PERIOD_CURRENT)
               )
               return trend.Name;
           }
        }
      else if(_PinBarType==Bullish) 
        { // in bullish case: from Low to Trend
         // check: Low is lower than Trend (or directly on the line), or distance between Low and Trend is 6 pips or less
         if(Low[BarShift]<=ObjectGetValueByShiftMQL4(trend.Name,BarShift,PERIOD_CURRENT) || (Low[BarShift]-ObjectGetValueByShiftMQL4(trend.Name,BarShift,PERIOD_CURRENT)<=10*point_global)) 
           {
            // now, check if Close price is on acceptable distance from Trend
            if((Close[BarShift]-ObjectGetValueByShiftMQL4(trend.Name,BarShift,PERIOD_CURRENT))<=100*point_global
               && Close[BarShift]>ObjectGetValueByShiftMQL4(trend.Name,BarShift,PERIOD_CURRENT)
               && Open[BarShift]>ObjectGetValueByShiftMQL4(trend.Name,BarShift,PERIOD_CURRENT)
               )
               return trend.Name;
           }
        }
      else return ""; // this is not a pin bar, so we do not care what it touches
      //delete trend;
     } // for-cycle across all the objects
   return "";
  }
  
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CBar::IsPinBarSizeOK(int PinBarShift) {

   // min pin bar size = 50% of ATR5
   // max pin bar size = 2000% of ATR5
   //Print("ATR5 = " + DoubleToString(ATR5,1));
   //if (DebugMode) Print("Bar height is: " + DoubleToString(this.Height() / ATR5 * 100,0) + "% of ATR5");

   if (this.Height() >= ATR5 * 0.5 && this.Height() <= ATR5 * 20)
      return true;
   else
      return false;

   //if((High[PinBarShift]-Low[PinBarShift]) >= MinPinBarSize*point_global && (High[PinBarShift]-Low[PinBarShift])<=MaxPinBarSize*point_global)
   //   return true;
   //else
   //   return false;
  }




//+------------------------------------------------------------------+
//| Pin Bar Detector Code Start                                      |
//+------------------------------------------------------------------+
void CBar::PinBarDetector(int hours_delay) {
   // function detects pin bar that touches a trend line and informs user via push notification about it
   // used for all strategies
   //if(NewBar(PERIOD_H1)) this.Reset_InformedAboutPinBar(); // reset flag when new hour starts

   if(!PBDetectorEnabled) return;
   //if( TimeHour(TimeLocal()) < StartAlertsEveryHourAtMin ) return; // this is already check in the OnCalculate function; time has not yet come to check for pin bar and message about it
   
   if(!this.IsPinBarSizeOK(0)) {
      if (DebugMode) Print("thisBar.IsPinBarSizeOK(0) = false - not checking for pin bar further");
      return;  // size is not large enough - skip further check
   }
   // --- check, if pin bar tail touches any solid line on H1 ---
   PinBarType _PinBarType = this.GetPinBarType(0);
   if (_PinBarType == NotPinBar) {
      //if (DebugMode) Print("Not a pin bar");
      return;
   }
   string TouchedLineName = this.PinBarTouchesLine(0,_PinBarType);
   
   if(TouchedLineName=="") {
      //if (DebugMode) Print("No trend was touched");
      return; // no line is touched - skipping this bar
   }
   // Checking times broken of this trend...
   CTrend trend(TouchedLineName);
   int LastBrokenByBarIndex = 0;
   if (trend.TimesBroken(PERIOD_H1,LastBrokenByBarIndex) != 1) {
      if (DebugMode) Print("Trend breaks is not 1");
      return; // detect only re-test of trend lines which are broken exactly once. 
   }
   // -----------------------

   // --- Check for Bearish: then notification and indicator mark
   if(_PinBarType==Bearish)  {
      if( hours_delay >= 1 && hours_delay <= 3 ) { // Watchlist hours delay = 1, 2 or 3
         PinBarPossible = true;
         BroadcastEvent(ChartID(),0,"PinBarPossible");
         PlaySoundAlert();
         Print("Bearish pin bar");

         if(!sets.InformedAbPinBar) {
            if (!(Strategy == D1 && DayPriority == Buy)) { // if it is not (D1 strategy and day priority is buy) - then inform about possible sell signal
               // in other words: exclude buy signals when sell is expected for D1
               SendPushAlert("Bearish pin possible");
               ChartCheckNeededSet(Pin_Bar,_Symbol,ChartID());
               sets.InformedAbPinBar = true;
               sets.SaveSettingsOnDisk();
            }
          }
        }
     }
   else PinBarPossible=false;
   // -------------------------------------------------------

   // --- Check for Bullish: then notification and indicator mark
   if(_PinBarType==Bullish) {
      if( hours_delay >= 1 && hours_delay <= 3 ) // Watchlist hours delay = 1, 2 or 3
        {
         //Print("i = 0");
         PinBarPossible=true;
         BroadcastEvent(ChartID(),0,"PinBarPossible");
         PlaySoundAlert();
         Print("Bullish pin bar");

         if(!sets.InformedAbPinBar) {
            if (!(Strategy == D1 && DayPriority == Sell)) { // if it is not (D1 strategy and day priority is sell) - then inform about possible buy signal 
               // in other words: exclude sell signals when buy is expected for D1
               SendPushAlert("Bullish pin possible");
               ChartCheckNeededSet(Pin_Bar,_Symbol,ChartID());
               sets.InformedAbPinBar = true;
               sets.SaveSettingsOnDisk();
            }
          }
        }
     }
   else PinBarPossible=false;
  } //  PinBarDetectorOnCalculate
  


void CBar::LevelFalseBreakDetectorD1() {
   // detecting only 2nd breakout; (no pin bar detection here)

   if (ArraySize(Levels) == 0) return; // no levels to work with
   
   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(_Symbol ,Latest_Price); // Assign current prices to structure 
   bool FalseBreakPossible = false;
   
   for (int i = 0; i < ArraySize(Levels); i++) { // for each level on the chart
      int LastBrokenByBarIndex;
      if ((Strategy == D1 && Levels[i].TimesBroken(PERIOD_H1,LastBrokenByBarIndex) == 1)) { // 1 times broken for Strategy D1;
         if (DayPriority == Buy && Levels[i].TradeDirection == Buy_Level) {
            if (Latest_Price.bid > Levels[i].Price1() + 10*_Point) { 
               FalseBreakPossible = true;
            }
         }
         else if (DayPriority == Sell && Levels[i].TradeDirection == Sell_Level) {
            if (Latest_Price.bid < Levels[i].Price1() - 10*_Point) 
               FalseBreakPossible = true;
         }
      }   
   } // for 

   if (FalseBreakPossible) {
      BroadcastEvent(ChartID(),0,"FalseLevelBreakPossible");
      PlaySoundAlert();
      
      if(!InformedAboutpossibleLevelFalseBreak) {
         SendPushAlert("False Break Possible");
         InformedAboutpossibleLevelFalseBreak=true;
      }
   }
} // LevelFalseBreakDetector()


bool CBar::IsPossibleThreat(double ATR, CMetaTrade &trades_array_on_symbol[]) {

   // CONDITION 1
   
   if (this.IsTooSmallForImpulse(ATR)) return false; // do not count too small bars to be a possible threat
   
   // taking array of trades on this specific symbol from the global trades array
   
   int trades_on_symbol = ArraySize(trades_array_on_symbol); // total quantity of orders on this symbol, incl. pending ones
   if (trades_on_symbol == 0 ) {
      //if (DebugMode) Print(__FUNCTION__ + ": No trades found on '" + _Symbol + "'");
      return false; // nothing to be threat to   
   }
   
   // CONDITION 2
   int positions_checked = 0;
   for (int i = 0; i < trades_on_symbol; i++) {
      // for each order on this symbol, we check, if this bar represents a threat
      // issue warning, if this bar is a threat to any order; when threat found - break the cycle and do not check other orders on this symbol
      TradeDir trade_dir = trades_array_on_symbol[i].TradeDirection();
      if (trade_dir == TradeDir_BUY) {
         positions_checked++;
         //if (DebugMode) Print("Checking buy position");
         if (this.IsBodyBlack() && this.Body() >= 0.4*this.Height() ) {   // CONDITIONS 2.1.A and 2.1.B
            //if (DebugMode) Print("Reason: consition 2.1: black body and body >= 40% of bar height");
            return true;
         }
         if ( this.UpperWick() > this.LowerWick() && this.UpperWick() >= 0.5*this.Height() )  { // CONDITIONS and 2.2.A and 2.2.B
            //if (DebugMode) Print("Reason: consition 2.2: upper wick > lower wich and upper with >= 50% of bar height");
            return true;
         }
      } // TradeDir_BUY
      else if (trade_dir == TradeDir_SELL) {
         positions_checked++;
         //if (DebugMode) Print("Checking sell position");
         if (this.IsBodyWhite() && this.Body() >= 0.4*this.Height() )  {  // CONDITIONS 2.1.A and 2.1.B
            //if (DebugMode) Print("Reason: condition 2.1: body is white and body >= 40% of bar height");
            return true;
         }
         if ( this.LowerWick() > this.UpperWick() && this.LowerWick() >= 0.5*this.Height() ) {  // CONDITIONS and 2.2.A and 2.2.B
            //if (DebugMode) Print("Reason: condition 2.2: lower wick > upper wick and lower wick >= 50% of body height");
            return true;
         }
      } // TradeDir_SELL
      else {
         Print(__FUNCTION__ + ": error detecting trade direction for trade #" + IntegerToString(trades_array_on_symbol[i].Ticket));
      } 
   }
   //if (DebugMode) Print(__FUNCTION__ + ": No threats found. Positions checked on " + _Symbol + ": " + IntegerToString(positions_checked));
   return false;
}



bool CBar::IsBodyBlack() {

   if (this.ClosePrice() < this.OpenPrice()) return true;
   else return false;

}


bool CBar::IsBodyWhite() {

   if (this.ClosePrice() > this.OpenPrice()) return true;
   else return false;

}


