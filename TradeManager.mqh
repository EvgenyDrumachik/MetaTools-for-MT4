#property strict
#include "TradesArray.mqh"
#include "AutoEntryControl.mqh"
#include "TradeLine.mqh"

class CTradeManager
  {
private:

   // *** STATUS FLAGS ***
   bool     m_TradeEXE_Alive;
   void     UpdateOrderTypeButton();
   void     HideAutoDeleteLimitOnTimerControls();

public:
                     CTradeManager();
                    ~CTradeManager();
   CTradesArray      TradesArray;     // Array of all open orders for this chart
   void              InitControls();
   
   CTradeLine        StopLossLine;
   CTradeLine        TakeProfitLine;
   CTradeLine        EntryLine;
   
   void              OnTrade();
   
   // *** STATUS FLAGS ***
   void     TradeEXE_Alive(bool alive);
   bool     TradeEXE_Alive();
   
   // *** TRADE MANAGER CONTROLS ***
   CButton              TM_Trade_Button;
   CButton              TM_BE_ML_Button;
   CButton              TM_Set_BE_BB_Level_Button;
   CButton              TM_AutoEntry_Button;
   CButton              TM_OrderType_Button;
   CButton              TM_NoBE_Button;
   CLabel               TM_RewardPercent_Label;
   CLabel               TM_StatusLED_Label;
   CLabel               TM_RiskPercent_Label;
   CLabel               TM_OrderExecutionResultLabel;
   CAutoEntryControl    AutoEntryControl;
   bool                 TradeLinesVisible;
   void                 HidePSC();
   void                 PSC_Show_Lines(bool show = true);
   void                 TM_Trade_Button_Click();
   // Auto Delete Limit on Timer
   CButton              TM_AutoDeleteLimitOnTimer_Button;
   CButton              TM_AutoDeleteLimitOnTimerMore_Button;
   CButton              TM_AutoDeleteLimitOnTimerLess_Button;
   void                 UpdateAutoDeleteLimitOnTimerControls();
   bool                 Delete_Limit_Order_On_Timer();
   void                 DisplayDistanceEntryLineToClosestLevel();
   void                 DisplayDistanceToClosestLevel();
   void                 ClosestLevel(double &distance, CLevel &Closest_Level);
   
   // *** Four Strings ***
   CButton              FourStrings_AutoMode_Button;   
   CButton              FourStrings_Fibo_Button;
   CButton              FourStrings_Orders_Button;  
   bool                 FourStrings_FiboSetup();   
   double               FourStrings_EntryPrices[4];  
   void                 FourStrings_OpenOrders(); 
   TradeDir             FourStrings_TradeDirection();
   bool                 FourStrings_SetEntryPrices();
   double               FourStrings_Trade_BE_Price(ulong Trade_Ticket, CFibo &BigFibo);
   void                 FourStrings_OnCalculate();
   void                 FourStrings_OnNewDay();
   CButton              BodyLevels_Button;
   bool                 Show_BodyLevels_Button();
   void                 ShowHideBodyLevelsButton(); 
   bool                 ToggleBodyLevels(StrategyID strategy, ENUM_TIMEFRAMES period, int first_bar, DayPriorityID DayPrio);
   void                 FourStrings_ExtendD1Levels();
   string               FourStrings_IsSignalOnD1Yesterday();
   // -- Four Strings --
   

   // *** Update Trade Manager Controls ***   
   void     UpdateTradeManagerStatusLED();
   void     UpdatePosOfBreakEvenControls(double break_even_price);
   void     UpdatePosOfTradeManager();
   void     UpdatePosVizOfTradeManager();
   void     UpdateTextOnTradeManagerUI();
   double   GetSpread();
   string   GetSpreadString(double spread);
   
   // ***   SL Range Rectangle ****
   void     UpdateVisPosOfRecommendedSLRange();
   string   SL_RangeRectName;
   string   SL_RangeUpperHLINE;
   string   SL_RangeLowerHLINE;
   void     RemoveSLRangeControls();
   string   MinSLSize_Label_Name;
   string   MaxSLSize_Label_Name;
   

   void     HideTradeManagerButtons();
   void     OnClick(string sparam);
   string   Order_Type();                 // can be Instant or Pending
   string   Order_Type_Short();           // can be M (Market() or P (Pending)
   void     Order_Type(string new_type);  // can be Instant or Pending
   TradeDir TradeDirection();             // Can be TradeDir_BUY | TradeDir_SELL | TradeDir_NONE - depending on the mutual position of EntryLine and StopLossLine

   void     ProcessBroadcastEvents(int id, long lparam);
   void     OnTick();

   // *** TRADE PREP ***
   void     ToggleBreakEvenControls(bool show, ulong ticket);
   void     ToggleBackwardsBreakControls(bool show, ulong ticket);
   double   RRR_From_Lines_Position();

   // *** TRADE LINES MANAGEMENT
   void     UpdateTradeLinesVisibleValue();
   void     SelectTradeLines(bool select);
   void     CheckAndUpdateTP(bool b_TradeLinesVisible);
   void     UpdatePosOfBackwardsBreakControls(double backwards_break_price);
   double   GetClosestLevelPriceSameDirection(CLevel &levels[], bool offset = false);  // for a trade that is being prepared
   double   GetClosestLevelPriceSameDirection(CLevel &levels[], ulong ticket);         // for already opened trade
   void     AlignTradeLines();
   
   
   
   // *** THICKNESS OF SPREAD FOR STOP LOSS
   public:
      void     UpdateSpreadThicknessOf_SL_and_TP();
      void     UpdateSpreadThicknessOfEntryLine();
      
   private:
      void     DeleteSpreadThicknessLines();
      string   m_SpreadThicknessLineName_TP;
      string   m_SpreadThicknessLineName_SL;
      string   m_SpreadThicknessLineName_Entry;
      bool     m_CreateSpreadThicknessLine(string name, double price1, color clr);
      bool     CTradeManager::PriceWasBelowLevelToday(double level, int today_bar_index, int H1_bar);
      bool     CTradeManager::PriceWasAboveLevelToday(double level, int today_bar_index, int H1_bar);
   // ********************************************
   
   
   
   // *** TRADE OPERATIONS ***
   public:
      bool     SendOpenTradeCommand(string comment = "");
      void     AutoEntryOnBarClose();
      void     Delete_Limit_Order_if_BE_Level_Is_Reached();
      void     ProcessBackwardsBreak();
      void     AlertOnPossibleThreateningBar(double ATR);
      bool     MoveSLtoEntry(ulong ticket);
      bool     MoveTPtoML(ulong ticket);
      bool     CloseTrade(ulong ticket);
      void     InformAboutOpenTradesForAllCharts();
      void     ToggleOrderType();
   
   // *** AFTER TRADE IS OPEN ***
   public:
      void     DrawEntryMarks(int ticket);
      void     Draw_Entry_Mark(string MarkType, ulong Ticket, double Price, color Clr, string LabelText = "", bool draw_label = true);
      void     DrawEntryParameters(ulong ticket);
      void     ShowSLinMoney();
      void     Set_BE_BB_Level_Button_Click();
      void     TM_NoBE_Button_Click();
      void     Set_BE_Level_Button_Click();               // setting up BE level
      void     Set_BB_Level_Button_Click();               // setting up BB level
      void     Highlight_Entry_Bar(int ticket);           // highlighting previous H1-bar
   
   
   // *****   ATR  Range  *****
   public: 
      void     UpdateATRRange(int x = 0, int y = 0);
      
   private:
      double   DayMinBeforeH1Bar(int H1barIndex);
      double   DayMaxBeforeH1Bar(int H1barIndex);
      string   ATR_Range_Upper_LimitRECT_Name;
      string   ATR_Range_Upper_100_LimitLINE_Name;
      string   ATR_Range_Lower_LimitRECT_Name;
      string   ATR_Range_Lower_100_LimitLINE_Name;
   
      string   Spread_Label_Name;
      
   // ******   Simulator Mode Methods ********
   public:
      void     UpdateVisOfSimulatorLines();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

CTradeManager::CTradeManager()
  {
   
   this.m_TradeEXE_Alive = false;
   this.TradeLinesVisible = false;
   
   this.Spread_Label_Name = "Spread Label";
   
   this.m_SpreadThicknessLineName_TP = "Spread Thickness TP";
   this.m_SpreadThicknessLineName_SL = "Spread Thickness SL";
   this.m_SpreadThicknessLineName_Entry = "Spread Thickness Entry";
   
   // taking names from global variable (from Common)
   if (SimulatorMode) { // redefining line names, if Forex Simulator is used.
      StopLossLineName = "sim#3d_visual_sl";
      TakeProfitLineName = "sim#3d_visual_tp";
      EntryLineName = "sim#3d_visual_ap";
   }
   this.StopLossLine.Name     = StopLossLineName; 
   this.TakeProfitLine.Name   = TakeProfitLineName;
   this.EntryLine.Name        = EntryLineName;
   this.SL_RangeRectName      = "Rect_SL_Range";
   this.SL_RangeUpperHLINE    = "SL_RangeUpperHLINE";
   this.SL_RangeLowerHLINE    = "SL_RangeLowerHLINE";
   this.MinSLSize_Label_Name  = "MinSLSize_Label";
   this.MaxSLSize_Label_Name  = "MaxSLSize_Label";
   
   this.ATR_Range_Upper_LimitRECT_Name      = "ATR_Range_Upper_LimitRECT_Name";
   this.ATR_Range_Upper_100_LimitLINE_Name     = "ATR_Range_Upper_100_LimitLINE_Name";
   this.ATR_Range_Lower_LimitRECT_Name      = "ATR_Range_Lower_LimitRECT_Name";
   this.ATR_Range_Lower_100_LimitLINE_Name     = "ATR_Range_Lower_100_LimitLINE_Name";
  }
  
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTradeManager::~CTradeManager()
  {
  
   this.TM_OrderType_Button.Destroy();
   this.TM_BE_ML_Button.Destroy();
   this.TM_Trade_Button.Destroy();
   this.TM_Set_BE_BB_Level_Button.Destroy();
   this.TM_NoBE_Button.Destroy();
   this.TM_RewardPercent_Label.Destroy();
   this.TM_StatusLED_Label.Destroy();
   this.TM_AutoEntry_Button.Destroy();
   this.TM_RiskPercent_Label.Destroy();
   this.TM_OrderExecutionResultLabel.Destroy();
   this.TM_AutoDeleteLimitOnTimer_Button.Destroy();
   this.TM_AutoDeleteLimitOnTimerMore_Button.Destroy();
   this.TM_AutoDeleteLimitOnTimerLess_Button.Destroy();
   this.FourStrings_AutoMode_Button.Destroy();
   this.BodyLevels_Button.Destroy();
   this.FourStrings_Fibo_Button.Destroy();
   this.FourStrings_Orders_Button.Destroy();
  
  }
//+------------------------------------------------------------------+


void CTradeManager::InitControls(void){
   // *** INITIALIZING CONTROLS ***
   TM_Trade_Button.Create(0,"TM_Trade_Button",0,0,0,60,20);
   TM_Trade_Button.Text("Buy / Sell");
   TM_Trade_Button.Font("Calibri Bold");
   TM_Trade_Button.FontSize(8);
   TM_Trade_Button.Color(clrWhite);
   TM_Trade_Button.ColorBackground(clrRed);
   TM_Trade_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"TM_Trade_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"TM_Trade_Button",OBJPROP_TOOLTIP,"Open Trade");
   TM_Trade_Button.Hide();
   
   TM_BE_ML_Button.Create(0,"TM_BE_ML_Button",0,0,0,50,20);
   TM_BE_ML_Button.Text("BE_ML_Button");
   TM_BE_ML_Button.Font("Calibri Bold");
   TM_BE_ML_Button.FontSize(8);
   TM_BE_ML_Button.Color(clrBlack);
   TM_BE_ML_Button.ColorBackground(clrKhaki);
   TM_BE_ML_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"TM_BE_ML_Button",OBJPROP_ZORDER,100);
   //ObjectSetString(ChartID(),"TM_BE_ML_Button",OBJPROP_TOOLTIP,"Break Even or Min Loss");
   TM_BE_ML_Button.Hide();
   
   
   TM_Set_BE_BB_Level_Button.Create(0,"TM_Set_BE_BB_Level_Button",0,0,0,75,20);
   TM_Set_BE_BB_Level_Button.Text("BE");
   TM_Set_BE_BB_Level_Button.Font("Calibri");
   TM_Set_BE_BB_Level_Button.FontSize(8);
   TM_Set_BE_BB_Level_Button.Color(clrBlack);
   TM_Set_BE_BB_Level_Button.ColorBackground(clrKhaki);
   TM_Set_BE_BB_Level_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"TM_Set_BE_BB_Level_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"TM_Set_BE_BB_Level_Button",OBJPROP_TOOLTIP,"Set Break Even Level");
   TM_Set_BE_BB_Level_Button.Hide(); 
   
   TM_AutoEntry_Button.Create(0,"TM_AutoEntry_Button",0,0,0,20,20);
   TM_AutoEntry_Button.Text("A");
   TM_AutoEntry_Button.Font("Calibri");
   TM_AutoEntry_Button.FontSize(8);
   TM_AutoEntry_Button.Color(clrBlack);
   TM_AutoEntry_Button.ColorBackground(clrKhaki);
   TM_AutoEntry_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"TM_AutoEntry_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"TM_AutoEntry_Button",OBJPROP_TOOLTIP,"Auto Entry on Bar Close");
   TM_AutoEntry_Button.Hide(); 
   
   // Trade Manager
   TM_RewardPercent_Label.Create(0,"TM_RewardPercent_Label",0,0,0,250,20);
   TM_RewardPercent_Label.FontSize(8);
   TM_RewardPercent_Label.Color(this.TakeProfitLine.Color());
   ObjectSetString(ChartID(),"TM_RewardPercent_Label",OBJPROP_TOOLTIP,"Reward");
   TM_RewardPercent_Label.Hide();
   
   TM_RiskPercent_Label.Create(0,"TM_RiskPercent_Label",0,0,0,250,20);
   TM_RiskPercent_Label.FontSize(8);
   TM_RiskPercent_Label.Color(this.StopLossLine.Color());
   ObjectSetString(ChartID(),"TM_RiskPercent_Label",OBJPROP_TOOLTIP,"Risk");
   TM_RiskPercent_Label.Hide();
   
   
   TM_StatusLED_Label.Create(0,"TM_StatusLED_Label",0,0,0,50,20);
   TM_StatusLED_Label.FontSize(15);
   TM_StatusLED_Label.Color(clrGray);
   TM_StatusLED_Label.Font("Wingdings");
   TM_StatusLED_Label.Text(CharToString(139));
   ObjectSetString(ChartID(),"TM_StatusLED_Label",OBJPROP_TOOLTIP,"'Trade.exe' Status");
   TM_StatusLED_Label.Hide();
   
   TM_OrderExecutionResultLabel.Create(0,"TM_OrderExecutionResultLabel",0,0,0,250,20);
   TM_OrderExecutionResultLabel.FontSize(8);
   TM_OrderExecutionResultLabel.Font("Calibri Bold");
   ObjectSetString(ChartID(),"TM_OrderExecutionResultLabel",OBJPROP_TOOLTIP,"Order Execution Result");
   TM_OrderExecutionResultLabel.Hide();

   TM_OrderType_Button.Create(0,"TM_OrderType_Button",0,0,0,20,20);
   TM_OrderType_Button.Text("M / P");
   TM_OrderType_Button.Font("Calibri");
   TM_OrderType_Button.FontSize(8);
   TM_OrderType_Button.Color(clrBlack);
   TM_OrderType_Button.ColorBackground(clrKhaki);
   TM_OrderType_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"TM_OrderType_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"TM_OrderType_Button",OBJPROP_TOOLTIP,"M - Market / P - Pending Order");
   TM_OrderType_Button.Hide();
   
   
   TM_NoBE_Button.Create(0,"TM_NoBE_Button",0,0,0,100,20);
   TM_NoBE_Button.Text("No BE btw...");
   TM_NoBE_Button.Font("Calibri");
   TM_NoBE_Button.FontSize(8);
   TM_NoBE_Button.Color(clrBlack);
   TM_NoBE_Button.ColorBackground(clrKhaki);
   TM_NoBE_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"TM_NoBE_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"TM_NoBE_Button",OBJPROP_TOOLTIP,"No Break Even around midnight");
   TM_NoBE_Button.Hide();
   if (sets.NoBEAroundMidnight()) {
      TM_NoBE_Button.Font("Calibri Bold");
      TM_NoBE_Button.Color(clrWhite);
      TM_NoBE_Button.ColorBackground(clrGreen);
   }
   else {
      TM_NoBE_Button.Font("Calibri");
      TM_NoBE_Button.Color(clrBlack);
      TM_NoBE_Button.ColorBackground(clrKhaki);
   }
   
   // Auto Delete Limit on Timer
   TM_AutoDeleteLimitOnTimer_Button.Create(0,"TM_AutoDeleteLimitOnTimer_Button",0,0,0,70,20);
   
   TM_AutoDeleteLimitOnTimer_Button.Font("Calibri");
   TM_AutoDeleteLimitOnTimer_Button.Text("Delete After");
   TM_AutoDeleteLimitOnTimer_Button.FontSize(10);
   TM_AutoDeleteLimitOnTimer_Button.Color(clrBlack);
   TM_AutoDeleteLimitOnTimer_Button.ColorBackground(clrKhaki);
   TM_AutoDeleteLimitOnTimer_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"TM_AutoDeleteLimitOnTimer_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"TM_AutoDeleteLimitOnTimer_Button",OBJPROP_TOOLTIP,"Auto Delete Limit On Timer Expiration");
   TM_AutoDeleteLimitOnTimer_Button.Hide();
   if (sets.AutoDeleteLimitOnTimer)
      HighlightButton(TM_AutoDeleteLimitOnTimer_Button,true,false,clrRed);
   else
      HighlightButton(TM_AutoDeleteLimitOnTimer_Button,false);
   if (sets.AutoDeleteLimitOnTimerAt > TimeCurrent()) {
      datetime TimeLeft = sets.AutoDeleteLimitOnTimerAt - TimeCurrent();
      TM_AutoDeleteLimitOnTimer_Button.Text(TimeToString(TimeLeft,TIME_SECONDS));
   }
      
      
   
   TM_AutoDeleteLimitOnTimerMore_Button.Create(0,"TM_AutoDeleteLimitOnTimerMore_Button",0,0,0,20,20);
   TM_AutoDeleteLimitOnTimerMore_Button.Text(">");
   TM_AutoDeleteLimitOnTimerMore_Button.Font("Calibri");
   TM_AutoDeleteLimitOnTimerMore_Button.FontSize(10);
   TM_AutoDeleteLimitOnTimerMore_Button.Color(clrBlack);
   TM_AutoDeleteLimitOnTimerMore_Button.ColorBackground(clrKhaki);
   TM_AutoDeleteLimitOnTimerMore_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"TM_AutoDeleteLimitOnTimerMore_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"TM_AutoDeleteLimitOnTimerMore_Button",OBJPROP_TOOLTIP,"Increase Time");
   TM_AutoDeleteLimitOnTimerMore_Button.Hide();
   
   TM_AutoDeleteLimitOnTimerLess_Button.Create(0,"TM_AutoDeleteLimitOnTimerLess_Button",0,0,0,20,20);
   TM_AutoDeleteLimitOnTimerLess_Button.Text("<");
   TM_AutoDeleteLimitOnTimerLess_Button.Font("Calibri");
   TM_AutoDeleteLimitOnTimerLess_Button.FontSize(10);
   TM_AutoDeleteLimitOnTimerLess_Button.Color(clrBlack);
   TM_AutoDeleteLimitOnTimerLess_Button.ColorBackground(clrKhaki);
   TM_AutoDeleteLimitOnTimerLess_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"TM_AutoDeleteLimitOnTimerLess_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"TM_AutoDeleteLimitOnTimerLess_Button",OBJPROP_TOOLTIP,"Decrease Time");
   TM_AutoDeleteLimitOnTimerLess_Button.Hide();
   
   if (Strategy == FourStrings) {
      FourStrings_AutoMode_Button.Create(0,"FourStrings_AutoMode_Button",0,0,0,110,20);
      FourStrings_AutoMode_Button.Text("4 Strings Auto");
      FourStrings_AutoMode_Button.Font("Calibri");
      FourStrings_AutoMode_Button.FontSize(10);
      FourStrings_AutoMode_Button.Color(clrBlack);
      FourStrings_AutoMode_Button.ColorBackground(clrKhaki);
      FourStrings_AutoMode_Button.ColorBorder(clrBlack);
      ObjectSetInteger(0,"FourStrings_AutoMode_Button",OBJPROP_ZORDER,100);
      ObjectSetString(ChartID(),"FourStrings_AutoMode_Button",OBJPROP_TOOLTIP,"'Four Strings' Auto Mode");
      TM_AutoDeleteLimitOnTimerLess_Button.Hide();
      if (sets.FourStringsAutoMode) {
         HighlightButton(FourStrings_AutoMode_Button,true,false,clrRed);
      }
      else {
         HighlightButton(FourStrings_AutoMode_Button,false,false,clrRed);
      }
      
      
      FourStrings_Fibo_Button.Create(0,"FourStrings_Fibo_Button",0,0,0,52,20);
      FourStrings_Fibo_Button.Text("Fibo");
      FourStrings_Fibo_Button.Font("Calibri");
      FourStrings_Fibo_Button.FontSize(10);
      FourStrings_Fibo_Button.Color(clrBlack);
      FourStrings_Fibo_Button.ColorBackground(clrKhaki);
      FourStrings_Fibo_Button.ColorBorder(clrBlack);
      ObjectSetInteger(0,"FourStrings_Fibo_Button",OBJPROP_ZORDER,100);
      ObjectSetString(ChartID(),"FourStrings_Fibo_Button",OBJPROP_TOOLTIP,"Create 'Four Strings' Fibo's");
      FourStrings_Fibo_Button.Hide();
    
      FourStrings_Orders_Button.Create(0,"FourStrings_Orders_Button",0,0,0,52,20);
      FourStrings_Orders_Button.Text("Orders");
      FourStrings_Orders_Button.Font("Calibri");
      FourStrings_Orders_Button.FontSize(10);
      FourStrings_Orders_Button.Color(clrBlack);
      FourStrings_Orders_Button.ColorBackground(clrKhaki);
      FourStrings_Orders_Button.ColorBorder(clrBlack);
      ObjectSetInteger(0,"FourStrings_Orders_Button",OBJPROP_ZORDER,100);
      ObjectSetString(ChartID(),"FourStrings_Orders_Button",OBJPROP_TOOLTIP,"Setup 'Four Strings' Limit Orders");
      FourStrings_Orders_Button.Hide();
   }
   
   

   if (this.Show_BodyLevels_Button()) {
      BodyLevels_Button.Create(0,"BodyLevels_Button",0,0,0,75,20);
      BodyLevels_Button.Text("Body Levels");
      BodyLevels_Button.Font("Calibri");
      BodyLevels_Button.FontSize(10);
      BodyLevels_Button.Color(clrBlack);
      BodyLevels_Button.ColorBackground(clrKhaki);
      BodyLevels_Button.ColorBorder(clrBlack);
      ObjectSetInteger(0,"BodyLevels_Button",OBJPROP_ZORDER,100);
      ObjectSetString(ChartID(),"BodyLevels_Button",OBJPROP_TOOLTIP,"Create / Remove Body Levels");
      BodyLevels_Button.Hide();
   }
   
}




bool CTradeManager::Show_BodyLevels_Button() {
   // conditions for BodyLevels_Button initialization and display
   if (Strategy == D1 && _Period == PERIOD_H1) return true;
   if (Strategy == FourStrings && _Period == PERIOD_D1) return true;
   //if (Strategy == S3 && _Period == PERIOD_H4) return true;
   //if (Strategy == BF && Period() != PERIOD_H1 && Period() != PERIOD_H4) return true;
   if (Strategy == Other) return false;
   
   return false;
}






void CTradeManager::Delete_Limit_Order_if_BE_Level_Is_Reached() {

   if (Strategy == FourStrings) return;
   if (!DeletePendingOrderWhenBEReached) return;
   if (OrdersTotal() < 1) return;
   int TradesCount = this.TradesArray.TradesCount(); // total orders count on this symbol; needed for further 'for' cycle later in this method
   int limit_trades_count = TradesArray.LimitTradesCountOnSymbol(Symbol());
   if (limit_trades_count < 1) return;
   if (limit_trades_count > 1) {
      MessageOnChart(">1 limit orders: orders will NOT be auto-deleted!", MessageOnChartAppearTime);
      return;
   }
   
   // deleting pending orders, where price has already reached break even level
   double be_level = sets.BreakEvenLevel();
   
   for (int i = TradesCount-1; i >= 0; i--) {
      if (TradesArray.Trades[i].TradeStrategy() == FourStrings) continue;
      if (TradesArray.Trades[i].IsLimitOrder() && TradesArray.Trades[i].TradeSymbol() == Symbol() && TradesArray.Trades[i].IsLimitOrderWith_BE_LevelReached(be_level)) {
         MessageOnChart("Break even level reached - closing limit order #" + IntegerToString(TradesArray.Trades[i].Ticket) + ".", MessageOnChartAppearTime);
         Print("Break even level (" + DoubleToString(sets.BreakEvenLevel(),5) + ") is reached - deleting pending order# " + IntegerToString(TradesArray.Trades[i].Ticket));
         if (!EventChartCustom(ChartID(),TRADE_CLOSE_COMMAND,TradesArray.Trades[i].Ticket,0,""))  {
            Print("Couldn't send custom event 'TRADE_CLOSE_COMMAND'");
            Current_H1_Bar.BarInfoIcon(159,clrRed,"BE reached, but could NOT send closing command for Limit Order");
         }
         else {
            Print("'TRADE_CLOSE_COMMAND' is sent");
            Current_H1_Bar.BarInfoIcon(251,clrRed,"BE reached, deleting Limit Order...");
         }
         return; // necessary (matching) order has been found - existing the function;
      }
   }
}










void CTradeManager::ShowSLinMoney() {
   if (OrdersTotal() == 0) return;
      
   string label_name = "SL_in_Money_Label";
   string msg;
   
   int order_index = TradesArray.LastOrderOnSymbol_index(Symbol());
   string currency;
   if (AccountInfoString(ACCOUNT_CURRENCY) == "USD") currency = "$";
   else if (AccountInfoString(ACCOUNT_CURRENCY) == "EUR") currency = "€";
   
   msg = "SL=" + currency + "" + DoubleToString(TradesArray.Trades[order_index].SL_Money(),0);
   
   ObjectDeleteSilent(label_name);
   datetime time = TimeCurrent();
   double price = TradesArray.Trades[order_index].SL();
   ObjectCreate(0,label_name,OBJ_TEXT,0,time,price);
   ObjectSetInteger(0,label_name,OBJPROP_ANCHOR,ANCHOR_LEFT_LOWER);
   ObjectSetMQL4(label_name,OBJPROP_CORNER,0);
   ObjectSetMQL4(label_name,OBJPROP_XDISTANCE,0);
   ObjectSetMQL4(label_name,OBJPROP_YDISTANCE,ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0));
   ObjectSetInteger(0,label_name,OBJPROP_SELECTABLE,true);
   ObjectSetInteger(0,label_name,OBJPROP_BACK,true);
   ObjectSetTextMQL4(label_name,msg,10,"verdana",this.StopLossLine.Color()); 
   ObjectSetInteger(0,label_name,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1);
   ObjectSetString(0,label_name,OBJPROP_TOOLTIP,"Click to delete");  
}





