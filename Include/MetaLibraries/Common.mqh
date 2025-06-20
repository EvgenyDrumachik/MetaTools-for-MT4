//+------------------------------------------------------------------+
//| Functions common for Meta Tools and Trader.exe                     |
//| These automonous variables and functions that do not work with global variables|
//| See library of useful functions here: https://www.forexfactory.com/showthread.php?t=165557
//+------------------------------------------------------------------+
  
  
  
//+------------------------------------------------------------------+
//|          ENUM's                                                  |
//+------------------------------------------------------------------+
enum StrategyID {
   BF = 0,           // BF
   D1 = 1,           // D1
   S3 = 2,           // S3
   Stratezhka = 3,   // Stratezhka
   FourStrings = 4,  // Four Strings
   Other = 5,        // Other
   //AutoDetect = 4  // AutoDetect
};

enum DayPriorityID {
   None = 0, // None
   Buy  = 1, // Buy
   Sell = 2, // Sell
};

enum Account_Number {
   BF_Demo_Main = 12387063,
   BF_2_Demo = 12387066,
   BF_Standard_Real = 6594361,
   D1_Demo = 12387065,
   S3_ECN_PRO_Demo = 29808559,  
   S3_ECN_PRO_Real = 5858293,
   D1_Real_Cent_F4U = 2643501
};

enum PinBarType {
   Bearish, // Bearish Pin Bar
   Bullish,  // Bullish Pin Bar
   NotPinBar // Not Pin Bar
};


enum TrendType {
   BearishTrend, // Bearish Trend
   BullishTrend, // Bullish Trend
   HorizontalTrend, // Horizontal Trend
   VerticalTrend,// Vertical Trend
   ErrorTrend
};

enum Probability {
   HighProbability = 2,    // High Probability
   LowProbability  = 1,    // Low Probability
   NormalProbability = 3,  // Normal Probability
   NoProbability   = 0,    // No Probability
};
   
   
   

enum TradeDirectionType {
   Sell_Level = 0, // Sell Level
   Buy_Level  = 1,  // Buy Level
   None_Level = 2 // None Level
};

enum TradeDir {
   TradeDir_BUY = 0, // Buy
   TradeDir_SELL = 1, // Sell
   TradeDir_NONE = 2, // None
};


enum ChartCheckNeeded {
   Not_Needed        = 0, // Not Needed
   S3_Impulse        = 1, // S3 Impulse
   Pin_Bar           = 2, // Pin Bar
   ChartCheckMissed  = 3, // Chart Check Missed
   PositionThreat    = 4, // Possible Bar that threatenes current position
};

enum ImpulseType {
   Buy_Impulse     = 0,
   Sell_Impulse    = 1,
   No_Impulse      = 2,
};


enum SnapTo {
   Extremums         = 0, // Extremums
   Bodies            = 1, // Bodies
   NoSnapping        = 2, // No Snapping
};

enum NewsImpact {

   No_News           = 0, // None
   All_Impact        = 1, // All News
   Low_Impact        = 2, // Low
   Medium_Impact     = 3, // Medium
   High_Impact       = 4, // High
   Medium_and_High   = 5, // Medium & High
};


struct CalendarEvent {
   string   title;
   string   country;
   datetime time;
   string   impact;
   string   forecast;
   string   previous;
};



  
//+------------------------------------------------------------------+
//| Defines                                                          |
//+------------------------------------------------------------------+

// *** User Interface Control *****************
#define INDENT_LEFT                         (5)      // indent from left (with allowance for border width)
#define INDENT_TOP                          (5)      // indent from top (with allowance for border width)
#define CONTROLS_GAP_X                      (5)       
#define CONTROLS_GAP_Y                      (5)     
#define BUTTON_WIDTH_NARROW                 (18)    
#define BUTTON_WIDTH_NORMAL                 (33)    
#define BUTTON_WIDTH_WIDE                   (70)    
#define BUTTON_WIDTH_DOUBLE                 (100)   
#define BUTTON_HEIGHT                       (20)      
#define WINDOW_DEFAULT_WIDTH                (165)
#define WINDOW_DEFAULT_HEIGHT               (400)
// ************************************************


#define WM_MDIMAXIMIZE  0x0225
#define WM_MDIGETACTIVE 0x0229
#define HR1    3600        // 1  * 3600 - for datetime operations
#define HR2400 86400       // 24 * 3600 - for datetime operations
#define HR4800 172800      // 48 * 3600 - for datetime operations

// *** Event types for Trade Manager and Trade.exe *** 
#define TRADE_OPEN_COMMAND                            600   // 
#define TRADE_BREAKEVEN_SET                           601   // 
#define TRADE_OPENED                                  602   // 
#define TRADE_SL_MOVED_TO_BREAKEVEN                   603   //
#define TRADE_EXE_LIVE                                604   //
#define TRADE_EXE_DETACHED                            605   //
#define PSC_HIDE_SHOW_LINES                           607   // 
#define TRADE_EXE_PING                                608   //
#define TRADE_OPEN_FAILED                             609   // 
#define TRADE_BREAKEVEN_UPDATED                       610   // 
#define TRADE_CLOSE_COMMAND                           611   // 
#define TRADE_CLOSED                                  612   // 
#define TRADE_MINLOSS_SET                             613   // 
#define TRADE_TP_MOVED_TO_MINLOSS                     614   // 
#define TRADE_BACKWARDSBREAK_UPDATED                  615   // 
#define CLICK_ORDER_TYPE_BTN                          616   // 
#define ORDER_TYPE_BTN_CLICKED                        617   // 
#define TRADE_TP_MOVE_TO_MINLOSS_FAILED               618   //  
#define TRADE_DELETE_ALL_YESTERDAY_PENDING_4STRINGS   619   // 
#define TRADE_DELETE_ALL_TODAY_PENDING_4STRINGS       620   // 
#define TRADE_DELETE_PENDING_ORDER_OPEN_MARKET_ORDER  621   //
#define TRADE_PENDING_ORDER_DELETED_OPEN_MARKET_ORDER 622   //
#define SETTINGS_CHANGED_BY_METATOOLS                 633   //
#define SETTINGS_CHANGED_BY_TRADE_EXE                 634   //
// ***************************************************

