#property copyright "Copyright 2019, Evgeny Drumachik"
#property link      "http://www.strategy4you.ru"
#property strict

void SaveTemplate_Button_Click() {
   bool also_save_screeshot = true;
   SaveTemplateAndScrenshot(also_save_screeshot);
}

   
   


void H1_Visibility_Button_Click() {
   for (int i = 0; i < ObjectsTotal(0, 0, -1); i++) { // for each object on the chart
      string objectName = ObjectName(0, i, 0, -1);    // getting the object name
      CGraphObject obj(objectName);
      
      
      if (obj.IsSelected()) {    // is this object is selected then...
         if (!IsModificationAllowed(objectName)) {
            MessageOnChart("Visibility of '" + objectName + "' is Not Modified", MessageOnChartAppearTime);
            continue;
         }
         ObjectSetMQL4(obj.Name, OBJPROP_TIMEFRAMES, OBJ_PERIOD_H1);
         ObjectSetMQL4(GetChannelName(obj.Name), OBJPROP_TIMEFRAMES, OBJ_PERIOD_H1);
         obj.UpdateToolTip();
      }
   }
   if(H1_Visibility_Button.Pressed())
      H1_Visibility_Button.Pressed(false);
   ChartRedraw();
}


void H1H4_Visibility_Button_Click() {
   for (int i = 0; i < ObjectsTotal(0, 0, -1); i++) { // for each object on the chart
      string objectName = ObjectName(0, i, 0, -1);    // getting the object name
      CGraphObject obj(objectName);
      if (obj.IsSelected()) {    // is this object is selected then...
         if (!IsModificationAllowed(objectName)) {
            MessageOnChart("Visibility of '" + objectName + "' is Not Modified", MessageOnChartAppearTime);
            continue;
         }
         ObjectSetMQL4(objectName, OBJPROP_TIMEFRAMES, OBJ_PERIOD_H1 | OBJ_PERIOD_H4);
         ObjectSetMQL4(GetChannelName(objectName), OBJPROP_TIMEFRAMES, OBJ_PERIOD_H1 | OBJ_PERIOD_H4);
         obj.UpdateToolTip();
      }
   }
   if(H1H4_Visibility_Button.Pressed())   H1H4_Visibility_Button.Pressed(false);
   ChartRedraw();
}

void H1D1_Visibility_Button_Click() {
   for (int i = 0; i < ObjectsTotal(0, 0, -1); i++) { // for each object on the chart
      string objectName = ObjectName(0, i, 0, -1);    // getting the object name
      CGraphObject obj(objectName);
      if (obj.IsSelected()) {    // is this object is selected then...
         if (!IsModificationAllowed(objectName)) {
            MessageOnChart("Visibility of '" + objectName + "' is Not Modified", MessageOnChartAppearTime);
            continue;
         }
         ObjectSetMQL4(objectName, OBJPROP_TIMEFRAMES, OBJ_PERIOD_H1 | OBJ_PERIOD_H4 | OBJ_PERIOD_D1);
         ObjectSetMQL4(GetChannelName(objectName), OBJPROP_TIMEFRAMES, OBJ_PERIOD_H1 | OBJ_PERIOD_H4 | OBJ_PERIOD_D1);
         obj.UpdateToolTip();
      }
   }
   if(H1H4_Visibility_Button.Pressed())   H1H4_Visibility_Button.Pressed(false);
   ChartRedraw();
}


void D1_Visibility_Button_Click() {
   for (int i = 0; i < ObjectsTotal(0, 0, -1); i++) { // for each object on the chart
      string objectName = ObjectName(0, i, 0, -1);    // getting the object name
      CGraphObject obj(objectName);
      if (obj.IsSelected()) {    // is this object is selected then...
         if (!IsModificationAllowed(objectName)) {
            MessageOnChart("Visibility of '" + objectName + "' is Not Modified", MessageOnChartAppearTime);
            continue;
         }
         ObjectSetMQL4(objectName, OBJPROP_TIMEFRAMES, OBJ_PERIOD_D1);
         ObjectSetMQL4(GetChannelName(objectName), OBJPROP_TIMEFRAMES, OBJ_PERIOD_D1);
         obj.UpdateToolTip();
      }
   }
   if(D1_Visibility_Button.Pressed())  D1_Visibility_Button.Pressed(false);
   
   ChartRedraw();
}




void SetSelectedLinesStyle_Button_Click(int style) {
   if (!isSelectedObjectModificationAllowed()) { SetDotLine_Button.Pressed(false); return; }
   if (SelectedObjectsCount()==0) {
      //SelectedLineStyle = STYLE_DOT;
      SetDotLine_Button.Pressed(false);
      return;
   } 

   for (int i = 0; i < ObjectsTotal(0, 0, -1); i++) { // for each object on the chart
      string objectName = ObjectName(0, i, 0, -1);    // getting the object name
      if (ObjectGetMQL4(objectName, OBJPROP_SELECTED) == 1) {    // is this object is selected then...
         
         if (!IsModificationAllowed(objectName)) {
            MessageOnChart("Style of '" + objectName + "' is Not Modified", MessageOnChartAppearTime);
            continue;
         }
         if(ObjectTypeMQL4(objectName)==OBJ_FIBO) 
         {
            ObjectSetMQL4(objectName,OBJPROP_LEVELWIDTH,1); 
            ObjectSetMQL4(objectName,OBJPROP_LEVELSTYLE,style);              
         }
         else
         {
            ObjectSetMQL4(objectName,OBJPROP_WIDTH,1); 
            ObjectSetMQL4(objectName,OBJPROP_STYLE,style);
            ObjectSetMQL4(GetChannelName(objectName),OBJPROP_WIDTH,1); 
            ObjectSetMQL4(GetChannelName(objectName),OBJPROP_STYLE,style);
            if(ObjectTypeMQL4(objectName)==OBJ_TREND) {
               CTrend trend(objectName);
               trend.DeleteTriangles();
               //TrianglesDelete(objectName); //deleting triangle where this line is parent
               ObjectSetTextMQL4(objectName,""); 
            }  
         }
         
      }
   }
   if(SetDotLine_Button.Pressed())  SetDotLine_Button.Pressed(false); 
   
   ChartRedraw();
}






void SetThickLine_Button_Click() {
   if (!isSelectedObjectModificationAllowed()) { SetThickLine_Button.Pressed(false); return; }
   if (SelectedObjectsCount()==0) {
      //SelectedLineWidth = 2;
      SetThickLine_Button.Pressed(false);
      return;
   } 

   // TODO: add check if FIBO - do not do anything!
   for (int i = 0; i < ObjectsTotal(0, 0, -1); i++) { // for each object on the chart
      string objectName = ObjectName(0, i, 0, -1);    // getting the object name
      
      if (ObjectGetMQL4(objectName, OBJPROP_SELECTED) == 1) {    // is this object is selected then...
        
         if (!IsModificationAllowed(objectName)) {
            MessageOnChart("Style of '" + objectName + "' is Not Modified", MessageOnChartAppearTime);
            continue;
         }
   
         if(ObjectTypeMQL4(objectName)==OBJ_FIBO) {
            // "This is FIBO!"
            ObjectSetMQL4(objectName, OBJPROP_LEVELWIDTH,2);
            }
         else
         {
            //This is NOT FIBO!
            ObjectSetMQL4(objectName,OBJPROP_STYLE,STYLE_SOLID);
            ObjectSetMQL4(objectName,OBJPROP_WIDTH,2);
            ObjectSetMQL4(GetChannelName(objectName),OBJPROP_STYLE,STYLE_SOLID);
            ObjectSetMQL4(GetChannelName(objectName),OBJPROP_WIDTH,2);
            //if(ObjectTypeMQL4(objectName)==OBJ_TREND) DrawUpdateTriangle(ChartEventID,objectName,0);
         }
      }
   }
   if(SetThickLine_Button.Pressed())  SetThickLine_Button.Pressed(false);

   ChartRedraw();
}


