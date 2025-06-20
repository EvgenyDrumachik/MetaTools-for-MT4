#include "GraphObject.mqh"
#include "Triangle.mqh"

class CTrend : public CGraphObject
  {
private:
   int               m_type;


public:
                     CTrend(string name) : CGraphObject(name){;}
                     CTrend(void);
                    ~CTrend();
   bool              Create(int mouse_x, int mouse_y);
   void              MakeHorizontal();
   void              Point2_to_end_of_day();
   bool              IsHorizontal();
   void              ToggleRay();
   bool              HasRay();
   void              Ray(bool should_have);
   string            getTypeName() { return("Trend"); }
   //ENUM_LINE_STYLE   GetStyle(); - should be inherite from CGraphObject rather
   bool              IsLockedOnExtremums();
   double            Angle();
   bool              IsSolid();
   void              DashDotDotToSolid();
   void              RestyleOutdatedTrend();
   bool              AutoCreateChannel(long X_Click_Coordinate);
   void              DrawUpdateTriangle(long X_Click_Coordinate);
   void              DeleteTriangle();
   bool              DeleteTriangles();
   void              DeleteChannel();
   void              DeleteLabels();
   void              UpdateStatus();
   void              UpdatePoint2WhenPreliminary();
   void              RestyleLineAsBroken();
   int               FirstPointBarIndex();
   int               SecondPointBarIndex();
   //int               LastBarWhichBrokenTrend();
   string            ChannelName();
   void              SetPointsOnH1Extremums();
   string            GetChannelWidthTextName();
   string            GetChannelWidthTextNameByCorrectionLineName();
  };


CTrend::CTrend(void) {
   //
}


CTrend::~CTrend(){
   //Print("CTrend destructor");
}




bool CTrend::Create(int mouse_x, int mouse_y){

   Name = "Trend Created by MetaTools #" + IntegerToString(MathRand());
   
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
   
   DateTime1 = Mouse_DateTime;
   
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
      DateTime2 = Mouse_DateTime + HR2400;
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
   
   //double screen_height = ChartGetDouble(0,CHART_PRICE_MAX,0) - ChartGetDouble(0,CHART_PRICE_MIN,0);

//   Price1 = Mouse_Price + screen_height * 0.003;
//   Price2 = Mouse_Price - screen_height * 0.003;

   Price1 = Mouse_Price;
   Price2 = Mouse_Price;
   
   
   ResetLastError();
   if(!ObjectCreate(ChartID(),Name,OBJ_TREND,0,DateTime1,Price1,DateTime2,Price2))
     {
      Print(__FUNCTION__,
            ": failed to create a trend! Error code = ",GetLastError());
      return(false);
     }
   ObjectSetInteger(0,Name,OBJPROP_SELECTABLE,true);
   Print("Trend '" + Name + "' is created");
   return true;

}











void CTrend::MakeHorizontal() {
   Print("Making '", Name, "' horizontal.");
   double price1 = ObjectGetDouble(0,Name,OBJPROP_PRICE,0);
   ObjectSetMQL4(Name,OBJPROP_PRICE2,price1);
}


bool CTrend::IsHorizontal(void) {

   double Price1 = ObjectGetDouble(0,Name,OBJPROP_PRICE,0);
   double Price2 = ObjectGetDouble(0,Name,OBJPROP_PRICE,1);
   
   if (Price1 == Price2) return true;
   else return false;
}



void CTrend::ToggleRay() {
   if (ObjectGetMQL4(Name,OBJPROP_RAY) == true)
      ObjectSetMQL4(Name,OBJPROP_RAY,0);  
   else
      ObjectSetMQL4(Name,OBJPROP_RAY,1);  
}


bool CTrend::HasRay() {

   if (ObjectGetMQL4(Name,OBJPROP_RAY) == 1) return true;
   
   else return false;

   //return ObjectGetMQL4(Name,OBJPROP_RAY);
}

void CTrend::Ray(bool should_have) {

   if (should_have) ObjectSetMQL4(Name,OBJPROP_RAY,1);
   else ObjectSetMQL4(Name,OBJPROP_RAY,0);

}


void CTrend::RestyleOutdatedTrend() {
   // works only with solid trendlines, with angles not 0 and not 90

   if(Period()!=PERIOD_H1) return; // restyle lines only when current TF = H1
   if(ObjectTypeMQL4(Name) != OBJ_TREND) return;
   if(ObjectGetMQL4(Name,OBJPROP_STYLE) != STYLE_SOLID) return;
   if(!ObjectGetMQL4(Name,OBJPROP_RAY_RIGHT)) return; // do not do anything for trends without ray
   if(!IsVisibleOnTF(PERIOD_H1)) return; // work only with trends which are visible on H1
   if(!IsLockedOnExtremums()) return; // trend should sit with both control points on High or Low

   double angle = Angle();
   if(angle == 0 || angle == 90) return;

// Finding x1, y1
   int x1,y1;
   long   t1 = ObjectGetInteger(0,Name,OBJPROP_TIME,1);
   double p1 = ObjectGetDouble(0,Name,OBJPROP_PRICE,1);
   ChartTimePriceToXY(0,0,t1,p1,x1,y1);
//------------------

// Finding x2, y2
   int x2,y2;
   long   t2 = TimeCurrent();
   double p2 = GetBid();
   ChartTimePriceToXY(0,0,t2,p2,x2,y2);
//------------------

   int K1=x2-x1;

//Finding y_extr
   double p_extr;
   int StartingBar=iBarShift(Symbol(),Period(),t1,false); // starting from the 2nd control point of the Trend

                                                          //setting starting value for p_extr
   if(angle>0) 
     {
      p_extr=Low[StartingBar];
     }
   else 
     {// (angle <0)
      p_extr=High[StartingBar];
     }

   long t_extr = 0; 
   int  x_extr = 0;
   for(int i=StartingBar; i>=0; i--) 
     { // checking all the bars till the end of the graph, left to right; finding extremum value p_extr
      if(angle>0) 
        {
         if(High[i]>p_extr) { p_extr=High[i]; t_extr=iTime(Symbol(),Period(),i); }
        }
      else 
        {// (angle <0)
         if(Low[i]<p_extr) { p_extr=Low[i];  t_extr=iTime(Symbol(),Period(),i); }
        } // if (angle > 0)
     } // for

// convert p_extr to y_extr
   int y_extr;

   ChartTimePriceToXY(0,0,t_extr,p_extr,x_extr,y_extr);
//Print("p_extr = ", p_extr, "; y_extr = ", y_extr);
// ---------------------------

   int H=MathAbs(y_extr-y1); // absolute (module) height
                             //Print("H = ", H, " / ", NormalizeDouble(MathAbs(p_extr - p1)*10000,1), " pp"); 

   double angle_in_radians=(angle*M_PI)/180;

   double K2=MathAbs(K1*tan(angle_in_radians));
//Print("K2 = ", K2, " / ", NormalizeDouble(MathAbs(p_extr - p1)*10000,1), " pp");

   if(K2>H)
     {
      Print(Name," is outdated. Re-Styling it.");
      //ObjectDeleteSilent(0,Name);
      ObjectSetMQL4(Name,OBJPROP_STYLE,STYLE_DOT);
      ObjectDeleteSilent(ChartID(),"Triangle for "+Name);
     }
   else if(K2==H) 
     {
      //Print("K2 = H");
      return;
     }
   else 
     {
      //Print(Name, " is OK"); // doing nothing
      return;
     }
}