void CTradeManager::UpdateTradeManagerStatusLED() {
   //Print(__FUNCTION__);

   // -----------------------------------------
   // update status icon of the trade manager
   // -----------------------------------------
   uchar character = 0;
   uchar trades_count = (uchar)TradesArray.TradesOpenOnChart(ChartID());
   //Print("trades_count = ", trades_count);
   
   if      (trades_count == 0)  character = 139;
   else if (trades_count == 1)  character = 140;
   else if (trades_count == 2)  character = 141;
   else if (trades_count == 3)  character = 142;
   else if (trades_count == 4)  character = 143;
   else if (trades_count == 5)  character = 144;
   else if (trades_count == 6)  character = 145;
   else if (trades_count == 7)  character = 146;
   else if (trades_count == 8)  character = 147;
   else if (trades_count == 9)  character = 148;
   else if (trades_count == 10) character = 149;
   else                         character = 108;
  
   TM_StatusLED_Label.Text(CharToString(character));
   string status;
   bool   b_status = true;
   
   if (trades_count > 0) status = "Trades Open: " + IntegerToString(trades_count) + "\n";
   
   if (this.m_TradeEXE_Alive) status = status + "Trade.exe Alive" + "\n";
   else {
      status = "Trade.exe is not attached to the chart" + "\n";
      b_status = false;
   }
   
   if (TerminalInfoInteger(TERMINAL_CONNECTED)) status = status + "Connected to server" + "\n";
   else {
      status = status + "Not connected to server" + "\n";
      b_status = false;
   }

   if (TradeAllowed) status = status + "Trading Allowed" + "\n";
   else {
      status = status + "Trading NOT Allowed" + "\n";
      b_status = false;
   }
   
   int i_today = TimeDayOfWeekMQL4(TimeLocal());
   if (i_today == 6 || i_today == 0) { // Check if Saturday or Sunday
      status = status + "Weekend - no trading";
      b_status = false;
   }
   else 
      status = status + "Working Day";   
      

   if (b_status) 
      TM_StatusLED_Label.Color(clrGreen);
   else
      TM_StatusLED_Label.Color(clrGray);    

   ObjectSetString(ChartID(),"TM_StatusLED_Label",OBJPROP_TOOLTIP,status);
   // -----------------------------------------
   // update status icon of the trade manager
   // -----------------------------------------

}




void CTradeManager::UpdatePosOfBackwardsBreakControls(double backwards_break_price) {
   // align position of the Backwards Break Button to BackwardsBreakLine and Show it
   datetime TimePosition;
   int i_today = TimeDayOfWeekMQL4(TimeLocal());
   if(i_today==6 || i_today==0) {// in case today is Saturday or Sunday
      TimePosition = StringToTime(string(Today() + HR2400*2)+"00:00"); // next Monday
      MessageOnChart("No trading on weekends", MessageOnChartAppearTime);
   }
   else // for all other days of the week
      TimePosition = Tomorrow();
   
   
   CMetaTrade trade(TradesArray.LastOrderOnSymbol_Ticket(Symbol())); // latest created order on this symbol
   CTradeLine bb_line(BackwardsBreakLineName);
   
  
   // convert time and price coordinates to x, y
   int x1,y1;
   ChartTimePriceToXY(0,0,TimePosition, backwards_break_price,x1,y1);
   TM_Set_BE_BB_Level_Button.Move(x1+10,y1+10);
   
   
   double BB_distance = MathAbs(backwards_break_price - trade.OpenPrice()) / _Point / 10;
   if (isCRYPTO()) BB_distance = BB_distance / 10;
   if (isOIL())    BB_distance = BB_distance * 10;
   
   string s_BB_distance = DoubleToString(BB_distance,0);
   if (BB_distance < 10) s_BB_distance = DoubleToString(BB_distance,1);
   
   
   TM_Set_BE_BB_Level_Button.Text("Set BB: " + s_BB_distance + "pp");
   TM_Set_BE_BB_Level_Button.ColorBackground(clrPink);
} 




void CTradeManager::UpdatePosOfBreakEvenControls(double break_even_price) {
   // align position of the Break Even Button to break_even_price and Show it
   datetime TimePosition;
   int i_today = TimeDayOfWeekMQL4(TimeLocal());
   if(i_today==6 || i_today==0) {// in case today is Saturday or Sunday
      TimePosition = StringToTime(string(Today() + HR2400*2)+"00:00"); // next Monday
      MessageOnChart("No trading on weekends", MessageOnChartAppearTime);
   }
   else // for all other days of the week
      TimePosition = Tomorrow();
   
   
   CMetaTrade trade(TradesArray.LastOrderOnSymbol_Ticket(Symbol())); // latest created order on this symbol
   CTradeLine be_line(BreakEvenLineName);
   
   // check if Break Even Line is positioned on the right side from entry line
   if (trade.TradeType() == OP_BUY || trade.TradeType() == OP_BUYLIMIT || trade.TradeType() == OP_BUYSTOP) { 
      // some kind of buy trade
      if (break_even_price <= trade.OpenPrice() || break_even_price >= trade.TP()) {
         // move line to the correct side from the entry line
         break_even_price = trade.GetBreakEvenPrice();
         be_line.Price1(break_even_price);
      }
   }
   else { 
      // some kind of sell trade 
      if (break_even_price >= trade.OpenPrice() || break_even_price <= trade.TP()) {
         // move line to the correct side from the entry line
         break_even_price = trade.GetBreakEvenPrice();
         be_line.Price1(break_even_price);
      }      
   }
   
   // convert time and price coordinates to x, y
   int x1,y1;
   ChartTimePriceToXY(0,0,TimePosition, break_even_price,x1,y1);
   TM_Set_BE_BB_Level_Button.Move(x1+10,y1+10);
   
   
   double be_distance = MathAbs(break_even_price - trade.OpenPrice()) / _Point / 10;
   
   if (isCRYPTO()) be_distance = be_distance / 10;
   if (isOIL())    be_distance = be_distance * 10;
   
   TM_Set_BE_BB_Level_Button.Text("Set BE: " + DoubleToString(be_distance,0) + "pp");
   TM_Set_BE_BB_Level_Button.ColorBackground(clrLawnGreen);
   
}




void CTradeManager::UpdatePosOfTradeManager() {
  
   datetime TimePosition;
   int i_today = TimeDayOfWeekMQL4(TimeLocal());
   if(i_today==6 || i_today==0) // in case today is Saturday or Sunday
      TimePosition = StringToTime(string(Today() + HR2400*2)+"00:00"); // next Monday
   else { // for all other days of the week
      if (Period() == PERIOD_H1 || Period() == PERIOD_M30)
         TimePosition = Tomorrow() + 6000;
      else if ( Period() == PERIOD_H4 )
         TimePosition = Tomorrow()+HR2400*2;
      else if ( Period() == PERIOD_D1 )
         TimePosition = Tomorrow()+HR2400*10;
      else if ( Period() == PERIOD_M15 )
         TimePosition = TimeCurrent() + HR1*7;
      else if ( Period() == PERIOD_M5 )
         TimePosition = TimeCurrent() + HR1*2;
      else if ( Period() == PERIOD_M1 )
         TimePosition = TimeCurrent() + HR1/2;
      else if ( Period() == PERIOD_W1 || Period() == PERIOD_MN1 )
         TimePosition = TimeCurrent() + HR2400*100;
      else
         TimePosition = Tomorrow()+HR2400/2;
   }
   
   int x1,y1;
   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(_Symbol, Latest_Price); // Assign current prices to structure 
   
   double position_price = Latest_Price.ask;
   int order_type = 0;
   CTradeLine SL_Line(StopLossLineName);
   CTradeLine Entry_Line(EntryLineName);
   
   if (TradesArray.TradesOpenOnChart(ChartID()) > 0) {
      // there are already open trades on this chart
      CMetaTrade trade(TradesArray.LastOrderOnSymbol_Ticket(Symbol()));
      order_type = trade.TradeType();
      
      position_price = SL_Line.Price();
      //if (order_type == OP_BUY || order_type == OP_BUYLIMIT || order_type == OP_BUYSTOP)
      //   //position_price = MathMax(Ask,trade.OpenPrice());
      //   position_price = SL_Line.Price();
      //else
      //   //position_price = MathMin(Bid,trade.OpenPrice());
      //   position_price = SL_Line.Price();
   }
   else if (this.TradeLinesVisible) { // lines are visible - connecting controls to StopLossLine
         position_price = SL_Line.Price();
   }
   
   ChartTimePriceToXY(0,0,TimePosition, position_price,x1,y1);
   if (SL_Line.Price() <= Entry_Line.Price()) {
      // for buy setup
      TM_Trade_Button.Move(x1+65,y1+40);
      TM_AutoEntry_Button.Move(x1+155,y1+40);
      TM_OrderType_Button.Move(x1+130,y1+40);
      TM_StatusLED_Label.Move(x1,y1+35);
      FourStrings_AutoMode_Button.Move(x1+65,y1+65);
      FourStrings_Fibo_Button.Move(x1+65,y1+90);
      FourStrings_Orders_Button.Move(x1+123,y1+90);     
   }
   else {
      // for sell setup
      TM_Trade_Button.Move(x1+65,y1-40);
      TM_AutoEntry_Button.Move(x1+155,y1-40);
      TM_OrderType_Button.Move(x1+130,y1-40);
      TM_StatusLED_Label.Move(x1,y1-35);
      FourStrings_AutoMode_Button.Move(x1+65,y1-65);
      FourStrings_Fibo_Button.Move(x1+65,y1-90);
      FourStrings_Orders_Button.Move(x1+123,y1-90);  
   }
   
   
   // positioning BE/ML button higher or lower both the entry and price to make sure it is not overlayed on top of any of them
   if (order_type == OP_BUY || order_type == OP_BUYLIMIT || order_type == OP_BUYSTOP) {
      TM_BE_ML_Button.Move(x1 + 30,y1-30);
      // TM_NoBE_Button.Move(x1 + 85, y1-30); // -> moved to Meta Tools Init file -> UpdatePositionOfAllButtons();
   }
   else {
      TM_BE_ML_Button.Move(x1 + 30,y1+10);
      // TM_NoBE_Button.Move(x1 + 85, y1+10);  // -> moved to Meta Tools Init file -> UpdatePositionOfAllButtons();
   }
   
   TM_OrderExecutionResultLabel.Move(x1,y1+65);
   
   int x2,y2;
   ChartTimePriceToXY(0,0,TimePosition, GetSL(),x2,y2);
   TM_RiskPercent_Label.Move(x2,y2);
   
   int x3,y3;
   ChartTimePriceToXY(0,0,TimePosition, GetTP(),x3,y3);
   TM_RewardPercent_Label.Move(x3,y3);
   
   if (!this.TradeLinesVisible && this.Show_BodyLevels_Button()) {
      BodyLevels_Button.Show();
      //Print(__FUNCTION__ + ": BodyLevels_Button is shown!");
   }
}



void CTradeManager::TradeEXE_Alive(bool alive) {

   this.m_TradeEXE_Alive = alive;
 
}


bool CTradeManager::TradeEXE_Alive() {

   return this.m_TradeEXE_Alive;

}



