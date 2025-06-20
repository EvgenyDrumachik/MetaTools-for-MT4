#ifdef __MQL5__
   #include <Trade\Trade.mqh>
#else
   #include <stdlib.mqh>
#endif 

enum OperationType {
   Order     = 0,
   Position  = 1,
   Deal      = 2,
   Error     = 3,
};

class CMetaTrade

  {
private:

      bool DisableTradingWhenLinesAreHidden, SubtractPositions, SubtractPendingOrders, DoNotApplyStopLoss, DoNotApplyTakeProfit, AskForConfirmation;
      int MaxSlippage, MaxSpread, MaxEntrySLDistance, MinEntrySLDistance, MagicNumber;
      double MaxPositionSize;
      string Commentary;
      
      string FindObjectByPostfix(const string postfix, const ENUM_OBJECT object_type);
      void   CalculateOpenVolume(double &volume_buy, double &volume_sell);
      int    CountDecimalPlaces(double number);
      bool   CheckConfirmation(const ENUM_ORDER_TYPE ot, const double PositionSize, const int ps_decimals, const double sp, const double el, const double sl, const double tp, const int n);

      enum ENTRY_TYPE
      {
          Instant,
          Pending,
          StopLimit
      };


public:
                               CMetaTrade();
                               CMetaTrade(string symbol);
                               CMetaTrade(ulong uTicket);
                              ~CMetaTrade();
      string                   TradeSymbol();
      ulong                    Ticket; 
      double                   OpenPrice();
      datetime                 OpenTime();
      datetime                 OpenDateOnly();
      ENUM_ORDER_TYPE          TradeType();  
      string                   TradeTypeString(); 
      TradeDir                 TradeDirection();
      double                   Profit();
      int                      ProfitPP();
      double                   SL();
      bool                     SL(double new_SL_price);
      double                   SL_Money();
      double                   TP();
      double                   SL_PP_ABS(); // SL in pips (5 digits); absolute value (never negative)
      double                   TP_PP_ABS(); // TP in pips (5 digits); absolute value (never negative)
      double                   SL_PP(); // SL in pips (5 digits)
      double                   TP_PP(); // TP in pips (5 digits)
      bool                     IsBreakEven();
      bool                     IsOpenAndActive();
      double                   GetBreakEvenPrice();
      double                   GetBackwardsBreakPriceDefault(double closest_level_price);
      double                   GetBreakEvenPriceDefault(StrategyID Strategy = S3);
      bool                     IsLimitOrder();
      bool                     IsLimitOrderWith_BE_LevelReached(double BreakEvenPrice);
      double                   DistBetweenPriceAndEntry();
      double                   Lots();
      string                   TradeComment();
      StrategyID               TradeStrategy();
      double                   FourStrings_TradeFiboLevel();
      bool                     DeletePendingOrder();
      
      static bool              OrderSelectMQL4(ulong Ticket);
      static ENUM_ORDER_TYPE   OrderTypeMQL4(ulong Ticket);
      static OperationType     OperationType(ulong Ticket);
      
      void                     OpenTrade(); // copy & paste from PSC Script
  };


CMetaTrade::CMetaTrade() {

}

CMetaTrade::CMetaTrade(string symbol) {
   MaxSlippage = 0;
   MagicNumber = 0;
   Commentary = "MetaTools";
}


CMetaTrade::CMetaTrade(ulong uTicket)
  {
  
  Ticket = uTicket;
  
  //Print("Class CTrade initialized with ticket #: ", Ticket);
  
  }
CMetaTrade::~CMetaTrade()
  {
  }
//+------------------------------------------------------------------+



double CMetaTrade::SL_Money(void) {

   if (OrdersTotal() == 0) {
      Print(__FUNCTION__ + ": No orders open");
      return 0;
   }

   if (!OrderSelectMQL4(Ticket)) {
      Print(__FUNCTION__ + ": Error " + IntegerToString(GetLastError()));
      return 0;
   }  
      
   double sl_money;
   ENUM_ORDER_TYPE trade_type;
   
   trade_type = TradeType();
   
   if (trade_type == ORDER_TYPE_BUY || trade_type == ORDER_TYPE_BUY_LIMIT || trade_type == ORDER_TYPE_BUY_STOP) {
      // some kind of buy order
      //sl_money = (OpenPrice() - SL()) * Lots() * (1 / MarketInfo(TradeSymbol(), MODE_POINT)) * MarketInfo(TradeSymbol(), MODE_TICKVALUE);
      sl_money = (OpenPrice() - SL()) * Lots() * (1 / _Point) * MarketInfoMQL4(TradeSymbol(), MODE_TICKVALUE);
   }
   else {
      // some kind of sell order
      //sl_money = (SL() - OpenPrice()) * Lots() * (1 / MarketInfo(TradeSymbol(), MODE_POINT)) * MarketInfo(TradeSymbol(), MODE_TICKVALUE);
      sl_money = (SL() - OpenPrice()) * Lots() * (1 / _Point) * MarketInfoMQL4(TradeSymbol(), MODE_TICKVALUE);
   }


    
   
   return -NormalizeDouble(sl_money,2);   
}




double CMetaTrade::Lots(void) {

   #ifdef __MQL5__
      OperationType ot = OperationType(Ticket);
      if (ot == Order) return OrderGetDouble(ORDER_VOLUME_CURRENT);
      else return PositionGetDouble(POSITION_VOLUME);
      Print(__FUNCTION__ + ": could not detect operation type. Detected type: " + EnumToString(ot));
      return -1;
   #else 
      if (OrderSelect((int)Ticket,SELECT_BY_TICKET))
         return OrderLots();
      else {
         Print(__FUNCTION__ + ": Error " + IntegerToString(GetLastError()));
         return 0;
      }     
   #endif 
}


double CMetaTrade::DistBetweenPriceAndEntry() {
   //для MQL нужно выбрать Order прежде чем вынимать его параметры

   double price = 0;
   ENUM_ORDER_TYPE trade_type = TradeType();
   string symbol = TradeSymbol();
   double open_price;
   
   // getting latest price of that Symbol
   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(symbol, Latest_Price); // Assign current prices to structure 
   
   if (trade_type == OP_BUY || trade_type == OP_BUYLIMIT || trade_type == OP_BUYSTOP) {
      price = Latest_Price.ask;
      //Print("symbol = " + symbol + "; trade_type = " + EnumToString(trade_type) + "; price = " + price);
   }
   else {
      price = Latest_Price.bid;
   }   
   #ifdef __MQL5__
      OperationType operation_type = OperationType(Ticket);
      if (operation_type == Order)
         open_price = OrderGetDouble(ORDER_PRICE_OPEN);
      else
         open_price = PositionGetDouble(POSITION_PRICE_OPEN);
   #else 
      //string s = OrderSymbol();
      open_price = OpenPrice();
      //Print("symbol = " + symbol + "; open_price = " + open_price);
   #endif 

   return MathAbs(open_price - price) / SymbolInfoDouble(symbol,SYMBOL_POINT) / 10;

}



