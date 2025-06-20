
NOT USED SO FAR!
SHOULD BE USED WHEN MOVING TO EA


class TradeEXE
  {
private:

public:
                     TradeEXE();
                    ~TradeEXE();
                    
   void              OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam);
   void              OnTick();
   void              OnTrade();
   void              OpenTrade();
   void              setMinLoss(int ticket);
   bool              setBE(bool RightNow = false);
   void              CalculateOpenVolume(double &volume_buy, double &volume_sell);
                  
   double            ppBE; // Break Even Distance
   int               Order_Type;
   int               total_orders;
   string            Commentary;
   
   bool DisableTradingWhenLinesAreHidden, SubtractPositions, SubtractPendingOrders, DoNotApplyStopLoss, DoNotApplyTakeProfit, AskForConfirmation;
   int MaxSlippage, MaxSpread, MaxEntrySLDistance, MinEntrySLDistance, MagicNumber;
   double MaxPositionSize;
   
   
   ushort            eventID;
   bool              IsTradeAllowed_LastValue;
   bool              FourStringsOrder; // flag to identify whether it is an order from FourStrings Strategy; defined via commentary
   
   datetime    MessageOnChartAppearTime;
   
   MTSettings sets; // access to settings of MetaTools class and file
   
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TradeEXE::TradeEXE()
  {
  
   // initializing variables
   ppBE = 0;         // Break Even Distance
   Order_Type = 0;
   total_orders = 0;
   MaxSlippage = 0;
   MagicNumber = 0;
   IsTradeAllowed_LastValue = false;
   FourStringsOrder = false;
   Commentary = "Trade.exe";
  
  
   sets.LoadSettingsFromDisk();
   
   if (sets.BreakEvenPP() != 0) {
      ppBE = sets.BreakEvenPP();
      //Print("Break Even Level " + DoubleToString(ppBE,2) + "pp assigned from Settings File");
   }
   else {
      //Print("Break Even Level Not Assigned");
      ppBE = 0;
   }
   
   
   // *** Let BF Tools know that Trade.exe is now running ***
   //long trade_allowed = 0;
   IsTradeAllowed_LastValue = IsTradeAllowed();
   //if (IsTradeAllowed_LastValue) trade_allowed = 1;
   
   // I suspect this message generation may have caused a large delay when changing accounts
   //if (!GenerateEvent(TRADE_EXE_LIVE,trade_allowed)) Print("Couldn't send 'TRADE_EXE_LIVE' with 'trade_allowed' = '" + IntegerToString(trade_allowed) + "'");
   // ******************************************************
//---

   total_orders = OrdersTotal();
   
   //return(INIT_SUCCEEDED);
   
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TradeEXE::~TradeEXE()
  {
  }
//+------------------------------------------------------------------+






void TradeEXE::OnTick()
  {
//---
   //Print("Tick starts");
   if (ppBE > 0) {
      bool moved_to_be;
      moved_to_be = setBE(); // set orders to break even, only, if set in settings file
      if (moved_to_be) {
         BarInfoIcon(0,PERIOD_H1,115,clrGreen,"SL moved to Break Even by Trade.exe");
      }
   }
   

   
   
   // if Trade Allowed is changed since last tick (event is NOT generated at every tick!)
   if (IsTradeAllowed_LastValue && !IsTradeAllowed()) {
      GenerateEvent(TRADE_EXE_LIVE,0); // inform that trade is now not allowed (0 means not allowed)
      IsTradeAllowed_LastValue = false;
      Print("Trading NOT allowed");
   }
   
   // and visa-versa
   if (!IsTradeAllowed_LastValue && IsTradeAllowed()) {
      GenerateEvent(TRADE_EXE_LIVE,1); // inform that trade is now allowed (1 means not allowed)
      IsTradeAllowed_LastValue = true;
      Print("Traing ALLOWED");
   }
   
   
   if (total_orders != OrdersTotal()) {
      OnTrade();
      total_orders = OrdersTotal();
   }
   
   
  }





void TradeEXE::OnTrade() {

   Print("OnTrade Event triggered");

}








//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void TradeEXE::OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
  
  

   if (id == TRADE_OPEN_COMMAND + 1000) {
      Print("TRADE_OPEN_COMMAND event is received");
      ppBE = 0; // first - reset BE level, so that newly opened trade will not move to BE instantly
      Commentary = sparam;
      OpenTrade();
      sets.LoadSettingsFromDisk(); // to update settings, especially new Break Even Level, which should be zero.
      return;
   }
   
   
   if (id == TRADE_BREAKEVEN_SET + 1000) {
      Print("TRADE_BREAKEVEN_SET event received");
      bool immediatelly = true;
      setBE(immediatelly); // set all trades on this symbol to break event right now
      return;
   }
   
   
   if (id == TRADE_MINLOSS_SET + 1000) {
      Print("TRADE_MINLOSS_SET event received");
      int ticket = (int)lparam; // ticket of the order that needs to be moved to Min Loss
      if (ticket == 0) Print("Ticket is 0. Not moving any orders to Min Loss");
      setMinLoss(ticket); // sets single negative trade on this symbol to Min Loss
      return;
   }
   
   if (id == TRADE_EXE_PING + 1000) {
      //Print("TRADE_EXE_PING event received");
      long trade_allowed = 0;
      if (IsTradeAllowed()) trade_allowed = 1;
      Sleep(1000);
      if (!GenerateEvent(TRADE_EXE_LIVE,trade_allowed)) Print("Couldn't send 'TRADE_EXE_LIVE'");
      
      return;
   }
   
   if (id == TRADE_BREAKEVEN_UPDATED + 1000) {
   
      Print("ppBE before = ", ppBE);
   
      sets.LoadSettingsFromDisk();
      
      if (sets.BreakEvenPP() != 0) {
         
         if (Symbol() != "XAUUSD" && Symbol() != "BRN")
            ppBE = sets.BreakEvenPP()/10;
         else
            ppBE = sets.BreakEvenPP();
         
         if(Digits()==3 || Digits()==5)
            ppBE*=10;
            //Print("ppBE after = ", ppBE);
            //Print("New Break Even is: ", sets.BreakEvenLevel(), " (", sets.BreakEvenPP()/10 ,"pp)");
         Print("ppBE after = ", ppBE);
      }
      else {
         //Print("Break Even Level NOT changed. Still: ", ppBE, "pp");
      }
      return;
   }
   



   if (id == TRADE_BACKWARDSBREAK_UPDATED + 1000) {
   
      Print("ppBB before = ", DoubleToString(sets.BackwardsBreakPP(),1));
   
      sets.LoadSettingsFromDisk();
      
      Print("ppBB after = ", DoubleToString(sets.BackwardsBreakPP(),1));

      return;
   }



   
   if (id == TRADE_CLOSE_COMMAND + 1000) {
      Print("TRADE_CLOSE_COMMAND is received");
      int ticket = (int)lparam;
      if (!OrderSelect(ticket,SELECT_BY_TICKET)) {
         Print("Could not select order#" + IntegerToString(ticket), " to delete it");
         return;
      }
      int order_type = OrderType();
      color clr;
      double ClosePrice = 0; // for active order

      if (order_type == OP_BUY || order_type == OP_BUYLIMIT || order_type == OP_BUYSTOP) clr = clrBlue;
      else
         clr = clrRed;

      
      if (order_type == OP_BUYLIMIT || order_type == OP_BUYSTOP || order_type == OP_SELLLIMIT || order_type == OP_SELLSTOP) {
         // For pending orders
         if(OrderDelete(ticket,clr)) {
            Print("Pending order #'" + IntegerToString(ticket)  + "' has been deleted");
            sets.BreakEvenLevel(0,0); // resetting break even level not to affect future orders
            GenerateEvent(TRADE_CLOSED,0);
         }
         else Print("Deleting error for pending order #'" + IntegerToString(ticket)  + "'. Error code: " + IntegerToString(GetLastError()));
      }
      else
         // for active orders
         
         if (order_type == OP_BUY) ClosePrice = Bid;
         else ClosePrice = Ask;
         if (OrderClose(ticket,OrderLots(),ClosePrice,10)) {
            Print("Order #'" + IntegerToString(ticket)  + "' has been closed");
            sets.BreakEvenLevel(0,0); // resetting break even level not to affect future orders
            sets.BackwardsBreakLevel(0,0);
            sets.SaveSettingsOnDisk();
            GenerateEvent(TRADE_CLOSED,0);
         }
         else Print("Closing error for order #'" + IntegerToString(ticket)  + "'. Error code: " + IntegerToString(GetLastError()));
   }
   
   
   if (id == TRADE_DELETE_ALL_YESTERDAY_PENDING_4STRINGS + 1000) {
      string symbol = sparam;
      Print("'TRADE_DELETE_ALL_YESTERDAY_PENDING_4STRINGS' is received. Closing all pending orders on '" + sparam + "' which opened yesterday");
      
      for(int i=OrdersTotal()-1; i >= 0 ; i--) {
         if (!OrderSelect(i,SELECT_BY_POS)) {
            Print("Could not select order with index " + IntegerToString(i) + ". Skipping to next one");
            continue;
         }
         CMetaTrade trade(OrderTicket());
         if (trade.TradeSymbol() == symbol) { 
            if (trade.TradeStrategy() == FourStrings) {
               ENUM_ORDER_TYPE tt = trade.TradeType();
               if (tt == ORDER_TYPE_BUY_LIMIT || tt == ORDER_TYPE_SELL_LIMIT) {
                  if ( trade.OpenDateOnly() <= Yesterday() ) {
                     Print("Deleting yesterday 'Four Strings' pending order with comment '" + trade.TradeComment() + "'");
                     trade.DeletePendingOrder();
                  }
               } 
            }
         }
      }
   }
   
   
   if (id == TRADE_DELETE_ALL_TODAY_PENDING_4STRINGS + 1000) {
      string symbol = sparam;
      Print("'TRADE_DELETE_ALL_TODAY_PENDING_4STRINGS' is received. Closing all pending orders on '" + sparam + "' which opened today");
      
      for(int i=OrdersTotal()-1; i >= 0 ; i--) {
         if (!OrderSelect(i,SELECT_BY_POS)) {
            Print("Could not select order with index " + IntegerToString(i) + ". Skipping to next one");
            continue;
         }
         CMetaTrade trade(OrderTicket());
         if (trade.TradeSymbol() == symbol) { 
            if (trade.TradeStrategy() == FourStrings) {
               ENUM_ORDER_TYPE tt = trade.TradeType();
               if (tt == ORDER_TYPE_BUY_LIMIT || tt == ORDER_TYPE_SELL_LIMIT) {
                  if ( trade.OpenDateOnly() == Today_DateOnly() ) {
                     Print("Deleting today's 'Four Strings' pending order with comment '" + trade.TradeComment() + "'");
                     trade.DeletePendingOrder();
                  }
               } 
            }
         }
      }
   }
   
   
   
   
   if (id == TRADE_DELETE_PENDING_ORDER_OPEN_MARKET_ORDER + 1000) {
      Print("Trying to delete pending order #" + IntegerToString(lparam));
   
      if ( OrderDelete((int)lparam) ) 
         EventChartCustom(ChartID(),TRADE_PENDING_ORDER_DELETED_OPEN_MARKET_ORDER,lparam,0,"");
      else
         Print("Could not delete pending order #" + IntegerToString(lparam));
         
      return;
   }
   
   
   
   
   
   if (id == LOAD_LAST_TEMPLATE + 1000) {
      Print("Loading last template");
      
      // finding the last saved template for this pair in MQL\Files
         string   file_name;      // переменная для хранения имен файлов
         string   filter="*" + Symbol() + "*.tpl"; // фильтр для поиска файлов
         string   file_names[];   // список имен файлов
         datetime create_dates[]; // список дат последней модификации тех же файлов
         int n = 0;
      //--- получение хэндла поиска в корне локальной папки MQL\Files
         long search_handle=FileFindFirst(filter,file_name);
      //--- проверим, успешно ли отработала функция FileFindFirst() - то есть найден хотя бы один первый файл
         if(search_handle!=INVALID_HANDLE) {
            do {//--- в цикле перебираем файлы
               ArrayResize(file_names,  ArraySize(file_names)  +1); //--- увеличим размер массива
               ArrayResize(create_dates,ArraySize(create_dates)+1); //--- увеличим размер массива
               file_names[n]=file_name; // saving file name
               create_dates[n] = (datetime)FileGetInteger(file_name,FILE_CREATE_DATE,false); // saving its creation date
               n++;
              }
            while(FileFindNext(search_handle,file_name));
            FileFindClose(search_handle); //--- закрываем хэндл поиска
           }
         else { // no files found
            Print("No previously saved templates found!");
            return;
           }
   // файлы шаблонов для данной пары найдены
   
   // list all found files for this pair
   //Print("Files found: " + IntegerToString(ArraySize(file_names)));
   //for (int i = 0; i < ArraySize(file_names); i++) {
   //   Print("File " + IntegerToString(i) + ": ", file_names[i], "; Created On: " + TimeToString(create_dates[i], TIME_SECONDS));
   //}

   // Searching for the latest saved (created) file among those in the array
   int index_of_last_file;
   if (ArraySize(file_names) == 1) index_of_last_file = 0;
   else { // there are more than 1 file -> searching for the newest one
      datetime dt = create_dates[0];
      for (int i = 1; i < ArraySize(create_dates); i++) {
         if (create_dates[i] > dt) {
            // newer file is found
            dt = create_dates[i];
            index_of_last_file = i;
         }
      }
   }
   
   Print("Latest saves templates is: " + file_names[index_of_last_file] + "; Created On: " + TimeToString(create_dates[index_of_last_file],TIME_SECONDS));
   
   // loading found file
   string path = "\\Files\\" + file_names[index_of_last_file];
   
   if(ChartApplyTemplate(0,path)) {
      Print("The template '" + path  + "' applied successfully");
   }
   else
      Print("Failed to apply '" + path  + "', error code ",GetLastError());
   return;

   }
   
   
   
   
   //-------------------------------------------------------------------------------------
} // End of OnChartEvent function
































      ///  ********** OTHER FUNCTIONS ***************




   
