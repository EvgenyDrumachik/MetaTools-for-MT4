//+------------------------------------------------------------------+
//|                                      Meta Tools Declarations.mqh |
//|                                                 Evgeny Drumachik |
//|                                             https://www.mql5.com |
//|            NO FUNCTIONS HERE!                                    |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|        INCLUDES                                                  |
//+------------------------------------------------------------------+
#include <Controls/Button.mqh>
#include <Controls/Label.mqh>
#include <Controls/Edit.mqh> // нужно для работы с полями в калькуляторе. Используется при нажатии горячей клавиши "\"
#include <Strings/String.mqh>
#include <..\Include\MetaLibraries\Common.mqh>
#include <..\Include\MetaLibraries\Meta Tools MQL5 Compatibility Functions.mqh>
//#include "Meta Tools MQL5 Compatibility Functions.mqh"
#include "GraphObject.mqh"
#include "Level.mqh"
#include "MetaTrade.mqh"
#include "Trend.mqh"
#include "Rectangle.mqh"
#include "Fibo.mqh"
#include "TradeLine.mqh"
#include "MTSettings.mqh"
#include "Meta Tools Functions.mqh"
#include "Meta Tools Button Handlers.mqh"
#include "Meta Tools Init.mqh"
#include "Crosshair.mqh"
#include "TradeManager.mqh"
#include "Bar.mqh"
#include "SpreadHistory.mqh"
#include <..\Include\MetaLibraries\FFNewsCalendar.mqh>
//#include "TradeEXE.mqh"  // TO BE USED WHEN MOVING TO EA

//+------------------------------------------------------------------+




//+------------------------------------------------------------------+
//| GLOBAL VARIABLES SECTION                                         |
//+------------------------------------------------------------------+

   // ---------- Global settings -----------------------------------------------
   // int               BreakEvenPP = 20; // Default Break Even Line Distance, pp - removed from global variables; now BE is calculated as 90% of SL size
   
   bool              OperationAllowed = true;
   const  bool       LightVersion = false;
   const  bool       DemoVersion = true;
   const  datetime   DemoVersionUntil = D'2033.05.30 23:59';
   const  bool       SubscriptionVersion = false;
   const  datetime   SubscriptionUntil = D'2023.03.01 23:59';

   // -----------------------------------------


    string indicator_short_name = "Meta Tools " + IntegerToString(ChartID());
    StrategyID    Strategy;                          // Current Strategy on the chart
    DayPriorityID DayPriority = None;               // Priority for today (Buy / Sell / None)
    Account_Number AN;     // account #
    MTSettings sets;  // settings
    
    bool DelayedInitComplete = false; // flag to track whether delayed intialization was completed; used in DelayedInit() function in Functions file
    short DelayedInitCounter = 0;
    
    int Mouse_X;
    int Mouse_Y;
    
    CSpreadHistory SpreadHistory; // class to record and read history of spreads
    double AvgSpread = 0;