void FiboReset_Button_Click() {

   if (SelectedObjectsCount() > 1) {
      Alert("You selected " + IntegerToString(SelectedObjectsCount()) + " objects. Only one Fibo and no other object must be selected!");
      FiboReset_Button.Pressed(false);
      return;
   }
   
    if (SelectedObjectsCount() == 0) {
      Print("Select one Fibo");
      FiboReset_Button.Pressed(false);
      return;
   }           
   
   for (int i = 0; i < ObjectsTotal(0, 0, -1); i++) { // for each object on the chart
      string objectName = ObjectName(0, i, 0, -1);    // getting the object name
      
      if (ObjectGetMQL4(objectName, OBJPROP_SELECTED) == 1) {    // is this object is selected then...
      
         if(ObjectTypeMQL4(objectName)==OBJ_FIBO) 
         {
            CFibo fibo(objectName);
            fibo.ResetLevelsToDefault();
            break;
         }
         else
         {
            Alert("No Fibo is selected!");
         }
      }
   }
   if(FiboReset_Button.Pressed())  FiboReset_Button.Pressed(false);    
   
   ChartRedraw();  
}


void ProcessShortCuts(long lparam, string sparam) {
   // resetting counters for some buttons, if any other button is pressed
   if ( lparam!=54 && lparam!=90 && lparam==102) SixButtonPressedCount     = 0; // for "6" and "Z" 
   if ( lparam!=68 && lparam!=88)                DButtonPressedCount       = 0; // for "D" and "X" 
   // **********************************

   

      long i_sparam = StringToInteger(sparam);

      if((lparam==48 && i_sparam==11) || (lparam==96 && i_sparam==82)) { // "0" - Show/Hide all buttons
         Print("Hide/Show all buttons");
         if ( GlobalVariableGet("BFToolsShowAll") == 1 ) {
            ObjectsHidden = true;
            BroadcastEvent(0,0,"HideAllUI");
         }
         else {
            ObjectsHidden = false;
            BroadcastEvent(0,0,"ShowAllUI");
         }
         UpdatePositionOfAllButtons(0, X_Delta);
         return;
      }
      
      if(lparam==57 && i_sparam==10) { // "9" - Show/Hide Main buttons
         Print("Hide/Show Main buttons");
         if (GlobalVariableGet("BFToolsShowMainButtons") == 1) { HideMainButtons(); BroadcastEvent(ChartID(),0,"HideMainButtons"); }
         else { 
            //ShowMainButtons(); 
            BroadcastEvent(ChartID(),0,"ShowMainButtons"); 
         }
         UpdatePositionOfAllButtons(0, X_Delta);
         return;
      }
      
      
     

      if(lparam==67 && i_sparam==46) { // "C" - Create New Trend
         CreateNewTrend();
         UpdatePositionOfAllButtons(0, X_Delta);
         ChartRedraw();
         return;
      }


      if(lparam==86 && i_sparam==47) { // "V" - Create New Rectangular Level
         if (S_Version) 
            MakeTrendHorizontalAndExtend();
         else
            CreateNewRectLevel();
         UpdatePositionOfAllButtons(0, X_Delta);
         ChartRedraw();
         return;
      }


      
      
      if(lparam==81 && i_sparam==16) { // Thick Line "Q"
         Print("Thick Line");
         SetThickLine_Button_Click();
         ChartRedraw();
         return;
      }

      if(lparam==87 && i_sparam==17) { // Thin Line "W"
         if (SelectedObjectsCount() > 0) {
            Print("Thin Line");
            SetSelectedLinesStyle_Button_Click(STYLE_SOLID);
            ChartRedraw();
            return;
         }
      }      

      if(lparam==69 && i_sparam==18) { // Dashed Line "E"
         Print("Dashed Line");
         SetSelectedLinesStyle_Button_Click(STYLE_DASH);
         ChartRedraw();
         return;
      }    

      if(lparam==82 && i_sparam==19) { // Dotted Line "R"
         Print("Dotted Line");
         SetSelectedLinesStyle_Button_Click(STYLE_DOT);
         ChartRedraw();
         return;
      }    
      
      
      if(lparam==84 && i_sparam==20) { // Dotted Line "T"
         SetExtremumToTakeOut(ChartID(),Mouse_X,Mouse_Y);
         ChartRedraw();
         return;
      }    
      
      
      if(lparam==89 && i_sparam==21) { // "Y" - Toggle Ray / Toggle Fill on Rectangle
         ToggleRay_and_RectangleFill();
         ChartRedraw();
         return;
      }          
                       
      // Getting Chart Auto-Scroll mode on/off -> CurrentAutoScrollMode
      long CurrentAutoScrollMode;
      ChartGetInteger(0,CHART_AUTOSCROLL,0,CurrentAutoScrollMode);
      //====
         
         
      //  === ZOOM IN
      //Print("SHIFT_Pressed = ", SHIFT_Pressed);
      if (SHIFT_Pressed == false && lparam == 16) SHIFT_Pressed = true;
      if (lparam == 187) { 
         if (!SHIFT_Pressed) { // Shift not is not pressed - so, zooming in
            Print(lparam,"= - Zoom In"); 
            ChartSetInteger(0,CHART_SCALEFIX,0,0);
            long CurrentChartScale;
            ChartGetInteger(0,CHART_SCALE,0,CurrentChartScale);
            CurrentChartScale++;
            ChartSetInteger(0,CHART_SCALE,0,CurrentChartScale);
            if (CurrentAutoScrollMode) ChartNavigate(0,CHART_END,0); //shifting chart to the end, if auto-scroll mode is ON
            SHIFT_Pressed = false;
         }
         else SHIFT_Pressed = false;
         return;
      }  
      //  ====== END OF ZOOM IN PROCESSING 


      if (lparam==68) {  // "D"
         Print("D"); 
         
         if (S_Version) {
            CreateNewRectLevel();
         }
         else {
            if (!EventChartCustom(ChartID(),CHART_SWITCHED,0,0,"")) Print("Couldn't send custom event 'CHART_SWITCHED'");
            SwitchTo_D1();
         }
         ChartRedraw();
         return;
      }
      
      
      
      if (lparam==88) {  // "X" - switch chart to TF D1
         Print("X"); 
         SwitchTo_D1();
         if (!EventChartCustom(ChartID(),CHART_SWITCHED,0,0,"")) Print("Couldn't send custom event 'CHART_SWITCHED'");
         ChartRedraw();
         return;
      }
      
      
      
      if (lparam==54 || lparam==90 || lparam==102) {  // "6"  "Z"
         Print("6/Z - H1"); 
         
         // "6" is pressed on H1 period. 
         SixButtonPressedCount++;
         if (SixButtonPressedCount == 3) { // Waiting it to be pressed 3 times. Then switch all charts to H1 TF
            Print("SixButtonPressedCount = ", SixButtonPressedCount);
            
            SwitchAllChartsToTF(PERIOD_H1);
            SixButtonPressedCount = 0;
            return;
         }
         SwitchTo_H1(0);
         if (!EventChartCustom(ChartID(),CHART_SWITCHED,0,0,"")) Print("Couldn't send custom event 'CHART_SWITCHED'");
         ChartRedraw();
        
         return;
      }
      
      
      
      
      if (lparam==55 && !IsKeyShift() && !IsKeyCtrl()) {  // "7"
         Print("7 - M15"); 
         ChartSetInteger(0,CHART_SCALE,0,2);      
         UnselectAll(); 
         ChartSetInteger(0,CHART_SCALEFIX,0,0); 
         ChartSetInteger(0,CHART_AUTOSCROLL,0,true); 
         ChartSetSymbolPeriod(0,_Symbol,PERIOD_M15); 
         ChartNavigate(0,CHART_END,0); 
         ChartRedraw();
         if (!EventChartCustom(ChartID(),CHART_SWITCHED,0,0,"")) Print("Couldn't send custom event 'CHART_SWITCHED'");
         return;
      }
      
      
      
      
      
      if (lparam==52 || lparam==100) {  // "4"  "H4"
         Print("4 - H4"); 
         //setting chart scale
         if (sets.FixChartScale_H4_Zoom == -1)  { // no special scale fixed by FIX button - default scale settings
            Print("!");
            Set_Chart_Default_Scale(0, PERIOD_H4, Strategy);
         }
         else {
            if ( ChartGetInteger(ChartID(),CHART_SCALE) != 1 )
               ChartSetInteger(0,CHART_SCALE,0,sets.FixChartScale_H4_Zoom); 

            ChartSetInteger(0,CHART_SCALEFIX,0,1);
            ChartSetDouble(0,CHART_FIXED_MAX,sets.FixChartScale_H4_Max);
            ChartSetDouble(0,CHART_FIXED_MIN,sets.FixChartScale_H4_Min);
         }
          
         UnselectAll(); 
         ChartSetSymbolPeriod(0,_Symbol,PERIOD_H4); 
         ChartNavigate(0,CHART_END,0); 
         ChartRedraw();
         if (!EventChartCustom(ChartID(),CHART_SWITCHED,0,0,"")) Print("Couldn't send custom event 'CHART_SWITCHED'");
         return;
      }
      
      
      if (lparam==53 || lparam==101) { 
         Print("5 - M5"); 
         ChartSetInteger(0,CHART_SCALE,0,2);      
         UnselectAll(); 
         ChartSetInteger(0,CHART_SCALEFIX,0,0); 
         ChartSetInteger(0,CHART_AUTOSCROLL,0,true); 
         ChartSetSymbolPeriod(0,_Symbol,PERIOD_M5); 
         ChartNavigate(0,CHART_END,0); 
         ChartRedraw();
         if (!EventChartCustom(ChartID(),CHART_SWITCHED,0,0,"")) Print("Couldn't send custom event 'CHART_SWITCHED'");
         return;
      }
      if (lparam==87) { 
         Print("W - W1"); 
         ChartSetInteger(0,CHART_SCALE,0,3);      
         UnselectAll(); 
         ChartSetInteger(0,CHART_SCALEFIX,0,0); 
         ChartSetInteger(0,CHART_AUTOSCROLL,0,true); 
         ChartSetSymbolPeriod(0,_Symbol,PERIOD_W1); 
         ChartNavigate(0,CHART_END,0); 
         ChartRedraw();
         if (!EventChartCustom(ChartID(),CHART_SWITCHED,0,0,"")) Print("Couldn't send custom event 'CHART_SWITCHED'");
         return;
      }
      //if (lparam==77) { // "M"
      //   Print("M - MN"); 
      //   ChartSetInteger(0,CHART_SCALE,0,3);     
      //   UnselectAll(); 
      //   ChartSetInteger(0,CHART_SCALEFIX,0,0); 
      //   ChartSetInteger(0,CHART_AUTOSCROLL,0,true); 
      //   ChartSetSymbolPeriod(0,_Symbol,PERIOD_MN1); 
      //   ChartNavigate(0,CHART_END,0); 
      //   ChartRedraw();
      //   return;
      //}
      if ( (lparam==51 || lparam==99) && !IsKeyShift() && !IsKeyCtrl()) {  //"3"
         Print("3 - M30");
         ChartSetInteger(0,CHART_SCALE,0,2);    
         UnselectAll(); 
         ChartSetInteger(0,CHART_SCALEFIX,0,0); 
         ChartSetInteger(0,CHART_AUTOSCROLL,0,true); 
         ChartSetSymbolPeriod(0,_Symbol,PERIOD_M30); 
         ChartNavigate(0,CHART_END,0); 
         ChartRedraw();
         if (!EventChartCustom(ChartID(),CHART_SWITCHED,0,0,"")) Print("Couldn't send custom event 'CHART_SWITCHED'");
         return;
      }
      if (lparam==79) {  // "o"
         Print("o - M1"); 
         ChartSetInteger(0,CHART_SCALE,0,2);      
         UnselectAll(); 
         ChartSetInteger(0,CHART_SCALEFIX,0,0); 
         ChartSetInteger(0,CHART_AUTOSCROLL,0,true); 
         ChartSetSymbolPeriod(0,_Symbol,PERIOD_M1); 
         ChartNavigate(0,CHART_END,0); 
         ChartRedraw();
         if (!EventChartCustom(ChartID(),CHART_SWITCHED,0,0,"")) Print("Couldn't send custom event 'CHART_SWITCHED'");
         return;
      }
      if (lparam==70) { // "F"
         Print("F - Fixed / Not Fixed Chart"); 
         long value;
         ChartGetInteger(0,CHART_SCALEFIX,0,value);
         if (value==1) ChartSetInteger(0,CHART_SCALEFIX,0,0);
            else ChartSetInteger(0,CHART_SCALEFIX,0,1);
         ChartRedraw();
         return;
      }
      if (lparam==71) {  // "g"
         Print("G - Auto Scroll Toggle"); 
         //long CurrentAutoScrollMode;
         ChartGetInteger(0,CHART_AUTOSCROLL,0,CurrentAutoScrollMode);
         if (CurrentAutoScrollMode) ChartSetInteger(0,CHART_AUTOSCROLL,0,false);
            else {
               ChartSetInteger(0,CHART_AUTOSCROLL,0,true);
               ChartNavigate(0,CHART_END,0); 
            }
         ChartRedraw();
         return;
      }
      

      if(lparam==27 && i_sparam==1) { // "ESC" - Unselect All
         UnselectAll();
         ChartRedraw();
         return;
      }
      
      if (lparam==9 && i_sparam==15) { // "TAB" Toggle FIX
         Print("Toggle FIX");
         ToggleFixChartScale();
         ChartRedraw();
         return;
      }
      
      
      // *** Navigation between charts ***
      if(i_sparam==331) { // Left arrow pressed - prev chart; 
         PrevChartInWL();
         ChartRedraw();
         return;
      }
      if (lparam == 65) { // letter "A"
         SwitchToChart(GetPrevChartID());
         ChartRedraw();
         return;
      }
      
      if(i_sparam==333) { // Right arrow pressed - next chart;
         NextChartInWL();
         ChartRedraw();
         return;
      }
      if (lparam == 83) { // "S"
         if (ChartNext(ChartID()) != -1) { SwitchToChart(ChartNext(ChartID())); }
         ChartRedraw();
         return;
      }
      // NAVIGATION BETWEEN CHARTS 
      
      
      
      
      
      if (lparam == 72) { // "H" - make trend horizontal;
         Print("Making trend horizontal");
         MakeTrendHorizontalAndExtend();
         ChartRedraw();
         return;
      } // "H" pressed
      
      
      
      
      
      
      if ( (lparam==49 || lparam==97) && !IsKeyShift() && !IsKeyCtrl() ) { // "1" - Add/remove pair to/from Watch List with Low Priority
         Print("1 - Add to Watch List with High Priority"); 
         HighClicked();
         ChartRedraw();
         return;
         }
     
      if( (i_sparam==3 || lparam==50) && !IsKeyShift() && !IsKeyCtrl() ) { // "2" - Add/remove pair to/from Watch List with High Probability
         Print("2 - Add to Watch List with Low Priority"); 
         LowClicked();
         ChartRedraw();
         return;
      }


      if( lparam == 77 ) {  //"m" hide / show S3/S4 levels (keep only BF-related graph objects)
         Print("Hide S3/S4 levels");
         bool leave_S3_levels = false;
         bool keep_BF_levels = true;
         bool scenarious_only = false;
         HideShowAllObjectsToggle(leave_S3_levels,keep_BF_levels,scenarious_only); // leave levels untouched
         UpdatePositionOfAllButtons(0, X_Delta);
         if (!S_Version && !ObjectsHidden && InWatchList) ShowHoursDelayButtons(true);
         ChartRedraw();
         return;      
      }  

      
      if(i_sparam==53 || lparam==191) {  // "/" (slash) hide / show all graphical objects
         Print("Hide all objects");
         HideShowAllObjectsToggle();
         UpdatePositionOfAllButtons(0, X_Delta);
         if (!S_Version && !ObjectsHidden && InWatchList) ShowHoursDelayButtons(true);
         ChartRedraw();
         return;      
      }      
      
      if(i_sparam==52 || lparam==190) {  //"." (point) hide / show all graphical objects, excl. S3 levels
         Print("Hide all objects, except S3 levels");
         bool keep_S3_levels = true;
         HideShowAllObjectsToggle(keep_S3_levels); // leave levels untouched
         UpdatePositionOfAllButtons(0, X_Delta);
         if (!S_Version && !ObjectsHidden && InWatchList) ShowHoursDelayButtons(true);
         ChartRedraw();
         return;      
      }     

      if(i_sparam==51 || lparam==188) {  //"," (comma) hide / show all only scenarious of price movement
         Print("Hide only scenarious");
         bool keep_levels = true;
         bool keep_BF_levels = true;
         bool scenarious_only = true;
         HideShowAllObjectsToggle(keep_levels, keep_BF_levels, scenarious_only); // leave levels untouched
         UpdatePositionOfAllButtons(0, X_Delta);
         if (!S_Version && !ObjectsHidden && InWatchList) ShowHoursDelayButtons(true);
         ChartRedraw();
         return;      
      }     
      
      if(i_sparam==25 || lparam==80) {  //"P" Screenshot
         ChartRedraw();
         bool saved_and_copied;

         saved_and_copied = SaveAndCopyScreenshot_Func();
         
         if (saved_and_copied)
            MessageOnChart("Screenshot saved and copied to clipboard", MessageOnChartAppearTime);
         else
            MessageOnChart("Screenshot saving failed", MessageOnChartAppearTime);
         ChartRedraw();
         return;      
      }  
      
      
      if(i_sparam==26 || lparam==219) {  //"[" Light Mode

         ChartSetInteger(0,CHART_COLOR_BACKGROUND,clrLemonChiffon);
         ChartSetInteger(0,CHART_COLOR_CHART_LINE,clrBlack);
         ChartSetInteger(0,CHART_COLOR_FOREGROUND,clrBlack);
         
         // bar colors
         ChartSetInteger(0,CHART_COLOR_CHART_UP,clrBlack);
         ChartSetInteger(0,CHART_COLOR_CHART_DOWN,clrBlack);
         ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,clrBlack);
         ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,clrWhite);
         // 
         

         ChartRedraw();
         return;      
      }          
      
      
      if(i_sparam==27 || lparam==221) {  //"]" Dark Mode

         ChartSetInteger(0,CHART_COLOR_BACKGROUND,clrBlack);
         ChartSetInteger(0,CHART_COLOR_CHART_LINE,clrLightBlue);
         ChartSetInteger(0,CHART_COLOR_FOREGROUND,clrDarkGray);
         
         // bar colors
         ChartSetInteger(0,CHART_COLOR_CHART_UP,clrMediumSeaGreen);
         ChartSetInteger(0,CHART_COLOR_CHART_DOWN,clrCrimson);
         ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,clrMediumSeaGreen);
         ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,clrCrimson);
         //
         ChartRedraw();
         return;      
      }       




      if(lparam==74) {  // "J" - Create new Fibo
      
         if (!S_Version) return;

         CFibo fibo();
         fibo.Create(Mouse_X,Mouse_Y);
         fibo.Select(true);
         
         fibo.SetDefaultVisibility();
         
         UpdatePositionOfAllButtons(0, X_Delta);
         ChartRedraw();
         return;      
      }    

   
      if (lparam == 78) {  // "N" is pressed - highlighting the bar

         Print("Highlighting candle");
         CRectangle rect;
         rect.HighlightCandleAtCursor(Mouse_X,Mouse_Y);
         ChartRedraw();
         return;
      }


      if ( lparam == 76 && !IsKeyShift()) {  // for "L" (tripple press "LLL" - clear chart from trading marks)
         if (ClearTradingMarksButtonPressedCount < 2) {
            ClearTradingMarksButtonPressedCount++;
            string msg = "Press 'L' 3 times in 2s to delete all trading marks. Pressed: " + IntegerToString(ClearTradingMarksButtonPressedCount);
            MessageOnChart(msg, MessageOnChartAppearTime);
            Print(msg);
            ChartRedraw();
            return;
         }
         ClearTradingMarks();
         ClearTradingMarksButtonPressedCount = 0;
         ChartRedraw();
      }


      if ( lparam == 76 && IsKeyShift()) {  // for "Shift+L" 
         string msg = "Shift+L: Deleting all news marks on all charts...";
         MessageOnChart(msg, MessageOnChartAppearTime);
         Print(msg);
         CFFNewsCalendar::DeleteAllNewsMarksOnAllCharts();
         ChartRedraw();
         return;
      }


      if ( lparam == 75 ) {  // for "K" Load last template
         if (LoadLastTemplateButtonPressedCount < 2) {
            LoadLastTemplateButtonPressedCount++;
            string msg = "Press 'K' 3 times in 2s to apply last template. Pressed: " + IntegerToString(LoadLastTemplateButtonPressedCount);
            MessageOnChart(msg, MessageOnChartAppearTime);
            Print(msg);
            ChartRedraw();
            return;
         }
         LoadLastTemplateButtonPressedCount = 0;
         Print("Broadcasting command to Trade.exe...");
         EventChartCustom(ChartID(),LOAD_LAST_TEMPLATE,0,0,"");
         ChartRedraw();
         return;
      }
      
      
      if ( lparam==66 ) { // "B" | "BBB" - Auto-find and build H1-levels for S3-strategy
         if (AutoCreateH1Levels_for_S3_Strategy_ButtonPressedCount < 2) {
            AutoCreateH1Levels_for_S3_Strategy_ButtonPressedCount++;
            string msg = "Find new pairs `with H1-levels. Pressed " + IntegerToString(AutoCreateH1Levels_for_S3_Strategy_ButtonPressedCount) + " times / 3";
            MessageOnChart(msg, MessageOnChartAppearTime);
            Print(msg);
            ChartRedraw();
            return;
         }
         AutoCreateH1Levels_for_S3_Strategy_ButtonPressedCount = 0;
         MessageOnChart("Searching new pairs with H1-levels...", MessageOnChartAppearTime);
         Print("Broadcasting command to find new pairs to all open charts...");
         BroadcastEvent(ChartID(),0,"FIND_H1_LEVELS");
          ChartRedraw();
         return;
      }



      if ( lparam==85 ) { // "U" | "UUU" - Auto-find D1-breaks and add them to watch list (S4-strategy)
         if (AutoFindD1Breaks_ButtonPressedCount < 2) {
            AutoFindD1Breaks_ButtonPressedCount++;
            string msg = "Find D1-level break. Pressed " + IntegerToString(AutoFindD1Breaks_ButtonPressedCount) + " times / 3";
            MessageOnChart(msg, MessageOnChartAppearTime);
            Print(msg);
            ChartRedraw();
            return;
         }
         AutoFindD1Breaks_ButtonPressedCount = 0;
         MessageOnChart("Searching new pairs with D1-level breaks...", MessageOnChartAppearTime);
         Print("Broadcasting command to find new pairs to all open charts...");
         BroadcastEvent(ChartID(),0,"FIND_D1_BREAKS");
         ChartRedraw();
         return;
      }





      if ( lparam == 222 || lparam == 220 ) { // "\"
         Print("Checking risk parameters on all charts...");
         PrintRiskParametersFromAllCharts();   
         ChartRedraw();      
         return;
      }


      if ( lparam == 186 ) { // ";;;"
         // read account size and risk size of the current chart
         
         if (CopyRiskToAllCharts_ButtonPressedCount < 2) {
            CopyRiskToAllCharts_ButtonPressedCount++;
            string msg = "Copy risk settings to all charts. Pressed " + IntegerToString(CopyRiskToAllCharts_ButtonPressedCount) + " times / 3";
            MessageOnChart(msg, MessageOnChartAppearTime);
            Print(msg);
            ChartRedraw();
            return;
         }
         CopyRiskToAllCharts_ButtonPressedCount = 0;
         CopyRiskParametersToAllCharts(); // actual execution of the main fucntion
         PrintRiskParametersFromAllCharts();
         ChartRedraw();
         return;
      }


      if ( lparam == 8 || lparam == 46 ) { // "DELETE"
         
         UpdatePositionOfAllButtons(0, X_Delta);
         
         return;
      }





      
      //Print("lparam=",lparam);
      //Print("sparam=",i_sparam);
      //Print("No Shortcut Assigned");
      ChartRedraw();
}