bool CTrend::IsLockedOnExtremums() {

   if(ObjectGetMQL4(Name,OBJPROP_TIME1) == ObjectGetMQL4(Name,OBJPROP_TIME2)) {  // vertical line
      Print(__FUNCTION__, ": Trend is vertical");
      return false; 
   }

   double price1 = Price1();
   double price2 = Price2();
   int Point1_Shift = ObjectGetShiftByValueMQL4(Name,price1); // bar index of the 1st point
   int Point2_Shift = ObjectGetShiftByValueMQL4(Name,price2); // bar index of the 2nd point
   #ifdef __MQL5__
      Point1_Shift++;
      Point2_Shift++;
      InitHighLowOpenCloseArrays(MathMax(Point1_Shift,Point2_Shift));
   #endif 
   if(Point1_Shift>=Bars(_Symbol,_Period) || Point1_Shift<0 || Point2_Shift<0) return true; // for really old / large lines, we assume - they sit on the entremes;


   if ( Point1_Shift >= ArraySize(High) || Point1_Shift >= ArraySize(Low) ) {Print("Point1_Shift is > than Array of Bars Size"); return false; } // error (check to avoid "array out of range" error below)
   if ( Point2_Shift >= ArraySize(High) || Point2_Shift >= ArraySize(Low) ) {Print("Point2_Shift is > than Array of Bars Size"); return false; } // error (check to avoid "array out of range" error below)

   
   bool point1_on_extremum;
   bool point2_on_extremum;
   if(price1 != High[Point1_Shift] && price1 != Low[Point1_Shift]) {  /* Print(Name,": Point 1 doesn't sit on extremum of bar ", IntegerToString(Point1_Shift)); */ point1_on_extremum = false;} else point1_on_extremum = true; 
   if(price2 != High[Point2_Shift] && price2 != Low[Point2_Shift]) {  /* Print(Name,": Point 2 doesn't sit on extremum of bar ", IntegerToString(Point2_Shift)); */ point2_on_extremum = false;} else point2_on_extremum = true; 


   if (!point1_on_extremum || !point2_on_extremum)
      return false;
   else
      return true;
}




double CTrend::Angle() { 
   int x1=0,x2=0;
   int y1=0,y2=0;
   long chart = ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0); // source: https://www.mql5.com/en/forum/152103
   long t1=ObjectGetInteger(0,Name,OBJPROP_TIME,0); // first point of the trend line
   double p1=ObjectGetDouble(0,Name,OBJPROP_PRICE,0);
   long t2=ObjectGetInteger(0,Name,OBJPROP_TIME,1);  // second point of the trend line
   double p2=ObjectGetDouble(0,Name,OBJPROP_PRICE,1);

   //convert time and price to x and y
   ChartTimePriceToXY(0,0,t1,p1,x1,y1);
   ChartTimePriceToXY(0,0,t2,p2,x2,y2);

   int size=(int)chart;
   y1=size-y1;
   y2=size-y2;
   if(x1==x2) { return 90; }
   double angle=(MathArctan(((double)y2-(double)y1)/((double)x2-(double)x1))*180)/M_PI;
   return angle;
}



void CTrend::DeleteTriangle() {
   ObjectDeleteSilent(0,"Triangle for " + Name);
   ObjectDeleteSilent(0,"Triangle for Channel Line " + Name);
}




