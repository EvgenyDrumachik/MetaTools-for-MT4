class CCrosshair : public CGraphObject
  {
private:
   bool     CreateLines();
   string   V_Line_Name;
   string   H_Line_Name;
   color    CrosshairColor;

public:
                     CCrosshair();
                    ~CCrosshair();
   void     ShowAtInitialPosition();
   void     Hide();
   bool     Move(int x, int y);
   bool     IsVisibleOnTF(int TimeFrame);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCrosshair::CCrosshair()
  {
  
   V_Line_Name = "Crosshair_V_Line";
   H_Line_Name = "Crosshair_H_Line";
   CrosshairColor = clrGray;
   this.CreateLines();
  
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCrosshair::~CCrosshair()
  {
  }
//+------------------------------------------------------------------+


bool CCrosshair::IsVisibleOnTF(int TimeFrame) {

   CGraphObject obj(V_Line_Name);
   if ( obj.IsVisibleOnTF(TimeFrame) )
      return true;
   else
      return false;
}


bool CCrosshair::CreateLines(void) {

   double middle_screen_price = (ChartGetDouble(0,CHART_PRICE_MAX,0) + ChartGetDouble(0,CHART_PRICE_MIN,0)) / 2;
   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(Symbol() ,Latest_Price); // Assign current prices to structure 
   double price = Latest_Price.bid;
   price = (price + middle_screen_price) / 2;
   datetime time  = TimeCurrent();
   
   //Print("price when created: ", price);

   if ( ObjectFindMQL4(H_Line_Name) < 0 ) {  // if not yet exist
      if(!ObjectCreate(0,H_Line_Name,OBJ_HLINE,0,0,price)) {
         Print(__FUNCTION__, ": failed to create a horizontal line! Error code = ",GetLastError());
         return(false);
      }
   }
   ObjectSetInteger(0,H_Line_Name,OBJPROP_COLOR,CrosshairColor);
   ObjectSetInteger(0,H_Line_Name,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(0,H_Line_Name,OBJPROP_WIDTH,1);
   ObjectSetInteger(0,H_Line_Name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,H_Line_Name,OBJPROP_SELECTED,false);
   

   if ( ObjectFindMQL4(V_Line_Name) < 0 ) {   // if not yet exist
      if ( !ObjectCreate(0,V_Line_Name,OBJ_VLINE,0,time,0) ) {
         Print(__FUNCTION__, ": failed to create a vertical line! Error code = ",GetLastError());
         return(false);
      }
   }

   ObjectSetInteger(0,V_Line_Name,OBJPROP_COLOR,CrosshairColor);
   ObjectSetInteger(0,V_Line_Name,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(0,V_Line_Name,OBJPROP_WIDTH,1);
   ObjectSetInteger(0,V_Line_Name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,V_Line_Name,OBJPROP_SELECTED,false); 
   
   this.Hide();
   //Print("Crosshair created");
   return true;
}



void CCrosshair::Hide() {
   ObjectSetMQL4(V_Line_Name,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   ObjectSetMQL4(H_Line_Name,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
}

void CCrosshair::ShowAtInitialPosition() {
   ObjectSetMQL4(V_Line_Name,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
   ObjectSetMQL4(H_Line_Name,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
   ObjectMove(0,V_Line_Name,0,TimeCurrent(),0);
   
   double middle_screen_price = (ChartGetDouble(0,CHART_PRICE_MAX,0) + ChartGetDouble(0,CHART_PRICE_MIN,0)) / 2;
   double price = last_tick.bid;
   price = (price + middle_screen_price) / 2;
   //Print("price = ", price);
   ObjectSetMQL4(H_Line_Name,OBJPROP_PRICE1,price);
}





bool CCrosshair::Move(int x, int y) {

   datetime new_time;
   double new_price;
   int sub_window = 0;
   ChartXYToTimePrice(0,x,y,sub_window,new_time,new_price);

   if(!ObjectMove(0,V_Line_Name,0,new_time,0)) {
      Print(__FUNCTION__,
            ": failed to move the vertical line! Error code = ",GetLastError());
      return(false);
   }
   if(!ObjectMove(0,H_Line_Name,0,0,new_price)) {
      Print(__FUNCTION__,
            ": failed to move the horizontal line! Error code = ",GetLastError());
      return(false);
   }

   return true;
}