void PrintRiskParametersFromAllCharts() {
   // prints our risk parameters from all charts where PSC will be found

   long current_chart_id = ChartFirst();
   
   while (true) {
   
      string warning = "";
      bool PSC_installed = false;
      bool MetaTools_installed = false;
      
      // check, if Position Size Calculator is attached to that chart already
      short IndicatorsTotal = (short)ChartIndicatorsTotal(current_chart_id,0);
      for (short i = 0; i < IndicatorsTotal; i++) {
         string ind_name = ChartIndicatorName(current_chart_id,0,i);
         if ( StringFind(ind_name, "Position Size Calculator") != -1) {
            PSC_installed = true;
         }
         else if ( StringFind(ind_name, "Meta Tools") != -1) {
            MetaTools_installed = true;
         }
      }
      
      if (!PSC_installed) warning = "PSC is NOT installed!";
      if (!MetaTools_installed) warning += "; Meta Tools is NOT installed";
      string s_AccountBalance = FindObjectByPostfix("m_EdtAccount", OBJ_EDIT, current_chart_id);                       
      s_AccountBalance = ObjectGetString(current_chart_id, s_AccountBalance, OBJPROP_TEXT);
      string s_AccountRisk = FindObjectByPostfix("EdtRiskPRes", OBJ_EDIT, current_chart_id);
      s_AccountRisk = ObjectGetString(current_chart_id, s_AccountRisk, OBJPROP_TEXT);
      string s_AccountRiskMoney = FindObjectByPostfix("EdtRiskMRes", OBJ_EDIT, current_chart_id);
      s_AccountRiskMoney = ObjectGetString(current_chart_id, s_AccountRiskMoney, OBJPROP_TEXT);
      Print(": Account Balance = " + s_AccountBalance + "  |  Risk: " + s_AccountRisk + "% / " + AccountInfoString(ACCOUNT_CURRENCY) + " " + s_AccountRiskMoney + 
         "  |  " + ChartSymbol(current_chart_id) + "  |  " + warning);
      
      current_chart_id = ChartNext(current_chart_id);
      if (current_chart_id < 0) break;
   
   }
}

