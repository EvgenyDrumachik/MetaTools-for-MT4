#property indicator_chart_window
#property indicator_plots 0
#property strict

#include "Meta Tools Declarations.mqh"


int OnInit() {

   //Print(__FUNCTION__ + ": INITIALIZING!...");

   SymbolInfoTick(_Symbol,last_tick);
   
   if((ENUM_PROGRAM_TYPE)MQLInfoInteger(MQL_PROGRAM_TYPE)==PROGRAM_INDICATOR)
      IndicatorSetString(INDICATOR_SHORTNAME, indicator_short_name);
   
   
   //bool chart_change = (bool)GlobalVariableGet("MetaTools-" + IntegerToString(ChartID()) + "-ChartChange");
   //if ( chart_change )
   //   Print(__FUNCTION__ + ": re-initializing after chart change. Short init..."); 
   //else 
   //   Print(__FUNCTION__ + ": full re-initialization");


   //if(!chart_change || ObjectsTotalMQL4() < 50) {
      // if this is not just changing TF; and if number of objects is not low (it could have been that user has deleted ALL objects from chart)
               ChartSetInteger(ChartID(),CHART_EVENT_OBJECT_CREATE,0,false); // not to process newly created UI elements in the event handler
               //--- Initialize the generator of random numbers
               MathSrand(GetTickCount());
            
               Update_X_Delta();
            
               TimeCurrent(CurrentTime);
               PreviousHour = CurrentTime.hour; // to detect hour change
               ThisChartIsActive = ThisChartActive();
               int indicators_total = ChartIndicatorsTotal(0, 0);
            	for (int i = 0; i < indicators_total; i++)
            	{
                  if (ChartIndicatorName(0, 0, i) == "BF Tools" + IntegerToString(ChartID()))
            		{
            			Print("Meta Tools is already attached.");
            			return(INIT_FAILED);
            		}
            	}
            
               // Terminal Variables - > Global Variables in the program
               if (IsChartInWL(ChartID())) InWatchList = true; else InWatchList = false;
               
               if (GlobalVariableGet("AutoBFTools") == 1)  AutoBFTools = true;
               else AutoBFTools = false;
               //
            
              RefreshStrategy();
              
              
              if (InWatchList) {
                  //Initialize Priority of the day (buy or sell)
                  UpdateLevelsArray();
                  UpdateDayPriority();
              }
              
            
              // Init Timer ====================
               if (!SimulatorMode) EventSetTimer(1); // necessary for Timer refresh each second; makes "Save Template" msg disappear too quickly; task: find a way to set a separate timer for Save Template Button
            
              //================================
              
            
               // ============ Initializing all the buttons =================
               //InitButtonColors();
               InitVisibilityButtons();
               InitUIControlButtons();
               InitColorControlButtons();
               InitLineControlButtons();
               InitOtherButtons();
               
               if (!S_Version) InitWatchListButtons();
               InitWatchListPairButtons();
               InitPrevNextButtons();
               InitArrayOfWatchPairButtons();
               InitCandleTimer();
               
               InitAutoBFTools_Button();
               InitFixChartScale_Button();
               UpdateSoundPushButtons();
               SignalProbability = ProbabilityInWatchList(ChartID());
               
               ResetAllWatchButtons();
            
            
               HoursDelay = int(MathRound(GlobalVariableGet("WL-" + _Symbol + "-" + IntegerToString(ChartID()))));
                  
               InitializeWatchButtons();
               UpdateChartArrays(); // reading all open charts and their ID's into global Arrays OpenChartSymbols[100]; and OpenChartIDs[100];
                  
               // Sending custom event to all open charts, so they can learn about this new chart being open and update their watch pair buttons
               //SendBroadCastMsg(); // commented out in attempt to improve performance. Let's see if removal will cause any bugs.
               UpdateWatchPairButtons();
            
               
               ShowAllWatchPairButtons();
               
               if (ShowMetaKeypad) InitMetaKeyPad();
               
               i_SelectedObjectsCount = SelectedObjectsCount();
               UnselectAll_Button.Text(IntegerToString(i_SelectedObjectsCount));
               FloatingLabel.Text(IntegerToString(i_SelectedObjectsCount));
               
               InitATRLabels();
               UpdateATRLabels();
               
               // Hide / Show All UI
               if (!GlobalVariableCheck("BFToolsShowAll"))  { GlobalVariableSet("BFToolsShowAll",1); }
               else {
                  if(GlobalVariableGet("BFToolsShowAll") == 0) {
                     HideButtons();
                     ObjectsHidden = true;
                  }
               }
               
               // Hide / Show Main Buttons
               if (!GlobalVariableCheck("BFToolsShowMainButtons"))  { GlobalVariableSet("BFToolsShowMainButtons",1); }
               else {
                  if(GlobalVariableGet("BFToolsShowMainButtons") == 0) HideMainButtons();
               }   
               
               // =============
               
               
               // *** Trades Manager Initialization ***
               if (!LightVersion) {
                  TradeManager.InitControls();
                  TradeManager.TradesArray.Update();                    // update global array of open orders
                  TradeManager.UpdateTradeLinesVisibleValue();
                  TradeManager.UpdatePosVizOfTradeManager();
                  TradeManager.UpdateTextOnTradeManagerUI();
                  TradeManager.UpdateTradeManagerStatusLED();
                  TradeManager.AutoEntryControl.RecoverRectangles();    // show instant and limit rectangles, if they AutoEntryOnBarClose is switched ON
                  TradeManager.TM_StatusLED_Label.Show(); 
                  // *****************************  
               }
               
               
               
               // *** Setting up FIX'ed scale, if it was applied - just in case this chart is switched to a different timeframe from the MT4 TF buttons
               if (AutoBFTools && !S_Version) Apply_FIX_Mode_and_Scale();
               //
               
               CLevel::DrawUpdateRoundLevelsD1();
               
               crosshair.Hide();
              
               total_orders = OrdersTotal(); // to trigger OnTrade() event
               
               // these commands should be down here to prevent reaction to creation and deletion of all the elements that are being initialized above
               if (!SimulatorMode) ChartSetInteger(ChartID(),CHART_EVENT_OBJECT_DELETE,true);   // necessary to detect OnDelete event; used to detect deletion of trend to delete its triangle
               if (!SimulatorMode) ChartSetInteger(ChartID(),CHART_EVENT_OBJECT_CREATE,0,true); // to be able to detect newly created objects
               //ChartSetInteger(ChartID(),CHART_EVENT_MOUSE_MOVE,0,true);    // to detect mouse move on chart
              
               // showing hour delay buttons, if in Watch List
               if (InWatchList && !ObjectsHidden && !S_Version) ShowHoursDelayButtons(true);
               else ShowHoursDelayButtons(false);
   //}
   //else {
   //   if (ArraySize(ArrayOfWatchPairButtons) == 0) {
   //      InitArrayOfWatchPairButtons();
   //   }
   //}


   ChartRedraw();
   
   return(INIT_SUCCEEDED);
} // OnInit
  
  
  
  
void OnDeinit(const int reason) {

   //Print(__FUNCTION__ + ": due to reason: " + (string)reason);
   
   
   if (ObjectsHidden) {
      HideShowAllObjectsToggle();
   }
   
   
	// Set temporary global variable, so that the indicator knows it is reinitializing because of 
	// timeframe/parameters change and should not prevent attachment.
	//if ( reason == REASON_CHARTCHANGE ) {
	//   GlobalVariableSet("MetaTools-" + IntegerToString(ChartID()) + "-ChartChange", 1);
	//   //ChartRedraw();
	//   //return;
	//}
 //  else
 //     GlobalVariableSet("MetaTools-" + IntegerToString(ChartID()) + "-ChartChange", 0);
   
   // ========================== FULL DEINIT =============================================
   ChartSetInteger(ChartID(),CHART_EVENT_OBJECT_DELETE,false); // disable detection of objects deletion to prevent processing of deletation of UI elements with CHARTEVENT_OBJECT_DELETE event
   
   // If we tried to add a second indicator, do not delete objects.
   if (reason == REASON_INITFAILED) {
      Print(__FUNCTION__ + ": init failed");
      ChartRedraw();
      return;
   }

   ObjectDelete(0,"CandleClosingTimeRemaining");
   Comment("");
   EventKillTimer();
   //============
   DestroyAllButtons();
   if (Strategy == D1)    {
      CLevel lvl();
      lvl.DeleteD1RoundLevels();
   }
   //SendBroadCastMsg(); I suspect this may have slowed MT4 down when changing broker or account
   Comment("");

   ChartRedraw();
}
  