bool BroadcastMessage(int event, int ticket) {

   double Double = 1;   // floating point number
   bool success = false;        // result of sending message
   string String = IntegerToString(event);
   
   success = EventChartCustom(ChartID(),(ushort)event,ticket,Double,String);

   if (!success) { 
      Print("Couldn't generate custom event '" + IntegerToString(event) + "'. Error code: ", GetLastError());
      return false;
   }
   else
      //Print("Message '", IntegerToString(event), "' sent from Trade.exe on ticket '" + IntegerToString(ticket) + "'");
      return true;

}






void TradeEXE::OpenTrade() {

   int ticket = 0; // my custom code


   //enum ENTRY_TYPE
   //{
   //   Instant,
   //   Pending
   //};



   // ******************************************
   // **** // COPY & PASTE FROM PSC SCRIPT ****
   // ******************************************

   string ps = ""; // Position size string.
   double el = 0, sl = 0, tp = 0; // Entry level, stop-loss, and take-profit.
   int ot; // Order type.
   ENTRY_TYPE entry_type;

   if (!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))
   {
      Alert("AutoTrading disabled! Please enable AutoTrading.");
      return;
   }

   // WindowFind() is very poor at finding indicators by their short name in MT4. Using ChartIndicatorName comparison instead.
   bool psc_found = false;
   int chart_indicators_total = ChartIndicatorsTotal(0, 0);
   for (int i = 0; i < chart_indicators_total; i++)
   {
      if (ChartIndicatorName(0, 0, i) == "Position Size Calculator" + IntegerToString(ChartID()))
      {
         psc_found = true;
         break;
      }
   }
   if (!psc_found)
   {
      Alert("Position Size Calculator not found!");
      return;
   }

	// Trying to find the position size object.
   ps = FindObjectByPostfix("m_EdtPosSize", OBJ_EDIT);
   ps = ObjectGetString(0, ps, OBJPROP_TEXT);
	if (StringLen(ps) == 0)
   {
      Alert("Position Size object not found!");
      return;
   }

   // Replace thousand separaptors.
   StringReplace(ps, ",", "");
   
   double PositionSize = StringToDouble(ps);
   int ps_decimals = CountDecimalPlaces(PositionSize);
      
   Print("Detected position size: ", DoubleToString(PositionSize, ps_decimals), ".");

   double MinLot = MarketInfo(Symbol(), MODE_MINLOT);
   double MaxLot = MarketInfo(Symbol(), MODE_MAXLOT);
   double LotStep = MarketInfo(Symbol(), MODE_LOTSTEP);

   if (PositionSize <= 0)
   {
      Print("Wrong position size value!");
      return;
   }
   
   
   
   /* MY CUSTOM CODE START
   string ObjectPrefix = ""; // To be found.
   string el_name = FindObjectByPostfix("EntryLine", OBJ_HLINE);
   int el_name_starts_at = StringFind(el_name, "EntryLine");
   if (el_name_starts_at > 0) ObjectPrefix = StringSubstr(el_name, 0, el_name_starts_at);
   */
   string ObjectPrefix = "PSC_";
   // MY CUSTOM CODE END
   
   
   
   el = ObjectGetDouble(0, ObjectPrefix + "EntryLine", OBJPROP_PRICE);
   if (el <= 0)
   {
      Alert("Entry Line not found!");
      return;
   }
   
   el = NormalizeDouble(el, Digits);
   Print("Detected entry level: ", DoubleToString(el, Digits), ".");

   RefreshRates();
   
   if ((el == Ask) || (el == Bid)) entry_type = Instant;
   else entry_type = Pending;
   
   Print("Detected entry type: ", EnumToString(entry_type), ".");
   
   sl = ObjectGetDouble(0, ObjectPrefix + "StopLossLine", OBJPROP_PRICE);
   if (sl <= 0)
   {
      Alert("Stop-Loss Line not found!");
      return;
   }
   sl = NormalizeDouble(sl, Digits);
   Print("Detected stop-loss level: ", DoubleToString(sl, Digits), ".");

   tp = ObjectGetDouble(0, ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE);
   if (tp > 0)
   {
      tp = NormalizeDouble(tp, Digits);
      Print("Detected take-profit level: ", DoubleToString(tp, Digits), ".");
   }
   else Print("No take-profit detected.");
   
   // Try reading multiple TP levels.
   int n = 0;
   double ScriptTPValue[];
   int ScriptTPShareValue[];
   double volume_share_sum = 0;
   while (true)
   {
      ArrayResize(ScriptTPValue, n + 1);
      ArrayResize(ScriptTPShareValue, n + 1);
      ScriptTPValue[n] = 0;
   	string ScriptTPObjectName = FindObjectByPostfix("m_EdtScriptTPEdit" + IntegerToString(n + 1), OBJ_EDIT);
      if (ScriptTPObjectName != "") ScriptTPValue[n] = NormalizeDouble(StringToDouble(ObjectGetString(0, ScriptTPObjectName, OBJPROP_TEXT)), _Digits);
      else break;
      Print("Detected Multiple TP #", n + 1, " = ", ScriptTPValue[n]);

   	ScriptTPShareValue[n] = 0;
   	string ScriptTPShareObjectName = FindObjectByPostfix("m_EdtScriptTPShareEdit" + IntegerToString(n + 1), OBJ_EDIT);
      if (ScriptTPShareObjectName != "") ScriptTPShareValue[n] = (int)StringToInteger(ObjectGetString(0, ScriptTPShareObjectName, OBJPROP_TEXT));
      else break;
      Print("Detected Multiple TP Share #", n + 1, " = ", ScriptTPShareValue[n]);
   	
   	volume_share_sum += ScriptTPShareValue[n];
   	
   	n++;
   }
   if (n > 0)
   {
      Print("Multiple TP volume share sum = ", volume_share_sum, ".");
      if ((volume_share_sum < 99) || (volume_share_sum > 100))
      {
         Print("Incorrect volume sum for multiple TPs - not taking any trades.");
         return;
      }
   }   
   else
   {
      // No multiple TPs, use single TP for 100% of volume.
      n = 1;
      ScriptTPValue[0] = tp;
      ScriptTPShareValue[0] = 100;
   }
   
	// Magic number
   string EdtMagicNumber = FindObjectByPostfix("m_EdtMagicNumber", OBJ_EDIT);
   if (EdtMagicNumber != "") MagicNumber = (int)StringToInteger(ObjectGetString(0, EdtMagicNumber, OBJPROP_TEXT));
   Print("Magic number = ", MagicNumber);

   // my custom code - commented following lines
   /*
	// Order commentary
   string EdtScriptCommentary = FindObjectByPostfix("m_EdtScriptCommentary", OBJ_EDIT);
   if (EdtScriptCommentary != "") Commentary = ObjectGetString(0, EdtScriptCommentary, OBJPROP_TEXT);
   Print("Order commentary = ", Commentary);

   // Checkbox for disabling trading when hidden lines
   string ChkDisableTradingWhenLinesAreHidden = FindObjectByPostfix("m_ChkDisableTradingWhenLinesAreHiddenButton", OBJ_BITMAP_LABEL);
   if (ChkDisableTradingWhenLinesAreHidden != "") DisableTradingWhenLinesAreHidden = ObjectGetInteger(0, ChkDisableTradingWhenLinesAreHidden, OBJPROP_STATE);
   Print("Disable trading when lines are hidden = ", DisableTradingWhenLinesAreHidden);

	// Entry line
   bool EntryLineHidden = false;
   int EL_Hidden = (int)ObjectGetInteger(0, ObjectPrefix + "EntryLine", OBJPROP_TIMEFRAMES);
   if (EL_Hidden == OBJ_NO_PERIODS) EntryLineHidden = true; 
   Print("Entry line hidden = ", EntryLineHidden);

	if ((DisableTradingWhenLinesAreHidden) && (EntryLineHidden))
	{
		Print("Not taking a trade - lines are hidden, and indicator says not to trade when they are hidden.");
		return;
	}
	*/
	// *************************

	// Other fuses
   string EdtMaxSlippage = FindObjectByPostfix("m_EdtMaxSlippage", OBJ_EDIT);
   if (EdtMaxSlippage != "") MaxSlippage = (int)StringToInteger(ObjectGetString(0, EdtMaxSlippage, OBJPROP_TEXT));
   Print("Max slippage = ", MaxSlippage);

   string EdtMaxSpread = FindObjectByPostfix("m_EdtMaxSpread", OBJ_EDIT);
   if (EdtMaxSpread != "") MaxSpread = (int)StringToInteger(ObjectGetString(0, EdtMaxSpread, OBJPROP_TEXT));
   Print("Max spread = ", MaxSpread);
   
   if (MaxSpread > 0)
   {
	   int spread = (int)((Ask - Bid) / Point);
	   if (spread > MaxSpread)
	   {
			Print("Not taking a trade - current spread (", spread, ") > maximum spread (", MaxSpread, ").");
			return;
	   }
	}
	
   string EdtMaxEntrySLDistance = FindObjectByPostfix("m_EdtMaxEntrySLDistance", OBJ_EDIT);
   if (EdtMaxEntrySLDistance != "") MaxEntrySLDistance = (int)StringToInteger(ObjectGetString(0, EdtMaxEntrySLDistance, OBJPROP_TEXT));
   Print("Max Entry/SL distance = ", MaxEntrySLDistance);

   if (MaxEntrySLDistance > 0)
   {
	   int CurrentEntrySLDistance = (int)(MathAbs(sl - el) / Point);
	   if (CurrentEntrySLDistance > MaxEntrySLDistance)
	   {
			Print("Not taking a trade - current Entry/SL distance (", CurrentEntrySLDistance, ") > maximum Entry/SL distance (", MaxEntrySLDistance, ").");
			return;
	   }
	}
	
   string EdtMinEntrySLDistance = FindObjectByPostfix("m_EdtMinEntrySLDistance", OBJ_EDIT);
   if (EdtMinEntrySLDistance != "") MinEntrySLDistance = (int)StringToInteger(ObjectGetString(0, EdtMinEntrySLDistance, OBJPROP_TEXT));
   Print("Min Entry/SL distance = ", MinEntrySLDistance);

   if (MinEntrySLDistance > 0)
   {
	   int CurrentEntrySLDistance = (int)(MathAbs(sl - el) / Point);
	   if (CurrentEntrySLDistance < MinEntrySLDistance)
	   {
			Print("Not taking a trade - current Entry/SL distance (", CurrentEntrySLDistance, ") < minimum Entry/SL distance (", MinEntrySLDistance, ").");
			return;
	   }
	}
	
   string EdtMaxPositionSize = FindObjectByPostfix("m_EdtMaxPositionSize", OBJ_EDIT);
   if (EdtMaxPositionSize != "") MaxPositionSize = StringToDouble(ObjectGetString(0, EdtMaxPositionSize, OBJPROP_TEXT));
   Print("Max position size = ", DoubleToString(MaxPositionSize, ps_decimals));
	   
   // Checkbox for subtracting open positions volume from the position size.
   string ChkSubtractPositions = FindObjectByPostfix("m_ChkSubtractPositionsButton", OBJ_BITMAP_LABEL);
   if (ChkSubtractPositions != "") SubtractPositions = ObjectGetInteger(0, ChkSubtractPositions, OBJPROP_STATE);
   Print("Subtract open positions volume = ", SubtractPositions);

   // Checkbox for subtracting pending orders volume from the position size.
   string ChkSubtractPendingOrders = FindObjectByPostfix("m_ChkSubtractPendingOrdersButton", OBJ_BITMAP_LABEL);
   if (ChkSubtractPendingOrders != "") SubtractPendingOrders = ObjectGetInteger(0, ChkSubtractPendingOrders, OBJPROP_STATE);
   Print("Subtract pending orders volume = ", SubtractPendingOrders);
   
   // my custom code
   /*
   // Checkbox for not applying stop-loss to the position.
   string ChkDoNotApplyStopLoss = FindObjectByPostfix("m_ChkDoNotApplyStopLossButton", OBJ_BITMAP_LABEL);
   if (ChkDoNotApplyStopLoss != "") DoNotApplyStopLoss = ObjectGetInteger(0, ChkDoNotApplyStopLoss, OBJPROP_STATE);
   Print("Do not apply stop-loss = ", DoNotApplyStopLoss);

   // Checkbox for not applying take-profit to the position.
   string ChkDoNotApplyTakeProfit = FindObjectByPostfix("m_ChkDoNotApplyTakeProfitButton", OBJ_BITMAP_LABEL);
   if (ChkDoNotApplyTakeProfit != "") DoNotApplyTakeProfit = ObjectGetInteger(0, ChkDoNotApplyTakeProfit, OBJPROP_STATE);
   Print("Do not apply take-profit = ", DoNotApplyTakeProfit);
   */
   DoNotApplyTakeProfit = false;
   DoNotApplyStopLoss = false;
   // end of my custom code
   
   
   // Checkbox for asking for confirmation.
   string ChkAskForConfirmation = FindObjectByPostfix("m_ChkAskForConfirmationButton", OBJ_BITMAP_LABEL);
   if (ChkAskForConfirmation != "") AskForConfirmation = ObjectGetInteger(0, ChkAskForConfirmation, OBJPROP_STATE);
   Print("Ask for confirmation = ", AskForConfirmation);

	ENUM_SYMBOL_TRADE_EXECUTION Execution_Mode = (ENUM_SYMBOL_TRADE_EXECUTION)SymbolInfoInteger(Symbol(), SYMBOL_TRADE_EXEMODE);
	Print("Execution mode: ", EnumToString(Execution_Mode));

   if (entry_type == Pending)
   {
      // Sell
      if (sl > el)
      {
         // Stop
         if (el < Bid) ot = OP_SELLSTOP;
         // Limit
         else ot = OP_SELLLIMIT;
      }
      // Buy
      else
      {
         // Stop
         if (el > Ask) ot = OP_BUYSTOP;
         // Limit
         else ot = OP_BUYLIMIT;
      }
   }
   // Instant
   else
   {
      // Sell
      if (sl > el) ot = OP_SELL;
      // Buy
      else ot = OP_BUY;
   }
   
	if ((SubtractPendingOrders) || (SubtractPositions))
	{
	   double existing_volume_buy = 0, existing_volume_sell = 0;
	   CalculateOpenVolume(existing_volume_buy, existing_volume_sell);
	   Print("Found existing buy volume = ", DoubleToString(existing_volume_buy, ps_decimals));
	   Print("Found existing sell volume = ", DoubleToString(existing_volume_sell, ps_decimals));
	   if ((ot == OP_BUY) || (ot == OP_BUYLIMIT) || (ot == OP_BUYSTOP)) PositionSize -= existing_volume_buy;
	   else PositionSize -= existing_volume_sell;
	   Print("Adjusted position size = ", DoubleToString(PositionSize, ps_decimals));
	   if (PositionSize < 0)
	   {
	      Print("Adjusted position size is less than zero. Not executing any trade.");
	      return;
	   }
	}
	
   if (MaxPositionSize > 0)
   {
	   if (PositionSize > MaxPositionSize)
	   {
			Print("Position size (", DoubleToString(PositionSize, ps_decimals), ") > maximum position size (", DoubleToString(MaxPositionSize, ps_decimals), "). Setting position size to ", DoubleToString(MaxPositionSize, ps_decimals), ".");
			PositionSize = MaxPositionSize;
	   }
	}

   if (AskForConfirmation)
   {
      // Evoke confirmation modal window.
      string caption = "Execute the trade?";
      string message;
      string order_type_text = "";
      string currency = AccountInfoString(ACCOUNT_CURRENCY);
      switch(ot)
      {
         case OP_BUY:
         order_type_text = "Buy";
         break;
         case OP_BUYSTOP:
         order_type_text = "Buy Stop";
         break;
         case OP_BUYLIMIT:
         order_type_text = "Buy Limit";
         break;
         case OP_SELL:
         order_type_text = "Sell";
         break;
         case OP_SELLSTOP:
         order_type_text = "Sell Stop";
         break;
         case OP_SELLLIMIT:
         order_type_text = "Sell Limit";
         break;
         default:
         break;
      }
      
      message = "Order: " + order_type_text + "\n";
      message += "Size: " + DoubleToString(PositionSize, ps_decimals);
      if (n > 1) message += " (multiple)";
      message += "\n";
      // Find Account Size button and edit.
      string account_button = FindObjectByPostfix("m_BtnAccount", OBJ_BUTTON);
      account_button = ObjectGetString(0, account_button, OBJPROP_TEXT);
      message += account_button;
      string account_value = FindObjectByPostfix("m_EdtAccount", OBJ_EDIT);
      account_value = ObjectGetString(0, account_value, OBJPROP_TEXT);
      message += ": " + account_value + " " + currency + "\n";
      string risk = FindObjectByPostfix("m_EdtRiskMRes", OBJ_EDIT);
      risk = ObjectGetString(0, risk, OBJPROP_TEXT);
      message += "Risk: " + risk + " " + currency + "\n";
      
      message += "Entry: " + DoubleToString(el, _Digits) + "\n";
      if (!DoNotApplyStopLoss) message += "Stop-loss: " + DoubleToString(sl, _Digits) + "\n";
      if ((tp > 0) && (!DoNotApplyTakeProfit)) message += "Take-profit: " + DoubleToString(tp, _Digits);
      if (n > 1) message += " (multiple)";
      message += "\n";
      
      int ret = MessageBox(message, caption, MB_OKCANCEL|MB_ICONWARNING);
      if (ret == IDCANCEL)
      {
         Print("Trade canceled.");
         return;
      }
   }

   double AccumulatedPositionSize = 0; // Total PS used by additional TPs.
   double ArrayPositionSize[]; // PS for each trade.
   ArrayResize(ArrayPositionSize, n);
   
   // Cycle to calculate volume for each partial trade.
   // The goal is to use normal rounded down values for additional TPs and then throw the remainder to the main TP.
   for (int j = n - 1; j >= 0; j--)
   {
      double position_size = PositionSize * ScriptTPShareValue[j] / 100.0;
   
      if (position_size < MinLot) 
      {
         Print("Position size ", position_size, " < broker's minimum position size. Not executing the trade.");
         continue;
      }
      else if (position_size > MaxLot)
      {
         Print("Position size ", position_size, " > broker's maximum position size. Reducing it.");
         position_size = MaxLot;
      }
      double steps = 0;
      if (LotStep != 0) steps = position_size / LotStep;
      if (MathAbs(MathRound(steps) - steps) < 0.00000001) steps = MathRound(steps);
      if (MathFloor(steps) < steps)
      {
         position_size = MathFloor(steps) * LotStep;
         Print("Adjusting position size to the broker's Lot Step parameter.");
      }

      // If this is one of the additional TPs, then count its PS towards total PS that will be open for additional TPs.
      if (j > 0) 
      {
         AccumulatedPositionSize += position_size;
      } 
      else // For the main TP, use the remaining part of the total PS.
      {
         position_size = PositionSize - AccumulatedPositionSize;
      }
      ArrayPositionSize[j] = position_size;
   }
   
   int LotStep_digits = CountDecimalPlaces(LotStep); // Required for proper volume normalization.
   // Going through a cycle to execute multiple TP trades.
   for (int j = 0; j < n; j++)
   {
      double order_sl = sl;
      double order_tp = NormalizeDouble(ScriptTPValue[j], _Digits);
      double position_size = NormalizeDouble(ArrayPositionSize[j], LotStep_digits);
      
      
   	// Market execution mode - preparation.
   	if ((Execution_Mode == SYMBOL_TRADE_EXECUTION_MARKET) && (entry_type == Instant))
   	{
   		// No SL/TP allowed on instant orders.
   		order_sl = 0;
   		order_tp = 0;
   	}
      if (DoNotApplyStopLoss)
      {
         sl = 0;
         order_sl = 0;
      }
      if (DoNotApplyTakeProfit)
      {
         tp = 0;
         order_tp = 0;
      }
   
      ticket = OrderSend(Symbol(), ot, position_size, el, MaxSlippage, order_sl, order_tp, Commentary, MagicNumber);
      if (ticket == -1)
      {
         int error = GetLastError();
         Print("Execution failed. Error: ", IntegerToString(error), " - ", ErrorDescription(error), ".");
      }
      else
      {
         if (n == 1) Print("Order executed. Ticket: ", ticket, ".");
         else Print("Order #", j, " executed. Ticket: ", ticket, ".");
      }
      if (!DoNotApplyTakeProfit) tp = ScriptTPValue[j];
   	// Market execution mode - applying SL/TP.
   	if ((Execution_Mode == SYMBOL_TRADE_EXECUTION_MARKET) && (entry_type == Instant) && (ticket != -1) && ((sl != 0) || (tp != 0)))
   	{
   		if (!OrderSelect(ticket, SELECT_BY_TICKET))
   		{
   			Print("Failed to find the order to apply SL/TP.");
   			return;
   		}
   		for (int i = 0; i < 10; i++)
   		{
   		   bool result = OrderModify(ticket, OrderOpenPrice(), sl, tp, OrderExpiration());
   		   if (result) break;
   		   else Print("Error modifying the order: ", GetLastError());
   		}
   	}
   }
   // **************************************************
   // **** // END OF COPY & PASTE FROM PSC SCRIPT ******
   // **************************************************







   // My Custom Code *** Script modification for Trade.exe starts here
   Sleep(500);
   if (ticket != -1)
      BroadcastMessage(TRADE_OPENED,ticket);
   else
      BroadcastMessage(TRADE_OPEN_FAILED,0);
   // End of my custom code *** Script modification finished here.
   
   
}