void CopyRiskParametersToAllCharts() {

   string account_size;
   string risk_size;
   
   account_size = FindObjectByPostfix("m_EdtAccount", OBJ_EDIT, ChartID());
   account_size = ObjectGetString(ChartID(), account_size, OBJPROP_TEXT);
   
   risk_size = FindObjectByPostfix("EdtRiskPIn", OBJ_EDIT, ChartID());
   risk_size = ObjectGetString(ChartID(), risk_size, OBJPROP_TEXT);
   
   Print("Setting account size and risk in %% on all charts as on the current one: account = " + account_size + " | Risk " + risk_size + "%");
   
   // removing commas to properly convert to double
   StringReplace(account_size,",","");
   StringReplace(risk_size,",","");
   
   BroadcastEvent(PSC_SET_ACCOUNT_SIZE,0,StringToDouble(account_size),"");
   BroadcastEvent(PSC_SET_RISK_SIZE,   0,StringToDouble(risk_size),"");
   
   MessageOnChart("Update request sent to all charts: account " + account_size + "; risk " + risk_size + "%", MessageOnChartAppearTime);

}





void SwitchTo_H1(long chart_id) {
   if (sets.FixChartScale_H1_Zoom == -1) { // no special scale fixed by FIX button - applying default scale
      Set_Chart_Default_Scale(chart_id, PERIOD_H1, Strategy);

   }
   else { // setting pre-set scale
      //Print("Setting Chart Fixed Min: ", sets.FixChartScale_H1_Min);
      ChartSetInteger(chart_id,CHART_SCALE,0,sets.FixChartScale_H1_Zoom);
      ChartSetInteger(chart_id,CHART_SCALEFIX,0,1);
      ChartSetDouble(chart_id,CHART_FIXED_MAX,sets.FixChartScale_H1_Max);
      ChartSetDouble(chart_id,CHART_FIXED_MIN,sets.FixChartScale_H1_Min);
   }
   
   UnselectAll(); 
   ChartSetInteger(chart_id,CHART_AUTOSCROLL,0,true); 
   ChartNavigate(chart_id,CHART_END,0); 
   bool added_to_queue = ChartSetSymbolPeriod(chart_id,NULL,PERIOD_H1); 
}