// Default properties of automatic graphical objects for A-BF Tools
   static color SelectedLineColor = clrGreen;
   static double SelectedLineStyle = STYLE_SOLID;
   static int    SelectedLineWidth = 1;
   static color DefaultUpTrendColor = clrGreen;
   static color DefaultDownTrendColor = clrRed;
   static bool  InWatchList = false;
   string WatchlistMark = "WatchlistMark";
   static bool AutoBFTools = false;
   static bool ThisChartIsActive = false;
   
   
   double   latest_close_price; // to be able to get the latest price when working in SimulatorMode

   // -----------------------------------------

   ////    ***      TIMER GLOBAL variables   ***
        datetime    MessageOnChartAppearTime;
   ////    ***      End of TIMER GLOBAL variables  ***


   //Auto-Triangles
   color    InpTriangleColor=clrLightSalmon;    // Auto-Triangles: Color
   //===========


   // Watch List 
   static bool WatchPairButtonsHidden = false;
   static int  ClearWLButtonPressedCount;
   datetime    WatchPairButtonsLastUpdate = TimeLocal()-10;
   datetime    LastChartChange = TimeLocal()-10;
   
   int         WatchListButtonsYShift = 0;
   //CWatchList   WatchList;
   
   
   // Chart controls
   static short LoadLastTemplateButtonPressedCount; // to count how many times "K" button was pressed to load last template
   static short AutoCreateH1Levels_for_S3_Strategy_ButtonPressedCount; // to count how many times "B" button is pressed
   static short AutoFindD1Breaks_ButtonPressedCount; // to count how many times "U" button is pressed
   static short CopyRiskToAllCharts_ButtonPressedCount; // counter for times ";" is pressed for copying risk from PSC of current chart to all other charts
  



   int         X_Delta;                         // Shift of all the UI elements from the left side of the screen
   int         HoursDelay;                      // Hours that this graph can be not checked (for Watch List); equals to -1, if "X" button is pressed.
   string      OpenChartSymbols[50];            // array of symbols of open charts in terminal
   long        OpenChartIDs[50];                // array of ID's of open charts in terminal (only Watched Ones)
   long        OpenChartInTerminalIDs[100];     // array of ID's of open charts in terminal (all, not only watched)
   CButton     ColorButtonsArray[12];           // array of buttons that change colors
   int         OpenChartsCount=0;
   int         SecondsSinceLastSoundAlarm = 1;
   ulong       click = 0;        // for double-click detection
   ulong       dclick = 750000;  // for double-click detection
   int         Timer2  = 0; // 5 seconds delay
   int         Timer60 = 0; // 60 seconds delay
   int         Timer3  = 0; // another timer for 5 sec delay - needs for other place in code should not intersect with Timer2
   int         Timer10 = 0; // 10 seconds timer
   int         Timer10_2 = 0; // 10 seconds timer
   MqlDateTime CurrentTime;
   CButton     ArrayOfWatchPairButtons[30];
   CLabel      ArrayOfTradeDirLabels[];
   CLabel      ArrayOfTradeInfoLabels[];
   CLevel      Levels[];            // array of trade levels drawn by user (green or red)
   
   CBar        Current_H1_Bar(0,PERIOD_H1);
   
   datetime    D1_datetime; // for detection of new day
   
   int         PreviousHour; // variable to detect hour change (instead of Newbar() function, which is not working properly)
   Probability SignalProbability;
   int         i_SelectedObjectsCount;

   int    LastBars = 0;
   
   // Push Notifications about possible signals
   //bool   InformedAboutpossiblePinBar = false; 
   bool   InformedAboutpossibleLevelFalseBreak = false;
   bool   InformedAboutBackwardsBreak = false;
   bool   PinBarPossible = false;
   
   bool   AnotherSecondDelay = true;
   

   double point_global = MarketInfoMQL4(Symbol(),MODE_POINT);
   bool   TemplateSavedAtThisHourAlready = false;
   
   // Shortcuts
   static bool CTRL_Pressed = false;
   static bool SHIFT_Pressed = false;
   static int  DButtonPressedCount;
   static int  SixButtonPressedCount;
   static int  HButtonPressedCount;
   
   static bool CrosshairMode = false;
   CCrosshair  crosshair();
   
   
   // ATR Indication variables
   float ATR5;
   float ATR14;
   float ATR180;
   
   // Hide/Show all objects
   bool  ObjectsHidden = false;
   string object_names[];
   int    object_timeframes[];




//    ***      Pin Bar Detector - Global Variables    ***
      bool     UseSoundAlerts = true; // PB Detector: Use Sound Alerts
      double   BodyToLongShadow = 0.6; // PB Detector: Body To Long Shadow Ratio
      double   ShortShadowToLongShadow = 0.7; // PB Detector: Short Shadow to Long Shadow Ratio
      datetime ArrayTime[], LastTime; // variables to detect closure of the last bar
      int      StartSignalDetectorsAt = 4; // PB Detector: Start Detecting at This Hour (Server Time)
      int      StopSignalDetectorsAfter = 22; // PB Detector: Stop Detecting after This Hour (Server Time)
      int      CountBars = 1; // PB Detector: CountBars - number of bars to count on, 0 = all.
//    ***      End of Pin Bar Detector Global Variables ***

