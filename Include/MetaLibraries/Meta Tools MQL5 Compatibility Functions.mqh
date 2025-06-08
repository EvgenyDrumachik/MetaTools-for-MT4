//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MarketInfoMQL4(string symbol,int type) 
  {
   switch(type) 
     {
      case MODE_LOW:
         return(SymbolInfoDouble(symbol,SYMBOL_LASTLOW));
      case MODE_HIGH:
         return(SymbolInfoDouble(symbol,SYMBOL_LASTHIGH));
      case MODE_TIME:
         return((double)SymbolInfoInteger(symbol,SYMBOL_TIME));
      case MODE_BID:
        {
         //MqlTick last_tick;
         SymbolInfoTick(symbol,last_tick);
         double bid=last_tick.bid;
         return(bid);
        }
      case MODE_ASK:
        {
         //MqlTick last_tick;
         SymbolInfoTick(symbol,last_tick);
         double ask=last_tick.ask;
         return(ask);
        }
      case MODE_POINT:
         return(SymbolInfoDouble(symbol,SYMBOL_POINT));
      case MODE_DIGITS:
         return((double)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
      case MODE_SPREAD:
         return((double)SymbolInfoInteger(symbol,SYMBOL_SPREAD));
      case MODE_STOPLEVEL:
         return((double)SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL));
      case MODE_LOTSIZE:
         return(SymbolInfoDouble(symbol,SYMBOL_TRADE_CONTRACT_SIZE));
      case MODE_TICKVALUE:
         return(SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_VALUE));
      case MODE_TICKSIZE:
         return(SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_SIZE));
      case MODE_SWAPLONG:
         return(SymbolInfoDouble(symbol,SYMBOL_SWAP_LONG));
      case MODE_SWAPSHORT:
         return(SymbolInfoDouble(symbol,SYMBOL_SWAP_SHORT));
      case MODE_STARTING:
         return(0);
      case MODE_EXPIRATION:
         return(0);
      case MODE_TRADEALLOWED:
         return(0);
      case MODE_MINLOT:
         return(SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN));
      case MODE_LOTSTEP:
         return(SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP));
      case MODE_MAXLOT:
         return(SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX));
      case MODE_SWAPTYPE:
         return((double)SymbolInfoInteger(symbol,SYMBOL_SWAP_MODE));
      case MODE_PROFITCALCMODE:
         return((double)SymbolInfoInteger(symbol,SYMBOL_TRADE_CALC_MODE));
      case MODE_MARGINCALCMODE:
         return(0);
      case MODE_MARGININIT:
         return(0);
      case MODE_MARGINMAINTENANCE:
         return(0);
      case MODE_MARGINHEDGED:
         return(0);
      case MODE_MARGINREQUIRED:
         return(0);
      case MODE_FREEZELEVEL:
         return((double)SymbolInfoInteger(symbol,SYMBOL_TRADE_FREEZE_LEVEL));

      default: return(0);
     }
   return(0);
  }