void SwitchTo_D1() {
   // setting chart scale
   
   

   if (sets.FixChartScale_D1_Zoom == -1)  { // no special scale fixed by FIX button - setting defaults
      Set_Chart_Default_Scale(0, PERIOD_D1,Strategy);
   }
   else {
      ChartSetInteger(0,CHART_SCALE,0,sets.FixChartScale_D1_Zoom);  
      ChartSetInteger(0,CHART_SCALEFIX,0,1);
      ChartSetDouble(0,CHART_FIXED_MAX,sets.FixChartScale_D1_Max);
      ChartSetDouble(0,CHART_FIXED_MIN,sets.FixChartScale_D1_Min);
   } 
   
   UnselectAll(); 
   ChartSetInteger(0,CHART_AUTOSCROLL,0,true); 
   ChartNavigate(0,CHART_END,0); 
   
   
   //  Waiting D/X to be pressed 3 times. Then switch all charts to Daily TF
   DButtonPressedCount++;
   if (DButtonPressedCount == 3) {
      SwitchAllChartsToTF(PERIOD_D1);
      DButtonPressedCount = 0;
      return;
   }
   
   //Print("Switching to D1... Period now: " + TimeframeToString(_Period));
   bool added_to_queue = ChartSetSymbolPeriod(0,NULL,PERIOD_D1); 
 
}









void ToggleRay_and_RectangleFill() {

   Print("Toggle 'Ray' and rectangle fill");
   if (SelectedObjectsCount()==0)  { Print("No lilnes are selected"); return; }

   for (int i = 0; i < ObjectsTotal(0, 0, -1); i++) { // for each object on the chart
   string objectName = ObjectName(0, i, 0, -1);    // getting the object name
      if (ObjectGetMQL4(objectName, OBJPROP_SELECTED) == 1) {    // is this object is selected then...
         
         if(ObjectTypeMQL4(objectName)==OBJ_TREND || ObjectTypeMQL4(objectName)==OBJ_CHANNEL) {
            CTrend trend(objectName);
            trend.ToggleRay();
         }
         else if (ObjectTypeMQL4(objectName)==OBJ_RECTANGLE) {
            CRectangle rect(objectName);
            rect.ToggleRectangleFill();
         }
      }
   }
}