string CMetaTrade::TradeSymbol(void) {

   #ifdef __MQL5__
      OperationType ot = OperationType(Ticket);
      if (ot == Order) return OrderGetString(ORDER_SYMBOL);
      else return PositionGetString(POSITION_SYMBOL);
      Print(__FUNCTION__ + ": could not detect operation type. Detected type: " + EnumToString(ot));
      return "";
   #else 
      if (OrderSelect((int)Ticket,SELECT_BY_TICKET))
         return OrderSymbol();
      else {
         Print(__FUNCTION__ + ": Error " + IntegerToString(GetLastError()));
         return __FUNCTION__ + ": Error " + IntegerToString(GetLastError());
      }
   #endif 
}



double CMetaTrade::SL(void){

   #ifdef __MQL5__
      OperationType ot = OperationType(Ticket);
      if (ot == Order) return OrderGetDouble(ORDER_SL);
      else return PositionGetDouble(POSITION_SL);
      Print(__FUNCTION__ + ": could not detect operation type. Detected type: " + EnumToString(ot));
      return 0;
   #else
      if (OrderSelect((int)Ticket,SELECT_BY_TICKET))
         return OrderStopLoss();
      else {
         Print(__FUNCTION__ + ": Error " + IntegerToString(GetLastError()));
         return 0;
      }   
   #endif 
}



bool CMetaTrade::SL(double new_SL_price) {

   ushort try = 0;
   bool pos_modified = false;

   while(try<5)  {
      #ifdef __MQL5__
         Print(__FUNCTION__ + ": Write MQL5 code!");
         return false;
         //CTrade trade();
         //trade.PositionModify((int)this.Ticket,new_SL_price,);
      #else 
         pos_modified = OrderModify((int)this.Ticket,OrderOpenPrice(),new_SL_price,OrderTakeProfit(),0);
      #endif 
      if( !pos_modified ) {
         Print(__FUNCTION__ + ": Order Modify error #",GetLastError()," on ",TradeSymbol()," type - ",EnumToString(TradeType()));
         MessageOnChart("Could NOT move SL to Break Even. Try #" + IntegerToString(try), MessageOnChartAppearTime);
         Sleep(1000);
         #ifdef __MQL5__
            // do nothing
         #else 
            RefreshRates();
         #endif 
         try++;
        }
      else {
         Print(__FUNCTION__ + ": SL for order #" + (string)Ticket + " moved back to " + string(new_SL_price));
         return true;
      }
     }
   return false;
}





double CMetaTrade::SL_PP_ABS(){ 

   #ifdef __MQL5__
      // write MQL5 code!
      Print(__FUNCTION__ + ": Write MQL5 code!");
      return 0;   
   #else
      if (OrderSelect((int)Ticket,SELECT_BY_TICKET)) {
         double d_point = MarketInfoMQL4(TradeSymbol(),MODE_POINT);
         double sl_pp = (MathAbs(OpenPrice() - SL())) / d_point;
         return sl_pp;
      }   
      else {
         Print(__FUNCTION__ + ": Error " + IntegerToString(GetLastError()));
         return 0;
      }
   
   #endif 
  
   
}


double CMetaTrade::TP() {

   if (OrderSelectMQL4(Ticket)) {
      #ifdef __MQL5__
         OperationType operation_type = OperationType(Ticket);
         if (operation_type == Order)
            return OrderGetDouble(ORDER_TP);
         else
            return PositionGetDouble(POSITION_TP);
      #else 
         return OrderTakeProfit();
      #endif  
   }
   else {
      Print(__FUNCTION__ + ": Error " + IntegerToString(GetLastError()));
      return 0;
   }
}



double CMetaTrade::TP_PP_ABS(){ 
   #ifdef __MQL5__
      // write MQL5 code!
      return 0;
   #else
      if (OrderSelect((int)Ticket,SELECT_BY_TICKET))
         return (MathAbs(OpenPrice() - TP())) / _Point;
      else {
         Print(__FUNCTION__ + ": Error " + IntegerToString(GetLastError()));
         return 0;
      }  
   #endif 
}




double CMetaTrade::TP_PP(){ 
   // returns positive value, if TP is at its original position - in the positive zone
   // returns negative value, if TP is in negative zone
   
   if (OrderSelectMQL4(Ticket)) {
      ENUM_ORDER_TYPE order_type = TradeType();
      double tp;
      double open_price;
      
      #ifdef __MQL5__
         tp          = OrderGetDouble(ORDER_TP);
         open_price  = OrderGetDouble(ORDER_PRICE_OPEN);
      #else 
         tp          = TP();
         open_price  = OpenPrice();
      #endif  
      
      
      if (order_type == ORDER_TYPE_BUY || order_type == ORDER_TYPE_BUY_LIMIT || order_type == ORDER_TYPE_BUY_STOP) {
         return (tp - open_price) / _Point;
      }
      else { // sell order
         return (open_price - tp) / _Point;
      }
   }
   else {
      Print(__FUNCTION__ + ": Error " + IntegerToString(GetLastError()));
      return 0;
   }
}


double CMetaTrade::SL_PP(){ 
   // returns negative, if SL is at its original location - in the negative zone

   if (OrderSelectMQL4(Ticket)) {
      ENUM_ORDER_TYPE order_type = TradeType();
      if (order_type == ORDER_TYPE_BUY || order_type == ORDER_TYPE_BUY_LIMIT || order_type == ORDER_TYPE_BUY_STOP) {
         return (SL() - OpenPrice()) / _Point;
      }
      else { // sell order
         return (OpenPrice() - SL()) / _Point;
      }
   }
   else {
      Print(__FUNCTION__ + ": Error " + IntegerToString(GetLastError()));
      return 0;
   }
}








double CMetaTrade::Profit() {
   // returns current position's profit
   
   if (!OrderSelectMQL4(Ticket))  {
      Print(__FUNCTION__ + ": Error " + IntegerToString(GetLastError()));
      return 0;
   }
   
   #ifdef __MQL5__
      return PositionGetDouble(POSITION_PROFIT);
   #else
      return OrderProfit();
   #endif 
}




