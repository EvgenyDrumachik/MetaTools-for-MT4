#property strict
class MTSettings
  {
private:
   string   m_FileName;
   
   double   m_BreakEvenLevel;    // price of break even line
   int      m_BreakEvenPP;       // distance from entry to break even line
   short    m_NoBELastMinOfDay;  // number of minutees before midnight when SL->BE move is not allowed
   short    m_NoBEFirstMinOfDay; // number of minutees after  midnight when SL->BE move is not allowed
   bool     m_NoBEAroundMidnight;// toggle which defines is NoBEAroundMidnight is activated
   
   double m_BackwardsBreakLevel; // price of the backwards break level
   int    m_BackwardsBreakPP;    // distance from entry to backwards break level


public:
            MTSettings();
           ~MTSettings();
           
   bool     SaveSettingsOnDisk();
   bool     LoadSettingsFromDisk();
   
   //       FixChartScale
   ulong    FixChartScale_D1_Zoom; // -1 - no zoom fix; 
   ulong    FixChartScale_H4_Zoom; // -1 - no zoom fix; 
   ulong    FixChartScale_H1_Zoom; // -1 - no zoom fix; 
   
   double   FixChartScale_H1_Min;  // min price level of chart for H1 when fixed scale
   double   FixChartScale_H1_Max;  // max price level of chart for H1 when fixed scale
   double   FixChartScale_H4_Min;  // min price level of chart for H4 when fixed scale
   double   FixChartScale_H4_Max;  // max price level of chart for H4 when fixed scale
   double   FixChartScale_D1_Min;  // min price level of chart for D1 when fixed scale
   double   FixChartScale_D1_Max;  // max price level of chart for D1 when fixed scale
   
   //bool     AllObjectHidden;       // flag indicating that all objects should be hidden when indicator is loaded - NOT USED???
   
   
   
   // ******************************************* Auto Entry Control Settings ***************************************************
   bool        AutoEntryOnBarClose;   // when current bar closes - auto open a new trade
   datetime    AutoEntryControl_InstantEntryRect_DateTime1;
   datetime    AutoEntryControl_InstantEntryRect_DateTime2;
   double      AutoEntryControl_InstantEntryRect_Price1;
   double      AutoEntryControl_InstantEntryRect_Price2;
      
   datetime    AutoEntryControl_LimitEntryRect_DateTime1;
   datetime    AutoEntryControl_LimitEntryRect_DateTime2;
   double      AutoEntryControl_LimitEntryRect_Price1;
   double      AutoEntryControl_LimitEntryRect_Price2;
 
   double      EntryLinePrice;
   // **********************************************************************************************************
   
   
   // ******************************************* Auto Delete Limit Order On Timer *****************************
   bool        AutoDeleteLimitOnTimer;
   datetime    AutoDeleteLimitOnTimerAt;   
   // **********************************************************************************************************
   
   
   
   bool     TP_Manual_Control;


   // ******************************************* Break Even ***************************************************
   double   BreakEvenLevel();        // Price of break even; set up by Meta Tools during opening of a new trade
   void     BreakEvenLevel(double be_price, double entry_price);
   int      BreakEvenPP(void);                                     // Break Even Level in PP
   void     BreakEvenPP(int be_PP,double entry_price, int ticket);
   short    NoBELastMinOfDay();           // read number of minutees before midnight when SL->BE move is not allowed
   short    NoBEFirstMinOfDay();          // read number of minutees after midnight when SL->BE move is not allowed
   bool     NoBEAroundMidnight();         // read value of NoBEAroundMidnight
   void     NoBEAroundMidnight(bool NoBE);// write value of NoBEAroundMidnight
   void     NoBELastMinOfDay(short min);  // write number of minutees before midnight when SL->BE move is not allowed
   void     NoBEFirstMinOfDay(short min); // write number of minutees after midnight when SL->BE move is not allowed    
   // **********************************************************************************************************
   
   
   // ******************************************* Backwards Break Level ****************************************
   double   BackwardsBreakLevel();        // Price of backwards break level; set up by Meta Tools during opening of a new trade
   void     BackwardsBreakLevel(double bb_price, double entry_price);
   int      BackwardsBreakPP(void);                                     // Break Even Level in PP
   void     BackwardsBreakPP(int be_PP,double entry_price, int ticket);
   // **********************************************************************************************************
   
   
   // ******************************************* Four Strings ****************************************
   bool        FourStringsAutoMode;
   // **********************************************************************************************************
   
   // ******************************************* Spread History ****************************************
   datetime    LastRecordedSpreadTime;
   // **********************************************************************************************************
   
   
   // ******************************************* Notification Flags ****************************************
   bool        InformedAbCheckTheChart;
   bool        InformedAbPinBar;
   bool        InformedAbS3imp;
   bool        InformedAbThreat;   
   // **********************************************************************************************************
   
   
  };