void MakeTrendHorizontalAndExtend() {

   HButtonPressedCount++;
   
   string objects[];
   ArrayOfSelectedObjects(objects); // getting array of selected objects         
   
   
   if (HButtonPressedCount >= 2) { // HButtonPressedCount 2 or more      
      for (int i = 0; i < ArraySize(objects); i++) {
            CGraphObject obj(objects[i]);
            obj.ExtendPoint2();
            HButtonPressedCount = 0;
       }
   }
      else { // HButtonPressedCount < 2
         
         for (int i = 0; i < ArraySize(objects); i++) {
            if (ObjectTypeMQL4(objects[i]) == OBJ_TREND) {
               if (Strategy == BF && ArraySize(objects) > 1) continue; // protection from multiple objects change in BF
               CTrend trend(objects[i]);
               trend.MakeHorizontal();
               trend.Ray(false);
            }
         }
      }
}




bool WatchListButtonsClickHandler(string sparam) {
    if (sparam=="WL1_Button") 
    {
      //Print("WL1_Button clicked.");
      SetHoursDelay(1,_Symbol);
      ResetAllWatchButtons();
      HighlightWatchButton(1);
      UpdateWatchPairButtons();
      ChartRedraw();
      return true;
    }
    if (sparam=="WL2_Button") 
    {
      //Print("WL2_Button clicked.");
      SetHoursDelay(2,_Symbol);
      ResetAllWatchButtons();
      HighlightWatchButton(2);
      UpdateWatchPairButtons();
      ChartRedraw();
      return true;
    }
    if (sparam=="WL3_Button") 
    {
      //Print("WL3_Button clicked.");
      SetHoursDelay(3,_Symbol);
      ResetAllWatchButtons();
      HighlightWatchButton(3);
      UpdateWatchPairButtons();
      ChartRedraw();
      return true;
    }
    if (sparam=="WL4_Button") 
    {
      //Print("WL4_Button clicked.");
      SetHoursDelay(4,_Symbol);
      ResetAllWatchButtons();
      HighlightWatchButton(4);
      UpdateWatchPairButtons();
      ChartRedraw();
      return true;
    }
    if (sparam=="WL5_Button") 
    {
       //Print("WL5_Button clicked.");
       SetHoursDelay(5,_Symbol);
       ResetAllWatchButtons();
       HighlightWatchButton(5);
       UpdateWatchPairButtons();
       ChartRedraw();
       return true;
    }
    if (sparam=="WL6_Button") 
    {
       //Print("WL6_Button clicked.");
       SetHoursDelay(6,_Symbol);
       ResetAllWatchButtons();
       HighlightWatchButton(6);
       UpdateWatchPairButtons();
       ChartRedraw();
       return true;
    }
    if (sparam=="WLX_Button") 
    {
       //Print("WLX_Button clicked.");
       SetHoursDelay(-1,_Symbol);
       ResetAllWatchButtons();
       HighlightWatchButton(-1);
       UpdateWatchPairButtons();
       ChartRedraw();
       return true;
    }
    
    if (sparam=="WL_Next") 
    {
      NextChartInWL();        // for all other version - switching through charts in WL   
      WL_Next.Pressed(false);
      ChartRedraw();
      return true;
    }
    
    if (sparam=="WL_Prev") 
    {
      PrevChartInWL(); // for all other version - switching through charts in WL
      WL_Prev.Pressed(false);
      ChartRedraw();
      return true;
    }
    else {
      ChartRedraw();
      return false;
    }
}



bool WatchListPairButtonsClickHandler(string sparam) {
    if (sparam=="WL_Pair1")  { SwitchToChart(OpenChartIDs[0]); ArrayOfWatchPairButtons[0].Pressed(false); ChartRedraw(); return true; }
    if (sparam=="WL_Pair2")  { SwitchToChart(OpenChartIDs[1]); ArrayOfWatchPairButtons[1].Pressed(false); ChartRedraw(); return true; }
    if (sparam=="WL_Pair3")  { SwitchToChart(OpenChartIDs[2]); ArrayOfWatchPairButtons[2].Pressed(false); ChartRedraw(); return true; }
    if (sparam=="WL_Pair4")  { SwitchToChart(OpenChartIDs[3]); ArrayOfWatchPairButtons[3].Pressed(false); ChartRedraw(); return true; }
    if (sparam=="WL_Pair5")  { SwitchToChart(OpenChartIDs[4]); ArrayOfWatchPairButtons[4].Pressed(false); ChartRedraw(); return true; }
    if (sparam=="WL_Pair6")  { SwitchToChart(OpenChartIDs[5]); ArrayOfWatchPairButtons[5].Pressed(false); ChartRedraw(); return true; }
    if (sparam=="WL_Pair7")  { SwitchToChart(OpenChartIDs[6]); ArrayOfWatchPairButtons[6].Pressed(false); ChartRedraw(); return true; }
    if (sparam=="WL_Pair8")  { SwitchToChart(OpenChartIDs[7]); ArrayOfWatchPairButtons[7].Pressed(false); ChartRedraw(); return true; }
    if (sparam=="WL_Pair9")  { SwitchToChart(OpenChartIDs[8]); ArrayOfWatchPairButtons[8].Pressed(false); ChartRedraw(); return true; }
    if (sparam=="WL_Pair10") { SwitchToChart(OpenChartIDs[9]); ArrayOfWatchPairButtons[9].Pressed(false); ChartRedraw(); return true; } 
    
    if (sparam=="WL_Pair11")  { SwitchToChart(OpenChartIDs[10]); ArrayOfWatchPairButtons[10].Pressed(false); ChartRedraw(); return true; }
    if (sparam=="WL_Pair12")  { SwitchToChart(OpenChartIDs[11]); ArrayOfWatchPairButtons[11].Pressed(false); ChartRedraw(); return true; }
    if (sparam=="WL_Pair13")  { SwitchToChart(OpenChartIDs[12]); ArrayOfWatchPairButtons[12].Pressed(false); ChartRedraw(); return true; }
    if (sparam=="WL_Pair14")  { SwitchToChart(OpenChartIDs[13]); ArrayOfWatchPairButtons[13].Pressed(false); ChartRedraw(); return true; }
    if (sparam=="WL_Pair15")  { SwitchToChart(OpenChartIDs[14]); ArrayOfWatchPairButtons[14].Pressed(false); ChartRedraw(); return true; }
    if (sparam=="WL_Pair16")  { SwitchToChart(OpenChartIDs[15]); ArrayOfWatchPairButtons[15].Pressed(false); ChartRedraw(); return true; }
    if (sparam=="WL_Pair17")  { SwitchToChart(OpenChartIDs[16]); ArrayOfWatchPairButtons[16].Pressed(false); ChartRedraw(); return true; }
    if (sparam=="WL_Pair18")  { SwitchToChart(OpenChartIDs[17]); ArrayOfWatchPairButtons[17].Pressed(false); ChartRedraw(); return true; }
    if (sparam=="WL_Pair19")  { SwitchToChart(OpenChartIDs[18]); ArrayOfWatchPairButtons[18].Pressed(false); ChartRedraw(); return true; }
    if (sparam=="WL_Pair20")  { SwitchToChart(OpenChartIDs[19]); ArrayOfWatchPairButtons[19].Pressed(false); ChartRedraw(); return true; } 
    
    if (sparam=="WL_Pair21")  { SwitchToChart(OpenChartIDs[20]); ArrayOfWatchPairButtons[20].Pressed(false); ChartRedraw(); return true; } 
    if (sparam=="WL_Pair22")  { SwitchToChart(OpenChartIDs[21]); ArrayOfWatchPairButtons[21].Pressed(false); ChartRedraw(); return true; } 
    if (sparam=="WL_Pair23")  { SwitchToChart(OpenChartIDs[22]); ArrayOfWatchPairButtons[22].Pressed(false); ChartRedraw(); return true; } 
    if (sparam=="WL_Pair24")  { SwitchToChart(OpenChartIDs[23]); ArrayOfWatchPairButtons[23].Pressed(false); ChartRedraw(); return true; } 
    if (sparam=="WL_Pair25")  { SwitchToChart(OpenChartIDs[24]); ArrayOfWatchPairButtons[24].Pressed(false); ChartRedraw(); return true; } 

    if (sparam=="WL_Pair26")  { SwitchToChart(OpenChartIDs[25]); ArrayOfWatchPairButtons[25].Pressed(false); ChartRedraw(); return true; } 
    if (sparam=="WL_Pair27")  { SwitchToChart(OpenChartIDs[26]); ArrayOfWatchPairButtons[26].Pressed(false); ChartRedraw(); return true; } 
    if (sparam=="WL_Pair28")  { SwitchToChart(OpenChartIDs[27]); ArrayOfWatchPairButtons[27].Pressed(false); ChartRedraw(); return true; } 
    if (sparam=="WL_Pair29")  { SwitchToChart(OpenChartIDs[28]); ArrayOfWatchPairButtons[28].Pressed(false); ChartRedraw(); return true; } 
    if (sparam=="WL_Pair30")  { SwitchToChart(OpenChartIDs[29]); ArrayOfWatchPairButtons[29].Pressed(false); ChartRedraw(); return true; } 
    
    else return false;
}