//+------------------------------------------------------------------+
//| Delete the triangle                                              |
//+------------------------------------------------------------------+
bool CTrend::DeleteTriangles()
  {
//--- reset the error value
   ResetLastError();
//--- delete the triangle
   if(!ObjectDeleteSilent(ChartID(),"Triangle for "+Name))
     {
      //Print(__FUNCTION__,": failed to delete the Triangle for " + Name + "! Error code = ",GetLastError());
      return(false);
     }

   if(!ObjectDeleteSilent(ChartID(),"Triangle for Channel Line "+Name))
     {
      //Print(__FUNCTION__,": failed to delete the Triangle for Channel Line " + Name + "! Error code = ",GetLastError());
      return(false);
     }

   ObjectDeleteSilent(ChartID(),"SL - Triangle for "+Name);
   ObjectDeleteSilent(ChartID(),"SL - Triangle for Channel Line "+Name);
   ObjectDeleteSilent(ChartID(),"TP - Triangle for "+Name);
   ObjectDeleteSilent(ChartID(),"TP - Triangle for Channel Line "+Name);
//--- successful execution
   return(true);
}




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTrend::AutoCreateChannel(long X_Click_Coordinate) {

   if(ObjectTypeMQL4(Name) != OBJ_TREND) return false;
   if(!ObjectGetMQL4(Name,OBJPROP_RAY_RIGHT)) return false; // do not do anything for trends without ray
   if(StringFind(Name,"Channel for")!=-1) return false; // channel itself is cliecked - do nothing
   if(!IsLockedOnExtremums()) {
      Print("Trend is not locked on High / Low of price (CTrend::AutoCreateChannel)");
      LastError = "Trend is not locked on High / Low of price";
      DeleteLabels();
      return false;
     } // trend should sit with both control points on High or Low

   double angle = Angle(); 

//Print("Auto-creating channel...");

// *** first we find extremum p3_new between main control points ***
   TrendType _TrendType=GetTrendType(Name);
   double     p1 = Price1();
   datetime   t1 = DateTime1(); 
   double     p2 = Price2(); 
   datetime   t2 = DateTime2();

   if(p1==p2 || t1==t2) { 
      LastError = "No auto-channel for vertical and horizonal lines";
      Print(LastError); 
      return false; 
    }

   int index1 = iBarShift(Symbol(),Period(),t1,true); // bar of the 1st control point
   int index2 = iBarShift(Symbol(),Period(),t2,true); // bar of the 2nd control point
   if(index1==-1 || index2==-1) {
      LastError = "Error in seach of bars of control points. See log.";
      Print("index1 = ",index1,"; index2 = ",index2,". Exiting function...");
      return false;
   }
   if((index1-index2)<3) { // too small distance between control points.
      LastError = "Too small distance between control points";
      Print(LastError);
      return false;
   }
                                 // *** Check if correction line was broken (even by pin) after 2nd control point. In this case - delete channel line and not create new one
//Print("Trend Type: ", EnumToString(_TrendType),"; index1 = ", index1);
   for(int i=index1-1; i>=0; i--) 
     { // cycle from 2nd control point until current bar
      if(_TrendType==BearishTrend) 
        {
         if(High[i]>ObjectGetValueByShiftMQL4(Name,i,PERIOD_CURRENT)) { 
            ObjectDeleteSilent(0,GetChannelName(Name)); 
            LastError = "Correction Line is already broken - no channel";
            return false; 
         }
        }
      else if(_TrendType==BullishTrend)
      if(Low[i]<ObjectGetValueByShiftMQL4(Name,i,PERIOD_CURRENT)) { 
         ObjectDeleteSilent(0,GetChannelName(Name)); 
         LastError = "Correction Line is already broken - no channel";
         return false; 
      }
     }
// **********************

// 
   int x2,y2;
   ChartTimePriceToXY(0,0,t2,p2,x2,y2);

   if(X_Click_Coordinate<x2) 
     {  // if clicked to the left of the 2nd control point - create / delete the channel
      if(ObjectFindMQL4(GetChannelName(Name))>-1) { // it is already exist
         ObjectDeleteSilent(0,GetChannelName(Name));
         ObjectDeleteSilent(0,GetChannelName(Name)+" Width");
         LastError = "Channel Line Deleted";
         return false;
        }
     }
   else return false; // if click if after the 2nd point - do nothing

                // creating copy of the correction line
   string ChannelName = ChannelName();
   ObjectDeleteSilent(0,GetChannelName(Name));
   ObjectCreate(0,ChannelName,OBJ_TREND,0,(datetime)ObjectGetMQL4(Name,OBJPROP_TIME1),ObjectGetMQL4(Name,OBJPROP_PRICE1));
   CopyObjectProperties(Name,ChannelName);
   ObjectSetMQL4(ChannelName,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(0,ChannelName,OBJPROP_SELECTABLE,true);
   ObjectSetInteger(0,ChannelName,OBJPROP_RAY_RIGHT,true);
   double ch_price1 = ObjectGetMQL4(Name,OBJPROP_PRICE1);
   double ch_price2 = ObjectGetMQL4(Name,OBJPROP_PRICE2);
   ObjectSetMQL4(ChannelName,OBJPROP_TIME1,ObjectGetMQL4(Name,OBJPROP_TIME1));
   ObjectSetMQL4(ChannelName,OBJPROP_TIME2,ObjectGetMQL4(Name,OBJPROP_TIME2));

   //double point=SymbolInfoDouble(Symbol(),SYMBOL_POINT);

   ObjectSetMQL4(ChannelName,OBJPROP_PRICE1,ch_price1);
   ObjectSetMQL4(ChannelName,OBJPROP_PRICE2,ch_price2);

   if(_TrendType==BearishTrend) {
      while(1==1) 
        { // cycle attempts to move the channel line 1 point at a time and check all the bars between 1st and 2nd control points, price touches the line; when it doesn't - move one step back
         ch_price1 = ch_price1 - point_global;
         ch_price2 = ch_price2 - point_global;
         ObjectSetMQL4(ChannelName,OBJPROP_PRICE1,ch_price1);
         ObjectSetMQL4(ChannelName,OBJPROP_PRICE2,ch_price2);
         if(IsTrendLowerThanAllLows(ChannelName)) 
           {
            ch_price1 = ch_price1 + point_global;
            ch_price2 = ch_price2 + point_global;
            break;
           }
        }
     }
   else if(_TrendType==BullishTrend) 
     {
      while(1==1) 
        { // cycle attempts to move the channel line 1 point at a time and check all the bars between 1st and 2nd control points, price touches the line; when it doesn't - move one step back
         ch_price1 = ch_price1 + point_global;
         ch_price2 = ch_price2 + point_global;
         ObjectSetMQL4(ChannelName,OBJPROP_PRICE1,ch_price1);
         ObjectSetMQL4(ChannelName,OBJPROP_PRICE2,ch_price2);
         if(IsTrendHigherThanAllHighs(ChannelName)) 
           {
            ch_price1 = ch_price1 - point_global;
            ch_price2 = ch_price2 - point_global;
            break;
           }
        }
     }

   ObjectSetMQL4(ChannelName,OBJPROP_PRICE1,ch_price1);
   ObjectSetMQL4(ChannelName,OBJPROP_PRICE2,ch_price2);

// measuring channel width and placing text on the chart with value
   double ChannelWidth=MathAbs(p1-ch_price1);
   ChannelWidth=NormalizeDouble(ChannelWidth/point_global/10,0);
   if (_Symbol == "_BRN") ChannelWidth = ChannelWidth * 10;
   string TextName=GetChannelWidthTextNameByChannelName(ChannelName);
   ObjectDeleteSilent(0,TextName);
   ObjectCreate(0,TextName,OBJ_TEXT,0,t1,ch_price1);
   ObjectSetString(0,TextName,OBJPROP_TEXT,DoubleToString(ChannelWidth,0));
   ObjectSetString(0,TextName,OBJPROP_FONT,"Calibri");
   ObjectSetInteger(0,TextName,OBJPROP_FONTSIZE,8);
   ObjectSetInteger(0,TextName,OBJPROP_COLOR,clrGray);
   ObjectSetInteger(0,TextName,OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
   ObjectSetString(0,TextName,OBJPROP_TOOLTIP,DoubleToString(ChannelWidth,0));
   
// *** end of channel measuring

   CTrend channel(ChannelName);
   channel.UpdateStatus();
   LastError = "Channel Line Created";
   return true;
// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
}
  











//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CTrend::DashDotDotToSolid() {

   if(!(Period()==PERIOD_H1)) return; // restyle lines only when current TF = H1
   if(ObjectGetMQL4(Name,OBJPROP_WIDTH)==1) 
     {
      if(ObjectGetMQL4(Name,OBJPROP_STYLE) != STYLE_DASHDOTDOT && ObjectGetMQL4(Name,OBJPROP_STYLE) != STYLE_SOLID) return;
     }
   if(!ObjectGetMQL4(Name,OBJPROP_RAY_RIGHT)) return; // do not do anything for trends without ray
   if(!IsVisibleOnTF(PERIOD_H1)) return; // work only with trends which are visible on H1
   if(!IsLockedOnExtremums()) return; // trend should sit with both control points on High or Low
   double angle = Angle();
//Print("Angle is: ", angle);
//if (angle == 0 || angle == 90) return;

   TrendType TypeOfTrend=GetTrendType(Name);
   double Extremum1,Extremum2;
   int Shift1 = ObjectGetShiftByValueMQL4(Name,ObjectGetDouble(0,Name,OBJPROP_PRICE,0));
   int Shift2 = ObjectGetShiftByValueMQL4(Name,ObjectGetDouble(0,Name,OBJPROP_PRICE,1));
   if(Shift1>Bars(_Symbol,_Period) || Shift1<0) 
     {
      //Print("Point 1 of '",Name,"' is out of range"); 
      return;
     }
   if(Shift2>Bars(_Symbol,_Period) || Shift2<0) 
     {
      //Print("Point 2 of '",Name,"' is out of range"); 
      return;
     }

   bool ChangeStyleToSolid=false;
   bool ChangeStyleToDashDotDot=false;

   if(TypeOfTrend==BearishTrend) 
     { // logic for bearish trend
      // *** FIND Extremum 1 ****
      if (ArraySize(Low) < (Shift1+1) ) { // protecting against 'out of range' fatal error
         Print(__FUNCTION__, ": Error - Cannot find extremum 1 of trend, bars history is not enough");
         return;
      }
      Extremum1 =Low[Shift1];
      for(int i=Shift1; i>=Shift2; i--) 
        {
         if(Low[i]<Extremum1) Extremum1=Low[i];
        }
      // *************************

      // *** FIND Extremum 2 ****
      Extremum2 =Low[Shift2];
      for(int i=Shift2; i>=0; i--) 
        { // cycle from the point 2 of trend until current bar
         if(Low[i]<Extremum2) Extremum2=Low[i];
        }
      // *************************

      // *** Compare extremums
      if(Extremum2<Extremum1) ChangeStyleToSolid=true; else ChangeStyleToDashDotDot=true;
     }
   else if(TypeOfTrend==BullishTrend) 
     { // logic for bullish trend 
      // *** FIND Extremum 1 ****
      if (ArraySize(High) < (Shift1+1) ) { // protecting against 'out of range' fatal error
         Print(__FUNCTION__, ": Error - Cannot find extremum 1 of trend, bars history is not enough");
         return;
      }
      Extremum1 = High[Shift1];
      for(int i=Shift1; i>=Shift2; i--) 
        {
         if(High[i]>Extremum1) Extremum1=High[i];
        }
      // *************************

      // *** FIND Extremum 2 ****
      Extremum2 =High[Shift2];
      for(int i=Shift2; i>=0; i--) 
        { // cycle from the point 2 of trend until current bar
         if(High[i]>Extremum2) Extremum2=High[i];
        }
      // *************************

      // *** Compare extremums
      if(Extremum2>Extremum1) ChangeStyleToSolid=true; else ChangeStyleToDashDotDot=true;
     }

   if(ChangeStyleToSolid) ObjectSetMQL4(Name,OBJPROP_STYLE,STYLE_SOLID);
   if(ChangeStyleToDashDotDot) 
     {
      ObjectSetMQL4(Name,OBJPROP_WIDTH,1);
      ObjectSetMQL4(Name,OBJPROP_STYLE,STYLE_DASHDOTDOT);
      DeleteTriangles();
     }
}
  
  
  
  
  











//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CTrend::DrawUpdateTriangle(long X_Click_Coordinate) {

   if(Strategy==S3 || Strategy==D1) {
      DeleteTriangle();
      return;
   }

   if(_Period!=PERIOD_H1) { return; } // work on H1 only

                                 //Check if this is a trend or channel
   if(ObjectTypeMQL4(Name)!=OBJ_TREND && ObjectTypeMQL4(Name)!=OBJ_CHANNEL) {
      //Print("This '",Name, "' is neither a trend nor channel"); 
      return;
     }
     
   if(ObjectGetMQL4(Name,OBJPROP_STYLE)!=STYLE_SOLID && ObjectGetMQL4(Name,OBJPROP_WIDTH)<2) 
     {
      //Print("The Line is not solid and not bold"); 
      ObjectDeleteSilent(0,"Triangle for "+Name);
      return;
     }

   if(!ObjectGetMQL4(Name,OBJPROP_RAY)) return; // draw triangles only on lines with ray

   //Finding angle of the selected trend line
   int x1=0,x2=0;
   int y1=0,y2=0;
   int chart = (int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0); // source: https://www.mql5.com/en/forum/152103
   long t1=ObjectGetInteger(0,Name,OBJPROP_TIME,0); // first point of the trend line
   double p1=ObjectGetDouble(0,Name,OBJPROP_PRICE,0);
   long t2=ObjectGetInteger(0,Name,OBJPROP_TIME,1);  // second point of the trend line
   double p2=ObjectGetDouble(0,Name,OBJPROP_PRICE,1);

//convert time and price to x and y
   ChartTimePriceToXY(0,0,t1,p1,x1,y1);
   ChartTimePriceToXY(0,0,t2,p2,x2,y2);

// check - where was the click - if before 2nd control point -  do nothing
   if(StringFind(Name,"Channel for")==-1) 
     { // this is not a channel
      if(X_Click_Coordinate!=0) 
        { // for all the calls of this function which do not have X_Click_Coordinate - we draw/update triangle, doesn't matter where the click was.
         if(X_Click_Coordinate<x2 && X_Click_Coordinate>x1) 
           {
            return;
           }
        }
     }
// end of check


   int size=chart;
   y1=size-y1;
   y2=size-y2;
   string text;
   if(x1==x2) { Print("Line is vertical"); return; }
   double angle=(MathArctan(((double)y2-(double)y1)/((double)x2-(double)x1))*180)/M_PI;
   if(angle>=70 || angle<=-70) 
     {
      //Print("Angle is " + DoubleToStr(angle,1) + "° (>=70°). Triangle will not be drawn"); 
      ObjectDeleteSilent(0,"Triangle for "+Name);
      return;
     }
//==========================================

//find triangle points 3 and 4
   string t3_time;
   string t4_time;
   if(angle>=40 || angle<=-40) 
     {
      t3_time = " 09:00";
      t4_time = " 21:00";
     }
   else 
     {
      t3_time = " 04:00";
      t4_time = " 23:00";
     }

// making triangle smaller, if both control poins of trend are within current and previous days
   int OneDay=24*60*60;
   string today;
   if(DayOfWeekMQL4()==6) // Saturday
      today=TimeToString(TimeCurrent()-OneDay,TIME_DATE); // format yyyy.mm.dd
   else if(DayOfWeekMQL4()==0) // Sunday 
   today= TimeToString(TimeCurrent()-2*OneDay,TIME_DATE);
   else today = TimeToString(TimeCurrent(),TIME_DATE);

   string yesterday;
   if(DayOfWeekMQL4()==6) // Saturday
      yesterday=TimeToString(TimeCurrent()-2*OneDay,TIME_DATE);
   else if(DayOfWeekMQL4()==0 || DayOfWeekMQL4()==1) // Sunday or Monday
   yesterday=TimeToString(TimeCurrent()-3*OneDay,TIME_DATE);
   else
      yesterday=TimeToString(TimeCurrent()-OneDay,TIME_DATE);

   datetime time3 = (datetime)ObjectGetMQL4(Name,OBJPROP_TIME1);
   datetime time4 = (datetime)ObjectGetMQL4(Name,OBJPROP_TIME2);
   string s_time3 = TimeToString(time3, TIME_DATE);
   string s_time4 = TimeToString(time4, TIME_DATE);
   bool SmallTriangle=false;

   if((s_time3==today || s_time3==yesterday) && (s_time4==today || s_time4==yesterday)) 
     { // then we make triangle smaller
      SmallTriangle=true;
      t3_time = " 12:00";
      t4_time = " 23:00";
     }
// making triangle smaller -------------------------------------------------------


//
   string s_year  = IntegerToString(YearMQL4());
   string s_month = IntegerToString(MonthMQL4());
   string s_day   = IntegerToString(DayMQL4());
   long t3 = StringToTime(s_year+"."+s_month+"."+s_day+ t3_time); // Time start of today
   long t4 = StringToTime(s_year+"."+s_month+"."+s_day+ t4_time); // Time end of today
   long t3_ch = t3; // same for channel triangle
   long t4_ch = t4; // same for channel triangle


                    //translate t3 into x3; t1 is already in x1
   double p3; // prince of point 3
   double p3_ch; // prince of point 3 for channel triangle
   int SubWindow;
   int x3; // x of point 3
   int y3; // y of point 3
   int x3_ch; // same for channel triangle
   int y3_ch; // same for channel triangle
   ChartTimePriceToXY(0,0,t3,1,x3,y3);
   ChartTimePriceToXY(0,0,t3,1,x3_ch,y3_ch);
   int b2=x3-x1;
   double angle_in_radians=(angle*M_PI)/180;
//Print("angle_in_radians: " + angle_in_radians);
   int a2 = (int)(b2 * tan(angle_in_radians));
   y3    = y1 + a2;
   y3_ch = y1 + a2;

   double p4;
   double p4_ch;
   int x4;
   int y4;
   int x4_ch; // same for channel triangle
   int y4_ch; // same for channel triangle
   ChartTimePriceToXY(0,0,t4,1,x4,y4);
   ChartTimePriceToXY(0,0,t4,1,x4_ch,y4_ch);
   int b3 = x4 - x1;
   int a3 = (int)(b3 * tan(angle_in_radians));
   y4    =y1 + a3;
   y4_ch=y1+a3; // same for channel triangle


                //=========== making space between triangle and line ===========
// for left and right points of triangle
   if(angle>0) 
     {
      y3    = (int)(y3-y3*0.005);
      y4    = (int)(y4-y4*0.01);
      y3_ch = (int)(y3_ch+y3_ch*0.02); // reverse for channel triangle
      y4_ch = (int)(y4_ch+y4_ch*0.018); // reverse for channel triangle

     }
   else
   if(angle<0 && angle>-15) 
     {
      y3    = (int)(y3*1.015);
      y4    = (int)(y4*1.015);
      y3_ch = (int)(y3_ch*0.995);
      y4_ch = (int)(y4_ch*0.995);
     }
   else
   if(angle<-15 && angle>-40) 
     {
      y3    = (int)(y3*1.02);
      y4    = (int)(y4*1.03);
      y3_ch = (int)(y3_ch*0.995);
      y4_ch = (int)(y4_ch*0.995);
     }
   else
   if(angle<-40)
     {
      y3    = (int)(y3*1.03);
      y4    = (int)(y4*1.04);
      y3_ch = (int)(y3_ch*0.99);
      y4_ch = (int)(y4_ch*0.98);
     }
// ==============================================================

//converting x3 and x4 into p3 and p4
   ChartXYToTimePrice(0,x3,chart-y3,SubWindow,t3,p3);
   ChartXYToTimePrice(0,x4,chart-y4,SubWindow,t4,p4);
   ChartXYToTimePrice(0,x3_ch,chart-y3_ch,SubWindow,t3_ch,p3_ch);
   ChartXYToTimePrice(0,x4_ch,chart-y4_ch,SubWindow,t4_ch,p4_ch);

   double p5 = 0; // price for middle point of triangle
   double p5_ch = 0; // price for middle point of channel triangle

                 // =============== SETTING UP THICKNESS (MIDDLE POINT) OF TRIANGLE via p5 variable ====================
// FOR POSITIVE ANGLE (line is up)
//Print("Angle = ", angle);
   if(angle>30) { p5=p3+p3*(angle/200000); p5_ch=p3_ch*1.0010; }
   else
   if(angle>=20) { p5=p3+p3*(angle/900000); p5_ch=p3_ch*1.0008; }
   else
   if(angle<20 && angle>10) { p5=p3-p3*(angle/100000); p5_ch=p3_ch*1.0006; }
   else
   if(angle<10 && angle>0) { p5=p3*0.9998; p5_ch=p3_ch*1.0003; }

// FOR NEGAVTIVE ANGLE (line is looking down)
   if(angle<-30) { p5=p3*0.9999; p5_ch=p3_ch*0.9985; }
   else
   if(angle<=-20) { p5=p3+p3*(angle/900000); p5_ch=p3_ch*0.9992;}
   else
   if(angle>-20 && angle<-10) { p5=p3*1.0001; p5_ch=p3_ch*0.9994; }
   else
   if(angle>-10 && angle<0) { p5=p3*1.0002; p5_ch=p3_ch*0.9997; }

//Print("Angle is " + DoubleToStr(angle,1) + "°");
//=====================================================================================
    
// checking if any resulting price points of the triangle is higher/lower than price of current chart scale; if - do nothing 
   double WinPriceMax = ChartGetDouble(0,CHART_PRICE_MAX,0);
   double WinPriceMin = ChartGetDouble(0,CHART_PRICE_MIN,0);
   if(p3>=WinPriceMax || p3<=WinPriceMin || 
      p4>=WinPriceMax|| p4<=WinPriceMin||
      p5>=WinPriceMax || p5<=WinPriceMin) 
     {
      Print("Triangle points are above / below of max/min of price scale; narrow chart scale and try again.");
      return;
     }
// *** end of check ***

   string TimeShift,TimeShift_ch;
   if(SmallTriangle) 
     {
      TimeShift="19:00";
      TimeShift_ch="16:00";
        } else {
      TimeShift="16:00";
      TimeShift_ch="14:00";
     }

   long t5    = StringToTime(s_year+"."+s_month+"."+s_day+" "+TimeShift); // middle of today, closer to the end
   long t5_ch = StringToTime(s_year+"."+s_month+"."+s_day+" "+TimeShift_ch); // middle of today, closer to the end

//----------------------------------------------------------------------------------------------------------------------------------    
//==========   TRIANGLE FOR THE MAIN TREND LINE   ======================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// first we find the right color, depending on the Buy and Sell buttons
   CTriangle MainTrendTriangle("");
   string TrendLineDesc = ObjectDescriptionMQL4(Name);
   MainTrendTriangle.Color(InpTriangleColor);

   MainTrendTriangle.Name = "Triangle for "+Name;

   //Now, we define - to delete or to create the triangle
   if(DoesObjectExist(MainTrendTriangle.Name) && ObjectGetMQL4(MainTrendTriangle.Name,OBJPROP_COLOR)==InpTriangleColor) {// if there is an orange triangle - we delete
      ObjectDeleteSilent(0,MainTrendTriangle.Name);
   }
   else
      if(!DoesObjectExist(MainTrendTriangle.Name)) {// there is no triangle - we create it
         MainTrendTriangle.Draw(0,MainTrendTriangle.Name,0,t3,p3,t4,p4,t5,p5,InpTriangleColor,STYLE_SOLID,1,true,true,true,false,0);
         ObjectSetMQL4(MainTrendTriangle.Name,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1);
        }

   MainTrendTriangle.UpdateToolTip();
//******************************************************************************************************************************

   string textangle = DoubleToString(angle,1);
   int a = y2-y1;
   int b = x2-x1;
   //text="The Angle of This Line is "+textangle+"°"+" a="+a+"; b="+b+"; b2="+b+"; a2="+a2;
}