// *** Other commands ***
#define LOAD_LAST_TEMPLATE                            700   // 
#define FIND_H1_LEVELS                                701   // 
#define FIND_D1_BREAKS                                702
#define CLEAR_WATCHLIST                               703   // 
#define HIDE_PSC                                      704   // 
#define CHART_SWITCHED                                705   // sent to a chart once switching on it is done. So, that chart would know it got activated
// ***************************************************

// *** Other events related to Position Size Calculator ***
#define PSC_SET_ACCOUNT_SIZE                          800   //                    
#define PSC_SET_RISK_SIZE                             801
#define PSC_TP_MULT_ALIGN                             802   //
#define PSC_SET_ENTRY_TYPE_INSTANT                    803
#define PSC_SET_ENTRY_TYPE_PENDING                    804
// *********************************************************


// *** News ***
#define NEWS_UPDATED                                  809   // info event from Trade.exe to MetaTools that news were updated
#define UPDATE_NEWS                                   810   // command to update news. Sent by MetaTools to Trade.exe                   
// *********************************************************

// to work with clipboard
#define GMEM_MOVEABLE   2
#define CF_DIB          8
#define SZBITMAPHEADER  14
// //


//+------------------------------------------------------------------+
//| Adoption to MQL5                                                 |
//+------------------------------------------------------------------+
#ifdef __MQL5__
   #define MODE_POINT 11
   #define OBJPROP_TIME1 300
   #define OBJPROP_PRICE1 301
   #define OBJPROP_TIME2 302
   #define OBJPROP_PRICE2 303
   #define OBJPROP_TIME3 304
   #define OBJPROP_PRICE3 305
   #define EMPTY -1
   #define SELECT_BY_POS 0
   #define MODE_BID 9
   #define MODE_ASK 10
   #define MODE_TIME 5
   #define MODE_LOTSIZE 15
   #define MODE_STOPLEVEL 14
   #define MODE_TICKSIZE 17
   #define MODE_TICKVALUE 16
   #define MODE_DIGITS 12
   #define MODE_SWAPLONG 18
   #define MODE_SWAPSHORT 19
   #define MODE_STARTING 20
   #define MODE_EXPIRATION 21
   #define MODE_TRADES 0
   #define MODE_LOTSTEP 24
   #define MODE_MAXLOT 25
   #define MODE_MINLOT 23
   #define MODE_TRADEALLOWED 22
   #define MODE_MARGININIT 29
   #define MODE_MARGINCALCMODE 28
   #define MODE_SWAPTYPE 26
   #define MODE_PROFITCALCMODE 27
   #define MODE_FREEZELEVEL 33
   #define MODE_MARGINHEDGED 31
   #define MODE_MARGINREQUIRED 32
   #define OBJPROP_FIBOLEVELS 200
   #define MODE_MARGINMAINTENANCE 30
   #define ERR_OBJECT_DOES_NOT_EXIST 4202
   
   datetime Time[];
   double   Open[];
   double   High[];
   double   Low[];
   double   Close[];  
   
   // adaptation of order types
   #define OP_BUY         ORDER_TYPE_BUY
   #define OP_SELL        ORDER_TYPE_SELL
   #define OP_BUYLIMIT    ORDER_TYPE_BUY_LIMIT
   #define OP_BUYSTOP     ORDER_TYPE_BUY_STOP
   #define OP_SELLLIMIT   ORDER_TYPE_SELL_LIMIT
   #define OP_SELLSTOP    ORDER_TYPE_SELL_STOP
   
   // arrow codes
   #define SYMBOL_THUMBSUP         67
   #define SYMBOL_THUMBSDOWN       68
   #define SYMBOL_ARROWUP          241
   #define SYMBOL_ARROWDOWN        242
   #define SYMBOL_STOPSIGN         251
   #define SYMBOL_CHECKSIGN        252
#endif 
// ***********************************************