//    ***   TRADE MANAGER GLOBAL VARIABLES   ***
      CTradeManager  TradeManager;
      int         Order_Type = 0;
      static int  ClearTradingMarksButtonPressedCount;
      
      bool        TradeAllowed = false;
      datetime    TradeEXE_LastSignalReceived_Datetime;
      int         total_orders = 0; // to trigger OnTrade() event
      MqlTick     last_tick; // to get the latest bid and ask
      
      CFFNewsCalendar  NewsCalendar;
//+------------------------------------------------------------------+
//| END OF GLOBAL VARIABLES SECTION                                  |
//+------------------------------------------------------------------+
//==========================================================================================




//+------------------------------------------------------------------+
//| EXTERNAL / INPUT SETTINGS                                        |
//+------------------------------------------------------------------+



//    ------------------------   DEFAULT SETTINGS     ------------------------
            // ====== General Settings ======
input       group "General"
input       bool        S_Version = false; // S-Version Shortcuts & Behavior
input       StrategyID  StrategySelector = S3;         // Strategy
input       bool        ShowMetaKeypad         = true;    // Show Meta Keypad
input       bool        SimulatorMode = false;      // Simulator Mode
input       bool        DebugMode = false;      // Debug Mode
            bool        PBDetectorEnabled = true; // PB Detector: Turn ON
            
input       string   FakeVariable04 = ""; // ====== Buttton Colors ======            
            // ====== Row 1 of color buttons ======
input       color CustomColor1_1 = clrBrown;  // Raw 1 Button 1
input       color CustomColor1_2 = clrRed;    // Raw 1 Button 2
input       color CustomColor1_3 = clrGreen;  // Raw 1 Button 3
input       color CustomColor1_4 = clrBlue;   // Raw 1 Button 4   
                  
            // ====== Row 2 of color buttons ======
input       color CustomColor2_1 = clrDarkViolet;   // Raw 2 Button 1
input       color CustomColor2_2 = clrChocolate;    // Raw 2 Button 2
input       color CustomColor2_3 = clrMagenta;      // Raw 2 Button 3
input       color CustomColor2_4 = clrDarkOrange;   // Raw 2 Button 4         
            
            // ====== Row 3 of color buttons ======
input       color CustomColor3_1 = clrDarkGray;   // Raw 3 Button 1
input       color CustomColor3_2 = clrLawnGreen;  // Raw 3 Button 2
input       color CustomColor3_3 = clrPink;       // Raw 3 Button 3
input       color CustomColor3_4 = clrDodgerBlue; // Raw 3 Button 4  
            
            // ====== Chart Object Defaults ======
input       string   FakeVariable05 = ""; // ====== Chart Object Defaults ======
input       color    M1_H1_Rectangle_Level_color      = clrLightGray;   // M1-H1 Rectangle Level
input       color    H4_Rectable_Level_color          = clrPink;        // H4 Rectable Level
input       color    MN1_D1_Rectangle_Level_color     = clrPowderBlue;  // MN1-D1 Rectable Level

            // ====== Watch List ======
input       string   FakeVariable06 = ""; // ====== Watch List ======
input       bool     SkipToNextWhenExcludedFromList = false; // Skip To Next Chart When Excluded From List

            // ====== Saving Templates ======
            bool     AutoSaveTemplateEnabled = true; // Auto-Save Template Every 4 hrs
            bool     AutoSaveTemplateAndScreenshotUponTrade = true; // Auto-Save Template & Screenshot Upon Trade
            int      ShowClosingTimerFromMin=50; // Timer: Show Closing Timer from Min for H1 Bar
input       int      StartAlertsEveryHourAtMin = 55; // Possible Pin Bar / S3-impulse Warning Starts at min 

            // ====== Levels Snapping ======
input       string   FakeVariable08 = ""; // ====== Levels Snapping ======
input       SnapTo   SnapHorizontalLinesOnMN1toH4To      = Extremums;   // Snap horizontal lines on MN1, W1, D1, H4 to
input       SnapTo   SnapHorizontalRectanglesOnMN1toH4To = Bodies;      // Snap horizontal rectangles on MN1, W1, D1, H4 to
input       SnapTo   SnapHorizontalLinesOnH1toM1To = Bodies;           // Snap horizontal lines on H1, M30, M15, M5, M1 to
input       SnapTo   SnapHorizontalRectanglesOnH1toM1To = Bodies;      // Snap horizontal rectangles on H1, M30, M15, M5, M1 to