void CTradeManager::UpdateTextOnTradeManagerUI() {

   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(_Symbol ,Latest_Price); // Assign current prices to structure 

   if ( !this.TradeLinesVisible && this.TradesArray.TradesPendingOnSymbol(Symbol()) == 1 ) {
      TradeDir trade_dir = this.TradesArray.TradeDirection(Symbol());
      if (trade_dir == TradeDir_BUY)
         TM_Trade_Button.Text("BUY NOW");
      else
         TM_Trade_Button.Text("SELL NOW");
   
   }


   if (!this.TradeLinesVisible) return; 
   
   // --- Find Position Size Calculator ---
   string PositionSize = ""; // Position size string.
   //int Window = WindowFind("Position Size Calculator" + IntegerToString(ChartID()));
   int Window = WindowFindMQL4("PositionSizeCalculator");
   //Print("Window = ", Window);
   if (Window == -1) // not found
   {
      // Trying to find position size object.
      PositionSize = FindEditObjectByPostfix("m_EdtPosSize");
      PositionSize = ObjectGetString(0, PositionSize, OBJPROP_TEXT);
	   if (StringLen(PositionSize) == 0)
      {
         Print("Position Size Calculator not found!");
         return;
      }
   }
   
   //--- Define if it is Buy or Sell
   double SL = GetSL();
   double EntryLevel = GetEntryLevel();
   string s_Order_Type = OrderTypeInPSC_String();
   
   string currency;
   if (AccountInfoString(ACCOUNT_CURRENCY) == "USD") currency = "$";
   else if(AccountInfoString(ACCOUNT_CURRENCY) == "EUR") currency = "€";
   
   string ButtonText = s_Order_Type;
   StringToUpper(ButtonText);
   
   // Writing label on the button
   TM_Trade_Button.Text(ButtonText);
   
   string RiskSizeLabel = FindEditObjectByPostfix("m_EdtRiskPRes");
   double RiskSize = StringToDouble(ObjectGetString(0, RiskSizeLabel, OBJPROP_TEXT));
   double TP = GetTP();
   
   // Label next to TP Line
   // RRR   
   //string RRR_Label = FindEditObjectByPostfix("m_EdtRR2");
   //double RRR = StringToDouble(ObjectGetString(0, RRR_Label, OBJPROP_TEXT));
   //RRR = NormalizeDouble(RRR,1);
   // Reward in Currency
   string Reward_Label = FindEditObjectByPostfix("m_EdtReward2");
   string s_Reward = ObjectGetString(0, Reward_Label, OBJPROP_TEXT);
   StringReplace(s_Reward,",","");
   double Reward = StringToDouble(s_Reward);
   s_Reward = NumberToString(Reward,0);   // adding comma as thousands separator
   // Calc reward as %% of the account value
   string AccountBalance_Label = FindEditObjectByPostfix("m_EdtAccount");
   string s_AccountBalanceValue = ObjectGetString(0, AccountBalance_Label, OBJPROP_TEXT);
   StringReplace(s_AccountBalanceValue,",","");
   double AccountBalanceValue = StringToDouble(s_AccountBalanceValue);
   double RewardRatio;
   if (AccountBalanceValue != 0)
      RewardRatio = Reward / AccountBalanceValue * 100;
   else
      RewardRatio = 0;
   string s_RewardRatio = DoubleToString(RewardRatio,1);
   
   
   
   double RRR = this.RRR_From_Lines_Position();
   
   // Writing values into the label
   string label = "TP: " + s_RewardRatio + "% | " + DoubleToString(RRR,1) + ":1 | "+ currency + s_Reward;
   TM_RewardPercent_Label.Text(label);
   ObjectSetString(ChartID(),"TM_RewardPercent_Label",OBJPROP_TOOLTIP,label);
  
   
   // detect which pair is it
   bool jpy    = StringFind(_Symbol,"JPY")!=-1;
   bool crypto = StringFind(_Symbol,"BTC")!=-1 || StringFind(_Symbol,"ETH")!=-1;
   bool oil    = _Symbol == "BRN" || _Symbol == "WTI" || _Symbol == "BRENT";
   bool gold   = StringFind(_Symbol,"XAU")!=-1;
   // *******************************************
   
   // Label next to SL Line
   string RiskSizeInCurrencyLabel = FindEditObjectByPostfix("m_EdtRiskMRes");
   string s_RiskSizeInCurrency = ObjectGetString(0, RiskSizeInCurrencyLabel, OBJPROP_TEXT);
   StringReplace(s_RiskSizeInCurrency,",","");
   double RiskSizeInCurrency = StringToDouble(s_RiskSizeInCurrency);
   s_RiskSizeInCurrency = NumberToString(RiskSizeInCurrency,0);
   // ATR14 ratio
   string s_atr;
   double SL_pp = MathAbs(GetSL() - GetEntryLevel()) / _Point / 10; 
   if (ATR14 != 0) {
      if (gold || oil || crypto) {
         s_atr = DoubleToString( SL_pp / ATR14 * 10,0);
      }
      else {
         s_atr = DoubleToString( SL_pp / ATR14 * 100,0);
      }
   }
   else s_atr = "0";
   
   // Writing values onto the label
   string reward_label = "SL: " + DoubleToString(RiskSize,1) + "% | -" + currency + s_RiskSizeInCurrency + " | " + s_atr + "% (ATR 14D)";
   TM_RiskPercent_Label.Text(reward_label);
   ObjectSetString(ChartID(),"TM_RiskPercent_Label",OBJPROP_TOOLTIP,reward_label);


   // Update Spread Label
   double spread = this.GetSpread();
   double price_coordinate = Latest_Price.ask;
   datetime time_coordinate = Tomorrow()+6000;
   //int x1, y1;
   //ChartTimePriceToXY(0,0,time_coordinate, price_coordinate,x1,y1);
   
   ObjectDeleteSilent(Spread_Label_Name);
   
   ObjectCreate(0,Spread_Label_Name,OBJ_TEXT,0,time_coordinate,price_coordinate);
   ObjectSetInteger(ChartID(),Spread_Label_Name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,Spread_Label_Name,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
   color clr;
   if (spread > AvgSpread*1.1)
      clr = clrRed;
   else if (spread == AvgSpread || spread > AvgSpread*0.9)
      clr = clrDarkOrange;
   else
      clr = clrGreen;
   
   ObjectSetInteger(0,Spread_Label_Name,OBJPROP_ANCHOR,CORNER_LEFT_LOWER);
   ObjectSetTextMQL4(Spread_Label_Name,this.GetSpreadString(spread),7,"verdana",clr);
   
}


double CTradeManager::GetSpread() {

   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(_Symbol ,Latest_Price); // Assign current prices to structure 
   double spread = (Latest_Price.ask-Latest_Price.bid)/_Point/10;
   if (IsCommodity() || isCRYPTO()) {
      spread = spread / 10;
   }
   return spread;
}

string CTradeManager::GetSpreadString(double spread) {

   string s_currency = "";
   short  digits = 1;
   if (IsCommodity() || isCRYPTO()) {
      s_currency = "$";
      digits = 2;
   }
   return "Spread: " + s_currency + DoubleToString(spread,digits) + " | " + s_currency + DoubleToString(AvgSpread,digits);
}





double CTradeManager::RRR_From_Lines_Position() {

   CTradeLine sl(StopLossLineName);
   CTradeLine tp(TakeProfitLineName);
   CTradeLine entry(EntryLineName);   
   
   double SL_Size = MathAbs(sl.Price() - entry.Price()) / _Point;
   double TP_Size = MathAbs(tp.Price() - entry.Price()) / _Point;
   
   if (SL_Size == 0) return 0;
   
   return TP_Size / SL_Size;

}






void CTradeManager::DrawEntryMarks(int ticket) { 
   // upon entry
   
   CMetaTrade trade(ticket);
      if (!trade.OrderSelectMQL4(ticket)) {
         Print(__FUNCTION__, ": couldn't select order # '",IntegerToString(ticket),"'");
         return;
      }
      else {

	      double sl = trade.SL(); 
	      double tp = trade.TP(); 
	      double el = trade.OpenPrice(); 
	      
	      //double sl_dist = MathAbs(el-sl)/_Point/10;
	      //double tp_dist = MathAbs(el-tp)/_Point/10;

	      double sl_dist = DistBtwTwoPrices(el,sl);
	      double tp_dist = DistBtwTwoPrices(el,tp);
	      
	      string symbol = trade.TradeSymbol();
       
       
         // *** replace with common function GetDistBtwTwoPrices(double price1, double price2) *****
//         bool jpy    = StringFind(symbol,"JPY")!=-1;
//         bool crypto = StringFind(symbol,"BTC")!=-1 || StringFind(symbol,"ETH")!=-1;
//         bool oil    = (symbol == "BRN" || symbol == "WTI" || symbol == "BRENT");
//         bool gold   = StringFind(symbol,"XAU")!=-1;
//         
//	      if (gold)                    { sl_dist = sl_dist / 1;  tp_dist = tp_dist / 1;  }
//	      else if (crypto)             { sl_dist = sl_dist / 10; tp_dist = tp_dist / 10; }
//	      else if (oil)                { sl_dist = sl_dist * 10; tp_dist = tp_dist * 10; }
	      // ****************************************************************************************
	      
	      
	      
	      string sl_label = "SL: " + DoubleToString(sl_dist,0);

         double ATR_Ratio = sl_dist/ATR14*100;
         if (isOIL()) ATR_Ratio = ATR_Ratio / 100;
         else if (isGOLD()) ATR_Ratio = ATR_Ratio / 10;
	         
	      if (!S_Version) sl_label = sl_label + " | " + DoubleToString(ATR_Ratio,0) + "%";
	      
	      string tp_label = "TP: " + DoubleToString(tp_dist,0) + " | " + DoubleToString(tp_dist/sl_dist,1) + ":1";
	      
	      MathSrand(GetTickCount()); // initialize random generator - needed for random naming
	      Draw_Entry_Mark("SL",ticket,sl,clrRed,sl_label); 
	      Draw_Entry_Mark("TP",ticket,tp,clrBlue,tp_label);
         Draw_Entry_Mark("Entry",ticket,el,clrBlack);
         if (!S_Version) DrawEntryParameters(ticket);
         Highlight_Entry_Bar(ticket);
      }
}





void CTradeManager::Draw_Entry_Mark(string MarkType, ulong Ticket, double Price, color Clr, string LabelText = "", bool draw_label = true) {
   datetime time1 = TimeCurrent();
   datetime time2 = time1 + 60*240; // 240 minutes = 4 hours, so, the line can be visible on H4.
   
   int random_int = MathRand();
   string name = MarkType + " for #" + IntegerToString(Ticket) + " (" + IntegerToString(random_int) + ")";
   //string name = MarkType + " for #" + IntegerToString(Ticket);
   //ObjectDeleteSilent(name);
   if(!ObjectCreate(ChartID(),name,OBJ_TREND,0,time1,Price,time2,Price)) {
      Print(__FUNCTION__, ": failed to create " + MarkType + " mark! Error code = ",GetLastError());
      return;
   }
   else { // mark is successfully created, now setting properties
      
      if (MarkType == "Entry") { // if it is entry mark, then we create an additional mark on D1 only 
         // create additionally another line (mark), which will be visible on D1 only.
         string name_d1 = name + " (D1)";
         
         if (!S_Version) { // creating mark on D1 TF
            ObjectCreate(ChartID(),name_d1,OBJ_TREND,0,Today(),Price,Tomorrow(),Price); // mark on D1 timeframe
            ObjectSetInteger(ChartID(),name_d1,OBJPROP_WIDTH,1);
            ObjectSetInteger(ChartID(),name_d1,OBJPROP_COLOR,Clr);
            ObjectSetInteger(0,name_d1,OBJPROP_TIMEFRAMES,OBJ_PERIOD_D1);
            ObjectSetInteger(ChartID(),name_d1,OBJPROP_RAY_RIGHT,false);
            ObjectSetInteger(ChartID(),name_d1,OBJPROP_SELECTABLE,false);
            ObjectSetTextMQL4(name_d1,LabelText,12);
         }
         
         // setting properties of the H1-line
         ObjectSetInteger(ChartID(),name,OBJPROP_WIDTH,1); 
         ObjectSetInteger(ChartID(),name,OBJPROP_COLOR,Clr); 
         ObjectSetInteger(0,name,OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4);   
      }
      else if (MarkType == "BreakEven") {
         ObjectSetInteger(ChartID(),name,OBJPROP_WIDTH,1);
         ObjectSetInteger(0,name,OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
      }
    
      else { // for SL and TP only; (not for Entry or BreakEven)
         ObjectSetInteger(ChartID(),name,OBJPROP_WIDTH,1);
         ObjectSetInteger(0,name,OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4);
         
         if (!S_Version && MarkType != "BackwardsBreak") {
            // small mark on D1 timeframe
            string name_d1 = name + " (D1)";
            //ObjectCreate(ChartID(),name_d1,OBJ_TREND,0,time1,Price,time2,Price); 
            ObjectCreate(ChartID(),name_d1,OBJ_TREND,0,Today(),Price,Today()+60*240,Price); 
            ObjectSetInteger(ChartID(),name_d1,OBJPROP_WIDTH,3);
            ObjectSetInteger(ChartID(),name_d1,OBJPROP_COLOR,Clr);
            ObjectSetInteger(0,name_d1,OBJPROP_TIMEFRAMES,OBJ_PERIOD_D1);
            ObjectSetInteger(ChartID(),name_d1,OBJPROP_RAY_RIGHT,false);
            ObjectSetInteger(ChartID(),name_d1,OBJPROP_SELECTABLE,false);
            ObjectSetTextMQL4(name_d1,LabelText,12);
         }
      }   
      
      // for all Mark Types:
      ObjectSetInteger(ChartID(),name,OBJPROP_COLOR,Clr);
      ObjectSetInteger(ChartID(),name,OBJPROP_RAY_RIGHT,false);
      ObjectSetTextMQL4(name,LabelText,12);
      
      
      // if there is LabelText - we add label
      if (StringLen(LabelText) > 0 && draw_label) { 
         string sl_label_name = MarkType + " Label for " + IntegerToString(Ticket) + " (" + IntegerToString(random_int) +")";
         ObjectDeleteSilent(0,sl_label_name);
         ObjectCreate(0,sl_label_name,OBJ_TEXT,0,time1,Price);
         ObjectSetString(0,sl_label_name,OBJPROP_TEXT,LabelText);
         ObjectSetString(0,sl_label_name,OBJPROP_FONT,"Calibri");
         ObjectSetInteger(0,sl_label_name,OBJPROP_FONTSIZE,8);
         ObjectSetInteger(0,sl_label_name,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1);
         ObjectSetString(0,sl_label_name,OBJPROP_TOOLTIP,LabelText);
         ObjectSetInteger(0,sl_label_name,OBJPROP_ANCHOR,CORNER_LEFT_UPPER);
         color label_clr;
         if (MarkType == "SL") {
            CTradeLine SL_Line(StopLossLineName);
            if ( SL_Line.Color() == clrRed )
               label_clr = clrCoral;
            else
               label_clr = SL_Line.Color();
         }
         else if (MarkType == "TP") {
            CTradeLine TP_Line(TakeProfitLineName);
            if ( TP_Line.Color() == clrBlue ) 
               label_clr = clrDodgerBlue;
            else
               label_clr = TP_Line.Color();
         }
         else
            label_clr = clrGray;
            
         ObjectSetInteger(0,sl_label_name,OBJPROP_COLOR,label_clr);
      }
   }
}





void CTradeManager::DrawEntryParameters(ulong ticket) {

    // Drawing "Bar Closed Dist" mark
    
      // distance (in pp) from closest level which is the same direction as trade 'ticket' and close price of the previous H1 bar
      // 1. Find closest level with same direction and 'ticket' trade
         double closest_level_price = this.GetClosestLevelPriceSameDirection(Levels, ticket);
         if (closest_level_price == 0) {
            MessageOnChart("No levels found; not drawing entry parameters", MessageOnChartAppearTime);
            return;
         } 
         CMetaTrade trade(ticket);
         double sl = trade.SL();
         
      // 3. Get close price of the previous H1-bar
         double last_H1_bar_close_price = iClose(_Symbol,PERIOD_H1,1);
      // 4. Measure the distance btw 'closest_level_price' and 'last_H1_bar_close_price'
         double dist1 = DistBtwTwoPrices(closest_level_price,last_H1_bar_close_price);
         double dist2 = DistBtwTwoPrices(closest_level_price,trade.OpenPrice());
         
      // 5. moving the mark under / on top of the SL label

         int x1,y1, x2, y2;
         ChartTimePriceToXY(0,0,TimeCurrent(),sl,x1,y1); // transform current coordates of SL label to x and y
         x2 = x1; y2 = y1;
         if (trade.TradeDirection() == TradeDir_BUY) {
            // label goes under the SL label
            y1 = y1 + 15; // shifting position by 20 pixels down 

            //Print("dist1 before = " + dist1);
            //Print("closest_level_price = " + closest_level_price);
            //Print("last_H1_bar_close_price = " + last_H1_bar_close_price);

            if (closest_level_price > last_H1_bar_close_price) dist1 = dist1 * -1; 
            if (closest_level_price > trade.OpenPrice()) dist2 = dist2 * -1;     
            
            //Print("dist1 after = " + dist1);
         }     
         else {
            // label goes above the SL label
            y1 = y1 - 40; // shifting position by 20 pixels up
            if (closest_level_price < last_H1_bar_close_price) dist1 = dist1 * -1; 
            if (closest_level_price < trade.OpenPrice()) dist2 = dist2 * -1;   
         }
         y2 = y1 + 10; // position of the 2nd label - slightly lower than the 1st one
         
         double   price1, price2;
         datetime time1,  time2;
         int sub_w;
         ChartXYToTimePrice(0,x1,y1,sub_w,time1,price1);
         ChartXYToTimePrice(0,x2,y2,sub_w,time2,price2);
         
         
         // 5. Form LabelText
         string LabelText1 = "Bar Closed: " + DoubleToString(dist1,1); // distance
         
         int random_int = MathRand();
         string label_1 = "EntryParam Bar Closed Dist for " + IntegerToString(ticket) + " (" + IntegerToString(random_int) +")";
         ObjectDeleteSilent(0,label_1);
         ObjectCreate(0,label_1,OBJ_TEXT,0,time1,price1);
         ObjectSetString(0,label_1,OBJPROP_TEXT,LabelText1);
         ObjectSetString(0,label_1,OBJPROP_FONT,"Calibri");
         ObjectSetInteger(0,label_1,OBJPROP_FONTSIZE,8);
         ObjectSetInteger(0,label_1,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1);
         ObjectSetString(0,label_1,OBJPROP_TOOLTIP,LabelText1);
         ObjectSetInteger(0,label_1,OBJPROP_ANCHOR,CORNER_LEFT_UPPER);
         ObjectSetInteger(0,label_1,OBJPROP_COLOR,clrDarkGray);

   
   
    // Drawingt "Entry Dist" mark
    
      

      string label_2 = "EntryParam Entry Dist for " + IntegerToString(ticket) + " (" + IntegerToString(random_int) +")";
      string LabelText2 = "Entry: " + DoubleToString(dist2,1); // distance
      ObjectDeleteSilent(0,label_2);
      ObjectCreate(0,label_2,OBJ_TEXT,0,time2,price2);
      ObjectSetString(0,label_2,OBJPROP_TEXT,LabelText2);
      ObjectSetString(0,label_2,OBJPROP_FONT,"Calibri");
      ObjectSetInteger(0,label_2,OBJPROP_FONTSIZE,8);
      ObjectSetInteger(0,label_2,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1);
      ObjectSetString(0,label_2,OBJPROP_TOOLTIP,LabelText2);
      ObjectSetInteger(0,label_2,OBJPROP_ANCHOR,CORNER_LEFT_UPPER);
      ObjectSetInteger(0,label_2,OBJPROP_COLOR,clrDarkGray);
}








void CTradeManager::CheckAndUpdateTP(bool b_TradeLinesVisible) {

   double SL = GetSL();
   double TP = GetTP();
   double EL = GetEntryLevel();
   if (SL > EL && TP > EL) {
      double NewTPLevel = EL - 2*(SL-EL);
      ObjectSetDouble(0,TakeProfitLineName,OBJPROP_PRICE,NewTPLevel);
   }

   if (SL < EL && TP < EL) {
      double NewTPLevel = EL + 2*(EL-SL);
      ObjectSetDouble(0,TakeProfitLineName,OBJPROP_PRICE,NewTPLevel);
   }
   Sleep(100);
   this.UpdateTextOnTradeManagerUI();
}




void CTradeManager::UpdateTradeLinesVisibleValue() {

   CTrend line(StopLossLineName);
   if (!line.IsVisibleOnTF(Period())) { // checking visibility of the Pos. Size Calculator Lines
      TradeLinesVisible = false;
      //Print("Lines are now OFF");
   }
   else {
      TradeLinesVisible = true;
      //Print("Lines are now ON");
   }
}



void CTradeManager::SelectTradeLines(bool select) {

   CTradeLine sl(StopLossLineName);
   CTradeLine tp(TakeProfitLineName);
   CTradeLine entry(EntryLineName);
   
   sl.Select(select);
   tp.Select(select);
   entry.Select(select);
   
}





void CTradeManager::ToggleBreakEvenControls(bool show, ulong ticket) {
   
   CTradeLine be_line(BreakEvenLineName);
   if (!be_line.IsExist()) {
      Print("Creating new break even line");
      if (!be_line.CreateBreakEvenLine(ticket)) { // creating BE line on the default distance from the entry
         MessageOnChart("Cannot create Break Even Line", MessageOnChartAppearTime);
         return;
      }
   }
   else {
      // line already exists
      Print("Updating existing break even line");
      be_line.UpdateBreakEvenLine(ticket);
   }
   
   CMetaTrade trade(ticket);
   UpdatePosOfBreakEvenControls(trade.GetBreakEvenPrice());

   // update text on Break Even Label and show it
   
   TM_Set_BE_BB_Level_Button.Show();
   //MessageOnChart("Set Break Even Level");
   
   // final check of BE line position
   if (be_line.Price() <= 0)
      be_line.Price(Ask);
}




void CTradeManager::ToggleBackwardsBreakControls(bool show, ulong ticket) {
   // show / hide line and button
   
   CMetaTrade trade(ticket);
   
   CTradeLine bb_line(BackwardsBreakLineName);
   if (!bb_line.IsExist()) {
      Print("Creating new backwards-break line");
      if (!bb_line.CreateBackwardsBreakLine(ticket)) { // creating BB line on the default distance from the entry
         MessageOnChart("Cannot create Backwards-Break Line", MessageOnChartAppearTime);
         return;
      }
   }
   else {
      // line already exists
      Print("Updating existing backwards-break line");
      bb_line.UpdateBackwardsBreakLine();
      bb_line.Price(trade.GetBackwardsBreakPriceDefault(this.GetClosestLevelPriceSameDirection(Levels,true)));
   }
   
   
   UpdatePosOfBackwardsBreakControls(trade.GetBackwardsBreakPriceDefault(this.GetClosestLevelPriceSameDirection(Levels,true)));

   // update text on Break Even Label and show it
   
   TM_Set_BE_BB_Level_Button.Show();
   MessageOnChart("Setting Up Backwards-Break Level...", MessageOnChartAppearTime);
}





void CTradeManager::ProcessBackwardsBreak() {
   // functions checks, if BB line was broken. If yes, it will close the last order on the symbol, or will move it to BE
   // pending order will be deleted
   // if bar has a long wick (>=50% of the bar height) - no actions will be done, but BB level will be reset, so, the user can set a new one.
   // if the trade is already in min loss (TP is in negative zone) - BB will not be processed (not to close the trade, if trader doesn't want it)
   
   // if (DebugMode) Print("Check for backwards break conditions...");
   
   
   // if backwards break level is ZERO - treating is as the backwards break function is OFF
   if (sets.BackwardsBreakLevel() == 0) {
      //Print("Backwards Break Function is OFF - NOT performing backwards break check");
      return;
   }
   // ***********************************************
   
   
   // *** Gather initial information about the current trade ***
   InformedAboutBackwardsBreak = false; // reset flag when new hour starts
   this.TradesArray.Update();
   ulong last_trade_ticket = TradesArray.LastOrderOnSymbol_Ticket(Symbol());
   if (last_trade_ticket == 0) {
      // if (DebugMode) Print(__FUNCTION__ + ": No orders found.");
      return;
   }
   CMetaTrade trade(last_trade_ticket);
   int trade_type = trade.TradeType();
   
   // check, if the order is already in Min Loss - then - do not process BB
   if (trade.TP_PP() <= 0) {
      Print("Trade '"+IntegerToString(trade.Ticket)+"' is already in Min Loss (TP is in negative zone or at 0). Not checking for backwards break.");
      return;
   }
   
 
   // performing the main check - if BB happened
   double   sl_size = trade.SL_PP_ABS();
   double   loss = MathAbs(trade.ProfitPP());
   loss = NormalizeDouble(loss,1);
   string s_loss;
   if (loss < 100) s_loss = DoubleToString(loss/10,1);
   else s_loss = DoubleToString(loss/10,0);
   s_loss = s_loss + "pp";
   
   bool     BB_Happened = false;
   string   order_type;
   CBar LastBar(1,PERIOD_H1); // last closed bar
   
   if (trade_type == OP_BUY || trade_type == OP_BUYLIMIT || trade_type == OP_BUYSTOP) {
      order_type = "Buy";
      if (LastBar.ClosePrice() < sets.BackwardsBreakLevel() ) { // last bar has broken backwards-break level
         BB_Happened = true;
      }
   }
   else if (trade_type == OP_SELL || trade_type == OP_SELLLIMIT || trade_type == OP_SELLSTOP) {
      order_type = "Sell";
      if (LastBar.ClosePrice() > sets.BackwardsBreakLevel() ) { // last bar has broken backwards-break level
         BB_Happened = true;
      }
   }
   else {
      Print(__FUNCTION__, ": unknown type of order. Order #", trade.Ticket);
      return;
   } 


   if (!BB_Happened) {
      Print("Backwards Break was NOT detected for order #" + IntegerToString(last_trade_ticket) + "");
      return;
   }
   
   // BB HAS HAPPENED! BB function is ON and we have the last qualified active trade identified
   Print("BB level is broken by last bar. Order #" + IntegerToString(last_trade_ticket) + "");
   
   // NOW: checking, if the breaking bar qualifies as backwards break.
   // the only criterion it is not qualitied, if when (for buy-trade) upper wick is >= 50% of the bar height
   
   if (order_type == "Buy") {
      // checking lower wick
      if (LastBar.LowerWick() >= LastBar.Height() * 0.5) {
         // not processing this backwards break & switching off the backwards break function & resetting BB level
         string descr = "Back.Break! Lower wick >= 50% of bar height. No changes for #" + IntegerToString(last_trade_ticket);
         Print(descr);
         BB_Happened = false;
         //sets.BackwardsBreakLevel(0,0);
         //sets.SaveSettingsOnDisk();
         //this.ToggleBackwardsBreakControls(true,last_trade_ticket);
         LastBar.BarInfoIcon(167,clrRed,descr);
         SendPushAlert(descr);
         InformedAboutBackwardsBreak = true;
      }
   }
   else if (order_type == "Sell") {
      // checking upper wick
      if (LastBar.UpperWick() >= LastBar.Height() * 0.5) {
         // not processing this backwards break & switching off the backwards break function & resetting BB level
         string descr = "Back.Break! Upper wick >= 50% of the bar height. No changes for #" + IntegerToString(last_trade_ticket);
         Print(descr);
         BB_Happened = false;
         //sets.BackwardsBreakLevel(0,0);
         //sets.SaveSettingsOnDisk();
         //this.ToggleBackwardsBreakControls(true,last_trade_ticket);
         LastBar.BarInfoIcon(167,clrRed,descr);
         SendPushAlert(descr);
         InformedAboutBackwardsBreak = true;
      }
   }
   else {
      Print(__FUNCTION__, ": unknown type of order. Order #", trade.Ticket);
      return;
   }
   
   // processing backwards break
   if (BB_Happened) {
     
      if (trade.ProfitPP() > 0) {
         Print("Trade is in profit: " + DoubleToString(trade.ProfitPP(),1) + ". Moving SL->Entry for order #" + IntegerToString(last_trade_ticket));
         LastBar.BarInfoIcon(167,clrRed,"Back.Break! Profit=" + DoubleToString(trade.ProfitPP(),1) + "pp. SL -> Entry");
         MoveSLtoEntry(trade.Ticket);
         SendPushAlert("Back.Break! Profit=" + DoubleToString(trade.ProfitPP(),1) + "pp. SL->Entry");
         InformedAboutBackwardsBreak = true;
         SaveTemplateAndScrenshot(false); // save template, but not screenshot
      }
      else {
         // trade either has 0 profit, or negative; or this is a pending order
         if (loss <= 0.25*sl_size) {
            CloseTrade(trade.Ticket);
            bool pending = false;
            if (trade_type == OP_BUYLIMIT || trade_type == OP_BUYSTOP || trade_type == OP_SELLLIMIT || trade_type == OP_SELLSTOP) pending = true;
            string msg;
            if (pending) msg = "Back.Break! Deleting pending order #" + IntegerToString(last_trade_ticket);
            else msg = "Back.Break! Loss = " + s_loss + " <= 0.25*SL. Closing order #" + IntegerToString(last_trade_ticket);
            sets.BackwardsBreakLevel(0,0);
            sets.SaveSettingsOnDisk();
            Print(msg);
            LastBar.BarInfoIcon(251, clrRed,msg);
            SendPushAlert(msg);
            InformedAboutBackwardsBreak = true;
            if (!S_Version) SaveTemplateAndScrenshot(false); // save template, but not screenshot
         }
         else {
            Print(__FUNCTION__ + ": Moving TP -> ML for order #" + IntegerToString(last_trade_ticket));
            bool moved_to_ML = this.MoveTPtoML(trade.Ticket);
            string msg;
            if (moved_to_ML) {
               msg = "Back.Break! Loss = " + s_loss + " > 0.25*SL. Moving TP->MinLoss";
               LastBar.BarInfoIcon(159, clrRed,msg);
            }
            else {
               msg = "Back.Break! Loss = " + s_loss + " > 0.25*SL, but couldn't move TP->ML";
               Print(msg);
            }
            SendPushAlert(msg);
            InformedAboutBackwardsBreak = true;
         }
      }
   }


}







bool CTradeManager::MoveSLtoEntry(ulong ticket) {

   if (!EventChartCustom(ChartID(),TRADE_BREAKEVEN_SET,ticket,0,"")) {
      Print("Couldn't send custom event 'TRADE_BREAKEVEN_SET'");
      return false;
   }
   else {
      Print("'TRADE_BREAKEVEN_SET' is sent");
      return true;
   }
}


bool CTradeManager::MoveTPtoML(ulong ticket) {

   // ************************************************************************************************
   // *** FIRST - CHECK IF THIS ORDER IS ALREADY NOT IN MIN LOSS MODE
   // *** not trying to move orders into MinLoss twice - this may prevent terminal from hanging
   CMetaTrade trade(ticket);
   if (trade.TradeType() == OP_BUY) { 
      if (trade.TP() < trade.OpenPrice()) { // Trade is already in Min Loss mode
         Print(__FUNCTION__ + ": Order #" + IntegerToString(trade.Ticket) + " is already in MinLoss mode. Not processing Min Loss request further");
         return false; 
      }
   }
   else if (trade.TradeType() == OP_SELL) { 
      if (trade.TP() > trade.OpenPrice()) { // Trade is already in Min Loss mode
         Print(__FUNCTION__ + ": Order #" + IntegerToString(trade.Ticket) + " is already in MinLoss mode. Not processing Min Loss request further");
         return false; 
      }
   }
   else { // this is probably a pending order
      Print(__FUNCTION__ + ": error - attempt to move non-active order#" + IntegerToString(trade.Ticket) + " to MinLoss");
      return false; 
   }
   Print(__FUNCTION__ + ": TP of order #" + IntegerToString(trade.Ticket) + " is in positive zone; moving to Min Loss...");
   // END OF CHECK
   // ************************************************************************************************


   if (!EventChartCustom(ChartID(),TRADE_MINLOSS_SET,ticket,0,""))  {
      Print("Couldn't send custom event 'TRADE_MINLOSS_SET'");
      return false;
   }
   else {
      Print("'TRADE_MINLOSS_SET' is sent");
      return true;
   }
}

bool CTradeManager::CloseTrade(ulong ticket) {
   if (!EventChartCustom(ChartID(),TRADE_CLOSE_COMMAND,ticket,0,""))  {
      Print("Couldn't send custom event 'TRADE_CLOSE_COMMAND'");
      return false;
   }
   else {
      Print("'TRADE_CLOSE_COMMAND' is sent");
      return true;
   }
}




void CTradeManager::HideTradeManagerButtons() {
   TM_Trade_Button.Hide();
   TM_Trade_Button.Hide();
   TM_Trade_Button.Hide();
   TM_StatusLED_Label.Hide();
   TM_AutoEntry_Button.Hide();
   TM_NoBE_Button.Hide();
}




void CTradeManager::UpdatePosVizOfTradeManager() { // Trade Manager

   if (Strategy == FourStrings && Period() == PERIOD_H1) {
      FourStrings_AutoMode_Button.Show();
      FourStrings_Fibo_Button.Show();
      FourStrings_Orders_Button.Show();
   }
   else {
      FourStrings_AutoMode_Button.Hide();
      FourStrings_Fibo_Button.Hide();
      FourStrings_Orders_Button.Hide();
   }

   if (!this.TradeLinesVisible || !this.m_TradeEXE_Alive) {
      // HIDING CONTROLS      
      TM_Trade_Button.Hide();
      TM_RewardPercent_Label.Hide();
      TM_RiskPercent_Label.Hide();
      TM_OrderExecutionResultLabel.Hide();
      TM_OrderExecutionResultLabel.Text("");
      if (!sets.AutoEntryOnBarClose) TM_AutoEntry_Button.Hide();
      TM_OrderType_Button.Hide();
      
      if (!sets.AutoEntryOnBarClose) {
         // turning off AutoEntry Control and mode
         this.AutoEntryControl.ShowControl(false,Levels);
         HighlightButton(TM_AutoEntry_Button,false);
         //sets.SaveSettingsOnDisk(); - Teporary disable - not clear why should this be here
      }
      // *********************************
      ObjectDeleteSilent(this.Spread_Label_Name);
   }
   else {
      // Trade Lines are visible and Trade.exe is live
      // SHOWING CONTOLS
      TM_RewardPercent_Label.Show();         
      TM_RiskPercent_Label.Show();
      TM_OrderExecutionResultLabel.Show();
      TM_AutoEntry_Button.Show();
      TM_OrderType_Button.Show();
   }
   
   if (this.m_TradeEXE_Alive) {
   
      // добавлено, чтобы разрешить торговлю на любом ТФ
      TM_StatusLED_Label.Show();  
      if (this.TradeLinesVisible) {
         TM_Trade_Button.Show(); 
      }
      // ==============================================
      
      /*   // закоментировано, чтобы разрешить торговлю на любом ТФ
      if (Period() == PERIOD_H1) { 
         if (this.TradeLinesVisible && !sets.AutoEntryOnBarClose) 
            TM_Trade_Button.Show();
         else {
            // TM_Trade_Button.Hide();     
            // TM_OrderType_Button.Hide(); 
         }
         TM_StatusLED_Label.Show();
      }
      else {
         // TM_StatusLED_Label.Hide();
         if (!sets.AutoEntryOnBarClose) TM_AutoEntry_Button.Hide();
         // TM_OrderType_Button.Hide(); 
      }
      */
   
   
   
      // process Break Even and Min Loss Buttons separatelly, independable of Lines being visible or not
      if (TradesArray.ProfitableTradesOpenOnSymbolNotBreakEven(Symbol()) > 0) {
         // switch on break even button (show and text on it)
         TM_BE_ML_Button.Text("SL -> BE");
         TM_BE_ML_Button.Color(clrGreen);
         TM_BE_ML_Button.ColorBorder(clrGreen);
         TM_BE_ML_Button.Show();
         CTradeLine be_line(BreakEvenLineName);
         if (!be_line.IsExist()) {
            ToggleBreakEvenControls(true,TradesArray.LastOrderOnSymbol_Ticket(Symbol()));
         }
      }
      else {
         ulong single_loss_trade_ticket = TradesArray.SingleLossTradeOnSymbolNotInMinLoss(Symbol());
         if (single_loss_trade_ticket !=0) {
            // switch on min loss button
            TM_BE_ML_Button.Text("TP -> ML");
            TM_BE_ML_Button.Color(clrRed);
            TM_BE_ML_Button.ColorBorder(clrRed);
            TM_BE_ML_Button.Show();
         }
      }
   
      if (sets.AutoEntryOnBarClose) HighlightButton(TM_AutoEntry_Button,true,false,clrRed);
      else HighlightButton(TM_AutoEntry_Button,false);
   
      if ( TradesArray.TradesOpenOnSymbol(Symbol()) > 0) {
         sets.LoadSettingsFromDisk();
         MqlDateTime server_time;
         TimeToStruct(TimeCurrent(),server_time);
         datetime midnight = StringToTime((string)server_time.year+"."+(string)server_time.mon+"."+(string)server_time.day+" "+"00:00");
         datetime StartTime = midnight - sets.NoBELastMinOfDay()*60;
         datetime EndTime   = midnight + sets.NoBEFirstMinOfDay()*60;
         string lead_zero_start_hour;  if (TimeHourMQL4(StartTime)   <10 )    lead_zero_start_hour = "0";
         string lead_zero_start_min;   if (TimeMinuteMQL4(StartTime) <10 )    lead_zero_start_min  = "0";
         string lead_zero_end_hour;    if (TimeHourMQL4(EndTime)     <10 )    lead_zero_end_hour   = "0";
         string lead_zero_end_min;     if (TimeMinuteMQL4(EndTime)   <10 )    lead_zero_end_min    = "0";
         
         string   start_time = lead_zero_start_hour + (string)TimeHourMQL4(StartTime) + ":" + lead_zero_start_min + (string)TimeMinuteMQL4(StartTime);
         string   end_time   = lead_zero_end_hour + (string)TimeHourMQL4(EndTime)   + ":" + lead_zero_end_min + (string)TimeMinuteMQL4(EndTime);
         TM_NoBE_Button.Text("No BE: " + start_time + " - " + end_time);
         TM_NoBE_Button.Show();
      }
      else {
         TM_NoBE_Button.Hide();
      }
   
   }
   
   
   else {
      //hide the Break Even / Min Loss button
      TM_BE_ML_Button.Hide();
   }
   // Break Even and Min Loss Button  
   
   
   this.UpdateOrderTypeButton(); // instant or pending
   
   if ( !this.TradeLinesVisible && this.TradesArray.TradesPendingOnSymbol(Symbol()) == 1 ) { 
      // show "BUY NOW" / "SELL NOW"
      // show this button, only if current price is <= 8% of ATR5. 
      short n = (short)this.TradesArray.FirstLimitOrderOnSymbol_index(Symbol());
      double dist = this.TradesArray.Trades[n].DistBetweenPriceAndEntry();
      if ( Symbol() == "WTI" || Symbol() == "BRN" || Symbol() == "BRENT" || Symbol() == "XAUUSD" || Symbol() == "XAGUSD" ) dist = dist * 10;
      if ( DebugMode ) Print("dist = " + DoubleToString(dist,2) + " | ATR5 = " + DoubleToString(ATR5,2));
      if ( dist <= 0.08 * ATR5 )
         TM_Trade_Button.Show();
   }
   else {
      //TM_Trade_Button.Hide();
   }
   
   
   // update visibility of the "Body Levels" button
   this.ShowHideBodyLevelsButton();
   //if (!this.TradeLinesVisible && this.Show_BodyLevels_Button())
   //   this.ShowHideControls();
   //else
   //   this.ShowHideControls();
   
   
   // --- UPDATING POSITION OF TRADE MANAGER CONTROLS ------
   this.UpdatePosOfTradeManager();
}




void CTradeManager::InformAboutOpenTradesForAllCharts() {
   //Inform (push) about open traders, if any; for all the symbols with open trades
   string msg;
   
   int open_trades = this.TradesArray.TradesCount();
   
   if (open_trades == 0) return;
   
   for (int i = 0; i < open_trades; i++) {
   
      if (StringLen(msg)>0) msg = msg + "; ";
      
      ENUM_ORDER_TYPE trade_type = TradeManager.TradesArray.Trades[i].TradeType();
      
      if (trade_type == OP_BUY || trade_type == OP_SELL) { // active order
       
            string symbol = TradeManager.TradesArray.Trades[i].TradeSymbol();
            
            double sl_pp = TradesArray.Trades[i].SL_PP_ABS()/10;
            string s_sl_pp = IntegerToString((int)MathRound(sl_pp));
            
            double profit = TradesArray.Trades[i].ProfitPP()/10;
            string s_profit = IntegerToString((int)MathRound(profit));
            
            msg = msg + SymbolAbbreviation(symbol)
               + " "    + s_profit + "pp" 
               + " SL:" + s_sl_pp  + "pp";
      }
      else { // limit or stop order
         msg = msg + SymbolAbbreviation(TradesArray.Trades[i].TradeSymbol()) + " " 
            + TradesArray.Trades[i].TradeTypeString();
      }
   } // for    
   
   if (StringLen(msg) == 0) return;
   
   msg = EnumToString(Strategy) + ": " + IntegerToString(open_trades) + " orders open. " + msg;
   SendNotification(msg);
   Print(msg);
   
}


void CTradeManager::ToggleOrderType(void) {
   EventChartCustom(ChartID(),CLICK_ORDER_TYPE_BTN,0,0,"");
}


void CTradeManager::UpdateVisOfSimulatorLines() {

   double SL_Line_Price = ObjectGetDouble(0,this.StopLossLine.Name,OBJPROP_PRICE);
   if (SL_Line_Price == 0) return; // exit, because Simulator Trade Lines are off
   //Print(SL_Line_Price);
   
   double Pending_Entry_Price = ObjectGetDouble(0,"sim#3d_visual_ap",OBJPROP_PRICE); 
   double dist_entry_to_SL = 0;
   double TP_ratio = 0;
   double dist_entry_to_TP = 0;
   double TP_Price   = ObjectGetDouble(0,this.TakeProfitLine.Name,OBJPROP_PRICE); 
   
   if (Pending_Entry_Price == 0) {
      // this is instant entry case
      double bid = ObjectGetDouble(0,"sim#3d_bid",OBJPROP_PRICE);
      double ask = ObjectGetDouble(0,"sim#3d_ask",OBJPROP_PRICE);
      if (SL_Line_Price < bid) {
         // buying case
         dist_entry_to_SL  = MathAbs(SL_Line_Price - ask) / _Point;
         dist_entry_to_TP  = MathAbs(TP_Price - ask) / _Point;
      }
      else {
         // selling case
         dist_entry_to_SL = MathAbs(SL_Line_Price - bid) / _Point;
         dist_entry_to_TP  = MathAbs(TP_Price - bid) / _Point;
      }
   }
   else {
      // this is pending entry case  
      dist_entry_to_SL = MathAbs(Pending_Entry_Price - SL_Line_Price) / _Point;
      dist_entry_to_TP  = MathAbs(TP_Price - Pending_Entry_Price) / _Point;
   }
   
   TP_ratio = dist_entry_to_TP / dist_entry_to_SL;
   ObjectSetText(this.StopLossLine.Name,"                                SL" + ": " + DoubleToString(dist_entry_to_SL,0) + " pp",20);
   ObjectSetText(this.TakeProfitLine.Name,"                                TP" + ": " + DoubleToString(TP_ratio,1) + ":1",20);
   
   //sim#3d_ask
   //sim#3d_bid

   //StopLossLineName = "sim#3d_visual_sl";
   //TakeProfitLineName = "sim#3d_visual_tp";
   //EntryLineName = "sim#3d_visual_ap";
}






void CTradeManager::OnClick(string sparam) {

   Print(__FUNCTION__);
   if (SimulatorMode) {
      TradeManager.UpdateVisOfSimulatorLines();
      return;
   }


   TradeManager.TradesArray.Update(); // should be first before all other functions, which may use the global array of levels
   
   if (sparam == StopLossLineName) {
      // it is very high in this method to make sure it will be executed.
      // I tried to put it lower, but it is not executed. Probably some other code exits the method earlier
      this.UpdateVisPosOfRecommendedSLRange();
   }
   
   // **************  FOUR STRINGS STRATEGY   *******************************************************************************
   if (sparam == "FourStrings_DeleteYesterdayPendingOrders") {
      string msg = "Deleting yesterday pending 'Four Strings' orders";
      Print(msg);
      MessageOnChart(msg, MessageOnChartAppearTime);
      Print("Pending orders on this symbol: " + IntegerToString(this.TradesArray.TradesPendingOnSymbol(Symbol())));
      TradeManager.TradesArray.FourStrings_DeleteYesterdayPendingOrdersOnSymbol(Symbol());
      return;
   }
   
   if (sparam == "FourStrings_DeleteTodayPendingOrders") {
      string msg = "Deleting today pending 'Four Strings' orders";
      Print(msg);
      MessageOnChart(msg, MessageOnChartAppearTime);
      Print("Pending orders on this symbol: " + IntegerToString(this.TradesArray.TradesPendingOnSymbol(Symbol())));
      TradeManager.TradesArray.FourStrings_DeleteTodayPendingOrdersOnSymbol(Symbol());
      return;
   }
   // ************************************************************************************************************************
   

   if (sparam == "TM_OrderType_Button") {
      this.ToggleOrderType();
      this.UpdateOrderTypeButton();
   }
   


   if (sparam == "TM_AutoEntry_Button") {
      if (sets.AutoEntryOnBarClose) {
         // Auto Entry was ON - swithing OFF
         HighlightButton(TM_AutoEntry_Button,false);
         sets.AutoEntryOnBarClose = false;
         sets.SaveSettingsOnDisk();
         this.AutoEntryControl.ShowControl(false,Levels);
         TM_Trade_Button.Show();
         this.TM_OrderType_Button.Show();
         this.Order_Type("Instant");
         MessageOnChart("Trade Manager: Manual Entry", MessageOnChartAppearTime);
      }
      else {
         // Auto Entry was OFF - switching ON
         HighlightButton(TM_AutoEntry_Button,true,false,clrRed);
         sets.AutoEntryOnBarClose = true;
         sets.SaveSettingsOnDisk();
         this.AutoEntryControl.ShowControl(true,Levels);
         TM_Trade_Button.Hide();
         this.TM_OrderType_Button.Hide();
         MessageOnChart("Trade Manager: Auto-Entry on Bar Close", MessageOnChartAppearTime);
         
         // Switch Order Type to Pending and Set Entry Line in the middle of the Instant Rectangle
         this.Order_Type("Pending");
         CTradeLine entry(EntryLineName);
         entry.Price(this.AutoEntryControl.DefaultLimitPrice(Levels));
      }
   }
   
   if (sparam == EntryLineName) {
      this.DisplayDistanceEntryLineToClosestLevel();
      this.UpdateVisPosOfRecommendedSLRange();
      
      if (sets.AutoEntryOnBarClose && this.AutoEntryControl.InstantEntryRect.IsExist()) {
         // making sure that EntryLine was not moved outside of logical boundaries of Instant Rect (if it exists)
         CTradeLine entry_line(EntryLineName);
         if (this.AutoEntryControl.TradeDirection == Buy_Level){
            if (entry_line.Price() >= this.AutoEntryControl.InstantEntryRect.Price1()) {
               // adjusting EntryLine back inside InstantEntryRectangle
               entry_line.Price(this.AutoEntryControl.DefaultLimitPrice(Levels));
            }
         }
         else { // sell setup
            if (entry_line.Price() <= this.AutoEntryControl.InstantEntryRect.Price2()) {
               // adjusting EntryLine back inside InstantEntryRectangle
               entry_line.Price(this.AutoEntryControl.DefaultLimitPrice(Levels));
            }
         }
      }
   }
   
   if (sparam == "TM_AutoDeleteLimitOnTimer_Button") {
      if (sets.AutoDeleteLimitOnTimer) {
         // was ON, swithing OFF
         HighlightButton(TM_AutoDeleteLimitOnTimer_Button,false);
         sets.AutoDeleteLimitOnTimer = false;
         sets.AutoDeleteLimitOnTimerAt = D'01.01.1970'; // resetting timer
         TM_AutoDeleteLimitOnTimer_Button.Text("Delete After");
         sets.SaveSettingsOnDisk();
         string msg = "Trade Manager: Auto-Delete Limit Order On Timer is OFF";
         MessageOnChart(msg, MessageOnChartAppearTime);
         Print(msg);
      }
      else {
         // was OFF, switching ON
         HighlightButton(TM_AutoDeleteLimitOnTimer_Button,true,false,clrRed);
         sets.AutoDeleteLimitOnTimer = true;
         if (sets.AutoDeleteLimitOnTimerAt < TimeCurrent())
             sets.AutoDeleteLimitOnTimerAt = TimeCurrent() + 30*60; // 
         sets.SaveSettingsOnDisk();
         string msg = "Trade Manager: Auto-Delete Limit Order On Timer is ON";
         MessageOnChart(msg, MessageOnChartAppearTime);
         Print(msg);
      }
   }
   
   if (sparam == "TM_AutoDeleteLimitOnTimerMore_Button") {      
      if ( (sets.AutoDeleteLimitOnTimerAt - TimeCurrent()) < 5*60)
         sets.AutoDeleteLimitOnTimerAt = sets.AutoDeleteLimitOnTimerAt + 1*60; // adding by 1 min
      else
         sets.AutoDeleteLimitOnTimerAt = sets.AutoDeleteLimitOnTimerAt + 5*60; // adding by 5 min
      
      
      sets.SaveSettingsOnDisk();
      TM_AutoDeleteLimitOnTimerMore_Button.Pressed(false);
   }
   
   if (sparam == "TM_AutoDeleteLimitOnTimerLess_Button") {
      if ( (sets.AutoDeleteLimitOnTimerAt - TimeCurrent()) < 5*60)
         sets.AutoDeleteLimitOnTimerAt = sets.AutoDeleteLimitOnTimerAt - 1*60; // reducing by 1 min
      else
         sets.AutoDeleteLimitOnTimerAt = sets.AutoDeleteLimitOnTimerAt - 5*60; // reducing by 5 min
      sets.SaveSettingsOnDisk();
      TM_AutoDeleteLimitOnTimerLess_Button.Pressed(false);
   }
   
   
   


      if (sparam == "AutoEntryOnBarClose") {
         Print("OnBarClose Event Simulation, sets.AutoEntryOnBarClose = ",  sets.AutoEntryOnBarClose);
         TradeManager.AutoEntryOnBarClose();
         return;
      }
      if (sparam == "BBCheck") {
         Print("Simulation of backwards break");
         this.ProcessBackwardsBreak();
         return;
      }
      if (sparam == "S3ImpulseCheck") {
         Print("Simulation of S3-impulse check");
         Current_H1_Bar.Alert_and_Sound_for_S3_Impulse(Levels,ATR5,IsSoundControlON());
         return;
      }
      
      if (sparam == "PositionThreatCheck") {
         Print("Simulation of check for Position Threat");
         this.AlertOnPossibleThreateningBar(ATR5);
         return;
      }


      this.UpdateTradeLinesVisibleValue();
      this.UpdatePosOfTradeManager();
      this.UpdateTextOnTradeManagerUI(); 
      
      
      if (sparam == StopLossLineName && AutoBFTools) {
         CTradeLine tp_line(TakeProfitLineName);
         tp_line.TPLineToOtherSideIfRequired(); // align TP line to the right side from entry line 
         //Print("sets.TP_Manual_Control = " + sets.TP_Manual_Control);
         if (!sets.TP_Manual_Control) tp_line.TPtoSL_Ratio_Keep(); // controlled automatically
         return;    
      }
     
      
      
      if (sparam == EntryLineName && AutoBFTools) {
         CTradeLine line(TakeProfitLineName);
         line.TPLineToOtherSideIfRequired(); // align TP line to the right side from entry line 
         if (!sets.TP_Manual_Control) line.TPtoSL_Ratio_Keep(); // controlled automatically
         return;    
      }
      
      
      if (sparam == TakeProfitLineName) {
         CTradeLine line(TakeProfitLineName);
         sets.TP_Manual_Control = true; // switching on manual control to stop connection between SL and TP; until Trade Lines will be switched OFF and ON again
         sets.SaveSettingsOnDisk();
         return;    
      }
      
      if (sparam == BreakEvenLineName) { // click on Break Even Line
         CTradeLine be_line(sparam);
         TradeManager.UpdatePosOfBreakEvenControls(be_line.Price1());
         if (TradeManager.TradesArray.TradesOpenOnChart(ChartID()) == 0) {
            be_line.Delete();
            TM_Set_BE_BB_Level_Button.Hide();
            return;
         }
         if (be_line.IsSelected()) {
            be_line.BreakEvenLineEdit();
            TM_Set_BE_BB_Level_Button.Show();
         }
         else { // BE line was not selected
            if (sets.BreakEvenLevel() != 0) {
               be_line.Price1(sets.BreakEvenLevel()); // move break even line to previously saved BE price
               
               // getting order to calculate what percentage is BE level from TP size
               ulong ticket = TradeManager.TradesArray.LastOrderOnSymbol_Ticket(Symbol());
               CMetaTrade trade(ticket);
               int BE_Percent = int(sets.BreakEvenPP()/trade.TP_PP()*100);
               be_line.BreakEvenLineSet(sets.BreakEvenPP(),BE_Percent);
               // ======
               
               TM_Set_BE_BB_Level_Button.Hide();
            }
            else {// BE is still 0 (not set) - we should not allow the BE line to be disselected
               be_line.BreakEvenLineEdit(); // new BE was not set - come back to BE-editing move
            }
         }
         return;
      }
      
      if (sparam == "SL_in_Money_Label") {
         // delete label that shows stop loss in money
         ObjectDeleteSilent("SL_in_Money_Label");
      }
      
      
      
      if (sparam == BackwardsBreakLineName) { // click on Backwards Break Line
         CTradeLine bb_line(sparam);
         TradeManager.UpdatePosOfBackwardsBreakControls(bb_line.Price1());
         if (TradeManager.TradesArray.TradesOpenOnChart(ChartID()) == 0) {
            bb_line.Delete();
            TM_Set_BE_BB_Level_Button.Hide();
            return;
         }
         if (bb_line.IsSelected()) {
            // enabling edit mode of the line
            bb_line.BackwardsBreakLineEdit();
            TM_Set_BE_BB_Level_Button.Show();
         }
         else {
            if (sets.BackwardsBreakLevel() != 0) {
               // move backwards break line to previously saved BB price
               bb_line.Price1(sets.BackwardsBreakLevel()); 
               bb_line.BackwardsBreakLineSet();
               TM_Set_BE_BB_Level_Button.Hide();
            }
            else {// BB is still 0 (not set) - we should not allow the BB line to be disselected
               bb_line.BackwardsBreakLineEdit(); // new BE was not set - come back to BE-editing move
            }
         }
         return;
      }
      
      
      
      
      if (sparam == "TM_Set_BE_BB_Level_Button") {
         // setting up BE and BB Levels
         this.Set_BE_BB_Level_Button_Click();
      }
      
      if (sparam == "TM_NoBE_Button") {
         this.TM_NoBE_Button_Click();
      }
      
      
      
      
      
      
      if (sparam == "TM_BE_ML_Button") {
         TM_BE_ML_Button.Pressed(false);
         
         //if (!MarketInfoMQL4(_Symbol,MODE_TRADEALLOWED)) {
         //   MessageOnChart("Trading is not allowed now");
         //   return;
         //}
         
         if (StringFind(TM_BE_ML_Button.Text(),"TP ->") != -1) {
         // min loss button pressed
            ulong single_loss_trade_ticket = TradeManager.TradesArray.SingleLossTradeOnSymbolNotInMinLoss(Symbol());
            if (single_loss_trade_ticket == 0) {
               MessageOnChart("There is no single loss trade on this symbol", MessageOnChartAppearTime);
               return;
            }
            this.MoveTPtoML(single_loss_trade_ticket);
            CBar curr_bar(0,PERIOD_H1);
            curr_bar.BarInfoIcon(115,clrRed,"TP moved to Min Loss by User");
            return;
         }
         //
      
         if (StringFind(TM_BE_ML_Button.Text(),"SL ->") != -1) {
         // break even button pressed
            if ( TradeManager.MoveSLtoEntry(TradeManager.TradesArray.LastOrderOnSymbol_Ticket(Symbol())) ) {
               CBar curr_bar(0,PERIOD_H1);
               curr_bar.BarInfoIcon(115,clrGreen,"SL moved to Break Even by User");
            }
            else 
               MessageOnChart("Could not move SL to Break Even", MessageOnChartAppearTime);
            return;
         }
      }
      
      if (sparam == "FourStrings_AutoMode_Button") {
         if (sets.FourStringsAutoMode) {
            HighlightButton(FourStrings_AutoMode_Button,false,false,clrRed);
            sets.FourStringsAutoMode = false;
            sets.SaveSettingsOnDisk();
            FourStrings_AutoMode_Button.Pressed(false);
         }
         else {
            HighlightButton(FourStrings_AutoMode_Button,true,false,clrRed);
            sets.FourStringsAutoMode = true;
            sets.SaveSettingsOnDisk();
            FourStrings_AutoMode_Button.Pressed(false);
         }
      }
      
      if (sparam == "FourStrings_Fibo_Button") {
         this.FourStrings_ExtendD1Levels();
         this.FourStrings_FiboSetup();
         string signal_level = this.FourStrings_IsSignalOnD1Yesterday();
         if (signal_level != "") {
            Print("Four Strings signal detected - yesterday D1-bar crossed level - highlighting that bar and disqualifying level for further work");
            CBar bar(1,PERIOD_D1);
            bar.HighlightBar(clrLawnGreen,"Signal for '4 Strings'");
            CLevel level(signal_level);
            level.Style(STYLE_DOT);
         }
         FourStrings_Fibo_Button.Pressed(false);
      }
      
      if (sparam == "FourStrings_Orders_Button") {
         this.FourStrings_SetEntryPrices();
         this.FourStrings_OpenOrders();
         FourStrings_Orders_Button.Pressed(false);
      }
      
      if (sparam == "BodyLevels_Button") {
         BodyLevels_Button.Pressed(false);
         if ( (Strategy == BF || Strategy == S3) && Period() == PERIOD_H1)
            this.ToggleBodyLevels(Strategy, (ENUM_TIMEFRAMES)Period(), 115, DayPriority);
         if ( (Strategy == BF || Strategy == S3) && Period() == PERIOD_H4)
            this.ToggleBodyLevels(Strategy, (ENUM_TIMEFRAMES)Period(), 128, DayPriority);
         else if (Strategy == D1 && Period() == PERIOD_H1) {
            // find index of the first bar yesterday (it depends on the day of the week)
            int index;
            int Day_of_Week = TimeDayOfWeekMQL4(TimeLocal());
            if (Day_of_Week == 6 || Day_of_Week == 0)
               index = iBarShift(Symbol(),PERIOD_H1,iTime(NULL, PERIOD_D1, 0));
            else
               index = iBarShift(Symbol(),PERIOD_H1,iTime(NULL, PERIOD_D1, 1));
            this.ToggleBodyLevels(Strategy, (ENUM_TIMEFRAMES)Period(), index, DayPriority);
         }
         else
            this.ToggleBodyLevels(Strategy, (ENUM_TIMEFRAMES)Period(), 1000, DayPriority);
      }
       
      
      

      // *************************
      // *** Show / Hide Lines ***
      // *************************
      if ( StringFind(sparam,"m_BtnLines") != -1) {
         Print("m_BtnLines");

         CTrend line(StopLossLineName);
         if (!line.IsVisibleOnTF(Period())) {    // Lines are getting switched ON
            //Print("Lines are now ON");
            TradeLinesVisible = true;
            if (AutoBFTools) this.AlignTradeLines();
         }
         else {
            TradeLinesVisible = false;
            //Print("Lines are now OFF");
         }
         
         if (AutoBFTools && TradeLinesVisible) {
            this.AlignTradeLines();
         }
         TradeManager.UpdatePosVizOfTradeManager();
         TradeManager.UpdateTextOnTradeManagerUI();
         return;
      }
      
      if ( StringFind(sparam,"m_BtnOrderType") != -1 ) {
         // Pending / Instant button on PSC is clicked
         //Print("Order type is clicked");
         CTrend trade_line(EntryLineName);
         trade_line.Select();
         trade_line.Name = StopLossLineName;
         trade_line.Select();
         trade_line.Name = TakeProfitLineName;
         trade_line.Select();
         //UpdateTextOnTradeManagerUI(TradeLinesVisible);
      }
      
      if (sparam == "TM_StatusLED_Label") {
         //Print("TM_StatusLED_Label");
         this.DisplayDistanceEntryLineToClosestLevel();
         
         int trades_on_symbol = this.TradesArray.TradesOpenOnSymbol(Symbol());
         if (trades_on_symbol == 0) {
            // resetting BE and BB levels in settings
            //Print("No trades (" +IntegerToString(trades_on_symbol)+ ") on this symbol - resetting BE and BB levels");
            sets.BreakEvenLevel(0,0);
            sets.BackwardsBreakLevel(0,0);
            sets.SaveSettingsOnDisk();
         }
         
         // generating custom event which will force PSC to think that Show Lines button on it is pressed
         if (!EventChartCustom(ChartID(),PSC_HIDE_SHOW_LINES,0,0,"m_BtnLines")) 
            Print("Couldn't generate a custom event. Error code: ", GetLastError(), ": ", ErrorDescription(GetLastError()));
         else
            //Print("'PSC_HIDE_SHOW_LINES' is sent");
         // ***

         TradeManager.UpdateTradeLinesVisibleValue();
         if (AutoBFTools && this.TradeLinesVisible) {
            // Trade Lines were just turned ON
            UpdateDayPriority(); // updating day priority to aligh trade lines accordingly
            if (Strategy == Stratezhka) this.Order_Type("Pending");
            this.AlignTradeLines();
            TradeManager.SelectTradeLines(true);
            MessageOnChart("Trade Manager: Manual Order Setup", MessageOnChartAppearTime);
            sets.TP_Manual_Control = false;
            this.UpdateVisPosOfRecommendedSLRange();
         }
         else {
            MessageOnChart("Trade Manager is OFF", MessageOnChartAppearTime);
            CTradeLine::Delete_AutoSLMark(); // removes AutoSLMark, if previously created
            sets.TP_Manual_Control = true;
            this.RemoveSLRangeControls();
         }
         this.UpdatePosVizOfTradeManager();
         this.UpdateTextOnTradeManagerUI();
         sets.AutoEntryOnBarClose = false;
         sets.SaveSettingsOnDisk();
         
         if (!this.TradeLinesVisible) {
            //Print("deleting...");
            this.DeleteSpreadThicknessLines();
         }
         return;
      }
      // -- Show / hide lines ---
    
    
    
      // OPEN ORDER
      if(sparam=="TM_Trade_Button") {
         this.TM_Trade_Button_Click();
      }
      // ------ OPEN ORDER --------
      
      //BreakEvenLine.OnClick();  // *** CONTNUE DEVELOPMENT!!! ***
    
     
}



void CTradeManager::TM_Trade_Button_Click() {

   Print(__FUNCTION__);
   
   // removing SL range and spead thickness
   this.RemoveSLRangeControls();
   this.DeleteSpreadThicknessLines();
   
   

   // making sure that the new trade will not be deleted on timer
   sets.AutoDeleteLimitOnTimer = false;
   sets.AutoDeleteLimitOnTimerAt = D'01.01.1970';
   sets.SaveSettingsOnDisk();
   // ************************
   if (!TradeManager.TradeEXE_Alive()) {
      Alert("Attach EA 'Trade.exe' to the chart first");
      return;
   }
   
   
   
   
   // *******************************************************************************************************
   // ************************  "BUY NOW"   |    "SELL NOW"    **********************************************
   // *******************************************************************************************************
   if (TM_Trade_Button.Text() == "BUY NOW" || TM_Trade_Button.Text() == "SELL NOW") {
      // 
      
      MessageOnChart("Processing emergency entry!", MessageOnChartAppearTime);
      short  icon_code;
      string icon_desc;
      if (TM_Trade_Button.Text() == "BUY NOW") {
         icon_code = 249;
         icon_desc = "BUY NOW is clicked by user";
      }
      else {
         icon_code = 249;
         icon_desc = "SELL NOW is clicked by user";
      }
      // 1. Create icon on symbol to record fact of clicking Buy Now / Sell Now
      BarInfoIcon(0, PERIOD_H1, icon_code, clrBlue, icon_desc);
      
      // 2. Delete the only existing limit order on this symbol
      TradeManager.TradesArray.DeleteFirstPendingOrderOnSymbolAndOpenMarketOrder(Symbol());
      // command to Trade.exe is sent; then Trade.exe will respond with TRADE_PENDING_ORDER_DELETED which is
      // then received and processed by TradeManager
      return;
   }
   // *******************************************************************************************************
   
   
   
   // hiding trade lines
   if (!EventChartCustom(ChartID(),PSC_HIDE_SHOW_LINES,0,0,"m_BtnLines")) 
      Print("Couldn't generate a custom event. Error code: ", GetLastError(), ": ", ErrorDescription(GetLastError()));
   else {
      //Print("'PSC_HIDE_SHOW_LINES' is sent");
      ObjectSetMQL4(StopLossLineName,OBJPROP_SELECTED,1);
      ObjectSetMQL4(TakeProfitLineName,OBJPROP_SELECTED,1);
      this.TradeLinesVisible = false;
   }
   TradeManager.TM_Trade_Button.Pressed(false);
   TradeManager.TM_Trade_Button.Hide();
   sets.BreakEvenLevel(0,0); // resetting break even level to make sure the new order will not be affected by BE level from previous order
   sets.BreakEvenPP(0,0,0);
   sets.BackwardsBreakLevel(0,0);
   sets.SaveSettingsOnDisk();
   this.DeleteSpreadThicknessLines();
   this.RemoveSLRangeControls();
   if (!EventChartCustom(ChartID(),TRADE_OPEN_COMMAND,0,0,EnumToString(Strategy))) 
      Print("Couldn't send custom event 'TRADE_OPEN_COMMAND'");
   else {
      Print("'TRADE_OPEN_COMMAND' is sent");
      if (!IsChartInWL(ChartID())) {
         AddChartToWatchlist(HighProbability);
         SignalProbability = ProbabilityInWatchList(ChartID());
         UpdateDayPriority();
         RefreshComment();
         return;        
      }                     
   }
   return;
}




void CTradeManager::PSC_Show_Lines(bool show = true) {

   CTradeLine SL_Line(StopLossLineName);
   if (SL_Line.IsVisibleOnTF(PERIOD_H1) && show) {
      // lines are already visible
      return;
   }
   
   if (!SL_Line.IsVisibleOnTF(PERIOD_H1) && !show) {
      // lines are already hidden
      return;
   }
   
   // if visible and we should hide || not visible and we need to show - send command to PSC

   // generating custom event which will force PSC to think that Show Lines button on it is pressed
   if (!EventChartCustom(ChartID(),PSC_HIDE_SHOW_LINES,0,0,"m_BtnLines")) 
      Print("Couldn't generate a custom event. Error code: ", GetLastError(), ": ", ErrorDescription(GetLastError()));
   //else
      //Print("'PSC_HIDE_SHOW_LINES' is sent");
   // ***

}




void CTradeManager::AlignTradeLines() {
   // Not aligning on weekends - when trades reviews are being done
   int i_today = TimeDayOfWeekMQL4(TimeLocal());
   
   //i_today = 1; /// TEMPORARY FOR DEVELOPMENT ONLY!
   
   if ( (i_today == 6 || i_today == 0) && Symbol() != "ETHBTC" && Symbol() != "BTCUSD" ) {// Check if Saturday or Sunday
      Print("Not aligning trade lines on weekend"); // not to interfere into trade analysis process
      return;
   }
   
   CTradeLine SL_Line(StopLossLineName);
   CTradeLine TP_Line(TakeProfitLineName);
   CTradeLine Entry_Line(EntryLineName);
   
   // 1) Align Entry Line, if it is too far from current price 
   Entry_Line.AlignEntryLine();
   SL_Line.AlignSLLine(DayPriority);
   TP_Line.TPLineToOtherSideIfRequired();
   TP_Line.AlignTPLine();

}









void CTradeManager::UpdateOrderTypeButton() {
   
   string ot = this.Order_Type_Short();
   TM_OrderType_Button.Text(ot);
   
   if (ot == "Pending") 
      ObjectSetInteger(ChartID(),EntryLineName,OBJPROP_SELECTED, true);

   TM_OrderType_Button.Pressed(false);
}



string CTradeManager::Order_Type() {
   bool selectable = ObjectGetInteger(ChartID(),EntryLineName,OBJPROP_SELECTABLE);
   if (selectable) 
      return "Pending";
   else
      return "Instant";
}



string CTradeManager::Order_Type_Short() {
   bool selectable = ObjectGetInteger(ChartID(),EntryLineName,OBJPROP_SELECTABLE);
   if (selectable) 
      return "P";
   else
      return "M";
}


void CTradeManager::Order_Type(string new_type) {
   
   string current_type = this.Order_Type();
   
   if (current_type != new_type) 
      this.ToggleOrderType();
      
}



void CTradeManager::AutoEntryOnBarClose(void) {

   // removing SL range and spread thickness
   this.RemoveSLRangeControls();
   this.DeleteSpreadThicknessLines();

   string success_text;

   if (sets.AutoEntryOnBarClose) {
      // perform auto-entry, if condition is met!
      
      bool entry_condition_met = false;
      string reason_for_non_entry = "";
      CBar bar(1,PERIOD_H1);
      
      TradeDir trade_dir = this.TradeDirection();
      string trade_type;
      if (trade_dir == TradeDir_BUY) trade_type = "buy";
      else if (trade_dir == TradeDir_SELL) trade_type = "sell";
      else trade_type = "none";
      
      if (this.AutoEntryControl.IsPriceWithinInstantRect(iClose(Symbol(),Period(),1))) {
         //instant entry
         Print("Bar closed within instant rectangle");
         this.Order_Type("Instant"); 
         entry_condition_met = true;
         success_text = "Bar closed within instant rect. Opening market "+trade_type+" order...";
      }
      else if (this.AutoEntryControl.IsPriceWithinLimitRect(iClose(Symbol(),Period(),1))) {
         // limit entry
         Print("Bar closed within limit rectangle");
         entry_condition_met = true;
         success_text = "Bar closed within limit rectangle. Opening "+trade_type+" limit order...";
      }
      
      if (entry_condition_met) {
         // additional check for non D1-strategy
         if (Strategy != D1) {
            if (this.AutoEntryControl.TradeDirection == Buy_Level) { 
               if (bar.UpperWick() >= 0.5 * bar.Height()) {
                  entry_condition_met = false;
                  reason_for_non_entry = "Upper wick is > than 50% of bar height. No trades open.";
                  Print(reason_for_non_entry);
               }
            }
            else { // sell setup
               if (bar.LowerWick() >= 0.5 * bar.Height()) {
                  entry_condition_met = false;
                  reason_for_non_entry = "Lower wick is > than 50% of bar height. No trades open.";
                  Print(reason_for_non_entry);
               }
            }
         }
      }
      else {
         reason_for_non_entry = "Bar closed outside of rectangles. No trades open.";
         Print(reason_for_non_entry);
         SendPushAlert(reason_for_non_entry);
      }
      
      
      if (entry_condition_met) {
         // opening trade
         TradeManager.AutoEntryControl.CreateGhostRectangles();
         if (this.SendOpenTradeCommand()) {// command to open trade successfully sent
            // hiding trade lines
            if (!EventChartCustom(ChartID(),PSC_HIDE_SHOW_LINES,0,0,"m_BtnLines")) 
               Print("Couldn't generate a custom event 'PSC_HIDE_SHOW_LINES'. Error code: ", GetLastError(), ": ", ErrorDescription(GetLastError()));
         }
         bar.BarInfoIcon(249,clrGreen,success_text);
      }
      else {
         // condition is not met
         // *** switch off auto-entry mode ***
         HighlightButton(TM_AutoEntry_Button,false);
         sets.AutoEntryOnBarClose = false;
         TradeManager.AutoEntryControl.CreateGhostRectangles();
         TradeManager.AutoEntryControl.ShowControl(false,Levels);
         TradeManager.Order_Type("Instant");
         MessageOnChart("Trade Manager: Manual Entry", MessageOnChartAppearTime);
         bar.BarInfoIcon(249, clrRed,reason_for_non_entry);
         // *** SAVING ALL SETTINGS ***
         sets.SaveSettingsOnDisk();
      }
   }
}


bool CTradeManager::SendOpenTradeCommand(string comment = "") {

   if (!EventChartCustom(ChartID(),TRADE_OPEN_COMMAND,0,0,EnumToString(Strategy) + ": " + comment)) {
      Print("Couldn't send custom event 'TRADE_OPEN_COMMAND'");
      return false;
   }
   else {
      Print("'TRADE_OPEN_COMMAND' is sent"); 
      return true;                 
   }
}




void CTradeManager::Set_BE_BB_Level_Button_Click() {

   if (StringFind(TM_Set_BE_BB_Level_Button.Text(), "Set BE") != -1) { // Set BE button is pressed
      this.Set_BE_Level_Button_Click(); // processing BE level set
      
      // as BE is now set, creating and showing BB line (but not processing its click in this logical branch)
      // show Line and button for backwards break
      if (sets.BackwardsBreakLevel() == 0) { // setting up backwards break level, only if it is not already setup.
         CMetaTrade trade(this.TradesArray.LastOrderOnSymbol_Ticket(Symbol()));
         CTradeLine bb_line(BackwardsBreakLineName);
         bb_line.Price(trade.GetBackwardsBreakPriceDefault(this.GetClosestLevelPriceSameDirection(Levels,true)));
         if (Strategy != D1) this.Set_BB_Level_Button_Click();      
      }
      else {
         Print("BB is already set to: " + DoubleToString(sets.BackwardsBreakLevel(),4));
      }
   }
      else if (StringFind(TM_Set_BE_BB_Level_Button.Text(), "Set BB") != -1) { // Set BB button is pressed (setting backwards-break level)
      this.Set_BB_Level_Button_Click();
         
   }

}


void CTradeManager::TM_NoBE_Button_Click() {
   
   if (sets.NoBEAroundMidnight()) {
      TM_NoBE_Button.Font("Calibri");
      TM_NoBE_Button.Color(clrBlack);
      TM_NoBE_Button.ColorBackground(clrKhaki);
      TM_NoBE_Button.Pressed(false);
      sets.NoBEAroundMidnight(false);
   }
   else {
      TM_NoBE_Button.Font("Calibri Bold");
      TM_NoBE_Button.Color(clrWhite);
      TM_NoBE_Button.ColorBackground(clrGreen);
      TM_NoBE_Button.Pressed(false);
      sets.NoBEAroundMidnight(true);
   }
   sets.SaveSettingsOnDisk();
   EventChartCustom(ChartID(),SETTINGS_CHANGED_BY_METATOOLS,0,0,EnumToString(Strategy));
}




void CTradeManager::Set_BE_Level_Button_Click() {

   CTradeLine be_line(BreakEvenLineName);
   ulong ticket = TradeManager.TradesArray.LastOrderOnSymbol_Ticket(Symbol());
   CMetaTrade trade(ticket);
   sets.BreakEvenLevel(be_line.Price1(),trade.OpenPrice()); 
   Print("New BE Level: ", sets.BreakEvenLevel());
   sets.SaveSettingsOnDisk();
      
   // hide break even controls
   TM_Set_BE_BB_Level_Button.Pressed(false);
   TM_Set_BE_BB_Level_Button.Hide();
   
   // Drawing break-even mark on the chart
   double be = sets.BreakEvenPP()/10;
   if (isOIL()) be = be * 10;
   else if (isCRYPTO()) be = be / 10;
   if (CreateLabelsOnChart)
      TradeManager.Draw_Entry_Mark("BreakEven",trade.Ticket,be_line.Price1(),clrSilver,"BE: " + DoubleToString(be,0));
   
   int BE_Percent = int(sets.BreakEvenPP()/trade.TP_PP()*100);
   be_line.BreakEvenLineSet(sets.BreakEvenPP(), BE_Percent);
   
   MessageOnChart("New Break Even Level: " + DoubleToString(be,1) + "pp", MessageOnChartAppearTime);

   if (!EventChartCustom(ChartID(),TRADE_BREAKEVEN_UPDATED,0,0,"")) 
      Print("Couldn't send custom event 'TRADE_BREAKEVEN_UPDATED'");
   else
      Print("'TRADE_BREAKEVEN_UPDATED' is sent. New break even level: " + DoubleToString(sets.BreakEvenLevel(),5));

}




void CTradeManager::Set_BB_Level_Button_Click() {

   Print("setting BB...");
   CTradeLine bb_line(BackwardsBreakLineName);
   bb_line.BackwardsBreakLineSet();
   
   CMetaTrade trade(TradeManager.TradesArray.LastOrderOnSymbol_Ticket(Symbol()));
   sets.BackwardsBreakLevel(bb_line.Price1(),trade.OpenPrice()); 
   Print("New BB Level: ", sets.BackwardsBreakLevel());
   sets.SaveSettingsOnDisk();
   if (!EventChartCustom(ChartID(),TRADE_BACKWARDSBREAK_UPDATED,0,0,"")) 
      Print("Couldn't send custom event 'TRADE_BACKWARDSBREAK_UPDATED'");
   else {
      Print("'TRADE_BACKWARDSBREAK_UPDATED' is sent. New backwards break level: " + DoubleToString(sets.BackwardsBreakLevel(),5));
   }


   // Drawing break-even mark on the chart
   double bb = sets.BackwardsBreakPP()/10;
   if ( isOIL() ) bb = bb * 10;
   else if (isCRYPTO()) bb = bb / 10;
   string s_bb = DoubleToString(bb,0);
   if (bb < 10) s_bb = DoubleToString(bb,1);
   if (CreateLabelsOnChart)
      TradeManager.Draw_Entry_Mark("BackwardsBreak",trade.Ticket,bb_line.Price1(),clrPink,"BB: " + s_bb, false);
   
   TM_Set_BE_BB_Level_Button.Pressed(false);
   TM_Set_BE_BB_Level_Button.Hide();
   
   MessageOnChart("New Backwards Break Level: " + DoubleToString(bb,1) + "pp", MessageOnChartAppearTime);
}











double CTradeManager::GetClosestLevelPriceSameDirection(CLevel &levels[], ulong ticket) {
   // for already existing trade
   // getting price of the level that is closest to the current price

   // first, let's see if there are any levels today at all
   int levels_count = ArraySize(levels);
   if (levels_count == 0) return 0; // no levels; direction is defined and level found

   CMetaTrade trade(ticket);
   TradeDir trade_dir = trade.TradeDirection();  // for direction of the trade
   TradeDirectionType   TradeDirection;          // for direction of the level
   
   if (trade_dir == TradeDir_BUY) {
      TradeDirection = Buy_Level;
   }
   else { // assuming it is sell
      TradeDirection = Sell_Level;
   }


   if (levels_count == 1 && Levels[0].TradeDirection != TradeDirection) return 0; // there is only one level and its direction is different - same thing as if there are no siutable levels
   if (levels_count == 1 && Levels[0].TradeDirection == TradeDirection) return Levels[0].Price(); // there is only one level and its direction is the same - problem solved - returning the price



   // there are at least 2 level; direction of them is not known yet


   
   // find closest level to the current price, which has the same trading direction as TradeDirection
   double distance = 0;
   CLevel AnchorLevel = levels[0];
   distance = levels[0].DistanceToCurrentPrice();
   
   for (int i = 1; i < levels_count; i++) {
      if (levels[i].TradeDirection != TradeDirection) continue; // skip levels that have different trading directions
      double new_distance = levels[i].DistanceToCurrentPrice();
      if (new_distance == 0) continue;
      if (distance == 0 && new_distance != 0) {
         distance = new_distance;
         AnchorLevel = levels[i];
      }
      else {// now we compare both values, which are not zero (as checked above)
         if (new_distance < distance) {
            distance = new_distance;
            AnchorLevel = levels[i];
         }
      }
   }   

   return AnchorLevel.Price();
}































double CTradeManager::GetClosestLevelPriceSameDirection(CLevel &levels[], bool offset = false) {
   // for not yet opened trade (preparing to enter)

   // get general direction of the trade first based on mutual position of SL and Entry lines
   CTradeLine sl_line(StopLossLineName);
   CTradeLine entry_line(EntryLineName);
   TradeDirectionType   TradeDirection;
   double AnchorLevelPrice;
   
   bool buy = false;
   if (sl_line.Price1() < entry_line.Price1()) { 
      TradeDirection = Buy_Level;
   }
   else {
      TradeDirection = Sell_Level;
   }
   
   
   // now, let's see if there are any levels today at all
   int levels_count = ArraySize(Levels);
   if (levels_count == 0) return 0; // no levels; direction is defined and level found
   
   if (levels_count == 1 && Levels[0].TradeDirection != TradeDirection) return 0; // there is only one level and its direction is different - same thing as if there are no siutable levels
   
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
   
   if (offset) {
      // adding additional margin for Backwards Break Level (not to be exactly on the level)
      double offset_value = 0;
      string symbol = Symbol();
      
      if (symbol == "AUDCAD")      offset_value = 15;
      else if (symbol == "AUDCHF") offset_value = 10;
      else if (symbol == "AUDJPY") offset_value = 15;
      else if (symbol == "AUDNZD") offset_value = 10;
      else if (symbol == "AUDUSD") offset_value = 10;
      else if (symbol == "BRN")    offset_value = 3;
      else if (symbol == "BRENT")  offset_value = 3;
      else if (symbol == "WTI")    offset_value = 3;
      else if (symbol == "CADCHF") offset_value = 7;
      else if (symbol == "CADJPY") offset_value = 8;
      else if (symbol == "CHFJPY") offset_value = 15;
      else if (symbol == "EURAUD") offset_value = 25;
      else if (symbol == "EURCAD") offset_value = 10;
      else if (symbol == "EURCHF") offset_value = 7;
      else if (symbol == "EURGBP") offset_value = 10;
      else if (symbol == "EURJPY") offset_value = 10;
      else if (symbol == "EURNZD") offset_value = 20;
      else if (symbol == "EURUSD") offset_value = 15;
      else if (symbol == "GBPAUD") offset_value = 30;
      else if (symbol == "GBPCAD") offset_value = 20;
      else if (symbol == "GBPCHF") offset_value = 17;
      else if (symbol == "GBPJPY") offset_value = 18;
      else if (symbol == "GBPNZD") offset_value = 30;
      else if (symbol == "GBPUSD") offset_value = 22;
      else if (symbol == "NZDCAD") offset_value = 15;
      else if (symbol == "NZDCHF") offset_value = 10;
      else if (symbol == "NZDJPY") offset_value = 14;
      else if (symbol == "NZDUSD") offset_value = 14;
      else if (symbol == "USDCAD") offset_value = 15;
      else if (symbol == "USDCHF") offset_value = 10;
      else if (symbol == "USDJPY") offset_value = 10;
      else if (symbol == "XAUUSD") offset_value = 60;
      else if (symbol == "BTCUSD") offset_value = 1500;
      else if (symbol == "ETHUSD") offset_value = 30;

      if (TradeDirection == Buy_Level)
         AnchorLevelPrice = AnchorLevelPrice - offset_value*_Point;
      else
         AnchorLevelPrice = AnchorLevelPrice + offset_value*_Point;
   }
   
   return AnchorLevelPrice;
}




void CTradeManager::ProcessBroadcastEvents(int id, long lparam) {


   // ============================ Trade.exe events processing ============================   
   if (id == TRADE_EXE_LIVE + 1000) {
      //Print("TRADE_EXE_LIVE event received. lparam = ", IntegerToString(lparam));
      if (!TradeManager.TradeEXE_Alive()) {
         TradeManager.TradeEXE_Alive(true);
         
         if (lparam == 1 && MarketInfoMQL4(_Symbol,MODE_TRADEALLOWED)) TradeAllowed = true;
         else TradeAllowed = false;
         
         TradeManager.UpdateTradeLinesVisibleValue();
         TradeManager.UpdatePosVizOfTradeManager();
         TradeManager.UpdateTradeManagerStatusLED();
      }
      TradeEXE_LastSignalReceived_Datetime = TimeLocal(); // to remember last time when LIVE PING was received from Trade.exe      
      return;
   }
   
   if (id == TRADE_EXE_DETACHED + 1000) {
      TradeManager.TradeEXE_Alive(false);
      TradeManager.UpdateTradeLinesVisibleValue();
      TradeManager.UpdatePosVizOfTradeManager();
      TradeManager.UpdateTradeManagerStatusLED();
      return;
   }
   
   
   
   if (id == TRADE_OPENED + 1000) {
      
      // ***** POST-TRADE_OPENED SEQUENCE BEGINS HERE *****
      int ticket = (int)lparam;
      //Print("TRADE_OPENED msg is received. Ticket: ", IntegerToString(lparam));
      CMetaTrade trade(ticket);
      if (Strategy != FourStrings && CreateLabelsOnChart) this.DrawEntryMarks(ticket);
      // ***
      bool also_save_screenshot = true;
      if (!S_Version) {
         if ( AutoSaveTemplateAndScreenshotUponTrade )
            SaveTemplateAndScrenshot(also_save_screenshot); // save template and screenshot
         WatchListButtonsClickHandler("WL1_Button"); // switch HoursDelay to 1
      }
      // resetting previous value of backwards break level to zero, to make sure the backwards break control will appear to setup new value
      
      
      
      // ****************************************************************************************
      // **** SET BE and BB levels to the same price as previous limit order ********
      // get ticket number of the last order in the history (the one just closed)
      // 
      ulong last_order_ticket = 0;
      bool order_selected = false;
      #ifdef __MQL5__
         last_order_ticket = HistoryOrderGetTicket(HistoryOrdersTotal()-1);
         if (last_order_ticket != 0) order_selected = true;
      #else 
         order_selected = OrderSelect( OrdersHistoryTotal() - 1,SELECT_BY_POS, MODE_HISTORY);
         last_order_ticket = OrderTicket();
      #endif 
      
      if ( order_selected ) {
         Print("Last Order Ticket: " + IntegerToString(last_order_ticket));
      }
      else
         Print("Could not find last order");
      
      // find BB and BE level marks (related to the last order in history) on the chart to read prices from it
      int obj_total = ObjectsTotalMQL4();
      string obj_name = "";
      int obj_count = 0;
      double be_price_of_deleted_limit = 0;
      double bb_price_of_deleted_limit = 0;
      for (int i = obj_total-1; i >= 0; i--) {
         obj_name = ObjectNameMQL4(i);
         if ( ObjectTypeMQL4(obj_name) != OBJ_TREND) continue;
         // trend found
         CTrend mark(obj_name);
         if (!mark.IsHorizontal()) continue;
         if ( StringFind(mark.Name,"BreakEven for #") != -1 && StringFind(mark.Name,IntegerToString(last_order_ticket)) != -1 && ObjectDescriptionMQL4(mark.Name) == "DELETED" ) {
            // BE mark for the last historical order is found!
            //Print("BE price from last historical order: " + mark.Price1());
            be_price_of_deleted_limit = mark.Price1(); 
            ObjectDeleteSilent(mark.Name); // deleting the found mark not to be used in the future orders.
         }
         else {
            if ( StringFind(mark.Name,"BackwardsBreak for #") != -1 && StringFind(mark.Name,IntegerToString(last_order_ticket)) != -1 && ObjectDescriptionMQL4(mark.Name) == "DELETED" ) {
               // BB mark for the last historical order is found!
               //Print("BB price from last historical order: " + mark.Price1());
               bb_price_of_deleted_limit = mark.Price1();
               ObjectDeleteSilent(mark.Name); // deleting the found mark not to be used in the future orders.
            }
         }
      }
      // ****************************************************************************************
      // ****************************************************************************************
      // ****************************************************************************************

      // resetting BB settings in the settings class
      sets.BackwardsBreakLevel(0,0);
      sets.BackwardsBreakPP(0,0,0);
      
      // resetting auto-delete-limit order settings
      sets.AutoDeleteLimitOnTimer = false;
      sets.AutoDeleteLimitOnTimerAt = D'01.01.1970';
      sets.SaveSettingsOnDisk();
      // *************************
      
      MessageOnChart("New trade opened. SL = " + DoubleToString(trade.SL(),5), MessageOnChartAppearTime);
      if (Strategy != FourStrings) this.ToggleBreakEvenControls(true,ticket); // start to setup Break Even Level
      this.TradesArray.Update();
      if (CreateLabelsOnChart)
         this.ShowSLinMoney();
      
      
      if (sets.AutoEntryOnBarClose) {
         // *** POST-AUTO-ENTRY SEQUENCE ***
         Print("AutoEntryOnBarClose: Setting up default BE and BE Levels...");
         
         // *** SETTING DEFAULT BREAK EVEN LEVEL - JUST SIMULATING USER ACTION - MOVING BE LINE TO DEFAULT POSITION  ***
         CTradeLine be_line(BreakEvenLineName);
         int trade_index = TradeManager.TradesArray.LastOrderOnSymbol_index(Symbol());
         be_line.Price1(TradeManager.TradesArray.Trades[trade_index].GetBreakEvenPriceDefault());
         //sets.BreakEvenLevel(be_line.Price1(),TradeManager.TradesArray.Trades[trade_index].OpenPrice());
         this.Set_BE_BB_Level_Button_Click();
         // ************************************************
         
         // *** SETTING DEFAULT BACKWARDSBREAK LEVEL - JUST SIMULATING USER ACTION - CREATING BB LINE IN DEFAULT POSITION ***
         CTradeLine bb_line(BackwardsBreakLineName);
         bb_line.Price(TradeManager.TradesArray.Trades[trade_index].GetBackwardsBreakPriceDefault(this.GetClosestLevelPriceSameDirection(Levels,true)));
         //sets.BackwardsBreakLevel(bb_price,TradeManager.TradesArray.Trades[trade_index].OpenPrice());
         if (Strategy != D1) this.Set_BB_Level_Button_Click();
         // ************************************************
         
         // *** switch off auto-entry mode ***
         HighlightButton(TM_AutoEntry_Button,false);
         sets.AutoEntryOnBarClose = false;
         
         TradeManager.AutoEntryControl.ShowControl(false,Levels);
         TradeManager.Order_Type("Instant");
         TM_Trade_Button.Show();
         MessageOnChart("Trade Manager: Manual Entry", MessageOnChartAppearTime);
         
         // *** SAVING ALL SETTINGS ***
         sets.SaveSettingsOnDisk();
         // *** END OF POST AUTO-ENTRY SEQUENCE ***
      }
      else
         Print("sets.AutoEntryOnBarClose = OFF");
      
      if (Strategy == FourStrings) this.FourStrings_OpenOrders(); // cycle opening 
      
      return;
      // ***** POST-TRADE_OPENED SEQUENCE ENDS HERE *****
   }
   
   if (id == TRADE_OPEN_FAILED + 1000) {
      MessageOnChart("Could NOT open trade", MessageOnChartAppearTime);
   }
   
   if (id == TRADE_SL_MOVED_TO_BREAKEVEN + 1000) {
      TM_BE_ML_Button.Hide();
      MessageOnChart("Stop Loss moved to Break Even", MessageOnChartAppearTime);
   }   
   
   if (id == TRADE_TP_MOVED_TO_MINLOSS + 1000) {
      TM_BE_ML_Button.Hide();
      MessageOnChart("Take Profit moved to Min Loss", MessageOnChartAppearTime);
   }      
   
   if (id == TRADE_TP_MOVE_TO_MINLOSS_FAILED + 1000) {
      //......
      CBar bar(1,PERIOD_H1);
      bar.BarInfoIcon(172, clrRed,"Could not move TP->ML after 5 attempts");
   }  
   
   
   if (id == TRADE_CLOSED + 1000) {
      TradeManager.TradesArray.Update();
      MessageOnChart("Trade Closed", MessageOnChartAppearTime);
   }
   
   if (id == TRADE_PENDING_ORDER_DELETED_OPEN_MARKET_ORDER + 1000) {
   
      //Print("Ticket of deleted pending order: " + IntegerToString(lparam));
   
      // 2. Deleting trading marks from the last pending order
      ObjectDeleteSilent("SL_in_Money_Label");
      
      // searching for all entry marks that have its number in their name to delete them
      int obj_total = ObjectsTotalMQL4();
      string obj_name = "";
      int obj_count = 0;
      for (int i = obj_total-1; i >= 0; i--) {
         obj_name = ObjectNameMQL4(i);
         // do not delete BB and BE lines - they can be used to set BB and BE levels to the same price levels
         if (StringFind(obj_name,"BackwardsBreak for #") != -1 || StringFind(obj_name,"BreakEven for #") != -1) {
            ObjectSetTextMQL4(obj_name,"DELETED"); // mark to then detect that this is the last deleted pending order once the new order will be open
            continue;
         }
            
         if (StringFind(obj_name,IntegerToString(lparam)) != -1 ) {
            ObjectDeleteSilent(obj_name);
            obj_count++;
         }
      }
      Print("Objects deleted: " + IntegerToString(obj_count));  
      
      
      // 3. Switch the Trade Lines on
      this.PSC_Show_Lines(true);
      
      // 4. Switch entry mode to "On Market"
      if ( this.Order_Type() != "Instant" ) this.ToggleOrderType();
      
      // 5. Immitate clicking on the "BUY" / "SELL" button to open market trade
      // preparing Trade Manager
      this.UpdateTradeLinesVisibleValue();
      this.UpdatePosVizOfTradeManager();
      this.UpdateTradeManagerStatusLED();
      this.UpdateTextOnTradeManagerUI();
      // clicking on the button
      this.TM_Trade_Button_Click();
      
      // no further sequential actions beyond this point!
      // we should catch ORDER_OPENED message in TradeManager and process it there.
      // ***************************************************************************
      // при отлавливании события TRADE_OPENED будет произведен поиск меток с текстом DELETED в их описании и по ним будут определены ранее установленные ВВ и ВЕ уровни
   }
   // ====================================================================================


}



void CTradeManager::AlertOnPossibleThreateningBar(double ATR) {

   if (Strategy == FourStrings && sets.FourStringsAutoMode) return; // do not check on possible bars against trade, if we are in Four Strings strategy in automated mode

   CMetaTrade trades_array_on_symbol[]; 
   this.TradesArray.TradesArrayOnSymbol(Symbol(), trades_array_on_symbol); // passing by reference

   if (Current_H1_Bar.IsPossibleThreat(ATR, trades_array_on_symbol)) {
      string msg = EnumToString(Strategy) + "|" + Symbol() + ": Possible bar against trade!";
      //if (DebugMode) Print(msg);
   
      if (!sets.InformedAbThreat)  {  
         ChartCheckNeededSet(PositionThreat,Current_H1_Bar.BarSymbol(),ChartID());
         if (IsPushControlON())
            if (!SendNotification(msg)) Print("Error sending push notification '"+ msg +"'");
            else Print("Push Notification Sent: " + msg);
         
         //Current_H1_Bar.InformedAboutPossibleThreatSet(); 
         sets.InformedAbThreat = true;
         sets.SaveSettingsOnDisk();
       }
       //else
       //  if (DebugMode) Print("Already informed about possible threat");
   }
   //else 
      //if (DebugMode) Print("No threat to position detected");
}



TradeDir CTradeManager::TradeDirection() {

   CTradeLine sl(StopLossLineName);
   CTradeLine el(EntryLineName);
   
   if (!sl.IsExist()) return TradeDir_NONE;
   if (!sl.IsExist()) return TradeDir_NONE;
   
   if (sl.Price() < el.Price()) return TradeDir_BUY;
   if (sl.Price() > el.Price()) return TradeDir_SELL;
   
   return TradeDir_NONE;
}











void CTradeManager::UpdateAutoDeleteLimitOnTimerControls() {
   // happends every second, but only on active chart

   if (OrdersTotal() < 1 || Strategy == FourStrings) {
      this.HideAutoDeleteLimitOnTimerControls();
      return;
   }
   
   
   // try to auto-delete on timer right here
   if (this.Delete_Limit_Order_On_Timer()){
      this.HideAutoDeleteLimitOnTimerControls();
      return;
   }
   //
   

   int LastLimitOrderIndex = this.TradesArray.LastLimitOrderOnSymbol_index(Symbol());

   if (LastLimitOrderIndex != -1 && !TM_Set_BE_BB_Level_Button.IsVisible() && this.TradesArray.LimitTradesCountOnSymbol(Symbol()) == 1) {
      int x,y;
      double PricePosition = this.TradesArray.Trades[LastLimitOrderIndex].OpenPrice();
      datetime TimePosition = Tomorrow()+HR2400/2;   
      ChartTimePriceToXY(0,0,TimePosition, PricePosition,x,y);    
   
      //выставить правильные координаты позиции рядом с единственным активным лимит-ордеров
      if (Period() == PERIOD_D1) x = x + 35;
      TM_AutoDeleteLimitOnTimer_Button.Move(x,y);
      TM_AutoDeleteLimitOnTimerLess_Button.Move(x+75,y);
      TM_AutoDeleteLimitOnTimerMore_Button.Move(x+97,y);
      
      TM_AutoDeleteLimitOnTimer_Button.Show();
      TM_AutoDeleteLimitOnTimerMore_Button.Show();
      TM_AutoDeleteLimitOnTimerLess_Button.Show();
      
      // counting down
      if (sets.AutoDeleteLimitOnTimer) {
         datetime TimeLeft = sets.AutoDeleteLimitOnTimerAt - TimeCurrent();
         HighlightButton(TM_AutoDeleteLimitOnTimer_Button,true,false,clrRed);
         TM_AutoDeleteLimitOnTimer_Button.Text(TimeToString(TimeLeft,TIME_SECONDS));
      }
   }
   else {
      this.HideAutoDeleteLimitOnTimerControls();
   }
}




bool CTradeManager::Delete_Limit_Order_On_Timer() {
   // happends every 10 sec, but on all charts (doesn't matter, if active or not)
   // returns true, if limit order was deleted

   if (!sets.AutoDeleteLimitOnTimer) return false;
   int limit_trades_count = TradesArray.LimitTradesCountOnSymbol(Symbol());
   if (limit_trades_count < 1) {
      sets.AutoDeleteLimitOnTimer = false;
      sets.AutoDeleteLimitOnTimerAt = D'01.01.1970';
      sets.SaveSettingsOnDisk();
      return false;
   }
   datetime blank_value = D'01.01.1970';
   if (sets.AutoDeleteLimitOnTimerAt == blank_value) {
      string msg = "Auto-Delete Limit Order on Timer is ON, but timer is not set";
      Print(msg);
      MessageOnChart(msg, MessageOnChartAppearTime);
      if (DebugMode) Print("sets.AutoDeleteLimitOnTimerAt = ", sets.AutoDeleteLimitOnTimerAt);
      return false;
   }
   
   int TradesCount = this.TradesArray.TradesCount(); // total orders count on this symbol; needed for further 'for' cycle later in this method
   
   if (limit_trades_count < 1) return false;
   if (limit_trades_count > 1) {
      MessageOnChart(">1 limit orders: orders will NOT be auto-deleted on timer!", MessageOnChartAppearTime);
      return false;
   }
   
   for (int i = TradesCount-1; i >= 0; i--) {
      if (TradesArray.Trades[i].IsLimitOrder() && TradesArray.Trades[i].TradeSymbol() == Symbol() && TimeCurrent() >= sets.AutoDeleteLimitOnTimerAt) {
         MessageOnChart("Timer expired - closing limit order #" + IntegerToString(TradesArray.Trades[i].Ticket) + ".", MessageOnChartAppearTime);
         if (DebugMode) Print("sets.AutoDeleteLimitOnTimerAt = " + TimeToString(sets.AutoDeleteLimitOnTimerAt));
         sets.AutoDeleteLimitOnTimer = false;
         sets.AutoDeleteLimitOnTimerAt = D'01.01.1970';
         Print("Timer expired - closing limit order #" + IntegerToString(TradesArray.Trades[i].Ticket) + ".");
         if (!EventChartCustom(ChartID(),TRADE_CLOSE_COMMAND,TradesArray.Trades[i].Ticket,0,"")) {
            Print("Couldn't send custom event 'TRADE_CLOSE_COMMAND'");
            Current_H1_Bar.BarInfoIcon(76,clrRed,"Could NOT broadcast closing command for Limit Order On Timer");
            return false;
         }
         else {
            Print("'TRADE_CLOSE_COMMAND' is sent");
            Current_H1_Bar.BarInfoIcon(185,clrRed,"Limit Order Closed On Timer Expiration");
            return true;
         }
      }
   }
   return false;
}







void CTradeManager::HideAutoDeleteLimitOnTimerControls() {
      TM_AutoDeleteLimitOnTimer_Button.Hide();
      TM_AutoDeleteLimitOnTimerMore_Button.Hide();
      TM_AutoDeleteLimitOnTimerLess_Button.Hide();
      HighlightButton(TM_AutoDeleteLimitOnTimer_Button,false);
      TM_AutoDeleteLimitOnTimer_Button.Text("Delete After");
}







bool CTradeManager::FourStrings_FiboSetup() {
   // setup Fibo, if D1-level is broken

   // First check, if conditions are met
   
   // Strategy
   if (Strategy != FourStrings) return false;
   
   // Yesterday D1 bar broken D1 blue horizontal trend, which provides trade direction for today?
   TradeDir TradeDirection = this.FourStrings_TradeDirection(); 
   Print("TradeDirection = " + EnumToString(TradeDirection));
   if (TradeDirection == TradeDir_NONE) {
      MessageOnChart("Trading direction cannot be detected", MessageOnChartAppearTime);
      return false;
   }
   // check step by step and perform everything that is missing
   
   // 1. Build Fibo's
   // check if already exist
   CFibo fibo();
   CFibo BigFibo(fibo.FourStrings_BigFiboName());
   CFibo SmallFibo(fibo.FourStrings_SmallFiboName());
   
   if (!BigFibo.IsExist()) {
      Print("At least Big Fibo does not exist. Creating...");
      BigFibo.CreateFibosForYesterday(TradeDirection);
   }
   

   // 2. Check, if opening of today is deeper than 50% of big fibo. If deeper - NO trades for today for Four String
   double RetracementFromBigFibo = BigFibo.FiboRetracement();
   Print("Achieved retracement = " + DoubleToString(RetracementFromBigFibo,1) + "%");
   string txt_label_name = "FourStrings Label for " + TimeToString(TimeCurrent(),TIME_DATE);
   ObjectDeleteSilent(txt_label_name);
   if (TradeDirection == TradeDir_BUY) {
      if (iOpen(Symbol(),PERIOD_D1,0) < BigFibo.GetPriceOfFiboLevel(50)) {
         MessageOnChart("Today opened below fibo 50%; no trades for '4 Strings'", MessageOnChartAppearTime);
         ObjectCreate(ChartID(),txt_label_name,OBJ_TEXT,0,iTime(Symbol(),PERIOD_D1,0)+60*60*12,BigFibo.Price1());
         ObjectSetString(ChartID(),txt_label_name,OBJPROP_TEXT,"Open Price < 50%");
         ObjectSetInteger(ChartID(),txt_label_name,OBJPROP_FONTSIZE,8);
         ObjectSetInteger(ChartID(),txt_label_name,OBJPROP_COLOR,clrRed);
         ObjectSetInteger(0,txt_label_name,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1);
         return false;
      }
   }
   else { // sell case
      if (iOpen(Symbol(),PERIOD_D1,0) > BigFibo.GetPriceOfFiboLevel(50)) {
         MessageOnChart("Today opened above fibo 50%; no trades for '4 Strings'", MessageOnChartAppearTime); 
         ObjectCreate(ChartID(),txt_label_name,OBJ_TEXT,0,iTime(Symbol(),PERIOD_D1,0)+60*60*12,BigFibo.Price1());
         ObjectSetString(ChartID(),txt_label_name,OBJPROP_TEXT,"Open Price > 50%");
         ObjectSetInteger(ChartID(),txt_label_name,OBJPROP_FONTSIZE,8);
         ObjectSetInteger(ChartID(),txt_label_name,OBJPROP_COLOR,clrRed);
         ObjectSetInteger(0,txt_label_name,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1);
         return false;
      }
   }

   // 3. Check if we shall extend fibo with a new high of the current day
   // 3.1. Check if today opening was not further, which would mean we need to extend the fibo first.
   if (TradeDirection == TradeDir_BUY) {
      if (iOpen(Symbol(),PERIOD_D1,0) > BigFibo.GetPriceOfFiboLevel(0)) {
         // then we extend Fibo's
         BigFibo.Price2(iOpen(Symbol(),PERIOD_D1,0));
         SmallFibo.Price2(BigFibo.GetPriceOfFiboLevel(61.8));
      }
   }
   else { // SELL CASE
      if (iOpen(Symbol(),PERIOD_D1,0) < BigFibo.GetPriceOfFiboLevel(0)) {
         // then we extend Fibo's
         BigFibo.Price2(iOpen(Symbol(),PERIOD_D1,0));
         SmallFibo.Price2(BigFibo.GetPriceOfFiboLevel(61.8));
      }
   }
   
   // 3.b. Make sure that retracement of 23.6 of yesterday big Fibo was not yet reached during today
   if (RetracementFromBigFibo < 23.6) {
      // then we check, if there was a high today that is higher than yesterday
      if (TradeDirection == TradeDir_BUY) {
         if (iHigh(Symbol(),PERIOD_D1,0) > iHigh(Symbol(),PERIOD_D1,1)) {
             // there is a new high = extending the big fibo!
             Print("Extending big Fibo to new today's high");
             BigFibo.Price2(iHigh(Symbol(),PERIOD_D1,0));
             SmallFibo.Price2(BigFibo.GetPriceOfFiboLevel(61.8)); // updating small fibo too
         }
      }
      else { // for sell case
         if (iLow(Symbol(),PERIOD_D1,0) < iLow(Symbol(),PERIOD_D1,1)) {
             // there is a new low = extending the big fibo!
             Print("Extending big Fibo to new today's low");
             BigFibo.Price2(iLow(Symbol(),PERIOD_D1,0));
             SmallFibo.Price2(BigFibo.GetPriceOfFiboLevel(61.8)); // updating small fibo too
         }
      }
   }
   
   
   // 4. If 61.8 is aleady achieved - NO further trades today
   if (RetracementFromBigFibo >= 61.8) {
      MessageOnChart("61.8% retracement is already achived - no further trades today for '4 Strings'", MessageOnChartAppearTime); 
      ObjectDeleteSilent(txt_label_name);
      ObjectCreate(ChartID(),txt_label_name,OBJ_TEXT,0,iTime(Symbol(),PERIOD_D1,0)+60*60*12,BigFibo.Price1());
      ObjectSetString(ChartID(),txt_label_name,OBJPROP_TEXT,"61.8% achieved");
      ObjectSetInteger(ChartID(),txt_label_name,OBJPROP_FONTSIZE,8);
      ObjectSetInteger(ChartID(),txt_label_name,OBJPROP_COLOR,clrRed);
      ObjectSetInteger(0,txt_label_name,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1);
      return false;
   }
  
   return true;
 
}



bool CTradeManager::FourStrings_SetEntryPrices() {
   
   CFibo fibo();
   CFibo BigFibo(fibo.FourStrings_BigFiboName());
   if (!BigFibo.IsExist()) {
      MessageOnChart("Create Fibo's first", MessageOnChartAppearTime);
      return false;
   }
   double RetracementFromBigFibo = BigFibo.FiboRetracement();
   
   ArrayInitialize(FourStrings_EntryPrices,0);
   
   if (RetracementFromBigFibo >= 61.8) {
      MessageOnChart("61.8% retracement is already achived - no further trades today for '4 Strings'", MessageOnChartAppearTime);
      return false;
   }
   
   
   // Later on - learn how to collect spread stats during the day and use it, instead of fixed values
   SpreadHistory.LoadSpreadHistoryFromDisk();
   double spread = SpreadHistory.AvgSpread()*10;
   //if (Symbol() == "EURNZD") spread = 45;
   //else if (Symbol() == "EURAUD") spread = 35;
   //else spread = 20;
   
   spread = spread * _Point;
   if (BigFibo.GetPriceOfFiboLevel(0) > BigFibo.GetPriceOfFiboLevel(100)) // BUY case
      //spread = MathAbs(Bid-Ask);
      spread = spread;
   else // SELL case
      //spread = -MathAbs(Bid-Ask);
      spread = spread * -1;
      

   if (RetracementFromBigFibo < 61.8) {
      FourStrings_EntryPrices[3] = BigFibo.GetPriceOfFiboLevel(61.8) + spread;
   }   
   if (RetracementFromBigFibo < 50) {
      FourStrings_EntryPrices[2] = BigFibo.GetPriceOfFiboLevel(50.0) + spread;
   }
   if (RetracementFromBigFibo < 38.2) {
      FourStrings_EntryPrices[1] = BigFibo.GetPriceOfFiboLevel(38.2) + spread;
   }
   if (RetracementFromBigFibo < 23.6) {
      FourStrings_EntryPrices[0] = BigFibo.GetPriceOfFiboLevel(23.6) + spread;
   }
   return true;
}




void CTradeManager::FourStrings_OpenOrders() {

   // Opens pending orders for each non-zero value from FourStrings_EntryPrices[] array
   // If no such values left - not opening any orders
   // this method is called from 
   //    a) Pressing "Orders" button (FourStrings_Orders_Button)
   //    b) in the end of "TRADE_OPENED" response sequence (it loops until all the orders are opened)

   // 5. Opening Pending orders
   // 5.1. Make sure Trading Lines are on
   CTradeLine SL_Line(StopLossLineName);
   CTradeLine Entry_Line(EntryLineName);
   CTradeLine TP_Line(TakeProfitLineName);
   CFibo fibo();
   CFibo SmallFibo(fibo.FourStrings_SmallFiboName());
   CFibo BigFibo(fibo.FourStrings_BigFiboName());
   TradeDir TradeDirection = this.FourStrings_TradeDirection();
   
   // 5.2. Make sure that Order Type chosen is Pending
   if (this.Order_Type_Short() != "P") this.ToggleOrderType();
   

   // 5.3. Setting up pending order for first price that is not 0
   
   for (int i = 0; i < ArraySize(FourStrings_EntryPrices); i++) {
      // [0] = 23.6
      // [1] = 38.2
      // [2] = 50
      // [3] = 61.8
      if (FourStrings_EntryPrices[i] == 0) {
         // hiding trade lines
         if (SL_Line.IsVisibleOnTF(PERIOD_H1)) {
            EventChartCustom(ChartID(),PSC_HIDE_SHOW_LINES,0,0,"m_BtnLines");
         }
         continue; // skip all levels where price is 0; process only levels with non-zero prices
      }
      // check if an order (active or pending) already exists. If yes - skip this level
      this.TradesArray.Update();
      
      
      double FiboLevel; // Fibo level that is being checked
      // check, if there is already a trade on this symbol for the same fibo level (look in trade's comment)
      if (i == 0) FiboLevel = 23.6;
      else if (i == 1) FiboLevel = 38.2;
      else if (i == 2) FiboLevel = 50;
      else if (i == 3) FiboLevel = 61.8;
      else break; // there cannot be and should not be more that 4 levels;
      
      // checking if there is already an order opened for this level
      if (this.TradesArray.TradesOpenOnSymbolAtFiboLevel(Symbol(),FiboLevel) > 0) {
         string msg = "Order already opened for Fibo " + DoubleToString(FiboLevel,1) + "% @ " + Symbol();
         MessageOnChart(msg, MessageOnChartAppearTime);
         Print(msg);
         FourStrings_EntryPrices[i] = 0; // reset that level
         continue;
      }
      
      
      // Show Trade Lines
      if (!SL_Line.IsVisibleOnTF(PERIOD_H1)) {   
         // generating custom event which will force PSC to think that Show Lines button on it is pressed
         if (!EventChartCustom(ChartID(),PSC_HIDE_SHOW_LINES,0,0,"m_BtnLines")) 
            Print("Couldn't generate a custom event. Error code: ", GetLastError(), ": ", ErrorDescription(GetLastError()));
      }
      
      // setting up entry level and SL
      Entry_Line.Price(FourStrings_EntryPrices[i]);
      // setting up SL level. First we check, if there is enough distance between 61.8 and 100% of Big Fibo
      double dist_btw_618_and_100 = MathAbs(BigFibo.GetPriceOfFiboLevel(61.8) - BigFibo.GetPriceOfFiboLevel(100)) / _Point;
      if (dist_btw_618_and_100 < MinDistBigFibo618_100_ForSL_pp) 
         SL_Line.Price(BigFibo.GetPriceOfFiboLevel(100)); // set SL behind 100% of BigFibo
      else
         SL_Line.Price(SmallFibo.GetPriceOfFiboLevel(61.8)); // setting up SL on the 61.8 of small fibo
      

      
      SpreadHistory.LoadSpreadHistoryFromDisk();
      double spread = SpreadHistory.AvgSpread()*10;
      if (spread <= 0) spread = 10;
      double delta;
      if (Symbol() == "EURNZD" || Symbol() == "EURUAD") delta = 35;
      else delta = 30;
      
      // trade-direction-specific logic (setting up SL and TP lines): shift SL and setup TP
         if (TradeDirection == TradeDir_BUY) {
            SL_Line.Price(SL_Line.Price() - delta*_Point); // shift SL slightly under 61.8
            double sl_size = MathAbs(Entry_Line.Price() - SL_Line.Price());
            TP_Line.Price(Entry_Line.Price() + sl_size * (i+1) );
         }
         else { // SELL CASE
            SL_Line.Price(SL_Line.Price() + (spread+20)*_Point); // shift SL slightly above 61.8
            double sl_size = MathAbs(SL_Line.Price() - Entry_Line.Price());
            TP_Line.Price(Entry_Line.Price() - sl_size * (i+1) );
         }
      

      // 5.3 Opening the trade:
      string comment;
      if (i == 0) comment = "23.6%";
      else if (i == 1) comment = "38.2%";
      else if (i == 2) comment = "50%";
      else if (i == 3) comment = "61.8%";
      
      if (SendOpenTradeCommand(comment)) {
         FourStrings_EntryPrices[i] = 0; // set value of this price to zero not to open any new orders for it in the future
         if (!IsChartInWL(ChartID())) {
            AddChartToWatchlist(HighProbability);
            SignalProbability = ProbabilityInWatchList(ChartID());
            UpdateDayPriority();
            RefreshComment();  
         }   
      }
      break; // once an order is opened - 
   } // for cycle through each Fibo level (for each entry price)

}







TradeDir CTradeManager::FourStrings_TradeDirection() {

   int obj_total=ObjectsTotalMQL4(); //total objects count
   //Print("obj_total = ", obj_total);
   for(int i=obj_total-1; i>=0; i--) { // for each object on the chart
      string objectName = ObjectNameMQL4(i);    // getting the object name
      //Print("[" + i + "] = " + objectName);
      //if (StringLen(objectName) == 0) Print("Error: couldn't get the name of object " + i);
      //if (objectName == "Trendline 41675") Print("index = " + i + "; objType = ", ObjectTypeMQL4(objectName));
      if (ObjectTypeMQL4(objectName) == OBJ_TREND) {
         CTrend trend(objectName);
         color clr = trend.Color();
         if (clr != clrGreen && clr != clrRed) continue;
         if (trend.Price1() == trend.Price1()) { // line is horizontal
            if (trend.Style() == STYLE_SOLID && trend.IsVisibleOnTF(PERIOD_D1)) { // line is solid     
               if (trend.DateTime1() > TimeCurrent() || trend.DateTime2() > TimeCurrent()) { // trend should extend into the future
                  // check if there was a break by yesterday D1-bar
                  double d1_open = iOpen(Symbol(),PERIOD_D1,1);
                  double d1_close = iClose(Symbol(),PERIOD_D1,1);
                  double level_price = trend.Price1();
                  if ( d1_open < level_price && d1_close > level_price && clr == clrGreen) return TradeDir_BUY;
                  if ( d1_open > level_price && d1_close < level_price && clr == clrRed)   return TradeDir_SELL;
               }
            }
         }
      }
   } // for

   return TradeDir_NONE;
}






void CTradeManager::FourStrings_OnNewDay() {
   // called only when new D1 bar is opened
   // test, if it works on Monday at 00:00!

   

   if (sets.FourStringsAutoMode) { // if "4 Strings Auto" button is on
   
      //--- Подтягиваем автоматические Д1-уровни вправо
      this.FourStrings_ExtendD1Levels();
   
      this.TradesArray.Update();
      
      // 1. If new day started - delete yesterday pending orders
      this.TradesArray.FourStrings_DeleteYesterdayPendingOrdersOnSymbol(Symbol());
      
      // проверка можно ли торговать на основании только что закрывшегося дня (соблюдаются ли условия, чтобы ставить Фибо). Если да - поставить Фибо и ордера
      if (this.FourStrings_FiboSetup()) {
         // значит есть пробой Д1-уровня и можно торговать ставить отложенные ордера
         if (this.FourStrings_SetEntryPrices()) {
            // удалось устновить цены - устанавливаем отложенные ордера
            this.FourStrings_OpenOrders();
            string signal_level = this.FourStrings_IsSignalOnD1Yesterday();
            if (signal_level != "") {
               CBar bar(1,PERIOD_D1);
               bar.HighlightBar(clrLawnGreen,"Signal for 'Four Strings'");
               CLevel level(signal_level);
               level.Style(STYLE_DOT);
            }
         }
      }
   } 
}



         
         
         
         
         

void CTradeManager::FourStrings_OnCalculate() {

   // This method is called only if it is 'Four Strings' strategy (checked in the main OnCalculate method of Meta Tools.mq4)
   // check if there is a new high / low of the day
   // if yes, and there are no active orders yet - extend fibo; and reposition orders
   
   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(Symbol() ,Latest_Price); // Assign current prices to structure 
   
   // 1. If today is Friday, check, if it is 20:00 already, or later. If so, - close pending orders opened today
   if (DayOfWeekMQL4() == 5 && sets.FourStringsAutoMode) { // Friday
      if (HourMQL4() >= 20) {
         this.TradesArray.Update();
         if (this.TradesArray.TradesPendingOnSymbol(Symbol())){
            this.TradesArray.FourStrings_DeleteTodayPendingOrdersOnSymbol(Symbol());
         }
      }
   }
   
   
   //1. Check, if there is already an active order on this pair with comment "FourStrings"
   CFibo fibo();
   CFibo BigFibo(fibo.FourStrings_BigFiboName());
   
   // Show BE Levels for each pending or active 'Four Strings' order
   
   CMetaTrade orders_array[];
   this.TradesArray.TradesArrayOnSymbol(Symbol(),orders_array,false);
   int trades_count = ArraySize(orders_array);
      for (int i = 0; i < trades_count; i++) {
         if (orders_array[i].IsBreakEven()) continue;
         double BE_Price = this.FourStrings_Trade_BE_Price(orders_array[i].Ticket,BigFibo);
         if (BE_Price == 0) continue; // non-FourStrings order, or something else went wrong
         // create small dash at price of break even
         string name = "BE Level for #" + IntegerToString(orders_array[i].Ticket);
         CTrend be_mark(name);
         if ( (!be_mark.IsExist()) || (be_mark.IsExist() && be_mark.Price1() != BE_Price) ) { // if doesn't exist at all; or exist, but at the wrong price
            ObjectDeleteSilent(name); // удалять только, если уже есть и стоит не на том месте, где надо
            ObjectCreate(ChartID(),name,OBJ_TREND,0,TimeCurrent(),BE_Price,TimeCurrent()+60*60*3,BE_Price);
            be_mark.Color(clrGray);
            be_mark.Thickness(2);
            be_mark.Ray(false);
            be_mark.SetText("BE for Order '" + (string)orders_array[i].FourStrings_TradeFiboLevel() + "%'");
         }
      }
   
   
   // CHECK ACTIVE "Four Strings" ORDERS if they have already reached BREAK EVEN level. If yes - send command to Trade.exe to move them to BE 
   int active_trades_count = this.TradesArray.TradesOpenOnSymbol(Symbol(),true);
   if (active_trades_count > 0) {
      if (!BigFibo.IsExist()) return;
      // Big Fibo exists
      // Cycle through all the Four Strings orders - check if they have reached their BE targets

      CMetaTrade active_orders_array[];
      this.TradesArray.TradesArrayOnSymbol(Symbol(),active_orders_array,true);
      for (int i = 0; i < ArraySize(active_orders_array); i++) {
         if ( i > ArraySize(active_orders_array) ) {Print(__FUNCTION__, ": i > ArraySize(active_orders_array); breaking for cycle"); break; } 
         if (active_orders_array[i].IsBreakEven()) continue; // skip to next, if this trade is already at Break Even
         if (active_orders_array[i].Profit() <= 0) continue; // order is not yet in profit - too early to talk about break even
         double BE_Price = this.FourStrings_Trade_BE_Price(active_orders_array[i].Ticket, BigFibo); 
         if (BE_Price == 0) {
            Print("Error calculating BE price for order '" + DoubleToString(active_orders_array[i].FourStrings_TradeFiboLevel(),1) + "%'");
            continue;
         }
         bool BE_Reached = false;
         if (active_orders_array[i].TradeType() == ORDER_TYPE_BUY) {
            if (Latest_Price.bid > BE_Price) BE_Reached = true; 
         }
         else if (active_orders_array[i].TradeType() == ORDER_TYPE_SELL) {
            if (Latest_Price.ask < BE_Price) BE_Reached = true; 
         }
         if (BE_Reached) EventChartCustom(ChartID(),TRADE_BREAKEVEN_SET,active_orders_array[i].Ticket,0,"");
      }      
   }
}
   
   
   
   
double CTradeManager::FourStrings_Trade_BE_Price(ulong Trade_Ticket, CFibo &BigFibo) {
   // Targets are:
   // For 61.8% order - target is 38.2
   // For 50%   order - target is 23.6
   // for 38.2% order - target is 0
   // for 23.6% order - target is 1/2 TP

   // Detect - which trade it is (from which level of Big Fibo by checking in the Comment)
   CMetaTrade trade(Trade_Ticket);
   double TradeLevel = trade.FourStrings_TradeFiboLevel();
   if (TradeLevel == 61.8) return BigFibo.GetPriceOfFiboLevel(38.2);
   if (TradeLevel == 50)   return BigFibo.GetPriceOfFiboLevel(23.6);
   if (TradeLevel == 38.2) return BigFibo.GetPriceOfFiboLevel(0);
   if (TradeLevel == 23.6) {
      ENUM_ORDER_TYPE ot = trade.TradeType();
      if (ot == ORDER_TYPE_BUY || ot == ORDER_TYPE_BUY_LIMIT) {
         return trade.OpenPrice()+(trade.TP()-trade.OpenPrice())/2;
      }
      else if (ot == ORDER_TYPE_SELL || ot == ORDER_TYPE_SELL_LIMIT) {
         return trade.OpenPrice()-(trade.OpenPrice()-trade.TP())/2;
      }
   }
   return 0;
}



void CTradeManager::ShowHideBodyLevelsButton() {

 
   if (SetSolidLine_Button.IsVisible()) // look at one of the buttons on the main UI of Meta Tools
      BodyLevels_Button.Show();
   else
      BodyLevels_Button.Hide();

   if (TradeLinesVisible)
      BodyLevels_Button.Hide();

}





bool CTradeManager::ToggleBodyLevels(StrategyID strategy, ENUM_TIMEFRAMES period, int first_bar, DayPriorityID DayPrio) {
   // period - bars of this period will be used (scaned) to find levels
   // period - newly created levels will be visible on this period only
   // first_bar - first bar in the past (from the left of the chart) which which level search will start
   
   
   // ************************** DELETING EXISTING LEVELS ****************************************************
   // if there is any level on this period already auto-created - removing them and quitting this method
   if (Strategy != D1) { // do not delete body for D1 stragegy
      bool deleting_existing = false;
      for (int i = ObjectsTotalMQL4(); i >= 0; i--) {
         CLevel lvl(ObjectNameMQL4(i));
         if ( lvl.IsBodyLevel() ) {
            Print(0);
            if ( !lvl.IsVisibleOnTF(period) ) continue; // do not delete levels, which are not visible on working TF (H1)
            if ( (Period() == PERIOD_H1 || Period() == PERIOD_H4) && lvl.IsVisibleOnTF(PERIOD_D1) ) continue; // if curr TF is H1 or H4 and level is visible on D1 (changed by user) - do not delete D1-levels
            if ( StringFind(lvl.Name,DoubleToString(lvl.Price1(),_Digits)) == -1 ) { 
               lvl.CreateCopy();
               lvl.Delete();
               continue; // price of the level doesn't match to its name -> changed manualy by user -> do not delete
            }
            deleting_existing = true;
            ObjectDeleteSilent(ObjectNameMQL4(i));
         }
      }
      if (deleting_existing) return false; // if levels are delete - do not create new levels this time; in other words - if there are levels to delete - do not create new ones
   }
   // or, create new levels only if no other levels exist on this TF.
   // ************************************************************************************************************************
   // ************************************************************************************************************************


   // ************************************************************************************************************************************************************
   // ************************** NO LEVELS EXIST - SCANNING CHART TO FIND QUALIFIED SEQUENCE BARS AND CREATE LEVELS ****************************************************
   // ************************************************************************************************************************************************************
   // Scan chart and finds all D1 levels, build on Open and Close prices for chosen timeframe
   if (first_bar < 1) { Print(__FUNCTION__ + ": first_bar < 1 - wrong use of function!"); return false; } // wrong call of this function
   
   string upper_levels[]; // names of upper levels
   string lower_levels[]; // names of upper levels
   
   // *** FIND UPPER LEVELS ***
   double highest_level = 0;
   int highest_bar = 0;
   
   
   // Big cycle through all the bars
   for (int curr_bar = first_bar; curr_bar > 1; curr_bar--) {
         if ( strategy == D1 && period == PERIOD_H1 && DayPrio == Buy ) break; // not creating upper levels when we expect buy signal for D1 strategy on H1 TF
         highest_level = 0; // reset the highest level (price for the level)
         highest_bar = curr_bar; // reset current bar
         
         // SMALL CYCLE: Cycle to the left until bar's high will be lower than the highest_level 
         for (int i = curr_bar; i < Bars(_Symbol,_Period); i++) {
            if (iHigh(Symbol(),period,i) < highest_level) break; // end this cycle! highest_level to the left is found
            
            // filter out bars which are not worth to analyze
                 
            // Find upper side of the bar (highest level)
            // first - find out - is it a white or black bar?
            bool white_bar = false;
            if (iOpen(Symbol(),period,i) < iClose(Symbol(),period,i)) white_bar = true;
            if (white_bar) {
               if (iClose(Symbol(),period,i) > highest_level) {
                  highest_level = iClose(Symbol(),period,i);
                  highest_bar = i;
               }
            }
            else { // black bar
               if (iOpen(Symbol(),period,i) > highest_level) {
                  highest_level = iOpen(Symbol(),period,i);
                  highest_bar = i;
               }
            }
         } // SMALL CYCLE
         // Candidate price and bar for the UPPER LEVEL is found; next - check it to make sure it qualies

         
         // VALIDATING UPPER LEVEL - check, if there are any higher open/close prices to the right - disqualify this level and do not create it
         // if there is a lower high - qualify
         bool qualified = true;
         for (int i = curr_bar-1; i > curr_bar-20; i--) {
            double open = iOpen(Symbol(),period,i);
            double close = iClose(Symbol(),period,i);
            double high = iHigh(Symbol(),period,i);
            if (open > highest_level || close > highest_level || i == 0) {
               qualified = false; // level is disqualified and should not be created
               break;
            }
            if (high < highest_level) {
               qualified = true; // level is disqualified and should not be created
               break;
            }
         } 
         
         // disqualifying level, if its lowest bar index > first bar (especially important for Strategy D1
         if (highest_bar > first_bar) qualified = false;
         
         // *** Qualification based on the number of time it was broken and which bar was the last which has broken it
         int LastBrokenBytBarIndex = 0;
         CLevel level();
         int times_broken = level.TimesBroken(period, LastBrokenBytBarIndex, highest_level,highest_bar);
         if (times_broken == 2 && LastBrokenBytBarIndex != 1) qualified = false;
         else if (times_broken > 2) qualified = false;
         if (times_broken == -1) Print(__FUNCTION__, ": Error in counting number of breaks! level.TimesBroken() returned '-1'");
         // *** End of qualification check.
         
         if ( highest_level == 0 ) qualified = false;
         if (!qualified) continue; // skip to the next bar in the big cycle
         
         // At this point - the level is qualified.
         // highest_level - this is the highest level from the left and right scan
         // highest_bar - bar on the body of which this level should sit and should start from
         level.Name = level.UpperLevel_Name(period,highest_level);
         // check, if such level already exists
         bool already_exists = false;
         // make sure that we've not just added a level with the same price during last three iterations
         int arr_size = ArraySize(upper_levels);
         for (int i = arr_size-1; i >= arr_size-3; i--) { // check 3 last added levels
            if (i < 0) break; // not to allow array of range error
            if (upper_levels[i] == level.Name) {
               already_exists = true; // level for this price is already built, just on another bar 
               break;
            }
         }
         
         if (already_exists) continue; // skip to the next bar in the cycle

         
         // add it to the array
         ArrayResize(upper_levels,ArraySize(upper_levels)+1);
         upper_levels[ArraySize(upper_levels)-1] = level.Name;
         
        
         // draw it on chart
         datetime time1 = iTime(Symbol(),period,highest_bar+2);
         int time2_shift;
         if (period == PERIOD_H1) time2_shift = 60*60*24;
         else time2_shift = period*120;
         datetime time2 = iTime(Symbol(),period,0) + time2_shift;
         level.TradeDirection = Sell_Level;
         level.CreateLevel(strategy, highest_level, time1, time2, clrRed, period);
         level.ExtendPoint2();
         //if (LastBrokenBytBarIndex == 1 && times_broken == 2) {
         //   // yesterday D1-bar gave signal - highlighting the bar
         //   Print("Highlighting yesterday bar");
         //   CBar bar(1,PERIOD_D1);
         //   bar.HighlightBar(clrLawnGreen,"Sell Signal for '4 Strings'");
         //}
         
         // Update label
         level.UpdateLabel(strategy,Sell);

   } // for - end of big cycle though all the bars for upper levels
   // *** UPPER LEVELS CREATED
   
   
   
   
   
   
   
   
   
   
   
   // *** FIND LOWER LEVELS ***
   double lowest_level = 0;
   int lowest_bar = 0;
   
   // Big Cycle - take bar by bar 
   for (int curr_bar = first_bar; curr_bar > 1; curr_bar--) {
      //Print("Strategy=" + EnumToString(strategy) + "; period = " + period + "; DayPrio = " + EnumToString(DayPrio));
      if ( strategy == D1 && period == PERIOD_H1 && DayPrio == Sell ) {Print("breaking"); break; } // not creating lower levels when we expect sell signal for D1 strategy on H1 TF
         bool white_bar = false;
         lowest_bar = curr_bar; // reset current bar
         
         // Find bottom of the bar
         if (iOpen(Symbol(),period,curr_bar) < iClose(Symbol(),period,curr_bar)) white_bar = true;
         if (white_bar)
            lowest_level = iOpen(Symbol(),period,curr_bar);
         else
            lowest_level = iClose(Symbol(),period,curr_bar); 
         // the lowest level is reset to the bottom of the bar
         
   
         // Cycle to the left until a bar's low will be higher than lowest_level
         // SMALL CYCLE: to see, if the lower level should be adjusted to be slightly lower to adjust to nearby bars
         for (int i = curr_bar+1; i < Bars(_Symbol,_Period); i++) {
            if (iLow(Symbol(),period,i) > lowest_level) break; // end this cycle! lowest_level to the left is found
            
            // Find lower side of the bar (lowest level)
            // first - find out - is it a white or black bar?
            white_bar = false;
            if (iOpen(Symbol(),period,i) < iClose(Symbol(),period,i)) white_bar = true;
            if (white_bar) {
               if (iOpen(Symbol(),period,i) < lowest_level) {
                  lowest_level = iOpen(Symbol(),period,i);
                  lowest_bar = i;
               }
            }
            else { // black bar
               if (iClose(Symbol(),period,i) < lowest_level) {
                  lowest_level = iClose(Symbol(),period,i);
                  lowest_bar = i;
               }
            }
         }
         
         
         // VALIDATING LOWER LEVEL - check, if there are any lower open/close prices to the right - disqualify this level and do not draw it
         // if there is a higher low - qualify
         bool qualified = true;
         // cycle to the right starting from the next bar
         for (int i = curr_bar-1; i > curr_bar-20; i--) {
            double open = iOpen(Symbol(),period,i);
            double close = iClose(Symbol(),period,i);
            double low = iLow(Symbol(),period,i);
            if (open < lowest_level || close < lowest_level || i == 0) {
               qualified = false; // level is disqualified and should not be created
               break;
            }
            if (low > lowest_level) {
               qualified = true; // level is disqualified and should not be created
               break;
            }
         } 
         
         // disqualifying level, if its lowest bar index > first bar (especially important for Strategy D1
         if (lowest_bar > first_bar) qualified = false;
         
         // *** Qualification based on the number of time it was broken and which bar was the last which broke it
         //if (this.TimesBrokenOnTF(highest_level,highest_bar, period,LastBrokenBytBarIndex) > 2) qualified = false; // broken twice or more - disqualify
         int LastBrokenByBarIndex = 0;
         CLevel level();
         int times_broken = level.TimesBroken(period, LastBrokenByBarIndex, lowest_level,lowest_bar);
         if (times_broken == 2 && LastBrokenByBarIndex != 1) qualified = false;
         else if (times_broken > 2) qualified = false;
         if (times_broken == -1) Print(__FUNCTION__, ": Error in counting number of breaks! level.TimesBroken() returned '-1'");
                  
         if (level.TimesBroken(period,LastBrokenByBarIndex, lowest_level,lowest_bar) > 2) qualified = false;; // broken twice or more - disqualify
         if ( lowest_level == 0 ) qualified = false;
         if (!qualified) { continue; } // skip to the next bar in the big cycle
         // *** End of qualification check
         
         // At this point - the level is qualified.
         // lowest_level - this is the lowest level from the left and right scan
         // lowest_bar - bar on the body of which this level should sit and should start from
         level.Name = level.LowerLevel_Name(period,lowest_level);
         // check, if such level already exists
         bool already_exists = false;
         // make sure that we've not just added a level with the same price during last three iterations
         int arr_size = ArraySize(lower_levels);
         for (int i = arr_size-1; i >= arr_size-3; i--) { // check 3 last added levels
            if (i < 0) break; // not to allow array of range error
            if (lower_levels[i] == level.Name) {
               already_exists = true; // level for this price is already built, just on another bar 
               break;
            }
         }
         if (already_exists) { /*Print(level.Name + " already exists");*/ continue; } // skip to the next bar in the cycle
         
         //add it to the array
         ArrayResize(lower_levels,ArraySize(lower_levels)+1);
         lower_levels[ArraySize(lower_levels)-1] = level.Name;
         
         // create it on chart
         datetime time1 = iTime(Symbol(),period,lowest_bar+2);
         int time2_shift;
         if (period == PERIOD_H1) time2_shift = 60*60*24;
         else time2_shift = period*120;
         datetime time2 = iTime(Symbol(),period,0) + time2_shift;
         level.TradeDirection = Buy_Level;
         level.CreateLevel(strategy, lowest_level, time1, time2, clrGreen, period);
         level.ExtendPoint2();
         //if (LastBrokenByBarIndex == 1 && times_broken == 2) {
         //   // yesterday D1-bar gave signal - highlighting the bar
         //   Print("Highlighting yesterday D1-bar");
         //   CBar bar(1,PERIOD_D1);
         //   bar.HighlightBar(clrLawnGreen,"Buy Signal for '4 Strings'");
         //}
         
         // update label
         level.UpdateLabel(strategy,Buy);

   } // for - end of big cycle though all the bars for lower levels
   // *** LOWER LEVELS CREATED
   
   return true;
      
} // ToggleBodyLevels



string CTradeManager::FourStrings_IsSignalOnD1Yesterday() {
   int levels_checked = 0;
   for (int i = 0; i < ArraySize(Levels); i++) {
      // checking each D1 level, if it provided FourStrings-signal yesterday
      levels_checked++;
      int LastBrokenByBarIndex = 0;
      int StartingBar = iBarShift(Symbol(),PERIOD_D1,Levels[i].DateTime1()) - 1;
      int times_broken = Levels[i].TimesBroken(PERIOD_D1, LastBrokenByBarIndex);
      
      if (LastBrokenByBarIndex == 1 && times_broken == 2) {
         Print(__FUNCTION__  ": Four String signal deleted on level '" + Levels[i].Name + "'");
         return Levels[i].Name;
      }
   }
   //Print("levels_checked = " + IntegerToString(levels_checked));
   return "";
}




void CTradeManager::FourStrings_ExtendD1Levels() {
   // продлить стандартные "Four String" Д1-уровни по следующего дня
   // используется для того, чтобы убедится, что уровни протянуты до конца вправо и участвуют в вычислении пробоя

   int LevelsExtended = 0;

   for (int i = ObjectsTotalMQL4(); i >= 0; i--) {
      CLevel level(ObjectNameMQL4(i));
      if ( level.IsBodyLevel()  && level.IsVisibleOnTF(PERIOD_D1) ) {
         level.ExtendPoint2();
         LevelsExtended++;
         //Print(level.Name);
      }
   }
   Print("Levels Extended: " + IntegerToString(LevelsExtended));
}


void CTradeManager::UpdateSpreadThicknessOfEntryLine() {

   if (!ShowSpreadThickness) return;
   
   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(_Symbol ,Latest_Price); // Assign current prices to structure 
   
   // ******** LIMIT ORDER PREPARATION HIGHLIGHTING ********
   // showing where Bid must reach to trigger the limit order
   if (this.TradeLinesVisible) { // Trade Lines are visible!
      CTradeLine el(EntryLineName);
      CTradeLine sl(StopLossLineName);
      if (el.Price() == Latest_Price.ask || el.Price() == Latest_Price.bid) return; // this is not limit order setting
      double price;
      if (sl.Price() < el.Price()) {
         // buy case
         price = el.Price() - AvgSpread*10*_Point;
      }
      else if (sl.Price() > el.Price()) {
         // sell case
         price = el.Price() + AvgSpread*10*_Point;
      }
      else return; // when they are equal - no highlights
      
      if (ObjectFindMQL4(this.m_SpreadThicknessLineName_Entry) < 0) {
         // such line does not exist - creating it
         this.m_CreateSpreadThicknessLine(this.m_SpreadThicknessLineName_Entry,price,el.Color());
      }
      else {
         // line with this name already exists - just updating its coordinates
         CTrend trend(this.m_SpreadThicknessLineName_Entry);
         trend.Price1(price);
         trend.Price2(price);
      }
   }
}



void CTradeManager::UpdateSpreadThicknessOf_SL_and_TP() {

   if (!ShowSpreadThickness) return;
   
   color clr_sl; // color of the SL line which will highlight the thickness
   color clr_tp; // color of the spread thinkness line for TP
   
   // take colors from real stop loss and take profit lines
   clr_sl = StopLossLine.Color();
   clr_tp = TakeProfitLine.Color();
   
   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(_Symbol ,Latest_Price); // Assign current prices to structure 
   

   // find all sell stop-losses on this chart (either in preparation or already set ones) 
   // and display how thick is current spread as box
   

   if (this.TradeLinesVisible) { // Trade Lines are visible!
      CTradeLine sl(StopLossLineName);
      CTradeLine el(EntryLineName);
      CTradeLine tp(TakeProfitLineName);
      
      // ******** ORDER PREPARATION HIGHLIGHTING ********
      // showing thickness around Trade Line "Stop Loss" (order preparation)
      if (sl.Price() <= el.Price()) { // show thickness only for sell cases; this one is BUY case
         ObjectDeleteSilent(this.m_SpreadThicknessLineName_SL);
      }
      else {
         // Trade Lines are visible and SL line is higher than Entry Line -> preparation of Sell order
         // Creating line which will visually emphasize the position of the SL line and level where SL will be triggered by Bid price
         
         // SETTING UP THINKNESS LINE FOR SL
         double price_sl = sl.Price() - AvgSpread*10*_Point;
         
         if (ObjectFindMQL4(this.m_SpreadThicknessLineName_SL) < 0) {
            // such line does not exist - creating it
            this.m_CreateSpreadThicknessLine(this.m_SpreadThicknessLineName_SL,price_sl,clr_sl);
         }
         else {
            // linee with this name already exists - just updating its coordinates
            CTrend trend_sl(this.m_SpreadThicknessLineName_SL);
            trend_sl.Price1(price_sl);
            trend_sl.Price2(price_sl);
            trend_sl.Selectable(true);
         }
      }
   
      // SETTING UP THINKNESS LINE FOR TP
      // showing thickness around Trade Line "Take Profit Line" (order preparation)
      if (tp.Price() > el.Price()) { // BUY case
         double price_tp = tp.Price() + AvgSpread*10*_Point;
         
         if (ObjectFindMQL4(this.m_SpreadThicknessLineName_TP) < 0) {
            // such line does not exist - creating it
            this.m_CreateSpreadThicknessLine(this.m_SpreadThicknessLineName_TP,price_tp,clr_tp);
         }
         else {
            // line with this name already exists - just updating its coordinates
            CTrend trend_tp(this.m_SpreadThicknessLineName_TP);
            trend_tp.Price1(price_tp);
            trend_tp.Price2(price_tp);
         }
      }
      else {
         ObjectDeleteSilent(m_SpreadThicknessLineName_TP);
      }
      // ********************************************************
   
   }
   
   

   
   
   
   
   
   // ******** ACTIVE ORDERS HIGHLIGHTING ********
   // find sell stop losses from already existing orders on the chart
   // both pending and active
   if (OrdersTotal() == 0) return;
   CMetaTrade array[];
   this.TradesArray.TradesArrayOnSymbol(Symbol(),array);
   int array_size = ArraySize(array);
   if (array_size == 0) return;
   ENUM_ORDER_TYPE order_type;
   for (int i = 0; i < array_size; i++) {
      order_type = array[i].TradeType();
      if (order_type != ORDER_TYPE_SELL && order_type != ORDER_TYPE_SELL_LIMIT && order_type != ORDER_TYPE_SELL_STOP) 
         continue;
      double sl = array[i].SL();
      double price = sl - (Latest_Price.ask-Latest_Price.bid);
      string trend_name = this.m_SpreadThicknessLineName_SL + " for #" + IntegerToString(array[i].Ticket);
      if (ObjectFindMQL4(trend_name) < 0) {
         // such line does not exist - creating it
         this.m_CreateSpreadThicknessLine(trend_name,price,clr_sl);
      }
      else {
         // line with this name already exists - just updating its coordinates
         CTrend trend(trend_name);
         trend.Price1(price);
         trend.Price2(price);
      }
   
   } // for
}




bool CTradeManager::m_CreateSpreadThicknessLine(string name, double price, color clr) {
   datetime time1 = iTime(_Symbol,_Period,(int)ChartGetInteger(0,CHART_FIRST_VISIBLE_BAR,0));
   datetime time2 = TimeCurrent() + (24-HourMQL4())*3600;
   
   
   if (!ObjectCreate(0,name,OBJ_TREND,0,time1,price,time2,price)){
      Print(__FUNCTION__ + ": could not create spead thickness line '" + name + "'");
      return false;
   }
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_DOT);
   ObjectSetInteger(0,name,OBJPROP_RAY,false);
   ObjectSetInteger(0,name,OBJPROP_RAY_RIGHT,false);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   return true;
}






void CTradeManager::DeleteSpreadThicknessLines() {
   int total = ObjectsTotalMQL4();
   string name;
   for (int i = total-1; i >= 0; i--) {
      name = ObjectNameMQL4(i);
      if (StringFind(name,this.m_SpreadThicknessLineName_SL) != -1) 
         ObjectDeleteSilent(name);
      if (StringFind(name,this.m_SpreadThicknessLineName_Entry) != -1) 
         ObjectDeleteSilent(name);
      if (StringFind(name,this.m_SpreadThicknessLineName_TP) != -1) 
         ObjectDeleteSilent(name);
   }
}






void CTradeManager::OnTrade() {

   this.DeleteSpreadThicknessLines();

}


void CTradeManager::HidePSC() {

   // hiding PositionSizeCalculator

   UpdateTradeLinesVisibleValue(); // updating "TradeLinesVisible" variable to make sure 
   
   if ( this.TradeLinesVisible ) {
      sets.TP_Manual_Control = true;
      sets.SaveSettingsOnDisk();
      if (!EventChartCustom(ChartID(),PSC_HIDE_SHOW_LINES,0,0,"m_BtnLines")) 
         Print("Couldn't generate a custom event 'PSC_HIDE_SHOW_LINES'. Error code: ", GetLastError(), ": ", ErrorDescription(GetLastError()));
   }
}








void CTradeManager::ClosestLevel(double &distance, CLevel &Closest_Level) {
   // find closest level to the current price and distance to that level
   // return both by reference
      Closest_Level = Levels[0];
      distance = Levels[0].DistanceToCurrentPrice();
      
      for (int i = 1; i < ArraySize(Levels); i++) {
         double new_distance = Levels[i].DistanceToCurrentPrice();
         if (new_distance == 0) continue;
         if (distance == 0 && new_distance != 0) {
            distance = new_distance;
            Closest_Level = Levels[i];
         }
         else {// now we compare both values, which are not zero (as checked above)
            if (new_distance < distance) {
               distance = new_distance;
               Closest_Level = Levels[i];
            }
         }
      }
}


void CTradeManager::DisplayDistanceToClosestLevel() {
  if (Strategy != D1 && Strategy != S3) return;
  
   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(Symbol() ,Latest_Price); // Assign current prices to structure 

  
   #ifdef __MQL5__
      InitHighLowOpenCloseArrays(3);
   #endif 
  
  
   string dist_label = "Dist to Closest Level Label";
   string rectangle = "Dist to Closest Level Label Rectangle";
   ObjectDeleteSilent(0,dist_label);
   ObjectDeleteSilent(0,rectangle);
   // find closest level
   int levels_count = ArraySize(Levels);
   double distance = 0;
   //double closest_level_price;
   //string closest_level;
   if (levels_count > 0) {
      distance = Levels[0].DistanceToCurrentPrice();
      CLevel Closest_Level;
      ClosestLevel(distance, Closest_Level); // pass distance and level by reference
           
      //Print("Distance to closest level = ", distance);
      CBar bar(0,PERIOD_H1);
      PinBarType _PinBarType = bar.PinBar_Type();

      bool candle_touches_level = false;
      if (Closest_Level.TradeDirection == Buy_Level) {
         if (_PinBarType == Bullish) {
            if (iLow(_Symbol,PERIOD_H1,0) <= Closest_Level.Price()) candle_touches_level = true;  
         }
         else {
            if (iOpen(_Symbol,PERIOD_H1,0) <= Closest_Level.Price()) candle_touches_level = true;  
         }
      }
      else if (Closest_Level.TradeDirection == Sell_Level) {
         if (_PinBarType == Bearish) {
            if (iHigh(_Symbol,PERIOD_H1,0) >= Closest_Level.Price()) candle_touches_level = true;
         }
         else {
            if (iOpen(_Symbol,PERIOD_H1,0) >= Closest_Level.Price()) candle_touches_level = true;
         } 
      }

      

      
      if (distance != 0 && distance < 1000 && candle_touches_level) {
         int random_int = MathRand();
         ObjectCreate(0,dist_label,OBJ_TEXT,0,TimeCurrent()+3600,Latest_Price.ask);
         ObjectSetString(0,dist_label,OBJPROP_TEXT,DoubleToString((double)distance/10,1));
         ObjectSetString(0,dist_label,OBJPROP_FONT,"Calibri");
         ObjectSetInteger(0,dist_label,OBJPROP_FONTSIZE,8);
         ObjectSetInteger(0,dist_label,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1|OBJ_PERIOD_M30|OBJ_PERIOD_M15|OBJ_PERIOD_M5|OBJ_PERIOD_M1);
         ObjectSetString(0,dist_label,OBJPROP_TOOLTIP,"Distance to closest level: " + DoubleToString((double)distance/10,1));
         ObjectSetInteger(0,dist_label,OBJPROP_ANCHOR,CORNER_LEFT_LOWER);
         ObjectSetInteger(0,dist_label,OBJPROP_SELECTABLE,false);
         
         ObjectCreate(0,rectangle,OBJ_RECTANGLE,0,TimeCurrent()-3600,Closest_Level.Price(),TimeCurrent()+3600,Latest_Price.bid);
         ObjectSetInteger(0,rectangle,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1|OBJ_PERIOD_M30|OBJ_PERIOD_M15|OBJ_PERIOD_M5|OBJ_PERIOD_M1);
         color rect_color;
         bool D1_pin_bar_signal_expected = false;
         
         if (_PinBarType == Bullish && iOpen(_Symbol,PERIOD_H1,0) >= Closest_Level.Price()) { // this is situation when D1 signal is purely on pin bar - 7 pp is the limit distance
            D1_pin_bar_signal_expected = true;
         }
         else if (_PinBarType == Bearish && iOpen(_Symbol,PERIOD_H1,0) <= Closest_Level.Price()) {
            D1_pin_bar_signal_expected = true;
         }
         
         if (D1_pin_bar_signal_expected) {
            if (distance <= 70) rect_color = clrGreenYellow;
            else rect_color = clrPink;
         }
         else {
            if (distance <= 100) rect_color = clrGreenYellow;
            else if (distance > 100 && distance <=150) rect_color = clrGold;
            else rect_color = clrPink;
         }
         
   
         ObjectSetMQL4(rectangle,OBJPROP_COLOR,rect_color);
         ObjectSetInteger(0,rectangle,OBJPROP_SELECTABLE,false);
      }
   }
}



void CTradeManager::DisplayDistanceEntryLineToClosestLevel() {
   //Print(__FUNCTION__);

   string rectangle = "Dist Closest Level to Entry Line Price";
   string dist_label = "Dist Closest Level to Entry Line Price Label";
   ObjectDeleteSilent(0,dist_label);
   ObjectDeleteSilent(0,rectangle);

   if (ArraySize(Levels) == 0) return;
   
   if ( !this.EntryLine.IsVisibleOnTF(_Period) ) return;
   
   CLevel Closest_Level;
   Closest_Level = Levels[0];
   
   double distance = (double)MathAbs(TradeManager.EntryLine.Price() - Levels[0].Price()) / _Point;
   //Print("distance = " + distance);
   
   for (int i = 1; i < ArraySize(Levels); i++) {
      double new_distance = (double)MathAbs(TradeManager.EntryLine.Price() - Levels[i].Price()) / _Point;
      if (new_distance == 0) continue;
      if (distance == 0 && new_distance != 0) {
         distance = new_distance;
         Closest_Level = Levels[i];
      }
      else {// now we compare both values, which are not zero (as checked above)
         if (new_distance < distance) {
            distance = new_distance;
            Closest_Level = Levels[i];
         }
      }
   }
   
   
   string s_distance;
   if ( distance >= 200 )
      s_distance = DoubleToString((double)distance/10,0);
   else
      s_distance = DoubleToString((double)distance/10,1);
      

      if (distance != 0 && distance < 1000) {
         int random_int = MathRand();
         ObjectCreate(0,dist_label,OBJ_TEXT,0,TimeCurrent()+25000,TradeManager.EntryLine.Price());
         ObjectSetString(0,dist_label,OBJPROP_TEXT,s_distance);
         ObjectSetString(0,dist_label,OBJPROP_FONT,"Calibri");
         ObjectSetInteger(0,dist_label,OBJPROP_FONTSIZE,8);
         ObjectSetInteger(0,dist_label,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1|OBJ_PERIOD_M30|OBJ_PERIOD_M15|OBJ_PERIOD_M5|OBJ_PERIOD_M1);
         ObjectSetString(0,dist_label,OBJPROP_TOOLTIP,"Distance Entry Line to Level: " + s_distance);
         ObjectSetInteger(0,dist_label,OBJPROP_ANCHOR,CORNER_LEFT_LOWER);
         ObjectSetInteger(0,dist_label,OBJPROP_SELECTABLE,false);
         
         datetime time1 = iTime(_Symbol,PERIOD_D1,0)+24*3600;
         datetime time2 = time1 + 20000;
         ObjectCreate(0,rectangle,OBJ_RECTANGLE,0,time1,Closest_Level.Price(),time2,TradeManager.EntryLine.Price());
         ObjectSetInteger(0,rectangle,OBJPROP_TIMEFRAMES,OBJ_PERIOD_H1|OBJ_PERIOD_M30|OBJ_PERIOD_M15|OBJ_PERIOD_M5|OBJ_PERIOD_M1);
         color rect_color;
         
         bool D1_pin_bar_signal_expected = false;
         CBar bar(0,PERIOD_H1);
         PinBarType _PinBarType = bar.PinBar_Type();
      
         if (_PinBarType == Bullish && TradeManager.EntryLine.Price() >= Closest_Level.Price()) { // this is situation when D1 signal is purely on pin bar - 7 pp is the limit distance
            D1_pin_bar_signal_expected = true;
         }
         else if (_PinBarType == Bearish && TradeManager.EntryLine.Price() <= Closest_Level.Price()) {
            D1_pin_bar_signal_expected = true;
         }
         
         if (D1_pin_bar_signal_expected) {
            if (distance <= 70) rect_color = clrGreenYellow;
            else rect_color = clrPink;
         }
         else {
            if (distance <= 100) rect_color = clrGreenYellow;
            else if (distance > 100 && distance <=150) rect_color = clrGold;
            else rect_color = clrPink;
         }
         
   
         ObjectSetMQL4(rectangle,OBJPROP_COLOR,rect_color);
         ObjectSetInteger(0,rectangle,OBJPROP_SELECTABLE,false);
      }

}




void CTradeManager::UpdateVisPosOfRecommendedSLRange() {

   // creates / updates visible range on chart 
   // range shows recommended boundaries for SL position
   //Print("updating...");

   // checking if recommended SL range is switched ON in settings
   if (MinRecommSL_fromATR == 0 && MaxRecommSL_fromATR == 0 && SL_Not_Less_Than_PP == 0 && SL_Not_More_Than_PP == 0) {
      Print(__FUNCTION__ + ": SL range settings set to zero; not showing recommended SL range");
      return;
   }
   
   // initial values for min and max of the SL range
   // initial value starts from entry price
   double min_SL = this.EntryLine.Price(); 
   double max_SL = this.EntryLine.Price();
   
   // offset from entry line: entry line minus offset = recommended position for SL
   double ATR14_offset, offset_min, offset_max;
   
   

   if ( Strategy == D1 ) {
      // только для Д1-стратегии
      if ( StringFind(_Symbol,"EUR") != -1 ) {
         // this is EUR-based pair
         offset_min   = 250 * _Point;
         offset_max   = 450 * _Point;
      }
      else {
         // this is GBP-based pair
         offset_min   = 300 * _Point;
         offset_max   = 500 * _Point;
      }
   }
   else {
      // для любой другой статегии
      /*   !!! ПРОДОЛЖИТЬ РАЗРАБОТКУ !!!
      Задействовать все настройки:
         изначальное положение:
            - Min Recommended SL-size as %% of ATR14
            - Max Recommended SL-size as %% of ATR14
         проверка и коррекция, чтобы не превышались эти значения:
            - SL-size not less than, pp
            - SL-size not more than, pp
      */
      ATR14_offset = ATR14 * 10 * _Point; // translating point value to price difference
      offset_min = ATR14_offset * MinRecommSL_fromATR / 100;
      offset_max = ATR14_offset * MaxRecommSL_fromATR / 100;
      if (isGOLD() || isOIL() || (isCRYPTO() && _Symbol != "RIPPLE" && _Symbol != "DOGECOIN")) {
         offset_min = offset_min * 10;
         offset_max = offset_max * 10;
      }
   }

   
   if (this.StopLossLine.Price() > this.EntryLine.Price()) {
      //Print("Sell");
      min_SL = min_SL + offset_min;
      max_SL = max_SL + offset_max;
   }
   else if (this.StopLossLine.Price() < this.EntryLine.Price()) {
      //Print("Buy");
      min_SL = min_SL - offset_min;
      max_SL = max_SL - offset_max;
   }
   else {
      Print("SL and Entry Line are on the same level. Not updating SL range");
      return;
   }


   // Min and max of range is found (per ATR only)
   // ******************************Create SL Range Rectangle **************************************************
   double upper_price = MathMax(min_SL,max_SL);
   double lower_price = MathMin(min_SL,max_SL);
   CRectangle rect();
   rect.Name = SL_RangeRectName;
   rect.Delete();
   datetime rect_time1 = iTime(_Symbol,_Period,(int)ChartGetInteger(0,CHART_FIRST_VISIBLE_BAR,0));
   datetime rect_time2 = 0;
   
   int x = (int)ChartGetInteger(0, CHART_WIDTH_IN_PIXELS);
   int y = 0; double price = 0;
   int subw = 0;
   ChartXYToTimePrice(ChartID(),x,y,subw,rect_time2,price);
   rect.Create(rect.Name,rect_time1, upper_price, rect_time2, lower_price);
   rect.Color(clrBlanchedAlmond);
   ObjectSetInteger(ChartID(),rect.Name,OBJPROP_TIMEFRAMES,MainTF);
   ObjectSetInteger(ChartID(),rect.Name,OBJPROP_SELECTABLE,false);
   if (!SimulatorMode) rect.SetText("Recommended SL Range");
   
   // creating HLINEs: upper range of rectangle and lower range of rectangle
   ObjectDeleteSilent(ChartID(),this.SL_RangeUpperHLINE);
   ObjectDeleteSilent(ChartID(),this.SL_RangeLowerHLINE);
   ObjectCreate(ChartID(),SL_RangeUpperHLINE,OBJ_HLINE,0,0,upper_price);
   ObjectCreate(ChartID(),SL_RangeLowerHLINE,OBJ_HLINE,0,0,lower_price);
   ObjectSetInteger(ChartID(),SL_RangeUpperHLINE,OBJPROP_COLOR,clrLightSalmon);
   ObjectSetInteger(ChartID(),SL_RangeLowerHLINE,OBJPROP_COLOR,clrLightSalmon);
   ObjectSetInteger(ChartID(),SL_RangeUpperHLINE,OBJPROP_TIMEFRAMES,MainTF);
   ObjectSetInteger(ChartID(),SL_RangeLowerHLINE,OBJPROP_TIMEFRAMES,MainTF);
   ObjectSetInteger(ChartID(),SL_RangeUpperHLINE,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(ChartID(),SL_RangeLowerHLINE,OBJPROP_SELECTABLE,false);
   if (!SimulatorMode) {
      ObjectSetTextMQL4(SL_RangeUpperHLINE,"Upper Limit of Recommended SL Range",12);
      ObjectSetTextMQL4(SL_RangeLowerHLINE,"Lower Limit of Recommended SL Range",12);
   }
   // ************************************************************************************************************


   // ************************ Create Range Labels - NOT YET FINISHED ***************************************************************
   // Lower
   CLabel MinSLSize_Label;
   ObjectDeleteSilent(ChartID(),MinSLSize_Label_Name);



   MinSLSize_Label.Create(ChartID(),MinSLSize_Label_Name,0,x,0,0,0);
   ObjectSetInteger(ChartID(),MinSLSize_Label_Name,OBJPROP_ANCHOR,ANCHOR_RIGHT_LOWER);
   ObjectSetInteger(0,MinSLSize_Label_Name,OBJPROP_SELECTABLE,false);
   MinSLSize_Label.Color(clrGray);
   MinSLSize_Label.Font("Arial Black");
   MinSLSize_Label.FontSize(8);
   ObjectSetString(ChartID(),MinSLSize_Label_Name,OBJPROP_TOOLTIP,"Min SL Size");
   ObjectSetInteger(ChartID(),MinSLSize_Label_Name,OBJPROP_TIMEFRAMES,MainTF);
   // *************************************************************************************************************


   /*   !!! ПРОДОЛЖИТЬ РАЗРАБОТКУ !!!
   1. Рассчитать координаты для текстовых меток
   2. Написать в них кол-во пунктов и сколько это в %% от АТР
   3. Написать тот же текст во всплаывающих подсказках горизонтальных линий.
   4. Наладить / разобраться с логикой. Какие настройки когда превалируют - пункты, а когда %% от АТР  
   */



   // Find coordinates for SL range labels and move them there  
   ObjectSetInteger(ChartID(),MinSLSize_Label_Name,OBJPROP_ANCHOR,ANCHOR_RIGHT_LOWER);
   
   ObjectSetInteger(0, MinSLSize_Label_Name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, MinSLSize_Label_Name, OBJPROP_YDISTANCE, y);
   ObjectSetText(MinSLSize_Label_Name, "label",8);

   //this.MinSLSize_Label
   //this.MaxSLSize_Label

   //MinRecommSL_fromATR
   //MaxRecommSL_fromATR
   //SL_Not_Less_Than_PP
   //SL_Not_More_Than_PP
}



void CTradeManager::RemoveSLRangeControls() {

   ObjectDeleteSilent(this.SL_RangeRectName);  
   ObjectDeleteSilent(this.SL_RangeRectName);      
   ObjectDeleteSilent(this.SL_RangeUpperHLINE);
   ObjectDeleteSilent(this.SL_RangeLowerHLINE);
   // also range delete labels
}


void CTradeManager::UpdateATRRange(int x = 0, int y = 0) {
 
   // x and y - are mouse coordinates. They are provided only when user holds shift
   // and follows bar chart along the history
   // for the current ATR range display, x and y are always zero

   // do not draw ATR range, if user is not on the MainTF now (main trading TF set in settings) 
   if (_Period != MainTF) return;


   // preparing variables
   int H1barIndex = 0;    
   int D1barIndex = 0;
   double ATR14_offset;
   double ref_price = Bid; // price which is considered to be the last one
   //Print("ref_price = " + ref_price);
   if (SimulatorMode) ref_price = latest_close_price;
   datetime time = TimeCurrent(); // current time or time of the click
   
  

   string ref_price_mark = "ref_price_mark";
   ObjectDeleteSilent(ref_price_mark);
   string DayMinBeforeH1Bar_Mark = "DayMinBeforeH1Bar_Mark";
   ObjectDeleteSilent(DayMinBeforeH1Bar_Mark);
   string DayMaxBeforeH1Bar_Mark = "DayMaxBeforeH1Bar_Mark";
   ObjectDeleteSilent(DayMaxBeforeH1Bar_Mark); 
   //string ATR_Label1 = "ATR_Label1";
   //ObjectDeleteSilent(ATR_Label1);
   string ATR_Label2 = "ATR_Label2";
   ObjectDeleteSilent(ATR_Label2);
   
   if (x != 0 && y != 0) {
      // drawing temporary ATR Range (on the history)
      double price;  // price of the click
      int    subw = 0; // sub window variable
      ChartXYToTimePrice(ChartID(),x,y,subw,time,price); 
      // find index of the H1 bar
      H1barIndex = iBarShift(_Symbol,PERIOD_H1,time);    
      D1barIndex = iBarShift(_Symbol,PERIOD_D1,time);    
      // click should be done within price range of this H1 bar; if not - exit the function
      if ( price > iHigh(_Symbol,_Period,H1barIndex) || price < iLow(_Symbol,_Period,H1barIndex) )  
         return;
      ATR14_offset = ATR(14,D1barIndex+1) * 10 * _Point; // translating point value to price difference;
      ref_price = price; // take the ref price from the click

      // creating current price mark
      ObjectCreate(ChartID(),ref_price_mark,OBJ_TREND,0,time,ref_price,time+HR1*2,ref_price);
      ObjectSetInteger(ChartID(),ref_price_mark,OBJPROP_COLOR,clrViolet);
      ObjectSetInteger(ChartID(),ref_price_mark,OBJPROP_TIMEFRAMES,PERIOD_H1);
      ObjectSetInteger(ChartID(),ref_price_mark,OBJPROP_RAY_RIGHT,false);
      ObjectSetInteger(ChartID(),ref_price_mark,OBJPROP_SELECTABLE,false);
      ObjectSetInteger(ChartID(),ref_price_mark,OBJPROP_WIDTH,2);
      ObjectSetString(ChartID(), ref_price_mark,OBJPROP_TEXT,"Current Price");
      
      // label 1 for the current price mark
      //ObjectCreate(ChartID(),ATR_Label1,OBJ_LABEL,0,0,0);
      int label_x, label_y;
      ChartTimePriceToXY(ChartID(),0,time+HR1*3,ref_price,label_x,label_y);
      //ObjectSetInteger(ChartID(),ATR_Label1,OBJPROP_XDISTANCE,label_x);
      //ObjectSetInteger(ChartID(),ATR_Label1,OBJPROP_YDISTANCE,label_y);
      double local_atr14 = ATR(14,D1barIndex+1);
      //ObjectSetText(ATR_Label1,"ATR14=" + DoubleToString(local_atr14,0),10,"Calibri",clrBlack);
      
      // label 2 for the current price mark
      ObjectCreate(ChartID(),ATR_Label2,OBJ_LABEL,0,0,0);
      ObjectSetInteger(ChartID(),ATR_Label2,OBJPROP_XDISTANCE,label_x);
      ObjectSetInteger(ChartID(),ATR_Label2,OBJPROP_YDISTANCE,label_y);
      double d_min = DayMinBeforeH1Bar(H1barIndex+1);
      double d_max = DayMaxBeforeH1Bar(H1barIndex+1);
      if (ref_price < d_min) d_min = ref_price;
      if (ref_price > d_max) d_max = ref_price;
      double percent_travelled = (d_max - d_min) / local_atr14 / _Point * 10;
      ObjectSetText(ATR_Label2,DoubleToString(percent_travelled,0) + "% of ATR14",10,"Calibri",clrBlack);
   }
   else {
      ATR14_offset = ATR14 * 10 * _Point; // translating point value to price difference
   }

   // if this is the first bar of the day - do not draw the ATR Range - limitation!
   if ( iTime(_Symbol,PERIOD_H1,H1barIndex) == iTime(_Symbol,PERIOD_D1,D1barIndex) )
      return;
   
   // Find min and max of the day where we will draw the ATR Range
   
   double day_min = DayMinBeforeH1Bar(H1barIndex+1);
   double day_max = DayMaxBeforeH1Bar(H1barIndex+1);

   if (ref_price < day_min) day_min = ref_price;
   if (ref_price > day_max) day_max = ref_price;

   if (x != 0 && y != 0) {
      // ************************************ creating day min and max marks ************************************
      ObjectCreate(ChartID(),DayMinBeforeH1Bar_Mark,OBJ_TREND,0,iTime(_Symbol,PERIOD_D1,D1barIndex),day_min,time+HR1*2,day_min);
      ObjectSetInteger(ChartID(),DayMinBeforeH1Bar_Mark,OBJPROP_COLOR,clrBlue);
      ObjectSetInteger(ChartID(),DayMinBeforeH1Bar_Mark,OBJPROP_TIMEFRAMES,PERIOD_H1);
      ObjectSetInteger(ChartID(),DayMinBeforeH1Bar_Mark,OBJPROP_RAY_RIGHT,false);
      ObjectSetInteger(ChartID(),DayMinBeforeH1Bar_Mark,OBJPROP_SELECTABLE,false);
      ObjectSetString(ChartID(), DayMinBeforeH1Bar_Mark,OBJPROP_TEXT,"Low of the day");
   
      ObjectCreate(ChartID(),DayMaxBeforeH1Bar_Mark,OBJ_TREND,0,iTime(_Symbol,PERIOD_D1,D1barIndex),day_max,time+HR1*2,day_max);
      ObjectSetInteger(ChartID(),DayMaxBeforeH1Bar_Mark,OBJPROP_COLOR,clrBlue);
      ObjectSetInteger(ChartID(),DayMaxBeforeH1Bar_Mark,OBJPROP_TIMEFRAMES,PERIOD_H1);
      ObjectSetInteger(ChartID(),DayMaxBeforeH1Bar_Mark,OBJPROP_RAY_RIGHT,false);
      ObjectSetInteger(ChartID(),DayMaxBeforeH1Bar_Mark,OBJPROP_SELECTABLE,false);
      ObjectSetString(ChartID(), DayMaxBeforeH1Bar_Mark,OBJPROP_TEXT,"High of the day");
      // *************************************************************************************************
   }

   //Print("ref_price = " + ref_price + ";    day_min = " + day_min + "    day_max = " + day_max); 
   
   // *** updating offset to different instruments... ***
   if (isOIL() || isCRYPTO() || isGOLD()) {
      ATR14_offset = ATR14_offset * 10;
      if (_Symbol == "DOGECOIN" || _Symbol == "RIPPLE")
         ATR14_offset = ATR14_offset / 10;
      else if (_Symbol == "SOLANA")
         ATR14_offset = ATR14_offset / 100;
   }
   else {
      if (_Symbol == "NQ100" || _Symbol == "SPX500")
         ATR14_offset = ATR14_offset / 10;
   }
    //*** update completed ***
   
   double upper_75_percent_limit    = day_min + ATR14_offset * 0.75;
   double upper_100_percent_limit   = day_min + ATR14_offset * 1;
   
   double lower_75_percent_limit    = day_max - ATR14_offset * 0.75;
   double lower_100_percent_limit   = day_max - ATR14_offset * 1;

   ObjectDeleteSilent(ATR_Range_Upper_LimitRECT_Name);
   ObjectDeleteSilent(ATR_Range_Upper_100_LimitLINE_Name);
   ObjectDeleteSilent(ATR_Range_Lower_LimitRECT_Name);
   ObjectDeleteSilent(ATR_Range_Lower_100_LimitLINE_Name);
   
   datetime time1 = iTime(_Symbol,PERIOD_D1,D1barIndex);
   datetime time2 = time1 + HR2400;
   
   
   // initial value for colors
   color clr_red        = clrBisque;
   color clr_green      = C'185,255,193';
   color clr_calc_upper = clr_green;
   color clr_calc_lower = clr_green;
   
   
   // **************************************************************************************************************
   // **********************    CALCULATING COLOR OF UPPER AND LOWER RECTANGLES **********************
   // **********************    calculating correct color for upper rectangle   **********************
   // 1) If price is currently inside the 75-100% rect
   if (ref_price >= upper_75_percent_limit) clr_calc_upper = clr_red;
   else {
      // 2) Price is now below 75%
      if (PriceWasAboveLevelToday(upper_75_percent_limit, D1barIndex,H1barIndex+1)) {
         // 2.1. Price was above 75% 
         if ( (iHigh(_Symbol, PERIOD_D1, D1barIndex ) - ref_price)/_Point/10 < ATR14/2 )
            // price did not yet travel down more than 1/2 of ATR14 - rect is red! 
            clr_calc_upper = clr_red;
      }   
   }

   // **********************     calculating correct color for lower rectangle   **********************
   // 1) If price is currently inside the 75-100% rect
   if (ref_price <= lower_75_percent_limit) clr_calc_lower = clr_red;
   else {
      // 2) Price is now above 75%
      if (PriceWasBelowLevelToday(lower_75_percent_limit, D1barIndex,H1barIndex+1)) {
         // 2.1. Price was below 75% 
         if ( (ref_price - iLow(_Symbol, PERIOD_D1, D1barIndex ))/_Point/10 < ATR14/2 )
            // price did not yet travel up more than 1/2 of ATR14 - rect is red! 
            clr_calc_lower = clr_red;
      }   
   }
   // **************************************************************************************************************
   // **************************************************************************************************************
   
   
   
   // ********************************************   UPPER LIMIT   ******************************************************************
   //create upper rectangle

   ObjectCreate(ChartID(),ATR_Range_Upper_LimitRECT_Name,OBJ_RECTANGLE,0,time1,upper_100_percent_limit,time2,upper_75_percent_limit);
   ObjectSetInteger(ChartID(),ATR_Range_Upper_LimitRECT_Name,OBJPROP_COLOR,clr_calc_upper);
   ObjectSetInteger(ChartID(),ATR_Range_Upper_LimitRECT_Name,OBJPROP_BACK,true);
   ObjectSetInteger(ChartID(),ATR_Range_Upper_LimitRECT_Name,OBJPROP_TIMEFRAMES,TimeFrameToObjPropTimeFrame(MainTF));
   ObjectSetInteger(ChartID(),ATR_Range_Upper_LimitRECT_Name,OBJPROP_SELECTABLE,false);
   if (!SimulatorMode) ObjectSetString(ChartID(),ATR_Range_Upper_LimitRECT_Name,OBJPROP_TEXT,"75-100% of ATR14 from today's low");
   
   // create upper limiting trend line (short horizontal line)
   ObjectCreate(ChartID(),ATR_Range_Upper_100_LimitLINE_Name,OBJ_TREND,0,time1,upper_100_percent_limit,time2,upper_100_percent_limit);
   ObjectSetInteger(ChartID(),ATR_Range_Upper_100_LimitLINE_Name,OBJPROP_COLOR,clrDarkOrange);
   ObjectSetInteger(ChartID(),ATR_Range_Upper_100_LimitLINE_Name,OBJPROP_RAY_RIGHT,false);
   ObjectSetInteger(ChartID(),ATR_Range_Upper_100_LimitLINE_Name,OBJPROP_WIDTH,2);
   ObjectSetInteger(ChartID(),ATR_Range_Upper_100_LimitLINE_Name,OBJPROP_BACK,true);
   ObjectSetInteger(ChartID(),ATR_Range_Upper_100_LimitLINE_Name,OBJPROP_TIMEFRAMES,TimeFrameToObjPropTimeFrame(MainTF));
   ObjectSetInteger(ChartID(),ATR_Range_Upper_100_LimitLINE_Name,OBJPROP_SELECTABLE,false);
   if (!SimulatorMode) ObjectSetString(ChartID(),ATR_Range_Upper_100_LimitLINE_Name,OBJPROP_TEXT,"100% of ATR14 from today's low");
   


   // ********************************************   LOWER LIMIT   ******************************************************************
   //create lower rectangle
   ObjectCreate(ChartID(),ATR_Range_Lower_LimitRECT_Name,OBJ_RECTANGLE,0,time1,lower_100_percent_limit,time2,lower_75_percent_limit);
   ObjectSetInteger(ChartID(),ATR_Range_Lower_LimitRECT_Name,OBJPROP_COLOR,clr_calc_lower);
   ObjectSetInteger(ChartID(),ATR_Range_Lower_LimitRECT_Name,OBJPROP_BACK,true);
   ObjectSetInteger(ChartID(),ATR_Range_Lower_LimitRECT_Name,OBJPROP_TIMEFRAMES,TimeFrameToObjPropTimeFrame(MainTF));
   ObjectSetInteger(ChartID(),ATR_Range_Lower_LimitRECT_Name,OBJPROP_SELECTABLE,false);
   if (!SimulatorMode) ObjectSetString(ChartID(),ATR_Range_Lower_LimitRECT_Name,OBJPROP_TEXT,"75-100% of ATR14 from today's high");
   
   // create lower limiting trend line (short horizontal line)
   ObjectCreate(ChartID(),ATR_Range_Lower_100_LimitLINE_Name,OBJ_TREND,0,time1,lower_100_percent_limit,time2,lower_100_percent_limit);
   ObjectSetInteger(ChartID(),ATR_Range_Lower_100_LimitLINE_Name,OBJPROP_COLOR,clrDarkOrange);
   ObjectSetInteger(ChartID(),ATR_Range_Lower_100_LimitLINE_Name,OBJPROP_RAY_RIGHT,false);
   ObjectSetInteger(ChartID(),ATR_Range_Lower_100_LimitLINE_Name,OBJPROP_WIDTH,2);
   ObjectSetInteger(ChartID(),ATR_Range_Lower_100_LimitLINE_Name,OBJPROP_BACK,true);
   ObjectSetInteger(ChartID(),ATR_Range_Lower_100_LimitLINE_Name,OBJPROP_TIMEFRAMES,TimeFrameToObjPropTimeFrame(MainTF));
   ObjectSetInteger(ChartID(),ATR_Range_Lower_100_LimitLINE_Name,OBJPROP_SELECTABLE,false);
   if (!SimulatorMode) ObjectSetString(ChartID(),ATR_Range_Lower_100_LimitLINE_Name,OBJPROP_TEXT,"100% of ATR14 from today's high");
   
}







double CTradeManager::DayMinBeforeH1Bar(int H1barIndex) {

   datetime start_time = iTime(_Symbol,PERIOD_H1,H1barIndex);
   int      D1_bar     = iBarShift(_Symbol,PERIOD_D1,start_time);
   datetime end_time   = iTime(_Symbol,PERIOD_D1,D1_bar);
   int      first_bar  = H1barIndex;
   int      last_bar   = iBarShift(_Symbol,PERIOD_H1,end_time);
   double   min_price  = iLow(_Symbol,PERIOD_H1,H1barIndex);
   double   low        = 0;
   
   for (int i = first_bar+1; i <= last_bar; i++) {
      low = iLow(_Symbol,PERIOD_H1,i);
      if (low < min_price)
         min_price = low;
   }     
   return min_price; 
}



double CTradeManager::DayMaxBeforeH1Bar(int H1barIndex) {

   datetime start_time = iTime(_Symbol,PERIOD_H1,H1barIndex);
   int      D1_bar     = iBarShift(_Symbol,PERIOD_D1,start_time);
   datetime end_time   = iTime(_Symbol,PERIOD_D1,D1_bar);
   int      first_bar  = H1barIndex;
   int      last_bar   = iBarShift(_Symbol,PERIOD_H1,end_time);
   double   max_price  = iHigh(_Symbol,PERIOD_H1,H1barIndex);
   double   high       = 0;
   
   for (int i = first_bar+1; i <= last_bar; i++) {
      high = iHigh(_Symbol,PERIOD_H1,i);
      if (high > max_price)
         max_price = high;
   }  
   return max_price; 
}









bool CTradeManager::PriceWasAboveLevelToday(double level, int today_bar_index, int H1_bar) {
   // returns true if price was above the indicated price level today
   // checking only to the left of the H1_bar
   datetime start_time = iTime(_Symbol,PERIOD_H1,H1_bar); // if this is not a current bar - start time if    
   datetime end_time   = iTime(_Symbol,PERIOD_D1,today_bar_index);

   short bars_today = (short)Bars(_Symbol,PERIOD_H1,start_time,end_time);
   
   int first_bar = iBarShift(_Symbol,PERIOD_H1,start_time);
   int last_bar  = iBarShift(_Symbol,PERIOD_H1,end_time);
   
   // cycle through bars of the day, starting from the last bar of that day, counting from right to left
   for (int i = first_bar; i <= last_bar; i++) {
      if ( iHigh(_Symbol,PERIOD_H1,i) > level  ) {
         //Print("PriceWasAboveLevelToday !");
         return true;
      } 
   }
   return false; 
}

bool CTradeManager::PriceWasBelowLevelToday(double level, int today_bar_index, int H1_bar) {
   // returns true if price was above the indicated price level today
   // checking only to the left of the H1_bar
   
   datetime start_time = iTime(_Symbol,PERIOD_H1,H1_bar); // if this is not a current bar - start time if    
   datetime end_time   = iTime(_Symbol,PERIOD_D1,today_bar_index);

   short bars_today = (short)Bars(_Symbol,PERIOD_H1,start_time,end_time);
   
   int first_bar = iBarShift(_Symbol,PERIOD_H1,start_time);
   int last_bar  = iBarShift(_Symbol,PERIOD_H1,end_time);
   
   // cycle through bars of the day, starting from the last bar of that day, counting from right to left
   for (int i = first_bar; i <= last_bar; i++) {
      if ( iLow(_Symbol,PERIOD_H1,i) < level  ) {
         //Print("PriceWasAboveLevelToday !");
         return true;
      } 
   }
   return false;

}


void CTradeManager::Highlight_Entry_Bar(int ticket) {
   // highlighting previous H1 bar

   int random_int = MathRand();
   string rect_name = "Entry Bar for #" + IntegerToString(ticket) + "(" + IntegerToString(random_int) + ")";
   datetime time1 = TimeCurrent() - 60*120; // two hours back
   datetime time2 = TimeCurrent();
   double price1 = iHigh(_Symbol,_Period,1);
   double price2 = iLow(_Symbol,_Period,1);

   if(!ObjectCreate(ChartID(),rect_name,OBJ_RECTANGLE,0,time1,price1,time2,price2))
   {
      Print(__FUNCTION__,": failed to create a rectangle! Error code = ",GetLastError());
      return;
   }
   else {
      ObjectSetInteger(ChartID(),rect_name,OBJPROP_COLOR,clrLawnGreen);
      ObjectSetInteger(0,rect_name,OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4);
      ObjectSetTextMQL4(rect_name,rect_name,12);
      return;
   }
}