int CMetaTrade::ProfitPP() { 

   if (OrderSelectMQL4(Ticket)){
   
      // including commission and swap
      //  int profit_pp = (int)( (OrderProfit() + OrderCommission() + OrderSwap() ) / OrderLots() / MarketInfo( OrderSymbol(), MODE_TICKVALUE ));
      // changed to account only net profit, without commission and swap
      double order_lots = 0;
      #ifdef __MQL5__
         order_lots = PositionGetDouble(POSITION_VOLUME);
         string symbol = PositionGetString(POSITION_SYMBOL);
         int profit_pp = (int)( Profit() / order_lots / SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_VALUE) ); // MQL5
      #else 
         order_lots = OrderLots();
         int profit_pp = (int)( OrderProfit() / order_lots / MarketInfo( OrderSymbol(), MODE_TICKVALUE ) ); // MQL4
      #endif
      
      //Print(__FUNCTION__ + "profit_pp = " + profit_pp);
      return profit_pp;
   }
   else {
      Print(__FUNCTION__ + ": Error " + IntegerToString(GetLastError()));
      return 0;
   }
}




double CMetaTrade::OpenPrice(void){

   OperationType operation_type = OperationType(Ticket);

   if (OrderSelectMQL4(Ticket))
      #ifdef __MQL5__
         if (operation_type == Order)
            return OrderGetDouble(ORDER_PRICE_OPEN);
         else // this is position
            return PositionGetDouble(POSITION_PRICE_OPEN);
      #else 
         return OrderOpenPrice();
      #endif 
   else { 
      string msg = __FUNCTION__ + ": Error " + IntegerToString(GetLastError()) + "; Ticket: " + IntegerToString(Ticket);
      Print(msg);
      return -1;
   }  
}






bool CMetaTrade::IsBreakEven(void) {

   #ifdef __MQL5__
      // write MQL5 code!
      
      
      return false;
   #else
      if (OrderSelect((int)Ticket,SELECT_BY_TICKET)) {
         int trade_type = TradeType();
         if (trade_type == OP_BUY || trade_type == OP_SELL) {
            // this is an active trade; sell or buy
            if (trade_type == OP_BUY) {  // specifically buy case
               if (SL() < OpenPrice())
                  return false;
               else
                  return true;
            }
            else if (trade_type == OP_SELL) { // specifically sell case
               if (SL() > OpenPrice())
                  return false;
               else
                  return true;
            }
            else 
               return false;
         }
         else // this is a pending (not active order)
            return false;
      }
      
      else { 
         string msg = __FUNCTION__ + ": Error " + IntegerToString(GetLastError());
         Print(msg);
         return false;
      }   
   #endif 

}




   

double CMetaTrade::GetBreakEvenPrice() {

   // 1. Check, if sets.BreakEvenPP() already contains value - then return it; if not then
   // 2. return this.GetBreakEvenPriceDefault()
   
   #ifdef __MQL5__
      // write MQL5 code!
      return 0;
   #else

      int BreakEvenPP_From_sets = sets.BreakEvenPP();     
      if (BreakEvenPP_From_sets != 0) {
         // calculate price of break even, given the break even distance
         double price = OpenPrice();
         int trade_type = TradeType();
         bool buy_order = trade_type == OP_BUY || trade_type == OP_BUYLIMIT || trade_type == OP_BUYSTOP;
         bool be_price_checked = false;
         if (buy_order) {
            price = price + BreakEvenPP_From_sets*10*_Point; // break even is higher than the entry price
            if (price < OrderTakeProfit() || price > OpenPrice()) be_price_checked = true;
         }
         else { // this is some type of the sell order
            price = price - BreakEvenPP_From_sets*10*_Point; // break even is lower than the entry price
            if (price > OrderTakeProfit() || price < OpenPrice()) be_price_checked = true;
         }
         
         Print(__FUNCTION__ + ": BE Price for ticket " + IntegerToString(this.Ticket) + " is " + DoubleToString(price,5));
         
         if (!be_price_checked) {
            string msg = __FUNCTION__ + ": BE calc err! Resetting BE half-way to TP";
            Print(msg);
            MessageOnChart(msg, MessageOnChartAppearTime);
            double TP = OrderTakeProfit();
            double open_price = OpenPrice();
            double delta = MathAbs(TP  - open_price);
            if (buy_order)
               price = open_price + delta / 2;
            else
               price = open_price - delta / 2;
         }
         return price;
      
      }
      else {
      
         return this.GetBreakEvenPriceDefault();
      
      }
      
   #endif 
}




double CMetaTrade::GetBreakEvenPriceDefault(StrategyID Strategy_ID = S3) {
   // default break even price is 90% of SL distance
   
   //#ifdef PROGRAM_INDICATOR // for MetaTools indicator only. Trade.exe doesn't know value of Strategy
         Print("...");
         double be_price;
         int trade_type = TradeType();
         double sl_price = SL();
         double tp_price = TP();
         double entry_price = OpenPrice();
      
         if (trade_type == OP_BUY || trade_type == OP_BUYLIMIT || trade_type == OP_BUYSTOP) {
            if (Strategy_ID == D1)
               be_price = entry_price + (tp_price - entry_price) * 0.7;
            else
               be_price = entry_price + (entry_price - sl_price) * 0.9;
         }
         else {// this is some type of the sell order
            if (Strategy_ID == D1)
               be_price = entry_price - (entry_price - tp_price) * 0.7;
            else
               be_price = entry_price - (sl_price - entry_price) * 0.9;
         }

      return be_price;


   
}




double CMetaTrade::GetBackwardsBreakPriceDefault(double closest_level_price) {
   // calculates price of recommended backwards break level, depending on the order type, current price, size of stop loss and whether there is a closest level
   // 1) if there is a closest level - set BB level behing it
   // 2) if there is no closest level - set BB level as ratio of SL size

   if (closest_level_price != 0) { 
      return closest_level_price;
   }

   // ELSE find and return backwards break level in relation to SL size
   double price = OpenPrice();
   int trade_type = TradeType();
   double sl_size = 0;
   
   #ifdef __MQL5__
      // write MQL5 code!
      return 0;
   #else
      if (trade_type == OP_BUY || trade_type == OP_BUYLIMIT || trade_type == OP_BUYSTOP) {
         sl_size = OpenPrice() - SL();
         price = price - sl_size * 0.2; // buy order - backwards break level should be lower than entry
      }
      else {// this is some type of the sell order
         sl_size = SL() - OpenPrice();
         price = price + sl_size * 0.2; // sell order - backwards break level should be higher than entry
      }
      
      return price;
   #endif 
}



bool CMetaTrade::IsLimitOrder() {

   ENUM_ORDER_TYPE order_type = TradeType();

   if (order_type == OP_BUYLIMIT || order_type == OP_SELLLIMIT) {
      return true;
   }
   else 
      return false;
}