input       string   FakeVariable07 = ""; // ====== Trade Manager ======
input       ENUM_TIMEFRAMES MainTF       = PERIOD_H1;    // Main Traiding Timeframe
input       bool     ShowSpreadThickness = true;         // Show Spread Thickness for Orders
input       short    MinRecommSL_fromATR = 25;           // Min Recommended SL-size as %% of ATR14
input       short    MaxRecommSL_fromATR = 35;           // Max Recommended SL-size as %% of ATR14
input       short    SL_Not_Less_Than_PP = 15;           // SL-size not less than, pp
input       short    SL_Not_More_Than_PP = 45;           // SL-size not more than, pp

//*/


/*
//    ------------------------   SILENT SETTINGS FOR SEREGEY   ------------------------
            // ====== General Settings ======
input       string   FakeVariable03 = ""; // ====== General ======
input       bool     S_Version = true;          // S-Version
input       StrategyID  StrategySelector = S3;         // Strategy
input       bool     ShowMetaKeypad = false;    // Show Meta Keypad
input       bool     DebugMode = false;      // Debug Mode
            bool     PBDetectorEnabled = false; // PB Detector: Turn ON
            
            // ====== Row 1 of color buttons ======
input       color CustomColor1_1 = clrBrown;     // Raw 1 Button 1
input       color CustomColor1_2 = clrRed;       // Raw 1 Button 2
input       color CustomColor1_3 = clrGreen;     // Raw 1 Button 3
input       color CustomColor1_4 = clrBlue;      // Raw 1 Button 4   
            
            // ====== Row 2 of color buttons ======
input       color CustomColor2_1 = clrDarkViolet;   // Raw 2 Button 1
input       color CustomColor2_2 = clrPink;         // Raw 2 Button 2
input       color CustomColor2_3 = clrLightSalmon;  // Raw 2 Button 3
input       color CustomColor2_4 = clrSkyBlue;      // Raw 2 Button 4         
      
            // ====== Row 3 of color buttons ======
input       color CustomColor3_1 = clrGray;        // Raw 3 Button 1
input       color CustomColor3_2 = clrOlive;       // Raw 3 Button 2
input       color CustomColor3_3 = clrLimeGreen;   // Raw 3 Button 3
input       color CustomColor3_4 = clrDodgerBlue;  // Raw 3 Button 4  
      
            
            // ====== Chart Object Defaults ======
input       string   FakeVariable04 = ""; // ====== Chart Object Defaults ======
input       color    M1_H1_Rectangle_Level_color      = clrLightPink;   // M1-H1 Rectangle Level
input       color    H4_Rectable_Level_color          = clrLightPink;   // H4 Rectable Level
input       color    MN1_D1_Rectangle_Level_color     = clrLightGray;   // MN1-D1 Rectable Level
            
            // ====== Watch List ======
input       string   FakeVariable05 = ""; // ====== Watch List ======
input       bool     SkipToNextWhenExcludedFromList = false; // Skip To Next Chart When Excluded From List
            // ====== Saving Templates ======
            bool     AutoSaveTemplateEnabled = false;  // Auto-Save Template Every 4 hrs
            bool     AutoSaveTemplateAndScreenshotUponTrade = true; // Auto-Save Template & Screenshot Upon Trade
            int      ShowClosingTimerFromMin=57; // Timer: Show Closing Timer from Min for H1 Bar
            int      StartAlertsEveryHourAtMin = 57; // Possible Pin Bar / S3-impulse Warning Start at min 

            // ====== Levels Snapping ======
input       string   FakeVariable08 = ""; // ====== Levels Snapping ======
input       SnapTo   SnapHorizontalLinesOnMN1toH4To      = Extremums;   // Snap horizontal lines on MN1, W1, D1, H4 to
input       SnapTo   SnapHorizontalRectanglesOnMN1toH4To = Bodies;      // Snap horizontal rectangles on MN1, W1, D1, H4 to
input       SnapTo   SnapHorizontalLinesOnH1toM1To = Bodies;           // Snap horizontal lines on H1, M30, M15, M5, M1 to
input       SnapTo   SnapHorizontalRectanglesOnH1toM1To = Bodies;      // Snap horizontal rectangles on H1, M30, M15, M5, M1 to

input       string   FakeVariable06 = ""; // ====== Trade Manager ======
input       ENUM_TIMEFRAMES MainTF       = PERIOD_H1;    // Main Traiding Timeframe
input       bool     ShowSpreadThickness = false;         // Show Spread Thickness for Orders
input       short    MinRecommSL_fromATR = 0;           // Min Recommended SL-size as %% of ATR14
input       short    MaxRecommSL_fromATR = 0;           // Max Recommended SL-size as %% of ATR14
input       short    SL_Not_Less_Than_PP = 0;           // SL-size not less than, pp
input       short    SL_Not_More_Than_PP = 0;           // SL-size not more than, pp
// ----------------------------------------------------------------------------------------------------------------------
//*/