void LineModificationButtonClickHandler(int id, string sparam) {

   if(sparam=="UnselectAll_Button")       { UnselectAll();                                   return; }
   if(sparam=="H1_Visibility_Button")     { H1_Visibility_Button_Click();                    return; }
   if(sparam=="H1H4_Visibility_Button")   { H1H4_Visibility_Button_Click();                  return; }
   if(sparam=="H1D1_Visibility_Button")   { H1D1_Visibility_Button_Click();                  return; }
   if(sparam=="D1_Visibility_Button")     { D1_Visibility_Button_Click();                    return; }
   
   if(sparam=="SetDashedLine_Button")     { SetSelectedLinesStyle_Button_Click(STYLE_DASH);  SetDashedLine_Button.Pressed(false); return; }
   if(sparam=="SetSolidLine_Button")      { SetSelectedLinesStyle_Button_Click(STYLE_SOLID); SetSolidLine_Button.Pressed(false);  return; }
   if(sparam=="SetDotLine_Button")        { SetSelectedLinesStyle_Button_Click(STYLE_DOT);   SetDotLine_Button.Pressed(false);    return; }
   if(sparam=="SetThickLine_Button")      { SetThickLine_Button_Click();                   return; }
   if(sparam=="FiboReset_Button")         { FiboReset_Button_Click();                        return; }
   
   
   // color modification
   if (StringFind(sparam,"CustomColor_Button") != -1) { // if true - color modification button is pressed
   
      if (sparam == "CustomColor_Button1_1")      { ModifyColor(CustomColor_Button1_1); }
      else if (sparam == "CustomColor_Button1_2") { ModifyColor(CustomColor_Button1_2); }
      else if (sparam == "CustomColor_Button1_3") { ModifyColor(CustomColor_Button1_3); }
      else if (sparam == "CustomColor_Button1_4") { ModifyColor(CustomColor_Button1_4); }
      else if (sparam == "CustomColor_Button2_1") { ModifyColor(CustomColor_Button2_1); }
      else if (sparam == "CustomColor_Button2_2") { ModifyColor(CustomColor_Button2_2); }
      else if (sparam == "CustomColor_Button2_3") { ModifyColor(CustomColor_Button2_3); } 
      else if (sparam == "CustomColor_Button2_4") { ModifyColor(CustomColor_Button2_4); }
      else if (sparam == "CustomColor_Button3_1") { ModifyColor(CustomColor_Button3_1); }
      else if (sparam == "CustomColor_Button3_2") { ModifyColor(CustomColor_Button3_2); }
      else if (sparam == "CustomColor_Button3_3") { ModifyColor(CustomColor_Button3_3); }
      else if (sparam == "CustomColor_Button3_4") { ModifyColor(CustomColor_Button3_4); }

   }
   ChartRedraw(); 
   //  ==== color modification
   
}

void ModifyColor(CButton &btn) {

   if (SelectedObjectsCount()==0) {
      btn.Pressed(false);
      return;
   }  
   ColorSelectedObjects(btn.ColorBackground());
   if(btn.Pressed())  btn.Pressed(false);
}


bool isSelectedObjectModificationAllowed() {
   if (i_SelectedObjectsCount > 1 && S_Version && Strategy == BF) {
      PlaySound("timeout.wav");
      return false;
   }
   else return true;
}



void AutoBFToolsButton_Click() { 
   if (GlobalVariableGet("AutoBFTools") == 1) {
      GlobalVariableSet("AutoBFTools",0);
      AutoBFTools = false;
      AutoBFTools_Button.Color(clrBlack);
      AutoBFTools_Button.Font("Calibri");
      AutoBFTools_Button.ColorBackground(clrKhaki);
      AutoBFTools_Button.Pressed(false); 
   }
   else {
      GlobalVariableSet("AutoBFTools",1);
      AutoBFTools = true;
      AutoBFTools_Button.Color(clrWhite);
      AutoBFTools_Button.Font("Calibri Bold");
      AutoBFTools_Button.ColorBackground(clrGreen);
      AutoBFTools_Button.Pressed(false);  
      
      //Print("Sending broadcast event 'AutoBFToolsSwitchedON'"); // so that Auto BF Tools can receive it and refresh all the objects
      BroadcastEvent(ChartID(),0,"AutoBFToolsSwitchedON");
   }
   ChartRedraw(); 
}


void UpdateAutoBFToolsButton() { 
   if (AutoBFTools) {
      AutoBFTools_Button.Color(clrWhite);
      AutoBFTools_Button.Font("Calibri Bold");
      AutoBFTools_Button.ColorBackground(clrGreen);
      AutoBFTools_Button.Pressed(false);   
   }
   else {
      AutoBFTools_Button.Color(clrBlack);
      AutoBFTools_Button.Font("Calibri");
      AutoBFTools_Button.ColorBackground(clrKhaki);
      AutoBFTools_Button.Pressed(false);   
   }
   ChartRedraw(); 
}