//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
   #import "user32.dll"
      int GetParent(int hWnd);
      int SendMessageW(int hWnd,int Msg,int wParam,int lParam);
      int SendMessageA(int hWnd,int Msg,int wParam,int lParam);
      bool GetWindowPlacement(int hWnd,int & lpwndpl[]); 
      int GetWindowLongA(int hWnd,int GWL_STYLE);
      // to work with clipboard   
      int OpenClipboard(int hOwnerWindow);
      int EmptyClipboard();
      int CloseClipboard();
      int SetClipboardData(int Format, int hMem);
      // // clipboard
   #import
   
   
   #import "stdlib.ex4"
      string ErrorDescription(int error_code);
      int    RGB(int red_value,int green_value,int blue_value);
      bool   CompareDoubles(double number1,double number2);
      string DoubleToStrMorePrecision(double number,int precision);
      string IntegerToHexString(int integer_number);
   #import

   #import "wininet.dll"
      // "wininet.dll" is required by ReadWebPage() function
      #define INTERNET_FLAG_PRAGMA_NOCACHE    0x00000100 // Forces the request to be resolved by the origin server, even if a cached copy exists on the proxy.
      #define INTERNET_FLAG_NO_CACHE_WRITE    0x04000000 // Does not add the returned entity to the cache. 
      #define INTERNET_FLAG_RELOAD            0x80000000 // Forces a download of the requested file, object, or directory listing from the origin server, not from the cache.
     int InternetAttemptConnect (int x);
     int InternetOpenA(string sAgent, int lAccessType, string sProxyName = "", string sProxyBypass = "", int lFlags = 0);
     int InternetOpenUrlA(int hInternetSession, string sUrl, string sHeaders = "", int lHeadersLength = 0, int lFlags = 0, int lContext = 0);
     int InternetReadFile(int hFile, int& sBuffer[], int lNumBytesToRead, int& lNumberOfBytesRead[]);
     int InternetCloseHandle(int hInet);
   #import
   
   
   #import "kernel32.dll"
      int  GlobalAlloc(int Flags, uint Size);
      int  GlobalLock(int hMem);
      int  GlobalUnlock(int hMem);
      int  GlobalFree(int hMem);
      void RtlMoveMemory(int, uint&[], uint);
   #import

//+------------------------------------------------------------------+



  int         broadcastEventID=5000;



   // ****************** TRADE MANAGER ******************
   string      StopLossLineName = "PSC_StopLossLine";
   string      TakeProfitLineName = "PSC_TakeProfitLine";
   string      EntryLineName = "PSC_EntryLine";
   string      BreakEvenLineName = "BreakEvenLine";
   string      BackwardsBreakLineName = "BackwardsBreakLine";
   string      InstantEntryRectName = "InstantEntryRect";
   string      LimitEntryRectName = "LimitEntryRect";
   // ******************************************************

  
//+------------------------------------------------------------------+
//| The function receives the chart width in pixels.                 |
//+------------------------------------------------------------------+
int ChartWidthInPixels() // Common function
  {
//--- prepare the variable to get the property value
   long result=-1;
//--- reset the error value
   ResetLastError();
//--- receive the property value
   if(!ChartGetInteger(ChartID(),CHART_WIDTH_IN_PIXELS,0,result))
     {
      //--- display the error message in Experts journal
      Print(__FUNCTION__+", Error Code = ",GetLastError());
     }
//--- return the value of the chart property
   return((int)result);
  }
  
  
  
  
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int SelectedObjectsCount() // Common function
  {
   int obj_total=ObjectsTotalMQL4(); //total objects count
   int obj_selected; //selected objects count
   obj_selected=0;

   for(int i=0; i<obj_total; i++) 
     { // for each object on the chart
      string objectName=ObjectName(0,i,0,-1);    // getting the object name
      if(ObjectGetMQL4(objectName,OBJPROP_SELECTED)==1) 
        {    // is this object is selected then...
         if (objectName != StopLossLineName && objectName != TakeProfitLineName && objectName != EntryLineName && objectName != BackwardsBreakLineName 
            && objectName != LimitEntryRectName && objectName != InstantEntryRectName && objectName != BreakEvenLineName)
            obj_selected++;
        }
     }
   return obj_selected;
  }
  

void ArrayOfSelectedObjects(string &objects[]) {

   int obj_total=ObjectsTotalMQL4(); //total objects count

   for(int i=0; i<obj_total; i++) 
     { // for each object on the chart
      string objectName=ObjectName(0,i,0,-1);    // getting the object name
      if(ObjectGetMQL4(objectName,OBJPROP_SELECTED)==1) {    // this object is selected then...
         ArrayResize(objects,ArraySize(objects)+1);
         objects[ArraySize(objects)-1] = objectName;
        }
     }
   return;
}  





//+------------------------------------------------------------------+
//|          Watch List Methods                                      |
//+------------------------------------------------------------------+
int GetHoursDelayByChartID(long _ChartID_,string _Symbol_) 
  {

   return int(GlobalVariableGet("WL-" + _Symbol_ + "-" + IntegerToString(_ChartID_)));

  }




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isDobleClick(int id)
  { // Common function
   static ulong clickTimeMemory;
   if(id==CHARTEVENT_CLICK)
     {
      ulong clickTime=GetTickCount();
      if(clickTime<clickTimeMemory+300)
        {
         //Print("Doubleclick");
         clickTimeMemory=0;
         return true;
        }
      else 
        {
         clickTimeMemory=clickTime;
         return false;
        }
     }
   else return false;
  }
  
  
  
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ThisChartActive() { // Common function
   
   // Code detecting, if this chart is now active! Can be used to optimize processor load - do not do most of UI processing and updates, if the chart is not active.
   string symbol = (string)_Symbol;
   int period = (int)_Period;
   int Parent = 0;
   int MyWND  = 0;
   
   #ifdef __MQL5__
      //MyWND  = GetParent(WindowHandleMQL4(symbol,period)); 
      //Parent = GetParent(GetParent(WindowHandleMQL4(symbol,period)));
      //return true;
      if ( !(bool)ChartGetInteger(ChartID(),CHART_BRING_TO_TOP) ) {
         //Print("This Chart is NOT Active");
         return false; 
      }
      else {
         //Print("This Chart is Active");
         return true;
      }
   #else
      MyWND  = GetParent(WindowHandle(symbol,period));
      Parent = GetParent(GetParent(WindowHandle(symbol,period)));
      
      int ActiveMDI=SendMessageA(Parent,WM_MDIGETACTIVE,0,0);
   
      if(ActiveMDI == MyWND ) {
         //Print("ThisChartActive");
         return true;
      }
      else {
         //Print("This Chart is NOT Active");
         return false;
      }
   #endif
  
  }
  
  
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string GetLineNameByTriangle(string TriangleName) 
  { // Common function

   int StartingPosition=StringFind(TriangleName,"Trendline",0); // of the TrendLineName
   string sub_string=StringSubstr(TriangleName,StartingPosition,50);
   StringTrimRight(sub_string);
   return sub_string;
  }
  
  
  
  

  
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CopyObjectProperties(string FromObject,string ToObject) 
  { // Common function

//int TrendWidth = ObjectGetInteger(0,FromTrend,OBJPROP_WIDTH);
//Print("Trend Width = ", TrendWidth);

//ObjectSetInteger(0,ToTrend,OBJPROP_WIDTH,TrendWidth);

   ObjectSetMQL4(ToObject,OBJPROP_TIMEFRAMES,ObjectGetMQL4(FromObject,OBJPROP_TIMEFRAMES));
   ObjectSetMQL4(ToObject,OBJPROP_COLOR,ObjectGetMQL4(FromObject,OBJPROP_COLOR));
   ObjectSetMQL4(ToObject,OBJPROP_STYLE,ObjectGetMQL4(FromObject,OBJPROP_STYLE));
   ObjectSetMQL4(ToObject,OBJPROP_WIDTH,ObjectGetMQL4(FromObject,OBJPROP_WIDTH));

  }




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string GetSymbolByGlobalVariableIndex(int index) 
  {
   string gvar_name=GlobalVariableName(index);
// we consider that symbol name is between the first two dashes, for example: InLWL-EURUSD-12390180329802934
   int first_dash_pos=StringFind(gvar_name,"-",0);
   int second_dash_pos=StringFind(gvar_name,"-",first_dash_pos+1);
   return StringSubstr(gvar_name,first_dash_pos+1,second_dash_pos-first_dash_pos-1);
  }