//    ------------------------   COMMON SETTINGS FOR ALL   ------------------------
input  bool    CreateLabelsOnChart = true; // Create Trading Labels On Chart
input  bool    DeletePendingOrderWhenBEReached = true; // Delete Pending Order If Break Even Reached


input       string   FakeVariable10 = ""; // ====== News Calendar ======
input       NewsImpact  News_Impact         = High_Impact; // Impact of news to display


//    ------------------------   FOUR STRINGS SETTINGS (СДЕЛАНО НЕ INPUT-ПЕРЕМЕННЫМИ - ДО ТОГО КАК БУДЕТ ВСЯ СТРАТЕГИЯ ДОРАБОТАНА   ------------------------
string   FakeVariable09 = ""; // ====== 'Four Strings' Strategy ======
double  MinDistBigFibo618_100_ForSL_pp = 500; // Min Dist Btw 61.8 & 100% of Large Fibo for SL











// *** CONTOLS DECLARATION ****

CButton H1_Visibility_Button;
CButton H1H4_Visibility_Button;
CButton H1D1_Visibility_Button;
CButton D1_Visibility_Button;

CButton CustomColor_Button1_1;
CButton CustomColor_Button1_2;
CButton CustomColor_Button1_3;
CButton CustomColor_Button1_4;
CButton CustomColor_Button2_1;
CButton CustomColor_Button2_2;
CButton CustomColor_Button2_3; 
CButton CustomColor_Button2_4;
CButton CustomColor_Button3_1;
CButton CustomColor_Button3_2;
CButton CustomColor_Button3_3;
CButton CustomColor_Button3_4;

CButton SetDashedLine_Button;
CButton SetSolidLine_Button;
CButton SetThickLine_Button;
CButton SetDotLine_Button;
CButton UnselectAll_Button;
CButton FixChartScale_Button;
CButton FiboReset_Button;
CButton SaveTemplate_Button;
CButton Minimize_Button;
CButton WL_InWL_High_Button;
CButton WL_InWL_Low_Button;
CButton ClearWL_Button;

CButton WL1_Button;
CButton WL2_Button;
CButton WL3_Button;
CButton WL4_Button;
CButton WL5_Button;
CButton WLX_Button;

CButton WL_Pair1;
CButton WL_Pair2;
CButton WL_Pair3;
CButton WL_Pair4;
CButton WL_Pair5;
CButton WL_Pair6;
CButton WL_Pair7;
CButton WL_Pair8;
CButton WL_Pair9;
CButton WL_Pair10;
CButton WL_Pair11;
CButton WL_Pair12;
CButton WL_Pair13;
CButton WL_Pair14;
CButton WL_Pair15;
CButton WL_Pair16;
CButton WL_Pair17;
CButton WL_Pair18;
CButton WL_Pair19;
CButton WL_Pair20;
CButton WL_Pair21;
CButton WL_Pair22;
CButton WL_Pair23;
CButton WL_Pair24;
CButton WL_Pair25;
CButton WL_Pair26;
CButton WL_Pair27;
CButton WL_Pair28;
CButton WL_Pair29;
CButton WL_Pair30;
CButton WL_Prev;
CButton WL_Next;
// -----------------

// =====

CButton SoundControl_Button;
CButton PushControl_Button;

// ====