// **********************************************************************************************************
// ******************************************* Break Even Level *********************************************
// **********************************************************************************************************

double MTSettings::BreakEvenLevel(void) {
   return m_BreakEvenLevel;
}

int MTSettings::BreakEvenPP(void) {
   return m_BreakEvenPP;
}

void MTSettings::BreakEvenLevel(double be_price,double entry_price) {
   this.m_BreakEvenLevel = be_price;
   this.m_BreakEvenPP = int(MathAbs(be_price - entry_price) / _Point);
}


short MTSettings::NoBELastMinOfDay() {
   return m_NoBELastMinOfDay;
}

short MTSettings::NoBEFirstMinOfDay() {
   return m_NoBEFirstMinOfDay;
}


void MTSettings::NoBELastMinOfDay(short min) {
   this.m_NoBELastMinOfDay = min;
}

void MTSettings::NoBEFirstMinOfDay(short min) {
   this.m_NoBEFirstMinOfDay = min;
}


void MTSettings::NoBEAroundMidnight(bool NoBE) {
   this.m_NoBEAroundMidnight = NoBE;
}

bool MTSettings::NoBEAroundMidnight() {
   return this.m_NoBEAroundMidnight;
}




void MTSettings::BreakEvenPP(int be_PP,double entry_price, int ticket) {

   this.m_BreakEvenPP = be_PP;
   CMetaTrade trade(ticket);
   TradeDir trade_dir = trade.TradeDirection();
   if (trade_dir == TradeDir_BUY) {
      this.m_BreakEvenLevel = entry_price + be_PP * _Point;
      Print("New break even is saved in settings: ", IntegerToString(be_PP), " pp / ", DoubleToString(this.m_BreakEvenLevel,5));
   }  
   else if (trade_dir == TradeDir_SELL) {
      this.m_BreakEvenLevel = entry_price - be_PP * _Point;
      Print("New break even is saved in settings: ", IntegerToString(be_PP), " pp / ", DoubleToString(this.m_BreakEvenLevel,5));
   }
   else {
      this.m_BreakEvenLevel = 0;
      this.m_BreakEvenPP = 0;
      Print(__FUNCTION__, ": Trade Direction is unknown. Cannot save break even price in settings");
   }   
}
// **********************************************************************************************************
// **********************************************************************************************************
// **********************************************************************************************************



// **********************************************************************************************************
// ******************************************* Backwards Break Level ****************************************
// **********************************************************************************************************
double MTSettings::BackwardsBreakLevel(void) {
   return m_BackwardsBreakLevel;
}

int MTSettings::BackwardsBreakPP(void) {
   return m_BackwardsBreakPP;
}

void MTSettings::BackwardsBreakLevel(double bb_price,double entry_price) {
   this.m_BackwardsBreakLevel = bb_price;
   this.m_BackwardsBreakPP = int(MathAbs(bb_price - entry_price) / _Point);
}

void MTSettings::BackwardsBreakPP(int bb_PP,double entry_price, int ticket) {
   this.m_BackwardsBreakPP = bb_PP;
   CMetaTrade trade(ticket);
   TradeDir trade_dir = trade.TradeDirection();
   if (trade_dir == TradeDir_BUY) {
      this.m_BackwardsBreakLevel = entry_price + bb_PP * _Point;
      Print("New backwards break level is saved in settings: ", IntegerToString(bb_PP), " pp / ", DoubleToString(this.m_BackwardsBreakLevel,5));
   }  
   else if (trade_dir == TradeDir_SELL) {
      this.m_BackwardsBreakLevel = entry_price - bb_PP * _Point;
      Print("New backwards level is saved in settings: ", IntegerToString(bb_PP), " pp / ", DoubleToString(this.m_BackwardsBreakLevel,5));
   }
   else {
      this.m_BackwardsBreakLevel = 0;
      Print(__FUNCTION__, ": Trade Direction is unknown. Cannot save break even price in settings");
   }   
}
// **********************************************************************************************************
// **********************************************************************************************************
// **********************************************************************************************************










  
  