//+------------------------------------------------------------------+
//| For Trade Manager and Trade.exe                                  |
//+------------------------------------------------------------------+
double GetSL() {
   return ObjectGetDouble(0, StopLossLineName, OBJPROP_PRICE);
}

double GetTP() {
   return ObjectGetDouble(0, TakeProfitLineName, OBJPROP_PRICE);
}

double GetEntryLevel() {
   return ObjectGetDouble(0, EntryLineName, OBJPROP_PRICE);
}


string FindEditObjectByPostfix(const string postfix)
{
	int obj_total = ObjectsTotal(0, 0, OBJ_EDIT);
	string name = "";
	bool found = false;
	for (int i = 0; i < obj_total; i++)
	{
		name = ObjectName(0, i, 0, OBJ_EDIT);
		string pattern = StringSubstr(name, StringLen(name) - StringLen(postfix));
		if (StringCompare(pattern, postfix) == 0)
		{
			found = true;
			break;
		}
	}
	if (found) return(name);
	else return("");
}

//int CountDecimalPlaces(double number)
//{
//   // 100 as maximum length of number.
//   for (int i = 0; i < 100; i++)
//   {
//      if (MathAbs(MathRound(number) - number) / MathPow(10, i) <= FLT_EPSILON) return(i);
//      number *= 10;
//   }
//   return(-1);
//}
//+------------------------------------------------------------------+
//| //   For Trade Manager and Trade.exe                             |
//+------------------------------------------------------------------+




bool DoesObjectExist(string objectName) {
   if(ObjectFind(0,objectName) == -1) return false;
   else return true;
}



//bool IsChartMaximized() {
//
//   int m[11];
//   int p[11];
//   
//   int h=WindowHandle(_Symbol,_Period);
//   int x=GetWindowLongA(h,-8);
//   bool z=GetWindowPlacement(h,m);
//   z=GetWindowPlacement(x,p);
//
//   if(m[9]>p[9] || m[10]>p[10]){
//      return true; 
//   }
//   else{
//      return false; 
//   }
//
//}





//+------------------------------------------------------------------+
//|   Time and Date Functions                                        |
//+------------------------------------------------------------------+
string TimeframeToString(int P) // Common function
  {
   switch(P)
     {
      case PERIOD_M1:  return("M1");
      case PERIOD_M2:  return("M2");
      case PERIOD_M3:  return("M3");
      case PERIOD_M4:  return("M4");
      case PERIOD_M5:  return("M5");
      case PERIOD_M6:  return("M6");
      case PERIOD_M10: return("M10");
      case PERIOD_M12: return("M12");
      case PERIOD_M15: return("M15");
      case PERIOD_M20: return("M20");
      case PERIOD_M30: return("M30");
      case PERIOD_H1:  return("H1");
      case PERIOD_H2:  return("H2");
      case PERIOD_H3:  return("H3");
      case PERIOD_H4:  return("H4");
      case PERIOD_H6:  return("H6");
      case PERIOD_H8:  return("H8");
      case PERIOD_H12: return("H12");
      case PERIOD_D1:  return("D1");
      case PERIOD_W1:  return("W1");
      case PERIOD_MN1: return("MN1");
      default:         return(IntegerToString(P));
     }
  }



//string ErrorCodeToString(int Erro

  

