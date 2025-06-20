

class CTriangle : public CGraphObject
  {
private:

public:
                     CTriangle(string name) : CGraphObject(name){;}
                    ~CTriangle();
    bool             Draw (const long chart_ID=0,const string name="Triangle",   // triangle name
                           const int sub_window=0, datetime time1=0, double price1=0, datetime time2=0,
                           double price2=0, datetime time3=0, double price3=0, const color clr=clrRed,
                           const ENUM_LINE_STYLE style=STYLE_SOLID, const int width=1, const bool fill=false,
                           const bool back=false, const bool selection=true, const bool hidden=true, const long z_order=0);
   void                    ChangeTriangleEmptyPoints(datetime &time1,double &price1,
                               datetime &time2,double &price2,
                               datetime &time3,double &price3);
    string           ParentTrendName;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//CTriangle::CTriangle()
//  {
//  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTriangle::~CTriangle()
  {
  }
//+------------------------------------------------------------------+






//+------------------------------------------------------------------+
//| Create triangle by the given coordinates                         |
//+------------------------------------------------------------------+
bool CTriangle::Draw (const long            chart_ID=0,        // chart's ID
           const string          name="Triangle",   // triangle name
           const int             sub_window=0,      // subwindow index 
           datetime              time1=0,           // first point time
           double                price1=0,          // first point price
           datetime              time2=0,           // second point time
           double                price2=0,          // second point price
           datetime              time3=0,           // third point time
           double                price3=0,          // third point price
           const color           clr=clrRed,        // triangle color
           const ENUM_LINE_STYLE style=STYLE_SOLID, // style of triangle lines
           const int             width=1,           // width of triangle lines
           const bool            fill=false,        // filling triangle with color
           const bool            back=false,        // in the background
           const bool            selection=true,    // highlight to move
           const bool            hidden=true,       // hidden in the object list
           const long            z_order=0)         // priority for mouse click
  {
//--- set anchor points' coordinates if they are not set
   ChangeTriangleEmptyPoints(time1,price1,time2,price2,time3,price3);
//--- reset the error value
   ResetLastError();
//--- create triangle by the given coordinates
   if(!ObjectCreate(chart_ID,name,OBJ_TRIANGLE,sub_window,time1,price1,time2,price2,time3,price3))
     {
      Print(__FUNCTION__,
            ": failed to create a triangle! Error code = ",GetLastError());
      return(false);
     }
//--- set triangle color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set style of triangle lines
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- set width of triangle lines
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of highlighting the triangle for moving
//--- when creating a graphical object using ObjectCreate function, the object cannot be
//--- highlighted and moved by default. Inside this method, selection parameter
//--- is true by default making it possible to highlight and move the object
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   ObjectSetMQL4(name,OBJPROP_SELECTED,0);
   return(true);
  }
  
  
  
 
  
  
//+------------------------------------------------------------------+
//| Check the values of triangle's anchor points and set default     |
//| values for empty ones                                            |
//+------------------------------------------------------------------+
void CTriangle::ChangeTriangleEmptyPoints(datetime &time1,double &price1,
                               datetime &time2,double &price2,
                               datetime &time3,double &price3)
  {
//--- if the first point's time is not set, it will be on the current bar
   if(!time1)
      time1=TimeCurrent();
//--- if the first point's price is not set, it will have Bid value
   if(!price1)
      price1=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- if the second point's time is not set, it is located 9 bars left from the second one
   if(!time2)
     {
      //--- array for receiving the open time of the last 10 bars
      datetime temp[10];
      CopyTime(Symbol(),Period(),time1,10,temp);
      //--- set the second point 9 bars left from the first one
      time2=temp[0];
     }
//--- if the second point's price is not set, move it 300 points lower than the first one
   if(!price2)
      price2=price1-300*SymbolInfoDouble(Symbol(),SYMBOL_POINT);
//--- if the third point's time is not set, it coincides with the second point's date
   if(!time3)
      time3=time2;
//--- if the third point's price is not set, it is equal to the first point's one
   if(!price3)
      price3=price1;
  }
  
  
  
  
  
