#property strict
class CTradesArray
  {
private:
string               m_symbol;

public:
                        CTradesArray();
                        CTradesArray(string symbol);
   void                 Symbol(string symbol);
                       ~CTradesArray();
   CMetaTrade*          Trades[];
   int                  TradesCount();
   int                  LimitTradesCountOnSymbol(string symbol);
   bool                 Update();
   int                  TradesOpenOnChart(long chartid);
   int                  TradesOpenOnSymbol(string symbol, bool CountOnlyActive = false);
   int                  TradesActiveOnSymbolSameDirection(string symbol, DayPriorityID Dir);
   int                  TradesPendingOnSymbol(string symbol);
   int                  TradesOpenOnSymbolAtPrice(string symbol, double price);
   int                  ProfitableTradesOpenOnSymbolNotBreakEven(string symbol);
   bool                 AllTradesAtBreakEvenOnSymbol(string symbol);
   bool                 AllTradesInProfitOnSymbol(string symbol);
   bool                 TradesInMinLossModeExistOnSymbol(string symbol);
   ulong                SingleLossTradeOnSymbolNotInMinLoss(string symbol);
   TradeDir             TradeDirection(string symbol); 
   string               TradeInfo(string symbol);
   string               TradeDirChar(string symbol);
   double               TotalProfitOnSymbol(string symbol);
   ulong                LastOrderOnSymbol_Ticket(string symbol);
   int                  LastOrderOnSymbol_index(string symbol);
   int                  LastLimitOrderOnSymbol_index(string symbol);
   int                  FirstLimitOrderOnSymbol_index(string symbol);
   void                 TradesArrayOnSymbol(string symbol, CMetaTrade &array[], bool ActiveOnly = false);
   void                 DeleteFirstPendingOrderOnSymbolAndOpenMarketOrder(string symbol);
   
   // *** FOUR STRINGS STRATEGY
   void                 FourStrings_DeleteYesterdayPendingOrdersOnSymbol(string symbol);
   void                 FourStrings_DeleteTodayPendingOrdersOnSymbol(string symbol);
   int                  TradesOpenOnSymbolAtFiboLevel(string symbol, double FiboLevel, bool CountOnlyActive = false);

  };
  

  
CTradesArray::CTradesArray() {
   // for array of all orders in the terminal
}

CTradesArray::CTradesArray(string symbol) {
   // for trades only for given symbol
   this.m_symbol = symbol;
}

void CTradesArray::Symbol(string symbol) {
   this.m_symbol = symbol;
}

  
  
CTradesArray::~CTradesArray() {   
  for (int i=0; i < ArraySize(Trades); i++) {
      delete Trades[i];
  }
  
  ArrayFree(Trades);
  ArrayResize(Trades,0);
}



int CTradesArray::TradesCount(void) {
   //this.Update();
   return ArraySize(Trades);

}