string SymbolAbbreviation(string _symbol) {

   string part1 = StringSubstr(_symbol,0,3); // left currency
   string part2 = StringSubstr(_symbol,3,3); // right currency
   if(part1 == "CHF") part1 = "CH"; 
      else if(part1 == "CAD") part1 = "CA"; 
      else if(part1 == "XAG") part1 = "XG";
      else if(part1 == "XAU") part1 = "XU";
      else part1 = StringSubstr(part1,0,1);
   if(part2 == "CHF") part2 = "CH"; 
      else if(part2 == "CAD") part2 = "CA"; 
      else if(part2 == "SGD") part2 = "SG";
      else if(part2 == "DKK") part2 = "DK";
      else if(part2 == "NOK") part2 = "NO";
      else if(part2 == "SEK") part2 = "SE";
      else if(part2 == "CNH") part2 = "CN";
      else part2 = StringSubstr(part2,0,1);
   
   return part1+"/"+part2;
        
}





int      TimeOfDay(datetime when){
   return (int)when % HR2400;         
}

datetime DateOfDay(datetime when){  
   return when - TimeOfDay(when) ;         
}

datetime Today(){                   
   return DateOfDay( TimeCurrent() );       
}

datetime Tomorrow() {                
   return Today() + HR2400;                 
}

datetime Yesterday(){   
   // returns open time of the previous D1 bar      
   return iTime(NULL, PERIOD_D1, 1);      
}

datetime Today_DateOnly(){   
   // returns open time of current D1 bar      
   return iTime(NULL, PERIOD_D1, 0);      
}



template<typename T>
string NumberToString(T number,int digits = 0,string sep=",")
{
   CString num_str;
   string prepend = number<0?"-":"";
   number=number<0?-number:number;
   int decimal_index = -1;
   if(typename(number)=="double" || typename(number)=="float")
   {
      num_str.Assign(DoubleToString((double)number,digits));
      decimal_index = num_str.Find(0,".");
   }
   else
      num_str.Assign(string(number));
   int len = (int)num_str.Len();
   decimal_index = decimal_index > 0 ? decimal_index : len; 
   int res = len - (len - decimal_index);
   for(int i = res-3;i>0;i-=3)
      num_str.Insert(i,sep);
   return prepend+num_str.Str();
}





int isLeapYear(){
   int _year = YearMQL4();
   if(_year%4 == 0){
      if(_year%400 == 0)return 1;
      if(_year%100 > 0)return 1;
   }
   return 0;
}




int DaysInMonth(int _month) {
   
   switch (_month) {
      case 1:  return 31;
      case 2:  return 28 + isLeapYear();
      case 3:  return 31;
      case 4:  return 30;
      case 5:  return 31; 
      case 6:  return 30;
      case 7:  return 31; 
      case 8:  return 31;
      case 9:  return 30;
      case 10: return 31;
      case 11: return 30;
      case 12: return 31;
   }
   return 0;
}




string DayOfWeekName(int day_number) {

   switch (day_number)
   {
      case 0: return "Sun";
      case 1: return "Mon";
      case 2: return "Tue";
      case 3: return "Wed";
      case 4: return "Thu";
      case 5: return "Fri";
      case 6: return "Sat";
      default: return "Error";
   }
}


string MonthToShortName(short month) {

   switch (month) {
      case 1:  return "Jan";
      case 2:  return "Feb";
      case 3:  return "Mar";
      case 4:  return "Apr";
      case 5:  return "May";
      case 6:  return "Jun";
      case 7:  return "Jul";
      case 8:  return "Aug";
      case 9:  return "Sep";
      case 10: return "Oct";
      case 11: return "Nov";
      case 12: return "Dec";
      default: return "Error";
   }
}





// ******************************************************************************************************************  
// *** NEW WAY OF GENERATING EVENTS *********************************************************************************
// ******************************************************************************************************************
bool GenerateEvent(int event, long lparam = 0, double dparam = 0, string sparam = "") {

   bool result = EventChartCustom(ChartID(),(ushort)event,lparam,dparam,sparam);

   if (!result) { 
      Print("Couldn't generate custom event '" + IntegerToString(event) + "'. Error code: ", GetLastError());
      return false;
   }
   else {
      //Print("Message '", IntegerToString(event), "' is sent. lparam = ", IntegerToString(lparam));
      return true;
   }
}
// ******************************************************************************************************************  
// ******************************************************************************************************************
// ******************************************************************************************************************  
 






  
// ******************************************************************************************************************  
// *** OLD WAY OF GENERATING EVENTS *********************************************************************************
// ******************************************************************************************************************
void SendBroadCastMsg() { // Common function
   ushort customEventID = 0; // Number of the custom event to send
   EventChartCustom(0,CHARTEVENT_CUSTOM,0,0,"New Chart");
   BroadcastEvent(ChartID(),0,"New Chart");
   ChartRedraw();
}
  
void SendBroadCastMsgClearWL() { // Common function
   int customEventID = 0; // Number of the custom event to send
   EventChartCustom(0,CHARTEVENT_CUSTOM,0,0,"ClearWL");
   BroadcastEvent(ChartID(),0,"ClearWL");
   ChartRedraw();
}

void BroadcastEvent(long lparam,double dparam,string sparam) { // Common function
   int eventID1=broadcastEventID-CHARTEVENT_CUSTOM;
   long currChart=ChartFirst(); // Taking ID of the first chart opened in the terminal
   int i=0;
   while(i<CHARTS_MAX) { // We have certainly no more than CHARTS_MAX open charts    
      EventChartCustom(currChart,(ushort)eventID1,lparam,dparam,sparam);  //sending message to that chart
      currChart=ChartNext(currChart); // Taking the next chart
      if(currChart==-1) break;        // Reached the end of the charts list?
      i++;// Proceeding to the next chart in the list of open charts in the terminal
   }
}
// ******************************************************************************************************************  
// ******************************************************************************************************************
// ******************************************************************************************************************  