//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CTrend::UpdateStatus() {
   int LastBrokenByBarIndex;
   int TimesBroken = TimesBroken(PERIOD_H1,LastBrokenByBarIndex);
   if(Strategy==S3) { /* Print("No line status updates for strategy 'S3'"); */ return; }
   if(StringFind(Name,"#")>-1) return; // this is probably a trade line showing historical trades, no style change is applied.

   string LineStatus="";
   if(TimesBroken==0) 
     {
      LineStatus = "Not broken";
      //ObjectSetMQL4(Name,OBJPROP_STYLE,STYLE_SOLID);
     }

   else if(TimesBroken==1) 
     {
      LineStatus="Broken once, possible entry!";
      //ObjectSetMQL4(Name,OBJPROP_STYLE,STYLE_SOLID);
     }

   else if(TimesBroken>1) 
     {
      if(IsThisChannel(Name)) 
        {  // channel case
         if(TimesBroken>2) 
           {
            LineStatus="Broken more than twice! No entry!";
            RestyleLineAsBroken();
           }
        }
      else 
        { // all other trends, not channels
         LineStatus="Broken more than once! No entry!";
         RestyleLineAsBroken();
        }
     }

   else if(TimesBroken==-1) 
     { //First point is further than available H1 bars
      LineStatus="Unknown";
     }

   //Print("Status of Line ", Name , ": ", LineStatus);
  }
  