// Calculate volume of open positions and/or pending orders.
// Counts volumes separately for buy and sell trades and writes them into parameterss.
void TradeEXE::CalculateOpenVolume(double &volume_buy, double &volume_sell)
{
   int total = OrdersTotal();
   for (int i = 0; i < total; i++)
   {
      // Select an order.
      if (!OrderSelect(i, SELECT_BY_POS)) continue;
      // Skip orders with a different trading instrument.
      if (OrderSymbol() != _Symbol) continue;
      // If magic number is given via PSC panel and order's magic number is different - skip.
      if ((MagicNumber != 0) && (OrderMagicNumber() != MagicNumber)) continue;

      if (SubtractPositions)
      {
         // Buy orders
         if (OrderType() == ORDER_TYPE_BUY) volume_buy += OrderLots();
         // Sell orders
         else if (OrderType() == ORDER_TYPE_SELL) volume_sell += OrderLots();
      }
      if (SubtractPendingOrders)
      {
         // Buy orders
         if ((OrderType() == ORDER_TYPE_BUY_LIMIT) || (OrderType() == ORDER_TYPE_BUY_STOP)) volume_buy += OrderLots();
         // Sell orders
         else if ((OrderType() == ORDER_TYPE_SELL_LIMIT) || (OrderType() == ORDER_TYPE_SELL_STOP)) volume_sell += OrderLots();
      }
   }
}