CLabel FloatingLabel;

// ====

CButton AutoBFTools_Button;

CLabel TodayRange_Label;
CLabel ATR5_Label;
CLabel ATR14_Label;
CLabel ATR180_Label;



CLabel TradeDir_WL_Pair1_Label;
CLabel TradeInfo_WL_Pair1_Label;

CLabel TradeDir_WL_Pair2_Label;
CLabel TradeInfo_WL_Pair2_Label;

CLabel TradeDir_WL_Pair3_Label;
CLabel TradeInfo_WL_Pair3_Label;

CLabel TradeDir_WL_Pair4_Label;
CLabel TradeInfo_WL_Pair4_Label;

CLabel TradeDir_WL_Pair5_Label;
CLabel TradeInfo_WL_Pair5_Label;

CLabel TradeDir_WL_Pair6_Label;
CLabel TradeInfo_WL_Pair6_Label;

CLabel TradeDir_WL_Pair7_Label;
CLabel TradeInfo_WL_Pair7_Label;

CLabel TradeDir_WL_Pair8_Label;
CLabel TradeInfo_WL_Pair8_Label;

CLabel TradeDir_WL_Pair9_Label;
CLabel TradeInfo_WL_Pair9_Label;

CLabel TradeDir_WL_Pair10_Label;
CLabel TradeInfo_WL_Pair10_Label;

CLabel TradeDir_WL_Pair11_Label;
CLabel TradeInfo_WL_Pair11_Label;

CLabel TradeDir_WL_Pair12_Label;
CLabel TradeInfo_WL_Pair12_Label;

CLabel TradeDir_WL_Pair13_Label;
CLabel TradeInfo_WL_Pair13_Label;

CLabel TradeDir_WL_Pair14_Label;
CLabel TradeInfo_WL_Pair14_Label;

CLabel TradeDir_WL_Pair15_Label;
CLabel TradeInfo_WL_Pair15_Label;

CLabel TradeDir_WL_Pair16_Label;
CLabel TradeInfo_WL_Pair16_Label;

CLabel TradeDir_WL_Pair17_Label;
CLabel TradeInfo_WL_Pair17_Label;

CLabel TradeDir_WL_Pair18_Label;
CLabel TradeInfo_WL_Pair18_Label;

CLabel TradeDir_WL_Pair19_Label;
CLabel TradeInfo_WL_Pair19_Label;

CLabel TradeDir_WL_Pair20_Label;
CLabel TradeInfo_WL_Pair20_Label;

CLabel TradeDir_WL_Pair21_Label;
CLabel TradeInfo_WL_Pair21_Label;

CLabel TradeDir_WL_Pair22_Label;
CLabel TradeInfo_WL_Pair22_Label;

CLabel TradeDir_WL_Pair23_Label;
CLabel TradeInfo_WL_Pair23_Label;

CLabel TradeDir_WL_Pair24_Label;
CLabel TradeInfo_WL_Pair24_Label;

CLabel TradeDir_WL_Pair25_Label;
CLabel TradeInfo_WL_Pair25_Label;

CLabel TradeDir_WL_Pair26_Label;
CLabel TradeInfo_WL_Pair26_Label;

CLabel TradeDir_WL_Pair27_Label;
CLabel TradeInfo_WL_Pair27_Label;

CLabel TradeDir_WL_Pair28_Label;
CLabel TradeInfo_WL_Pair28_Label;

CLabel TradeDir_WL_Pair29_Label;
CLabel TradeInfo_WL_Pair29_Label;

CLabel TradeDir_WL_Pair30_Label;
CLabel TradeInfo_WL_Pair30_Label;

CLabel RightLowerInfoSymbol_Label;
CLabel RightLowerInfo_Label;


// *** Meta Keypad ***
CButton Crosshair_Button;
CButton DeleteObject_Button;
CButton ChartNavigateLeft_Button;
CButton ChartNavigateRight_Button;
CButton MakeTrendHorizontalAndExtend_Button;
CButton ToggleTrendRay_Button;
CButton FixVertScale_Button;
CButton ShowHideScenarios_Button;
CButton HideShowAllObjectsExcLevels_Button;
CButton CopyObject_Button;
// **********************************
// **********************************