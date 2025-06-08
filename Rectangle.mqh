class CRectangle : public CGraphObject
  {
private:

public:
                     CRectangle(string name) : CGraphObject(name){;}
                     CRectangle()            : CGraphObject(){;}
                     ~CRectangle(void);

   void              AutoColor(bool is_S_Version, CLevel &levels[]);
   void              AutoColor(bool is_S_Version);
   bool              Create(string name, datetime DateTime1, double Price1, datetime DateTime2, double Price2); 
   //bool              CreateLevel(int mouse_x, int mouse_y);    
   void              ToggleRectangleFill();   
   void              SetRectangleFill(bool fill);
   bool              HighlightCandleAtCursor(int mouse_x, int mouse_y); 
   static void       UpdateH4Shadow(); 
   float             GetSidesRatio();           
  };

CRectangle::~CRectangle(void)
  {
  }
//+------------------------------------------------------------------+








bool CRectangle::Create(string name, datetime DateTime1, double Price1, datetime DateTime2, double Price2) {

   ResetLastError();
   if(!ObjectCreate(ChartID(),name,OBJ_RECTANGLE,0,DateTime1,Price1,DateTime2,Price2))
     {
      Print(__FUNCTION__,
            ": failed to create new rectangle '" + name + "'! Error code = ",GetLastError());
      return(false);
     }

   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,true, true);
   //Print("Rectangle '" + name + "' is created");
   return true;

}




bool CRectangle::HighlightCandleAtCursor(int mouse_x, int mouse_y) {

   this.Name = "Highlight Created by MetaTools #" + IntegerToString(MathRand());
   
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
   
   DateTime1 = Mouse_DateTime - 60*Period();
   DateTime2 = Mouse_DateTime + 60*Period();
   int index = iBarShift(Symbol(),Period(),Mouse_DateTime,true);
   if (index == -1) { // bar is not found
      Print("No bar is highlighted. Point mouse cursor to a bar and then press Shift");
      return false; 
   }
   Price1 = iHigh(Symbol(),Period(),index);
   Price2 = iLow(Symbol(),Period(),index);
   
   
   ResetLastError();
   if(!ObjectCreate(ChartID(),this.Name,OBJ_RECTANGLE,0,DateTime1,Price1,DateTime2,Price2))
     {
      Print(__FUNCTION__,
            ": failed to create new candle-highlighter '" + this.Name + "'! Error code = ",GetLastError());
      return(false);
     }

   //ObjectSetInteger(0,this.Name,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   //ObjectSetInteger(0,this.Name,OBJPROP_TIMEFRAMES,PERIOD_H1);
   if (Period() == PERIOD_H1)
      ObjectSetMQL4(this.Name, OBJPROP_TIMEFRAMES, OBJ_PERIOD_H1 | OBJ_PERIOD_M30 | OBJ_PERIOD_M15 | OBJ_PERIOD_M5 | OBJ_PERIOD_M1);
   else if (Period() == PERIOD_H4)
      ObjectSetMQL4(this.Name, OBJPROP_TIMEFRAMES, OBJ_PERIOD_H4);
   else if (Period() == PERIOD_D1)
      ObjectSetMQL4(this.Name, OBJPROP_TIMEFRAMES, OBJ_PERIOD_D1);  
   else
      ObjectSetMQL4(this.Name, OBJPROP_TIMEFRAMES, Period());        
      
      
      
   this.Color(clrGold);
   Print("Highlight '" + this.Name + "' is created");
   return true;
}


void CRectangle::AutoColor(bool is_S_Version) {

   CLevel dummy[];
   this.AutoColor(is_S_Version,dummy);

}


float CRectangle::GetSidesRatio() {

      int x1, x2, y1, y2;
      
      ChartTimePriceToXY(0,0,this.DateTime1(),this.Price1(),x1,y1);
      ChartTimePriceToXY(0,0,this.DateTime2(),this.Price2(),x2,y2);
      
      // dimensions of the rectangle
      float width  = (float)MathAbs(x1-x2);
      float height = (float)MathAbs(y1-y2);
      
      float ratio;
      if (height == 0) 
         ratio = 0;
      else
         ratio = width / height;

      //Print("ratio = " + DoubleToStr(ratio,3));
      return ratio;     

}