// *** Following code is from STDLIB.mq4 ***
string ErrorDescription(int error_code)
  {
   string error_string;
//---
   switch(error_code)
     {
      //--- codes returned from trade server
      case 0:   error_string="no error";                                                   break;
      case 1:   error_string="no error, trade conditions not changed";                     break;
      case 2:   error_string="common error";                                               break;
      case 3:   error_string="invalid trade parameters";                                   break;
      case 4:   error_string="trade server is busy";                                       break;
      case 5:   error_string="old version of the client terminal";                         break;
      case 6:   error_string="no connection with trade server";                            break;
      case 7:   error_string="not enough rights";                                          break;
      case 8:   error_string="too frequent requests";                                      break;
      case 9:   error_string="malfunctional trade operation (never returned error)";       break;
      case 64:  error_string="account disabled";                                           break;
      case 65:  error_string="invalid account";                                            break;
      case 128: error_string="trade timeout";                                              break;
      case 129: error_string="invalid price";                                              break;
      case 130: error_string="invalid stops";                                              break;
      case 131: error_string="invalid trade volume";                                       break;
      case 132: error_string="market is closed";                                           break;
      case 133: error_string="trade is disabled";                                          break;
      case 134: error_string="not enough money";                                           break;
      case 135: error_string="price changed";                                              break;
      case 136: error_string="off quotes";                                                 break;
      case 137: error_string="broker is busy (never returned error)";                      break;
      case 138: error_string="requote";                                                    break;
      case 139: error_string="order is locked";                                            break;
      case 140: error_string="long positions only allowed";                                break;
      case 141: error_string="too many requests";                                          break;
      case 145: error_string="modification denied because order is too close to market";   break;
      case 146: error_string="trade context is busy";                                      break;
      case 147: error_string="expirations are denied by broker";                           break;
      case 148: error_string="amount of open and pending orders has reached the limit";    break;
      case 149: error_string="hedging is prohibited";                                      break;
      case 150: error_string="prohibited by FIFO rules";                                   break;
      //--- mql4 errors
      case 4000: error_string="no error (never generated code)";                           break;
      case 4001: error_string="wrong function pointer";                                    break;
      case 4002: error_string="array index is out of range";                               break;
      case 4003: error_string="no memory for function call stack";                         break;
      case 4004: error_string="recursive stack overflow";                                  break;
      case 4005: error_string="not enough stack for parameter";                            break;
      case 4006: error_string="no memory for parameter string";                            break;
      case 4007: error_string="no memory for temp string";                                 break;
      case 4008: error_string="non-initialized string";                                    break;
      case 4009: error_string="non-initialized string in array";                           break;
      case 4010: error_string="no memory for array\' string";                              break;
      case 4011: error_string="too long string";                                           break;
      case 4012: error_string="remainder from zero divide";                                break;
      case 4013: error_string="zero divide";                                               break;
      case 4014: error_string="unknown command";                                           break;
      case 4015: error_string="wrong jump (never generated error)";                        break;
      case 4016: error_string="non-initialized array";                                     break;
      case 4017: error_string="dll calls are not allowed";                                 break;
      case 4018: error_string="cannot load library";                                       break;
      case 4019: error_string="cannot call function";                                      break;
      case 4020: error_string="expert function calls are not allowed";                     break;
      case 4021: error_string="not enough memory for temp string returned from function";  break;
      case 4022: error_string="system is busy (never generated error)";                    break;
      case 4023: error_string="dll-function call critical error";                          break;
      case 4024: error_string="internal error";                                            break;
      case 4025: error_string="out of memory";                                             break;
      case 4026: error_string="invalid pointer";                                           break;
      case 4027: error_string="too many formatters in the format function";                break;
      case 4028: error_string="parameters count is more than formatters count";            break;
      case 4029: error_string="invalid array";                                             break;
      case 4030: error_string="no reply from chart";                                       break;
      case 4050: error_string="invalid function parameters count";                         break;
      case 4051: error_string="invalid function parameter value";                          break;
      case 4052: error_string="string function internal error";                            break;
      case 4053: error_string="some array error";                                          break;
      case 4054: error_string="incorrect series array usage";                              break;
      case 4055: error_string="custom indicator error";                                    break;
      case 4056: error_string="arrays are incompatible";                                   break;
      case 4057: error_string="global variables processing error";                         break;
      case 4058: error_string="global variable not found";                                 break;
      case 4059: error_string="function is not allowed in testing mode";                   break;
      case 4060: error_string="function is not confirmed";                                 break;
      case 4061: error_string="send mail error";                                           break;
      case 4062: error_string="string parameter expected";                                 break;
      case 4063: error_string="integer parameter expected";                                break;
      case 4064: error_string="double parameter expected";                                 break;
      case 4065: error_string="array as parameter expected";                               break;
      case 4066: error_string="requested history data is in update state";                 break;
      case 4067: error_string="internal trade error";                                      break;
      case 4068: error_string="resource not found";                                        break;
      case 4069: error_string="resource not supported";                                    break;
      case 4070: error_string="duplicate resource";                                        break;
      case 4071: error_string="cannot initialize custom indicator";                        break;
      case 4072: error_string="cannot load custom indicator";                              break;
      case 4073: error_string="no history data";                                           break;
      case 4074: error_string="not enough memory for history data";                        break;
      case 4075: error_string="not enough memory for indicator";                           break;
      case 4099: error_string="end of file";                                               break;
      case 4100: error_string="some file error";                                           break;
      case 4101: error_string="wrong file name";                                           break;
      case 4102: error_string="too many opened files";                                     break;
      case 4103: error_string="cannot open file";                                          break;
      case 4104: error_string="incompatible access to a file";                             break;
      case 4105: error_string="no order selected";                                         break;
      case 4106: error_string="unknown symbol";                                            break;
      case 4107: error_string="invalid price parameter for trade function";                break;
      case 4108: error_string="invalid ticket";                                            break;
      case 4109: error_string="trade is not allowed in the expert properties";             break;
      case 4110: error_string="longs are not allowed in the expert properties";            break;
      case 4111: error_string="shorts are not allowed in the expert properties";           break;
      case 4200: error_string="object already exists";                                     break;
      case 4201: error_string="unknown object property";                                   break;
      case 4202: error_string="object does not exist";                                     break;
      case 4203: error_string="unknown object type";                                       break;
      case 4204: error_string="no object name";                                            break;
      case 4205: error_string="object coordinates error";                                  break;
      case 4206: error_string="no specified subwindow";                                    break;
      case 4207: error_string="graphical object error";                                    break;
      case 4210: error_string="unknown chart property";                                    break;
      case 4211: error_string="chart not found";                                           break;
      case 4212: error_string="chart subwindow not found";                                 break;
      case 4213: error_string="chart indicator not found";                                 break;
      case 4220: error_string="symbol select error";                                       break;
      case 4250: error_string="notification error";                                        break;
      case 4251: error_string="notification parameter error";                              break;
      case 4252: error_string="notifications disabled";                                    break;
      case 4253: error_string="notification send too frequent";                            break;
      case 4260: error_string="ftp server is not specified";                               break;
      case 4261: error_string="ftp login is not specified";                                break;
      case 4262: error_string="ftp connect failed";                                        break;
      case 4263: error_string="ftp connect closed";                                        break;
      case 4264: error_string="ftp change path error";                                     break;
      case 4265: error_string="ftp file error";                                            break;
      case 4266: error_string="ftp error";                                                 break;
      case 5001: error_string="too many opened files";                                     break;
      case 5002: error_string="wrong file name";                                           break;
      case 5003: error_string="too long file name";                                        break;
      case 5004: error_string="cannot open file";                                          break;
      case 5005: error_string="text file buffer allocation error";                         break;
      case 5006: error_string="cannot delete file";                                        break;
      case 5007: error_string="invalid file handle (file closed or was not opened)";       break;
      case 5008: error_string="wrong file handle (handle index is out of handle table)";   break;
      case 5009: error_string="file must be opened with FILE_WRITE flag";                  break;
      case 5010: error_string="file must be opened with FILE_READ flag";                   break;
      case 5011: error_string="file must be opened with FILE_BIN flag";                    break;
      case 5012: error_string="file must be opened with FILE_TXT flag";                    break;
      case 5013: error_string="file must be opened with FILE_TXT or FILE_CSV flag";        break;
      case 5014: error_string="file must be opened with FILE_CSV flag";                    break;
      case 5015: error_string="file read error";                                           break;
      case 5016: error_string="file write error";                                          break;
      case 5017: error_string="string size must be specified for binary file";             break;
      case 5018: error_string="incompatible file (for string arrays-TXT, for others-BIN)"; break;
      case 5019: error_string="file is directory, not file";                               break;
      case 5020: error_string="file does not exist";                                       break;
      case 5021: error_string="file cannot be rewritten";                                  break;
      case 5022: error_string="wrong directory name";                                      break;
      case 5023: error_string="directory does not exist";                                  break;
      case 5024: error_string="specified file is not directory";                           break;
      case 5025: error_string="cannot delete directory";                                   break;
      case 5026: error_string="cannot clean directory";                                    break;
      case 5027: error_string="array resize error";                                        break;
      case 5028: error_string="string resize error";                                       break;
      case 5029: error_string="structure contains strings or dynamic arrays";              break;
      default:   error_string="unknown error";
     }
//---
   return(error_string);
  }
