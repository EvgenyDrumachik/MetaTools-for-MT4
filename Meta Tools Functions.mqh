//+------------------------------------------------------------------+
//|                                                      BF Tools    |
//|                                      Copyright 2020, CompanyName |
//| These are functions specific to UI of BF Tools                   |
//| Can be used only in the context of the BF Tools UI               |
//| needs declarations of other functions                            |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, Evgeny Drumachik"
#property link      "http://www.strategy4you.ru"
#property strict

#include <Controls/Button.mqh>
#include "GraphObject.mqh"
#include "Trend.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


void Update_X_Delta() {
   
   X_Delta = ChartWidthInPixels() - 245;

}




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ShowAllWatchPairButtons() {
//Print("Showing all Watch Pair Buttons...");

   if(OpenChartsCount>1)
     {
      //Showing all Watch Pair Buttons..
      for(int i=0;i<ArraySize(ArrayOfWatchPairButtons);i++)
        {
        //Print("StringLen(OpenChartSymbols[i]) = " + IntegerToString( StringLen(OpenChartSymbols[i])) );
         if(StringLen(OpenChartSymbols[i])>0) 
           {
            ArrayOfWatchPairButtons[i].Show();
           }
         else 
           {
            ArrayOfWatchPairButtons[i].Hide();
           }
        }
     }
   WatchPairButtonsHidden=false;
   
   // Showing labels
   for(int i=0;i<ArraySize(ArrayOfTradeDirLabels);i++)  {
      ArrayOfTradeDirLabels[i].Show();
   }
   
   for(int i=0;i<ArraySize(ArrayOfTradeInfoLabels);i++) {
      ArrayOfTradeInfoLabels[i].Show();
   }  
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void HideAllWatchPairButtons() 
  {
   for(int i=0;i<ArraySize(ArrayOfWatchPairButtons);i++) 
     {
      ArrayOfWatchPairButtons[i].Hide();
     }
   WatchPairButtonsHidden=true;

   // Hiding labels
   for(int i=0;i<ArraySize(ArrayOfTradeDirLabels);i++)  {
      ArrayOfTradeDirLabels[i].Hide();
   }
   
   for(int i=0;i<ArraySize(ArrayOfTradeInfoLabels);i++) {
      ArrayOfTradeInfoLabels[i].Hide();
   }   

  }



//+------------------------------------------------------------------+
void ResetAllWatchButtons()
  {
//Print("Reseting all Watch Buttons...");

   WL1_Button.Color(clrBlack);
   WL1_Button.ColorBackground(clrLightGray);
   WL1_Button.Pressed(false);
   WL1_Button.Font("Calibri");

   WL2_Button.Color(clrBlack);
   WL2_Button.ColorBackground(clrLightGray);
   WL2_Button.Pressed(false);
   WL2_Button.Font("Calibri");

   WL3_Button.Color(clrBlack);
   WL3_Button.ColorBackground(clrLightGray);
   WL3_Button.Pressed(false);
   WL3_Button.Font("Calibri");

   WL4_Button.Color(clrBlack);
   WL4_Button.ColorBackground(clrLightGray);
   WL4_Button.Pressed(false);
   WL4_Button.Font("Calibri");

   WL5_Button.Color(clrBlack);
   WL5_Button.ColorBackground(clrLightGray);
   WL5_Button.Pressed(false);
   WL5_Button.Font("Calibri");


   WLX_Button.Color(clrBlack);
   WLX_Button.ColorBackground(clrLightGray);
   WLX_Button.Pressed(false);
   //WLX_Button.Font("Calibri");

//Print("All Watch Buttons were reset.");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int NumberOfElementsInIntArray(long &arr[]) 
   // returns number of non-zero elements in an array
  {

   int NumberOfElements=0;
   int array_size=ArraySize(arr);

   for(int i=0; i<array_size; i++) 
     {
      if(arr[i]!=0) NumberOfElements++;
     }

   return NumberOfElements;

  }
  

int NumberOfElementsInStringArray(string &arr[]) 
   // returns number of non "" (empty) elements in an array
  {

   int NumberOfElements=0;
   int array_size=ArraySize(arr);

   for(int i=0; i<array_size; i++) 
     {
      if(arr[i] != "" && arr[i] != NULL) NumberOfElements++;
     }

   return NumberOfElements;

  }
  
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UpdateWatchPairButtons(bool force_update = false) 
  {
  
   // Prevent too frequent updates; maximum every 1 seconds
   if ( TimeLocal() - WatchPairButtonsLastUpdate < 1 && !force_update) return;

   if(!ThisChartIsActive) return; // do not do anything, if this chart is now not active in the Meta Trader UI

   //if (force_update)
   //   Print(__FUNCTION__ + ": force_update");


   //first update the High / Low buttons
   SetHighLow_WL_Buttons(ProbabilityInWatchList(ChartID()));

   // then update all the watch pair buttons
   int WatchedPairsCount = NumberOfElementsInIntArray(OpenChartIDs); // number of pair in watch list
   
   //Print("NumberOfElementsInIntArray = " + WatchedPairsCount);

   for(int i=0; i<WatchedPairsCount; i++) {  // cycle through all watched pairs = through all the visible buttons
      if( i > ArraySize(ArrayOfWatchPairButtons)-1 ) { Print("Watch List supports not more than " + IntegerToString(ArraySize(ArrayOfWatchPairButtons)) + " pairs."); break; } // only 25 watch pair buttons are supported
      int _ChartPeriod=ChartPeriod(OpenChartIDs[i]);
      int _HoursDelay = GetHoursDelayByChartID(OpenChartIDs[i],OpenChartSymbols[i]);
      if(_HoursDelay == 0) _HoursDelay = 1;
      string _ButtonText;

      // defining pair name to be written on the button
      if(StringLen(OpenChartSymbols[i])<6)  {
         _ButtonText = OpenChartSymbols[i]+","+TimeframeToString(_ChartPeriod);
         //Print("_ButtonText = " + _ButtonText);
        }
      else {
         string part1 = StringSubstr(OpenChartSymbols[i],0,3); // left currency
         string part2 = StringSubstr(OpenChartSymbols[i],3,3); // right currenct
         
         // part1 and part 2
         if(part1 == "CHF") part1 = "CH"; 
         else if(part1 == "CAD") part1 = "CA"; 
         else if(part1 == "XAG") part1 = "XG";
         else if(part1 == "XAU") part1 = "XU";
         else if(part1 == "ETH") part1 = "ET";
         else if(part1 == "BTC") part1 = "BT";
         else part1 = StringSubstr(part1,0,1);
         
         if(part2 == "CHF") part2 = "CH"; 
         else if(part2 == "CAD") part2 = "CA"; 
         else if(part2 == "SGD") part2 = "SG";
         else if(part2 == "DKK") part2 = "DK";
         else if(part2 == "NOK") part2 = "NO";
         else if(part2 == "SEK") part2 = "SE";
         else if(part2 == "CNH") part2 = "CN";
         else part2 = StringSubstr(part2,0,1);
         // //// part1 and part2
         
         
         // processing cases of long crypto names
         if (OpenChartSymbols[i] == "BITCOIN")
            _ButtonText="BTC,"+TimeframeToString(_ChartPeriod);
         else if (OpenChartSymbols[i] == "CHAINLNK")
            _ButtonText="CHAIN,"+TimeframeToString(_ChartPeriod);
         else if (OpenChartSymbols[i] == "ETHEREUM")
            _ButtonText="ETH,"+TimeframeToString(_ChartPeriod);
         else if (OpenChartSymbols[i] == "DOGECOIN")
            _ButtonText="DOGE,"+TimeframeToString(_ChartPeriod);
         else if (OpenChartSymbols[i] == "RIPPLE")
            _ButtonText="RIPPL,"+TimeframeToString(_ChartPeriod);
         else if (OpenChartSymbols[i] == "SOLANA")
            _ButtonText="SOL,"+TimeframeToString(_ChartPeriod);
         else 
            _ButtonText=part1+"/"+part2+","+TimeframeToString(_ChartPeriod);
        }
        // button pair name for button text

      
      // hours delay indication for non-S-version
      if(!S_Version) { // if not version for Sergey
         if(_HoursDelay==-1) _ButtonText=_ButtonText+"";
         else _ButtonText=_ButtonText+"-"+IntegerToString(_HoursDelay);
      }
      // hours delay indication

      
      // set resulting button text and tooltip
      ArrayOfWatchPairButtons[i].Text(_ButtonText);
      ObjectSetString(ChartID(),ArrayOfWatchPairButtons[i].Name(),OBJPROP_TOOLTIP,OpenChartSymbols[i]);
      // =====================

      
      // show/hide button
      if(!WatchPairButtonsHidden) {
         ArrayOfWatchPairButtons[i].Show(); 
      }
      else ArrayOfWatchPairButtons[i].Hide();
      // ===============



      // *** formatting button based on hours delay, priority and if selected ***
      ArrayOfWatchPairButtons[i].Color(clrBlack);
      if(_HoursDelay==1)  {
         ArrayOfWatchPairButtons[i].Font("Calibri Bold");
         ArrayOfWatchPairButtons[i].ColorBorder(clrBrown);
         if(ChartCheckMissed) {
            ArrayOfWatchPairButtons[i].Color(clrWhite);
            ArrayOfWatchPairButtons[i].ColorBackground(clrRed);
           }
        }
      else if(_HoursDelay==-1 && !S_Version)  {
         if (Strategy == BF || Strategy == D1 || Strategy == S3) {
            // so far, we do nothing special here
            ArrayOfWatchPairButtons[i].Font("Calibri");
            ArrayOfWatchPairButtons[i].ColorBorder(clrGray);
            ArrayOfWatchPairButtons[i].Color(clrGray);
            
            Probability prob = ProbabilityInWatchList(OpenChartIDs[i]);
            if (Strategy == S3 && prob == HighProbability) {
               ArrayOfWatchPairButtons[i].ColorBorder(clrBlack);
               ArrayOfWatchPairButtons[i].Color(clrBlack);
            }
         }
      }
      else {
         ArrayOfWatchPairButtons[i].Font("Calibri");
         ArrayOfWatchPairButtons[i].ColorBorder(clrBlack);
      }
      
        
      if(OpenChartIDs[i]==ChartID()) {
         //this button is for current chart
         //Highlight this WL Pair Button via array
         ArrayOfWatchPairButtons[i].Color(clrWhite);
         ArrayOfWatchPairButtons[i].ColorBackground(clrGreen);
        }
      else
        {
         // not current chart
         //format based on Probability
         if (_HoursDelay == 1) ArrayOfWatchPairButtons[i].Color(clrBlack); // otherwise, it will stay white from the instruction above
         Probability prob = ProbabilityInWatchList(OpenChartIDs[i]);
         if (prob == HighProbability && OpenChartSymbols[i] != _Symbol) {
            ArrayOfWatchPairButtons[i].ColorBackground(clrGold);
         }
         else {
            // Unhighlight it
            ArrayOfWatchPairButtons[i].ColorBackground(clrLightGray);
         }
        }
      // =======================
      
      
   
      // *** UPDATING RIGHT-SIDE LABELS OF THE WATCH LIST BUTTON *** 
      // check order direction and order info, fill into related labels
      TradeManager.TradesArray.Update();
      int trades_on_symbol = TradeManager.TradesArray.TradesOpenOnSymbol(OpenChartSymbols[i]);
      if (trades_on_symbol > 0) { // there is at least 1 order on that pair
          ArrayOfTradeDirLabels[i].Text(TradeManager.TradesArray.TradeDirChar(OpenChartSymbols[i]));
          ArrayOfTradeInfoLabels[i].Text(TradeManager.TradesArray.TradeInfo(OpenChartSymbols[i]));
          
          string tooltip = "Trade Info";
          
          if (trades_on_symbol > 1) { // for multiple orders on this symbol
               int trades_total = TradeManager.TradesArray.TradesCount();
               int trade_number = 0; // to count trades on the current symbol
               for (int n = 0; n < trades_total; n++) { // cycle through all the orders in the terminal
                  // n - index of trade in the total array of all terminal orders
                  if (TradeManager.TradesArray.Trades[n].TradeSymbol() == OpenChartSymbols[i]) { // cycle through trades on this symbol only
                     trade_number++;
                     tooltip = tooltip + "\n" + "Trade " + IntegerToString(trade_number) + ": " + DoubleToString(TradeManager.TradesArray.Trades[n].ProfitPP(),0);
                  }           
               } // for cycle through open trades
               
               tooltip = tooltip + "\n"  + "Open Trades: " + IntegerToString(trades_on_symbol);
               
               ObjectSetString(0,ArrayOfTradeInfoLabels[i].Name(),OBJPROP_TOOLTIP,tooltip);
          }
          
          else { // only 1 trade on this symbol
            ObjectSetString(0,ArrayOfTradeInfoLabels[i].Name(),OBJPROP_TOOLTIP,tooltip);
          }
         
         int actives_trades_count = TradeManager.TradesArray.TradesOpenOnSymbol(OpenChartSymbols[i],true);
         if (actives_trades_count > 0) {
               // check if all trades are in BE - change label color to green; otherwise - change to red
               bool all_trades_at_BE = false;
               if ( TradeManager.TradesArray.AllTradesAtBreakEvenOnSymbol(OpenChartSymbols[i]) ) {
                  ArrayOfTradeInfoLabels[i].Color(clrGreen);
                  all_trades_at_BE = true;
               }
               else {
                  ArrayOfTradeInfoLabels[i].Color(clrRed);
                  //Print("Check...");
                  if ( TradeManager.TradesArray.TradesInMinLossModeExistOnSymbol(OpenChartSymbols[i]) ) {
                     ArrayOfTradeInfoLabels[i].Text("x" + ArrayOfTradeInfoLabels[i].Text());
                  }
                  else {
                     ArrayOfTradeInfoLabels[i].Font("Caribri");
                     //Print("else");
                  }
               }
               if ( TradeManager.TradesArray.AllTradesInProfitOnSymbol(OpenChartSymbols[i]) && !all_trades_at_BE )
                  ArrayOfTradeInfoLabels[i].Color(clrBlack);
         }
      }
      else  { // no orders
         if (ArraySize(ArrayOfTradeDirLabels)>i) {
            ArrayOfTradeDirLabels[i].Text("");
            ArrayOfTradeInfoLabels[i].Text("");
            // reset color to black
            ArrayOfTradeDirLabels[i].Color(clrBlack);
            ArrayOfTradeInfoLabels[i].Color(clrBlack);
         }
         else Print("Attempt to access array element #" + IntegerToString(i) + ", while size of array ArrayOfTradeDirLabels = " + IntegerToString(ArraySize(ArrayOfTradeDirLabels)));
      }
      
      ChartCheckNeeded need = ChartCheckNeededGet(OpenChartSymbols[i],OpenChartIDs[i]);
      if (need != Not_Needed) {
      
         if (need == S3_Impulse) {
            ArrayOfTradeDirLabels[i].Text(CharToString(108));
            ObjectSetString(ChartID(),ArrayOfTradeDirLabels[i].Name(),OBJPROP_TOOLTIP,"S3 Impulse");
         }
         else if (need == Pin_Bar) {
            ArrayOfTradeDirLabels[i].Text(CharToString(116));
            ObjectSetString(ChartID(),ArrayOfTradeDirLabels[i].Name(),OBJPROP_TOOLTIP,"Pin Bar");
         } 
         else if (need == ChartCheckMissed) {
            ArrayOfTradeDirLabels[i].Text(CharToString(185));
            ObjectSetString(ChartID(),ArrayOfTradeDirLabels[i].Name(),OBJPROP_TOOLTIP,"Check Missed");
         }
         else if (need == PositionThreat) {
            ArrayOfTradeDirLabels[i].Text(CharToString(77));
            ObjectSetString(ChartID(),ArrayOfTradeDirLabels[i].Name(),OBJPROP_TOOLTIP,"Postion Threat");
         }
         ArrayOfTradeDirLabels[i].Color(clrRed);
      }
      
      else {
         if (ArraySize(ArrayOfTradeDirLabels)>i) {
            ArrayOfTradeDirLabels[i].Color(clrBlack);
            ObjectSetString(ChartID(),ArrayOfTradeDirLabels[i].Name(),OBJPROP_TOOLTIP,"Direction of Last Opened Trade");
         }
         else Print("Attempt to access array element #" + IntegerToString(i) + ", while size of array ArrayOfTradeDirLabels = " + IntegerToString(ArraySize(ArrayOfTradeDirLabels)));
      }  
        
     } // cycle through all the watched pairs




   //now hide all the buttons, which do not display any watched pair
   for(int i=WatchedPairsCount; i< ArraySize(ArrayOfWatchPairButtons); i++) {
      ArrayOfWatchPairButtons[i].Hide();
   }
    
     
   ObjectSetString(ChartID(),"WL_InWL_High_Button",OBJPROP_TOOLTIP,"В Watch List - High Quality Setup (" + IntegerToString(WatchedPairsCount) + ")");
   ObjectSetString(ChartID(),"WL_InWL_Low_Button", OBJPROP_TOOLTIP,"В Watch List - Low Quality Setup ("  + IntegerToString(WatchedPairsCount) + ")");

   ChartRedraw();
   WatchPairButtonsLastUpdate = TimeLocal(); // to track when was it last updated and prevent too frequent updates
}
  
  
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void HighlightWatchButton(int hd)
  {

   HoursDelay=hd;

//Print("HighlightWatchButton(): HoursDelay = "+ HoursDelay);

//Print("Setting BG Color of the button '" + hd + "' to clrGreen.");
   if(HoursDelay == 0) {WL1_Button.Color(clrWhite); WL1_Button.ColorBackground(clrGreen); WL1_Button.Font("Calibri Bold"); return;}
   if(HoursDelay == 1) {WL1_Button.Color(clrWhite); WL1_Button.ColorBackground(clrGreen); WL1_Button.Font("Calibri Bold"); return;}
   if(HoursDelay == 2) {WL2_Button.Color(clrWhite); WL2_Button.ColorBackground(clrGreen); WL2_Button.Font("Calibri Bold"); return;}
   if(HoursDelay == 3) {WL3_Button.Color(clrWhite); WL3_Button.ColorBackground(clrGreen); WL3_Button.Font("Calibri Bold"); return;}
   if(HoursDelay == 4) {WL4_Button.Color(clrWhite); WL4_Button.ColorBackground(clrGreen); WL4_Button.Font("Calibri Bold"); return;}
   if(HoursDelay == 5) {WL5_Button.Color(clrWhite); WL5_Button.ColorBackground(clrGreen); WL5_Button.Font("Calibri Bold"); return;}
   if(HoursDelay== -1) {WLX_Button.Color(clrWhite); WLX_Button.ColorBackground(clrGreen); /*WLX_Button.Font("Calibri Bold"); */ return;}
  }
  
  
  
  





  
  
  
  
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void InitializeWatchButtons()
  {
   HoursDelay = (int)MathRound(GlobalVariableGet("WL-"+_Symbol+"-"+IntegerToString(ChartID())));

   HighlightWatchButton(HoursDelay);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetHoursDelay(int hd,string _symbol) 
  {
   HoursDelay=hd;
   long chartid=GetChartIDbySymbol(_symbol);
   GlobalVariableSet("WL-"+_symbol+"-"+IntegerToString(chartid),hd);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long GetChartIDbySymbol(string _symbol) 
  {
   int total=GlobalVariablesTotal();
   for(int i=0;i<total;i++)
     {
      string gvar_name=GlobalVariableName(i);
      if(StringFind(gvar_name,"WL-"+_symbol)>-1) 
        { // symbol is found in the name of the global variable
         int first_dash_pos=StringFind(gvar_name,"-",0);
         int second_dash_pos=StringFind(gvar_name,"-",first_dash_pos+1);
         return StringToInteger(StringSubstr(gvar_name,second_dash_pos+1)); // return part of global variable name from the 2nd dash till the end of the name
        }
     }
   return 0;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+



void UpdateChartArrays() // getting only Watched chart symbols and ChartID's into two dedicated arrays
  {
   CleanUpChartArrays();
   TradeManager.TradesArray.Update();

   long     currChartID=ChartFirst();
   string   currChartSymbol;
   bool     IsThisChartInWL;

   int i=0;

// filling up arrays with watched charts (Watch List Charts)
   while(i < 99) 
     {
         IsThisChartInWL = IsChartInWL(currChartID);
         currChartSymbol = ChartSymbol(currChartID);
         
         OpenChartInTerminalIDs[i] = currChartID;
   
         if(IsThisChartInWL || TradeManager.TradesArray.TradesOpenOnChart(currChartID)>0) { // decide to add to WL this pair too!
            OpenChartSymbols[i] = currChartSymbol;
            OpenChartIDs[i] = currChartID;
            i++;
           }
   
         currChartID = ChartNext(currChartID);
         if(currChartID < 0) { 
            OpenChartsCount = i+1; 
            break; 
         }// Chart Arrays Updated     
     } // while
     //Print("Size of 'OpenChartInTerminalIDs' array = " + NumberOfElementsInIntArray(OpenChartInTerminalIDs));
}     
    
    
long GetPrevChartID() 
  {
   long currChart;
   long prevChart=ChartFirst();

   if(prevChart==ChartID()) return 0; // we are in the beginning already

   int i=0;
   while(i<100)
     {
      currChart=ChartNext(prevChart);
      if(currChart == ChartID()) return prevChart;
      prevChart=currChart;// save the current chart ID for the ChartNext()
     }
   return 0;
  }


  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string GetSelectedObjectName() 
  {
   if(SelectedObjectsCount()!=1) 
     {
      //Print(__FUNCTION__, ": SelectedObjectsCount() != 1. Returning empty value");
      return "";
     }

   int obj_total=ObjectsTotalMQL4(); //total objects count
   string SelectedObjectName="";
   int n=0; // counting how many objects did we check
   for(int i=obj_total; i>=0; i--) 
     { // for each object on the chart
      SelectedObjectName=ObjectNameMQL4(i);    // getting the object name
      n++;
      if(ObjectGetMQL4(SelectedObjectName,OBJPROP_SELECTED)==1) 
        {    // is this object is selected then...
         //Print("Objects checked: ",n);
         return SelectedObjectName;
        }
      //else return "";
     }
   Print("Objects checked: ",n);
   return SelectedObjectName;
  }




  
  
string GetBarTimeLeftString() {
   
   int secondsleft;
   
   if (ArraySize(Time) > 0) {
   secondsleft = int(Time[0]+_Period*60-TimeCurrent()) - 1;
   }
   else 
      secondsleft = 0; // some kind of error with Time array
      
      
   
   //Print("Time[0]=",Time[0], "  _Period=",_Period,"  TimeCurrent()=",TimeCurrent(),"  secondsleft=",secondsleft);
   int h,m,s;
   s=secondsleft%60;
   m=((secondsleft-s)/60)%60;
   h=(secondsleft-s-m*60)/3600;

   
   string displaystr;
   // Note, the prefix of spaces below is intentional and necessary to keep the top-middle-anchored text off of Bar[0]!
   if (secondsleft >= 0 && h==0) 
     {
      displaystr = StringSubstr(TimeToString(secondsleft,TIME_MINUTES|TIME_SECONDS),3);
     }
   else if (secondsleft >= 0 && h>0) 
     {
      displaystr = IntegerToString(h) + ":" + StringSubstr(TimeToString(secondsleft,TIME_MINUTES|TIME_SECONDS),3);
     }
   else if (h==0)
     {// When 1 bar is complete, before a new bar is formed the old version displayed hard-to-read negative values. This is very explicit
      // FYI, max of ~62 characters
      displaystr = ":-" + StringSubstr(TimeToString(-1*secondsleft,TIME_MINUTES|TIME_SECONDS),3);
     }
   else //h!=0 and I think always h<0
     {// When 1 bar is complete, before a new bar is formed the old version displayed hard-to-read negative values. This is very explicit
      // FYI, max of ~62 characters
      displaystr = "-" + IntegerToString(-1*h)  + ":" + StringSubstr(TimeToString(-1*secondsleft,TIME_MINUTES|TIME_SECONDS),3);
     }
   
   return displaystr;
}



string GetBarTimeLeftString(ENUM_TIMEFRAMES period)
  {

   int secondsleft;
   secondsleft = int(iTime(Symbol(),period,0) + PeriodSeconds(period) - TimeCurrent());

   int h,m,s;
   s = 60 - secondsleft%60;
   m = ((secondsleft-s)/60)%60;
//m = 60 - ((secondsleft)/60)%60;
   h = (secondsleft-s-m*60)/3600;

   string displaystr;
// Note, the prefix of spaces below is intentional and necessary to keep the top-middle-anchored text off of Bar[0]!
   if(secondsleft >= 0 && h==0)
     {
      displaystr = StringSubstr(TimeToString(secondsleft,TIME_MINUTES|TIME_SECONDS),3);
     }
   else
      if(secondsleft >= 0 && h>0)
        {
         displaystr = IntegerToString(h) + ":" + StringSubstr(TimeToString(secondsleft,TIME_MINUTES|TIME_SECONDS),3);
        }
      else
         if(h==0)
           {
            // When 1 bar is complete, before a new bar is formed the old version displayed hard-to-read negative values. This is very explicit
            // FYI, max of ~62 characters
            displaystr = ":-" + StringSubstr(TimeToString(-1*secondsleft,TIME_MINUTES|TIME_SECONDS),3);
           }
         else //h!=0 and I think always h<0
           {
            // When 1 bar is complete, before a new bar is formed the old version displayed hard-to-read negative values. This is very explicit
            // FYI, max of ~62 characters
            displaystr = "-" + IntegerToString(-1*h) + ":" + StringSubstr(TimeToString(-1*secondsleft,TIME_MINUTES|TIME_SECONDS),3);
           }

   return displaystr;
  }
  
  
void UpdateRightLowerInfo(void) {
   datetime time = TimeCurrent() + 1;

   string label_txt = TimeToString(time,TIME_DATE) + " " + TimeToString(time,TIME_SECONDS);
   if(IsMarketOpen(Symbol()))
      label_txt += "  |  H4 bar: " + GetBarTimeLeftString(PERIOD_H4);
   else
      label_txt += "  |  Market is Closed";
   RightLowerInfo_Label.Text(label_txt);
   RightLowerInfoSymbol_Label.Text(_Symbol + ", " + TimeframeToString(_Period));
   ChartRedraw(ChartID());
}




bool IsMarketOpen(const string symbol, const bool debug = false) {
    datetime from = NULL;
    datetime to = NULL;
    datetime serverTime = TimeCurrent();

    // Get the day of the week
    MqlDateTime dt;
    TimeToStruct(serverTime,dt);
    const ENUM_DAY_OF_WEEK day_of_week = (ENUM_DAY_OF_WEEK) dt.day_of_week;

    // Get the time component of the current datetime
    const int time = (int) MathMod(serverTime,HR2400);

    if ( debug ) PrintFormat("%s(%s): Checking %s", __FUNCTION__, symbol, EnumToString(day_of_week));

    // Brokers split some symbols between multiple sessions.
    // One broker splits forex between two sessions (Tues thru Thurs on different session).
    // 2 sessions (0,1,2) should cover most cases.
    int session=2;
    while(session > -1)
    {
        if(SymbolInfoSessionTrade(symbol,day_of_week,session,from,to ))
        {
            if ( debug ) PrintFormat(    "%s(%s): Checking %d>=%d && %d<=%d",
                                        __FUNCTION__,
                                        symbol,
                                        time,
                                        from,
                                        time,
                                        to );
            if(time >=from && time <= to )
            {
                if ( debug ) PrintFormat("%s Market is open", __FUNCTION__);
                return true;
            }
        }
        session--;
    }
    if ( debug ) Print("Market NOT open");
    return false;
}

  
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UpdatePosVisOfCandleTimer() {

   // if auto-entry is ON - always show the timer.
   if (sets.AutoEntryOnBarClose) {
      ObjectSetInteger(0,"CandleClosingTimeRemaining",OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
      int x, y, sub;
      x = TradeManager.TM_AutoEntry_Button.Left();
      y = TradeManager.TM_AutoEntry_Button.Bottom();
      datetime new_date;
      double new_price;
      ChartXYToTimePrice(ChartID(),x,y,sub,new_date,new_price);
      ObjectMove(0,"CandleClosingTimeRemaining",0,new_date-3600,new_price);
      ObjectSetTextMQL4("CandleClosingTimeRemaining",GetBarTimeLeftString(),9,"verdana",clrBlack);
   }
   else
      if( TimeDayOfWeekMQL4(TimeLocal()) != 6 && TimeDayOfWeekMQL4(TimeLocal()) != 0 ) // if not weekend  
      { 
         if (  (CurrentTime.min >= ShowClosingTimerFromMin && _Period == PERIOD_H1) 
            || _Period == PERIOD_H4 || _Period == PERIOD_M1 
            || _Period == PERIOD_M5 || _Period == PERIOD_M15 || _Period == PERIOD_M30) 
         {
            // we show timer; always show timer for H4
            ObjectSetInteger(0,"CandleClosingTimeRemaining",OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
         }
         else {
            ObjectSetInteger(0,"CandleClosingTimeRemaining",OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
            return;
         }

         // if we reached here, it means we are still showing the time. Therefore updating position of it
         int DayOfTomorrow=DayMQL4()+1;
         string y = IntegerToString(YearMQL4());
         string m = IntegerToString(MonthMQL4());
         string d = IntegerToString(DayOfTomorrow);
         string time;
         if (_Period == PERIOD_H4) time = " 23:00";
         else time = " 01:00";
         datetime TimePosition=StringToTime(y+"."+m+"."+d+" "+time);
         
         ObjectMove(0,"CandleClosingTimeRemaining",0,TimePosition,GetBid());
         ObjectSetTextMQL4("CandleClosingTimeRemaining",GetBarTimeLeftString(),9,"verdana",clrBlack);
      }
      else {
         // hide timer
         ObjectSetInteger(0,"CandleClosingTimeRemaining",OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
         return;
      }
}



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PlaySoundAlert() {
   if (!IsSoundControlON()) return;
   if(GetHoursDelayByChartID(ChartID(),_Symbol)==1 && UseSoundAlerts && MinuteMQL4() >= StartAlertsEveryHourAtMin) {
      if (SecondsSinceLastSoundAlarm < 10) return; // release sound alert once each 3 at most
      if (!PlaySound("tick.wav")) Print("Sound Alert file not found");
      else Print("Sound played");
      SecondsSinceLastSoundAlarm = 0;
      Print("Sound from ", _Symbol, " / Strategy: ", EnumToString(Strategy));
   }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PB_HighLightWLPairButton(long _chartID) 
  {

   if(!ThisChartActive()) return; // do not do anything, if this chart is not active

   for(int i=0;i<ArraySize(ArrayOfWatchPairButtons);i++) // finding current button among those displayed
     {
      if(OpenChartIDs[i]==_chartID) 
        { // found!
         ArrayOfWatchPairButtons[i].Color(clrWhite);
         ArrayOfWatchPairButtons[i].ColorBackground(clrRed);
         break;
        }
     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AutoSaveTemplateEvery4Hours() {

// Define current time
   MqlDateTime _time_struct_outside;  // time inside the 'for' cycle
   int _hour_outside;
   int _minute_outside;
   int _sec_outside;
   TimeCurrent(_time_struct_outside);
   _hour_outside     =     _time_struct_outside.hour;
   _minute_outside   =     _time_struct_outside.min;
   _sec_outside      =     _time_struct_outside.sec;
   if(AutoSaveTemplateEnabled) 
     {
      if(_hour_outside==5 || _hour_outside==9 || _hour_outside==13 || _hour_outside==17 || _hour_outside==21) 
        {

         if(_minute_outside==0 && !TemplateSavedAtThisHourAlready) 
           {
            bool also_save_screenshot = false;
            SaveTemplateAndScrenshot(also_save_screenshot);
            TemplateSavedAtThisHourAlready=true;
           }
        }
      else TemplateSavedAtThisHourAlready=false;
     }
  }
  
  

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SwitchToChart(long chart_id)
  {
   long chartwindow=-1;

   if(!ChartGetInteger(chart_id,CHART_WINDOW_HANDLE,0,chartwindow)) {
      Print("Couldn't Get Chart Window");
   }
   int parent = (int)GetParent((int)chartwindow);

   SendMessageW(GetParent(parent),WM_MDIMAXIMIZE,parent,0);
   
   // Sending message to that chart to enable post-switch processing
    EventChartCustom(chart_id,CHART_SWITCHED,0,0,"");
   
  }


void UnselectAll() {
   //Print("Unselect All");
   if(SelectedObjectsCount() == 0) return;
   for(int i=0; i<ObjectsTotalMQL4(); i++)
     { // for each object on the chart
      string objectName=ObjectNameMQL4(i);    // getting the object name
      if(ObjectGetMQL4(objectName,OBJPROP_SELECTED)==1) 
        {    // is this object is selected then...
         //Unselect the object
         ObjectSetMQL4(objectName,OBJPROP_SELECTED,0);
        }
     }
   UnselectAll_Button.Text(IntegerToString(SelectedObjectsCount()));
   UnselectAll_Button.Pressed(false);
   i_SelectedObjectsCount = 0;
   UpdatePositionOfAllButtons(0, X_Delta);
}
  

  

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TrendType GetTrendType(string TrendName) 
  {

   double     p1 = ObjectGetMQL4(TrendName,OBJPROP_PRICE1);
   datetime   t1 = (datetime)ObjectGetMQL4(TrendName,OBJPROP_TIME1);
   double     p2 = ObjectGetMQL4(TrendName,OBJPROP_PRICE2);
   datetime   t2 = (datetime)ObjectGetMQL4(TrendName,OBJPROP_TIME2);

   if(t1 == t2) return VerticalTrend;
   if(p1 == p2) return HorizontalTrend;
   if(p2 > p1)  return BullishTrend;
   if(p2 < p1)  return BearishTrend;

   return ErrorTrend;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

void InformAboutFormedD1Signal() {

   InformedAboutpossibleLevelFalseBreak=false; // reset flag when new hour starts
   for (int i = 0; i < ArraySize(Levels); i++) {
      int LastBrokenByBarIndex;
      if (Levels[i].TimesBroken(PERIOD_H1,LastBrokenByBarIndex) == 2) {
         // проверить, что это именно эта последняя свеча дала второй пробой
         // Buy case:
         if (Levels[i].TradeDirection == Buy_Level) {
            if (Levels[i].Price() > iOpen(_Symbol,_Period,1) && Levels[i].Price() < iClose(_Symbol,_Period,1)) { // last bar has broken this level
               Print("Last bar broken buy level - buy signal!");
               PlaySoundAlert();
               SendPushAlert("Buy Signal");
            }
         }
         else if (Levels[i].TradeDirection == Sell_Level) {
            if (Levels[i].Price() < iOpen(_Symbol,_Period,1) && Levels[i].Price() > iClose(_Symbol,_Period,1)) { // last bar has broken this level
               Print("Last bar broken sell level - sell signal!");
               PlaySoundAlert();
               SendPushAlert("Sell Signal");
            }
         }
      }
   }

}



void DisqualifyBrokenLevels_StrategyD1() {

   if (Strategy != D1) return;
   
   int LastBrokenByBarIndex = 0;
   for (int i = 0; i < ArraySize(Levels); i++) {
      if (Levels[i].TimesBroken(PERIOD_H1,LastBrokenByBarIndex) >1) 
         Levels[i].Style(STYLE_DOT);
   }
   UpdateLevelsArray();
}




void ExtendAllFibos() {
   //if (ObjectsTotalMQL4(OBJ_FIBO) == 0) { Print("No fibo's to check"); return; } // no fibo's on this graph - doesn't work!!!
   int total_objects = ObjectsTotalMQL4();

   for(int i=0; i < total_objects; i++) {
      string objectName = ObjectNameMQL4(i);
      
      if(ObjectTypeMQL4(objectName) == OBJ_FIBO && Strategy != FourStrings) {
         CFibo fibo(objectName);
         if(!fibo.IsVisibleOnTF(_Period)) continue;
         // but if visible then...
         fibo.ExtendFibo();
        }
     }  // for - across all objects
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


void UpdateFiboLevelsForAll() 
  {
   int FiboCount=0;

   for(int i=0; i<ObjectsTotalMQL4(); i++) 
     {
      string OldFiboName=ObjectNameMQL4(i);
      if(ObjectTypeMQL4(OldFiboName)==OBJ_FIBO && Strategy != FourStrings) {
         CFibo fibo(OldFiboName);
         if(fibo.IsSelected()) continue;        // not procesing currently selected Fibos
         fibo.UpdateLevels();
         FiboCount++;
        } // if this is Fibo
     } // for on all objects
}








//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsThisChannel(string LineName) 
  {
   if(StringFind(LineName,"Channel for") == -1) return false;
   else return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SnapHorizLevelToBars(string DraggedObject) 
  {
// for D1 and S3 strategies. Detecting horizontal solid trend line or horiz box (rectangle)
// cycling from First Bar (Time 1) until the Last Bar (Time 2)
// Checking if there is any Open[] or Close[] price in the visinity of Snapping Distance (normally 20 pp)
// selecting the closest one and moving the object (Price1 and Price2) to that closest price

   CGraphObject obj(DraggedObject);
   double Price1 = obj.Price1(); 
   double Price2 = obj.Price2(); 

   if(ObjectTypeMQL4(DraggedObject) == OBJ_TREND) {
      // checking trend line...
      if(ObjectGetMQL4(DraggedObject,OBJPROP_RAY_RIGHT)) return;
      if(ObjectGetMQL4(DraggedObject,OBJPROP_STYLE) != STYLE_SOLID) return;
      if(Price1 != Price2) return; // line should be horizontal
      // snapping code....
      CTrend trend(DraggedObject);
      if (_Period == PERIOD_D1 || _Period == PERIOD_H4 || _Period == PERIOD_W1 || _Period == PERIOD_MN1) {
         trend.SnapTo(SnapHorizontalLinesOnMN1toH4To);
      }
      else if (_Period == PERIOD_H1 || _Period == PERIOD_M30 || _Period == PERIOD_M15 || _Period == PERIOD_M5 || _Period == PERIOD_M1) {
         trend.SnapTo(SnapHorizontalLinesOnH1toM1To);
      }      
   }
   else if (ObjectTypeMQL4(DraggedObject) == OBJ_RECTANGLE) {
      // checks for rectangles: rectangle should be horizontal: height should be less than 1/4 of the length
      CRectangle rect(DraggedObject);
      float ratio = rect.GetSidesRatio();
      if(ratio < 4) return;
      // snapping code....
      if (_Period == PERIOD_D1 || _Period == PERIOD_H4 || _Period == PERIOD_W1 || _Period == PERIOD_MN1) {
         rect.SnapTo(SnapHorizontalRectanglesOnMN1toH4To);
      }
      else if (_Period == PERIOD_H1 || _Period == PERIOD_M30 || _Period == PERIOD_M15 || _Period == PERIOD_M5 || _Period == PERIOD_M1) {
         rect.SnapTo(SnapHorizontalRectanglesOnH1toM1To);
      }  
   }
}
  




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SaveTemplateAndScrenshot(bool also_save_screenshot) 
  {
   string StrategyName;
   if(Strategy==Other) StrategyName="STR";
   else StrategyName=EnumToString(Strategy);
   
   MqlDateTime date_time;
   TimeLocal(date_time);
   
   //string TemplateFileName = StringFormat("", date_time.day);
   string TemplateFileName = TimeToString(TimeLocal(),TIME_DATE) + " " + StrategyName + " " + _Symbol + " srv " + TimeToString(TimeCurrent(),TIME_SECONDS) + " local " + TimeToString(TimeLocal(),TIME_SECONDS);
   StringReplace(TemplateFileName,":","-");


   HideShowButtons(); Minimize_Button.Hide(); // hiding all elements, so that anybody who doesn't have BF Tools will see undeleted elements.
   TradeManager.HideTradeManagerButtons();
   ShowMetaKeyPad(false);
   ChartSaveTemplate(0,TemplateFileName);
   ChartSaveTemplate(0,"\\Files\\" + TemplateFileName); // also saving to MQL\Files folder to enable function to apply template programmatically by ChartApplyTemplate() function
   ShowMetaKeyPad(true);
   HideShowButtons(); 
   Minimize_Button.Show();
   UpdatePositionOfAllButtons(0, X_Delta);

   Print("Template '"+TemplateFileName+"' is saved.");
   
   bool screenshot_saved = false;
   if (also_save_screenshot) 
      if (SaveAndCopyScreenshot_Func()) screenshot_saved = true;
   
   if (ThisChartActive()) {
      if (screenshot_saved)
         MessageOnChart("Template and screenshot saved and copied to clipboard", MessageOnChartAppearTime);
      else
         MessageOnChart("Template saved to '" + TemplateFileName + "'", MessageOnChartAppearTime);
   }
   if(SaveTemplate_Button.Pressed()) SaveTemplate_Button.Pressed(false);
   
    // also saving screenshot and copying it to clipboard
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


bool SaveAndCopyScreenshot_Func() {
   bool saved_and_copied;
   UpdatePositionOfAllButtons(0, ChartWidthInPixels() - 700); // Moving MetaTools to the left to make it visible on the screenshot

   long x = (int)ChartGetInteger(ChartID(),CHART_WIDTH_IN_PIXELS);
   long y = (int)ChartGetInteger(ChartID(),CHART_HEIGHT_IN_PIXELS);
   ObjectSetInteger(ChartID(),RightLowerInfo_Label.Name(),OBJPROP_XDISTANCE,x-5-460);
   ObjectSetInteger(ChartID(),RightLowerInfo_Label.Name(),OBJPROP_YDISTANCE,y-3-75);
   
   ObjectSetInteger(ChartID(),RightLowerInfoSymbol_Label.Name(),OBJPROP_XDISTANCE,x-5-460);
   ObjectSetInteger(ChartID(),RightLowerInfoSymbol_Label.Name(),OBJPROP_YDISTANCE,y-3-100);

   ShowMetaKeyPad(false);
   HideMainButtons();
   TodayRange_Label.Show();
   ATR5_Label.Show();
   ATR14_Label.Show();
   ATR180_Label.Show();
   
   saved_and_copied = SaveAndCopyScreenshot(EnumToString(Strategy));
   
   ShowMainButtons();
   ShowMetaKeyPad(true);
   UpdatePositionOfAllButtons(0, X_Delta); // Moving MetaTools back to its original position

   return saved_and_copied;
}



//void MessageOnChart(string msg) {
//   string label_name = "MessageOnChartLabel";
//   
//   ObjectCreateMQL4(label_name,OBJ_LABEL,0,0,0);
//   ObjectSetInteger(0,label_name,OBJPROP_ANCHOR,ANCHOR_LEFT_LOWER);
//   ObjectSetMQL4(label_name,OBJPROP_CORNER,0);
//   ObjectSetMQL4(label_name,OBJPROP_XDISTANCE,0);
//   ObjectSetMQL4(label_name,OBJPROP_YDISTANCE,ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0));
//   //ObjectSetInteger(ChartID(),label_name,OBJPROP_SELECTABLE,false);
//   ObjectSetInteger(ChartID(),label_name,OBJPROP_BACK,true);
//   ObjectSetTextMQL4(label_name,msg,18,"verdana",clrBlack);
//   MessageOnChartAppearTime = TimeLocal();
//   //Print("Message displayed on chart: '", msg , "'");
//}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AllDashDotDotTrendsToSolid() 
  {
   int obj_total=ObjectsTotalMQL4(); //total objects count
   for(int i= 0; i<obj_total; i++) { // for each object on the chart
      string objectName=ObjectNameMQL4(i);    // getting the object name
      if(ObjectTypeMQL4(objectName) != OBJ_TREND) continue;
      CTrend trend(objectName);
      trend.DashDotDotToSolid();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RestyleAllOutdatedTrends() 
  {

   int obj_total=ObjectsTotalMQL4(); //total objects count

   for(int i=0; i<obj_total; i++) { // for each object on the chart
      string objectName=ObjectNameMQL4(i);    // getting the object name
      if (ObjectTypeMQL4(objectName) == OBJ_TREND){
         CTrend trend(objectName);
         trend.RestyleOutdatedTrend();
      }
     }

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string GetChannelWidthTextNameByChannelName(string ChannelName) 
  {
   return ChannelName + " Width";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsTrendLowerThanAllLows(string TrendLineName) 
  {
// determines, if a trend is lower than all the lows between its control points

   datetime   t1 = (datetime)ObjectGetMQL4(TrendLineName,OBJPROP_TIME1);
   datetime   t2 = (datetime)ObjectGetMQL4(TrendLineName,OBJPROP_TIME2);
   int index1 = iBarShift(_Symbol,_Period,t1,true); // bar of the 1st control point
   int index2 = iBarShift(_Symbol,_Period,t2,true); // bar of the 2nd control point

   double LineValue;

   for(int i=index1-1; i>index2; i--) 
     { // cycle through all the bars between the control points
      LineValue=ObjectGetValueByShiftMQL4(TrendLineName,i,PERIOD_CURRENT);

      if(Low[i] <= LineValue) return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsTrendHigherThanAllHighs(string TrendLineName) 
  {
// determines, if a trend is higher than all the highs between its control points

   datetime   t1 = (datetime)ObjectGetMQL4(TrendLineName,OBJPROP_TIME1);
   datetime   t2 = (datetime)ObjectGetMQL4(TrendLineName,OBJPROP_TIME2);
   int index1 = iBarShift(_Symbol,_Period,t1,true); // bar of the 1st control point
   int index2 = iBarShift(_Symbol,_Period,t2,true); // bar of the 2nd control point

   for(int i=index1-1; i>index2; i--) 
     { // cycle through all the bars between the control points
      if(High[i] >= ObjectGetValueByShiftMQL4(TrendLineName,i,PERIOD_CURRENT)) return false;
     }
   return true;
  }






string GetChannelName(string TrendLineName)
  {
   return "Channel for " + TrendLineName;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetChannelColor(string TrendLineName,color clr) 
  {

   ObjectSetMQL4(GetChannelName(TrendLineName),OBJPROP_COLOR,clr);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AddChartToWatchlist(Probability Prob) {

   Print(__FUNCTION__ + ": adding chart to watch list with '" + EnumToString(Prob) + "' (" + (string)Prob + ")");

   if (InWatchList && SignalProbability == Prob) return; // this pair is already in watchlist with required probability

   int WatchedPairsCount=NumberOfElementsInIntArray(OpenChartIDs);
   string s_chartid = IntegerToString(ChartID());

   if(WatchedPairsCount>=ArraySize(ArrayOfWatchPairButtons)) { Alert("Watch List supports up to " + IntegerToString(ArraySize(ArrayOfWatchPairButtons)) + " pairs"); return; }

   short prio = 0;

   if (Prob == HighProbability) {
      GlobalVariableSet("InWL-"+_Symbol+"-"+s_chartid,2);
      prio = 2;
   }
   else if (Prob == LowProbability) {
      GlobalVariableSet("InWL-"+_Symbol+"-"+s_chartid,1);
      prio = 1;
   }
   else if (Prob == NormalProbability) {
      GlobalVariableSet("InWL-"+_Symbol+"-"+s_chartid,3);
      prio = 3; 
   }
   else if (Prob == NoProbability) {
      GlobalVariableSet("InWL-"+_Symbol+"-"+s_chartid,0);
      prio = 0;
   }
   else Print(__FUNCTION__ + ": Could NOT define Probability. Error in code!");
   
   // *************************************************************************************************************************
   // ***** creating a small mark on the chart which is not visible for users to record that this chart is in the watch list **
   // *************************************************************************************************************************
      ObjectDeleteSilent(WatchlistMark);
      datetime datetime1, datetime2;
      double   price;
      
      if (TimeDayOfWeekMQL4(TimeLocal()) == 6 || TimeDayOfWeekMQL4(TimeLocal()) == 0) {
         // if today is Saturday or Sunday - create mark in the 2nd part of the day
         datetime1 = iTime(_Symbol,PERIOD_D1,0) + 3600*20;
      }
      else {
         // if today is working day - create mark in the 1st part of the day
         datetime1 = iTime(_Symbol,PERIOD_D1,0) + 3600*2;
      }
      datetime2   = datetime1 + 3600*2;
      price       = iHigh(_Symbol,PERIOD_D1,0);
      
      ObjectCreate(ChartID(),WatchlistMark,OBJ_TREND,0,datetime1,price,datetime2,price);
      ObjectSetInteger(ChartID(),WatchlistMark,OBJPROP_WIDTH,2);
      ObjectSetInteger(ChartID(),WatchlistMark,OBJPROP_RAY_RIGHT,false);
      ObjectSetString(0,WatchlistMark,OBJPROP_TEXT,IntegerToString(prio));
      
      ObjectSetInteger(ChartID(),WatchlistMark,OBJPROP_COLOR,clrBlack);
      
      if (DebugMode) {
         ObjectSetInteger(ChartID(),WatchlistMark,OBJPROP_SELECTABLE,true);
         ObjectSetInteger(0,WatchlistMark,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1|OBJ_PERIOD_H4);
      }
      else {
         ObjectSetInteger(ChartID(),WatchlistMark,OBJPROP_SELECTABLE,false);
         ObjectSetInteger(0,WatchlistMark,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
      }
   // *************************************************************************************************************************
   // *************************************************************************************************************************
   // *************************************************************************************************************************
   
   
   
   SetHighLow_WL_Buttons(Prob);
   
   InWatchList = true;
 
   UpdateLevelsArray(); // array of horizontal levels for D1 and S3
   // updating pos and vis of buttons, to re-aligh hours-delay buttons and <<<, >>> buttons
   UpdatePositionOfAllButtons(0, X_Delta);
   ShowHoursDelayButtons(true);
   //ShowMainButtons();
   //
   
   InitDayOfWeekLabels();
   
   SignalProbability = Prob; // setting global variable to the new value
   
   if (!S_Version) ToggleWartchListIcon(true);
   
   //UpdateWatchPairButtons();

   //Print("written text to the WatchListMark: " + ObjectGetString(0,WatchlistMark,OBJPROP_TEXT));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


void ToggleWartchListIcon(bool add = true) {

   if (S_Version || !CreateLabelsOnChart) return;

   string icon_name = "Watchlist Icon for " + TimeToString(iTime(_Symbol,PERIOD_D1,0));
   if (!add && (TimeDayOfWeekMQL4(TimeLocal()) == 0 || TimeDayOfWeekMQL4(TimeLocal()) == 6) ) return; // do not delete watch list icon when removing pair from the watch list on weekend
   
   ObjectDeleteSilent(ChartID(),icon_name);

   if (!add) return;

   // creating icon on the chart
   double price_coordinate  = iHigh(_Symbol,PERIOD_D1,0);
   datetime time_coordinate = iTime(_Symbol,PERIOD_D1,0) + 120*60;
   
   bool created = ObjectCreate(ChartID(),icon_name,OBJ_ARROW,0,time_coordinate,price_coordinate);
   if (!created) {
      Print(__FUNCTION__ + ": Could not create watch list icon '" + icon_name + "',. Error: " + IntegerToString(GetLastError()));
      return;
   }
   string Description = "Added to Watch List on " + TimeToString(TimeCurrent(),TIME_SECONDS) + " as " + EnumToString(SignalProbability) + "";
   color clr;
   if (SignalProbability == HighProbability) clr = clrDarkViolet;
   else clr = clrGray;
   ObjectSetInteger(0,icon_name,OBJPROP_ANCHOR,ANCHOR_BOTTOM);
   ObjectSetInteger(0,icon_name,OBJPROP_COLOR,clr);
   ObjectSetString(0,icon_name,OBJPROP_TOOLTIP,Description);
   ObjectSetInteger(0,icon_name,OBJPROP_SELECTABLE,true);
   ObjectSetInteger(0,icon_name,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1);
   ObjectSetInteger(0,icon_name,OBJPROP_ARROWCODE,51);
   ObjectSetTextMQL4(icon_name,Description,10);
   //Print(Description);
}



void SetHighLow_WL_Buttons(Probability Prob) {

   if (Prob == HighProbability) {
      HighlightButton(WL_InWL_High_Button,true);
      HighlightButton(WL_InWL_Low_Button,false);
   }
   
   else if (Prob == LowProbability) {
      HighlightButton(WL_InWL_Low_Button,true);
      HighlightButton(WL_InWL_High_Button,false);
   }

}

void RemoveChartFromWatchlist() {

   TradeManager.TradesArray.Update();

   if (TradeManager.TradesArray.TradesOpenOnSymbol(_Symbol) != 0) return;

   GlobalVariableSet("InWL-"+_Symbol+"-"+IntegerToString(ChartID()),0);
   ResetAllWatchButtons();
   HighlightWatchButton(-1);
   SetHoursDelay(-1,_Symbol);
   
   InWatchList = false;

   HighlightButton(WL_InWL_High_Button,false);
   HighlightButton(WL_InWL_Low_Button,false);
   
   ObjectDeleteSilent(WatchlistMark);

   UpdateWatchPairButtons();
   ShowHoursDelayButtons(false);
   
   // updating pos and vis of buttons, to re-aligh hours-delay buttons and <<<, >>> buttons
   UpdatePositionOfAllButtons(0, X_Delta);
   //ShowMainButtons();
   //
   InitDayOfWeekLabels();
   
   ToggleWartchListIcon(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsChartInWL(long Chart_ID) 
  {

   string g_var_name="InWL-"+ChartSymbol(Chart_ID)+"-"+IntegerToString(Chart_ID);
   if(GlobalVariableGet(g_var_name) != 0) return true;

   else return false;
  }

Probability ProbabilityInWatchList(long Chart_ID) {
   string g_var_name  = "InWL-"+ChartSymbol(Chart_ID)+"-"+IntegerToString(Chart_ID);
   int    g_var_value = (int)GlobalVariableGet(g_var_name);
   
   if      (g_var_value == 0) return NoProbability;
   else if (g_var_value == 1) return LowProbability;
   else if (g_var_value == 2) return HighProbability;
   else if (g_var_value == 3) return NormalProbability;
   else return NoProbability;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void HighlightButton(CButton &Btn,bool Highlight, bool UpdateFont = true, color Color = clrGreen) 
  {

   if(Highlight) 
     {
      Btn.Color(clrWhite);
      Btn.ColorBackground(Color);
      if (UpdateFont) Btn.Font("Calibri Bold");
     }
   else 
     {
      Btn.Color(clrBlack);
      Btn.ColorBackground(clrKhaki);
      if (UpdateFont) Btn.Font("Calibri");
      Btn.Pressed(false);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long NextChartIDinWL() 
  {

   int WatchedPairsCount=NumberOfElementsInIntArray(OpenChartIDs);
   long currChartID=ChartID();
   long nextChartID = 0;

   for(int i=0; i<WatchedPairsCount; i++) 
     {
      if(currChartID==OpenChartIDs[i]) 
        {
         nextChartID= OpenChartIDs[i+1];
         break;
        }

     }
   return nextChartID;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long PrevChartIDinWL() 
  {

   int WatchedPairsCount=NumberOfElementsInIntArray(OpenChartIDs);
   long currChartID = ChartID();
   long prevChartID = 0;
   
   if (!InWatchList) {
      // this current chart is not in watch list
      // then return - to the chart that before this one and that is in watch list
      // scan all the charts in the terminal from the end to the beginning and find return ID of the first one (after current one) that is in Watch List 
      short charts_in_terminal = (short)NumberOfElementsInIntArray(OpenChartInTerminalIDs);
      // find array id of this chart in the OpenChartIDs array
      //Print("charts_in_terminal = " + charts_in_terminal);
      short index = 0;
      for (short i = charts_in_terminal-1; i >= 0; i--) {
         if ( OpenChartInTerminalIDs[i] == ChartID() ) {
            index = i;
            break;
         }      
      }
      // index of this chart in the OpenChartIDs array is now found!
      // cycle from this index further to the beginning of the array to find the first one which is in the watch list
      long prev_chart_in_WL = 0;
      for ( short i = index; i >= 0; i-- ) {
         if (i < 0 ) break;
         if ( IsChartInWL(OpenChartInTerminalIDs[i]) ) {
            prev_chart_in_WL = OpenChartInTerminalIDs[i];
            break;
         }
      }
      return prev_chart_in_WL;
   }

   for(int i=0; i<WatchedPairsCount; i++) 
     {
      if(currChartID==OpenChartIDs[i]) 
        {
         if(i>0) { prevChartID=OpenChartIDs[i-1]; }
         break;
        }

     }
   return prevChartID;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void NextChartInWL() 
  {
   long nextChartID = NextChartIDinWL();
   if(nextChartID!=0) { 
      SwitchToChart(nextChartID); 
      //SwitchTo_H1(nextChartID); - could not make it work
   }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PrevChartInWL() 
  {
   long prevChartID = PrevChartIDinWL();
   if(prevChartID!=0) { 
      SwitchToChart(prevChartID); 
      //SwitchTo_H1(prevChartID); - could not make it work
   }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ClearWatchList() {

// scan through all the global variable responsible for being in WL and set them to 0
   int total=GlobalVariablesTotal();
   TradeManager.TradesArray.Update();

   for(int i=0;i<total;i++) {
      if(StringFind(GlobalVariableName(i),"InWL-")!=-1)  {
         // first we check, if there is order opened for this pair
         string SymbolBeingChecked = GetSymbolByGlobalVariableIndex(i);
         
         if (TradeManager.TradesArray.TradesOpenOnSymbol(SymbolBeingChecked)==0) { // no orders opened on this chart - now we delete it from the WL

            SetHoursDelay(-1,SymbolBeingChecked);
            if(SymbolBeingChecked==_Symbol) { // current chart is the one being deleted from the WL now
               ResetAllWatchButtons();
               HighlightWatchButton(-1);
            }
            GlobalVariableDel(GlobalVariableName(i));
        }
     }
   UpdateWatchPairButtons();
   BroadcastEvent(ChartID(),0,"ClearWL");
  } // for
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CleanUpChartArrays() {

//Cleaning up both arrays. 
   for(int n=0; n<ArraySize(OpenChartSymbols); n++) 
     {
      OpenChartSymbols[n]=NULL;
     }
   for(int m=0; m<ArraySize(OpenChartIDs); m++) 
     {
      OpenChartIDs[m]=NULL;
     }
// --- end of arrays cleaned up

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RefreshStrategy() {
   
   Strategy = StrategySelector;
   return;
   
}


void RefreshComment() {
   string comment;
   string prob;
   SignalProbability = ProbabilityInWatchList(ChartID());
   if (SignalProbability == HighProbability)
      prob = "High";
   else if (SignalProbability == LowProbability)
      prob = "Low";
   else
      prob = "Not in Watch List";

   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(_Symbol ,Latest_Price); // Assign current prices to structure 

   // define type of the account
   ENUM_ACCOUNT_TRADE_MODE account_type=(ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE);
   string trade_mode;
   if (SimulatorMode) {
      trade_mode = "Simulator Mode";
   }
   else {
      switch(account_type)
        {
         case  ACCOUNT_TRADE_MODE_DEMO:
            trade_mode="Demo";
            break;
         case  ACCOUNT_TRADE_MODE_CONTEST:
            trade_mode="Competition Account";
            break;
         default:
            trade_mode="Real Account";
            break;
        }
   }
   //
   
   
   if (DayPriority != None && Strategy != Other) 
      comment = "Strategy: " + EnumToString(Strategy) + " | " + trade_mode + "\n" + "Priority: " + EnumToString(DayPriority) + " " + prob + " | ";
   else if (DayPriority == None && Strategy != Other)
      comment = "Strategy: " + EnumToString(Strategy) + " | " + trade_mode + "\n" + prob + " | ";
   else if (DayPriority != None && Strategy == Other)
      comment = "Priority: " + EnumToString(DayPriority) + " " + prob + " | ";
   
   //comment = comment + "Spread: " + DoubleToString((Latest_Price.ask-Latest_Price.bid)/_Point/10,1) + " | " + DoubleToString(AvgSpread,1);
   comment = comment + "Spread: " + TradeManager.GetSpreadString(TradeManager.GetSpread());


   if (LightVersion) {
      comment += "\n" + "Free Version" + " | https://metatools.online";
   }
   else if (DemoVersion) {
      if (TimeCurrent() < DemoVersionUntil)
         comment += "\n" + "Demo Version Until " + TimeToString(DemoVersionUntil) + " | Visit https://metatools.online";
      else
         comment += "\n" + "This Demo Version Expired On " + TimeToString(DemoVersionUntil) + " | Visit https://metatools.online/contact";
   }
   else if (SubscriptionVersion) {
      if (TimeCurrent() < SubscriptionUntil)
         comment += "\n" + "Subscription Until " + TimeToString(SubscriptionUntil) + "";
      else
         comment += "\n" + "This Subscription Expired On " + TimeToString(SubscriptionUntil) + " | Visit https://metatools.online/contact";
   }



   if (DebugMode) {
   
      comment += "\n" + "Debug Mode" + "\n" + "--------------------";
      
      comment += "\n" + " ========= WATCH LIST =========";
      comment += "\n" + "InWatchList = " + IntegerToString(InWatchList);
      comment += "\n" + "StartAlertsEveryHourAtMin: " + IntegerToString(StartAlertsEveryHourAtMin);
      int i_today = TimeDayOfWeekMQL4(TimeLocal());
      comment += "\n" + "Day of Week = " + IntegerToString(i_today);
      
      
      comment += "\n" + "\n" + " ======= TRADE MANAGER =======";
      TradeManager.TradesArray.Update();
      int trades_on_symbol = TradeManager.TradesArray.TradesOpenOnSymbol( _Symbol );
      int trades_count = TradeManager.TradesArray.TradesCount();
      
      comment += "\n" + "Open Trades on " + _Symbol + ": " + IntegerToString(trades_on_symbol);
      comment += "\n" + "Limit Trades on " + _Symbol + ": " + IntegerToString(TradeManager.TradesArray.LimitTradesCountOnSymbol(_Symbol));
      double break_even_level = sets.BreakEvenLevel();
      comment += "\n" + "Break Even Level: " + DoubleToString(break_even_level,5);
      comment += "\n" + "Backwards Break Level: " + DoubleToString(sets.BackwardsBreakLevel(),5);
     
      
      
      if (trades_on_symbol == 1 && break_even_level != 0) {
         // calculating distance from current price to break even
         double current_price = 0;
         ENUM_ORDER_TYPE trade_type;
         // define current price first depending on the current order type
         for (int i = 0; i < trades_count; i++) {
            // find that one trade on this symbol and check its type
            if (TradeManager.TradesArray.Trades[i].TradeSymbol() == _Symbol) {
               trade_type = TradeManager.TradesArray.Trades[i].TradeType();
               if (trade_type == OP_BUY || trade_type == OP_BUYLIMIT || trade_type == OP_BUYSTOP)
                  current_price = Latest_Price.bid;
               else
                  current_price = Latest_Price.ask;
               break;
             }
         }
         comment += "\n" + "Distance from price to break even: " + DoubleToString(MathAbs(break_even_level - current_price) / _Point / 10,1);
      }
   
      comment += "\n" + "Levels: " + IntegerToString(ArraySize(Levels));
      for (int i=0; i<ArraySize(Levels); i++) {
         comment += "\n" + "   "+IntegerToString(i)+": " + EnumToString(Levels[i].TradeDirection) + " '" + Levels[i].Name + "' @ " + DoubleToString(Levels[i].Price(),5);
      }
      comment += "\n" + "AutoEntryControl.TradeDirection: " + EnumToString(TradeManager.AutoEntryControl.TradeDirection);
      comment += "\n" + "sets.AutoDeleteLimitOnTimer: " +  (string)sets.AutoDeleteLimitOnTimer;
      comment += "\n" + "sets.AutoDeleteLimitOnTimerAt: " +  (string)sets.AutoDeleteLimitOnTimerAt;
      comment += "\nServer Time: " + TimeToString(TimeCurrent(),TIME_SECONDS);

   
   }


   Comment(comment);
}







void UpdateATRLabels() {

   bool jpy    = isJPY();
   bool crypto = isCRYPTO();
   bool oil    = isOIL(); 
   bool gold   = isGOLD();
   string label;

   string units;
   if (gold || oil) units = "$";


//   // *************************   ATR5  *************************
//   #ifdef __MQL5__
//      ATR5 = (float)MathRound(iATR(_Symbol,PERIOD_D1,5)/_Point);
//   #else 
//      ATR5 = (float)MathRound(iATR(_Symbol,PERIOD_D1,5,1)/_Point);
//   #endif 
//   
//  
//   if (_Digits == 5) ATR5 = ATR5/10;
//   if (crypto) {
//      ATR5 = ATR5/100;
//      if (_Symbol == "RIPPLE" || _Symbol == "DOGECOIN" || _Symbol == "SOLANA")
//         ATR5 = ATR5 * 100;
//   }
//   if (jpy) ATR5 = ATR5/10;
//   if (oil || gold) ATR5 = ATR5/100;

   ATR5 = ATR(5);
   if (oil)  label = units + DoubleToString(ATR5,2);
   else if (gold) label = units + DoubleToString(ATR5,1);
   else label = IntegerToString((int)ATR5);
   ATR5_Label.Text(label);
   
   
   // *************************   ATR14  *************************
   //#ifdef __MQL5__
   //   ATR14 = (float)MathRound(iATR(_Symbol,PERIOD_D1,14)/_Point);
   //#else 
   //   ATR14 = (float)MathRound(iATR(_Symbol,PERIOD_D1,14,1)/_Point);
   //#endif 
   //if (_Digits == 5) ATR14 = ATR14/10;
   //if (crypto) {
   //   ATR14 = ATR14/100;
   //   if (_Symbol == "RIPPLE" || _Symbol == "DOGECOIN" || _Symbol == "SOLANA")
   //      ATR14 = ATR14 * 100;
   //}
   //if (jpy) ATR14 = ATR14/10;
   //if (oil || gold) ATR14 = ATR14/100;
   
   
   ATR14 = ATR(14);
   if (oil)  label = units + DoubleToString(ATR14,2);
   else if (gold) label = units + DoubleToString(ATR14,1);
   else label = IntegerToString((int)ATR14);
   ATR14_Label.Text(label);
   
   // *************************   ATR180  *************************
//   #ifdef __MQL5__
//      ATR180 = (float)MathRound(iATR(_Symbol,PERIOD_D1,180)/_Point);
//   #else 
//      ATR180 = (float)MathRound(iATR(_Symbol,PERIOD_D1,180,1)/_Point);
//   #endif 
//   
//   if (_Digits == 5) ATR180 = ATR180/10;
//   if (crypto) {
//      ATR180 = ATR180/100;
//      if (_Symbol == "RIPPLE" || _Symbol == "DOGECOIN" || _Symbol == "SOLANA")
//         ATR180 = ATR180 * 100;
//   }
//   if (jpy) ATR180 = ATR180/10;
//   if (oil || gold) ATR180 = ATR180/100;

   ATR180 = ATR(180);
   
   if (oil)  label = units + DoubleToString(ATR180,2);
   else if (gold) label = units + DoubleToString(ATR180,1);
   else label = IntegerToString((int)ATR180);
   ATR180_Label.Text(label);
   // ***************************************************************************
   
   
   double TodayRange = NormalizeDouble(  (iHigh(_Symbol,PERIOD_D1,0) - iLow(_Symbol,PERIOD_D1,0))  /_Point / 10, 2);
   if (_Digits == 5 && oil)  TodayRange = TodayRange/100;
   if (jpy)                  TodayRange = TodayRange/1;
   if (crypto)               TodayRange = TodayRange/10;
   if (oil || gold)          TodayRange = TodayRange/10; 
   double ratio;
   if (ATR14 != 0 )
       ratio = NormalizeDouble((double)TodayRange/(double)ATR14,2);
   else ratio = 0;
   if (S_Version) {
      if (gold)
         TodayRange_Label.Text(units + DoubleToString(TodayRange,1));
      else if (oil)
         TodayRange_Label.Text(units + DoubleToString(TodayRange,2));
      else
         TodayRange_Label.Text(DoubleToString(TodayRange,0));
   }
   else TodayRange_Label.Text(DoubleToString(ratio*100,0) + "%");
   
   if (TodayRange > ATR14*0.75) {
      TodayRange_Label.Color(clrRed); 
   }   
   else {
      TodayRange_Label.Color(clrGray); 
   }
   
   if (StringLen(units) == 0) units = "pp";
   
   string s_TodayRange;
   if (oil || gold) s_TodayRange = units + DoubleToString(TodayRange,2);
   else s_TodayRange = DoubleToString(TodayRange,0) + "pp";
   
   string NewDescription = "Today's Range is " + s_TodayRange + "  |  " + DoubleToString(ratio*100,0) + "% of ATR(14 Days)";
   ObjectSetString(0,"TodayRange_Label",OBJPROP_TOOLTIP,NewDescription);
}





void UpdateATRLabelsPosition(int x_delta) {
   TodayRange_Label.Move(x_delta-20,5);
   ATR5_Label.Move(x_delta-20,20);
   ATR14_Label.Move(x_delta-20,35);
   ATR180_Label.Move(x_delta-20,50);
   
   string TodaysRange = TodayRange_Label.Text();
   string s_ATR5 = ATR5_Label.Text();
   string s_ATR14 = ATR14_Label.Text();
   string s_ATR180 = ATR180_Label.Text();

   if(StringLen(TodaysRange) == 3)         TodayRange_Label.Shift   (-8,0); 
   else if (StringLen(TodaysRange) == 4)   TodayRange_Label.Shift   (-16,0); 
   else if (StringLen(TodaysRange) == 5)   TodayRange_Label.Shift   (-22,0); 
   else if (StringLen(TodaysRange) == 1)   TodayRange_Label.Shift   (2,0); 
      
   if(StringLen(s_ATR5) == 3)         ATR5_Label.Shift   (-6,0); 
   else if (StringLen(s_ATR5) == 4)   ATR5_Label.Shift   (-12,0); 
   else if (StringLen(s_ATR5) == 5)   ATR5_Label.Shift   (-18,0); 
   else if (StringLen(s_ATR5) == 1)   ATR5_Label.Shift   (6,0); 
   
   if(StringLen(s_ATR14) == 3)        ATR14_Label.Shift  (-6,0);
   else if (StringLen(s_ATR14) == 4)  ATR14_Label.Shift   (-12,0);
   else if (StringLen(s_ATR14) == 5)  ATR14_Label.Shift   (-18,0); 
   else if (StringLen(s_ATR14) == 1)  ATR14_Label.Shift   (6,0);  
   
   if(StringLen(s_ATR180) == 3)       ATR180_Label.Shift (-6,0); 
   else if (StringLen(s_ATR180) == 4) ATR180_Label.Shift   (-12,0); 
   else if (StringLen(s_ATR180) == 5) ATR180_Label.Shift   (-18,0); 
   else if (StringLen(s_ATR180) == 1) ATR180_Label.Shift   (6,0);
}






void ColorSelectedObjects(color Colour) {
   if (!isSelectedObjectModificationAllowed()) return;
     for (int i = 0; i < ObjectsTotalMQL4(); i++) { // for each object on the chart
      string objectName = ObjectNameMQL4(i);    // getting the object name
      if (ObjectGetMQL4(objectName, OBJPROP_SELECTED) == 1) {    // is this object is selected then...
      
         if (!IsModificationAllowed(objectName)) {
            MessageOnChart("Color of '" + objectName + "' is Not Modified", MessageOnChartAppearTime);
            continue;
         }
      
         if(ObjectTypeMQL4(objectName)==OBJ_FIBO)
         {
            ObjectSetMQL4(objectName,OBJPROP_LEVELCOLOR,Colour);
         }
         else
         {
            ObjectSetMQL4(objectName,OBJPROP_COLOR,Colour);
            SetChannelColor(objectName, Colour);
         }
      }
   }
}

void SwitchAllChartsToTF(ENUM_TIMEFRAMES period) {
   int count=0;
   long chartid=ChartFirst();
 
   do {
      if (period == PERIOD_H1) {
         //if (IsChartInWL(chartid)) {
            ChartSetInteger(chartid,CHART_EVENT_OBJECT_DELETE,false); // disable detection of objects deletion to prevent processing of deletation of UI elements
            ChartSetSymbolPeriod(chartid,ChartSymbol(chartid),period);
         //}
      }
      else { 
         ChartSetInteger(chartid,CHART_EVENT_OBJECT_DELETE,false); // disable detection of objects deletion to prevent processing of deletation of UI elements
         ChartSetSymbolPeriod(chartid,ChartSymbol(chartid),period);
      }
      
      //setting the right scale
      if (period == PERIOD_H1 || period == PERIOD_H4) {
         if (Strategy == D1)
            ChartSetInteger(0,CHART_SCALE,0,3);
         else
            ChartSetInteger(chartid,CHART_SCALE,0,2); 
      }
      else if (period == PERIOD_D1) ChartSetInteger(chartid,CHART_SCALE,0,3); 
      
      chartid=ChartNext(chartid);
      count++;
   } // do
   while(chartid!=-1);
   
   BroadcastEvent(ChartID(),0,"HIDE_PSC");
   
   return;
}










bool IsObjectInYesterday(string objectName) {
   datetime DateOfObject = (datetime)ObjectGetMQL4(objectName,OBJPROP_TIME1);
   DateOfObject = DateOfDay(DateOfObject);
   if (DateOfObject == Yesterday()) 
      return true;
   else return false;
}

// ===============================



void UpdateLevelsArray() {

   // delete all labels and reset Levels array to 0, if this chart is not in WL, or if the strategy is not allowed
   if (!InWatchList &&  ArraySize(Levels)>0) {
      //Print("Deleting labels for ",ArraySize(Levels)," levels...");
      for (int i = 0; i < ArraySize(Levels); i++) {
         if (!Levels[i].DeleteLabels()) Print("Couldn't delete label '",Levels[i].LevelTimesBrokenLabelName(),"'");
      }
      ArrayResize(Levels,0); // delete current values and make the array size to zero
      return;
   }
   
   if (!InWatchList) return;

   // Find levels    
   ArrayResize(Levels,0); // delete current values and make the array size to zero
   int obj_total=ObjectsTotalMQL4(); //total objects count
   for(int i=0; i<obj_total; i++) { // for each object on the chart
   
      string objectName = ObjectNameMQL4(i);    // getting the object name
      if (ObjectTypeMQL4(objectName) == OBJ_TREND) {
         //first we delete existing labels
         CLevel level(objectName);
         level.DeleteLabels();

         // then - check conditions, if this line qualifies as tradable level
         if (!level.HasRay()) { // no ray
            if (level.IsHorizontal()) { // line is horizontal
               if (ObjectGetMQL4(objectName,OBJPROP_STYLE) == STYLE_SOLID) { // line should be solid
                  if (level.DateTime2() > TimeCurrent() && level.HoursBetweenControlPoints() > 8) { // 2nd point is within today && 1st point is in the beginning of today or earlier
                     
                     //Print("-1");
                     if (ObjectGetMQL4(objectName,OBJPROP_COLOR) == clrRed || ObjectGetMQL4(objectName,OBJPROP_COLOR) == clrGreen) {
                        //Print("0"); // не понятно почему не проходит проверку верхний IF при тестировании на BTC в воскр....
                        int LastBrokenByBarIndex=0;
                        int TimesBroken = level.TimesBroken(PERIOD_H1,LastBrokenByBarIndex);
                        
                        if (Strategy == D1) {
                           //Print("1");
                           if (TimesBroken == 2 && LastBrokenByBarIndex > 1) continue; // keep levels which broken 2 times, but last break is done with last bar; it is necessary to remain this level, because we measure entry parameters from it (Bar Close dist, Entry dist)
                           //Print("2");
                           if (TimesBroken > 2 ) continue;
                        }
                        
                        ArrayResize(Levels, ArraySize(Levels) + 1);     //  grow the array size by 1 cell
                        Levels[ArraySize(Levels) - 1] = level;       //  save found level into the array 
                        Print("New Level added: " + level.Name + "; Total levels: " + IntegerToString(ArraySize(Levels)));
                     }  
                  }
               }
            }
         }      
      }
   } // for 



   if ( (_Symbol == "EURAUD" || _Symbol == "GBPAUD") && Strategy == D1 ) { 
      // adding round levels
  
      CLevel fake_level(""); // fake instance just to take out standard names of round levels

      CLevel level_minus1(fake_level.RoundLevel_Minus1_Name);  
      CLevel level_plus1(fake_level.RoundLevel_Plus1_Name);
      level_minus1.DeleteLabels();
      level_plus1.DeleteLabels();
      if (DayPriority == Buy) {
         level_minus1.TradeDirection = Buy_Level;
         level_plus1.TradeDirection = Buy_Level;
      }
      else if (DayPriority == Sell) {
         level_minus1.TradeDirection = Sell_Level;
         level_plus1.TradeDirection = Sell_Level;
      }
      
      int LastBrokenByBarIndex=0;
      if (level_minus1.TimesBroken(PERIOD_H1,LastBrokenByBarIndex) < 2) {
         ArrayResize(Levels, ArraySize(Levels) + 1);            //  grow the array size by 1 cell
         Levels[ArraySize(Levels) - 1] = level_minus1;          //  save round level into the array 
      }
      
      if (level_plus1.TimesBroken(PERIOD_H1,LastBrokenByBarIndex) < 2) {
         ArrayResize(Levels, ArraySize(Levels) + 1);            //  grow the array size by 1 cell
         Levels[ArraySize(Levels) - 1] = level_plus1;           //  save round level into the array 
      }
   }
   
   

   if (ArraySize(Levels)>0){ 
      //Print("Levels found: ", ArraySize(Levels));
      for (int i = 0; i < ArraySize(Levels); i++) {
         Levels[i].DeleteLabels(); // here insteaf of earlier in this method
         Levels[i].UpdateLabel(Strategy,DayPriority);
      }
   }
   else {
      //Print("No Levels found");
   }

}


void UpdateStatusOfAllTrends() { // solid -> dashed, if broken
   int obj_total=ObjectsTotalMQL4(); //total objects count
   for(int i=0; i<obj_total; i++) { // for each object on the chart
      string objectName = ObjectNameMQL4(i);    // getting the object name
      if (ObjectTypeMQL4(objectName) == OBJ_TREND) {
         if (ObjectGetMQL4(objectName,OBJPROP_RAY_RIGHT)) { // has ray
            if (ObjectGetMQL4(objectName,OBJPROP_PRICE1) != ObjectGetMQL4(objectName,OBJPROP_PRICE2)) { // line is not horizontal
               if (ObjectGetMQL4(objectName,OBJPROP_STYLE) == STYLE_SOLID) { // line is solid
                  CTrend trend(objectName);
                  trend.UpdateStatus();
               }
            }
         }
      }
   }
}







void ChartCheckNeededSet(ChartCheckNeeded ccn, string symbol, long chartid) {

   GlobalVariableSet("ChartCheckNeeded-"+symbol+"-"+IntegerToString(chartid),ccn);

}

ChartCheckNeeded ChartCheckNeededGet(string symbol, long chartid) {
   return (ChartCheckNeeded)GlobalVariableGet("ChartCheckNeeded-"+symbol+"-"+IntegerToString(chartid));
}





void ToggleSoundControl() {

   if (IsSoundControlON()) SoundControlSet(false);
   else SoundControlSet(true);

}


void TogglePushControl() {

   if (IsPushControlON()) PushControlSet(false);
   else PushControlSet(true);

}


bool IsSoundControlON() {
   int sound = (int)GlobalVariableGet("SoundControl");
   if (sound == 1) return true;
   else return false;   
}

void SoundControlSet(bool ON) {

   if (ON) {
      GlobalVariableSet("SoundControl",1);
      HighlightButton(SoundControl_Button,true);
   }
   else {
      GlobalVariableSet("SoundControl",0);
      HighlightButton(SoundControl_Button,false);
   }
}


bool IsPushControlON() {
   int push = (int)GlobalVariableGet("PushControl");
   if (push == 1) return true;
   else return false;   
}

void PushControlSet(bool ON) {

   if (ON) {
      GlobalVariableSet("PushControl",1);
      HighlightButton(PushControl_Button,true);
   }
   else {
      GlobalVariableSet("PushControl",0);
      HighlightButton(PushControl_Button,false);
   }
   sets.InformedAbCheckTheChart = false;
   sets.InformedAbPinBar = false;
   sets.InformedAbS3imp = false;
   sets.InformedAbThreat = false;
   sets.SaveSettingsOnDisk();
}

bool IsInformer() {

   // find out, if this chart is the first one in the terminal that is added to the watch list - this is the informer BF Tools
   int WatchedPairsCount=NumberOfElementsInIntArray(OpenChartIDs);
   if (WatchedPairsCount == 0) return false; // no charts in the watch list - nobody is the Informer

   if (OpenChartIDs[0] == ChartID()) return true;
   else return false;

}



void InformAboutHoursDelay1ForAllCharts() {
   //inform (push) about charts with HoursDelay = 1 - Check The Chart; for all the charts in the watch list
   
   if (S_Version) return;
      
   int charts_in_watchlist = NumberOfElementsInIntArray(OpenChartIDs);
   
   //Print("charts_in_watchlist = ", charts_in_watchlist);
   
   if (charts_in_watchlist == 0) return;
   
   string msg;
   int pairs_with_hd1 = 0;
   
   // cycle through all the pairs in the watch list to find those with hours delay == 1
   // but if a pair has trade ON - do not inform about it, because it is already being informed via TradeManager.InformAboutOpenTradesForAllCharts()
   for (int i = 0; i < charts_in_watchlist; i++) {
      // !!! exclude pair, where 1+ trades are open - information about those is sent separately !!!
      if (TradeManager.TradesArray.TradesOpenOnChart(OpenChartIDs[i]) > 0) continue; // skip charts on which at least 1 order is open;       
   
      int hd = GetHoursDelayByChartID(OpenChartIDs[i],OpenChartSymbols[i]);
      
      Print("hd = ", hd);
      
      if (hd == 1) {
         if (StringLen(msg) > 0 ) msg = msg + ", ";
         
         msg = msg + SymbolAbbreviation(OpenChartSymbols[i]);
         pairs_with_hd1++;
      }
   }
   
   Print("msg = ", msg);
   if (StringLen(msg) == 0) return; // no pair has HoursDelay == 1;
   
   msg = EnumToString(Strategy) + ": Check " + IntegerToString(pairs_with_hd1) + " chart(s). " + msg;
   SendNotification(msg);
   
   Print(msg);

}












// ************************************************************************
// ************************************************************************
// ************************************************************************



bool NewHour() {
   MqlDateTime datetime_struct;
   
   
   if (SimulatorMode) 
      // this is needed because in SimulatorMode TimeCurrent() provides server real time, instead of the simulated time.
      TimeToStruct(iTime(_Symbol,PERIOD_H1,0), datetime_struct);
   else
      TimeCurrent(datetime_struct);
      
      
   //Print(__FUNCTION__);
   
   if    ( (datetime_struct.hour > PreviousHour) 
      || ( (PreviousHour >= 18 && PreviousHour <= 23) && (datetime_struct.hour >= 0 && datetime_struct.hour <= 10) )  // just in case prev known time was long time ago; also, if we are crossing midnight by server time
   ) { // new hour started!
         PreviousHour = datetime_struct.hour;
         return true;
   }
   else return false;
}


bool NewBar(ENUM_TIMEFRAMES period) { // taken from this link. See "Answer" section. https://stackoverflow.com/questions/49778099/mql4-listenting-to-candle-bar-open-event
   /* 
   This function, `NewBar`, is designed to check if a new bar (candlestick) has opened in a given period on a trading chart.
   
   Steps:
   1. Sets the `ArrayTime` as a series, to allow accessing the most recent data first.
   2. Retrieves the opening times of the latest two bars for the specified symbol and period, storing them in `ArrayTime`.
   3. If it's the first run (identified by `LastTime` being 0), it sets `firstRun` as true.
   4. Checks if `ArrayTime` is empty. If it is, returns false as there's no bar data to process.
   5. If the most recent bar's opening time (`ArrayTime[0]`) is greater than `LastTime`, meaning a new bar has opened:
      a. If it's not the first run, it sets `newBar` as true.
      b. Updates `LastTime` with the current bar's opening time.
   6. Returns `newBar`, which is true if a new bar has opened (excluding the first run) and false otherwise.
   
   Limitations:
   - If there's no data available (i.e., `ArrayTime` is empty), the function cannot detect a new bar and will return false.
   - The function relies on the internal state (`LastTime`). If not properly managed, it may result in inaccurate detections.
   */



   bool firstRun=false;
   bool newBar=false;

   ArraySetAsSeries(ArrayTime,true);
   CopyTime(_Symbol,period,0,2,ArrayTime);

   if(LastTime==0) firstRun=true;
   if (ArraySize(ArrayTime) == 0) return false;
   if(ArrayTime[0]>LastTime) {
      if(firstRun==false) newBar=true;
      LastTime=ArrayTime[0];
     }
   return newBar;
  }
  
  

bool NewDay() {
   // detection of new bar on D1
   // can give true only once per hour: if called from a different place - will return false (which may not be correct)
   if (D1_datetime != iTime(_Symbol,PERIOD_D1,0)) {
      Print("New D1 bar opened!");
      D1_datetime = iTime(_Symbol,PERIOD_D1,0);
      return true;
   }
   return false;
}



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string ParallelTrendName(string TrendName) { // Common function

   CTrend trend1(TrendName);

   for(int i=0; i<ObjectsTotalMQL4(); i++) 
     {
      string objectName=ObjectNameMQL4(i);
      if((ObjectTypeMQL4(objectName)==OBJ_TREND || ObjectTypeMQL4(objectName)==OBJ_CHANNEL) && objectName!=TrendName) {
         CTrend trend2(objectName);
                 
         double Trend1_Angle = trend1.Angle();
         double Trend2_Angle = trend2.Angle();
         if(Trend1_Angle==Trend2_Angle) 
           {
            return objectName;
           }
        }
     }
   return "";
  }
  
  
  











void HideShowAllObjectsToggle(bool keep_S3_levels = false, bool keep_BF_levels = false, bool scenarious_only = false, bool keep_UI = false) {
   // if leave_levels == true -> don't hide levels
   // scenarious_only == true -> switch off price scenarious only (dashed trends without ray)


   if (ObjectsHidden) {
      // showing
      string obj_name;
      int    obj_type;

      int obj_total=ObjectsTotalMQL4(); //total objects count
      for(int i=0; i < obj_total; i++) { // for each object on the chart
         obj_name = ObjectNameMQL4(i);
         obj_type = ObjectTypeMQL4(obj_name);
         
         if (obj_type == 23 || obj_type == 24 || obj_type == 25 || obj_type == 27 || obj_type == 28) continue;
         
         int tf_vis = ObjectTFbyName(obj_name);
         if (tf_vis != -1) ObjectSetInteger(ChartID(),obj_name,OBJPROP_TIMEFRAMES,tf_vis);
         
      }
      
      ArrayResize(object_names,0);
      ArrayResize(object_timeframes,0);
      
      if ( ChartGetInteger(ChartID(), CHART_SHOW_PERIOD_SEP) == false ) {
         // period separators are visible now - hiding
         ChartSetInteger(ChartID(),CHART_SHOW_PERIOD_SEP,true);
      }
      
      if (GlobalVariableGet("BFToolsShowAll") == 1) ShowButtons();
      
      ObjectsHidden = false;
   }

   else {
      // hiding
      // 1) Find all objects (qualifying for this hiding operation), get their names to an array
      // 2) get their visibility timeframes to an array
      // 3) save all the names and timeframes to settings file (for qualified* objects only)
      // 4) hide all the objects (qualified* objects only)
      // * 'qualified' means those which are defined by parameters of this function

      //string object_names[];        // global variable
      //int    object_timeframes[];   // global variable
      string obj_name;
      int    obj_type;

      int obj_total=ObjectsTotalMQL4(); //total objects count
      for(int i=0; i < obj_total; i++) { // for each object on the chart
      
         obj_name = ObjectNameMQL4(i);
         obj_type = ObjectTypeMQL4(obj_name);
         
         // ***** Hiding scenarious only ***
         if (scenarious_only && obj_type == 2) {   
            CTrend trend(obj_name);
            if ( trend.Style() == STYLE_DASH && !trend.HasRay() ) {
               //Print("Trend '", obj_name , "', style = '", ObjectGetMQL4(obj_name,OBJPROP_STYLE) ,"', HasRay = ", ObjectGetMQL4(obj_name,OBJPROP_RAY)); 
               ArrayResize(object_names, ArraySize(object_names) + 1); //  grow the array size by 1 cell
               object_names[ArraySize(object_names)-1] = ObjectNameMQL4(i);
               // 2)
               ArrayResize(object_timeframes, ArraySize(object_timeframes) + 1); //  grow the array size by 1 cell
               object_timeframes[ArraySize(object_timeframes)-1] = (int)ObjectGetMQL4(obj_name,OBJPROP_TIMEFRAMES);   
               // 4) Hidde the object
               trend.Hide();           
               continue; // skip to the next object
            }
            else
               continue; // skip to the next object
         }
         if (scenarious_only) continue; // check nothing else - continue to look for scenarious only
         // ********************
            
         
         if (keep_S3_levels) {
            //Print("Not hiding levels");
            CGraphObject obj(obj_name);
            if ( obj.IsS3Level() ) continue; // not hiding S3 levels
         }
         
         if (keep_BF_levels) {
            //Print("Not hiding levels");
            CGraphObject obj(obj_name);
            if ( obj.IsBFGraphObject() ) continue; // not hiding BF levels
         }

         if (obj_type == 23 || obj_type == 24 || obj_type == 25 || obj_type == 27 || obj_type == 28) continue;
         
            //Print("i = ", i, "; name = ", obj_name, "; tf = , ", (int)ObjectGetMQL4(obj_name,OBJPROP_TIMEFRAMES), "; Object Type = ", obj_type);
        
            // 1)
            
            ArrayResize(object_names, ArraySize(object_names) + 1); //  grow the array size by 1 cell
            object_names[ArraySize(object_names)-1] = ObjectNameMQL4(i);
            // 2)
            ArrayResize(object_timeframes, ArraySize(object_timeframes) + 1); //  grow the array size by 1 cell
            object_timeframes[ArraySize(object_timeframes)-1] = (int)ObjectGetMQL4(obj_name,OBJPROP_TIMEFRAMES);
            
            // 3)
            
            // 4) Hidde the object
            ObjectSetInteger(ChartID(),obj_name,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
         
      }
      Print("Array size = ", IntegerToString(ArraySize(object_names)));
      
      if (!scenarious_only) {
         int UI_Shown = (int)GlobalVariableGet("BFToolsShowAll"); // memorizing status of the flag for visibility of the main UI
         if (!keep_UI) HideButtons(); // 
         if (UI_Shown) GlobalVariableSet("BFToolsShowAll",1); // recovering the flag state, if it was 1
      }
      
      if ( ChartGetInteger(ChartID(), CHART_SHOW_PERIOD_SEP) == true ) {
         // period separators are visible now - hiding
         ChartSetInteger(ChartID(),CHART_SHOW_PERIOD_SEP,false);
      }
      
      ObjectsHidden = true;
   }
}


int ObjectTFbyName(string name) {
   int arr_size = ArraySize(object_timeframes);
   for (int i = 0; i < arr_size; i++) {
      if (object_names[i] == name) return object_timeframes[i];
   }
   //Print("name not found");
   return -1;
}











void Apply_FIX_Mode_and_Scale() {
   int per = _Period;
   if (per == PERIOD_H1) {
      if (sets.FixChartScale_H1_Zoom != -1) {   // setting pre-set scale
         ChartSetInteger(0,CHART_SCALE,0,sets.FixChartScale_H1_Zoom);
         ChartSetInteger(0,CHART_SCALEFIX,0,1);
         ChartSetDouble(0,CHART_FIXED_MAX,sets.FixChartScale_H1_Max);
         ChartSetDouble(0,CHART_FIXED_MIN,sets.FixChartScale_H1_Min);
      }
      else // applying default settings for H1
         Set_Chart_Default_Scale(0, per,Strategy);
   }
   else if (per == PERIOD_H4) {
      if (sets.FixChartScale_H4_Zoom != -1) {   // setting pre-set scale
         ChartSetInteger(0,CHART_SCALE,0,sets.FixChartScale_H4_Zoom);
         ChartSetInteger(0,CHART_SCALEFIX,0,1);
         ChartSetDouble(0,CHART_FIXED_MAX,sets.FixChartScale_H4_Max);
         ChartSetDouble(0,CHART_FIXED_MIN,sets.FixChartScale_H4_Min);
      }
      else // applying default settings for H4
         Set_Chart_Default_Scale(0, per,Strategy);
   }
   else if (per == PERIOD_D1) {
      if (sets.FixChartScale_D1_Zoom != -1) {   // setting pre-set scale
         ChartSetInteger(0,CHART_SCALE,0,sets.FixChartScale_D1_Zoom);
         ChartSetInteger(0,CHART_SCALEFIX,0,1);
         ChartSetDouble(0,CHART_FIXED_MAX,sets.FixChartScale_D1_Max);
         ChartSetDouble(0,CHART_FIXED_MIN,sets.FixChartScale_D1_Min);
      }
      else // applying default settings for D1
         Set_Chart_Default_Scale(0, per,Strategy);
   }
   else {
      Set_Chart_Default_Scale(0, per,Strategy);
   }
   ChartNavigate(0,CHART_END,0);
}



void Set_Chart_Default_Scale(long chart_id, int period, StrategyID strategy) {

   bool scale_change_queued = false;

   if (period == PERIOD_H1) {
      if (strategy == D1) {
         if ( ChartGetInteger(chart_id,CHART_SCALE) != 3 )
            scale_change_queued = ChartSetInteger(chart_id,CHART_SCALE,0,3); 
      }
      else {
         if ( ChartGetInteger(chart_id,CHART_SCALE) != 2 )
            scale_change_queued = ChartSetInteger(chart_id,CHART_SCALE,0,2);  
      }
   }
   else if (period == PERIOD_D1 || period == PERIOD_W1 || period == PERIOD_MN1) {
      if ( ChartGetInteger(chart_id,CHART_SCALE) != 3 ) {
         scale_change_queued = ChartSetInteger(chart_id,CHART_SCALE,0,3);   
      }
   }
   else {
      if ( ChartGetInteger(chart_id,CHART_SCALE) != 2 )
         scale_change_queued = ChartSetInteger(chart_id,CHART_SCALE,0,2); 
   }
   
   //if (scale_change_queued) Print("Chart scale queued");
   //else Print("Chart scale NOT queued");
   
   ChartSetInteger(chart_id,CHART_SCALEFIX,0,0); 
   
}


void CreateNewRectLevel() {
   
   CLevel level();
   level.CreateRectLevel(Mouse_X,Mouse_Y);
   level.AutoColor(S_Version);
   level.Select(true);
   
   level.SetDefaultVisibility();
}


void CreateNewTrend() {

   UnselectAll();
   CTrend trend();
   trend.Create(Mouse_X,Mouse_Y);
   trend.Select(true);
   

   trend.SetDefaultVisibility();
  
   // setting up ray
   if (Strategy == BF) trend.Ray(true);
   else
   trend.Ray(false);
   
   color trend_color;
   if (Strategy == BF) {
      // randomize colors
      int num = 1 + 11*MathRand()/32768; // random number between 1-11
      if     (num == 1) trend_color = CustomColor1_1;
      else if (num == 2) trend_color = CustomColor1_2;
      else if (num == 3) trend_color = CustomColor1_3;
      else if (num == 4) trend_color = CustomColor1_4;
      else if (num == 5) trend_color = CustomColor2_1;
      else if (num == 6) trend_color = CustomColor2_3;
      else if (num == 7) trend_color = CustomColor2_4;
      else if (num == 8) trend_color = CustomColor3_1;
      else if (num == 9) trend_color = CustomColor3_2;
      else if (num == 10) trend_color = CustomColor3_3;
      else if (num == 11) trend_color = CustomColor3_4;
      else trend_color = clrGreen;
   }  
   else
      trend_color = clrGreen;
   
   trend.Color(trend_color);
}



void InitHighLowOpenCloseArrays(int n = 100) {
      // filling up arrays of High and Low
      #ifdef __MQL5__
         n++; // adding 1 just in case, to avoid array-out-of-range errors
         ArrayResize(High,0);
         ArrayResize(Low,0);
         ArrayResize(Open,0);
         ArrayResize(Close,0);
         ArraySetAsSeries(High,true);
         ArraySetAsSeries(Low,true);
         ArraySetAsSeries(Open,true);
         ArraySetAsSeries(Close,true);
         CopyHigh(_Symbol,_Period,0,n,High);
         CopyLow(_Symbol,_Period,0,n,Low);
         CopyOpen(_Symbol,_Period,0,n,Open);
         CopyClose(_Symbol,_Period,0,n,Close);
      #endif 
}











void onDoubleClick(const int id,
                  const long& lparam,
                  const double& dparam,
                  const string& sparam)
{
   
   int x = (int)lparam;
   int y = (int)dparam;

   int window  = 0;
   datetime dt = 0;
   double   p  = 0;

   if (ChartXYToTimePrice(0, x, y, window, dt, p))
      onXYDoubleClick(window, x, y, dt, p,sparam);      
}

void onClick(const int id,
                  const long& lparam,
                  const double& dparam,
                  const string& sparam)
{
   int x = (int)lparam;
   int y = (int)dparam;

   int window  = 0;
   datetime dt = 0;
   double   p  = 0;

   if (ChartXYToTimePrice(0, x, y, window, dt, p))
      onXYClick(window, x, y, dt, p);      
}

void onXYDoubleClick(int window, int x, int y, datetime dt, double p, string sparam) {
   if (sparam == BreakEvenLineName || sparam == BackwardsBreakLineName) {
      CTradeLine line(sparam);
      if (!line.IsSelected()) {
         Print(line.Name + " is unselected");
      }
   }
}

void onXYClick(int window, int x, int y, datetime dt, double p) {
   //Print("Click");
}




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SendPushAlert(string txt) {
   //if(_Period!=AlertFromPeriod) { Print("Not sending push alert - not watching this time frame"); return; }
   if(GetHoursDelayByChartID(ChartID(),_Symbol)!=1) { Print("Not sending push alert - HoursDelay > 1"); return; }
   string per=TimeframeToString(_Period);
   txt=EnumToString(Strategy)+"-"+_Symbol+"@"+per+": "+txt;
   //Print(txt);
   if(IsPushControlON()) {
      if (!SendNotification(txt)) Print("Error sending push notification");
      else Print("Push Notification Sent: " + txt);
     }
   else
      Print("Push Control is OFF");
  }
  


void ClearTradingMarks() {
   // find and deletes all trading marks from the chart

   string array_of_names[12];
   array_of_names[0]  = "TP for #";
   array_of_names[1]  = "BreakEven for #";
   array_of_names[2]  = "Entry for #";
   array_of_names[3]  = "SL for #";
   array_of_names[4]  = "BackwardsBreak for #";
   array_of_names[5]  = "Entry Bar for #";
   array_of_names[6]  = "BarInfoIcon #";
   array_of_names[7]  = "SL Label for";
   array_of_names[8]  = "BreakEven Label for";
   array_of_names[9]  = "TP Label for";
   array_of_names[10] = "SL_in_Money_Label";
   array_of_names[11] = "EntryParam";
   int array_size = ArraySize(array_of_names);
   
   int obj_total=ObjectsTotalMQL4(); //total objects count
   string obj_name = "";
   int total_checked = 0; // counting how many objects did we check
   int total_deleted = 0; // counting how many did we delete
   for(int i = obj_total; i>=0; i--) { // for each object on the chart
      obj_name=ObjectNameMQL4(i);    // getting the object name
      total_checked++;
      for(int y = 0; y < array_size; y++) {
         int match = StringFind(obj_name, array_of_names[y]);
         if (match != -1) { // match is found
            ObjectDeleteSilent(obj_name);
            total_deleted++;
         }   
      }
   }
   string msg = "Checked: " + IntegerToString(total_checked) + " objects; Deleted: " + IntegerToString(total_deleted) + " trading marks";
   MessageOnChart(msg, MessageOnChartAppearTime);
   Print(msg);
}






void Watchlist_S3_Autobuild() {

   /*
   This function "Watchlist_S3_Autobuild" is designed to automate the process of creating and managing a watchlist for 'S3' trading strategy. Here are the steps it performs:
   
   1. It starts by cleaning up the chart from old H1-levels and turns some of them into D1-levels.
   2. It auto-prolongs D1 blue levels for further analysis of the previous day's bar.
   3. It defines the index of the yesterday candle, handling different cases for weekdays and weekends.
   4. It checks for a BUY level, by searching for an H1 pattern (green level) based on certain conditions.
   5. If the conditions are met, a buy level is created and added to the watchlist.
   6. It checks for a SELL level, by searching for an H1 pattern (red level) based on certain conditions. Sell signals are not built for indices.
   7. If the conditions are met, a sell level is created and added to the watchlist.
   8. It extends existing H1 levels based on whether a buy or sell level was created and adds them to the watchlist.
   9. It checks if any blue levels were tested by any D1-bars in the S3-pattern. If so, it raises the probability to HIGH.
   10. It adds the pair to the watchlist with the detected probability.
   
   Note: Engulfing detection has been disabled as it was not working well for the S3 strategy. 
   
   Limitations:
   - The function does not create sell signals for indices.
   - If the previous day's bar (yesterday candle) is on a weekend, it considers it as a current bar.
   - The function relies on several global variables, functions, and objects which need to be defined and instantiated correctly for it to work properly.
   */


   //if (Strategy != S3) return;
   
   // cleaning up chart from the old H1-levels and turning some of them to D1-levels
   CleanUpS3ChartFromH1Levels();
   
   // first, auto-prolonging D1 blue levels, because we will be checking if yesterday bar is testing any of them
   AutoProlongBlueLevels();
   // =====================
   

   // defining bar index of the yesterday candle
   int i_today = TimeDayOfWeekMQL4(TimeLocal());
   if (SimulatorMode) i_today = TimeDayOfWeekMQL4(iTime(_Symbol,PERIOD_H1,0));
   int yest_bar;

   if (i_today == 6 || i_today == 0) {
      // weekend
      yest_bar = 0;
   }
   else {
      // weekdays
      yest_bar = 1;
   }
   // =========================================
   
   CLevel level;
   Probability probability = LowProbability;
   bool buy_level_created = false;
   bool sell_level_created = false;
   bool add_to_watchlist = false;
   short pattern_start_bar = 0; // D1-bar where S3 pattern starts (the most left bar)
   
   Print(__FUNCTION__);
   
   // checking for BUY level... - searching for H1 pattern (green level)
   bool condition1 = iLow(_Symbol,PERIOD_D1,yest_bar) < iLow(_Symbol,PERIOD_D1,yest_bar+1);
   bool condition2 = iOpen(_Symbol,PERIOD_D1,yest_bar) >= iLow(_Symbol,PERIOD_D1,yest_bar+1);
   bool condition3 = iClose(_Symbol,PERIOD_D1,yest_bar) >= iLow(_Symbol,PERIOD_D1,yest_bar+1);
   bool isTooFar   = IsS3LevelTooFarFromPrice(iLow(_Symbol,PERIOD_D1,yest_bar+1));
   //Print(__FUNCTION__ + ". For BUY: condition1 = " + condition1 + "; condition2 = " + condition2 + "; condition3 = " + condition3 + "; isTooFar = " + isTooFar);
   if ( condition1 && condition2 && condition3 && !isTooFar ) {
      //Print("building buy level...");
      level.CreateH1Level(yest_bar+1, Buy_Level);
      buy_level_created = true;
      add_to_watchlist = true;
   }
   else {
      //Print("No buy level");
   }
   
   
   // checking for SELL level... - searching for H1 pattern (red level)
   if ( _Symbol != "SPX500" && _Symbol != "NQ100" ) {
      // do not build sell signal for indexies
      condition1 = iHigh(_Symbol,PERIOD_D1,yest_bar)  >  iHigh(_Symbol,PERIOD_D1,yest_bar+1);
      condition2 = iOpen(_Symbol,PERIOD_D1,yest_bar)  <= iHigh(_Symbol,PERIOD_D1,yest_bar+1);
      condition3 = iClose(_Symbol,PERIOD_D1,yest_bar) <= iHigh(_Symbol,PERIOD_D1,yest_bar+1);
      isTooFar   = IsS3LevelTooFarFromPrice(iHigh(_Symbol,PERIOD_D1,yest_bar+1));
      //Print(__FUNCTION__ + ". For SELL: condition1 = " + condition1 + "; condition2 = " + condition2 + "; condition3 = " + condition3 + "; isTooFar = " + isTooFar);
      if ( condition1 && condition2 && condition3 && !isTooFar ) {
         //Print("building sell level...");
         level.CreateH1Level(yest_bar+1, Sell_Level);
         sell_level_created = true;
         add_to_watchlist = true;
      }
      else {
         //Print("No sell level");
      }
   }
   
   pattern_start_bar = short(yest_bar+1); // by default - the most left bar is this; 
   
   ExtendExistingH1Levels(add_to_watchlist, buy_level_created, sell_level_created, yest_bar, pattern_start_bar);
   
   bool engulfing = false;
   
   // entgulfung detection is disabled because it is not working well and not a good signal for S3 strategy
   //if (!S_Version) {
   //   engulfing = DelectEngulfingS3Pattern(add_to_watchlist, buy_level_created, sell_level_created, yest_bar, pattern_start_bar);
   //   //if (engulfing) Print("Engulfing detected");
   //   //else Print("No engulfing");
   //}
   // *******
   
   
   if (add_to_watchlist && !InWatchList) {
      // checking, if we should raise the probability to HIGH
      // we do this only in case if yesterday extremum is testing a blue level
      
      // find all blue levels and check, if any of them was tested by any D1-bar in the S3-pattern
      // bars in the models - those which are touched by the signal level (red/greeen) 
      int obj_total = ObjectsTotalMQL4();
      string obj;
      for (int i = 0; i < obj_total; i++) {
         obj = ObjectNameMQL4(i);
         if ( ObjectTypeMQL4(obj) == OBJ_TREND ) {
            CLevel lvl(obj); // blue D1-level
            if ( lvl.IsHorizontal() && lvl.Style() == STYLE_SOLID && lvl.Color() == clrBlue && lvl.DateTime2() > TimeCurrent() ) {
               // check if this level was tested by one of bar in the S3-pannern
               
               // check if this blue D1 level is touched by any of the D1-bars in the pattern starting from pattern_start_bar (the most left one)
               double lvl_price = lvl.Price();
               for (short n = 0; n <= pattern_start_bar; n++) { // scan each bar which is included in the S3-pattern
                  double open      = iOpen( _Symbol,PERIOD_D1,n);
                  double close     = iClose(_Symbol,PERIOD_D1,n);
                  double high      = iHigh( _Symbol,PERIOD_D1,n);
                  double low       = iLow(  _Symbol,PERIOD_D1,n);
                  
                  if (buy_level_created) {
                     if ( low <= lvl_price && open >= lvl_price && close >= lvl_price ) {
                        probability = HighProbability;
                        break; // it is enough to find at least one blue level that was tested
                     }
                  }
                  if (sell_level_created) {
                     if ( high >= lvl_price && open <= lvl_price && close <= lvl_price ) {
                        probability = HighProbability;
                        break; // it is enough to find at least one blue level that was tested
                     }
                  }
               }
               
            }  // if ( lvl.IsHorizontal() && lvl.Style() == STYLE_SOLID...
         } // if TREND
      } // for
      // finally adding this pair to watch list with detected probability
      AddChartToWatchlist(probability);
   }
   // ------------------------------------------------
   
   
}

void Watchlist_S4_Autobuild() {

   Print("Searching for breaks of D1 levels...");

   // defining bar index of the yesterday candle
   int i_today = TimeDayOfWeekMQL4(TimeLocal());
   int yest_bar;

   if (i_today == 6 || i_today == 0) {
      // weekend
      yest_bar = 0;
   }
   else {
      // weekdays
      yest_bar = 1;
   }
   // =========================================

   // 1. cycle though all the objects to find RECTs, HLINEs and TRENDs
   // 2. find price levels to be checked for break by yesterday bar
   // 3. for rectangles check sell level (lower edge of rect) and buy level (upper edge)
   // 4. for non-horizontal trends: qualify only once-broken trends; check only one direction: sell or buy, depending on the ange of the trend
   // 5. For all objects: disqualify, if they do not stretch far enough to the right beyond the yesterda bar
   string obj;
   ENUM_OBJECT obj_type;
   int obj_total = ObjectsTotalMQL4();
   CBar bar(yest_bar,PERIOD_D1);
   if ( bar.OpenPrice() == bar.ClosePrice() ) return; // skip doji
   
   for (int i = 0; i < obj_total; i++) {
      double sell_level = 0; // resetting level for each object that is being checked
      double buy_level = 0;  // resetting level for each object that is being checked
      obj = ObjectNameMQL4(i);
      obj_type = (ENUM_OBJECT)ObjectTypeMQL4(obj);
      CGraphObject general_obj(obj);
      if ( !general_obj.IsVisibleOnTF(PERIOD_D1) ) continue; // skip objects that are not visble on D1

      if ( obj_type == OBJ_TREND || obj_type == OBJ_HLINE) {
         CTrend trend(obj);
         if (obj_type == OBJ_TREND) {
            if (trend.DateTime1() < iTime(_Symbol,PERIOD_D1,yest_bar) && trend.DateTime2() < iTime(_Symbol,PERIOD_D1,yest_bar) ) continue; // skip old levels
            if ( trend.IsHorizontal() ) { // make sure that D1-bar has broken this horizontal level
               if ( bar.IsBodyBlack() )
                  if ( !( bar.OpenPrice() > trend.Price1() && bar.ClosePrice() < trend.Price1() ) ) continue; // disqualify trends which are not broken by black bar
               if ( bar.IsBodyWhite() )
                  if ( !( bar.OpenPrice() < trend.Price1() && bar.ClosePrice() > trend.Price1() ) ) continue; // disqualify trends which are not broken by white bar
            }
         }
         if ( !trend.IsSolid() ) continue; // skip non-solid trends and HLINEs
         if ( obj_type == OBJ_HLINE ) {
            if ( bar.IsBodyBlack() && bar.OpenPrice() > trend.Price1() && bar.ClosePrice() < trend.Price1() )         
               sell_level = trend.Price1();
            else if ( bar.IsBodyWhite() && bar.OpenPrice() < trend.Price1() && bar.ClosePrice() > trend.Price1() )
               buy_level  = trend.Price1();
         }
         else { // this is OBJ_TREND
            if ( trend.IsHorizontal() ) {
               sell_level = trend.Price1();
               buy_level  = trend.Price1();
            }
            else {
               int n = 0;
               if ( trend.TimesBroken(PERIOD_D1,n) != 1 ) continue; // do not count breaks of trends that are broken not exactly once
               if ( trend.Price1() < trend.Price2() && bar.IsBodyBlack() ) { // trend is ascending and D1 bar is black
                  buy_level = 0;
                  double intersection_price = ObjectGetValueByShiftMQL4(trend.Name,yest_bar,PERIOD_D1);
                  if ( bar.OpenPrice() > intersection_price && bar.ClosePrice() < intersection_price ) // make sure that D1-bar broke the level
                     sell_level = intersection_price;
               }
               else if ( trend.Price1() > trend.Price2() && bar.IsBodyWhite() ) { // trend is descending and D1 bar is white
                  sell_level = 0;
                  double intersection_price = ObjectGetValueByShiftMQL4(trend.Name,yest_bar,PERIOD_D1);
                  if ( bar.OpenPrice() < intersection_price && bar.ClosePrice() > intersection_price ) // make sure that D1-bar broke the level
                     sell_level = intersection_price;
               }
            }
         }
      }
      else if ( obj_type == OBJ_RECTANGLE ) {
         // disqualify old RECT's that do not stretch beyond yesterday bar to the right
         CRectangle rect(obj);
         if (rect.DateTime1() < iTime(_Symbol,PERIOD_D1,yest_bar) && rect.DateTime2() < iTime(_Symbol,PERIOD_D1,yest_bar) ) continue; // skip old levels
         if ( bar.IsBodyBlack() ) {
            if ( bar.OpenPrice() < MathMax(rect.Price1(),rect.Price2()) ) continue; // open price of yesterday bar should be higher than level
            buy_level = 0;
            sell_level = MathMin(rect.Price1(),rect.Price2());
         }
         else { // body is white
            if ( bar.OpenPrice() > MathMin(rect.Price1(),rect.Price2()) ) continue; // open price of yesterday bar should be lower than level
            sell_level = 0;
            buy_level = MathMax(rect.Price1(),rect.Price2());
         }
      }

      
      // check what we have as buy_level and sell_level
      if ( sell_level != 0 && bar.IsBodyBlack() ) {
         if ( iClose(_Symbol,PERIOD_D1,yest_bar) < sell_level ) {
            Print(__FUNCTION__ + ": D1-break of level " + obj + " for SELL is detected. Adding to Watch List");
            if (!InWatchList) AddChartToWatchlist(LowProbability);
            return;
         }
      }
      if ( buy_level != 0 && bar.IsBodyWhite() ) {
         if ( iClose(_Symbol,PERIOD_D1,yest_bar) > buy_level ) {
            Print(__FUNCTION__ + ": D1-break of level " + obj + " for BUY is detected. Adding to Watch List");
            if (!InWatchList) AddChartToWatchlist(LowProbability);
            return;
         }
      }
   } // for  
}



bool DelectEngulfingS3Pattern(bool &add_to_watchlist, bool &buy_level_created, bool &sell_level_created, int yest_bar, short &pattern_start_bar) {

   // 1. Filtering out candles with too small bodies
   // Small body: body < 40% of ATR14
   
   CBar yest(yest_bar, PERIOD_D1);
   CBar before_yest(yest_bar+1, PERIOD_D1);
   
   double yest_body_size        = yest.Body() / 10; 
   double before_yest_body_size = before_yest.Body() / 10;

   //Print("yest_body_size: " + DoubleToString(yest_body_size,1));
   //Print("before_yest_body_size: " + DoubleToString(before_yest_body_size,1));
   //Print("ATR14: " + DoubleToString(ATR14,1));
   
   // filter out based on volatility: relative size of bodies to ATR14
   if ( yest_body_size        < ATR14*0.4 || yest_body_size        > ATR14*10)  { Print(__FUNCTION__ + ": Body of yesterday bar is too big or too small relative to ATR14"); return false; }
   if ( before_yest_body_size < ATR14*0.4 || before_yest_body_size > ATR14*10 ) { Print(__FUNCTION__ + ": Body of before-yesterday bar is too big or too small relative to ATR14"); return false; }
   
   // filtering on relative size of bodies (amount of engulfing)
   if ( before_yest_body_size >= yest_body_size*1.3 ) { Print("Body of yesterday's bar is too small relative to before yesterday"); return false; } 
   if ( before_yest_body_size <= yest_body_size*0.7 ) { Print("Body of yesterday's bar is too big relative to before yesterday"); return false; }
   
   // filtering on relation of wick size and bodies
   // wicks should not be longer than 85% of the body
   double yest_upper_wick = yest.UpperWick() / 10;
   double yest_lower_wick = yest.LowerWick() / 10;
   double before_yest_upper_wick = before_yest.UpperWick() / 10;
   double before_yest_lower_wick = before_yest.LowerWick() / 10;
   if (yest_upper_wick > yest_body_size*0.85) { Print(__FUNCTION__ + ": Yesterday upper wick > 85% of Yesterday Body"); return false; }
   if (yest_lower_wick > yest_body_size*0.85) { Print(__FUNCTION__ + ": Yesterday lower wick > 85% of Yesterday Body"); return false; }
   if (before_yest_upper_wick > before_yest_body_size*0.85) { Print(__FUNCTION__ + ": Before yesterday upper wick > 85% of Before yesterday Body"); return false; }
   if (before_yest_lower_wick > before_yest_body_size*0.85) { Print(__FUNCTION__ + ": Before yesterday upper wick > 85% of Before yesterday Body"); return false; }
   
   // check that one bar is black, another is white (not both are same color)
   if (yest.IsBodyBlack() && before_yest.IsBodyBlack() ) { Print(__FUNCTION__ + ": Both bodies are black - not engulfing"); return false; }
   if (yest.IsBodyWhite() && before_yest.IsBodyWhite() ) { Print(__FUNCTION__ + ": Both bodies are white - not engulfing"); return false; }
   
   CBar TestBar(yest_bar+2,PERIOD_D1); // bar which H1-level can be build upon
   // check if any bar of engulfing has created new extremums compared to TestBar
   bool buy_level = false;
   bool sell_level = false;
   if ( (yest.LowPrice()  < TestBar.LowPrice()  || before_yest.LowPrice()  < TestBar.LowPrice() )  &&  !IsS3LevelTooFarFromPrice(TestBar.LowPrice() )  ) buy_level = true;
   if ( (yest.HighPrice() > TestBar.HighPrice() || before_yest.HighPrice() > TestBar.HighPrice())  &&  !IsS3LevelTooFarFromPrice(TestBar.HighPrice())  ) sell_level = true;
   
   if ( _Symbol == "SPX500" || _Symbol == "NQ100" ) sell_level = false;
   
   CLevel level();
   if (buy_level)  {
      level.CreateH1Level(TestBar.Index(), Buy_Level);
      buy_level_created = true;
      add_to_watchlist = true;
   }
   if (sell_level) {
      level.CreateH1Level(TestBar.Index(), Sell_Level);
      sell_level_created = true;
      add_to_watchlist = true;
   }
   
   if ( TestBar.Index() > pattern_start_bar ) pattern_start_bar = short(TestBar.Index());
   
   return true; // engulfing detected!

}




void ExtendExistingH1Levels(bool &add_to_watchlist, bool &buy_level_created, bool &sell_level_created, int yest_bar, short &pattern_start_bar) {
   // for S3 Strategy only
   // Trying to extend existing not-yet-broken levels
   // 1. Find all red and green levels which have the right point time = time of yesterday D1 bar
   // 2. Make sure that such levels are not broken neither by yesterday D1 bar, nor by today's opening D1 bar
   int i_today = TimeDayOfWeekMQL4(TimeLocal());
   int obj_total = ObjectsTotalMQL4();
   string obj;
   for (int i = 0; i < obj_total; i++) {
      // scanning all the objects on the chart - search for red and green levels to extend
      obj = ObjectNameMQL4(i);
      if ( ObjectTypeMQL4(obj) == OBJ_TREND ) {
         CLevel lvl(obj);
                  
         if (  lvl.IsHorizontal() && lvl.Style() == STYLE_SOLID && // level is horizontal and solid
            (  lvl.DateTime2() == iTime(_Symbol,PERIOD_D1,yest_bar) 
            || lvl.DateTime2() == iTime(_Symbol,PERIOD_D1,yest_bar-1)
            || lvl.DateTime2() == iTime(_Symbol,PERIOD_D1,0) +  + 60*60*24 // on today's bar in case of now is weekend
            ) // right point is on one of two previous days or on today's bar (happens on weekends)
            && (lvl.Color() == clrGreen || lvl.Color() == clrRed) ) {     // it is either red or green (standard colors for sell and buy accordingly)        
            
            // check, if that level was not broken by yesterday bar
            bool broken1 = lvl.Price() > iOpen(_Symbol, PERIOD_D1,yest_bar) && lvl.Price() < iClose(_Symbol,PERIOD_D1,yest_bar); // within white bar;
            bool broken2 = lvl.Price() > iClose(_Symbol,PERIOD_D1,yest_bar) && lvl.Price() < iOpen(_Symbol, PERIOD_D1,yest_bar); // within black bar;
            bool broken3 = false;
            if (i_today != 6 && i_today != 0) {
               // checking for broken3 only if today is not weekend
               TradeDirectionType direction = lvl.GetTradeDirection();
               if (direction == Buy_Level) {
                  broken3 = iOpen(_Symbol,PERIOD_D1,0) < lvl.Price();
               }
               else if (direction == Sell_Level) {
                  broken3 = iOpen(_Symbol,PERIOD_D1,0) > lvl.Price();
               }            
            }
            
           
            int LastBrokenByBarIndex;
            if ( !broken1 && !broken2 && !broken3 && !IsS3LevelTooFarFromPrice(lvl.Price()) && lvl.TimesBroken(PERIOD_D1,LastBrokenByBarIndex) == 0 ) {
               // extending such level
               lvl.ExtendPoint2();
               if ( iBarShift(_Symbol,PERIOD_D1,lvl.DateTime1()) > pattern_start_bar ) pattern_start_bar = short( iBarShift(_Symbol,PERIOD_D1,lvl.DateTime1()) ); 
               add_to_watchlist = true;
               if (lvl.Color() == clrGreen) buy_level_created = true;
               else sell_level_created = true;
            }
         }
      }
   }
}


bool IsS3LevelTooFarFromPrice(double level_price) {

   if (SimulatorMode) return false; // I could not understand how to get SymbolInfoDouble(_Symbol,SYMBOL_POINT) to work
   // properly, because _Symbol is in the SimulatorMode returns symbol name with a prefix. I would need to edit it out.
   // but I do not consider this condition important for simulation mode, so, it will not be checked

   double bid  = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   
   bool   oil  = _Symbol == "BRN" || _Symbol == "WTI" || _Symbol == "BRENT";
   bool   gold = StringFind(_Symbol,"XAU")!=-1;
   bool   btc  = StringFind(_Symbol,"BTC")!=-1;
   bool   eth  = StringFind(_Symbol,"ETH")!=-1;

   // if this distance is > (0.8 x ATR14) then - do not extend such level
   double dist = MathAbs( (bid - level_price) / SymbolInfoDouble(_Symbol,SYMBOL_POINT) / 10 );
   if (oil || gold) dist = dist / 10;
   else if ( eth ) dist = dist / 10;
   else if ( btc ) dist = dist / 100;
   //Print("dist = " + dist + "; bid = " + bid + "; level_price = " + level_price);
   //Print("level_price = " + level_price + "  |  bid = " + bid + "  |  dist = " + dist + "  |  ATR14 = " + ATR14);
   bool too_far = dist > (0.8*ATR14);
   
   return too_far;

}




void AutoProlongBlueLevels() {

   int obj_total = ObjectsTotalMQL4();
   string obj;
   int LastBrokenByBarIndex;

   for (int i = 0; i < obj_total; i++) {
      obj = ObjectNameMQL4(i);
   
      if ( ObjectTypeMQL4(obj) == OBJ_TREND ) {
         CLevel lvl(obj);
         datetime point2 = lvl.DateTime2(); // memorizing the right datetime of the line
         double dist_btw_control_points = double(lvl.DateTime2() - lvl.DateTime1()) / 60/60;
         if ( dist_btw_control_points < 48 ) continue; // skip short lines (probably not levels which needs extension)
         
         if ( StringFind(lvl.Name,"TP for #") != -1 || StringFind(lvl.Name,"SL for #") != -1) continue;
      
         if ( lvl.IsHorizontal() && lvl.Style() == STYLE_SOLID && lvl.Color() == clrBlue && lvl.TimesBroken(PERIOD_D1,LastBrokenByBarIndex) < 2 ) {
         
            lvl.ExtendPoint2();
            
            // if extended level is now broken more than once - set its Point2 back to the old position.
            if ( lvl.TimesBroken(PERIOD_D1,LastBrokenByBarIndex) > 1 ) lvl.DateTime2(point2);
         
         }
      }
   }
}


void CleanUpS3ChartFromH1Levels() {

   int obj_total = ObjectsTotalMQL4();
   string obj;
   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(_Symbol ,Latest_Price); // Assign current prices to structure 

   for (int i = 0; i < obj_total; i++) {
      // scan through all the chart objects
      obj = ObjectNameMQL4(i);
   
      if ( ObjectTypeMQL4(obj) == OBJ_TREND ) {
         // find trends
         CLevel lvl(obj);
         if ( StringFind(lvl.Name,"TP for #") != -1 || StringFind(lvl.Name,"SL for #") != -1) continue; // skip, if this is a SL or TP mark
         double dist_btw_control_points = double(lvl.DateTime2() - lvl.DateTime1()) / 60/60;
         //Print("dist_btw_control_points = " + dist_btw_control_points + " | Name = " + lvl.Name);
         if ( dist_btw_control_points < 48 ) continue; // skip short lines (probably not levels which needs extension
         if ( lvl.IsHorizontal() && lvl.Style() == STYLE_SOLID && (lvl.Color() == clrRed || lvl.Color() == clrGreen) && lvl.IsVisibleOnTF(PERIOD_D1) ) {
            // trends should be horizonal, solid, red or green and visible on D1
            
            // 1. Check if this red/green level is already broken on D1. If yes - change style and proceed to the next one
            int LastBrokenByBarIndex=0;
            if (lvl.TimesBroken(PERIOD_D1,LastBrokenByBarIndex) > 0) {
               // then - change style and hide from D1
               lvl.Thickness(1);
               lvl.Style(STYLE_DOT);
               ObjectSetMQL4(lvl.Name, OBJPROP_TIMEFRAMES, OBJ_PERIOD_H1 | OBJ_PERIOD_H4);
               continue;
            }
            
            double dist = MathAbs( (Latest_Price.bid - lvl.Price()) / _Point / 10 );
            bool   gold = StringFind(_Symbol,"XAU")!=-1;
            bool   btc  = StringFind(_Symbol,"BTC")!=-1;
            bool   eth  = StringFind(_Symbol,"ETH")!=-1;
            bool   oil  = StringFind(_Symbol,"WTI")!=-1 || StringFind(_Symbol,"BRN")!=-1 || StringFind(_Symbol,"BRENT")!=-1;
            if (gold) dist = dist / 10;
            else if (btc) dist = dist / 100;
            else if (eth) dist = dist / 10;
            else if (oil) dist = dist / 10;
           
            if (!S_Version) {
               if ( (TimeLocal() - lvl.DateTime2()) >= HR2400*10 || dist > (1.5*ATR14) ) { // approx 10 days; or price has moved away from that level enough
                  // 2. Check, if prolongation of this level to the right will show any breaks 
                  // if breaks are not more than 1 - turn this level into blue D1-level
                  // if there will be more than 1 breaks - change style and hide from D1
                  datetime point2 = lvl.DateTime2(); // memorizing points just in case we will need to rollback the extension
                  lvl.Color(clrBlue);
                  lvl.ExtendPoint2();
                  if (lvl.TimesBroken(PERIOD_D1,LastBrokenByBarIndex) > 1) {
                     // level is broken more than one - change style
                     lvl.DateTime2(point2); // rolling back the extension
                     lvl.Thickness(1);
                     lvl.Style(STYLE_DOT);
                     ObjectSetMQL4(lvl.Name, OBJPROP_TIMEFRAMES, OBJ_PERIOD_H1 | OBJ_PERIOD_H4);
                  }
                  else {
                     // turning this level to blue D1-level and extending the right point more to the right
                     lvl.Color(clrBlue);
                     lvl.Thickness(1);
                     lvl.ExtendPoint2(); // applying extension again, because extension works differently on blue levels.
                  }  
               }
            } // if (!S_Version) {
            else
               Print("Not converting old S3-level to D1 blue levels for S-Version");
         }
      }
   }
}






long LastChartIDinWatchList() {
   for (int i = 0; i < ArraySize(OpenChartIDs); i++) {
      if ( OpenChartIDs[i] == 0) {
         if (i == 0) return 0;
         else return OpenChartIDs[i-1];
      }
   }
   return 0;
}



bool ProtectionCheck() {

   if (LightVersion) return true;

   long account_number = AccountInfoInteger(ACCOUNT_LOGIN);
   //Print("account_number = " + account_number);
   
   // check if this is a demo version
   if (DemoVersion) {
      if (TimeCurrent() < DemoVersionUntil) return true;
      else {
         MessageOnChart("Demo expired. Contact sales@metatools.online", MessageOnChartAppearTime);
         return false;
      }
   }
   else if (SubscriptionVersion) {
      int fourteen_days = 1209600; // 14 days = 60 sec * 60 min * 24 hrs * 14 days
      int diff = int(SubscriptionUntil - TimeCurrent());
      if ( diff < fourteen_days && diff > 0 )
         MessageOnChart("Extend your subscription: sales@metatools.online", MessageOnChartAppearTime);
      if (TimeCurrent() < SubscriptionUntil) return true;
      else {
         MessageOnChart("Subscription expired. Contact sales@metatools.online", MessageOnChartAppearTime);
         return false;
      }
   }
   
   
   int permitted_accounts[10] = { 
      //60769621, 60051447, 27000909 // Anton Russman
      //,250242888, 250214479 // Demo Accounts for Сергей Коломийцев
       143037926 // 1) My main account for BF + S3 + S4
      ,500109495 // 2) Robo-Forex Demo for development and testing
      ,51006822  // 3) Alpari demo for development MT5
      ,51049550  // 4)  Alpari Demo Account MT5
      ,5866978   // 5) Alpari Real account; (zero depo; not used)
      ,5862997   // 6) BF Real Account ECN Pro | Alpari
      ,5862996   // 7) D1 Real Account ECN Pro | Alpari
      ,5858293   // 8) S3/S4 Real Account ECN Pro | Alpari
      ,29912728  // 9) S3/S4 Demo Account ECN Pro | Alpari
      ,250196559 // 10) S3/S4 Demo Account ECN Pro | Alpari
      }; // 
   
   for (int i = 0; i < ArraySize(permitted_accounts); i++) {
   
      if ( permitted_accounts[i] == account_number) return true;
   
   }
   MessageOnChart("Unauthorized Account Number. Contact sales@metatools.online", MessageOnChartAppearTime);
   return false;

}


bool IsObjectArrow(string obj_name) {

   int ArrowCode = (ENUM_OBJECT_PROPERTY_INTEGER)ObjectGetMQL4(obj_name,OBJPROP_ARROWCODE);
   if (ArrowCode == SYMBOL_ARROWUP || ArrowCode == SYMBOL_ARROWDOWN) 
      return true;
   else return false;

}



void SetExtremumToTakeOut(long Chart_ID, int x, int y) {

   if (_Period != PERIOD_H1) return; // operation is possible on H1 TF only

   datetime TimeClicked;
   double   PriceClicked;
   int      sub_w = 0;
   string   symbol = ChartSymbol(Chart_ID);
   int      period = ChartPeriod(Chart_ID);
   
   ChartXYToTimePrice(Chart_ID,x,y,sub_w,TimeClicked,PriceClicked);
   
   int BarClicked = iBarShift(symbol,period,TimeClicked);
   
   double bar_low    = iLow( symbol, period, BarClicked);
   double bar_high   = iHigh(symbol, period, BarClicked);
   double bar_height = bar_high - bar_low;

   
   if ( PriceClicked < bar_low || PriceClicked > bar_high ) return; // if clicked outside of the bar - skipping this situation 
   
   if ( PriceClicked > (bar_low + bar_height/4) && PriceClicked < (bar_high - bar_height/4) ) return; // if clicked in the middle of the bar - skip
   
   
   bool high_clicked = false;
   
   if (PriceClicked > (bar_high - bar_height/4)) high_clicked = true;
   
   
   double trend_price;
   string trend_name;
   TradeDirectionType trade_dir;
   
   if (high_clicked) {
      Print("high_clicked");
      trend_price = bar_high;
      trend_name = "HighToTakeOut";
      trade_dir = Sell_Level;
   }
   else {
      Print("low_clicked");
      trend_price = bar_low;
      trend_name = "LowToTakeOut";
      trade_dir = Buy_Level;
   }
   
   
   
   if (ObjectFind(Chart_ID,trend_name) != -1) {
      bool same_bar = false;
      if (ObjectGetInteger(Chart_ID,trend_name,OBJPROP_TIME1) == TimeClicked) same_bar = true;
      ObjectDeleteSilent(Chart_ID,trend_name);
      ToggleExtremumTakeOutLabelForLevels(trade_dir, true);
      if (same_bar) return; 
   }
   
   datetime DateTime2 = StringToTime(string(Today() + HR2400)+"00:00");
   
   ResetLastError();
   if(!ObjectCreate(Chart_ID,trend_name,OBJ_TREND,0,TimeClicked,trend_price,DateTime2,trend_price)) {
      Print(__FUNCTION__, ": failed to create a trend! Error code = ",GetLastError());
   }
   else {
      ObjectSetInteger(0,trend_name,OBJPROP_SELECTABLE,false);
      ObjectSetInteger(0,trend_name,OBJPROP_RAY_RIGHT,false);
      ObjectSetInteger(0,trend_name,OBJPROP_COLOR,clrDarkGray);
      ObjectSetMQL4(trend_name, OBJPROP_TIMEFRAMES, TimeFrameToObjPropTimeFrame(period));
   }
   
   ToggleExtremumTakeOutLabelForLevels(trade_dir, false);
   
   // create a symbol label for all the active levels of the same direction
   

}


void ToggleExtremumTakeOutLabelForLevels(TradeDirectionType trade_dir, bool remove) {
   // set or remove "ExtremumTakeOutLabel" (arrow symbol showing blue circle)

   for (int i = 0; i < ArraySize(Levels); i++) {
      if (Levels[i].TradeDirection == trade_dir) {
         string label_name = Levels[i].ExtToTakeOutLabelName();
         
         if (remove) 
            ObjectDeleteSilent(label_name);
         else {
            string tooltip;
            color  label_clr;
            if (trade_dir == Sell_Level) {
               tooltip = "No signal until indicated high is taken out";
               label_clr = clrRed;
            }
            else {
               tooltip = "No signal until indicated low is taken out";
               label_clr = clrGreen;
            }
            datetime arrow_time = StringToTime(string(Today() + HR2400 + HR1*4));
            ResetLastError();
            if(!ObjectCreate(0,label_name,OBJ_TEXT,0,arrow_time,Levels[i].Price1())) {
               Print(__FUNCTION__, ": failed to create arrow! Error code = ",GetLastError());
            }
            else {
               ObjectSetInteger(0,label_name,OBJPROP_SELECTABLE,true);
               ObjectSetMQL4(label_name, OBJPROP_TIMEFRAMES, PERIOD_H1);
               ObjectSetInteger(0,label_name,OBJPROP_ANCHOR,ANCHOR_LEFT);
               ObjectSetTextMQL4(label_name,CharToString(159),9,"Wingdings",label_clr);
               ObjectSetString(0,label_name,OBJPROP_TOOLTIP,tooltip);
            }
         }   
      } 
   }
}