int CTrend::FirstPointBarIndex(){
   return iBarShift(Symbol(),PERIOD_H1,DateTime1(),false);
}

int CTrend::SecondPointBarIndex(){
   return iBarShift(Symbol(),PERIOD_H1,DateTime2(),false);
}

  
//int CTrend::TimesBroken() {
//   int TimesBrokenCounter=0;
//   if (!IsVisibleOnTF(Period())) return 0; // if this trend is not visible on the current TF - do not check how many times it is broken, otherwise, bugs / abmiguities are possible (it may be broken on one TF and not broken on another)
//
//// getting index of the bar, from which the trendline starts
//   int StartingBar=SecondPointBarIndex();
//   if(StartingBar>Bars(_Symbol,_Period))  {
//      // Print("Trend '" + Name + "': First point is further than available H1 bars. Load more history. Not checking if line is broken or not.");
//      return -1;
//     }
////Print("Counting from bar: ", StartingBar);
//   double Thicker=_Point*3;
//   //Print("Thicker = ", Thicker);
//   //Print("StartingBar = ", StartingBar);
//   for(int i=StartingBar-1; i>0; i--) {
//      // начинать подсчет со второй опорной точки трендовой линии и продолжать цикл до последнего сформировавшегося бара
//      //(преобразовать time2 -> bar index)
//      double TrendBreakPrice = ObjectGetValueByShiftMQL4(Name,i,PERIOD_CURRENT);
//      if((Open[i]+Thicker)<TrendBreakPrice && (Close[i]-Thicker)>TrendBreakPrice && Close[i+1]<TrendBreakPrice)  { // break bottom-up
//         TimesBrokenCounter++;
//      }
//      if((Open[i]-Thicker)>TrendBreakPrice && (Close[i]+Thicker)<TrendBreakPrice && Close[i+1]>TrendBreakPrice) { // break top-down
//         TimesBrokenCounter++;
//        }
//      if ( (i+1) < ArraySize(Open) && (i+1) < ArraySize(Close) ) { // check to protect against "array out of range"  error  
//         if(Open[i]<TrendBreakPrice && Close[i]<TrendBreakPrice && Close[i+1]>TrendBreakPrice) TimesBrokenCounter++;
//         if(Open[i]>TrendBreakPrice && Close[i]>TrendBreakPrice && Close[i+1]<TrendBreakPrice) TimesBrokenCounter++;
//      }
//     }//for
//   return TimesBrokenCounter;
//}