bool CMetaTrade::IsLimitOrderWith_BE_LevelReached(double BreakEvenPrice) {
   // проверка, если это лимитный ордер, то проверяется достигла ли цена БИД (и для покупок и для продаж)
   // уровня б/у

   if (BreakEvenPrice == 0) return false; // break even is not yet set
   
   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(Symbol() ,Latest_Price); // Assign current prices to structure 
   
   ENUM_ORDER_TYPE order_type = TradeType();

   if (order_type == OP_BUYLIMIT) {
      
      if (Latest_Price.bid >= BreakEvenPrice) return true;
      else return false;
      
   }
   else if (order_type == OP_SELLLIMIT) {

      if (Latest_Price.bid <= BreakEvenPrice) return true; // look at Bid (not Ask) intentionally as it is drawing the chart
      else return false;
      
   }
   else 
      return false;
}

bool CMetaTrade::IsOpenAndActive() {

   bool is_open = false;
   
   #ifdef __MQL5__
      is_open = OrderSelect(Ticket); // selecting from currently running trades; if selected - it is active
   #else
      is_open = OrderSelect((int)Ticket,SELECT_BY_TICKET,MODE_TRADES); // selecting from currently running trades; if selected - it is active
   #endif 
   
   
   ENUM_ORDER_TYPE ot = TradeType();
   bool is_active;

   if (ot == ORDER_TYPE_BUY || ot == ORDER_TYPE_SELL) // making sure that this order is not pending
      is_active = true;
   else
      is_active = false;
      
      
   if (is_open && is_active) return true;
   else return false;
}




string CMetaTrade::TradeComment(void){

   if (OrderSelectMQL4(Ticket))
      #ifdef __MQL5__
         if (OperationType(Ticket) == Order)
            return OrderGetString(ORDER_COMMENT);
         else
            return PositionGetString(POSITION_COMMENT);
      #else 
         return OrderComment();
      #endif 
   else { 
      string msg = __FUNCTION__ + ": Error " + IntegerToString(GetLastError());
      Print(msg);
      return "Error" + IntegerToString(GetLastError());
   }

}


StrategyID CMetaTrade::TradeStrategy() {

   string comment = TradeComment();
   
   if (StringFind(comment,"S3") != -1 ) return S3;
   if (StringFind(comment,"D1") != -1 ) return D1;
   if (StringFind(comment,"BF") != -1 ) return BF;
   if (StringFind(comment,"FourStrings") != -1 ) return FourStrings;
   if (StringFind(comment,"Other") != -1 ) return Other;
   return Other;

}


double CMetaTrade::FourStrings_TradeFiboLevel() {

   string comment = TradeComment();
   if (StringFind(comment,"23.6%") != -1 ) return 23.6;
   if (StringFind(comment,"38.2%") != -1 ) return 38.2;
   if (StringFind(comment,"50%") != -1 ) return 50;
   if (StringFind(comment,"61.8%") != -1 ) return 61.8;
   return 0;

}






bool CMetaTrade::DeletePendingOrder(){

   if (!OrderSelectMQL4(Ticket)) {
      Print(__FUNCTION__ + ": Could not select order with ticket #" + IntegerToString(Ticket) + "");
      return false;
   }
   
   #ifdef __MQL5__
      MqlTradeRequest   request;
      MqlTradeResult    result;
      request.action    = TRADE_ACTION_REMOVE;
      request.order     = Ticket;
      return(OrderSend(request,result));
   #else   
      if (!OrderDelete((int)Ticket)) {
         Print(__FUNCTION__ + ": Could not delete order with ticket #" + IntegerToString(Ticket) + "");
         return false;
      }
      else
         return true;
   #endif 

}



datetime CMetaTrade::OpenTime() {

   bool order_selected = false;
   
   #ifdef __MQL5__
      order_selected = OrderSelect(Ticket);
   #else
      order_selected = OrderSelect((int)Ticket,SELECT_BY_TICKET);
   #endif 

   if (!order_selected) {
      Print(__FUNCTION__ + ": Could not select order with ticket #" + IntegerToString(Ticket) + "");
      return 0;
   }
   
    #ifdef __MQL5__
      return (datetime)PositionGetInteger(POSITION_TIME);
    #else
      return OrderOpenTime();
   #endif 
}


datetime CMetaTrade::OpenDateOnly() {
   // return open date of the order (without time; time is 00:00:00)
   datetime open_time      = OpenTime();
   datetime open_date_only = StringToTime(IntegerToString(TimeYearMQL4(open_time)) + "." + IntegerToString(TimeMonthMQL4(open_time)) + "." + IntegerToString(TimeDayMQL4(open_time)));
   return open_date_only;
}


int TimeDayMQL4(datetime date)
  {
   MqlDateTime tm;
   TimeToStruct(date,tm);
   return(tm.day);
  }
  
int TimeYearMQL4(datetime date)
  {
   MqlDateTime tm;
   TimeToStruct(date,tm);
   return(tm.year);
  }
  
  
  
  
bool CMetaTrade::OrderSelectMQL4(ulong Ticket) {

   if (Ticket == 0) {
      Print(__FUNCTION__ + ": incorrect use of function. Ticket should not be 0");
      return false;
   }
  
   
   #ifdef __MQL5__
      // trying to select order
      
      if (OrderSelect(Ticket))
         return true;   
      else
         return PositionSelectByTicket(Ticket);
            
   #else 
      // for MQL4
      return OrderSelect((int)Ticket,SELECT_BY_TICKET);
   
   #endif 
   
}