MTSettings::MTSettings()
  {
  this.m_FileName = "MetaTools_" + Symbol() + IntegerToString(ChartID()) + ".txt";
  
  // *** pre-load default settings ***
  this.FixChartScale_D1_Zoom = -1;
  this.FixChartScale_H4_Zoom = -1;
  this.FixChartScale_H1_Zoom = -1;
  // ----------------------------------
  
  this.m_BreakEvenLevel = 0;
  this.m_BreakEvenPP    = 0;
  
  this.LoadSettingsFromDisk();
  
  
  }
MTSettings::~MTSettings()
  {
  this.SaveSettingsOnDisk();
  }
//+------------------------------------------------------------------+



bool MTSettings::SaveSettingsOnDisk() {

	//Print("Trying to save settings to file: " + m_FileName + ".");
   
	int fh;
	fh = FileOpen(m_FileName, FILE_CSV | FILE_WRITE);
	if (fh == INVALID_HANDLE)
	{
		Print("Failed (#1) to open file for writing: " + this.m_FileName + ". Error: " + IntegerToString(GetLastError()));

		fh = FileOpen(m_FileName, FILE_CSV | FILE_WRITE);
		if (fh == INVALID_HANDLE) {
		   Print("Failed (#2) to open file for writing: " + this.m_FileName + ". Error: " + IntegerToString(GetLastError()));
		   
		   fh = FileOpen(m_FileName, FILE_CSV | FILE_WRITE);
		   if (fh == INVALID_HANDLE) {
		      Print("Failed (#3) to open file for writing: " + this.m_FileName + ". Error: " + IntegerToString(GetLastError()));
		      FileClose(fh);
		      return(false);
		   }
		}
	}

	// Order does not matter.
	
	// *** FIX Chart Scale ***
	FileWrite(fh, "FixChartScale_D1_Zoom");
	FileWrite(fh, IntegerToString(this.FixChartScale_D1_Zoom));

	FileWrite(fh, "FixChartScale_H4_Zoom");
	FileWrite(fh, IntegerToString(this.FixChartScale_H4_Zoom));

	FileWrite(fh, "FixChartScale_H1_Zoom");
	FileWrite(fh, IntegerToString(this.FixChartScale_H1_Zoom));
	// ***********************************************************



   // *** Values for min and max values of fixed windos ***
	FileWrite(fh, "FixChartScale_H1_Min");
	FileWrite(fh, DoubleToString(this.FixChartScale_H1_Min));   

   FileWrite(fh, "FixChartScale_H1_Max");
	FileWrite(fh, DoubleToString(this.FixChartScale_H1_Max));  
	
	FileWrite(fh, "FixChartScale_H4_Min");
	FileWrite(fh, DoubleToString(this.FixChartScale_H4_Min));  
	
	FileWrite(fh, "FixChartScale_H4_Max");
	FileWrite(fh, DoubleToString(this.FixChartScale_H4_Max));  
	
	FileWrite(fh, "FixChartScale_D1_Min");
	FileWrite(fh, DoubleToString(this.FixChartScale_D1_Min));  
	
	FileWrite(fh, "FixChartScale_D1_Max");
	FileWrite(fh, DoubleToString(this.FixChartScale_D1_Max));  
   // ***********************************************************
   
   // ***********************************************************
   // *** Trade Manager Settings ****
   // ***********************************************************
   FileWrite(fh, "BreakEvenLevel");
   FileWrite(fh, DoubleToString(this.m_BreakEvenLevel));
   
   FileWrite(fh, "BreakEvenPP");
   FileWrite(fh, IntegerToString(this.m_BreakEvenPP));
   
   FileWrite(fh, "NoBELastMinOfDay");
   FileWrite(fh, IntegerToString(this.m_NoBELastMinOfDay));

   FileWrite(fh, "NoBEFirstMinOfDay");
   FileWrite(fh, IntegerToString(this.m_NoBEFirstMinOfDay));

   FileWrite(fh, "BackwardsBreakLevel");
   FileWrite(fh, DoubleToString(this.m_BackwardsBreakLevel));
   
   FileWrite(fh, "BackwardsBreakPP");
   FileWrite(fh, IntegerToString(this.m_BackwardsBreakPP));
   
   FileWrite(fh, "TP_Manual_Control");
   if (TP_Manual_Control) FileWrite(fh, "1");
   else FileWrite(fh, "0");
   
   // ***********************************************************
   // *** Auto Entry Control Settings ***************************   
   // ***********************************************************
   FileWrite(fh, "AutoEntryOnBarClose");
   if (AutoEntryOnBarClose) FileWrite(fh, "1");
   else FileWrite(fh, "0");
   
   FileWrite(fh, "NoBEAroundMidnight");
   if (m_NoBEAroundMidnight) FileWrite(fh, "1");
   else FileWrite(fh, "0"); 
      
   FileWrite(fh, "AutoEntryControl_InstantEntryRect_DateTime1");
   FileWrite(fh, TimeToString(this.AutoEntryControl_InstantEntryRect_DateTime1));
   
   FileWrite(fh, "AutoEntryControl_InstantEntryRect_DateTime2");
   FileWrite(fh, TimeToString(this.AutoEntryControl_InstantEntryRect_DateTime2));
 
   FileWrite(fh, "AutoEntryControl_InstantEntryRect_Price1");
   FileWrite(fh, DoubleToString(this.AutoEntryControl_InstantEntryRect_Price1));

   FileWrite(fh, "AutoEntryControl_InstantEntryRect_Price2");
   FileWrite(fh, DoubleToString(this.AutoEntryControl_InstantEntryRect_Price2)); 


   FileWrite(fh, "AutoEntryControl_LimitEntryRect_DateTime1");
   FileWrite(fh, TimeToString(this.AutoEntryControl_LimitEntryRect_DateTime1));
   
   FileWrite(fh, "AutoEntryControl_LimitEntryRect_DateTime2");
   FileWrite(fh, TimeToString(this.AutoEntryControl_LimitEntryRect_DateTime2));
 
   FileWrite(fh, "AutoEntryControl_LimitEntryRect_Price1");
   FileWrite(fh, DoubleToString(this.AutoEntryControl_LimitEntryRect_Price1));

   FileWrite(fh, "AutoEntryControl_LimitEntryRect_Price2");
   FileWrite(fh, DoubleToString(this.AutoEntryControl_LimitEntryRect_Price2)); 

   FileWrite(fh, "EntryLinePrice");
   FileWrite(fh, DoubleToString(this.EntryLinePrice)); 
   // **********************************************************
   // ***********************************************************
   



   // ***********************************************************
   // *** Auto Delete Limit on Timer  ***************************   
   // ***********************************************************
   FileWrite(fh, "AutoDeleteLimitOnTimer");
   if (AutoDeleteLimitOnTimer) FileWrite(fh, "1");
   else FileWrite(fh, "0");
   
   FileWrite(fh, "AutoDeleteTimitOnTimerAt");
   FileWrite(fh, TimeToString(this.AutoDeleteLimitOnTimerAt));
   // **********************************************************
   // ***********************************************************



   // ***********************************************************
   // *** Auto Delete Limit on Timer  ***************************   
   // ***********************************************************
   FileWrite(fh, "FourStringsAutoMode");
   if (FourStringsAutoMode) FileWrite(fh, "1");
   else FileWrite(fh, "0");
   // **********************************************************
   // ***********************************************************

   // Spread History
   FileWrite(fh, "LastRecordedSpreadTime");
   FileWrite(fh, TimeToString(this.LastRecordedSpreadTime,TIME_SECONDS));


   // Information flags (informed on PushNotification about ...)

   FileWrite(fh, "InformedAbCheckTheChart");
   if (InformedAbCheckTheChart) FileWrite(fh, "1");
   else FileWrite(fh, "0");

   FileWrite(fh, "InformedAbPinBar");
   if (InformedAbPinBar) FileWrite(fh, "1");
   else FileWrite(fh, "0");
   
   FileWrite(fh, "InformedAbS3imp");
   if (InformedAbS3imp) FileWrite(fh, "1");
   else FileWrite(fh, "0");

   FileWrite(fh, "InformedAbThreat");
   if (InformedAbThreat) FileWrite(fh, "1");
   else FileWrite(fh, "0");



	FileClose(fh);

	//Print("Saved settings successfully.");
	return(true);

}