//+------------------------------------------------------------------+
//| convert red, green and blue values to color                      |
//+------------------------------------------------------------------+
int RGB(int red_value,int green_value,int blue_value)
  {
//--- check parameters
   if(red_value<0)     red_value=0;
   if(red_value>255)   red_value=255;
   if(green_value<0)   green_value=0;
   if(green_value>255) green_value=255;
   if(blue_value<0)    blue_value=0;
   if(blue_value>255)  blue_value=255;
//---
   green_value<<=8;
   blue_value<<=16;
   return(red_value+green_value+blue_value);
  }
//+------------------------------------------------------------------+
//| right comparison of 2 doubles                                    |
//+------------------------------------------------------------------+
bool CompareDoubles(double number1,double number2)
  {
   if(NormalizeDouble(number1-number2,8)==0) return(true);
   else return(false);
  }
//+------------------------------------------------------------------+
//| up to 16 digits after decimal point                              |
//+------------------------------------------------------------------+
string DoubleToStrMorePrecision(double number,int precision)
  {
   static double DecimalArray[17]=
     {
      1.0,
      10.0,
      100.0,
      1000.0,
      10000.0,
      100000.0,
      1000000.0,
      10000000.0,
      100000000.0,
      1000000000.0,
      10000000000.0,
      100000000000.0,
      1000000000000.0,
      10000000000000.0,
      100000000000000.0,
      1000000000000000.0,
      10000000000000000.0
     };

   double rem,integer,integer2;
   string intstring,remstring,retstring;
   bool   isnegative=false;
   int    rem2;
//---
   if(precision<0)  precision=0;
   if(precision>16) precision=16;
//---
   double p=DecimalArray[precision];
   if(number<0.0)
     {
      isnegative=true;
      number=-number;
     }
   integer=MathFloor(number);
   rem=MathRound((number-integer)*p);
   remstring="";
   for(int i=0; i<precision; i++)
     {
      integer2=MathFloor(rem/10);
      rem2=(int)NormalizeDouble(rem-integer2*10,0);
      remstring=IntegerToString(rem2)+remstring;
      rem=integer2;
     }
//---
   intstring=DoubleToString(integer,0);
   if(isnegative)
      retstring="-"+intstring;
   else
      retstring=intstring;

   if(precision>0)
      retstring=retstring+"."+remstring;
//---
   return(retstring);
  }