void BroadcastEvent(ushort evenID,long lparam,double dparam,string sparam) { // Common function

   long currChart=ChartFirst(); // Taking ID of the first chart opened in the terminal
   int i=0;
   while(i<CHARTS_MAX) { // We have certainly no more than CHARTS_MAX open charts    
      EventChartCustom(currChart,(ushort)evenID,lparam,dparam,sparam);  //sending message to that chart
      currChart=ChartNext(currChart); // Taking the next chart
      if(currChart==-1) break;        // Reached the end of the charts list?
      i++;// Proceeding to the next chart in the list of open charts in the terminal
   }

}



  
  
int TimeFrameToObjPropTimeFrame(int period) {

   // returns OBJPROP_TIMEFRAMES

   if (period == PERIOD_D1) return OBJ_PERIOD_D1;
   if (period == PERIOD_H1) return OBJ_PERIOD_H1;
   if (period == PERIOD_H4) return OBJ_PERIOD_H4;
   if (period == PERIOD_M1) return OBJ_PERIOD_M1;
   if (period == PERIOD_M15) return OBJ_PERIOD_M15;
   if (period == PERIOD_M30) return OBJ_PERIOD_M30;
   if (period == PERIOD_M5) return OBJ_PERIOD_M5;
   if (period == PERIOD_MN1) return OBJ_PERIOD_MN1;
   if (period == PERIOD_W1) return OBJ_PERIOD_W1;
   
   else return OBJ_PERIOD_H1;
}




string OrderTypeInPSC_String() {

   string entry_type;
   
   double el = ObjectGetDouble(0, EntryLineName, OBJPROP_PRICE);
   el = NormalizeDouble(el, _Digits);
   double sl = ObjectGetDouble(0, StopLossLineName, OBJPROP_PRICE);
   int ot; // Order Type
   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(_Symbol ,Latest_Price); // Assign current prices to structure 
   
   
   bool selectable = ObjectGetInteger(ChartID(),EntryLineName,OBJPROP_SELECTABLE);
   if (selectable) 
      entry_type = "Pending";
   else
      entry_type = "Instant";

   if (entry_type == "Pending")
   {
      // Sell
      if (sl > el)
      {
         // Stop
         if (el < Latest_Price.bid) {
            ot = OP_SELLSTOP;
            return "Sell Stop";
         }
         // Limit
         else { 
            ot = OP_SELLLIMIT;
            return "Sell Limit";
         }
      }
      // Buy
      else
      {
         // Stop
         if (el > Latest_Price.ask) {
            ot = OP_BUYSTOP;
            return "Buy Stop";
         }
         // Limit
         else { 
            ot = OP_BUYLIMIT;
            return "Buy Limit";
         }
      }
   }
   else // Instant
   {
      // Sell
      if (sl > el) {
         ot = OP_SELL;
         return "Sell";
      }   
      else {   // Buy
         ot = OP_BUY;
         return "Buy";
      }
   }
}






bool CopyScreenshotToClipboard(int width, int height)
{
   bool bReturnvalue = false;

   // Temporary file   
   string strFile = IntegerToString(ChartID()) + IntegerToString(GetTickCount()) + ".bmp";

   // Take screenshot
   if (!ChartScreenShot(0, strFile, width, height)) {
      // Screenshot failed
      Print("Screenshot failed");
   } else {
      // Open file 
      int h = FileOpen(strFile, FILE_BIN | FILE_READ);
      if (h == INVALID_HANDLE) {
         // File open failed
         Print("File '",strFile,"' open failed");
      } else {
         // Get file size
         uint szFile = (uint)FileSize(h);
         
         // Try grabbing ownership of the clipboard 
         if (OpenClipboard(0) == 0) {
            // Failed to open the clipboard
            Print("Failed to open the clipboard");
         } else {
            // Try emptying the clipboard
            if (EmptyClipboard() == 0) {
               // Failed to empty the clipboard
               Print("Failed to empty the clipboard");
            } else {
               // Try allocating a block of global memory to hold the text 
               int hMem = GlobalAlloc(GMEM_MOVEABLE, szFile - SZBITMAPHEADER);         
               if (hMem == 0) {
                  // Memory allocation failed
                  Print("Memory allocation failed");
               } else {

                  // Lock the memory
                  int ptrMem = GlobalLock(hMem);
                  if (ptrMem == 0) {               
                     // Memory lock failed 
                     Print("Memory lock failed");                 
                     GlobalFree(hMem);
                  } else {

                     // Skip past the file header
                     FileSeek(h, SZBITMAPHEADER, SEEK_SET);

                     // Read the file, minus the header, into an array
                     uint arrData[];
                     ArrayResize(arrData, (szFile - SZBITMAPHEADER) / 4);
                     FileReadArray(h, arrData);                     

                     // Copy the array into the memory block, and then release control of the memory
                     RtlMoveMemory(ptrMem, arrData, szFile - SZBITMAPHEADER);
                     GlobalUnlock(hMem);  

                     // Try setting the clipboard contents using the global memory
                     if (SetClipboardData(CF_DIB, hMem) != 0) {
                        // Okay
                        bReturnvalue = true;   

                     } else {
                        // Failed to set the clipboard using the global memory
                        Print("Failed to set the clipboard using the global memory");
                        GlobalFree(hMem);
                     } 
                     CloseClipboard();              
                  }
               }
            }
         }
         FileClose(h);
      }
   
      FileDelete(strFile);
   }
   Print("Screenshot copied to clipboard");
   return bReturnvalue;
}