//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer() {

   if (SimulatorMode) return;

   //Print(__FUNCTION__);

   DelayedInit();
   
   if (!OperationAllowed) {
      Print(__FUNCTION__ + ": Operation is not allowed");
      return; // protection
   }

  if (InWatchList) {
   AutoSaveTemplateEvery4Hours();
   TimeCurrent(CurrentTime); // update current time structure
  }
  
  // *** Recording of Spread History ***
  datetime blank_value = D'01.01.1970';
  if (TimeDayOfWeekMQL4(TimeLocal()) != 6 && TimeDayOfWeekMQL4(TimeLocal()) != 0) { // excluding weekend
     if (sets.LastRecordedSpreadTime == blank_value || TimeCurrent() > sets.LastRecordedSpreadTime + 600) {
         if (HourMQL4() > 0 && HourMQL4() < 23 && MinuteMQL4() > 5 && MinuteMQL4() < 55 && MinuteMQL4() != 15 && MinuteMQL4() != 30 && MinuteMQL4() != 45){
            //Print("Recording spread history");
            SpreadHistory.SaveCurrentSpeadToDisk();
            sets.LastRecordedSpreadTime = TimeCurrent();
            sets.SaveSettingsOnDisk();
         }
     }
  }
  // **********************************
  
  
 
  SecondsSinceLastSoundAlarm++; // increasing timer for sounds
  
  if (ThisChartIsActive) { // if chart is active
      // each 1 second
      UpdateChartArrays();
      UpdateWatchPairButtons();
      UpdateRightLowerInfo();
      
      UpdatePosVisOfCandleTimer();
      
      if (!LightVersion) {
         TradeManager.UpdateAutoDeleteLimitOnTimerControls();
         TradeManager.UpdateSpreadThicknessOf_SL_and_TP();
         TradeManager.UpdateSpreadThicknessOfEntryLine();
      }

      if (MathAbs(MessageOnChartAppearTime - TimeLocal()) > 10) { // is more than 5 seconds passed since the chart message was shown on the chart - remove it
         ObjectDeleteSilent(0,"MessageOnChartLabel"); 
      }
      
      
      // *** Timer10_2 ***
      if (Timer10_2 == 10) {
         // nothing here yet; every 10 seconds on active chart
         Timer10_2 = 0;  
      }
      else Timer10_2++;
      // ***************
      
      
      if (Timer2 == 5) { 
         // every 5 seconds
         
         // refreshing strategy, if account number has changed
         if (AN != AccountInfoInteger(ACCOUNT_LOGIN)) { RefreshStrategy(); RefreshComment(); }
                          
         
         Timer2 = 0;
         HButtonPressedCount = 0;
         
      }
      else Timer2++;
      
      
      if (Timer60 == 60) { // every 60 seconds
         UpdateATRLabels();
         Timer60 = 0;
         SpreadHistory.LoadSpreadHistoryFromDisk();
         AvgSpread = SpreadHistory.AvgSpread();
         
         
         // checking if there is a trade on this symbol while BB or BE levels are not yet set by user
         // if so - play sound alert to user
         if (sets.BreakEvenLevel() <= 0 || sets.BackwardsBreakLevel() <= 0) {
            if (OrdersTotal() > 0) {
               if ( TradeManager.TradesArray.TradesOpenOnSymbol(_Symbol,false) > 0) {
                  MessageOnChart("BE or BB level is NOT set!", MessageOnChartAppearTime);
                  PlaySound("Alert.wav");
               }
            }
         }
      }
      else Timer60++;
      
      
      // every 2 seconds
      if (AnotherSecondDelay) {  // resetting current Watch List Pair button back to green every other second
         AnotherSecondDelay = false;
         
         ClearTradingMarksButtonPressedCount = 0; // resetting counter for times "L" is pressed for clearing chart from trading marks
         LoadLastTemplateButtonPressedCount = 0;  // resetting counter for times "K" is pressed for loading last template for current symbol
         AutoCreateH1Levels_for_S3_Strategy_ButtonPressedCount = 0; // resetting counter for times "B" is pressed
         AutoFindD1Breaks_ButtonPressedCount = 0; // resetting counter for times "U" is pressed
         ClearWLButtonPressedCount = 0;           // resetting counter for "C" (main UI) button clicking
         CopyRiskToAllCharts_ButtonPressedCount = 0; // resetting counter for times ";" is pressed for copying risk from PSC of current chart to all other charts
         
         // Updating AutoBFTools button
         //Print("Updating AutoBFTools button");
         if (GlobalVariableGet("AutoBFTools") == 1)  AutoBFTools = true;
         else AutoBFTools = false;
         UpdateAutoBFToolsButton();
         UpdateSoundPushButtons();
         // =============================
         
         RefreshComment();
         
         // *** TRADE MANAGER ************************************** (every 2 seconds)
         // checking how much time passed since we last time seen Trade.exe live
         // **** ПЕРЕНЕСТИ ЭТИ ПРОВЕРКИ В КЛАСС TRADE MANAGER!
         if (!LightVersion) {
                  if (MathAbs(TradeEXE_LastSignalReceived_Datetime - TimeLocal()) > 5) {
                     TradeManager.TradeEXE_Alive(false);
                     TradeAllowed = false;
                  }
               // Trade.exe
               
               // Break Even button
               TradeManager.UpdateTradeLinesVisibleValue(); // check if Trade Lines are still visible and update TradeLinesVisible bool value accordingly
               TradeManager.UpdatePosVizOfTradeManager();
               TradeManager.UpdateTradeManagerStatusLED();
               if (TradeManager.TradesArray.TradesOpenOnChart(ChartID()) == 0)  {
                  ObjectDeleteSilent(0,BreakEvenLineName);
                  ObjectDeleteSilent(0,BackwardsBreakLineName);
                  TradeManager.TM_Set_BE_BB_Level_Button.Hide();
                  TradeManager.TM_BE_ML_Button.Hide();
               }
               else { // some trades are open on chart - make sure that BreakEvenLine and BackwardsBreakLine exist
                  if (Strategy != FourStrings) {
                     CTradeLine be_line(BreakEvenLineName);
                     CTradeLine bb_line(BackwardsBreakLineName);
                     ulong ticket = TradeManager.TradesArray.LastOrderOnSymbol_Ticket(_Symbol);
                     
                           // if any of the lines does not exist - start setting BB / BE from the beginning; or if exist - show them in correct position
                           if (!be_line.IsExist()) {
                              if (sets.BreakEvenLevel() != 0) {
                                 be_line.CreateBreakEvenLine(ticket);
                                 be_line.Price1(sets.BreakEvenLevel()); // move break even line to previously saved BE price
                                 CMetaTrade trade(ticket);
                                 int BE_Percent = int(sets.BreakEvenPP()/trade.TP_PP()*100);
                                 be_line.BreakEvenLineSet(sets.BreakEvenPP(),BE_Percent);
                                 TradeManager.TM_Set_BE_BB_Level_Button.Hide();
                              }
                              else {// BE is still 0 (not set) - we should not allow the BE line to be disselected
                                 TradeManager.ToggleBreakEvenControls(true,ticket);
                              }
                           }
                           
                           
                           if (be_line.IsExist() && !bb_line.IsExist()) {
                              if (sets.BackwardsBreakLevel() != 0) {
                                 // move backwards break line to previously saved BB price
                                 Print("Re-creating BB line... for ticket ", ticket);
                                 bb_line.CreateBackwardsBreakLine(ticket);
                                 bb_line.Price1(sets.BackwardsBreakLevel()); 
                                 bb_line.BackwardsBreakLineSet();
                                 TradeManager.TM_Set_BE_BB_Level_Button.Hide();
                              }
                              else {// BB is still 0 (not set) - we should not allow the BB line to be disselected
                                TradeManager.ToggleBackwardsBreakControls(true,ticket);
                              }
                           }
                  }
               }
         }
         // Break Even button
         
         // Just send a ping message to check if Trade.exe is alive
         if (!LightVersion) {
            if (!GenerateEvent(TRADE_EXE_PING)) 
               Print("Couldn't send 'TRADE_EXE_PING'");
         }
         // ********************************************************
         /// ************************
         
         if (DebugMode && ThisChartIsActive) RefreshComment();
         
      }
      else { AnotherSecondDelay = true; }


      ChartRedraw();
   
  } // ThisChartIsActive
  

  
   // Every 10 seconds, dóesn't matter - this is active chart or not
   if (Timer10 == 10) {
      if (InWatchList) {
         if (!LightVersion)
            TradeManager.TradesArray.Update(); // to make sure that following functions will work with updated list of orders
         if (!S_Version) {
            int i_today = TimeDayOfWeekMQL4(TimeLocal());
            if (i_today != 6 && i_today != 0) { // Check if Saturday or Sunday
               if (CurrentTime.min >= StartAlertsEveryHourAtMin) { 
                     // if HoursDelay = 1 - remind about it with push
                     if (!sets.InformedAbCheckTheChart && IsPushControlON() && IsInformer()) { 
                        //Print("informing...");
                     
                        // 1) inform (push) about charts with HoursDelay = 1 - Check The Chart; for all the charts in the watch list
                        InformAboutHoursDelay1ForAllCharts();
                        
                        // 2) Inform (push) about open traders, if any; for all the symbols with open trades
                        TradeManager.InformAboutOpenTradesForAllCharts();
                     
                        // InformedAboutCheckTheChartSet(true);
                        sets.InformedAbCheckTheChart = true; // informed. Not to repeat until the flag will be reset.
                        sets.SaveSettingsOnDisk();
                     }
               }
            }
         }
         // following is executed for all versions; every 10 seconds
         if (!LightVersion)
            TradeManager.Delete_Limit_Order_On_Timer();
      
      }
      Timer10 = 0;
   }
   else Timer10++;

}