ENUM_ORDER_TYPE CMetaTrade::OrderTypeMQL4(ulong Ticket) {

   OperationType operation_type = OperationType(Ticket);
   OrderSelectMQL4(Ticket);
   
   #ifdef __MQL5__
      if (operation_type == Order) return (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
      else if (operation_type == Position) return (ENUM_ORDER_TYPE)PositionGetInteger(POSITION_TYPE);
      else return 0;
   #else 
      return (ENUM_ORDER_TYPE)OrderType();
   #endif 
}



OperationType CMetaTrade::OperationType(ulong Ticket) {
   if (Ticket == 0) {
      Print(__FUNCTION__ + ": incorrect use of function. Ticket should not be 0");
      return Error;
   }
  
   #ifdef __MQL5__
      // trying to select order
      if (OrderSelect(Ticket))
         return Order;   
      else if (PositionSelectByTicket(Ticket))
         return Position;
      else return Error;
   #else 
      // for MQL4
      return Order;
   #endif 
}


ENUM_ORDER_TYPE CMetaTrade::TradeType() {

   // for MQL4
   //OP_BUY - buy order,
   //OP_SELL - sell order,
   //OP_BUYLIMIT - buy limit pending order,
   //OP_BUYSTOP - buy stop pending order,
   //OP_SELLLIMIT - sell limit pending order,
   //OP_SELLSTOP - sell stop pending order.

   // for MQL5
   //ORDER_TYPE_BUY
   //ORDER_TYPE_SELL
   //ORDER_TYPE_BUY_LIMIT
   //ORDER_TYPE_SELL_LIMIT
   //ORDER_TYPE_BUY_STOP
   //ORDER_TYPE_SELL_STOP
   //ORDER_TYPE_BUY_STOP_LIMIT
   //ORDER_TYPE_SELL_STOP_LIMIT
   //ORDER_TYPE_CLOSE_BY

   bool trade_selected = false;
   
   #ifdef __MQL5__
      trade_selected = OrderSelect(Ticket); // search among pending orders
      if (!trade_selected)
         trade_selected = PositionSelectByTicket(Ticket); // search among open positions
   #else
      trade_selected = OrderSelect((int)Ticket,SELECT_BY_TICKET);
   #endif  

   if (trade_selected)
      return OrderTypeMQL4(Ticket);
   else {
      Print(__FUNCTION__ + ": Error " + IntegerToString(GetLastError()) + "; ticket: " + IntegerToString(Ticket));
      return NULL;
   }
}

string CMetaTrade::TradeTypeString() {

   ENUM_ORDER_TYPE trade_type = TradeType();
   
   if (trade_type == OP_BUY) return "Buy";
   else if (trade_type == OP_SELL) return "Sell";
   else if (trade_type == OP_BUYLIMIT) return "Buy Limit";
   else if (trade_type == OP_BUYSTOP) return "Buy Stop";
   else if (trade_type == OP_SELLLIMIT) return "Sell Limit";
   else if (trade_type == OP_SELLSTOP) return "Sell Stop";
   else return __FUNCTION__ + ": Error determining order type";
}


TradeDir CMetaTrade::TradeDirection() {

   bool order_selected = false;
   
   #ifdef __MQL5__
      order_selected = OrderSelect(Ticket);
   #else
      order_selected = OrderSelect((int)Ticket,SELECT_BY_TICKET);
   #endif    

   if (order_selected) {
      ENUM_ORDER_TYPE ot = OrderTypeMQL4(Ticket);
      if(ot == OP_BUY || ot == OP_BUYLIMIT || ot == OP_BUYSTOP) return TradeDir_BUY;
      else if (ot == OP_SELL || ot == OP_SELLLIMIT || ot == OP_SELLSTOP) return TradeDir_SELL;
   }
   else {
      Print(__FUNCTION__ + ": Error " + IntegerToString(GetLastError()) + "; Ticket: " + IntegerToString(Ticket));
      return TradeDir_NONE;
   }
   
   return TradeDir_NONE;

}
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  





#ifdef __MQL5__
         //+------------------------------------------------------------------+
         //| Script execution function.                                       |
         //+------------------------------------------------------------------+
         void CMetaTrade::OpenTrade()
         {
             double Window;
             CTrade *Trade; // for PSC script (Open Trade function)
         
             string ps = ""; // Position size string.
             double el = 0, sl = 0, tp = 0, sp = 0; // Entry level, stop-loss, take-profit, and stop price.
             ENUM_ORDER_TYPE ot; // Order type.
             ENTRY_TYPE entry_type = Instant;
         
             if (!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))
             {
                 Alert("Algo Trading disabled! Please enable Algo Trading.");
                 return;
             }
         
             Window = ChartWindowFind(0, "Position Size Calculator" + IntegerToString(ChartID()));
         
             if (Window == -1)
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
             
             MqlTick Latest_Price; // Structure to get the latest prices      
             SymbolInfoTick(Symbol() ,Latest_Price); // Assign current prices to structure 
         
             // Replace thousand separaptors.
             StringReplace(ps, ",", "");
         
             double PositionSize = StringToDouble(ps);
             int ps_decimals = CountDecimalPlaces(PositionSize);
         
             Print("Detected position size: ", DoubleToString(PositionSize, ps_decimals), ".");
         
             double MinLot = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN);
             double MaxLot = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MAX);
             double LotStep = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
         
             if (PositionSize <= 0)
             {
                 Print("Wrong position size value!");
                 return;
             }
         
             string ObjectPrefix = ""; // To be found.
             string el_name = FindObjectByPostfix("EntryLine", OBJ_HLINE);
             int el_name_starts_at = StringFind(el_name, "EntryLine");
             if (el_name_starts_at > 0) ObjectPrefix = StringSubstr(el_name, 0, el_name_starts_at);
             el = ObjectGetDouble(0, ObjectPrefix + "EntryLine", OBJPROP_PRICE);
             if (el <= 0)
             {
                 Alert("Entry Line not found!");
                 return;
             }
         
             el = NormalizeDouble(el, _Digits);
             Print("Detected entry level: ", DoubleToString(el, _Digits), ".");
         
             string et = FindObjectByPostfix("m_BtnOrderType", OBJ_BUTTON);
             et = ObjectGetString(0, et, OBJPROP_TEXT);
             if (et == "Instant") entry_type = Instant;
             else if (et == "Pending") entry_type = Pending;
             else if (et == "Stop Limit") entry_type = StopLimit;
         
             Print("Detected entry type: ", EnumToString(entry_type), ".");
         
             sl = ObjectGetDouble(0, ObjectPrefix + "StopLossLine", OBJPROP_PRICE);
             if (sl <= 0)
             {
                 Alert("Stop-Loss Line not found!");
                 return;
             }
             sl = NormalizeDouble(sl, _Digits);
             Print("Detected stop-loss level: ", DoubleToString(sl, _Digits), ".");
         
         
             tp = ObjectGetDouble(0, ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE);
             if (tp > 0)
             {
                 tp = NormalizeDouble(tp, _Digits);
                 Print("Detected take-profit level: ", DoubleToString(tp, _Digits), ".");
             }
             else Print("No take-profit detected.");
         
             if (entry_type == StopLimit)
             {
                 sp = ObjectGetDouble(0, ObjectPrefix + "StopPriceLine", OBJPROP_PRICE);
                 if (sp > 0)
                 {
                     sp = NormalizeDouble(sp, _Digits);
                     Print("Detected stop price level: ", DoubleToString(sp, _Digits), ".");
                 }
                 else
                 {
                     Alert("No stop price line detected for Stop Limit order!");
                     return;
                 }
             }
         
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
         
             if ((n == 0) || (AccountInfoInteger(ACCOUNT_MARGIN_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_NETTING))
             {
                 if (n > 0)
                 {
                     Print("Netting mode detected. Multiple TPs won't work. Setting one TP at 100% volume.");
                 }
                 // No multiple TPs, use single TP for 100% of volume.
                 n = 1;
                 ScriptTPValue[0] = tp;
                 ScriptTPShareValue[0] = 100;
             }
         
             // Magic number
             string EdtMagicNumber = FindObjectByPostfix("m_EdtMagicNumber", OBJ_EDIT);
             if (EdtMagicNumber != "") MagicNumber = (int)StringToInteger(ObjectGetString(0, EdtMagicNumber, OBJPROP_TEXT));
             Print("Magic number = ", MagicNumber);
         
             // Order commentary
             string EdtScriptCommentary = FindObjectByPostfix("m_EdtScriptCommentary", OBJ_EDIT);
             if (EdtScriptCommentary != "") Commentary = ObjectGetString(0, EdtScriptCommentary, OBJPROP_TEXT);
             Print("Order commentary = ", Commentary);
         
             // Checkbox
             string ChkDisableTradingWhenLinesAreHidden = FindObjectByPostfix("m_ChkDisableTradingWhenLinesAreHiddenButton", OBJ_BITMAP_LABEL);
             if (StringLen(ChkDisableTradingWhenLinesAreHidden) > 0) DisableTradingWhenLinesAreHidden = ObjectGetInteger(0, ChkDisableTradingWhenLinesAreHidden, OBJPROP_STATE);
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
         
             // Edits
             string EdtMaxSlippage = FindObjectByPostfix("m_EdtMaxSlippage", OBJ_EDIT);
             if (StringLen(EdtMaxSlippage) > 0) MaxSlippage = (int)StringToInteger(ObjectGetString(0, EdtMaxSlippage, OBJPROP_TEXT));
             Print("Max slippage = ", MaxSlippage);
         
             string EdtMaxSpread = FindObjectByPostfix("m_EdtMaxSpread", OBJ_EDIT);
             if (StringLen(EdtMaxSpread) > 0) MaxSpread = (int)StringToInteger(ObjectGetString(0, EdtMaxSpread, OBJPROP_TEXT));
             Print("Max spread = ", MaxSpread);
         
             if (MaxSpread > 0)
             {
                 int spread = (int)SymbolInfoInteger(Symbol(), SYMBOL_SPREAD);
                 if (spread > MaxSpread)
                 {
                     Print("Not taking a trade - current spread (", spread, ") > maximum spread (", MaxSpread, ").");
                     return;
                 }
             }
         
             string EdtMaxEntrySLDistance = FindObjectByPostfix("m_EdtMaxEntrySLDistance", OBJ_EDIT);
             if (StringLen(EdtMaxEntrySLDistance) > 0) MaxEntrySLDistance = (int)StringToInteger(ObjectGetString(0, EdtMaxEntrySLDistance, OBJPROP_TEXT));
             Print("Max Entry/SL distance = ", MaxEntrySLDistance);
         
             if (MaxEntrySLDistance > 0)
             {
                 int CurrentEntrySLDistance = (int)(MathAbs(sl - el) / Point());
                 if (CurrentEntrySLDistance > MaxEntrySLDistance)
                 {
                     Print("Not taking a trade - current Entry/SL distance (", CurrentEntrySLDistance, ") > maximum Entry/SL distance (", MaxEntrySLDistance, ").");
                     return;
                 }
             }
         
             string EdtMinEntrySLDistance = FindObjectByPostfix("m_EdtMinEntrySLDistance", OBJ_EDIT);
             if (StringLen(EdtMinEntrySLDistance) > 0) MinEntrySLDistance = (int)StringToInteger(ObjectGetString(0, EdtMinEntrySLDistance, OBJPROP_TEXT));
             Print("Min Entry/SL distance = ", MinEntrySLDistance);
         
             if (MinEntrySLDistance > 0)
             {
                 int CurrentEntrySLDistance = (int)(MathAbs(sl - el) / Point());
                 if (CurrentEntrySLDistance < MinEntrySLDistance)
                 {
                     Print("Not taking a trade - current Entry/SL distance (", CurrentEntrySLDistance, ") < minimum Entry/SL distance (", MinEntrySLDistance, ").");
                     return;
                 }
             }
         
             string EdtMaxPositionSize = FindObjectByPostfix("m_EdtMaxPositionSize", OBJ_EDIT);
             if (StringLen(EdtMaxPositionSize) > 0) MaxPositionSize = StringToDouble(ObjectGetString(0, EdtMaxPositionSize, OBJPROP_TEXT));
             Print("Max position size = ", DoubleToString(MaxPositionSize, ps_decimals));
         
             // Checkbox for subtracting open positions volume from the position size.
             string ChkSubtractPositions = FindObjectByPostfix("m_ChkSubtractPositionsButton", OBJ_BITMAP_LABEL);
             if (StringLen(ChkSubtractPositions) > 0) SubtractPositions = ObjectGetInteger(0, ChkSubtractPositions, OBJPROP_STATE);
             Print("Subtract open positions volume = ", SubtractPositions);
         
             // Checkbox for subtracting pending orders volume from the position size.
             string ChkSubtractPendingOrders = FindObjectByPostfix("m_ChkSubtractPendingOrdersButton", OBJ_BITMAP_LABEL);
             if (StringLen(ChkSubtractPendingOrders) > 0) SubtractPendingOrders = ObjectGetInteger(0, ChkSubtractPendingOrders, OBJPROP_STATE);
             Print("Subtract pending orders volume = ", SubtractPendingOrders);
         
             // Checkbox for not applying stop-loss to the position.
             string ChkDoNotApplyStopLoss = FindObjectByPostfix("m_ChkDoNotApplyStopLossButton", OBJ_BITMAP_LABEL);
             if (ChkDoNotApplyStopLoss != "") DoNotApplyStopLoss = ObjectGetInteger(0, ChkDoNotApplyStopLoss, OBJPROP_STATE);
             Print("Do not apply stop-loss = ", DoNotApplyStopLoss);
         
             // Checkbox for not applying take-profit to the position.
             string ChkDoNotApplyTakeProfit = FindObjectByPostfix("m_ChkDoNotApplyTakeProfitButton", OBJ_BITMAP_LABEL);
             if (ChkDoNotApplyTakeProfit != "") DoNotApplyTakeProfit = ObjectGetInteger(0, ChkDoNotApplyTakeProfit, OBJPROP_STATE);
             Print("Do not apply take-profit = ", DoNotApplyTakeProfit);
         
             // Checkbox for asking for confirmation.
             string ChkAskForConfirmation = FindObjectByPostfix("m_ChkAskForConfirmationButton", OBJ_BITMAP_LABEL);
             if (ChkAskForConfirmation != "") AskForConfirmation = ObjectGetInteger(0, ChkAskForConfirmation, OBJPROP_STATE);
             Print("Ask for confirmation = ", AskForConfirmation);
         
             Trade = new CTrade;
             Trade.SetDeviationInPoints(MaxSlippage);
             if (MagicNumber > 0) Trade.SetExpertMagicNumber(MagicNumber);
         
             ENUM_SYMBOL_TRADE_EXECUTION Execution_Mode = (ENUM_SYMBOL_TRADE_EXECUTION)SymbolInfoInteger(Symbol(), SYMBOL_TRADE_EXEMODE);
             Print("Execution mode: ", EnumToString(Execution_Mode));
         
             if (SymbolInfoInteger(Symbol(), SYMBOL_FILLING_MODE) == SYMBOL_FILLING_FOK)
             {
                 Print("Order filling mode: Fill or Kill.");
                 Trade.SetTypeFilling(ORDER_FILLING_FOK);
             }
             else if (SymbolInfoInteger(Symbol(), SYMBOL_FILLING_MODE) == SYMBOL_FILLING_IOC)
             {
                 Print("Order filling mode: Immediate or Cancel.");
                 Trade.SetTypeFilling(ORDER_FILLING_IOC);
             }
         
             double existing_volume_buy = 0, existing_volume_sell = 0;
             if ((SubtractPendingOrders) || (SubtractPositions))
             {
                 CalculateOpenVolume(existing_volume_buy, existing_volume_sell);
                 Print("Found existing buy volume = ", DoubleToString(existing_volume_buy, ps_decimals));
                 Print("Found existing sell volume = ", DoubleToString(existing_volume_sell, ps_decimals));
             }
         
             bool isOrderPlacementFailing = false;  // Track if any of the order-operations fail.
         
             if ((entry_type == Pending) || (entry_type == StopLimit))
             {
                 // Sell
                 if (sl > el)
                 {
                     // Stop
                     if (el < Latest_Price.bid) ot = ORDER_TYPE_SELL_STOP;
                     // Limit
                     else ot = ORDER_TYPE_SELL_LIMIT;
                     // Stop Limit
                     if (entry_type == StopLimit) ot = ORDER_TYPE_SELL_STOP_LIMIT;
                 }
                 // Buy
                 else
                 {
                     // Stop
                     if (el > Latest_Price.ask) ot = ORDER_TYPE_BUY_STOP;
                     // Limit
                     else ot = ORDER_TYPE_BUY_LIMIT;
                     // Stop Limit
                     if (entry_type == StopLimit) ot = ORDER_TYPE_BUY_STOP_LIMIT;
                 }
         
                 if ((SubtractPendingOrders) || (SubtractPositions))
                 {
                     if ((ot == ORDER_TYPE_BUY_LIMIT) || (ot == ORDER_TYPE_BUY_STOP) || (ot == ORDER_TYPE_BUY_STOP_LIMIT)) PositionSize -= existing_volume_buy;
                     else PositionSize -= existing_volume_sell;
                     Print("Adjusted position size = ", DoubleToString(PositionSize, 2));
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
         
                 if ((AskForConfirmation) && (!CheckConfirmation(ot, PositionSize, ps_decimals, sp, el, sl, tp, n)))
                 {
                     delete Trade;
                     return;
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
                     tp = NormalizeDouble(ScriptTPValue[j], _Digits);
                     double position_size = NormalizeDouble(ArrayPositionSize[j], LotStep_digits);
         
                     if (DoNotApplyStopLoss) sl = 0;
                     if (DoNotApplyTakeProfit) tp = 0;
         
                     if (!Trade.OrderOpen(Symbol(), ot, position_size, entry_type == StopLimit ? el : 0, entry_type == StopLimit ? sp : el, sl, tp, 0, 0, Commentary))
                     {
                         Print("Error sending order: ", Trade.ResultRetcodeDescription() + ".");
                         isOrderPlacementFailing = true;
                     }
                     else
                     {
                         if (n == 1) Print("Order executed. Ticket: ", Trade.ResultOrder(), ".");
                         else Print("Order #", j, " executed. Ticket: ", Trade.ResultOrder(), ".");
                     }
                 }
             }
             // Instant
             else
             {
                 // Sell
                 if (sl > el) ot = ORDER_TYPE_SELL;
                 // Buy
                 else ot = ORDER_TYPE_BUY;
         
                 if ((SubtractPendingOrders) || (SubtractPositions))
                 {
                     if (ot == ORDER_TYPE_BUY) PositionSize -= existing_volume_buy;
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
         
                 if ((AskForConfirmation) && (!CheckConfirmation(ot, PositionSize, ps_decimals, sp, el, sl, tp, n)))
                 {
                     delete Trade;
                     return;
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
         
                     if (!Trade.PositionOpen(Symbol(), ot, position_size, el, order_sl, order_tp, Commentary))
                     {
                         Print("Error sending order: ", Trade.ResultRetcodeDescription() + ".");
                         isOrderPlacementFailing = true;
                     }
                     else
                     {
                         MqlTradeResult result;
                         Trade.Result(result);
                         if ((Trade.ResultRetcode() != 10008) && (Trade.ResultRetcode() != 10009) && (Trade.ResultRetcode() != 10010))
                         {
                             Print("Error opening a position. Return code: ", Trade.ResultRetcodeDescription());
                             isOrderPlacementFailing = true;
                             break;
                         }
         
                         Print("Initial return code: ", Trade.ResultRetcodeDescription());
         
                         ulong order = result.order;
                         Print("Order ID: ", order);
         
                         ulong deal = result.deal;
                         Print("Deal ID: ", deal);
                         if (!DoNotApplyTakeProfit) tp = ScriptTPValue[j];
                         // Market execution mode - application of SL/TP.
                         if ((Execution_Mode == SYMBOL_TRADE_EXECUTION_MARKET) && (entry_type == Instant) && ((sl != 0) || (tp != 0)))
                         {
                             // Not all brokers return deal.
                             if (deal != 0)
                             {
                                 if (HistorySelect(TimeCurrent() - 60, TimeCurrent()))
                                 {
                                     if (HistoryDealSelect(deal))
                                     {
                                         long position = HistoryDealGetInteger(deal, DEAL_POSITION_ID);
                                         Print("Position ID: ", position);
         
                                         if (!Trade.PositionModify(position, sl, tp))
                                         {
                                             Print("Error modifying position: ", GetLastError());
                                             isOrderPlacementFailing = true;
                                         }
                                         else Print("SL/TP applied successfully.");
                                     }
                                     else
                                     {
                                         Print("Error selecting deal: ", GetLastError());
                                         isOrderPlacementFailing = true;
                                     }
                                 }
                                 else
                                 {
                                     Print("Error selecting deal history: ", GetLastError());
                                     isOrderPlacementFailing = true;
                                 }
                             }
                             // Wait for position to open then find it using the order ID.
                             else
                             {
                                 // Run a waiting cycle until the order becomes a positoin.
                                 for (int i = 0; i < 10; i++)
                                 {
                                     Print("Waiting...");
                                     Sleep(1000);
                                     if (PositionSelectByTicket(order)) break;
                                 }
                                 if (!PositionSelectByTicket(order))
                                 {
                                     Print("Error selecting position: ", GetLastError());
                                     isOrderPlacementFailing = true;
                                 }
                                 else
                                 {
                                     if (!Trade.PositionModify(order, sl, tp))
                                     {
                                         Print("Error modifying position: ", GetLastError());
                                         isOrderPlacementFailing = true;
                                     }
                                     else Print("SL/TP applied successfully.");
                                 }
                             }
                         }
                     }
                 }
             }
             if (n > 0) PlaySound(isOrderPlacementFailing ? "timeout.wav" : "ok.wav");
         
             delete Trade;
         }
         
         //+------------------------------------------------------------------+
         //| Finds a chart object by name's postfix. Returns object's name.   |
         //+------------------------------------------------------------------+
         string CMetaTrade::FindObjectByPostfix(const string postfix, const ENUM_OBJECT object_type)
         {
             int obj_total = ObjectsTotal(0, 0, object_type);
             string name = "";
             bool found = false;
             for (int i = 0; i < obj_total; i++)
             {
                 name = ObjectName(0, i, 0, object_type);
                 string pattern = StringSubstr(name, StringLen(name) - StringLen(postfix));
                 if (StringCompare(pattern, postfix) == 0) return name;
             }
             return "";
         }
         
         // Calculate volume of open positions and/or pending orders.
         // Counts volumes separately for buy and sell trades and writes them into parameterss.
         void CMetaTrade::CalculateOpenVolume(double &volume_buy, double &volume_sell)
         {
             if (SubtractPendingOrders)
             {
                 int total = OrdersTotal();
                 for (int i = 0; i < total; i++)
                 {
                     // Select an order.
                     if (!OrderSelect(OrderGetTicket(i))) continue;
                     // Skip orders with a different trading instrument.
                     if (OrderGetString(ORDER_SYMBOL) != _Symbol) continue;
                     // If magic number is given via PSC panel and order's magic number is different - skip.
                     if ((MagicNumber != 0) && (OrderGetInteger(ORDER_MAGIC) != MagicNumber)) continue;
         
                     // Buy orders
                     if ((OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_LIMIT) || (OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_STOP)) volume_buy += OrderGetDouble(ORDER_VOLUME_CURRENT);
                     // Sell orders
                     else if ((OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_LIMIT) || (OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_STOP)) volume_sell += OrderGetDouble(ORDER_VOLUME_CURRENT);
                 }
             }
         
             if (SubtractPositions)
             {
                 int total = PositionsTotal();
                 for (int i = 0; i < total; i++)
                 {
                     // Works with hedging and netting.
                     if (!PositionSelectByTicket(PositionGetTicket(i))) continue;
                     // Skip positions with a different trading instrument.
                     if (PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
                     // If magic number is given via PSC panel and position's magic number is different - skip.
                     if ((MagicNumber != 0) && (PositionGetInteger(POSITION_MAGIC) != MagicNumber)) continue;
         
                     // Long positions
                     if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) volume_buy += PositionGetDouble(POSITION_VOLUME);
                     // Short positions
                     else if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) volume_sell += PositionGetDouble(POSITION_VOLUME);
                 }
             }
         }
         
         //+------------------------------------------------------------------+
         //| Counts decimal places.                                           |
         //+------------------------------------------------------------------+
         int CMetaTrade::CountDecimalPlaces(double number)
         {
             // 100 as maximum length of number.
             for (int i = 0; i < 100; i++)
             {
                 double pwr = MathPow(10, i);
                 if (MathRound(number * pwr) / pwr == number) return i;
             }
             return -1;
         }
         
         //+------------------------------------------------------------------+
         //| Check confirmation for order opening via dialog window.          |
         //+------------------------------------------------------------------+
         bool CMetaTrade::CheckConfirmation(const ENUM_ORDER_TYPE ot, const double PositionSize, const int ps_decimals, const double sp, const double el, const double sl, const double tp, const int n)
         {
             // Evoke confirmation modal window.
             string caption = "Execute the trade?";
             string message;
             string order_type_text = "";
             string currency = AccountInfoString(ACCOUNT_CURRENCY);
             switch(ot)
             {
             case ORDER_TYPE_BUY:
                 order_type_text = "Buy";
                 break;
             case ORDER_TYPE_BUY_STOP:
                 order_type_text = "Buy Stop";
                 break;
             case ORDER_TYPE_BUY_LIMIT:
                 order_type_text = "Buy Limit";
                 break;
             case ORDER_TYPE_BUY_STOP_LIMIT:
                 order_type_text = "Buy Stop Limit";
                 break;
             case ORDER_TYPE_SELL:
                 order_type_text = "Sell";
                 break;
             case ORDER_TYPE_SELL_STOP:
                 order_type_text = "Sell Stop";
                 break;
             case ORDER_TYPE_SELL_LIMIT:
                 order_type_text = "Sell Limit";
                 break;
             case ORDER_TYPE_SELL_STOP_LIMIT:
                 order_type_text = "Sell Stop Limit";
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
         
             if (sp > 0) message += "Stop price: " + DoubleToString(sp, _Digits) + "\n";
             message += "Entry: " + DoubleToString(el, _Digits) + "\n";
             if (!DoNotApplyStopLoss) message += "Stop-loss: " + DoubleToString(sl, _Digits) + "\n";
             if ((tp > 0) && (!DoNotApplyTakeProfit)) message += "Take-profit: " + DoubleToString(tp, _Digits);
             if (n > 1) message += " (multiple)";
             message += "\n";
         
             int ret = MessageBox(message, caption, MB_OKCANCEL | MB_ICONWARNING);
             if (ret == IDCANCEL)
             {
                 Print("Trade canceled.");
                 return false;
             }
             return true;
         }
         //+-------------------------------
#endif 