//int CTrend::LastBarWhichBrokenTrend() {
//   int StartingBar=SecondPointBarIndex();
//   double Thicker=_Point*3;
//   double TrendBreakPrice;
//   
//   for(int i=1; i<StartingBar; i++) {
//      // starting from the last closed bar and going until second control point (excluding bar of the 2nd control point)
//         TrendBreakPrice=ObjectGetValueByShiftMQL4(Name,i,PERIOD_CURRENT);
//         if((Open[i]+Thicker)<TrendBreakPrice && (Close[i]-Thicker)>TrendBreakPrice && Close[i+1]<TrendBreakPrice)  { // break bottom-up
//            return i;
//         }
//         if((Open[i]-Thicker)>TrendBreakPrice && (Close[i]+Thicker)<TrendBreakPrice && Close[i+1]>TrendBreakPrice) { // break top-down
//            return i;
//           }
//         if(Open[i]<TrendBreakPrice && Close[i]<TrendBreakPrice && Close[i+1]>TrendBreakPrice) return i;
//         if(Open[i]>TrendBreakPrice && Close[i]>TrendBreakPrice && Close[i+1]<TrendBreakPrice) return i;
//    }//for
//    return -1;
//}



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CTrend::RestyleLineAsBroken() {
   if (IsVisibleOnTF(PERIOD_D1) || IsVisibleOnTF(PERIOD_H4)) return; // do not restyle higher TF lines
   
   if(ObjectGetMQL4(Name,OBJPROP_STYLE)==STYLE_SOLID && IsVisibleOnTF(PERIOD_H1))  {
      
      ObjectSetMQL4(Name,OBJPROP_WIDTH,1);
      ObjectSetMQL4(Name,OBJPROP_STYLE,STYLE_DASH);
      Description("");
      DeleteTriangles();
   }
}