bool CTradesArray::Update() {
   // updates internal array of trades 'this.Trades[]'
   // fill in 'this.Trades[]' with orders on this symbol
   // in case of MQL5: fill it in with orders and positions
   ArrayFree(this.Trades);
   ArrayResize(this.Trades,0);
   bool symbol_specific = false;
   if (StringLen(this.m_symbol) > 0) symbol_specific = true; // indicates whether this trades array is symbol-specific; false - general
   ulong ticket;
   string symbol;
   
   
   for(int i=0; i < OrdersTotal(); i++) {
      
      #ifdef __MQL5__
         ticket = OrderGetTicket(i);
         if (!OrderSelect(ticket)) { Print(__FUNCTION__ + ": could NOT select a pending order"); return false; }
         symbol = OrderGetString(ORDER_SYMBOL);
      #else
         if (!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
         ticket = OrderTicket();
         symbol = OrderSymbol();
      #endif 
      
      if (symbol_specific > 0) {
         // then we check the symbol of the trade - and add only trades for current symbol
         
         if (symbol == this.m_symbol) {
            ArrayResize(this.Trades,ArraySize(Trades)+1);
            this.Trades[i] = new CMetaTrade(ticket);
         }
      }
      else {
         // we add all trades, doesn't matter the symbol
         int old_size = ArraySize(this.Trades);
         ArrayResize(this.Trades,ArraySize(this.Trades)+1);
         int new_size = ArraySize(this.Trades);
         if ( new_size == (old_size+1) ) // re-sizing was done correctly
            this.Trades[i] = new CMetaTrade(ticket); 
         else {
            Print(__FUNCTION__ + ": ArrayResize error '"+IntegerToString(GetLastError())+"'! old_size="+IntegerToString(old_size)+"; new_size="+IntegerToString(new_size)+"; i="+ 
                  IntegerToString(i) +"; ArraySize(this.Trades) = " + IntegerToString(ArraySize(this.Trades)));
         }
      }
   } 
   
   // if it is MQL5 - add also position
   #ifdef __MQL5__
      for (int i = ArraySize(this.Trades); i < ArraySize(this.Trades) + PositionsTotal(); i++) {
         ticket = PositionGetTicket(i);
         ArrayResize(this.Trades,ArraySize(Trades)+1);
         this.Trades[i] = new CMetaTrade(ticket);
      }  
   #endif 
   
   return true;
}



int CTradesArray::TradesOpenOnChart(long chartid) {
   // returns number of trades on the specified chart; any trade types are counted, including pending
   //this.Update();
   if (ArraySize(this.Trades) == 0) return 0;
   int orders_count = 0;
   string chart_symbol = ChartSymbol(chartid);
   
   //if ( OrdersTotal() != ArraySize(this.Trades) ) this.Update();
   
   for(int i=0; i < ArraySize(this.Trades); i++) {
      if (this.Trades[i].TradeSymbol() == chart_symbol) orders_count++;
   }
   return orders_count;
}


int CTradesArray::LimitTradesCountOnSymbol(string symbol) {
   // counts all limit orders on symbol
   //this.Update();
   int total_trades = ArraySize(this.Trades);
   if (total_trades == 0) return 0;
   int limit_orders_count = 0;
   ENUM_ORDER_TYPE trade_type;
   for(int i=0; i < total_trades; i++) {
      trade_type = this.Trades[i].TradeType();
      if (this.Trades[i].TradeSymbol() == symbol) {
         if (trade_type == OP_BUYLIMIT || trade_type == OP_SELLLIMIT) limit_orders_count++;
      }
   }
   return limit_orders_count;
}


int CTradesArray::TradesOpenOnSymbol(string symbol, bool CountOnlyActive = false) {
   // counts number of open active trades on specified symbol
   // this.Update();
   // // for MQL5 - returns positions count open on symbol
   int orders_count = 0;
   
   #ifdef __MQL5__
      // counting open positions only
      for (int i = 0; i < PositionsTotal(); i++) {
         ulong ticket = PositionGetTicket(i);
         if (PositionGetString(POSITION_SYMBOL) == symbol) orders_count++;
      } 
      if (!CountOnlyActive) {
         // also counting orders
         for (int i = 0; i < OrdersTotal(); i++) {
            ulong ticket = OrderGetTicket(i);
            if (OrderGetString(ORDER_SYMBOL) == symbol) orders_count++;
         } 
      }     
   #else 
      for(int i=0; i < OrdersTotal(); i++) {
         if (!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
         if (OrderSymbol() == symbol) { 
            if (CountOnlyActive) {
               if (OrderType() == ORDER_TYPE_BUY || OrderType() == ORDER_TYPE_SELL)
                  orders_count++;
            }
            else {
               orders_count++;
            }
         }
      }
   #endif 
   
   return orders_count;
}





int CTradesArray::TradesActiveOnSymbolSameDirection(string symbol, DayPriorityID Dir) {

   // counts number of open active trades on specified symbol
   // this.Update();
   // // for MQL5 - returns positions count open on symbol
   int orders_count = 0;
   
   #ifdef __MQL5__
      // counting open positions only
      //for (int i = 0; i < PositionsTotal(); i++) {
      //   ulong ticket = PositionGetTicket(i);
      //   if (PositionGetString(POSITION_SYMBOL) == symbol) orders_count++;
      //}    
   #else // MQL4
      for(int i=0; i < OrdersTotal(); i++) {
         if (!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
         if (OrderSymbol() == symbol) { 
               if (Dir == Buy) {
                  if (OrderType() == ORDER_TYPE_BUY)
                     orders_count++;
               }
               else if  (Dir == Sell) {
                  if (OrderType() == ORDER_TYPE_SELL)
                     orders_count++;
               }
         }
      }
   #endif 
   
   return orders_count;


}



int CTradesArray::TradesOpenOnSymbolAtPrice(string symbol, double open_price) {
   // counts number of any trades (active or pending) on specified symbol at specified entry price
   //this.Update();
   open_price = NormalizeDouble(open_price,_Digits); // if not, done then price we are comparing too can have more decimals and it will not be technically equal
   int orders_count = 0;
   for(int i=0; i < OrdersTotal(); i++) {
   
      Print("symbol = ", symbol);
      Print("open_price = ", open_price);
      Print("this.Trades[i].OpenPrice() = ", this.Trades[i].OpenPrice());
   
         if (this.Trades[i].TradeSymbol() == symbol && this.Trades[i].OpenPrice() == open_price) { 
            orders_count++;
         }
      }
   return orders_count;
}









int CTradesArray::ProfitableTradesOpenOnSymbolNotBreakEven(string symbol) {
   // counts all active trades on specified symbol, where sl != entry price
   this.Update();
   int orders_count = 0;
   for(int i=0; i < OrdersTotal(); i++) {
      if (this.Trades[i].TradeSymbol() == symbol) { 
         if ( !this.Trades[i].IsBreakEven() && this.Trades[i].Profit() > 0 && (this.Trades[i].TradeType() == OP_BUY || this.Trades[i].TradeType() == OP_SELL) ) 
            // if trade is not in break even and it is active
            orders_count++;
      }
   }
   return orders_count;
}




bool CTradesArray::AllTradesAtBreakEvenOnSymbol(string symbol) {
   // returns true, if all orders on symbol are in break even, or if SL is in positive zone
   //this.Update();
   
   // try to find at least 1 active order which is not in BE
   for(int i=0; i < OrdersTotal(); i++) {
      if (this.Trades[i].TradeSymbol() == symbol) { 
         if ( !this.Trades[i].IsBreakEven() && (this.Trades[i].TradeType() == OP_BUY || this.Trades[i].TradeType() == OP_SELL) ) 
            // if trade is not in break even and it is active
            return false;
      }
   }   
   return true;
}


bool CTradesArray::AllTradesInProfitOnSymbol(string symbol) {

   // returns true, if all orders on symbol are in profit, doesn't matter if they are in BE or not
   //this.Update();
   
   // try to find at least 1 active order which is not in profit
   for(int i=0; i < OrdersTotal(); i++) {
      if (this.Trades[i].TradeSymbol() == symbol) { 
         if ( this.Trades[i].Profit() < 0 && (this.Trades[i].TradeType() == OP_BUY || this.Trades[i].TradeType() == OP_SELL) ) 
            // if trade is not in profit and it is active
            return false;
      }
   }   
   return true;

}


bool CTradesArray::TradesInMinLossModeExistOnSymbol(string symbol) {
   // returns true, if there is at least order with TP in negative zone

   // try to find at least 1 active order where TP is in negative zone
   for(int i=0; i < OrdersTotal(); i++) {
      if (this.Trades[i].TradeSymbol() == symbol) { 
      //Print(symbol + ", this.Trades[i].TP() = ", this.Trades[i].TP_PP());
         if ( this.Trades[i].TP_PP() < 0 && (this.Trades[i].TradeType() == OP_BUY || this.Trades[i].TradeType() == OP_SELL) ) 
            // if trade is not in profit and it is active
            return true;
      }
   }   
   return false;
   Print("No trades on Min Loss Mode");
}



ulong CTradesArray::SingleLossTradeOnSymbolNotInMinLoss(string symbol) {
   // returns ticket of the single active trade with negative profit and TP in positive area; if it is not single, or there are no such orders - returns 0
   //this.Update();
   ushort orders_count = 0;
   ulong  ticket = 0;
   for(int i=0; i < OrdersTotal(); i++) {
      if (this.Trades[i].TradeSymbol() == symbol) { 
         if ( this.Trades[i].Profit() < 0 && (this.Trades[i].TradeType() == OP_BUY || this.Trades[i].TradeType() == OP_SELL) ) {
            // if trade is not in break even and it is active
            
            // checking if TP is in positive area
            if ( 
                  ( this.Trades[i].TradeType() == OP_BUY && this.Trades[i].TP() > this.Trades[i].OpenPrice()) ||
                  ( this.Trades[i].TradeType() == OP_SELL && this.Trades[i].TP() < this.Trades[i].OpenPrice())  
               ) 
               {
                  orders_count++;
                  ticket = this.Trades[i].Ticket;
               }
         }
      }
   }
   if (orders_count == 1) return ticket;
   else return 0;
}







TradeDir CTradesArray::TradeDirection(string symbol) {

   //this.Update();

   for(int i=0; i < OrdersTotal(); i++) {
      if (Trades[i].TradeSymbol() == symbol) {
         return Trades[i].TradeDirection();
      }
   }
   return TradeDir_NONE;
}


string CTradesArray::TradeDirChar(string symbol) {

   TradeDir trade_dir;
   //this.Update();
   
   for(int i=0; i < OrdersTotal(); i++) {
      if (Trades[i].TradeSymbol() == symbol) {
         trade_dir = Trades[i].TradeDirection();
         if (trade_dir == TradeDir_BUY) return CharToString(241);
         else if (trade_dir == TradeDir_SELL) return CharToString(242);
      }
   }
   
   return "";
}





string CTradesArray::TradeInfo(string symbol) {

   // for pending orders: S / L - and how far is the price from that entry in pp
   // for active trades: current profit in pp

   double profit_pp = 0;
   string info;
   int trade_type = 0;
   int trades_count = 0;
   int trade_index = 0;
   
   //bool jpy    = StringFind(symbol,"JPY")!=-1;
   //bool crypto = StringFind(symbol,"BTC")!=-1 || StringFind(symbol,"ETH")!=-1;
   //bool gold   = StringFind(symbol,"XAU")!=-1;
   bool oil    = symbol == "BRN" || symbol == "WTI" || symbol == "BRENT";
   

   //this.Update();

   for(int i=0; i < ArraySize(this.Trades); i++) {
      if (Trades[i].TradeSymbol() == symbol) {
         trade_type = Trades[i].TradeType(); // type of the last trade
         trade_index = i;
         trades_count++;
      }
   }
   
   
   // getting profit in pp
   profit_pp = this.TotalProfitOnSymbol(symbol);
   if (!oil) profit_pp = profit_pp/10;
   
   
   if (trades_count != 0 && (trade_type == OP_BUY || trade_type == OP_SELL)) {
      // there are open ACTIVE trades on this symbol 
      //Print("profit_pp = ", profit_pp);
      if (profit_pp < 10 && profit_pp > -10) 
         if (!oil)
            info = DoubleToString(profit_pp,0);
         else
            info = DoubleToString(profit_pp,1);
      else
         info = DoubleToString(profit_pp,0);
      
      if (profit_pp == 0) info = "0";

      if (trades_count > 1) info = info + "*";

      return info;
   }
   else { // there is a pending order on the symbol
      string distance; 
      double dist = this.Trades[trade_index].DistBetweenPriceAndEntry();
      if (dist >= 10) 
         distance = DoubleToString(dist,0); // no comma and digits after it
      else
         distance = DoubleToString(dist,1); // 1 digit after comma
      
      if (trade_type == OP_BUYLIMIT || trade_type == OP_SELLLIMIT) return "L" + distance;
      else if (trade_type == OP_BUYSTOP || trade_type == OP_SELLSTOP) return "S" + distance;
   }

   return "";
}



double CTradesArray::TotalProfitOnSymbol(string symbol) {
   // profit in pp
   // if there is more than 1 trade open on the symbol, then return profit on least profitable trade

   //this.Update();
   
   double profit_pp = 0;
   
   //finding total profit in pp as sum 
   //for(int i=0; i < OrdersTotal(); i++) {
   //   if (Trades[i].TradeSymbol() == symbol) {
   //      profit_pp = profit_pp + Trades[i].ProfitPP();
   //   }
   //} 
   
   // finding least profitable trade on the symbol and returning it
   int trades_on_symbol = this.TradesOpenOnSymbol(symbol);
   int trades_total = OrdersTotal();
   if (trades_on_symbol > 1) { // there are more than 1 trades on that symbol - find the one with least profit and return it
         // 1) find the first trade for the symbol
         double min_profit = 0;
         for(int i=0; i < trades_total; i++) {
            if (Trades[i].TradeSymbol() == symbol) {
               min_profit = Trades[i].ProfitPP();
               continue;
            }
         }
         for(int i=0; i < trades_total; i++) {
            if (Trades[i].TradeSymbol() == symbol) {
               double profit = Trades[i].ProfitPP();
               if (profit < min_profit) min_profit = profit;
            }
         }
         return min_profit;
    }
      else if (trades_on_symbol == 1) { // there is only 1 trade on that symbol - search for it and return its profit.
         for(int i=0; i < trades_total; i++) {
            if (Trades[i].TradeSymbol() == symbol) {
               return Trades[i].ProfitPP();
            }
         }      
      }
      
      else if (trades_on_symbol == 0) { // no trades on that symbol
         return 0;
      }
      else return 0;
      return 0;
} 


ulong CTradesArray::LastOrderOnSymbol_Ticket(string symbol) {
   // returns ticket of the latest order created for this symbol
  
   //this.Update();
   int total_trades = ArraySize(this.Trades);
   if (total_trades == 0) return 0;
   
   for (int i = total_trades - 1; i >= 0; i--) {
      // cycle through all the open trades (including pending ones) BACKWARDS in the array
      // and find the first encounter by that symbol - it will be the last opened trade
      if (symbol == this.Trades[i].TradeSymbol()) return this.Trades[i].Ticket;
   }
   
   // no open trades for this symbol found
   return 0;

}

int CTradesArray::LastOrderOnSymbol_index(string symbol) {

   // returns latest order's index in the current array of orders
  
   //this.Update();
   int total_trades = ArraySize(this.Trades);
   if (total_trades == 0) return -1;
   
   for (int i = total_trades - 1; i >= 0; i--) {
      // cycle through all the open trades (including pending ones) BACKWARDS in the array
      // and find the first encounter by that symbol - it will be the last opened trade
      if (symbol == this.Trades[i].TradeSymbol()) return i;
   }
   
   // no open trades for this symbol found
   return -1;
   
}




int CTradesArray::LastLimitOrderOnSymbol_index(string symbol) {

   // returns latest limit order's index in the current array of orders
  
   //this.Update();
   int total_trades = ArraySize(this.Trades);
   if (total_trades == 0) return -1;
   
   for (int i = total_trades - 1; i >= 0; i--) {
      // cycle through all the open trades (including pending ones) BACKWARDS in the array
      // and find the first encounter by that symbol - it will be the last opened trade
      if (symbol == this.Trades[i].TradeSymbol() && this.Trades[i].IsLimitOrder()) return i;
   }
   
   // no open trades for this symbol found
   return -1;
   
}


int CTradesArray::FirstLimitOrderOnSymbol_index(string symbol) {

   // returns first limit order's index in the current array of orders
  
   //this.Update();
   int total_trades = ArraySize(this.Trades);
   if (total_trades == 0) return -1;
   
   for (int i = 0; i < total_trades; i++) {
      // cycle through all the open trades (including pending ones) FORWARD in the array
      // and find the first encounter by that symbol - it will be the first opened trade
      if (symbol == this.Trades[i].TradeSymbol() && this.Trades[i].IsLimitOrder()) return i;
   }
   
   // no open trades for this symbol found
   return -1;

}





void CTradesArray::TradesArrayOnSymbol(string symbol, CMetaTrade &array[], bool ActiveOnly = false) {
   // returns array of trades 'array[]' for specified symbol
   this.Update();
   int orders_total = ArraySize(this.Trades); // total trades in the terminal
   
   for (int i = 0; i < orders_total; i++) { // cycle through all the trades in the terminal
      
      if (this.Trades[i].TradeSymbol() == symbol) {
         if (ActiveOnly) {
            ENUM_ORDER_TYPE tt = this.Trades[i].TradeType();
            if (tt == ORDER_TYPE_BUY_LIMIT || tt == ORDER_TYPE_SELL_LIMIT) continue;
         }
         // both active and pending are requested at this point
         int old_size = ArraySize(array);
         int new_size = ArrayResize(array,ArraySize(array)+1);
         if (new_size != (old_size+1))
            Print(__FUNCTION__ + ": i=" + IntegerToString(i) + "; ArraySize(array)=" + IntegerToString(ArraySize(array)));
         array[ArraySize(array)-1] = this.Trades[i]; // refer to the last added elememnt of the array
      }      
   }
}



int CTradesArray::TradesOpenOnSymbolAtFiboLevel(string symbol, double FiboLevel, bool CountOnlyActive = false) {

   // Special method for "Four Strings" strategy
   // counts number of open active trades on specified symbol at specified Big Fibo's level
   //this.Update();
   int orders_count = 0;
   for(int i=0; i < OrdersTotal(); i++) {
      if (this.Trades[i].TradeSymbol() == symbol) { 
         if (CountOnlyActive) { // only active market orders
            if (this.Trades[i].TradeType() == OP_BUY || this.Trades[i].TradeType() == OP_SELL)
               if (this.Trades[i].FourStrings_TradeFiboLevel() == FiboLevel) {
                  orders_count++;
               }
         }
         else { // any type of order
               if (this.Trades[i].FourStrings_TradeFiboLevel() == FiboLevel) {
                  orders_count++;
               }
         }
      }
   }
   return orders_count;

}




void CTradesArray::DeleteFirstPendingOrderOnSymbolAndOpenMarketOrder(string symbol) {

   // finding first pending order on symbol and sending command to Trade.exe to delete it

   ulong ticket = 0;
   for(int i=0; i < OrdersTotal(); i++) {
      if (this.Trades[i].TradeSymbol() == symbol) { 
         ENUM_ORDER_TYPE tt = this.Trades[i].TradeType();
         if (tt == ORDER_TYPE_BUY_LIMIT || tt == ORDER_TYPE_SELL_LIMIT) {
            ticket = this.Trades[i].Ticket;
            break;
         } 
      }
   }
   
   
   if (ticket != 0) {
      if (!EventChartCustom(ChartID(),TRADE_DELETE_PENDING_ORDER_OPEN_MARKET_ORDER,ticket,0,"")) 
         Print("Couldn't send custom event TRADE_DELETE_PENDING_ORDER_OPEN_MARKET_ORDER");
      else {
         Print("Deleting pending order #" + IntegerToString(ticket) + "; TRADE_DELETE_PENDING_ORDER command is sent to Trade.exe");                   
      }
   }
   else
      Print("No pending order is found on this symbol");

}







void CTradesArray::FourStrings_DeleteYesterdayPendingOrdersOnSymbol(string symbol) {
    Print("Checking for 'Four Strings' pending orders opened yesterday on the symbol...");

   //this.Update();
   int orders_count = 0;
   for(int i=0; i < OrdersTotal(); i++) {
      if (this.Trades[i].TradeSymbol() == symbol) { 
         if (this.Trades[i].TradeStrategy() == FourStrings) {
            ENUM_ORDER_TYPE tt = this.Trades[i].TradeType();
            if (tt == ORDER_TYPE_BUY_LIMIT || tt == ORDER_TYPE_SELL_LIMIT) {
               datetime yesterday = Yesterday(); // date and time
               datetime open_day = this.Trades[i].OpenDateOnly();
               if ( open_day <= yesterday ) {
                  orders_count++;
               }
            } 
         }
      }
   }
   
   if (orders_count > 0) {
      if (!EventChartCustom(ChartID(),TRADE_DELETE_ALL_YESTERDAY_PENDING_4STRINGS,0,0,_Symbol)) 
         Print("Couldn't send custom event 'TRADE_DELETE_ALL_YESTERDAY_PENDING_4STRINGS'");
      else {
         Print(IntegerToString(orders_count), " of 'Four Strings' pending orders (opened yesterday) detected. Deleting...");
         Print("'TRADE_DELETE_ALL_YESTERDAY_PENDING_4STRINGS' is sent");                   
      }
   }
   else
      Print("No 'Four Strings' pending orders opened yesterday were found");
}




void CTradesArray::FourStrings_DeleteTodayPendingOrdersOnSymbol(string symbol) {
    Print("Checking for 'Four Strings' pending orders opened today on the symbol...");

   //this.Update();
   int orders_count = 0;
   for(int i=0; i < OrdersTotal(); i++) {
      if (this.Trades[i].TradeSymbol() == symbol) { 
         if (this.Trades[i].TradeStrategy() == FourStrings) {
            ENUM_ORDER_TYPE tt = this.Trades[i].TradeType();
            if (tt == ORDER_TYPE_BUY_LIMIT || tt == ORDER_TYPE_SELL_LIMIT) {
               if ( this.Trades[i].OpenDateOnly() == Today_DateOnly() ) {
                  orders_count++;
               }
            } 
         }
      }
   }
   
   if (orders_count > 0) {
      if (!EventChartCustom(ChartID(),TRADE_DELETE_ALL_TODAY_PENDING_4STRINGS,0,0,_Symbol)) 
         Print("Couldn't send custom event 'TRADE_DELETE_ALL_TODAY_PENDING_4STRINGS'");
      else {
         Print(IntegerToString(orders_count) , " of 'Four Strings' pending orders (opened today) detected. Deleting...");
         Print("'TRADE_DELETE_ALL_TODAY_PENDING_4STRINGS' is sent");                   
      }
   }
   else
      Print("No 'Four Strings' pending orders opened today were found");
}



int CTradesArray::TradesPendingOnSymbol(string symbol) {

   //this.Update();
   int orders_count = 0;
   int total_trades = ArraySize(this.Trades);
   if ( total_trades != OrdersTotal() ) this.Update();
   
   for(int i=0; i < total_trades; i++) {
      if (this.Trades[i].TradeSymbol() == symbol) { 
         if (this.Trades[i].TradeType() == ORDER_TYPE_BUY_LIMIT || this.Trades[i].TradeType() == ORDER_TYPE_SELL_LIMIT)
            orders_count++;
      }
   }
   
   return orders_count;

}