//+------------------------------------------------------------------+
//| convert integer to string contained input's hexadecimal notation |
//+------------------------------------------------------------------+
string IntegerToHexString(int integer_number)
  {
   string hex_string="00000000";
   int    value,shift=28;
//---
   for(int i=0; i<8; i++)
     {
      value=(integer_number>>shift)&0x0F;
      if(value<10)
         hex_string=(string)StringSetCharacter(hex_string,i,ushort(value+'0'));
      else
         hex_string=(string)StringSetCharacter(hex_string,i,ushort((value-10)+'A'));
      shift-=4;
     }
//---
   return(hex_string);
  }
//+------------------------------------------------------------------+
// *** End of code from STDLIB.mq4 ***


int DayOfWeekMQL4()
  {
   MqlDateTime tm;
   TimeCurrent(tm);
   return(tm.day_of_week);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int YearMQL4()
  {
   MqlDateTime tm;
   TimeCurrent(tm);
   return(tm.year);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int MonthMQL4()
  {
   MqlDateTime tm;
   TimeCurrent(tm);
   return(tm.mon);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int DayMQL4()
  {
   MqlDateTime tm;
   TimeCurrent(tm);
   return(tm.day);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int MinuteMQL4()
  {
   MqlDateTime tm;
   TimeCurrent(tm);
   return(tm.min);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetBid()
  {

   //MqlTick last_tick;
   SymbolInfoTick(_Symbol,last_tick);
   return last_tick.bid;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetAsk()
  {

   //MqlTick last_tick;
   SymbolInfoTick(_Symbol,last_tick);
   return last_tick.ask;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int WindowHandleMQL4(string symbol, // LOOKS LIKE THIS FUNCTION DOESN"T WORK PROPERLY!!! not in MQL5...
                     int tf)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   long currChart,prevChart=ChartFirst();
   int i=0,limit=100;
   while(i<limit)
     {
      currChart=ChartNext(prevChart);
      if(currChart<0) break;
      if(ChartSymbol(currChart)==symbol
         && ChartPeriod(currChart)==timeframe)
         return((int)currChart);
      prevChart=currChart;
      i++;
     }
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ObjectSetTextMQL4(string name,
                       string text,
                       int m_font_size=10,
                       string font="",
                       color text_color=CLR_NONE)
  {
   int tmpObjType=(int)ObjectGetInteger(0,name,OBJPROP_TYPE);
   if(ObjectSetString(0,name,OBJPROP_TEXT,text)==true
      && ObjectSetInteger(0,name,OBJPROP_FONTSIZE,m_font_size)==true)
     {
      if((StringLen(font)>0)
         && ObjectSetString(0,name,OBJPROP_FONT,font)==false)
         return(false);
      if(text_color != CLR_NONE
         && ObjectSetInteger(0,name,OBJPROP_COLOR,text_color)==false)
         return(false);
      return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int TimeMinuteMQL4(datetime date)
  {
   MqlDateTime tm;
   TimeToStruct(date,tm);
   return(tm.min);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int TimeHourMQL4(datetime date)
  {
   MqlDateTime tm;
   TimeToStruct(date,tm);
   return(tm.hour);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int TimeSecondsMQL4(datetime date)
  {
   MqlDateTime tm;
   TimeToStruct(date,tm);
   return(tm.sec);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int TimeDayOfWeekMQL4(datetime date)
  {
   MqlDateTime tm;
   TimeToStruct(date,tm);
   return(tm.day_of_week);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ObjectGetMQL4(string name,int index) 
  {
   switch(index)
     {
      case OBJPROP_TIME1:
         return((double)ObjectGetInteger(0,name,OBJPROP_TIME));
      case OBJPROP_PRICE1:
         return(ObjectGetDouble(0,name,OBJPROP_PRICE));
      case OBJPROP_TIME2:
         return((double)ObjectGetInteger(0,name,OBJPROP_TIME,1));
      case OBJPROP_PRICE2:
         return(ObjectGetDouble(0,name,OBJPROP_PRICE,1));
      case OBJPROP_TIME3:
         return((double)ObjectGetInteger(0,name,OBJPROP_TIME,2));
      case OBJPROP_PRICE3:
         return(ObjectGetDouble(0,name,OBJPROP_PRICE,2));
      case OBJPROP_COLOR:
         return((double)ObjectGetInteger(0,name,OBJPROP_COLOR));
      case OBJPROP_STYLE:
         return((double)ObjectGetInteger(0,name,OBJPROP_STYLE));
      case OBJPROP_WIDTH:
         return((double)ObjectGetInteger(0,name,OBJPROP_WIDTH));
      case OBJPROP_BACK:
         return((double)ObjectGetInteger(0,name,OBJPROP_WIDTH));
      case OBJPROP_RAY:
         return((double)ObjectGetInteger(0,name,OBJPROP_RAY_RIGHT));
      case OBJPROP_RAY_RIGHT:
         return((double)ObjectGetInteger(0,name,OBJPROP_RAY_RIGHT));
      case OBJPROP_ELLIPSE:
         return((double)ObjectGetInteger(0,name,OBJPROP_ELLIPSE));
      case OBJPROP_SCALE:
         return(ObjectGetDouble(0,name,OBJPROP_SCALE));
      case OBJPROP_ANGLE:
         return(ObjectGetDouble(0,name,OBJPROP_ANGLE));
      case OBJPROP_ARROWCODE:
         return((double)ObjectGetInteger(0,name,OBJPROP_ARROWCODE));
      case OBJPROP_TIMEFRAMES:
         return((double)ObjectGetInteger(0,name,OBJPROP_TIMEFRAMES));
      case OBJPROP_DEVIATION:
         return(ObjectGetDouble(0,name,OBJPROP_DEVIATION));
      case OBJPROP_FONTSIZE:
         return((double)ObjectGetInteger(0,name,OBJPROP_FONTSIZE));
      case OBJPROP_CORNER:
         return((double)ObjectGetInteger(0,name,OBJPROP_CORNER));
      case OBJPROP_XDISTANCE:
         return((double)ObjectGetInteger(0,name,OBJPROP_XDISTANCE));
      case OBJPROP_YDISTANCE:
         return((double)ObjectGetInteger(0,name,OBJPROP_YDISTANCE));
      case OBJPROP_FIBOLEVELS:
         return((double)ObjectGetInteger(0,name,OBJPROP_LEVELS));
      case OBJPROP_LEVELCOLOR:
         return((double)ObjectGetInteger(0,name,OBJPROP_LEVELCOLOR));
      case OBJPROP_LEVELSTYLE:
         return((double)ObjectGetInteger(0,name,OBJPROP_LEVELSTYLE));
      case OBJPROP_LEVELWIDTH:
         return((double)ObjectGetInteger(0,name,OBJPROP_LEVELWIDTH));
      case OBJPROP_SELECTED:
         return((double)ObjectGetInteger(0,name,OBJPROP_SELECTED));
      default: return 0;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ObjectSetMQL4(string name,
                   int index,
                   double value)
  {
   switch(index)
     {
      case OBJPROP_TIME1:
         ObjectSetInteger(0,name,OBJPROP_TIME,(int)value);return(true);
      case OBJPROP_PRICE1:
         ObjectSetDouble(0,name,OBJPROP_PRICE,value);return(true);
      case OBJPROP_TIME2:
         ObjectSetInteger(0,name,OBJPROP_TIME,1,(int)value);return(true);
      case OBJPROP_PRICE2:
         ObjectSetDouble(0,name,OBJPROP_PRICE,1,value);return(true);
      case OBJPROP_TIME3:
         ObjectSetInteger(0,name,OBJPROP_TIME,2,(int)value);return(true);
      case OBJPROP_PRICE3:
         ObjectSetDouble(0,name,OBJPROP_PRICE,2,value);return(true);
      case OBJPROP_COLOR:
         ObjectSetInteger(0,name,OBJPROP_COLOR,(int)value);return(true);
      case OBJPROP_STYLE:
         ObjectSetInteger(0,name,OBJPROP_STYLE,(int)value);return(true);
      case OBJPROP_WIDTH:
         ObjectSetInteger(0,name,OBJPROP_WIDTH,(int)value);return(true);
      case OBJPROP_BACK:
         ObjectSetInteger(0,name,OBJPROP_BACK,(int)value);return(true);
      case OBJPROP_RAY:
         ObjectSetInteger(0,name,OBJPROP_RAY_RIGHT,(int)value);return(true);
      case OBJPROP_ELLIPSE:
         ObjectSetInteger(0,name,OBJPROP_ELLIPSE,(int)value);return(true);
      case OBJPROP_SCALE:
         ObjectSetDouble(0,name,OBJPROP_SCALE,value);return(true);
      case OBJPROP_ANGLE:
         ObjectSetDouble(0,name,OBJPROP_ANGLE,value);return(true);
      case OBJPROP_ARROWCODE:
         ObjectSetInteger(0,name,OBJPROP_ARROWCODE,(int)value);return(true);
      case OBJPROP_TIMEFRAMES:
         ObjectSetInteger(0,name,OBJPROP_TIMEFRAMES,(int)value);return(true);
      case OBJPROP_DEVIATION:
         ObjectSetDouble(0,name,OBJPROP_DEVIATION,value);return(true);
      case OBJPROP_FONTSIZE:
         ObjectSetInteger(0,name,OBJPROP_FONTSIZE,(int)value);return(true);
      case OBJPROP_CORNER:
         ObjectSetInteger(0,name,OBJPROP_CORNER,(int)value);return(true);
      case OBJPROP_XDISTANCE:
         ObjectSetInteger(0,name,OBJPROP_XDISTANCE,(int)value);return(true);
      case OBJPROP_YDISTANCE:
         ObjectSetInteger(0,name,OBJPROP_YDISTANCE,(int)value);return(true);
      case OBJPROP_FIBOLEVELS:
         ObjectSetInteger(0,name,OBJPROP_LEVELS,(int)value);return(true);
      case OBJPROP_LEVELCOLOR:
         ObjectSetInteger(0,name,OBJPROP_LEVELCOLOR,(int)value);return(true);
      case OBJPROP_LEVELSTYLE:
         ObjectSetInteger(0,name,OBJPROP_LEVELSTYLE,(int)value);return(true);
      case OBJPROP_LEVELWIDTH:
         ObjectSetInteger(0,name,OBJPROP_LEVELWIDTH,(int)value);return(true);
      case OBJPROP_SELECTED:
         ObjectSetInteger(0,name,OBJPROP_SELECTED,(int)value);return(true);
      default: return(false);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string ObjectDescriptionMQL4(string name)
  {
   return(ObjectGetString(0,name,OBJPROP_TEXT));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_OBJECT ObjectTypeMQL4(string name)
  {
   return((ENUM_OBJECT)ObjectGetInteger(0,name,OBJPROP_TYPE));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ObjectsTotalMQL4(int type=EMPTY,
                     int window=-1)
  {
   return(ObjectsTotal(0,window,type));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ObjectFindMQL4(string name)
  {
   return(ObjectFind(0,name));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_TIMEFRAMES TFMigrate(int tf)
  {
   switch(tf)
     {
      case 0: return(PERIOD_CURRENT);
      case 1: return(PERIOD_M1);
      case 5: return(PERIOD_M5);
      case 15: return(PERIOD_M15);
      case 30: return(PERIOD_M30);
      case 60: return(PERIOD_H1);
      case 240: return(PERIOD_H4);
      case 1440: return(PERIOD_D1);
      case 10080: return(PERIOD_W1);
      case 43200: return(PERIOD_MN1);

      case 2: return(PERIOD_M2);
      case 3: return(PERIOD_M3);
      case 4: return(PERIOD_M4);
      case 6: return(PERIOD_M6);
      case 10: return(PERIOD_M10);
      case 12: return(PERIOD_M12);
      case 16385: return(PERIOD_H1);
      case 16386: return(PERIOD_H2);
      case 16387: return(PERIOD_H3);
      case 16388: return(PERIOD_H4);
      case 16390: return(PERIOD_H6);
      case 16392: return(PERIOD_H8);
      case 16396: return(PERIOD_H12);
      case 16408: return(PERIOD_D1);
      case 32769: return(PERIOD_W1);
      case 49153: return(PERIOD_MN1);
      default: return(PERIOD_CURRENT);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ObjectCreateMQL4(string name,
                      ENUM_OBJECT type,
                      int window,
                      datetime time1,
                      double price1,
                      datetime time2=0,
                      double price2=0,
                      datetime time3=0,
                      double price3=0)
  {
   return(ObjectCreate(0,name,type,window,
          time1,price1,time2,price2,time3,price3));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetIndexStyleMQL4(int index,
                       int type,
                       int style=EMPTY,
                       int width=EMPTY,
                       color clr=CLR_NONE) 
  {
   if(width>-1)
      PlotIndexSetInteger(index,PLOT_LINE_WIDTH,width);
   if(clr!=CLR_NONE)
      PlotIndexSetInteger(index,PLOT_LINE_COLOR,clr);
   switch(type)
     {
      case 0:
         PlotIndexSetInteger(index,PLOT_DRAW_TYPE,DRAW_LINE);
      case 1:
         PlotIndexSetInteger(index,PLOT_DRAW_TYPE,DRAW_SECTION);
      case 2:
         PlotIndexSetInteger(index,PLOT_DRAW_TYPE,DRAW_HISTOGRAM);
      case 3:
         PlotIndexSetInteger(index,PLOT_DRAW_TYPE,DRAW_ARROW);
      case 4:
         PlotIndexSetInteger(index,PLOT_DRAW_TYPE,DRAW_ZIGZAG);
      case 12:
         PlotIndexSetInteger(index,PLOT_DRAW_TYPE,DRAW_NONE);

      default:
         PlotIndexSetInteger(index,PLOT_DRAW_TYPE,DRAW_LINE);
     }
   switch(style)
     {
      case 0:
         PlotIndexSetInteger(index,PLOT_LINE_STYLE,STYLE_SOLID);
      case 1:
         PlotIndexSetInteger(index,PLOT_LINE_STYLE,STYLE_DASH);
      case 2:
         PlotIndexSetInteger(index,PLOT_LINE_STYLE,STYLE_DOT);
      case 3:
         PlotIndexSetInteger(index,PLOT_LINE_STYLE,STYLE_DASHDOT);
      case 4:
         PlotIndexSetInteger(index,PLOT_LINE_STYLE,STYLE_DASHDOTDOT);

      default: return;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetIndexArrowMQL4(int index,int code) 
  {
#ifdef __MQL5__
   PlotIndexSetInteger(index,PLOT_ARROW,code);
#else
   SetIndexArrow(index,code);
#endif
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetIndexEmptyValueMQL4(int index,double value) 
  {
#ifdef __MQL5__
   PlotIndexSetDouble(index,PLOT_EMPTY_VALUE,value);
#else
   SetIndexEmptyValue(index,value);
#endif
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetIndexLabelMQL4(int index,string text) 
  {
#ifdef __MQL5__
   PlotIndexSetString(index,PLOT_LABEL,text);
#else
   SetIndexLabel(index,text);
#endif
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//double ObjectGetValueByShiftMQL4(string name,int shift) 
//  {
//   ENUM_TIMEFRAMES timeframe=TFMigrate(PERIOD_CURRENT);
//   MqlRates mql4[];
//   CopyRates(NULL,timeframe,shift,1,mql4);
//   if (ArraySize(mql4) < 1) return 0;
//   return(ObjectGetValueByTime(0,name,mql4[0].time,0));
//  }
  
double ObjectGetValueByShiftMQL4(string name, int shift, ENUM_TIMEFRAMES period)
  {
   //ENUM_TIMEFRAMES timeframe=TFMigrate(PERIOD_CURRENT);
   MqlRates mql4[];
   CopyRates(_Symbol,period,shift,1,mql4);
   if (ArraySize(mql4) == 0) return 0;
   return(ObjectGetValueByTime(0,name,mql4[0].time,0));
  }
  
  
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string ObjectNameMQL4(int index) 
  {
   return(ObjectName(0,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ObjectGetShiftByValueMQL4(string name,
                              double value)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(PERIOD_CURRENT);
   datetime Arr[];
   MqlRates mql4[];
   if(ObjectGetTimeByValue(0,name,value)<0) return(-1);
   CopyRates(NULL,timeframe,0,1,mql4);
   if (ArraySize(mql4) == 0) return -1;
   if(CopyTime(NULL,timeframe,mql4[0].time,ObjectGetTimeByValue(0,name,value),Arr)>0)
      return(ArraySize(Arr)-1);
   else return(-1);
  }
//+------------------------------------------------------------------+


int TimeMonthMQL4(datetime date)
  {
   MqlDateTime tm;
   TimeToStruct(date,tm);
   return(tm.mon);
  }
  
  
int HourMQL4()
  {
   MqlDateTime tm;
   TimeCurrent(tm);
   return(tm.hour);
  }
  
  
int SecondsMQL4()
  {
   MqlDateTime tm;
   TimeCurrent(tm);
   return(tm.sec);
  }
  
  
  
double ObjectGetValueByShiftMQL4(string name,
                                 int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(PERIOD_CURRENT);
   MqlRates mql4[];
   CopyRates(NULL,timeframe,shift,1,mql4);
   return(ObjectGetValueByTime(0,name,mql4[0].time,0));
  }
  
  
  
int WindowFindMQL4(string name)
  {
   int window=-1;
   if((ENUM_PROGRAM_TYPE)MQLInfoInteger(MQL_PROGRAM_TYPE)==PROGRAM_INDICATOR)
     {
      window=ChartWindowFind();
     }
   else
     {
      window=ChartWindowFind(0,name);
      if(window==-1) Print(__FUNCTION__+"(): Error = ",GetLastError());
     }
   return(window);
  }