void CTrend::DeleteChannel(void) {
   ObjectDeleteSilent(0,ChannelName());

}

void CTrend::DeleteLabels(void) {
   ObjectDeleteSilent(0,GetChannelWidthTextName());
   ObjectDeleteSilent(0,GetChannelWidthTextNameByCorrectionLineName());
}


string CTrend::GetChannelWidthTextName() {
   return ChannelName() + " Width";
}

string CTrend::GetChannelWidthTextNameByCorrectionLineName() {
   return Name + " Width";
}


string CTrend::ChannelName() {
   return "Channel for "+Name;
}



void CTrend::UpdatePoint2WhenPreliminary(void) {
   if(ObjectGetInteger(0,Name,OBJPROP_STYLE) != STYLE_DASHDOTDOT) return; // work only with dashdotdot lines
   
   int SecondPointIndex = SecondPointBarIndex(); // index of the bar, on which 2nd point of the trend sits
   
   TrendType _TrendType=GetTrendType(Name);
   
   double NewPriceForSecondPoint = 0;
   datetime NewTimeForSecondPoint = TimeCurrent();
   
   double LowestLow = Low[SecondPointIndex];
   double HighestHigh = High[SecondPointIndex];
   
   if (SecondPointIndex != 0) {
      LowestLow = Low[SecondPointIndex-1];
      HighestHigh = High[SecondPointIndex-1];      
   }
   
   int LowestBarIndex = 0;
   int HighestBarIndex = 0;
  
   
   if (_TrendType == BullishTrend) {
      for (int i = SecondPointIndex -2; i >= 0; i--) { // find lowest low
         if (Low[i] < LowestLow) { LowestLow = Low[i]; LowestBarIndex = i; }
      }
      if (LowestLow <= ObjectGetValueByShiftMQL4(Name,LowestBarIndex)) {
         NewPriceForSecondPoint = LowestLow;
         NewTimeForSecondPoint = iTime(Symbol(),_Period,LowestBarIndex);
      }   
   }
   else if (_TrendType == BearishTrend) {
      for (int i = SecondPointIndex -1; i >= 0; i--) { // find highest high after the 2nd point
         if (High[i] > HighestHigh) { HighestHigh = High[i]; HighestBarIndex = i; }
      }
      if (HighestHigh >= ObjectGetValueByShiftMQL4(Name,HighestBarIndex)) { // the high of the bar is on the line, or higher than the line
         NewPriceForSecondPoint = HighestHigh;
         NewTimeForSecondPoint = iTime(Symbol(),_Period,HighestBarIndex);
      } 
   }
   
   
   if ((LowestBarIndex > 0 || HighestBarIndex > 0) && (NewPriceForSecondPoint>0)) { // if any conditions above triggered, they have gived to either of these variables a non-zero value
      if (_TrendType == BullishTrend && NewPriceForSecondPoint < Price2()) return;
      if (_TrendType == BearishTrend && NewPriceForSecondPoint > Price1()) return;
      ObjectSetDouble(0,Name,OBJPROP_PRICE,1,NewPriceForSecondPoint);
      ObjectSetInteger(0,Name,OBJPROP_TIME,1,NewTimeForSecondPoint);
   }
   
}