bool MTSettings::LoadSettingsFromDisk()
{
   //Print("Trying to load settings from file.");
   
   if (!FileIsExist(this.m_FileName))
   {
   	Print("No settings file to load.");
   	return(false);
   }
   
   int fh;
   fh = FileOpen(this.m_FileName, FILE_CSV | FILE_READ);
   
	if (fh == INVALID_HANDLE)
	{
		Print("Failed to open file for reading: " + this.m_FileName + ". Error: " + IntegerToString(GetLastError()));
		return(false);
	}
	

	while (!FileIsEnding(fh))
	{
	   string var_name = FileReadString(fh);
	   string var_content = FileReadString(fh);
	   if (var_name == "FixChartScale_D1_Zoom") {
	      if (StringLen(var_content) > 0) {
	   	   this.FixChartScale_D1_Zoom = StringToInteger(var_content);
	      }
	      else
	         this.FixChartScale_D1_Zoom = -1;
	   }
	   else if (var_name == "FixChartScale_H4_Zoom") {
	      if (StringLen(var_content) > 0)
	   	   this.FixChartScale_H4_Zoom = StringToInteger(var_content);
	      else
	         this.FixChartScale_H4_Zoom = -1;
	   }
	   else if (var_name == "FixChartScale_H1_Zoom") {
	      if (StringLen(var_content) > 0)
	   	   this.FixChartScale_H1_Zoom = StringToInteger(var_content);
	   	else
	   	   this.FixChartScale_H1_Zoom = -1;
	   }
	   
	   
	   else if (var_name == "FixChartScale_H1_Min") {
	         this.FixChartScale_H1_Min = StringToDouble(var_content);
	   }
	   else if (var_name == "FixChartScale_H1_Max") {
	         this.FixChartScale_H1_Max = StringToDouble(var_content);
	   }
	   else if (var_name == "FixChartScale_H4_Min") {
	         this.FixChartScale_H4_Min = StringToDouble(var_content);
	   }
	   else if (var_name == "FixChartScale_H4_Max") {
	         this.FixChartScale_H4_Max = StringToDouble(var_content);
	   }
	   else if (var_name == "FixChartScale_D1_Min") {
	         this.FixChartScale_D1_Min = StringToDouble(var_content);
	   }
	   else if (var_name == "FixChartScale_D1_Max") {
	         this.FixChartScale_D1_Max = StringToDouble(var_content);
	   }
	
	   else if (var_name == "BreakEvenLevel") {
	         this.m_BreakEvenLevel = StringToDouble(var_content);
	         //Print("var_content m_BreakEvenLevel = ", var_content);
	   }
	   
	   else if (var_name == "BreakEvenPP") {
	         this.m_BreakEvenPP = int(StringToDouble(var_content));
	         //Print("var_content m_BreakEvenPP = ", var_content);
	   }
	   
	   
	   else if (var_name == "NoBELastMinOfDay") {
	         this.m_NoBELastMinOfDay = short(StringToDouble(var_content));
	   }
	   
	   else if (var_name == "NoBEFirstMinOfDay") {
	         this.m_NoBEFirstMinOfDay = short(StringToDouble(var_content));
	   }

	   else if (var_name == "NoBEAroundMidnight") {
	         bool value = int(StringToDouble(var_content));
	         if (value == 1) this.m_NoBEAroundMidnight = true;
	         else this.m_NoBEAroundMidnight = false;
	   }
	   
	   else if (var_name == "BackwardsBreakLevel") {
	         this.m_BackwardsBreakLevel = StringToDouble(var_content);
	         //Print("var_content m_BreakEvenLevel = ", var_content);
	   }
	   
	   else if (var_name == "BackwardsBreakPP") {
	         this.m_BackwardsBreakPP = int(StringToDouble(var_content));
	         //Print("var_content m_BreakEvenPP = ", var_content);
	   }
	   
   
	   else if (var_name == "TP_Manual_Control") {
	         bool value = int(StringToDouble(var_content));
	         if (value == 1) this.TP_Manual_Control = true;
	         else this.TP_Manual_Control = false;
	   }
	   
	   
	   
      // ***********************************************************
      // *** Auto Entry Control Settings ***************************   
      // ***********************************************************
	   else if (var_name == "AutoEntryOnBarClose") {
	         bool value = int(StringToDouble(var_content));
	         if (value == 1) this.AutoEntryOnBarClose = true;
	         else this.AutoEntryOnBarClose = false;
	   }
	   
	   else if (var_name == "AutoEntryControl_InstantEntryRect_Price1") {
	         this.AutoEntryControl_InstantEntryRect_Price1 = StringToDouble(var_content);
	   }
	   
	   else if (var_name == "AutoEntryControl_InstantEntryRect_Price2") {
	         this.AutoEntryControl_InstantEntryRect_Price2 = StringToDouble(var_content);
	   }
	   
	   else if (var_name == "AutoEntryControl_LimitEntryRect_Price1") {
	         this.AutoEntryControl_LimitEntryRect_Price1 = StringToDouble(var_content);
	   }
	   
	   else if (var_name == "AutoEntryControl_LimitEntryRect_Price2") {
	         this.AutoEntryControl_LimitEntryRect_Price2 = StringToDouble(var_content);
	   }
	   
	   
	   else if (var_name == "AutoEntryControl_InstantEntryRect_DateTime1") {
	         this.AutoEntryControl_InstantEntryRect_DateTime1 = StringToTime(var_content);
	   }
	   
	   else if (var_name == "AutoEntryControl_InstantEntryRect_DateTime2") {
	         this.AutoEntryControl_InstantEntryRect_DateTime2 = StringToTime(var_content);
	   }
	   
	   
	   else if (var_name == "AutoEntryControl_LimitEntryRect_DateTime1") {
	         this.AutoEntryControl_LimitEntryRect_DateTime1 = StringToTime(var_content);
	   }
	   
	   else if (var_name == "AutoEntryControl_LimitEntryRect_DateTime2") {
	         this.AutoEntryControl_LimitEntryRect_DateTime2 = StringToTime(var_content);
	   }
	   
	   else if (var_name == "EntryLinePrice") {
	         this.EntryLinePrice = double(StringToDouble(var_content));
	   }
      // **********************************************************
      // ***********************************************************


      // Spread History
	   else if (var_name == "LastRecordedSpreadTime") {
	         this.LastRecordedSpreadTime = datetime(StringToDouble(var_content));
      }

      // ***********************************************************
      // *** Auto Delete Limit on Timer  ***************************   
      // ***********************************************************
	   else if (var_name == "AutoDeleteLimitOnTimer") {
	         bool value = int(StringToDouble(var_content));
	         if (value == 1) this.AutoDeleteLimitOnTimer = true;
	         else this.AutoDeleteLimitOnTimer = false;
	   }
   
	   else if (var_name == "AutoDeleteTimitOnTimerAt") {
	         this.AutoDeleteLimitOnTimerAt = StringToTime(var_content);
	   }
      // **********************************************************
      // ***********************************************************


      // ***********************************************************
      // *** Auto Delete Limit on Timer  ***************************   
      // ***********************************************************
      else if (var_name == "FourStringsAutoMode") {
	         bool value = int(StringToDouble(var_content));
	         if (value == 1) this.FourStringsAutoMode = true;
	         else this.FourStringsAutoMode = false;
      }

 

      // ***********************************************************
      // *** Information flag (informed with push about...) ********   
      // ***********************************************************
	   else if (var_name == "InformedAbCheckTheChart") {
	         bool value = int(StringToDouble(var_content));
	         if (value == 1) this.InformedAbCheckTheChart = true;
	         else this.InformedAbCheckTheChart = false;
	   }
	   else if (var_name == "InformedAbPinBar") {
	         bool value = int(StringToDouble(var_content));
	         if (value == 1) this.InformedAbPinBar = true;
	         else this.InformedAbPinBar = false;
	   }
	   else if (var_name == "InformedAbS3imp") {
	         bool value = int(StringToDouble(var_content));
	         if (value == 1) this.InformedAbS3imp = true;
	         else this.InformedAbS3imp = false;
	   }
	   else if (var_name == "InformedAbThreat") {
	         bool value = int(StringToDouble(var_content));
	         if (value == 1) this.InformedAbThreat = true;
	         else this.InformedAbThreat = false;
	   }
      // **********************************************************
      // *********************************************************** 
 
	}
		




   FileClose(fh);
   //Print("Loaded settings successfully.");

   return(true); 
} 