void ToggleFixChartScale() {

   Print(__FUNCTION__);
   
   int period = _Period;
      
   if (period == PERIOD_H1) {
     if (sets.FixChartScale_H1_Zoom == -1) { // was off -> switching ON
         //ChartSetDouble(0,CHART_FIXED_MAX,1.2);
         ChartSetInteger(0,CHART_SCALEFIX,0,1); // switch ON chart scale fix
         sets.FixChartScale_H1_Zoom = (int)ChartGetInteger(ChartID(),CHART_SCALE,0);
         sets.FixChartScale_H1_Min =  ChartGetDouble(0,CHART_FIXED_MIN,0);
         //Print("Memorizing Chart Fix Min = ", sets.FixChartScale_H1_Min);
         sets.FixChartScale_H1_Max = ChartGetDouble(0,CHART_FIXED_MAX,0);
         HighlightButton(FixChartScale_Button,true);
         MessageOnChart("FIX ON", MessageOnChartAppearTime);
      }
      else { // was ON -> switching off
         sets.FixChartScale_H1_Zoom = -1;
         HighlightButton(FixChartScale_Button,false); 
         MessageOnChart("FIX OFF", MessageOnChartAppearTime);
      }
   }
   else if (period == PERIOD_H4) {
     if (sets.FixChartScale_H4_Zoom == -1) { // was off -> switching ON
         ChartSetInteger(0,CHART_SCALEFIX,0,1); // switch ON chart scale fix
         sets.FixChartScale_H4_Zoom = (int)ChartGetInteger(ChartID(),CHART_SCALE,0);
         sets.FixChartScale_H4_Min =  ChartGetDouble(0,CHART_FIXED_MIN,0);
         sets.FixChartScale_H4_Max =  ChartGetDouble(0,CHART_FIXED_MAX,0);
         HighlightButton(FixChartScale_Button,true); 
         MessageOnChart("FIX ON", MessageOnChartAppearTime);
      }
      else { // was ON -> switching off
         sets.FixChartScale_H4_Zoom = -1;
         HighlightButton(FixChartScale_Button,false); 
         MessageOnChart("FIX OFF", MessageOnChartAppearTime);
      }
   }
   else if (period == PERIOD_D1) {
     if (sets.FixChartScale_D1_Zoom == -1) { // was off -> switching ON
         ChartSetInteger(0,CHART_SCALEFIX,0,1); // switch ON chart scale fix
         sets.FixChartScale_D1_Zoom = (int)ChartGetInteger(ChartID(),CHART_SCALE,0);
         sets.FixChartScale_D1_Min  = ChartGetDouble(0,CHART_FIXED_MIN,0);
         sets.FixChartScale_D1_Max  = ChartGetDouble(0,CHART_FIXED_MAX,0);
         HighlightButton(FixChartScale_Button,true); 
         MessageOnChart("FIX ON", MessageOnChartAppearTime);
      }
      else { // was ON -> switching off
         sets.FixChartScale_D1_Zoom = -1;
         HighlightButton(FixChartScale_Button,false); 
         MessageOnChart("FIX OFF", MessageOnChartAppearTime);
      }
   }
   else {
      FixChartScale_Button.Pressed(false);
      MessageOnChart("FIX works for timeframes H1, H4 and D1 only", MessageOnChartAppearTime);
   }
   
   InitDayOfWeekLabels();
   ChartRedraw(); 
}



void ToggleCrosshairMode() {

   bool update_font = false;

   if (CrosshairMode) {
      HighlightButton(Crosshair_Button,false, update_font);
      crosshair.Hide();
      CrosshairMode = false;
   }
   else {
      HighlightButton(Crosshair_Button,true, update_font);
      crosshair.ShowAtInitialPosition();
      CrosshairMode = true;
      
   }   
   ChartRedraw(); 
}



void HighClicked() {
   if (!IsChartInWL(ChartID())) { // this chart is not yet in the watch list
      AddChartToWatchlist(HighProbability);
      SignalProbability = ProbabilityInWatchList(ChartID());
      UpdateDayPriority();
      RefreshComment();
      UpdateChartArrays();
      UpdateWatchPairButtons(true);
      ChartRedraw(); 
      return;        
   }
   else { // it is already in the watchlist
      SignalProbability = ProbabilityInWatchList(ChartID());
      if (SignalProbability == HighProbability) {
         if (SkipToNextWhenExcludedFromList) {
            if ( ChartID() == LastChartIDinWatchList() ) // this is the last chart in the watch list
               SwitchToChart(OpenChartIDs[0]);
            else // there are still charts in the watch list
               NextChartInWL();
         }
         RemoveChartFromWatchlist();
         UpdateDayPriority();
         UpdateLevelsArray();
         RefreshComment();
         UpdateChartArrays();
         UpdateWatchPairButtons(true);
         ChartRedraw(); 
         return; 
      }  
      else if (SignalProbability == LowProbability) { // change from LOW to HIGH
         int hours_delay = HoursDelay; // remember HoursDelay value
         RemoveChartFromWatchlist(); UpdateChartArrays();
         AddChartToWatchlist(HighProbability);
         UpdateDayPriority();
         SetHoursDelay(hours_delay,_Symbol); ResetAllWatchButtons(); HighlightWatchButton(HoursDelay);
         RefreshComment();
         UpdateChartArrays();
         UpdateWatchPairButtons(true);
         ChartRedraw(); 
         return; 
      }
   }  
}






void LowClicked() {
   if (!IsChartInWL(ChartID())) { // this chart is not yet in watch list
      AddChartToWatchlist(LowProbability);
      SignalProbability = ProbabilityInWatchList(ChartID());
      UpdateDayPriority();
      RefreshComment();
      UpdateChartArrays();
      UpdateWatchPairButtons(true);
      ChartRedraw(); 
      return;        
   }
   else { // // it is already in the watchlist
      SignalProbability = ProbabilityInWatchList(ChartID());
      if (SignalProbability == LowProbability) {
         if (SkipToNextWhenExcludedFromList) {
            if ( ChartID() == LastChartIDinWatchList() ) // this is the last chart in the watch list
               SwitchToChart(OpenChartIDs[0]);
            else // there are still charts in the watch list
               NextChartInWL();
         }
         RemoveChartFromWatchlist();
         UpdateDayPriority();
         UpdateLevelsArray();
         UpdateChartArrays();
         UpdateWatchPairButtons(true);
         RefreshComment();
         ChartRedraw(); 
         return;
      } 
      else if (SignalProbability == HighProbability) { // change from HIGH to LOW
         int hours_delay = HoursDelay; // remember HoursDelay value 
         RemoveChartFromWatchlist(); UpdateChartArrays();
         AddChartToWatchlist(LowProbability);
         UpdateDayPriority();
         UpdateChartArrays();
         UpdateWatchPairButtons(true);
         RefreshComment();
         SetHoursDelay(hours_delay,_Symbol); ResetAllWatchButtons(); HighlightWatchButton(HoursDelay);
         ChartRedraw(); 
         return; 
      }
   }  
   UpdatePositionOfAllButtons(0, X_Delta);
   ShowMainButtons();
   ChartRedraw(); 
}

void MoveColorChangeButtonToLevel(string clicked_obj, int x, int y) {

   //Print(__FUNCTION__ + ": clicked obj name: " + clicked_obj);
   if (clicked_obj != GetSelectedObjectName()) return;
   
   if (i_SelectedObjectsCount != 1) { /* Print(__FUNCTION__ + ": i_SelectedObjectsCount = " + i_SelectedObjectsCount); */ return; }
   
   CTrend obj(clicked_obj);
   
   if (obj.Type() != OBJ_TREND) { /*Print(__FUNCTION__ + ": type is not Trend");*/ return; }
   if (obj.HasRay()) { /*Print(__FUNCTION__ + ": Trend has ray");*/ return; }
   if (!obj.IsHorizontal()) { /*Print(__FUNCTION__ + ": Trend is not horizontal");*/ return; }
   color clr = obj.Color();
   if (clr != clrRed && clr != clrGreen) { /*Print(__FUNCTION__ + ": color is neither red, nor green");*/ return; }
   
   short red_btn_i = -1;
   short grn_btn_i = -1;

   // finding index of red and grn buttons
   for (short i = 0; i < ArraySize(ColorButtonsArray); i++) {
      if (ColorButtonsArray[i].ColorBackground() == clrRed) red_btn_i = i;
      else if (ColorButtonsArray[i].ColorBackground() == clrGreen) grn_btn_i = i; 
      if (red_btn_i != -1 && grn_btn_i != -1) break; // both indexes are found
   }
   
   //int x,y,subw=0;
   //ChartTimePriceToXY(0,subw,obj.DateTime1(),obj.Price1(),x,y);
   y = y + 20;
   
   if (clr == clrGreen) {
      // moving Red button
      ColorButtonsArray[red_btn_i].Move(x,y);
   }
   else {
      // moving Green button
       ColorButtonsArray[grn_btn_i].Move(x,y);
   }
}






