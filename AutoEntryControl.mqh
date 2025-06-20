#property strict
class CAutoEntryControl
  {
private:


   CTrend               LimitEntryLine;
   CLabel               InstantEntryRect_Label;
   CLabel               LimitEntryRect_Label;
   CLabel               LimitEntryLine_Label;
   double               AnchorLevelPrice;

   
   void      GetAnchorLevelPrice(CLevel &levels[]);
   
   // object names
   string InstantEntryRect_Label_Name;
   string LimitEntryRect_Label_Name;
   //string LimitEntryLine_Label_Name;
   
   void        UpdateInstantEntryRect();
   void        UpdateLimitEntryRect();
   double      GetInstantRectangleHeight();
   
   void        UpdateInstantEntryRectLabel();
   void        UpdateLimitEntryRectLabel();
   
   string      InstantEntryRectHeight_Label;
   string      LimitEntryRectHeight_Label;
   
   
public:
                     CAutoEntryControl();
                    ~CAutoEntryControl();

   CRectangle           InstantEntryRect;
   CRectangle           LimitEntryRect;
   bool        ShowControl(bool show, CLevel &levels[]);
   void        OnDrag(string sparam);
   double      DefaultLimitPrice(CLevel &levels[]);
   bool        IsPriceWithinInstantRect(double price);
   bool        IsPriceWithinLimitRect(double price);
   TradeDirectionType   TradeDirection;
   void        RecoverRectangles();   
   void        CreateGhostRectangles();
                    
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAutoEntryControl::CAutoEntryControl()
  {
  
      InstantEntryRect.Name              = InstantEntryRectName;
      LimitEntryRect.Name                = LimitEntryRectName;
      //LimitEntryLine.Name                = "LimitEntryLine";
      InstantEntryRect_Label_Name        = "InstantEntryRect_Label";
      LimitEntryRect_Label_Name          = "LimitEntryRect_Label";
      //LimitEntryLine_Label_Name          = "LimitEntryLine_Label";
      InstantEntryRectHeight_Label       = "InstantEntryRectHeight_Label";
      LimitEntryRectHeight_Label         = "LimitEntryRectHeight_Label";
   
  } // AutoEntryControl
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

void CAutoEntryControl::RecoverRectangles() {
  if (sets.AutoEntryOnBarClose) {
      
      // recovering positions of rectangles and entry line
      
      if (sets.AutoEntryControl_InstantEntryRect_Price1 != 0) { // if rectangle coordinates were saved (it was not deleted by user)
         this.UpdateInstantEntryRect();
         this.InstantEntryRect.DateTime1(sets.AutoEntryControl_InstantEntryRect_DateTime1);
         this.InstantEntryRect.DateTime2(sets.AutoEntryControl_InstantEntryRect_DateTime2);
         this.InstantEntryRect.Price1(sets.AutoEntryControl_InstantEntryRect_Price1);
         this.InstantEntryRect.Price2(sets.AutoEntryControl_InstantEntryRect_Price2);
      }
      
      if (sets.AutoEntryControl_LimitEntryRect_Price1 != 0) {
         this.UpdateLimitEntryRect(); 
         this.LimitEntryRect.DateTime1(sets.AutoEntryControl_LimitEntryRect_DateTime1);
         this.LimitEntryRect.DateTime2(sets.AutoEntryControl_LimitEntryRect_DateTime2);
         this.LimitEntryRect.Price1(sets.AutoEntryControl_LimitEntryRect_Price1);
         this.LimitEntryRect.Price2(sets.AutoEntryControl_LimitEntryRect_Price2);
      }
      
      CTradeLine entry_line(EntryLineName);
      entry_line.Price(sets.EntryLinePrice);
  }
}



CAutoEntryControl::~CAutoEntryControl() {
  
  if (sets.AutoEntryOnBarClose) {
      // saving positions of rectangles and entry line
      sets.AutoEntryControl_InstantEntryRect_DateTime1   = this.InstantEntryRect.DateTime1();
      sets.AutoEntryControl_InstantEntryRect_DateTime2   = this.InstantEntryRect.DateTime2();
      sets.AutoEntryControl_InstantEntryRect_Price1      = this.InstantEntryRect.Price1();
      sets.AutoEntryControl_InstantEntryRect_Price2      = this.InstantEntryRect.Price2();
      
      sets.AutoEntryControl_LimitEntryRect_DateTime1  = this.LimitEntryRect.DateTime1();
      sets.AutoEntryControl_LimitEntryRect_DateTime2  = this.LimitEntryRect.DateTime2();
      sets.AutoEntryControl_LimitEntryRect_Price1     = this.LimitEntryRect.Price1();
      sets.AutoEntryControl_LimitEntryRect_Price2     = this.LimitEntryRect.Price2();
      
      CTradeLine entry_line(EntryLineName);
      sets.EntryLinePrice  = entry_line.Price();
      sets.SaveSettingsOnDisk();
  }
  
}
//+------------------------------------------------------------------+


double CAutoEntryControl::DefaultLimitPrice(CLevel &levels[]) {

   double new_entry_price = 0;
   
   Print("TradeDirection = " + EnumToString(TradeDirection));

   if (TradeDirection == Buy_Level) {
      new_entry_price = (InstantEntryRect.Price1() - InstantEntryRect.Price2()) / 4 * 3 + InstantEntryRect.Price2();
   }
   else if (TradeDirection == Sell_Level) {
      new_entry_price = InstantEntryRect.Price1() - (InstantEntryRect.Price1() - InstantEntryRect.Price2()) / 4 * 3;
   }
   else Print(__FUNCTION__ + ": Error! Couldn't refine TrandeDirection: " + EnumToString(TradeDirection));

   Print("new_entry_price = " + DoubleToString(new_entry_price,5));
   return new_entry_price;

}



bool CAutoEntryControl::ShowControl(bool show, CLevel &levels[]) {

   if (!show) {
      // hiding all Auto-Entry Controls
      InstantEntryRect.Hide();
      LimitEntryRect.Hide();
      LimitEntryLine.Hide();
      InstantEntryRect_Label.Hide();
      LimitEntryRect_Label.Hide();
      LimitEntryLine_Label.Hide();
      ObjectDeleteSilent(0,InstantEntryRectHeight_Label);
      ObjectDeleteSilent(0,LimitEntryRectHeight_Label);
      return true;
   }

   // showing all Auto-Entry Controls
   this.GetAnchorLevelPrice(levels); // the result is assigned to this.AnchorLevelPrice property

   // creating objects, if they don't exist
   this.UpdateInstantEntryRect();
   this.UpdateLimitEntryRect();
   
   return true;

}








void CAutoEntryControl::UpdateLimitEntryRect(void) {

   double Price1, Price2;
   double InstantRectHeight = MathAbs(InstantEntryRect.Price2() - InstantEntryRect.Price1());
   datetime DateTime1, DateTime2;
   
   DateTime1 = InstantEntryRect.DateTime1();
   DateTime2 = InstantEntryRect.DateTime2();
   
   
   if (TradeDirection == Buy_Level) {
      Price2 = InstantEntryRect.Price1();
      Price1 = Price2 + InstantRectHeight / 2;
   }
   else {
      Price1 = InstantEntryRect.Price2();
      Price2 = Price1 - InstantRectHeight / 2;
   }
   
   if (!LimitEntryRect.IsExist()) {
      // creating
      LimitEntryRect.Create(LimitEntryRect.Name,DateTime1,Price1,DateTime2,Price2);
      Print("InstantEntryRect is created");
   }

   // updating existing one
   LimitEntryRect.DateTime1(DateTime1);
   LimitEntryRect.DateTime2(DateTime2);
   LimitEntryRect.Price1(Price1);
   LimitEntryRect.Price2(Price2);
   ObjectSetMQL4(LimitEntryRect.Name, OBJPROP_TIMEFRAMES, OBJ_PERIOD_H1);
   LimitEntryRect.Select(true);
   LimitEntryRect.Color(clrDarkOrange);
   LimitEntryRect.SetRectangleFill(false);
   LimitEntryRect.Thickness(1);
   
   this.UpdateLimitEntryRectLabel();
}








void CAutoEntryControl::UpdateInstantEntryRect(void){
   
   double Price1, Price2;
   datetime DateTime1, DateTime2;
   
   double points_height = this.GetInstantRectangleHeight();

   
   if (TradeDirection == Buy_Level){
      Price2 = AnchorLevelPrice;
      Price1 = Price2 + points_height*_Point;
   }
   else {
      Price1 = AnchorLevelPrice;
      Price2 = Price1 - points_height*_Point;
   }
   
   DateTime1 = TimeCurrent() - 7200;
   DateTime2 = TimeCurrent() + 25000;
   
   if (!InstantEntryRect.IsExist()) {
      // creating
      InstantEntryRect.Create(InstantEntryRect.Name,DateTime1,Price1,DateTime2,Price2);
      Print("InstantEntryRect is created");
   }

   // updating existing one
   InstantEntryRect.DateTime1(DateTime1);
   InstantEntryRect.DateTime2(DateTime2);
   InstantEntryRect.Price1(Price1);
   InstantEntryRect.Price2(Price2);
   ObjectSetMQL4(InstantEntryRect.Name, OBJPROP_TIMEFRAMES, OBJ_PERIOD_H1);
   InstantEntryRect.Select(true);
   InstantEntryRect.Color(clrDodgerBlue);
   InstantEntryRect.SetRectangleFill(false);
   InstantEntryRect.Thickness(1);
   
   this.UpdateInstantEntryRectLabel();
}


void CAutoEntryControl::UpdateInstantEntryRectLabel(void){
   // create / update label showing height of the rectangle
   if (ObjectFindMQL4(this.InstantEntryRectHeight_Label) >= 0) ObjectDeleteSilent(0,this.InstantEntryRectHeight_Label);
   double height = MathAbs(this.InstantEntryRect.Price1() - this.InstantEntryRect.Price2()) / _Point;
   double h      = MathAbs(this.InstantEntryRect.Price1() - this.InstantEntryRect.Price2()) / 3;
   
   //Print("this.InstantEntryRect.Price2() = " + this.InstantEntryRect.Price2());
   
   int decimals = 0;
   if (height < 200) decimals = 1;
   ObjectCreate(0,this.InstantEntryRectHeight_Label,OBJ_TEXT,0,this.InstantEntryRect.DateTime2()+3600,this.InstantEntryRect.Price2()+h);
   ObjectSetString(0,InstantEntryRectHeight_Label,OBJPROP_TEXT,DoubleToString((double)height/10,decimals));
   ObjectSetString(0,InstantEntryRectHeight_Label,OBJPROP_FONT,"Calibri");
   ObjectSetInteger(0,InstantEntryRectHeight_Label,OBJPROP_FONTSIZE,8);
   ObjectSetInteger(0,InstantEntryRectHeight_Label,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1|OBJ_PERIOD_M30|OBJ_PERIOD_M15|OBJ_PERIOD_M5|OBJ_PERIOD_M1);
   ObjectSetString(0,InstantEntryRectHeight_Label,OBJPROP_TOOLTIP,"Height of the instant entry rectangle: " + DoubleToString((double)height/10,decimals));
   ObjectSetInteger(0,InstantEntryRectHeight_Label,OBJPROP_ANCHOR,CORNER_LEFT_LOWER);
   ObjectSetInteger(0,InstantEntryRectHeight_Label,OBJPROP_SELECTABLE,false);
}

void CAutoEntryControl::UpdateLimitEntryRectLabel(void){
   // create / update label showing height of the rectangle
   ObjectDeleteSilent(0,LimitEntryRectHeight_Label);
   double height = MathAbs(LimitEntryRect.Price1() - LimitEntryRect.Price2()) / _Point;
   double h      = MathAbs(LimitEntryRect.Price1() - LimitEntryRect.Price2()) / 3;
   
   int decimals = 0;
   if (height < 200) decimals = 1;
   ObjectCreate(0,LimitEntryRectHeight_Label,OBJ_TEXT,0,LimitEntryRect.DateTime2()+3600,LimitEntryRect.Price2()+h);
   ObjectSetString(0,LimitEntryRectHeight_Label,OBJPROP_TEXT,DoubleToString((double)height/10,decimals));
   ObjectSetString(0,LimitEntryRectHeight_Label,OBJPROP_FONT,"Calibri");
   ObjectSetInteger(0,LimitEntryRectHeight_Label,OBJPROP_FONTSIZE,8);
   ObjectSetInteger(0,LimitEntryRectHeight_Label,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1|OBJ_PERIOD_M30|OBJ_PERIOD_M15|OBJ_PERIOD_M5|OBJ_PERIOD_M1);
   ObjectSetString(0,LimitEntryRectHeight_Label,OBJPROP_TOOLTIP,"Height of the limit entry rectangle: " + DoubleToString((double)height/10,decimals));
   ObjectSetInteger(0,LimitEntryRectHeight_Label,OBJPROP_ANCHOR,CORNER_LEFT_LOWER);
   ObjectSetInteger(0,LimitEntryRectHeight_Label,OBJPROP_SELECTABLE,false);
}


void CAutoEntryControl::OnDrag(string sparam) {

   if (sparam == InstantEntryRectName) {
      if (LimitEntryRect.Price1() != 0) {
         // upading limit rect, if it exists (was not deleted by user)
         LimitEntryRect.DateTime1(InstantEntryRect.DateTime1());
         LimitEntryRect.DateTime2(InstantEntryRect.DateTime2());
         //Print("TradeDirection = ", EnumToString(TradeDirection));
         if (TradeDirection == Buy_Level) {
            LimitEntryRect.Price2(InstantEntryRect.Price1());
         }
         else {
            LimitEntryRect.Price1(InstantEntryRect.Price2());
         }
      }
      // make sure both rectangles stay near the current bar
      if (InstantEntryRect.DateTime2() <= TimeCurrent()) {
         InstantEntryRect.DateTime2(TimeCurrent() + 25000);
         LimitEntryRect.DateTime2(TimeCurrent() + 25000);
      }
      if (InstantEntryRect.DateTime1() >= TimeCurrent()) {
         InstantEntryRect.DateTime1(TimeCurrent() - 7200);
         LimitEntryRect.DateTime1(TimeCurrent() - 7200);
      }
      //
      
      // make sure that Price1 and Price2 of LimitEntryRect didn't switch its places as a result of above
      if (LimitEntryRect.Price2() >= LimitEntryRect.Price1() && LimitEntryRect.Price1() != 0) {
         if (TradeDirection == Buy_Level) {
            LimitEntryRect.Price1(LimitEntryRect.Price2() + this.GetInstantRectangleHeight()*_Point);
         }
         else {
            if (LimitEntryRect.Price1() != 0)
               LimitEntryRect.Price2(LimitEntryRect.Price1() - this.GetInstantRectangleHeight()*_Point);
         }
      }
      if (InstantEntryRect.Price2() >= InstantEntryRect.Price1()) {
         if (TradeDirection == Buy_Level) {
            InstantEntryRect.Price2(InstantEntryRect.Price1() - this.GetInstantRectangleHeight()*_Point);
         }
         else {
            InstantEntryRect.Price1(InstantEntryRect.Price2() + this.GetInstantRectangleHeight()*_Point);
         }
      }
      //
      this.UpdateInstantEntryRectLabel();
      
      if (LimitEntryRect.Price1() != 0) 
         this.UpdateLimitEntryRectLabel();
   }
   else if (sparam == LimitEntryRectName) {
      if (InstantEntryRect.Price1() != 0) {
         // updaing instant rect, if it exists (was not deleted by user)
         InstantEntryRect.DateTime1(LimitEntryRect.DateTime1());
         InstantEntryRect.DateTime2(LimitEntryRect.DateTime2());
      
         if (TradeDirection == Buy_Level) {
            InstantEntryRect.Price1(LimitEntryRect.Price2());
         }
         else {
            InstantEntryRect.Price2(LimitEntryRect.Price1());
         }
      }
      // make sure both rectangles stay near the current bar
      if (LimitEntryRect.DateTime2() <= TimeCurrent()) {
         LimitEntryRect.DateTime2(TimeCurrent() + 25000);
         InstantEntryRect.DateTime2(TimeCurrent() + 25000);
      }
      if (LimitEntryRect.DateTime1() >= TimeCurrent()) {
         LimitEntryRect.DateTime1(TimeCurrent() - 7200);
         InstantEntryRect.DateTime1(TimeCurrent() - 7200);
      }
      //
      this.UpdateLimitEntryRectLabel();
      
      if (InstantEntryRect.Price1() != 0) 
         this.UpdateInstantEntryRectLabel();
   }


}







void CAutoEntryControl::GetAnchorLevelPrice(CLevel &levels[]) {

   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(_Symbol ,Latest_Price); // Assign current prices to structure 

   // define general direction of the trade first based on mutual position of SL and Entry lines
   CTradeLine sl_line(StopLossLineName);
   CTradeLine entry_line(EntryLineName);
   if (sl_line.Price1() < entry_line.Price1()) { 
      TradeDirection = Buy_Level;
      AnchorLevelPrice = Latest_Price.bid;
   }
   else {
      TradeDirection = Sell_Level;
      AnchorLevelPrice = Latest_Price.ask;
   }
   
   
   // now, let's see if there are any levels today at all
   int levels_count = ArraySize(Levels);
   if (levels_count == 0) return; // no levels; direction is defined and level found
   
   if (levels_count == 1 && Levels[0].TradeDirection != TradeDirection) return; // there is only one level and its direction is different - same thing as if there are no siutable levels
   
   // further - assuming that levels_count > 0
   
   // find closest level to the current price, which has the same trading direction as TradeDirection
   double distance = 0;
   CLevel AnchorLevel = Levels[0];
   distance = Levels[0].DistanceToCurrentPrice();
   
   for (int i = 1; i < levels_count; i++) {
      if (Levels[i].TradeDirection != TradeDirection) continue; // skip levels that have different trading directions
      double new_distance = Levels[i].DistanceToCurrentPrice();
      if (new_distance == 0) continue;
      if (distance == 0 && new_distance != 0) {
         distance = new_distance;
         AnchorLevel = Levels[i];
      }
      else {// now we compare both values, which are not zero (as checked above)
         if (new_distance < distance) {
            distance = new_distance;
            AnchorLevel = Levels[i];
         }
      }
   }   
   AnchorLevelPrice  = AnchorLevel.Price();
   
}




double CAutoEntryControl::GetInstantRectangleHeight(void){

   double points_height;
   string symbol = Symbol();
   
   if ( symbol == "BTCEUR" ) points_height = 3000;
   else if ( symbol == "XAUUSD" ) points_height = 1000;
   else if ( symbol == "BTCUSD" ) points_height = 4000;
   else if ( symbol == "ETHUSD" ) points_height = 500;
   else if ( symbol == "WTI" ) points_height = 25;
   else if ( symbol == "BRN" ) points_height = 25;
   else if ( symbol == "BRENT" ) points_height = 25;
   
   // для пар стратегии Д1 ******
   else if ( symbol == "EURCAD" 
          || symbol == "EURNZD" 
          || symbol == "GBPJPY" 
          || symbol == "EURUSD" 
          || symbol == "GBPUSD" 
          || symbol == "EURAUD" 
          || symbol == "GBPAUD" 
    // **************************
          ) 
      points_height = 100;
   else points_height = 100;

   return points_height;

}






bool CAutoEntryControl::IsPriceWithinInstantRect(double price) {

   if (!InstantEntryRect.IsExist()) return false; // if the rectangle doesn't exist (was deleted) - return false;

   if (price < InstantEntryRect.Price1() && price > InstantEntryRect.Price2())
      return true;
      
   else
      return false;

}


bool CAutoEntryControl::IsPriceWithinLimitRect(double price) {

   if (!LimitEntryRect.IsExist()) return false; // if the rectangle doesn't exist (was deleted) - return false;

   if (price < LimitEntryRect.Price1() && price >= LimitEntryRect.Price2())
      return true;
      
   else
      return false;

}




void CAutoEntryControl::CreateGhostRectangles() {

   MathSrand(GetTickCount());
   int random_int = MathRand();
   string InstantGhostRect_Name = this.InstantEntryRect.Name + " ghost #" + IntegerToString(random_int);
   string LimitGhostRect_Name = this.LimitEntryRect.Name + " ghost #" + IntegerToString(random_int);
   
   CRectangle InstantGhostRect(InstantGhostRect_Name);
   CRectangle LimitGhostRect(LimitGhostRect_Name);
   
   InstantGhostRect.Create(InstantGhostRect.Name,InstantEntryRect.DateTime1(),InstantEntryRect.Price1(),InstantEntryRect.DateTime2(),InstantEntryRect.Price2());
   LimitGhostRect.Create(LimitGhostRect.Name,LimitEntryRect.DateTime1(),LimitEntryRect.Price1(),LimitEntryRect.DateTime2(),LimitEntryRect.Price2());
   
   InstantGhostRect.Color(clrDeepSkyBlue);
   LimitGhostRect.Color(clrOrange);
   
   InstantGhostRect.Style(STYLE_DOT);
   LimitGhostRect.Style(STYLE_DOT);

   InstantGhostRect.Select(false);
   LimitGhostRect.Select(false);
   
   InstantGhostRect.Fill(false);
   LimitGhostRect.Fill(false);  
   
   ObjectSetMQL4(InstantGhostRect.Name, OBJPROP_TIMEFRAMES, OBJ_PERIOD_H1|OBJ_PERIOD_M30|OBJ_PERIOD_M15);
   ObjectSetMQL4(LimitGhostRect.Name, OBJPROP_TIMEFRAMES, OBJ_PERIOD_H1|OBJ_PERIOD_M30|OBJ_PERIOD_M15);

}