void CRectangle::AutoColor(bool is_S_Version, CLevel &levels[]) {

   //Print("Auto coloring '" + this.Name + "'");
   
//   int x1, x2, y1, y2;
//   
//   ChartTimePriceToXY(0,0,this.DateTime1(),this.Price1(),x1,y1);
//   ChartTimePriceToXY(0,0,this.DateTime2(),this.Price2(),x2,y2);
//   
//   // dimensions of the rectangle
//   int width  = MathAbs(x1-x2);
//   int height = MathAbs(y1-y2);
//   
//   // ratio between rectangle sides; squary has ratio = 1
//   // ratio of > 1 - for horizontal levels
//   // ratio of < 1 - for vertical boxes (candles highlight)
//   float ratio;
//   if (height == 0) 
//      ratio = 0;
//   else
//      ratio = float(width / height);
   
   
   float ratio = this.GetSidesRatio();
   
   color new_color = clrBlack;
   
   if (ratio > 1) {
      // horizontal box
      
      if (Period() == PERIOD_D1 || Period() == PERIOD_W1 || Period() == PERIOD_MN1)
         new_color = MN1_D1_Rectangle_Level_color;
      else if ( Period() == PERIOD_H4 )
         new_color = H4_Rectable_Level_color;
      else
         new_color = M1_H1_Rectangle_Level_color;
      
   }
   else if (ratio < 1) {
      // vertical box
      if (Period() == PERIOD_H1) {
           double time_diff = double(MathAbs((this.DateTime1() - this.DateTime2())/3600)-1);
           Print("time_diff = ", DoubleToString(time_diff,3));
           if ( (time_diff > 5) && (ArraySize(levels) > 0) ) { // time difference between points is more than 5 hours (5 candles); and there are buy / sell formalized levels on the chart
               // larger box is being built
               // 1) find upper and lower edges of the rectangle
               double upper_edge = MathMax(this.Price1(),this.Price2());
               double lower_edge = MathMin(this.Price1(),this.Price2());
               //Print("upper_edge = ", DoubleToString(upper_edge,5));
               //Print("lower_edge = ", DoubleToString(lower_edge,5));
               int upper_edge_y;
               int lower_edge_y;
               int x;
               ChartTimePriceToXY(0,0,this.DateTime1(),upper_edge,x,upper_edge_y);
               ChartTimePriceToXY(0,0,this.DateTime2(),lower_edge,x,lower_edge_y);
               Print("upper_edge_y = ", upper_edge_y);
               Print("lower_edge_y = ", lower_edge_y);
               int margin = 20; // +/- pixels of where the level will be searched; if found the in that range - will be considered as aligned to the edge
               int upper_edge_y_min = upper_edge_y - margin;
               int upper_edge_y_max = upper_edge_y + margin;
               int lower_edge_y_min = lower_edge_y - margin;
               int lower_edge_y_max = lower_edge_y + margin;
               
               // 2) cycle through all the registered levels and find those where upper or lower edge is close (within the margin)
               for (int i = 0; i < ArraySize(levels); i++) {
                  int level_y = levels[i].y(); // y coordinate of the level
                  //Print("Level[",i,"], price: ", DoubleToString(levels[i].Price(),5), "; y = ", IntegerToString(level_y));
                  if (levels[i].TradeDirection == Buy_Level) {
                     // check if the level is at the upper_edge of the box
                     //Print("Buy level found");
                     //Print("Level Price: ", DoubleToString(levels[i].Price(),5));
                     //Print("level_y = ", level_y);
                     if (level_y < upper_edge_y_max && level_y > upper_edge_y_min) {
                        new_color = clrLawnGreen;
                        Print("New color assigned: ", ColorToString(new_color,true));
                        break;
                     }
                  }
                  else if (levels[i].TradeDirection == Sell_Level) {
                     // check if the level is at the lower_edge of the box   
                     Print("Sell level found");
                     if (level_y < lower_edge_y_max && level_y > lower_edge_y_min) {
                        new_color = clrPink;
                        Print("New color assigned: ", ColorToString(new_color,true));
                        break;
                     }
                  }
                  else continue;
               } // for
               
               // if after the 'for' cycle no color was assigned - applying standard color
               if (new_color == NULL) {
                  Print("no levels found close - applying standard color for vertical boxes on H1");
                  new_color = clrGold;
               }
           }
           else 
            // smaller box - for patterns selections (up to 5 candles)
            new_color = clrGold;
      }
      else { // any other periods
         new_color = clrGold;
      }
   }
   
  
   if (ratio != 1) {
      //Print("Setting new color '", ColorToString(new_color,true),"'");
      this.Color(new_color);
   }
   
   return;
}


void CRectangle::ToggleRectangleFill() {

   if (ObjectGetInteger(0,this.Name,OBJPROP_BACK) == true)
      ObjectSetInteger(0,this.Name,OBJPROP_BACK,false);  
   else
      ObjectSetInteger(0,this.Name,OBJPROP_BACK,true);   
}

void CRectangle::SetRectangleFill(bool fill) {

   if (fill)
      ObjectSetInteger(0,this.Name,OBJPROP_BACK,true); 
   else
      ObjectSetInteger(0,this.Name,OBJPROP_BACK,false); 

}