void TradeEXE::setMinLoss(int ticket) {

   CMetaTrade trade(ticket);
   if (!trade.IsOpenAndActive()) {
      Print(__FUNCTION__ + ": '"+IntegerToString(trade.Ticket)+"' is not open or not active. Cancelling SetMinLoss attempt");
      return;
   }
   
   double sl_size = MathAbs(trade.SL_PP());
   double loss = MathAbs(trade.ProfitPP());
   Print("sl_size = ", DoubleToString(sl_size,1), " pp");
   Print("loss = ", DoubleToString(loss,1));
   Print("0.25*sl_size = ", DoubleToString(0.25*sl_size,1));
   double new_tp;
   
   // ************************************************************************************************
   // *** FIRST - CHECK IF THIS ORDER IS ALREADY NOT IN MIN LOSS MODE
   // *** not trying to move orders into MinLoss twice - may prevent terminal from hanging
   if (trade.TradeType() == OP_BUY) { 
      if (trade.TP() < trade.OpenPrice()) { // Trade is already in Min Loss mode
         Print("Order #" + IntegerToString(trade.Ticket) + " is already in MinLoss mode. Not processing Min Loss request further");
         return; 
      }
   }
   else if (trade.TradeType() == OP_SELL) { 
      if (trade.TP() > trade.OpenPrice()) { // Trade is already in Min Loss mode
         Print("Order #" + IntegerToString(trade.Ticket) + " is already in MinLoss mode. Not processing Min Loss request further");
         return; 
      }
   }
   else return; // this is probably a pending order
   // END OF CHECK
   // ************************************************************************************************
   
   
   // *** this trade is not in Min Loss mode - processing Min Loss request
   // calculating new TP level, depending on how large is current loss
   if (loss > 0.25*sl_size) {
      Print("Loss > 0.25*SL - moving TP to 0.2 from SL (or as per multiplier in settings)");
      if (trade.TradeType() == OP_BUY) 
         new_tp = trade.OpenPrice() - MinLossSize*sl_size*Point;
      else
         new_tp = trade.OpenPrice() + MinLossSize*sl_size*Point;
   }
   else { // loss is less than 0.25*sl_size - set TP half-way between current price and entry price
      Print("Loss <= 0.25*SL - moving TP to 1/2 of loss");
      if (trade.TradeType() == OP_BUY) 
         new_tp = trade.OpenPrice() - (trade.OpenPrice() - Bid) * 0.5;
      else 
         new_tp = trade.OpenPrice() + (Ask - trade.OpenPrice()) * 0.5;
   }
   
   Print("New TP to be set up = ", DoubleToString(new_tp,5));
   
   if (trade.TP() == new_tp) {
      string msg = __FUNCTION__ + ": Attempt to set same TP for order# " + IntegerToString(trade.Ticket) + ". Exiting function";
      MessageOnChart(msg);
      Print(msg);
      return;
   }
   
   int try=0;
   bool MinLossSucceeded = false;
   while(try<5) {
      if( OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),new_tp,0) == false )
        {
         Print(__FUNCTION__ + ": Could NOT move TP to Min Loss. Error #",GetLastError()," on ",Symbol()," type - ",OrderType(),", lot - ",OrderLots());
         MessageOnChart("Could NOT move TP to Min Loss at attempt #" + IntegerToString(try));
         try++;
         Sleep(1000);
        }
      else {
         MinLossSucceeded = true;
         BroadcastMessage(TRADE_TP_MOVED_TO_MINLOSS,OrderTicket());
         Print("TP moved to " + DoubleToString(new_tp,5) + " -%% of the account");
         break;
      }
   }  
   if (!MinLossSucceeded) {
      SendPushAlert("Could NOT move TP->ML"); 
      BroadcastMessage(TRADE_TP_MOVE_TO_MINLOSS_FAILED,OrderTicket());
   }                 
}