bool SaveAndCopyScreenshot(string Strategy_Name) {

   string filename=IntegerToString(DayMQL4())+"-"
                           +IntegerToString(MonthMQL4())+"-"
                           +IntegerToString(YearMQL4())+" "+Strategy_Name+" "+_Symbol+" "
                           +TimeToString(TimeCurrent(),TIME_MINUTES)
                           +".gif";
   StringReplace(filename,":","-");
   Print("Saving screenshot to '", filename, "'");
   int height = (int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0);
   int width = (int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0);
   width = width - 400;
   height = height - 50;
      
   int last_error;
   
   //UpdatePositionOfAllButtons(0, ChartWidthInPixels() - 700); // Moving MetaTools to the left to make it visible on the screenshot
 
   bool CopiedToClipboard   = CopyScreenshotToClipboard((int)width,(int)height); // copying the same to clipboard
      last_error = GetLastError();
      if (!CopiedToClipboard) Print("Couldn't copy to clipboard. Error code: ", last_error);
      
   bool SavedOnDisk       = ChartScreenShot(0,filename,width,height,ALIGN_RIGHT);
   //bool SavedOnDisk         = WindowScreenShot(filename,width,height,0);
      last_error = GetLastError();
      if (!SavedOnDisk) Print("Couldn't save screenshot on disk. Error code: ", last_error);
   
   
   //UpdatePositionOfAllButtons(0, X_Delta); // Moving MetaTools back to its original position
   
   
   if(CopiedToClipboard && SavedOnDisk)
      return true;
   else
      return false;
}










bool IsModificationAllowed(string objectName) {
   if (objectName == StopLossLineName 
      || objectName == TakeProfitLineName 
      || objectName == EntryLineName 
      || objectName == BackwardsBreakLineName 
      || objectName == BreakEvenLineName
      || objectName == BreakEvenLineName
      || objectName == InstantEntryRectName
      || objectName == LimitEntryRectName
      )  // do not change Trade Lines
      return false;
   else
      return true;
}









string s_TimeCurrent() {

   string h, m, s;
   if (TimeHourMQL4(TimeCurrent()) < 10) h = "0" + IntegerToString(HourMQL4());
   else h = IntegerToString(HourMQL4());
   
   if (MinuteMQL4() < 10) m = "0" + IntegerToString(MinuteMQL4());
   else m = IntegerToString(MinuteMQL4());
   
   if (TimeSecondsMQL4(TimeCurrent()) < 10) s = "0" + IntegerToString(SecondsMQL4());
   else s = IntegerToString(TimeSecondsMQL4(TimeCurrent()));
   
   return h + ":" + m + ":" + s;

}