//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
  


  if ( !OperationAllowed ) return;
  
  if (id == CHART_SWITCHED + 1000) {
      Print("got CHART_SWITCHED event!");
      if (Period() == PERIOD_H1) {
         //Update_X_Delta();
         //UpdateLevelsArray();
         UpdateChartArrays();
         UpdateWatchPairButtons();
         UpdateATRLabels();
         UpdateRightLowerInfo();
         UpdatePosVisOfCandleTimer();
         //Print("Period H1!");
      }
  }
  
   // ************* Double Click Detection ************
   int x = (int)lparam;
   int y = (int)dparam;

   int window  = 0;
   datetime dt = 0;
   double   p  = 0;
   
   
   if (id == CHARTEVENT_CLICK) {
      //TradeManager.UpdateATRRange(x,y);
      
      //if ( (isDobleClick(id) && sparam == ""))
      //   SetExtremumToTakeOut(ChartID(),x,y);
      
      Mouse_X = (int)lparam;
      Mouse_Y = (int)dparam;
      
      crosshair.Move(x,y);
      return;
   }
   
   
   
      
   if (ChartXYToTimePrice(0, x, y, window, dt, p))
   {
      if (id == CHARTEVENT_OBJECT_CLICK)
      {
         if (GetMicrosecondCount() - click < dclick)
         {
            onDoubleClick(id, lparam, dparam, sparam);
            click = 0;
         } else {
            onClick(id, lparam, dparam, sparam);
            click = GetMicrosecondCount();
         }
      }
   }
   // **************************************************
  
 
  
  
   if (id == NEWS_UPDATED + 1000) {
         MessageOnChart("News updated!", MessageOnChartAppearTime);
         //downloader =  new CFFNewsDownloader();
         NewsCalendar.LoadNewsFromFile();
         NewsCalendar.DrawNewsOnChart(ChartID(),News_Impact);
      // now array of structures of news are in downloader.Events[]
         return;
   }
  
   if (id == SETTINGS_CHANGED_BY_TRADE_EXE + 1000) {
      Print("SETTINGS_CHANGED_BY_TRADE_EXE is received");
      sets.LoadSettingsFromDisk();
   }
  
  
   if (id==CHARTEVENT_MOUSE_MOVE && !SimulatorMode) {
   
      Mouse_X = (int)lparam;
      Mouse_Y = (int)dparam;
      
      if (IsKeyShift() && i_SelectedObjectsCount == 0)
         TradeManager.UpdateATRRange(x,y);
      
      //long value;
      //ChartGetInteger(0,CHART_EVENT_MOUSE_MOVE,0,value);
      //Print("Mode: " + value + "; Mouse_X = ", Mouse_X, "; Mouse_Y = ", Mouse_Y);
   
      if (!LightVersion) {
         if (TradeManager.TradeLinesVisible && i_SelectedObjectsCount > 1) {
            TradeManager.UpdateTradeLinesVisibleValue();
            TradeManager.UpdatePosOfTradeManager();
            TradeManager.UpdateTextOnTradeManagerUI();  
         }
      }
   
      if (!S_Version) {
         if (i_SelectedObjectsCount > 1) {
            FloatingLabel.Move(Mouse_X+20,Mouse_Y+20); // indication of quantity of selected objects
            FloatingLabel.Show();
         }
         else FloatingLabel.Hide();
      }
      ChartRedraw();
      return;
   }
   
   
   // If double-click is detected - do nothing and exit OnChartEvent()
   //if (isDobleClick(id)) return;
   //////////////////////////
   
   //ThisChartIsActive = ThisChartActive();
   
   ThisChartIsActive = true;
   
   //Print(__FUNCTION__ + ": ThisChartIsActive = " + ThisChartIsActive);
   
   // ============================ Broadcasted events processing ============================
      if (id == broadcastEventID) {
         if (sparam == "AutoBFToolsSwitchedON") {
            Print("Event 'AutoBFToolsSwitchedON' is received!");
            AutoBFTools = true;
            UpdateAutoBFToolsButton();
            ExtendAllFibos(); // first, we extend all fibo's where necessary;
            UpdateFiboLevelsForAll(); // then, we delete broken fibo levels, where necessary
            ChartRedraw();
            return;
         }
         if (sparam == "ShowAllUI") {
            ObjectsHidden = false;
            ShowButtons();
            ChartRedraw();
            return;
         }
         
         if (sparam == "HideAllUI") {
            ObjectsHidden = true;
            HideButtons();
            ChartRedraw();
            return;
         }
         
         if (sparam == "ShowMainButtons") {
            ShowMainButtons();
            ChartRedraw();
            return;
         }       
         if (sparam == "HideMainButtons") {
            HideMainButtons();
            ChartRedraw();
            return;
         }  

         if (sparam == "ClearWL") {
            // updating whether this specific chart is still in the watch list
            if (IsChartInWL(ChartID())) InWatchList = true; else RemoveChartFromWatchlist();
            ChartRedraw();
         }
         if (sparam == "FIND_H1_LEVELS" && !LightVersion) {
            Print("FIND_H1_LEVELS command is received");
            Watchlist_S3_Autobuild();
            SwitchTo_D1();
            ChartRedraw();
         }
         if (sparam == "FIND_D1_BREAKS" && !LightVersion) {
            Print("FIND_D1_BREAKS command is received");
            Watchlist_S4_Autobuild();
            SwitchTo_D1();
            ChartRedraw();
         }
         if (sparam == "CLEAR_WATCHLIST") {
            RemoveChartFromWatchlist();
            SwitchTo_D1();
            if (!LightVersion) TradeManager.HidePSC();
            ChartRedraw();
         }
         if (sparam == "HIDE_PSC" && !LightVersion) {
            TradeManager.HidePSC();
            ChartRedraw();
         }
      }
   // ====================================================================================
   
   
   
   if (!LightVersion)
      TradeManager.ProcessBroadcastEvents(id,lparam);
   

  
   
   
   
   
   
   if (id==CHARTEVENT_OBJECT_CREATE) {
   
      if (StringFind(sparam,"m_") != -1) return; // do not process creation of UI elements of Posision Sizer
      if (StringFind(sparam,"PS_") != -1) return;
      if (ObjectType(sparam) > 23) return; // UI elements of a panel
      
      Print("Object created: " + sparam + "; Object Type: " + IntegerToString(ObjectType(sparam)));
      
      
      
      CGraphObject obj(sparam);
      ENUM_OBJECT type = obj.Type();
      obj.SetDefaultVisibility();
      
 
      if ( InWatchList && IsObjectArrow(sparam) ) {
         UpdateDayPriority();
         RefreshComment();
      }

      
     
     // =============================  Auto BF Tools (on CHARTEVENT_OBJECT_CREATE)  ==============================
     string objectName = sparam;
     // getting price coordinates of the created object
     double Price1 = ObjectGetMQL4(objectName,OBJPROP_PRICE1);
     double Price2 = ObjectGetMQL4(objectName,OBJPROP_PRICE2);
     
     if (AutoBFTools) {
         // ==== Applying default color and line type ====
         if(ObjectTypeMQL4(objectName)==OBJ_FIBO && Strategy != FourStrings) {
            Print("Fibo " + sparam + " created");
            CFibo created_fibo(objectName);
            created_fibo.ExtendFibo();
            created_fibo.UpdateLevels();
            created_fibo.AutoColor();
         }
         else if((ObjectTypeMQL4(objectName)==OBJ_TREND || ObjectTypeMQL4(objectName)==OBJ_CHANNEL)) {
             // setting control points of the trend on the M1 extremums
            CTrend trend(sparam);
            trend.SetPointsOnH1Extremums();

            //
            if (Price1 != Price2) { // do not copy properties, if this is a horizontal line
               string ParallelTrend = ParallelTrendName(sparam);
               if (StringLen(ParallelTrend) > 0) CopyObjectProperties(ParallelTrend,sparam);
            }
         
            string ParallelTrend = ParallelTrendName(objectName);
            bool ThisIsCopy = false;
            if (StringLen(ParallelTrend) > 0) ThisIsCopy = true;
         
            if (!ThisIsCopy && (StringFind(objectName,"#") == -1)  ) { // this is not a copy and this is not aline showing historical trades
               //Print("This is not a copy");
               double dist = double(trend.DateTime2() - trend.DateTime1()) / 60/60;
               //Print("dist = " + dist);
               if (dist > 40) {
                  if (Price1>Price2) { //down-trend
                     trend.Color(DefaultDownTrendColor);
                  }
                  else {// up-trend   
                     trend.Color(DefaultUpTrendColor);
                  }
               }
               else
                  trend.Color(clrDarkGray);
               
               if (dist > 2160) { 
                  //Print("increasing width for " + sparam);
                  ObjectSetMQL4(sparam,OBJPROP_STYLE,STYLE_SOLID);
                  ObjectSetMQL4(sparam,OBJPROP_WIDTH,2); // IT DOESN'T WORK - CANNOT UNDERSTAND WHY?!
               }
               
               if (SelectedLineColor != DefaultUpTrendColor) ObjectSetMQL4(objectName,OBJPROP_COLOR,SelectedLineColor);
               
               ObjectSetMQL4(objectName,OBJPROP_WIDTH,SelectedLineWidth);  
               ObjectSetMQL4(objectName,OBJPROP_STYLE,SelectedLineStyle);
            }
         }
         else if (ObjectTypeMQL4(objectName)==OBJ_RECTANGLE) {
            CRectangle rect(objectName);
            rect.AutoColor(S_Version, Levels);
         }
         else if ( IsObjectArrow(sparam) ) {
            #ifdef __MQL5__
               int arrow_code = (ENUM_OBJECT_PROPERTY_INTEGER)ObjectGetMQL4(sparam,OBJPROP_ARROWCODE);
            #else
               int arrow_code = (int)ObjectGetMQL4(sparam,OBJPROP_ARROWCODE);
            #endif 
            
            if (arrow_code == SYMBOL_ARROWUP || arrow_code == SYMBOL_THUMBSUP)
               ObjectSetMQL4((objectName),OBJPROP_COLOR,clrGreen);    
            else if (arrow_code == SYMBOL_ARROWDOWN || arrow_code == SYMBOL_THUMBSDOWN)
               ObjectSetMQL4((objectName),OBJPROP_COLOR,clrRed);   
            else if (arrow_code == SYMBOL_STOPSIGN)
               ObjectSetMQL4((objectName),OBJPROP_COLOR,clrBlack); 
            ObjectSetMQL4( objectName,OBJPROP_TIMEFRAMES,TimeFrameToObjPropTimeFrame(_Period) ); // all arrows types to be visible only on the TF where is it drawn            
         }
     }
     //-------------------------------------------------------------------------------------
     
     obj.UpdateToolTip();
     
     ChartRedraw();
     return;
   } // CHARTEVENT_OBJECT_CREATE
   

   //if (SimulatorMode) return; 

   
   if (id==CHARTEVENT_OBJECT_CHANGE && ThisChartIsActive && !SimulatorMode) {
      CGraphObject obj(sparam);
      obj.UpdateToolTip();
      return;
   }

  
  
  if (id==CHARTEVENT_CHART_CHANGE && ThisChartIsActive && !SimulatorMode) { 
  
      // prevent processing of too frequent CHART_CHANGE events
      if ( TimeLocal() - LastChartChange < 1 ) return;
  
      //Print("chart change!");
      // when switching from one chart to another, e.g. using <<< or >>> buttons - ( WORKS IN FULL SCREEN MODE ONLY! )
      // also when changing from one TF to another
      ChartCheckNeededSet(Not_Needed,_Symbol,ChartID());
      Update_X_Delta();
      UpdateWatchPairButtons(true);  
      UpdatePositionOfAllButtons(id, X_Delta);
      //UpdateATRLabels(); 
      //Print("Chart change and active");
      
      // Update Trade Manager controls
      TradeManager.UpdateATRRange(); // should work for Light version too
      if (!LightVersion) {
         TradeManager.UpdateTradeLinesVisibleValue();
         if (TradeManager.TradeLinesVisible) {
            TradeManager.UpdatePosOfTradeManager();
            TradeManager.UpdateTextOnTradeManagerUI();
         }
      }
      // ****
      #ifdef __MQL5__
         ChartRedraw();
      #endif 
      
      LastChartChange = TimeLocal();   // prevent processing of too frequent CHART_CHANGE events
      
      return;
  }
  
  
  
  

  if (id == broadcastEventID && ThisChartIsActive) {
      if (sparam == "PinBarPossible") {
         //Print("Broadcast msg received: ", sparam, " on ", ChartSymbol(lparam));
         if (lparam != ChartID()) PB_HighLightWLPairButton(lparam); // lparam = ChartID, pair of which needs to be highlighted
      }
      return;
  }



  
  if (id==CHARTEVENT_KEYDOWN && ThisChartIsActive) {
      // Print("id = " + IntegerToString(id) + " | lparam = " + IntegerToString(lparam) + " | " + DoubleToString(dparam,2) + " | sparam = " + sparam);
      ProcessShortCuts(lparam, sparam);
      if (SHIFT_Pressed == false && lparam == 16) SHIFT_Pressed = true;
      
      if (InWatchList) {
         UpdateLevelsArray(); // in case any parameter of some levels were changed by some shortcut
         UpdateDayPriority(); // first array of levels should be updated
      }     
      
     return;
  }
  
   
   
   
   if (id==CHARTEVENT_OBJECT_DELETE && !SimulatorMode) { // this event can be triggered by A-BF Tools when it goes over all Fibo and updates them.

      if (StringFind(sparam,"m_") != -1) return; // do not process creation of UI elements of Posision Sizer
      if (ObjectType(sparam) > 23) return; // UI elements of a panel
      if (StringFind(sparam,"PSC") != -1) return;
      if (StringFind(sparam,"PS_") != -1) return;
      if (StringFind(sparam,"Button") != -1) return;
      if (StringFind(sparam,"Label") != -1) return;
      if (StringFind(sparam,"WL_Pair") != -1) return;
      if (StringFind(sparam,"LOADMORE") != -1) return;
      if (StringFind(sparam,"MinMax") != -1) return;
      if (StringFind(sparam,"Close") != -1) return;
      if (StringFind(sparam,"Caption") != -1) return;
      if (StringFind(sparam,"Back") != -1) return;
      if (StringFind(sparam,"Border") != -1) return;

      Print("CHARTEVENT_OBJECT_DELETE: Deleting '" + sparam + "'; Object Type: " + IntegerToString(ObjectType(sparam)));

      CTrend trend(sparam);
      trend.DeleteTriangle();
      trend.DeleteChannel();
      trend.DeleteLabels();
      
      CLevel level(sparam);
      level.DeleteLabels();
      ObjectDeleteSilent(0,level.ExtToTakeOutLabelName());
      
      i_SelectedObjectsCount = SelectedObjectsCount();
      UnselectAll_Button.Text(IntegerToString(i_SelectedObjectsCount));
      FloatingLabel.Text(IntegerToString(i_SelectedObjectsCount));

      if (InWatchList) {
         //UpdateLevelsArray(); - почему-то наличие этого обновления здесь вызывает тройной вызов этой функции не понятно из каких мест и при удалении нескольких уровней одновременно - подвисание терминала
         UpdateDayPriority();
         RefreshComment();
      }

      if (StringFind(sparam,"BigFibo") != -1 || StringFind(sparam,"SmallFibo") != -1) {
         //Print("Deleting linked fibo...");
         CFibo fibo(sparam);
         fibo.DeleteLinkedFibo();
      }
      UpdatePositionOfAllButtons(id, X_Delta);
      //ChartRedraw();
   }
   
   
   

   if(id==CHARTEVENT_OBJECT_CLICK) {
   
      //Print("CLICK");
      
      if (!LightVersion) TradeManager.OnClick(sparam);   
      
      //if((ENUM_PROGRAM_TYPE)MQLInfoInteger(MQL_PROGRAM_TYPE)==PROGRAM_INDICATOR)
      //   Print("This is indicator");
      //else if((ENUM_PROGRAM_TYPE)MQLInfoInteger(MQL_PROGRAM_TYPE)==PROGRAM_EXPERT)
      //   Print("This is expert");
      
      //Print("Object clicked: " + sparam + " | ZORDER = " + ObjectGetInteger(0,sparam,OBJPROP_ZORDER)); 
     
     //CGraphObject obj_temp(sparam);
     //int LastBrokenByBarIndex;
     //int times_broken = obj_temp.TimesBroken(_Period,LastBrokenByBarIndex);  
     //Print("Object '" + sparam + "' is broken: ", IntegerToString(times_broken) + " times; LastBrokenByBarIndex = ", IntegerToString(LastBrokenByBarIndex));


      // ************************************************************************
      // ******************          SIMULATIONS        *************************
      // ************************************************************************
      if (sparam == "FourStrings_NewDay" && !LightVersion) {
         Print(__FUNCTION__ + ": New Day started! (SIMULATION)");
         TradeManager.FourStrings_OnNewDay();         
      }

      
      if (sparam == "PinBarCheck") {
         Print("Simulation of pin bar check");
         Current_H1_Bar.PinBarDetector(HoursDelay);
         return;
      }
      
      
      if (sparam == "Watchlist_S3_Autobuild_Simulate") {
         Print("Simulating S3 Watch List build on this chart");
         Watchlist_S3_Autobuild();
      }
      
      if ( sparam == "D1BreakTest" ) {
         Print("Simulating receipt of command 'FIND_D1_BREAKS'");
         Watchlist_S4_Autobuild();
      }
      
      if ( sparam == "Strategy_D1_BodyLevelsOnBarCloseOnH1" && !LightVersion) {
         int index = iBarShift(_Symbol,PERIOD_H1,iTime(NULL, PERIOD_D1, 1));
         TradeManager.ToggleBodyLevels(Strategy, PERIOD_H1, index, DayPriority);
         UpdateLevelsArray();
         DisqualifyBrokenLevels_StrategyD1();
      }
      
      if ( sparam == "BackBreak_SIM" ) {
         Print("Simulating Backwards Break Event - Process Possible backwards break...");
         TradeManager.ProcessBackwardsBreak();  
      }
      
      if ( sparam == "S3Imp_SIM" ) {
         Print("Simulating S3 impulse detection...");
         Current_H1_Bar.Alert_and_Sound_for_S3_Impulse(Levels,ATR5,IsSoundControlON()); 
      }
      
      if ( sparam == "PossThreat_SIM" ) {
         Print("Simulating possible threat check...");
         TradeManager.AlertOnPossibleThreateningBar(ATR5);
      }  
      
      if ( sparam == "AutoEntry_SIM" ) {
         Print("Simulating auto-entry...");
         TradeManager.AutoEntryOnBarClose();
      }
      
      // ************************************************************************
      // ************************************************************************
      
      
      UpdatePositionOfAllButtons(id, X_Delta); // important to update main UI buttons after each click
      

      i_SelectedObjectsCount = SelectedObjectsCount();
      MoveColorChangeButtonToLevel(sparam, (int)lparam, (int)dparam);
         
      
      if (InWatchList && (ObjectTypeMQL4(sparam) == OBJ_ARROW || ObjectTypeMQL4(sparam) == OBJ_TREND)) {
         UpdateLevelsArray(); // update global Levels[] array, just in case levels were updated.
         UpdateDayPriority();
         RefreshComment();
      }
      

      
      // =============================  Auto Tools ("A") is ON during OBJECT_CLICK  ==============================
      if (AutoBFTools) {
         if(ObjectTypeMQL4(sparam)==OBJ_TREND) {
            CTrend trend(sparam);
            if (!SimulatorMode) trend.AutoCreateChannel(lparam);
            MessageOnChart(trend.LastError, MessageOnChartAppearTime);
            trend.SetPointsOnH1Extremums();
            if (Strategy == BF || Strategy == S3) {
               trend.DrawUpdateTriangle(lparam);
               trend.RestyleOutdatedTrend(); 
               trend.DashDotDotToSolid();
            }
            
            if (_Period == PERIOD_H1 && Strategy == D1) {
               DisqualifyBrokenLevels_StrategyD1();
               int LastBrokenByBarIndex;
               if (trend.TimesBroken(PERIOD_H1,LastBrokenByBarIndex) > 1)
                  trend.Style(STYLE_DOT);
            }
            
            int TFmask = (int)ObjectGetMQL4(trend.Name,OBJPROP_TIMEFRAMES);
            if(TFmask == 31 || TFmask == 30 || TFmask == 28 || TFmask == 24 || TFmask == 16 || TFmask == 48 || TFmask == 80) { 
               // find a better way to find out, if an object is visible on an individual time frame
               if (Strategy == BF) {
                  trend.UpdateStatus(); 
                  trend.UpdatePoint2WhenPreliminary(); 
                  //}
               }
               
               UnselectAll_Button.Text(IntegerToString(i_SelectedObjectsCount));
               FloatingLabel.Text(IntegerToString(i_SelectedObjectsCount));
               trend.UpdateToolTip();
               return;
            }
            trend.UpdateToolTip();
         }
                
         if(ObjectTypeMQL4(sparam)==OBJ_FIBO && Strategy != FourStrings) {
            Print("Fibo '" + sparam + "' clicked");
            CFibo fibo(sparam);
            fibo.ExtendFibo();
            fibo.UpdateLevels(); // then we update delete broken fibo levels
            fibo.UpdateToolTip();
            i_SelectedObjectsCount = SelectedObjectsCount();
            UnselectAll_Button.Text(IntegerToString(i_SelectedObjectsCount));
            FloatingLabel.Text(IntegerToString(i_SelectedObjectsCount));
            return;
         }
         ChartRedraw();
         } // AutoBFTools

      //-------------------------------------------------------------------------------------
      
         
         // First, buttons that do not work with selected objects       

            if(sparam=="AutoBFTools_Button") {
                  AutoBFToolsButton_Click();  
                  return;
            }             
            
            if(sparam=="SaveTemplate_Button") {
                  SaveTemplate_Button_Click();  
                  return;
            }  
       
           if(sparam=="Minimize_Button") {
               HideShowButtons();
               return;
           }
            
            if(sparam=="WL_InWL_High_Button") {
               HighClicked();
            }

            if(sparam=="WL_InWL_Low_Button") {
               LowClicked();
            }            
            
            
            if(sparam=="ClearWL_Button") {
               if (ClearWLButtonPressedCount < 2) { 
                  ClearWLButtonPressedCount++; 
                  MessageOnChart("Click 3 times in 2 sec; Clicked: " + IntegerToString(ClearWLButtonPressedCount) + "/3", MessageOnChartAppearTime);
                  //Print("ClearWLButtonPressedCount = ", ClearWLButtonPressedCount); 
               }
               else { 
                  MessageOnChart("Clearing Watch List...", MessageOnChartAppearTime);
                  BroadcastEvent(ChartID(),0,"CLEAR_WATCHLIST");
                  ClearWLButtonPressedCount = 0;
                }
            }
            
            
            
            if (sparam=="SoundControl_Button") {
               ToggleSoundControl();
               return;
            }
            
            if (sparam=="PushControl_Button") {
               TogglePushControl();
            }
            
            if (sparam=="FixChartScale_Button") {
               ToggleFixChartScale();
            }
            
       
         // Shift + Click = Delete object sparam       
         //Print("SHIFT_Pressed = ", SHIFT_Pressed);
         if (SHIFT_Pressed) { // Shift is pressed and click on an object is made
            //Print("Shift + Click");
            SHIFT_Pressed = false;
            return;
         }  
         
         
         
          //---------- Watch List Buttons Click Handling ---------------------------
          if (WatchListButtonsClickHandler(sparam)) return;
      
          //  -----------------  Watch List Pair Buttons Click Handling ---------------------
          if (WatchListPairButtonsClickHandler(sparam)) return;
         //
      
         i_SelectedObjectsCount = SelectedObjectsCount();
         UnselectAll_Button.Text(IntegerToString(i_SelectedObjectsCount));
         FloatingLabel.Text(IntegerToString(i_SelectedObjectsCount));
      
         // Now bottons, which require at least one object to be selected
            //  -----------------  Modification of Lines ---------------------
         // Now buttons, which require at least one object to be selected     
         if (SelectedObjectsCount() != 0) { 
            LineModificationButtonClickHandler(id, sparam); 
            if (InWatchList) {
               UpdateLevelsArray(); // just in case any level gets re-colored
               UpdateDayPriority(); // first array of levels should be updated
            }
         }
         //----------------------------------------------------------------
         //Print("Updating tooltip");
         CGraphObject obj(sparam);
         obj.UpdateToolTip();
   




      // =============================  Meta Keypad  ==============================
   
      if (sparam=="Crosshair_Button") {
         ToggleCrosshairMode();
         return;
      }   
   
      if (sparam=="ChartNavigateLeft_Button") {
         Print("sparam = ", sparam);
         SwitchToChart(GetPrevChartID());
         ChartNavigateLeft_Button.Pressed(false);
         return;
      }
      
      if (sparam=="ChartNavigateRight_Button") {
         if (ChartNext(ChartID()) != -1) { SwitchToChart(ChartNext(ChartID())); }
         ChartNavigateRight_Button.Pressed(false);
         return;
      }
   
      if (sparam=="FixVertScale_Button") {
         long value;
         ChartGetInteger(0,CHART_SCALEFIX,0,value);
         if (value==1) ChartSetInteger(0,CHART_SCALEFIX,0,0);
            else ChartSetInteger(0,CHART_SCALEFIX,0,1);
         FixVertScale_Button.Pressed(false);
         return;
      }
      
      if (sparam=="MakeTrendHorizontalAndExtend_Button") {
         MakeTrendHorizontalAndExtend();
         MakeTrendHorizontalAndExtend_Button.Pressed(false);
         return;
      }
   
      if (sparam=="ToggleTrendRay_Button") {
         ToggleRay_and_RectangleFill();
         ToggleTrendRay_Button.Pressed(false);
         return;
      } 
      
      
      if (sparam=="DeleteObject_Button") {
         DeleteObject_Button.Pressed(false);
         string SelectedObjects[]; // first we create array of selected objects;
         for (int i = 0; i < ObjectsTotal(0, 0, -1); i++) { // for each object on the chart
            string objectName = ObjectName(0, i, 0, -1);    // getting the object name
            if (ObjectGetMQL4(objectName, OBJPROP_SELECTED) == 1) {    // is this object is selected then...   
               if (objectName != StopLossLineName &&objectName != TakeProfitLineName && objectName != EntryLineName) { // do not delete trade lines
                  ArrayResize(SelectedObjects,ArraySize(SelectedObjects)+1);  // putting name of that object into an array
                  SelectedObjects[ArraySize(SelectedObjects)-1] = objectName;
               }
            }
         }
         
         if (ArraySize(SelectedObjects) == 0) return;
         Print("Array Size = ", ArraySize(SelectedObjects));
         
         // secondly, we delete them
         for (int i = 0; i < ArraySize(SelectedObjects); i++) {
            
               ObjectDeleteSilent(SelectedObjects[i]);
         }
         UpdatePositionOfAllButtons(id, X_Delta);
         return;
      }
      
      
      if (sparam=="CopyObject_Button") {
         CopyObject_Button.Pressed(false);
         if (SelectedObjectsCount() > 1) { MessageOnChart("Select 1 object only", MessageOnChartAppearTime); return; }
         string object = GetSelectedObjectName();
         CGraphObject old_obj(object);
         string new_obj_name = old_obj.CreateCopy();
         if (StringLen(new_obj_name) > 0) {
            CGraphObject new_obj(new_obj_name);
            new_obj.Select(true);
            MessageOnChart("Copy created", MessageOnChartAppearTime);
         }
         else
            MessageOnChart("Can't copy this type of object", MessageOnChartAppearTime);      
      }
      
      
      if (sparam=="ShowHideScenarios_Button") {
         ShowHideScenarios_Button.Pressed(false);
         bool leave_levels = true;
         bool scenarious_only = true;
         HideShowAllObjectsToggle(leave_levels,scenarious_only); // leave levels untouched
         return; 
      }
      
      if (sparam=="HideShowAllObjectsExcLevels_Button") {
         HideShowAllObjectsExcLevels_Button.Pressed(false);
         bool keap_levels = true;
         bool scenarious_only = false;
         bool keep_UI = true;
         HideShowAllObjectsToggle(keap_levels, scenarious_only, keep_UI); // leave levels untouched
         return; 
      }
      //----------------------- Meta Keypad -------------------------------------



      
         
   } // End of check: if(id==CHARTEVENT_OBJECT_CLICK)
     // NO UI BUTTON PROCESSING BEYOND THIS POINT





   // =============================  Auto BF Tools  ==============================
   if(id==CHARTEVENT_OBJECT_DRAG) { // // snapping horizon to canble body, or to extremums
      if (AutoBFTools) {
         //Print("Dragging...");
         SnapHorizLevelToBars(sparam);
         
         // Trade Manager
         if (!LightVersion) {
            TradeManager.OnClick(sparam);
            //TradeManager.UpdateTradeLinesVisibleValue();
            //TradeManager.UpdatePosOfTradeManager();
            //TradeManager.UpdateTextOnTradeManagerUI();
         }
         // ************
      }
      if (!LightVersion) {
         //TradeManager.BreakEvenLine.OnDrag();
         TradeManager.AutoEntryControl.OnDrag(sparam);
      }
      ChartRedraw();
   }
   

   
   //-------------------------------------------------------------------------------------
} // End of OnChartEvent function



