bool TradeEXE::setBE(bool RightNow = false)
   // copy & paste from here: http://atsforex.com/советник-автоматический-перевод-орд/#more-3264
   // small modification is done to make this function automonous
  {
   
   int try=0;
   double sl=0;
   //int MN = -1;            // modification from original code
   //bool everyPair=false;   // modification from original code
   for(int i=OrdersTotal()-1; i>=0; i--) {
      //Print("OrderTicket() = ", OrderTicket());
      if(OrderSelect(i,SELECT_BY_POS)==true && OrderSymbol()==Symbol()) {

         if(OrderType()==OP_BUY) {
            if ( (MarketInfo(OrderSymbol(),MODE_BID)-OrderOpenPrice() >= ppBE*(MarketInfo(OrderSymbol(),MODE_POINT))) || RightNow)
              {
              //Print(2);
              sl=OrderOpenPrice();
               if(OrderStopLoss()<sl)
                 {
                  while(try<5)
                    {
                     if( OrderModify(OrderTicket(),OrderOpenPrice(),sl,OrderTakeProfit(),0)==false )
                       {
                        Print(__FUNCTION__ + ": Order Modify error #",GetLastError()," on ",Symbol()," type - ",OrderType(),", lot - ",OrderLots());
                        MessageOnChart("Could NOT move SL to Break Even. Try #" + IntegerToString(try));
                        Sleep(1000);
                        RefreshRates();
                        try++;
                       }
                     else {
                        BroadcastMessage(TRADE_SL_MOVED_TO_BREAKEVEN,OrderTicket());
                        return true;
                     }
                    }
                  try=0;
                 }
              }
            } // OrderType()==OP_BUY
         if(OrderType()==OP_SELL) {
            //if (sets.BreakEvenLevel() != 0 ) ppBE = MarketInfo(OrderSymbol(),MODE_BID)-OrderOpenPrice() * Point * sets.BreakEvenLevel(); // if settings contain value, we take it; My Custom Code
            if( (OrderOpenPrice()-MarketInfo(OrderSymbol(),MODE_ASK)>=ppBE*(MarketInfo(OrderSymbol(),MODE_POINT))) || RightNow)
              {
              // sl=OrderOpenPrice()+MarketInfo(Symbol(),MODE_SPREAD)*MarketInfo(OrderSymbol(),MODE_POINT);
              sl=OrderOpenPrice();
               if(OrderStopLoss()>sl)
                 {
                  while(try<5)
                    {
                     if(OrderModify(OrderTicket(),OrderOpenPrice(),sl,OrderTakeProfit(),0)==false)
                       {
                        Print(__FUNCTION__ + ": Order Modify error #",GetLastError()," on ",Symbol()," type - ",OrderType(),", lot - ",OrderLots());
                        MessageOnChart("Could NOT move SL to Break Even. Try #" + IntegerToString(try));
                        Sleep(1000);
                        RefreshRates();
                        try++;
                       }
                     else {
                        BroadcastMessage(TRADE_SL_MOVED_TO_BREAKEVEN,OrderTicket());
                        return true;
                     }
                    }
                  try=0;
                 }
              }
            } // OrderType()==OP_SELL
        }
   } // for through all the orders
  return false;
  } // setBE 
  
  