void BarInfoIcon(int bar_index, ENUM_TIMEFRAMES period, int arrow_code, color clr, string Description) {

   datetime bar_time;
   // time of the icon depends, if this is the current bar, or not
   // if current - its time coordinate is exactly current server time
   // otherwise, it is opening time of that bar.
   bool s3_icon = false;
   if (arrow_code >= 127 && arrow_code <= 132) s3_icon = true;
   
   if (bar_index == 0 && !s3_icon)
      bar_time = TimeCurrent(); // current bar
   else
      bar_time = iTime(_Symbol,period,bar_index); // a bar somewhere in the past; or this is S3 icon
      
   int random_int = MathRand();  
   string icon_name = "BarInfoIcon #" + IntegerToString(random_int) + ")"; // this enables to have multiple icons for one bar.
   double price = iHigh(_Symbol,period,bar_index);
   Description = s_TimeCurrent() + " " + Description;
   


   if (s3_icon) {
      // but if this is one of these icons - only 1 such icons can be created per bar
      icon_name = "BarInfoIcon #" + IntegerToString(int(bar_time)); // this makes each icon personal to each bar
      // first we seach, if such icon was already created for this bar; if yes - delete it before creating the new one
      if (ObjectFindMQL4(icon_name) >= 0) { // such icon already exists for this bar
         ObjectDelete(0,icon_name);
      }
      price = iLow(_Symbol,period,bar_index);
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


void MessageOnChart(string msg, datetime &MsgOnChartAppearTime) {
   string label_name = "MessageOnChartLabel";
   ObjectDelete(0,label_name);
//
   if (!ObjectCreateMQL4(label_name,OBJ_LABEL,0,0,0)) {
      Print(__FUNCTION__ + ": Failed to create label. Error code: " + IntegerToString(GetLastError()));
      return;
   }
   ObjectSetInteger(0,label_name,OBJPROP_ANCHOR,ANCHOR_LEFT_LOWER);
   ObjectSetMQL4(label_name,OBJPROP_CORNER,0);
   ObjectSetMQL4(label_name,OBJPROP_XDISTANCE,0);
   ObjectSetMQL4(label_name,OBJPROP_YDISTANCE,ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0));
   //ObjectSetInteger(ChartID(),label_name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(ChartID(),label_name,OBJPROP_BACK,true);
   ObjectSetTextMQL4(label_name,msg,18,"verdana",clrBlack);
   MsgOnChartAppearTime = TimeLocal();
   Print("Message displayed on chart: '", msg , "'");
}



string FindObjectByPostfix(const string postfix, const ENUM_OBJECT object_type, long chart_id = 0)
{
	int obj_total = ObjectsTotal(chart_id, 0, object_type);
	string name = "";
	bool found = false;
	for (int i = 0; i < obj_total; i++)
	{
		name = ObjectName(chart_id, i, 0, object_type);
		string pattern = StringSubstr(name, StringLen(name) - StringLen(postfix));
		if (StringCompare(pattern, postfix) == 0) return(name);
	}
	return("");
}



bool isJPY(string symbol = "") {
   if (symbol == "") symbol = _Symbol;
   return StringFind(_Symbol,"JPY")!=-1;
}


bool isCRYPTO(string symbol = "") {

   if (symbol == "") symbol = _Symbol;


   return StringFind(symbol,"BTC")!=-1 || StringFind(symbol,"ETH")!=-1 || StringFind(symbol,"BITCOIN")!=-1 || StringFind(symbol,"AAVE")!=-1 
         || StringFind(symbol,"CARDANO")!=-1 || StringFind(symbol,"RIPPLE")!=-1
         || StringFind(symbol,"DAI")!=-1     || StringFind(symbol,"EOS")!=-1 || StringFind(symbol,"FILECOIN")!=-1 || StringFind(symbol,"LITECOIN")!=-1
         || StringFind(symbol,"MONERO")!=-1  || StringFind(symbol,"POLKADOT")!=-1 || StringFind(symbol,"POLYGON")!=-1 || StringFind(symbol,"UNISWAP")!=-1
         || StringFind(symbol,"CHAINLNK")!=-1;
}

bool isDOGECOIN(string symbol = "") {
   if (symbol == "") symbol = _Symbol;
   return StringFind(symbol,"DOGECOIN")!=-1;
}

bool isSOLANA(string symbol = "") {
   if (symbol == "") symbol = _Symbol;
   return StringFind(symbol,"SOLANA")!=-1;
}



bool isOIL(string symbol = ""){
   if (symbol == "") symbol = _Symbol;
   return symbol == "BRN" || symbol == "WTI" || symbol == "BRENT";
}

bool isGOLD(string symbol = "") {
   if (symbol == "") symbol = _Symbol;
   return StringFind(_Symbol,"XAU")!=-1;
}


bool IsCommodity(string symbol = "") {
   if (symbol == "") symbol = _Symbol;
  if (StringFind(_Symbol,"XAU")!=-1 || StringFind(_Symbol,"XAG")!=-1 || StringFind(_Symbol,"BRN")!=-1 || StringFind(_Symbol,"WTI")!=-1 || StringFind(_Symbol,"BRENT")!=-1) 
      return true;
  else
   return false;
}


bool IsKeyEsc( void )   { return(::TerminalInfoInteger(TERMINAL_KEYSTATE_ESCAPE) < 0); }
bool IsKeyTab( void )   { return(::TerminalInfoInteger(TERMINAL_KEYSTATE_TAB) < 0); }
bool IsKeyCtrl( void )  { return(::TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0); }
bool IsKeyShift( void ) { return(::TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0); }


float ATR(short period, int shift = 1) {

   float atr;

   #ifdef __MQL5__
      atr = (float)MathRound(iATR(_Symbol,PERIOD_D1,period)/_Point);
   #else 
      atr = (float)MathRound(iATR(_Symbol,PERIOD_D1,period,shift)/_Point);
   #endif 
   
  
   if (_Digits == 5) atr = atr/10;
   if (isCRYPTO()) {
      atr = atr/100;
      if (_Symbol == "RIPPLE" || _Symbol == "DOGECOIN" || _Symbol == "SOLANA")
         atr = atr * 100;
   }
   if (isJPY()) atr = atr/10;
   if (isOIL() || isGOLD()) atr = atr/100;

   return atr;

}


double DistFromCurrentPriceToLevel(TradeDirectionType TradeDirection, double LevelPrice) {
   // measures the distance between the current price (bid or ask depending on the BUY / SELL order type)
   // TradeDirectionType: Sell_Level  |  Buy_Level
   
   if (TradeDirection == Buy_Level) {
      return MathAbs( LevelPrice - Ask ) / _Point / 10;
   }
   else if (TradeDirection == Sell_Level) {
      return MathAbs( LevelPrice - Bid ) / _Point / 10;
   }
   else {
      Print(__FUNCTION__ + "Error calling function; TradeDirection is not specified.");
      return 0;
   }

}


double DistBtwTwoPrices(double price1, double price2) {

   double dist = MathAbs(price1 - price2)/_Point/10;
   
   if (isGOLD())        { dist = dist / 1;  }
   else if (isCRYPTO())   { dist = dist / 10; }
   else if (isOIL())      { dist = dist * 10; }
   else if (isDOGECOIN() || isSOLANA()) { dist = dist; }

   return dist;

}


bool IsToday(datetime date) {
   return date >= TimeCurrent()-TimeCurrent()%86400;
}



bool ObjectDeleteSilent(string object_name) {

   return ObjectDeleteSilent(0, object_name);

}


bool ObjectDeleteSilent(long chart_id, string object_name) {

   bool flag = ChartGetInteger(chart_id,CHART_EVENT_OBJECT_DELETE);
   bool result;
   
   if (flag == true) {
      ChartSetInteger(chart_id,CHART_EVENT_OBJECT_DELETE,false);
      result = ObjectDelete(chart_id, object_name);
      ChartSetInteger(chart_id,CHART_EVENT_OBJECT_DELETE,true);   
   }
   
   result = ObjectDelete(chart_id, object_name);

   return result;
}



void ChartID_Last_14_Days_MinMax(long chartid, double &min, double &max) {

   string symbol =   ChartSymbol(chartid);
   min           =   iLow(symbol,PERIOD_D1,0);
   max           =   iHigh(symbol,PERIOD_D1,0);
   
   for (int i = 1; i < 15; i++) {
   
      if (iLow(symbol,PERIOD_D1,i) < min)
         min = iLow(symbol,PERIOD_D1,i);
         
      if (iHigh(symbol,PERIOD_D1,i) > max)
         max = iHigh(symbol,PERIOD_D1,i);
   
   }

}