int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
  
  
   // ===== Making sure that in Simulator Mode OnCalculate will not be processed more than once a second =====
   static datetime lastRunTime = 0;
   datetime currentTick = GetTickCount(); // Get current system tick count
   bool NewH1Bar = NewHour();
   bool NewD1Bar = NewBar(PERIOD_D1);
   
   if (!NewH1Bar && !NewD1Bar) { // and this is not a new bar
      if (SimulatorMode && (currentTick - lastRunTime < 1000) ) { // 1000 ms = 1 sec
            //Print("Skip");
            return (rates_total);
         }
   }
   lastRunTime = currentTick; // Update lastRunTime
   //Print(__FUNCTION__ + ": NewH1Bar = " + NewH1Bar + "  | NewD1Bar = " + NewD1Bar);
   /// ===================================================================================================================
  

  

  if ( !OperationAllowed ) return(rates_total); // protection
  if (!InWatchList && !SimulatorMode) return(rates_total);
  if (LightVersion) return(rates_total);

 
  if (SimulatorMode) {
      latest_close_price = close[0];
      TradeManager.UpdateATRRange();
  }
  
   if (total_orders != OrdersTotal()) {   
      OnTrade();
      total_orders = OrdersTotal();
   }
  
  
  

  
   int i_today = TimeDayOfWeekMQL4(TimeLocal());
   // next we compare to the local time instead of server time, because server time comes only with ticks - and it can be too late.

   if(    TimeHourMQL4(TimeLocal()) >= StartSignalDetectorsAt 
      &&  TimeHourMQL4(TimeLocal()) <= StopSignalDetectorsAfter 
      &&  i_today != 6 && i_today != 0  
      &&  TimeMinuteMQL4(TimeLocal()) >= StartAlertsEveryHourAtMin
      )     {
      // allowed days of week and hours for signal detectors and allowed minute checking all types of signals
         Current_H1_Bar.PinBarDetector(HoursDelay);
         if (Strategy == D1) Current_H1_Bar.LevelFalseBreakDetectorD1();
         
         if ( Strategy == S3 || Strategy == Stratezhka || Strategy == Other ) Current_H1_Bar.Alert_and_Sound_for_S3_Impulse(Levels,ATR5,IsSoundControlON());
         
         TradeManager.AlertOnPossibleThreateningBar(ATR5);         
     }
  
  
   
   if (ThisChartIsActive) { 
      TradeManager.DisplayDistanceToClosestLevel(); // Display distance to closest level
      TradeManager.DisplayDistanceEntryLineToClosestLevel();
      if (TradeManager.TradeLinesVisible && TradeManager.Order_Type() == "Instant")
         TradeManager.UpdateVisPosOfRecommendedSLRange();
   }
  
  
   // ******************** Trade Manager - At each tick *************************
   TradeManager.TradesArray.Update();
   TradeManager.Delete_Limit_Order_if_BE_Level_Is_Reached();
   
   if (TradeManager.TradeLinesVisible && ThisChartIsActive) {
      TradeManager.UpdateTextOnTradeManagerUI();  
   }
   // ************************************************************
  

   // ******************** Four Strings Strategy *************************
   if (Strategy == FourStrings) {
      TradeManager.FourStrings_OnCalculate();  
      if (NewDay()) {
         Print(__FUNCTION__ + ": New Day started!");
         TradeManager.FourStrings_OnNewDay();
      }
   }
   // ************************************************************
   
   
   
  if (SimulatorMode) {
      if (NewD1Bar) 
         if (Strategy == S3) Watchlist_S3_Autobuild();
  }

   

   if (NewH1Bar) { // this function works only once per hour.
  
      if (DebugMode) Print("New Hour");
   
      // REDUCING HOURS DELAY FOR NON S-VERSION   
      if (!S_Version) {   
            i_today = TimeDayOfWeekMQL4(TimeLocal());
            if(HoursDelay > 1 && i_today!=6 && i_today!=0) { // reducing Hours Delay for this pair by 1, and updating the watch list pair button
               HoursDelay--;
               SetHoursDelay(HoursDelay,_Symbol);
               ResetAllWatchButtons();
               HighlightWatchButton(HoursDelay);
            }
               else if (HoursDelay == 1) {
               ChartCheckNeededSet(ChartCheckMissed,_Symbol,ChartID());
               //Print("Chart check missed!"); 
               BroadcastEvent(ChartID(),0,"ChartCheckMissed");
            }
      }
      // END OF HOURS DELAY

      
      // resetting information flag about all kinds of events
      sets.InformedAbS3imp = false;
      sets.InformedAbThreat = false;
      sets.InformedAbCheckTheChart = false;
      sets.InformedAbPinBar = false;
      sets.SaveSettingsOnDisk();
      //InformedAboutCheckTheChartSet(false); // notification when HoursDelay == 1
      //Current_H1_Bar.Reset_InformedAboutPossibleS3Impulse(); // resetting flag about possible S3-impulse
      //Current_H1_Bar.Reset_InformedAboutPossibleThreat();    // resetting flag about possible threat
      
   
      TradeManager.ProcessBackwardsBreak();
      TradeManager.AutoEntryOnBarClose(); // perform auto-entry on bar close, if switched on
      
      
      
      // **** H1-bar closure processing for Strategy "D1" *************************************************************************
      InformAboutFormedD1Signal();
      if (Strategy == D1 && InWatchList && (DayPriority == Sell || DayPriority == Buy) &&  i_today != 6 && i_today != 0 ) {
         if (TradeManager.TradesArray.TradesActiveOnSymbolSameDirection(_Symbol,DayPriority) == 0) {
            int index = iBarShift(_Symbol,PERIOD_H1,iTime(NULL, PERIOD_D1, 1)); // first bar of yesterday
            TradeManager.ToggleBodyLevels(Strategy, PERIOD_H1, index, DayPriority);
         }
         else
            MessageOnChart("Active order(s) on chart: Not auto-creating levels on H1 close", MessageOnChartAppearTime);
         UpdateLevelsArray();
         DisqualifyBrokenLevels_StrategyD1();
      }
      // *************************************************************************************************************************
  
  
  
      if (AutoBFTools) {
            // Automation specific for BF
            if (Strategy == BF || Strategy == S3) {
               //Update status of trend lines
               //  Solid trends -> Dot-Dot (when outdated) - temporary disabled, as it is sometimes causing false change of style to dot-dot
               AllDashDotDotTrendsToSolid(); //  DashDotDot -> Solid (when new extremum appears)
      
               
               // 
               if (HoursDelay != -1) {   
                  UpdateLevelsArray(); // update global Levels[] array, in case some levels were broken with this new bar
                  UpdateDayPriority(); // first array of levels should be updated
               
                  //  Solid -> Dashed (when broken)
                  for (int i = 0; i < ObjectsTotal(0, 0, -1); i++) { // for each object on the chart
                     string TrendLineName = ObjectName(0, i, 0, -1);    // getting the object name
                        if(ObjectTypeMQL4(TrendLineName)==OBJ_TREND && ObjectGetMQL4(TrendLineName,OBJPROP_STYLE) == STYLE_SOLID) {
                           CTrend trend(TrendLineName);
                           if(trend.IsVisibleOnTF(_Period)) trend.UpdateStatus();  
                           int LastBrokenByBarIndex;
                           int TimesBroken = trend.TimesBroken(PERIOD_H1,LastBrokenByBarIndex);
                           if(TimesBroken == 1 || TimesBroken == 2) {
                              if(LastBrokenByBarIndex == 1) { // new break is registered for trend (up to 1 break) or for channel (up to 2 breaks)
                                 HoursDelay=1;
                                 SetHoursDelay(HoursDelay,_Symbol);
                                 ResetAllWatchButtons();
                                 HighlightWatchButton(HoursDelay);
                              }
                           }     
                        }
                   }
               } // if (_Period == PERIOD_H1)
            } // if (Strategy == BF || Strategy == BF2)
      }   // if (AutoBFTools)
      
      sets.AutoEntryOnBarClose = false;
      sets.SaveSettingsOnDisk();
   } // NewHour() && !LightVersion

   //-------------------------------------------------------------------------------------
   

  return(rates_total);

}
  



void OnTrade() {
   
   if (!LightVersion) {
      Print("OnTrade Event triggered");
      TradeManager.OnTrade();
   }
}