void CTrend::Point2_to_end_of_day(){

   int DayOfTomorrow=DayMQL4()+1;
   string s_year = IntegerToString(YearMQL4());
   string s_month = IntegerToString(MonthMQL4());
   string s_day = IntegerToString(DayOfTomorrow);
   datetime NewDateTime2=StringToTime(s_year+"."+s_month+"."+s_day+" "+" 00:00");

   DateTime2(NewDateTime2);

}

void CTrend::SetPointsOnH1Extremums() {
   // works so far to precise trend control points from H4, D1, W1 down to H1; H1 to M1 is not supported so far - see comments below in this method
   
   if (IsHorizontal()) return;

   //first check, if trend points are setting on the current chart extremums
   if (!IsLockedOnExtremums()) { // do not work for such line
      Print("Trend is not locked on extremums. Not updating");
      return; 
   }
   
   if(Period() == PERIOD_MN1 || Period() == PERIOD_M1) return; // doesn't work on M1 and MN1; M1 - no point, MN1 - there can be different number of hours in different months

   ENUM_TIMEFRAMES period = PERIOD_M1; // default resolution
   
   if (Period() == PERIOD_D1 || Period() == PERIOD_W1 || Period() == PERIOD_H4) period = PERIOD_H1; // lower resolution on higher timeframes
   else return; // do not allow any other periods so far. I couldn't achieve stable work on H1 period, probably due to unstable availability of M1 history.

   datetime P1_time_start = DateTime1();
   datetime P2_time_start = DateTime2();
   
   double P1_Price = Price1();
   double P2_Price = Price2();
   
   int P1_M1_start_bar = iBarShift(Symbol(),period,P1_time_start);
   int P2_M1_start_bar = iBarShift(Symbol(),period,P2_time_start);
   
   if ( BarIndexOfDateTime1() > ChartGetInteger(0,CHART_VISIBLE_BARS,0) ) { Print("Point 1 is too far into history"); return; }
   
   //Print("P1_M1_start_bar = ", P1_M1_start_bar);
   //Print("P2_M1_start_bar = ", P2_M1_start_bar);
   
   int P1_M1_end_bar = 0;
   int P2_M1_end_bar = 0;
   
   // defining end bar, depending on the current TF
   if      (Period() == PERIOD_H1)    { P1_M1_end_bar = P1_M1_start_bar - 60;  P2_M1_end_bar = P2_M1_start_bar - 60;  }
   else if (Period() == PERIOD_D1)    { P1_M1_end_bar = P1_M1_start_bar - 24;  P2_M1_end_bar = P2_M1_start_bar - 24;  }
   else if (Period() == PERIOD_H4)    { P1_M1_end_bar = P1_M1_start_bar - 4;   P2_M1_end_bar = P2_M1_start_bar - 4;   }
   else if (Period() == PERIOD_W1)    { P1_M1_end_bar = P1_M1_start_bar - 120; P2_M1_end_bar = P2_M1_start_bar - 120; }
   else if (Period() == PERIOD_M30)   { P1_M1_end_bar = P1_M1_start_bar - 30;  P2_M1_end_bar = P2_M1_start_bar - 30;  }
   else if (Period() == PERIOD_M15)   { P1_M1_end_bar = P1_M1_start_bar - 15;  P2_M1_end_bar = P2_M1_start_bar - 15;  }
   else if (Period() == PERIOD_M5)    { P1_M1_end_bar = P1_M1_start_bar - 5;   P2_M1_end_bar = P2_M1_start_bar - 5;   }
   
   
   TrendType TypeOfTrend = GetTrendType(Name);
   
   int P1_NewBar = P1_M1_start_bar;
   int P2_NewBar = P2_M1_start_bar;
   
   double P1_lowest_low = iLow(Symbol(),period,P1_M1_start_bar);
   double P1_highest_high = iHigh(Symbol(),period,P1_M1_start_bar);
   double P2_lowest_low = iLow(Symbol(),period,P2_M1_start_bar);
   double P2_highest_high = iHigh(Symbol(),period,P2_M1_start_bar);
   
   if (TypeOfTrend==BearishTrend) { // search for highs on M1
      for (int i = P1_M1_start_bar; i > P1_M1_end_bar; i--) {// for 1st control point of trend; for each M1 bar
         if(iHigh(Symbol(),period,i) > P1_highest_high) { P1_highest_high = iHigh(Symbol(),period,i); P1_NewBar = i; }
      }
      DateTime1(iTime(Symbol(),period,P1_NewBar)); // shifting datetime of the 1st point to the new position.

      for (int i = P2_M1_start_bar; i > P2_M1_end_bar; i--) {// for 2nd control point of trend; for each M1 bar
         if(iHigh(Symbol(),period,i) > P2_highest_high) { P2_highest_high = iHigh(Symbol(),period,i); P2_NewBar = i; }
      }
      DateTime2(iTime(Symbol(),period,P2_NewBar)); // shifting datetime of the 1st point to the new position.
      Print("Control points of ",Name," updated");
   }
   else if (TypeOfTrend==BullishTrend) { // search for lows on M1
      for (int i = P1_M1_start_bar; i > P1_M1_end_bar; i--) {// for 1st control point of trend; for each M1 bar
         if(iLow(Symbol(),period,i) < P1_lowest_low) { P1_lowest_low = iLow(Symbol(),period,i); P1_NewBar = i; }
      }
      //Print("P1_NewBar = ", P1_NewBar);
      DateTime1(iTime(Symbol(),period,P1_NewBar)); // shifting datetime of the 1st point to the new position.

      for (int i = P2_M1_start_bar; i > P2_M1_end_bar; i--) {// for 2nd control point of trend; for each M1 bar
         if(iLow(Symbol(),period,i) < P2_lowest_low) { P2_lowest_low = iLow(Symbol(),period,i); P2_NewBar = i; }
      }
      //Print("P2_NewBar = ", P2_NewBar);
      DateTime2(iTime(Symbol(),period,P2_NewBar)); // shifting datetime of the 1st point to the new position.
      Print("Control points of ",Name," updated");
   }
}


bool CTrend::IsSolid(void) {

   return bool(ObjectGetInteger(0,Name,OBJPROP_STYLE) == STYLE_SOLID);

}



