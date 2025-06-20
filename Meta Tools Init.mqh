void InitVisibilityButtons() {

   H1_Visibility_Button.Create(0,"H1_Visibility_Button",0,X_Delta+0,5,X_Delta+30,25);
   H1_Visibility_Button.Text("H1");
   H1_Visibility_Button.Font("Calibri");
   H1_Visibility_Button.FontSize(9);
   H1_Visibility_Button.Color(clrBlack);
   H1_Visibility_Button.ColorBackground(clrKhaki);
   H1_Visibility_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"H1_Visibility_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"H1_Visibility_Button",OBJPROP_TOOLTIP,"H1 visibility only");
   
   H1H4_Visibility_Button.Create(0,"H1H4_Visibility_Button",0,X_Delta+35,5,X_Delta+65,25);
   H1H4_Visibility_Button.Text(" H1|H4");
   H1H4_Visibility_Button.Font("Calibri");
   H1H4_Visibility_Button.FontSize(7);
   H1H4_Visibility_Button.Color(clrBlack);
   H1H4_Visibility_Button.ColorBackground(clrKhaki);
   H1H4_Visibility_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"H1H4_Visibility_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"H1H4_Visibility_Button",OBJPROP_TOOLTIP,"H1 and H4 visbility only");
   
   H1D1_Visibility_Button.Create(0,"H1D1_Visibility_Button",0,X_Delta+70,5,X_Delta+100,25);
   H1D1_Visibility_Button.Text("  H1-D1");
   H1D1_Visibility_Button.Font("Calibri");
   H1D1_Visibility_Button.FontSize(7);
   H1D1_Visibility_Button.Color(clrBlack);
   H1D1_Visibility_Button.ColorBackground(clrKhaki);
   H1D1_Visibility_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"H1D1_Visibility_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"H1D1_Visibility_Button",OBJPROP_TOOLTIP,"Visibility on H1, H4 and D1"); 
 
   D1_Visibility_Button.Create(0,"D1_Visibility_Button",0,X_Delta+105,5,X_Delta+135,25);
   D1_Visibility_Button.Text("D1");
   D1_Visibility_Button.Font("Calibri");
   D1_Visibility_Button.FontSize(9);
   D1_Visibility_Button.Color(clrBlack);
   D1_Visibility_Button.ColorBackground(clrKhaki);
   D1_Visibility_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"D1_Visibility_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"D1_Visibility_Button",OBJPROP_TOOLTIP,"D1 visibility only");
}

void InitColorControlButtons() {

   string ColorName;

   CustomColor_Button1_1.Create(0,"CustomColor_Button1_1",0,X_Delta+0,30,X_Delta+30,50);
   CustomColor_Button1_1.ColorBackground(CustomColor1_1);
   CustomColor_Button1_1.ColorBorder(clrBlack);
   ObjectSetInteger(0,"CustomColor_Button1_1",OBJPROP_ZORDER,100);
   ColorName = StringSubstr(ColorToString(CustomColor1_1,true),3);
   ObjectSetString(ChartID(),"CustomColor_Button1_1",OBJPROP_TOOLTIP,ColorName);
   ColorButtonsArray[0] = CustomColor_Button1_1;

   CustomColor_Button1_2.Create(0,"CustomColor_Button1_2",0,X_Delta+35,30,X_Delta+65,50);
   CustomColor_Button1_2.ColorBackground(CustomColor1_2);
   CustomColor_Button1_2.ColorBorder(clrBlack);
   ObjectSetInteger(0,"CustomColor_Button1_2",OBJPROP_ZORDER,100);
   ColorName = StringSubstr(ColorToString(CustomColor1_2,true),3);
   ObjectSetString(ChartID(),"CustomColor_Button1_2",OBJPROP_TOOLTIP,ColorName);
   ColorButtonsArray[1] = CustomColor_Button1_2;

   CustomColor_Button1_3.Create(0,"CustomColor_Button1_3",0,X_Delta+70,30,X_Delta+100,50);
   CustomColor_Button1_3.ColorBackground(CustomColor1_3);
   CustomColor_Button1_3.ColorBorder(clrBlack);
   ObjectSetInteger(0,"CustomColor_Button1_3",OBJPROP_ZORDER,100);
   ColorName = StringSubstr(ColorToString(CustomColor1_3,true),3);
   ObjectSetString(ChartID(),"CustomColor_Button1_3",OBJPROP_TOOLTIP,ColorName);
   ColorButtonsArray[2] = CustomColor_Button1_3;
   
   CustomColor_Button1_4.Create(0,"CustomColor_Button1_4",0,X_Delta+105,30,X_Delta+135,50);
   CustomColor_Button1_4.ColorBackground(CustomColor1_4);
   CustomColor_Button1_4.ColorBorder(clrBlack);
   ObjectSetInteger(0,"CustomColor_Button1_4",OBJPROP_ZORDER,100);
   ColorName = StringSubstr(ColorToString(CustomColor1_4,true),3);
   ObjectSetString(ChartID(),"CustomColor_Button1_4",OBJPROP_TOOLTIP,ColorName);
   ColorButtonsArray[3] = CustomColor_Button1_4;

   CustomColor_Button2_1.Create(0,"CustomColor_Button2_1",0,X_Delta+0,55,X_Delta+30,75);
   CustomColor_Button2_1.ColorBackground(CustomColor2_1);
   CustomColor_Button2_1.ColorBorder(clrBlack);
   ObjectSetInteger(0,"CustomColor_Button2_1",OBJPROP_ZORDER,100);
   ColorName = StringSubstr(ColorToString(CustomColor2_1,true),3);
   ObjectSetString(ChartID(),"CustomColor_Button2_1",OBJPROP_TOOLTIP,ColorName);
   ColorButtonsArray[4] = CustomColor_Button2_1;

   CustomColor_Button2_2.Create(0,"CustomColor_Button2_2",0,X_Delta+35,55,X_Delta+65,75);
   CustomColor_Button2_2.ColorBackground(CustomColor2_2);
   CustomColor_Button2_2.ColorBorder(clrBlack);
   ObjectSetInteger(0,"CustomColor_Button2_2",OBJPROP_ZORDER,100);
   ColorName = StringSubstr(ColorToString(CustomColor2_2,true),3);
   ObjectSetString(ChartID(),"CustomColor_Button2_2",OBJPROP_TOOLTIP,ColorName);
   ColorButtonsArray[5] = CustomColor_Button2_2;

   CustomColor_Button2_3.Create(0,"CustomColor_Button2_3",0,X_Delta+70,55,X_Delta+100,75);
   CustomColor_Button2_3.ColorBackground(CustomColor2_3);
   CustomColor_Button2_3.ColorBorder(clrBlack);
   ObjectSetInteger(0,"CustomColor_Button2_3",OBJPROP_ZORDER,100);
   ColorName = StringSubstr(ColorToString(CustomColor2_3,true),3);
   ObjectSetString(ChartID(),"CustomColor_Button2_3",OBJPROP_TOOLTIP,ColorName);
   ColorButtonsArray[6] = CustomColor_Button2_3;
   
   CustomColor_Button2_4.Create(0,"CustomColor_Button2_4",0,X_Delta+105,55,X_Delta+135,75);
   CustomColor_Button2_4.ColorBackground(CustomColor2_4);
   CustomColor_Button2_4.ColorBorder(clrBlack);
   ObjectSetInteger(0,"CustomColor_Button2_4",OBJPROP_ZORDER,100);
   ColorName = StringSubstr(ColorToString(CustomColor2_4,true),3);
   ObjectSetString(ChartID(),"CustomColor_Button2_4",OBJPROP_TOOLTIP,ColorName);
   ColorButtonsArray[7] = CustomColor_Button2_4;

   CustomColor_Button3_1.Create(0,"CustomColor_Button3_1",0,X_Delta+0,80,X_Delta+30,100);
   CustomColor_Button3_1.ColorBackground(CustomColor3_1);
   CustomColor_Button3_1.ColorBorder(clrBlack);
   ObjectSetInteger(0,"CustomColor_Button3_1",OBJPROP_ZORDER,100);
   ColorName = StringSubstr(ColorToString(CustomColor3_1,true),3);
   ObjectSetString(ChartID(),"CustomColor_Button3_1",OBJPROP_TOOLTIP,ColorName);
   ColorButtonsArray[8] = CustomColor_Button3_1;

   CustomColor_Button3_2.Create(0,"CustomColor_Button3_2",0,X_Delta+35,80,X_Delta+65,100);
   CustomColor_Button3_2.ColorBackground(CustomColor3_2);
   CustomColor_Button3_2.ColorBorder(clrBlack);
   ObjectSetInteger(0,"CustomColor_Button3_2",OBJPROP_ZORDER,100);
   ColorName = StringSubstr(ColorToString(CustomColor3_2,true),3);
   ObjectSetString(ChartID(),"CustomColor_Button3_2",OBJPROP_TOOLTIP,ColorName);
   ColorButtonsArray[9] = CustomColor_Button3_2;

   CustomColor_Button3_3.Create(0,"CustomColor_Button3_3",0,X_Delta+70,80,X_Delta+100,100);
   CustomColor_Button3_3.ColorBackground(CustomColor3_3);
   CustomColor_Button3_3.ColorBorder(clrBlack);
   ObjectSetInteger(0,"CustomColor_Button3_3",OBJPROP_ZORDER,100);
   ColorName = StringSubstr(ColorToString(CustomColor3_3,true),3);
   ObjectSetString(ChartID(),"CustomColor_Button3_3",OBJPROP_TOOLTIP,ColorName);
   ColorButtonsArray[10] = CustomColor_Button3_3;
   
   CustomColor_Button3_4.Create(0,"CustomColor_Button3_4",0,X_Delta+105,80,X_Delta+135,100);
   CustomColor_Button3_4.ColorBackground(CustomColor3_4);
   CustomColor_Button3_4.ColorBorder(clrBlack);
   ObjectSetInteger(0,"CustomColor_Button3_4",OBJPROP_ZORDER,100);
   ColorName = StringSubstr(ColorToString(CustomColor3_4,true),3);
   ObjectSetString(ChartID(),"CustomColor_Button3_4",OBJPROP_TOOLTIP,ColorName);
   ColorButtonsArray[11] = CustomColor_Button3_4;


//===========
}

void InitUIControlButtons() {
   Minimize_Button.Create(0,"Minimize_Button",0,X_Delta+186,5,X_Delta+205,25);
   Minimize_Button.Text("_");
   Minimize_Button.Font("Calibri");
   Minimize_Button.FontSize(11);
   Minimize_Button.Color(clrBlack);
   Minimize_Button.ColorBackground(clrKhaki);
   Minimize_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"Minimize_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"Minimize_Button",OBJPROP_TOOLTIP,"Hide/show all buttons (0)");

   WL_InWL_High_Button.Create(0,"WL_InWL_High_Button",0,X_Delta+140,30,X_Delta+171,50);
   WL_InWL_High_Button.Text("HIGH");
   WL_InWL_High_Button.Font("Calibri");
   WL_InWL_High_Button.FontSize(10);
   WL_InWL_High_Button.Color(clrBlack);
   WL_InWL_High_Button.ColorBackground(clrKhaki);
   WL_InWL_High_Button.ColorBorder(clrBlack);
   WL_InWL_High_Button.Pressed(false);   
   ObjectSetInteger(0,"WL_InWL_High_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"WL_InWL_High_Button",OBJPROP_TOOLTIP,"Add to Watch List with HIGH probability");
   if (IsChartInWL(ChartID()) && ProbabilityInWatchList(ChartID()) == HighProbability) HighlightButton(WL_InWL_High_Button,true); else HighlightButton(WL_InWL_High_Button,false);
   

   WL_InWL_Low_Button.Create(0,"WL_InWL_Low_Button",0,X_Delta+173,30,X_Delta+205,50);
   WL_InWL_Low_Button.Text("LOW");
   WL_InWL_Low_Button.Font("Calibri");
   WL_InWL_Low_Button.FontSize(10);
   WL_InWL_Low_Button.Color(clrBlack);
   WL_InWL_Low_Button.ColorBackground(clrKhaki);
   WL_InWL_Low_Button.ColorBorder(clrBlack);
   WL_InWL_Low_Button.Pressed(false);   
   ObjectSetInteger(0,"WL_InWL_Low_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"WL_InWL_Low_Button",OBJPROP_TOOLTIP,"Add to Watch List with LOW probability");
   if (IsChartInWL(ChartID()) && ProbabilityInWatchList(ChartID()) == LowProbability) HighlightButton(WL_InWL_Low_Button,true); else HighlightButton(WL_InWL_Low_Button,false);


   ClearWL_Button.Create(0,"ClearWL_Button",0,X_Delta+163,5,X_Delta+184,25);
   ClearWL_Button.Text("C");
   ClearWL_Button.Font("Calibri");
   ClearWL_Button.FontSize(11);
   ClearWL_Button.Color(clrBlack);
   ClearWL_Button.ColorBackground(clrKhaki);
   ClearWL_Button.ColorBorder(clrBlack);
   ClearWL_Button.Pressed(false);   
   ObjectSetInteger(0,"ClearWL_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"ClearWL_Button",OBJPROP_TOOLTIP,"Clear Watch List. Press 3 times");

   SoundControl_Button.Create(0,"SoundControl_Button",0,0,0,21,20);
   SoundControl_Button.Text("S");
   SoundControl_Button.Font("Calibri");
   SoundControl_Button.FontSize(11);
   SoundControl_Button.Color(clrBlack);
   SoundControl_Button.ColorBackground(clrKhaki);
   SoundControl_Button.ColorBorder(clrBlack);
   SoundControl_Button.Pressed(false);
   ObjectSetInteger(0,"SoundControl_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"SoundControl_Button",OBJPROP_TOOLTIP,"Sound On/Off");
   
   PushControl_Button.Create(0,"PushControl_Button",0,0,0,21,20);
   PushControl_Button.Text("P");
   PushControl_Button.Font("Calibri");
   PushControl_Button.FontSize(11);
   PushControl_Button.Color(clrBlack);
   PushControl_Button.ColorBackground(clrKhaki);
   PushControl_Button.ColorBorder(clrBlack);
   PushControl_Button.Pressed(false);
   ObjectSetInteger(0,"PushControl_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"PushControl_Button",OBJPROP_TOOLTIP,"Send Push-Notifications");
   
}


void InitLineControlButtons() {

   SetSolidLine_Button.Create(0,"SetSolidLine_Button",0,X_Delta+0,105,X_Delta+30,125);
   SetSolidLine_Button.Text("-");
   SetSolidLine_Button.Font("Symbol");
   SetSolidLine_Button.FontSize(10);
   SetSolidLine_Button.Color(clrBlack);
   SetSolidLine_Button.ColorBackground(clrKhaki);
   SetSolidLine_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"SetSolidLine_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"SetSolidLine_Button",OBJPROP_TOOLTIP,"Solid Line (W)");
   
   SetDashedLine_Button.Create(0,"SetDashedLine_Button",0,X_Delta+35,105,X_Delta+65,125);
   SetDashedLine_Button.Text(" - - ");
   SetDashedLine_Button.Font("Calibri");
   SetDashedLine_Button.FontSize(10);
   SetDashedLine_Button.Color(clrBlack);
   SetDashedLine_Button.ColorBackground(clrKhaki);
   SetDashedLine_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"SetDashedLine_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"SetDashedLine_Button",OBJPROP_TOOLTIP,"Dashed Line (E)");

   
   SetDotLine_Button.Create(0,"SetDotLine_Button",0,X_Delta+105,105,X_Delta+135,125);
   SetDotLine_Button.Text("---");
   SetDotLine_Button.Font("Calibri");
   SetDotLine_Button.FontSize(10);
   SetDotLine_Button.Color(clrBlack);
   SetDotLine_Button.ColorBackground(clrKhaki);
   SetDotLine_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"SetDotLine_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"SetDotLine_Button",OBJPROP_TOOLTIP,"Dotted Line (T)");
   
   SetThickLine_Button.Create(0,"SetThickLine_Button",0,X_Delta+0,130,X_Delta+30,150);
   SetThickLine_Button.Text("B");
   SetThickLine_Button.Font("Calibri Bold");
   SetThickLine_Button.FontSize(12);
   SetThickLine_Button.Color(clrBlack);
   SetThickLine_Button.ColorBackground(clrKhaki);
   SetThickLine_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"SetThickLine_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"SetThickLine_Button",OBJPROP_TOOLTIP,"Bold Line (Q)");
 
   FiboReset_Button.Create(0,"FiboReset_Button",0,X_Delta+35,130,X_Delta+65,150);
   FiboReset_Button.Text("F D");
   FiboReset_Button.Font("Calibri");
   FiboReset_Button.FontSize(11);
   FiboReset_Button.Color(clrBlack);
   FiboReset_Button.ColorBackground(clrKhaki);
   FiboReset_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"FiboReset_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"FiboReset_Button",OBJPROP_TOOLTIP,"Reset All Fibo Levels");

}

void InitOtherButtons() {

   FixChartScale_Button.Create(0,"FixChartScale_Button",0,0,0,30,20);
   FixChartScale_Button.Text("FIX");
   FixChartScale_Button.Font("Calibri");
   FixChartScale_Button.FontSize(11);
   FixChartScale_Button.Color(clrBlack);
   FixChartScale_Button.ColorBackground(clrKhaki);
   FixChartScale_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"FixChartScale_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"FixChartScale_Button",OBJPROP_TOOLTIP,"Fix Chart Scale (Tab)");
   
   UnselectAll_Button.Create(0,"UnselectAll_Button",0,X_Delta+70,130,X_Delta+100,150);
   UnselectAll_Button.Text("Un");
   UnselectAll_Button.Font("Calibri");
   UnselectAll_Button.FontSize(11);
   UnselectAll_Button.Color(clrBlack);
   UnselectAll_Button.ColorBackground(clrKhaki);
   UnselectAll_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"UnselectAll_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"UnselectAll_Button",OBJPROP_TOOLTIP,"Unselect All (ESC)");
 
   SaveTemplate_Button.Create(0,"SaveTemplate_Button",0,X_Delta+105,130,X_Delta+135,150);
   SaveTemplate_Button.Text("<");
   SaveTemplate_Button.Font("Wingdings");
   SaveTemplate_Button.FontSize(13);
   SaveTemplate_Button.Color(clrBlack);
   SaveTemplate_Button.ColorBackground(clrKhaki);
   SaveTemplate_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"SaveTemplate_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"SaveTemplate_Button",OBJPROP_TOOLTIP,"Save Template and Make Screenshot");   

   AutoBFTools_Button.Create(0,"AutoBFTools_Button",0,X_Delta+140,5,X_Delta+161,25);
   AutoBFTools_Button.Text("A");
   AutoBFTools_Button.Font("Calibri");
   AutoBFTools_Button.FontSize(10);
   AutoBFTools_Button.Color(clrBlack);
   AutoBFTools_Button.ColorBackground(clrKhaki);
   AutoBFTools_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"AutoBFTools_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"AutoBFTools_Button",OBJPROP_TOOLTIP,"Chart auto-updates On/Off");

   FloatingLabel.Create(0,"FloatingLabel",0,0,0,0,0);
   FloatingLabel.Font("Calibri");
   FloatingLabel.FontSize(10);
   FloatingLabel.Color(clrGray);
   FloatingLabel.Hide();   
   
   // **************** creatig RightLowerInfo_Label****************************************
   string RightLowerInfoName = "RightLowerInfo";
   RightLowerInfo_Label.Create(0,RightLowerInfoName,0,0,0,0,0);
   ObjectSetInteger(ChartID(),RightLowerInfo_Label.Name(),OBJPROP_ANCHOR,ANCHOR_RIGHT_LOWER);
   ObjectSetInteger(0,RightLowerInfoName,OBJPROP_SELECTABLE,false);
   RightLowerInfo_Label.Color(clrGray);
   RightLowerInfo_Label.Font("Arial Black");
   RightLowerInfo_Label.FontSize(8);
   ObjectSetString(ChartID(),RightLowerInfo_Label.Name(),OBJPROP_TOOLTIP,"Server Time");
   ObjectSetInteger(ChartID(),RightLowerInfo_Label.Name(),OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
   
   string RightLowerInfoSymbolName = "RightLowerInfoSymbol";
   RightLowerInfoSymbol_Label.Create(0,RightLowerInfoSymbolName,0,0,0,0,0);
   ObjectSetInteger(ChartID(),RightLowerInfoSymbol_Label.Name(),OBJPROP_ANCHOR,ANCHOR_RIGHT_LOWER);
   ObjectSetInteger(0,RightLowerInfoSymbolName,OBJPROP_SELECTABLE,false);
   RightLowerInfoSymbol_Label.Color(clrGray);
   RightLowerInfoSymbol_Label.Font("Arial Black");
   RightLowerInfoSymbol_Label.FontSize(14);
   ObjectSetString(ChartID(),RightLowerInfoSymbol_Label.Name(),OBJPROP_TOOLTIP,"Current Symbol and Period");
   ObjectSetInteger(ChartID(),RightLowerInfoSymbol_Label.Name(),OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
   // **** END OF CREATING OF RightLowerInfo ******************************************

}

void InitMetaKeyPad() {
   Crosshair_Button.Create(0,"Crosshair_Button",0,X_Delta+0,0,X_Delta+30,20);
   Crosshair_Button.Text(CharToString(177));
   Crosshair_Button.Font("Wingdings");
   Crosshair_Button.FontSize(16);
   Crosshair_Button.Color(clrBlack);
   Crosshair_Button.ColorBackground(clrKhaki);
   Crosshair_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"Crosshair_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"Crosshair_Button",OBJPROP_TOOLTIP,"Cross-hair (Ctrl+F)");   
   
   DeleteObject_Button.Create(0,"DeleteObject_Button",0,X_Delta+0,0,X_Delta+30,20);
   DeleteObject_Button.Text("X");
   DeleteObject_Button.Font("Calibri");
   DeleteObject_Button.FontSize(13);
   DeleteObject_Button.Color(clrBlack);
   DeleteObject_Button.ColorBackground(clrKhaki);
   DeleteObject_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"DeleteObject_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"DeleteObject_Button",OBJPROP_TOOLTIP,"Delete Selected Objects"); 
   
   ChartNavigateLeft_Button.Create(0,"ChartNavigateLeft_Button",0,X_Delta+0,0,X_Delta+30,20);
   ChartNavigateLeft_Button.Text("<");
   ChartNavigateLeft_Button.Font("Calibri");
   ChartNavigateLeft_Button.FontSize(13);
   ChartNavigateLeft_Button.Color(clrBlack);
   ChartNavigateLeft_Button.ColorBackground(clrKhaki);
   ChartNavigateLeft_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"ChartNavigateLeft_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"ChartNavigateLeft_Button",OBJPROP_TOOLTIP,"Prev Chart in Terminal (A)"); 

   ChartNavigateRight_Button.Create(0,"ChartNavigateRight_Button",0,X_Delta+0,0,X_Delta+30,20);
   ChartNavigateRight_Button.Text(">");
   ChartNavigateRight_Button.Font("Calibri");
   ChartNavigateRight_Button.FontSize(13);
   ChartNavigateRight_Button.Color(clrBlack);
   ChartNavigateRight_Button.ColorBackground(clrKhaki);
   ChartNavigateRight_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"ChartNavigateRight_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"ChartNavigateRight_Button",OBJPROP_TOOLTIP,"Next Chart in Terminal (S)"); 

   MakeTrendHorizontalAndExtend_Button.Create(0,"MakeTrendHorizontalAndExtend_Button",0,X_Delta+0,0,X_Delta+30,20);
   MakeTrendHorizontalAndExtend_Button.Text("H");
   MakeTrendHorizontalAndExtend_Button.Font("Calibri");
   MakeTrendHorizontalAndExtend_Button.FontSize(13);
   MakeTrendHorizontalAndExtend_Button.Color(clrBlack);
   MakeTrendHorizontalAndExtend_Button.ColorBackground(clrKhaki);
   MakeTrendHorizontalAndExtend_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"MakeTrendHorizontalAndExtend_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"MakeTrendHorizontalAndExtend_Button",OBJPROP_TOOLTIP,"Make Trend Horizontal (click once); Prolong Level (click twice)"); 


   ToggleTrendRay_Button.Create(0,"ToggleTrendRay_Button",0,X_Delta+0,0,X_Delta+30,20);
   ToggleTrendRay_Button.Text("Y");
   ToggleTrendRay_Button.Font("Calibri");
   ToggleTrendRay_Button.FontSize(13);
   ToggleTrendRay_Button.Color(clrBlack);
   ToggleTrendRay_Button.ColorBackground(clrKhaki);
   ToggleTrendRay_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"ToggleTrendRay_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"ToggleTrendRay_Button",OBJPROP_TOOLTIP,"Trend Ray On/Off"); 

   FixVertScale_Button.Create(0,"FixVertScale_Button",0,X_Delta+0,0,X_Delta+30,20);
   FixVertScale_Button.Text("F");
   FixVertScale_Button.Font("Calibri");
   FixVertScale_Button.FontSize(13);
   FixVertScale_Button.Color(clrBlack);
   FixVertScale_Button.ColorBackground(clrKhaki);
   FixVertScale_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"FixVertScale_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"FixVertScale_Button",OBJPROP_TOOLTIP,"Fix Chart Scale");

   ShowHideScenarios_Button.Create(0,"ShowHideScenarios_Button",0,X_Delta+0,0,X_Delta+30,20);
   ShowHideScenarios_Button.Text("S");
   ShowHideScenarios_Button.Font("Calibri");
   ShowHideScenarios_Button.FontSize(13);
   ShowHideScenarios_Button.Color(clrBlack);
   ShowHideScenarios_Button.ColorBackground(clrKhaki);
   ShowHideScenarios_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"ShowHideScenarios_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"ShowHideScenarios_Button",OBJPROP_TOOLTIP,"Show/Hide Scenarios"); 

   HideShowAllObjectsExcLevels_Button.Create(0,"HideShowAllObjectsExcLevels_Button",0,X_Delta+0,0,X_Delta+30,20);
   HideShowAllObjectsExcLevels_Button.Text(".");
   HideShowAllObjectsExcLevels_Button.Font("Calibri");
   HideShowAllObjectsExcLevels_Button.FontSize(13);
   HideShowAllObjectsExcLevels_Button.Color(clrBlack);
   HideShowAllObjectsExcLevels_Button.ColorBackground(clrKhaki);
   HideShowAllObjectsExcLevels_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"HideShowAllObjectsExcLevels_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"HideShowAllObjectsExcLevels_Button",OBJPROP_TOOLTIP,"Hide/Show All Except Levels"); 

   CopyObject_Button.Create(0,"CopyObject_Button",0,X_Delta+0,0,X_Delta+30,20);
   CopyObject_Button.Text(CharToString(52));
   CopyObject_Button.Font("Wingdings");
   CopyObject_Button.FontSize(13);
   CopyObject_Button.Color(clrBlack);
   CopyObject_Button.ColorBackground(clrKhaki);
   CopyObject_Button.ColorBorder(clrBlack);
   ObjectSetInteger(0,"CopyObject_Button",OBJPROP_ZORDER,100);
   ObjectSetString(ChartID(),"CopyObject_Button",OBJPROP_TOOLTIP,"Copy Single Selected Object"); 
   
}





void InitPrevNextButtons() {
      WL_Prev.Create(0,"WL_Prev",0,X_Delta+0,180,X_Delta+65,200);
      WL_Prev.Font("Calibri");
      WL_Prev.Text("<<<");
      WL_Prev.FontSize(10);
      WL_Prev.Color(clrBlack);
      WL_Prev.ColorBackground(clrLightGray);
      WL_Prev.ColorBorder(clrBlack); 
      ObjectSetInteger(0,"WL_Prev",OBJPROP_ZORDER,100); 
      ObjectSetString(ChartID(),"WL_Prev",OBJPROP_TOOLTIP,"Prev Chart in Watch List (Left)"); 

      WL_Next.Create(0,"WL_Next",0,X_Delta+70,180,X_Delta+135,200);
      WL_Next.Font("Calibri");
      WL_Next.Text(">>>");
      WL_Next.FontSize(10);
      WL_Next.Color(clrBlack);
      WL_Next.ColorBackground(clrLightGray);
      WL_Next.ColorBorder(clrBlack);  
      ObjectSetInteger(0,"WL_Next",OBJPROP_ZORDER,100);
      ObjectSetString(ChartID(),"WL_Next",OBJPROP_TOOLTIP,"Next Chart in Watch List (Right)");
}

void InitWatchListButtons() {

   //=========== Watch List Buttons =====================
      WL1_Button.Create(0,"WL1_Button",0,X_Delta+0,155,X_Delta+21,175);
      WL1_Button.Hide();
      WL1_Button.Text("1");
      WL1_Button.Font("Calibri");
      WL1_Button.FontSize(12);
      WL1_Button.Color(clrBlack);
      WL1_Button.ColorBackground(clrLightGray);
      WL1_Button.ColorBorder(clrBlack);
      ObjectSetInteger(0,"WL1_Button",OBJPROP_ZORDER,100);
      ObjectSetString(ChartID(),"WL1_Button",OBJPROP_TOOLTIP,"Check Signal Upon Closure of Current Bar");
 
      WL2_Button.Create(0,"WL2_Button",0,X_Delta+25,155,X_Delta+44,175);
      WL2_Button.Hide();
      WL2_Button.Text("2");
      WL2_Button.Font("Calibri");
      WL2_Button.FontSize(12);
      WL2_Button.Color(clrBlack);
      WL2_Button.ColorBackground(clrLightGray);
      WL2_Button.ColorBorder(clrBlack);
      ObjectSetInteger(0,"WL2_Button",OBJPROP_ZORDER,100);
      ObjectSetString(ChartID(),"WL2_Button",OBJPROP_TOOLTIP,"Upon Closure of Next Bar");
      
      WL3_Button.Create(0,"WL3_Button",0,X_Delta+48,155,X_Delta+67,175);
      WL3_Button.Hide();
      WL3_Button.Text("3");
      WL3_Button.Font("Calibri");
      WL3_Button.FontSize(12);
      WL3_Button.Color(clrBlack);
      WL3_Button.ColorBackground(clrLightGray);
      WL3_Button.ColorBorder(clrBlack);
      ObjectSetInteger(0,"WL3_Button",OBJPROP_ZORDER,100);
      ObjectSetString(ChartID(),"WL3_Button",OBJPROP_TOOLTIP,"Upon Closure of 3rd Bar");
 
      WL4_Button.Create(0,"WL4_Button",0,X_Delta+71,155,X_Delta+90,175);
      WL4_Button.Hide();
      WL4_Button.Text("4");
      WL4_Button.Font("Calibri");
      WL4_Button.FontSize(12);
      WL4_Button.Color(clrBlack);
      WL4_Button.ColorBackground(clrLightGray);
      WL4_Button.ColorBorder(clrBlack);
      ObjectSetInteger(0,"WL4_Button",OBJPROP_ZORDER,100);
      ObjectSetString(ChartID(),"WL4_Button",OBJPROP_TOOLTIP,"Upon Closure of 4th Bar");

      WL5_Button.Create(0,"WL5_Button",0,X_Delta+94,155,X_Delta+115,175);
      WL5_Button.Hide();
      WL5_Button.Text("5");
      WL5_Button.Font("Calibri");
      WL5_Button.FontSize(12);
      WL5_Button.Color(clrBlack);
      WL5_Button.ColorBackground(clrLightGray);
      WL5_Button.ColorBorder(clrBlack);
      ObjectSetInteger(0,"WL5_Button",OBJPROP_ZORDER,100);
      ObjectSetString(ChartID(),"WL5_Button",OBJPROP_TOOLTIP,"Upon Closure of 5th Bar");

      WLX_Button.Create(0,"WLX_Button",0,X_Delta+119,155,X_Delta+135,175);
      WLX_Button.Hide();
      WLX_Button.Text("");
      WLX_Button.Font("Calibri Bold");
      WLX_Button.FontSize(11);
      WLX_Button.Color(clrBlack);
      WLX_Button.ColorBackground(clrLightGray);
      WLX_Button.ColorBorder(clrBlack);
      ObjectSetInteger(0,"WLX_Button",OBJPROP_ZORDER,100);
      ObjectSetString(ChartID(),"WLX_Button",OBJPROP_TOOLTIP,"Do Not Check Chart Today");

      if (S_Version || !InWatchList || ObjectsHidden) {
         //Print(__FUNCTION__ + ": hiding 6 WL buttons");
         WL1_Button.Hide();
         WL2_Button.Hide();
         WL3_Button.Hide();
         WL4_Button.Hide();
         WL5_Button.Hide();
         WLX_Button.Hide();
      }
      ChartRedraw();
}


void InitCandleTimer() {
   // Init timer shown next to price during last 10 min (last 3 min for S-Version) of each hour
   ObjectCreateMQL4("CandleClosingTimeRemaining",OBJ_TEXT,0,0,0);
   ObjectSetInteger(0,"CandleClosingTimeRemaining",OBJPROP_ANCHOR,ANCHOR_LEFT_UPPER);
   ObjectSetInteger(0,"CandleClosingTimeRemaining",OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,"CandleClosingTimeRemaining",OBJPROP_COLOR,clrBlack);
   ObjectSetString(ChartID(),"CandleClosingTimeRemaining",OBJPROP_TOOLTIP,"Время до закрытия свечи");
   ObjectSetInteger(0,"CandleClosingTimeRemaining",OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);  
   // ************************************************************************************************
}


void InitWatchListPairButtons() {
      // Pair buttons of the watch list ============================== 
      //
      int WatchListButtonRightX = 205;
      int TradeDirLabelRightX = 219;
      
      int TradeDirFontSize = 11;
      string TradeDirFont = "Wingdings";
      color TradeDirFontColor = clrBlack;
      
      
      TradeDir_WL_Pair1_Label.Create(0,"TradeDir_WL_Pair1_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair1_Label.Create(0,"TradeInfo_WL_Pair1_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);
      //ObjectSetInteger(0,"TradeDir_WL_Pair1_Label",OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);

      TradeDir_WL_Pair2_Label.Create(0,"TradeDir_WL_Pair2_Label",0,X_Delta+205,82+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair2_Label.Create(0,"TradeInfo_WL_Pair2_Label",0,X_Delta+217,82+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);
      
      TradeDir_WL_Pair3_Label.Create(0,"TradeDir_WL_Pair3_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair3_Label.Create(0,"TradeInfo_WL_Pair3_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);
      
      TradeDir_WL_Pair4_Label.Create(0,"TradeDir_WL_Pair4_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair4_Label.Create(0,"TradeInfo_WL_Pair4_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);

      TradeDir_WL_Pair5_Label.Create(0,"TradeDir_WL_Pair5_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair5_Label.Create(0,"TradeInfo_WL_Pair5_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);

      TradeDir_WL_Pair6_Label.Create(0,"TradeDir_WL_Pair6_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair6_Label.Create(0,"TradeInfo_WL_Pair6_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);

      TradeDir_WL_Pair7_Label.Create(0,"TradeDir_WL_Pair7_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair7_Label.Create(0,"TradeInfo_WL_Pair7_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);
      
      TradeDir_WL_Pair8_Label.Create(0,"TradeDir_WL_Pair8_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair8_Label.Create(0,"TradeInfo_WL_Pair8_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);

      TradeDir_WL_Pair9_Label.Create(0,"TradeDir_WL_Pair9_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair9_Label.Create(0,"TradeInfo_WL_Pair9_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);
      
      TradeDir_WL_Pair10_Label.Create(0,"TradeDir_WL_Pair10_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair10_Label.Create(0,"TradeInfo_WL_Pair10_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);
      
      TradeDir_WL_Pair11_Label.Create(0,"TradeDir_WL_Pair11_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair11_Label.Create(0,"TradeInfo_WL_Pair11_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);
      
      TradeDir_WL_Pair12_Label.Create(0,"TradeDir_WL_Pair12_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair12_Label.Create(0,"TradeInfo_WL_Pair12_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);
      
      TradeDir_WL_Pair13_Label.Create(0,"TradeDir_WL_Pair13_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair13_Label.Create(0,"TradeInfo_WL_Pair13_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);
      
      TradeDir_WL_Pair14_Label.Create(0,"TradeDir_WL_Pair14_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair14_Label.Create(0,"TradeInfo_WL_Pair14_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);
      
      TradeDir_WL_Pair15_Label.Create(0,"TradeDir_WL_Pair15_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair15_Label.Create(0,"TradeInfo_WL_Pair15_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);
      
      TradeDir_WL_Pair16_Label.Create(0,"TradeDir_WL_Pair16_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair16_Label.Create(0,"TradeInfo_WL_Pair16_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);
      
      TradeDir_WL_Pair17_Label.Create(0,"TradeDir_WL_Pair17_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair17_Label.Create(0,"TradeInfo_WL_Pair17_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);
      
      TradeDir_WL_Pair18_Label.Create(0,"TradeDir_WL_Pair18_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair18_Label.Create(0,"TradeInfo_WL_Pair18_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);
      
      TradeDir_WL_Pair19_Label.Create(0,"TradeDir_WL_Pair19_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair19_Label.Create(0,"TradeInfo_WL_Pair19_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);
      
      TradeDir_WL_Pair20_Label.Create(0,"TradeDir_WL_Pair20_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair20_Label.Create(0,"TradeInfo_WL_Pair20_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);
      
      TradeDir_WL_Pair21_Label.Create(0,"TradeDir_WL_Pair21_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair21_Label.Create(0,"TradeInfo_WL_Pair21_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);
      
      TradeDir_WL_Pair22_Label.Create(0,"TradeDir_WL_Pair22_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair22_Label.Create(0,"TradeInfo_WL_Pair22_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);
      
      TradeDir_WL_Pair23_Label.Create(0,"TradeDir_WL_Pair23_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair23_Label.Create(0,"TradeInfo_WL_Pair23_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);
      
      TradeDir_WL_Pair24_Label.Create(0,"TradeDir_WL_Pair24_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair24_Label.Create(0,"TradeInfo_WL_Pair24_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);
      
      TradeDir_WL_Pair25_Label.Create(0,"TradeDir_WL_Pair25_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair25_Label.Create(0,"TradeInfo_WL_Pair25_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);
      
      TradeDir_WL_Pair26_Label.Create(0,"TradeDir_WL_Pair26_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair26_Label.Create(0,"TradeInfo_WL_Pair26_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);
      
      TradeDir_WL_Pair27_Label.Create(0,"TradeDir_WL_Pair27_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair27_Label.Create(0,"TradeInfo_WL_Pair27_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);
      
      TradeDir_WL_Pair28_Label.Create(0,"TradeDir_WL_Pair28_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair28_Label.Create(0,"TradeInfo_WL_Pair28_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);
      
      TradeDir_WL_Pair29_Label.Create(0,"TradeDir_WL_Pair29_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair29_Label.Create(0,"TradeInfo_WL_Pair29_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);
      
      TradeDir_WL_Pair30_Label.Create(0,"TradeDir_WL_Pair30_Label",0,X_Delta+205,59+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);      
      TradeInfo_WL_Pair30_Label.Create(0,"TradeInfo_WL_Pair30_Label",0,X_Delta+217,57+WatchListButtonsYShift,X_Delta+TradeDirLabelRightX,10+WatchListButtonsYShift);
      
      
      // =========== *************** =============

      // Watch List Button 1
      WL_Pair1.Create(0,"WL_Pair1",0,X_Delta+140,55+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,75+WatchListButtonsYShift);
      WL_Pair1.Font("Calibri");
      WL_Pair1.FontSize(10);
      WL_Pair1.Color(clrBlack);
      WL_Pair1.ColorBackground(clrLightGray);
      WL_Pair1.ColorBorder(clrBlack);
      ObjectSetInteger(0,"WL_Pair1",OBJPROP_ZORDER,100);

      WL_Pair2.Create(0,"WL_Pair2",0,X_Delta+140,80+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,100+WatchListButtonsYShift);
      WL_Pair2.Font("Calibri");
      WL_Pair2.FontSize(10);
      WL_Pair2.Color(clrBlack);
      WL_Pair2.ColorBackground(clrLightGray);
      WL_Pair2.ColorBorder(clrBlack);   
      ObjectSetInteger(0,"WL_Pair2",OBJPROP_ZORDER,100);
      
      WL_Pair3.Create(0,"WL_Pair3",0,X_Delta+140,105+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,125+WatchListButtonsYShift);
      WL_Pair3.Font("Calibri");
      WL_Pair3.FontSize(10);
      WL_Pair3.Color(clrBlack);
      WL_Pair3.ColorBackground(clrLightGray);
      WL_Pair3.ColorBorder(clrBlack);    
      ObjectSetInteger(0,"WL_Pair3",OBJPROP_ZORDER,100);

      WL_Pair4.Create(0,"WL_Pair4",0,X_Delta+140,130+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,150+WatchListButtonsYShift);
      WL_Pair4.Font("Calibri");
      WL_Pair4.FontSize(10);
      WL_Pair4.Color(clrBlack);
      WL_Pair4.ColorBackground(clrLightGray);
      WL_Pair4.ColorBorder(clrBlack);     
      ObjectSetInteger(0,"WL_Pair4",OBJPROP_ZORDER,100);

      WL_Pair5.Create(0,"WL_Pair5",0,X_Delta+140,155+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,175+WatchListButtonsYShift);
      WL_Pair5.Font("Calibri");
      WL_Pair5.FontSize(10);
      WL_Pair5.Color(clrBlack);
      WL_Pair5.ColorBackground(clrLightGray);
      WL_Pair5.ColorBorder(clrBlack);   
      ObjectSetInteger(0,"WL_Pair5",OBJPROP_ZORDER,100);
 
      WL_Pair6.Create(0,"WL_Pair6",0,X_Delta+140,180+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,200+WatchListButtonsYShift);
      WL_Pair6.Font("Calibri");
      WL_Pair6.FontSize(10);
      WL_Pair6.Color(clrBlack);
      WL_Pair6.ColorBackground(clrLightGray);
      WL_Pair6.ColorBorder(clrBlack);    
      ObjectSetInteger(0,"WL_Pair6",OBJPROP_ZORDER,100);

      WL_Pair7.Create(0,"WL_Pair7",0,X_Delta+140,205+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,225+WatchListButtonsYShift);
      WL_Pair7.Font("Calibri");
      WL_Pair7.FontSize(10);
      WL_Pair7.Color(clrBlack);
      WL_Pair7.ColorBackground(clrLightGray);
      WL_Pair7.ColorBorder(clrBlack); 
      ObjectSetInteger(0,"WL_Pair7",OBJPROP_ZORDER,100);  

      WL_Pair8.Create(0,"WL_Pair8",0,X_Delta+140,230+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,250+WatchListButtonsYShift);
      WL_Pair8.Font("Calibri");
      WL_Pair8.FontSize(10);
      WL_Pair8.Color(clrBlack);
      WL_Pair8.ColorBackground(clrLightGray);
      WL_Pair8.ColorBorder(clrBlack);    
      ObjectSetInteger(0,"WL_Pair8",OBJPROP_ZORDER,100);
 
      WL_Pair9.Create(0,"WL_Pair9",0,X_Delta+140,255+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,275+WatchListButtonsYShift);
      WL_Pair9.Font("Calibri");
      WL_Pair9.FontSize(10);
      WL_Pair9.Color(clrBlack);
      WL_Pair9.ColorBackground(clrLightGray);
      WL_Pair9.ColorBorder(clrBlack);   
      ObjectSetInteger(0,"WL_Pair9",OBJPROP_ZORDER,100);
    
      WL_Pair10.Create(0,"WL_Pair10",0,X_Delta+140,280+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,300+WatchListButtonsYShift);
      WL_Pair10.Font("Calibri");
      WL_Pair10.FontSize(10);
      WL_Pair10.Color(clrBlack);
      WL_Pair10.ColorBackground(clrLightGray);
      WL_Pair10.ColorBorder(clrBlack);
      ObjectSetInteger(0,"WL_Pair10",OBJPROP_ZORDER,100);
      
      
      WL_Pair11.Create(0,"WL_Pair11",0,X_Delta+140,305+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,325+WatchListButtonsYShift);
      WL_Pair11.Font("Calibri");
      WL_Pair11.FontSize(10);
      WL_Pair11.Color(clrBlack);
      WL_Pair11.ColorBackground(clrLightGray);
      WL_Pair11.ColorBorder(clrBlack);
      ObjectSetInteger(0,"WL_Pair11",OBJPROP_ZORDER,100);

      WL_Pair12.Create(0,"WL_Pair12",0,X_Delta+140,330+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,350+WatchListButtonsYShift);
      WL_Pair12.Font("Calibri");
      WL_Pair12.FontSize(10);
      WL_Pair12.Color(clrBlack);
      WL_Pair12.ColorBackground(clrLightGray);
      WL_Pair12.ColorBorder(clrBlack);   
      ObjectSetInteger(0,"WL_Pair12",OBJPROP_ZORDER,100);
      
      WL_Pair13.Create(0,"WL_Pair13",0,X_Delta+140,355+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,375+WatchListButtonsYShift);
      WL_Pair13.Font("Calibri");
      WL_Pair13.FontSize(10);
      WL_Pair13.Color(clrBlack);
      WL_Pair13.ColorBackground(clrLightGray);
      WL_Pair13.ColorBorder(clrBlack);    
      ObjectSetInteger(0,"WL_Pair13",OBJPROP_ZORDER,100);

      WL_Pair14.Create(0,"WL_Pair14",0,X_Delta+140,380+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,400+WatchListButtonsYShift);
      WL_Pair14.Font("Calibri");
      WL_Pair14.FontSize(10);
      WL_Pair14.Color(clrBlack);
      WL_Pair14.ColorBackground(clrLightGray);
      WL_Pair14.ColorBorder(clrBlack);     
      ObjectSetInteger(0,"WL_Pair14",OBJPROP_ZORDER,100);

      WL_Pair15.Create(0,"WL_Pair15",0,X_Delta+140,405+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,425+WatchListButtonsYShift);
      WL_Pair15.Font("Calibri");
      WL_Pair15.FontSize(10);
      WL_Pair15.Color(clrBlack);
      WL_Pair15.ColorBackground(clrLightGray);
      WL_Pair15.ColorBorder(clrBlack);   
      ObjectSetInteger(0,"WL_Pair15",OBJPROP_ZORDER,100);
 
      WL_Pair16.Create(0,"WL_Pair16",0,X_Delta+140,430+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,450+WatchListButtonsYShift);
      WL_Pair16.Font("Calibri");
      WL_Pair16.FontSize(10);
      WL_Pair16.Color(clrBlack);
      WL_Pair16.ColorBackground(clrLightGray);
      WL_Pair16.ColorBorder(clrBlack);    
      ObjectSetInteger(0,"WL_Pair16",OBJPROP_ZORDER,100);

      WL_Pair17.Create(0,"WL_Pair17",0,X_Delta+140,455+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,475+WatchListButtonsYShift);
      WL_Pair17.Font("Calibri");
      WL_Pair17.FontSize(10);
      WL_Pair17.Color(clrBlack);
      WL_Pair17.ColorBackground(clrLightGray);
      WL_Pair17.ColorBorder(clrBlack); 
      ObjectSetInteger(0,"WL_Pair17",OBJPROP_ZORDER,100);  

      WL_Pair18.Create(0,"WL_Pair18",0,X_Delta+140,480+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,500+WatchListButtonsYShift);
      WL_Pair18.Font("Calibri");
      WL_Pair18.FontSize(10);
      WL_Pair18.Color(clrBlack);
      WL_Pair18.ColorBackground(clrLightGray);
      WL_Pair18.ColorBorder(clrBlack);    
      ObjectSetInteger(0,"WL_Pair18",OBJPROP_ZORDER,100);
 
      WL_Pair19.Create(0,"WL_Pair19",0,X_Delta+140,505+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,525+WatchListButtonsYShift);
      WL_Pair19.Font("Calibri");
      WL_Pair19.FontSize(10);
      WL_Pair19.Color(clrBlack);
      WL_Pair19.ColorBackground(clrLightGray);
      WL_Pair19.ColorBorder(clrBlack);   
      ObjectSetInteger(0,"WL_Pair19",OBJPROP_ZORDER,100);
    
      WL_Pair20.Create(0,"WL_Pair20",0,X_Delta+140,530+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,550+WatchListButtonsYShift);
      WL_Pair20.Font("Calibri");
      WL_Pair20.FontSize(10);
      WL_Pair20.Color(clrBlack);
      WL_Pair20.ColorBackground(clrLightGray);
      WL_Pair20.ColorBorder(clrBlack);
      ObjectSetInteger(0,"WL_Pair20",OBJPROP_ZORDER,100);

      WL_Pair21.Create(0,"WL_Pair21",0,X_Delta+140,555+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,575+WatchListButtonsYShift);
      WL_Pair21.Font("Calibri");
      WL_Pair21.FontSize(10);
      WL_Pair21.Color(clrBlack);
      WL_Pair21.ColorBackground(clrLightGray);
      WL_Pair21.ColorBorder(clrBlack);
      ObjectSetInteger(0,"WL_Pair21",OBJPROP_ZORDER,100);

      WL_Pair22.Create(0,"WL_Pair22",0,X_Delta+140,580+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,600+WatchListButtonsYShift);
      WL_Pair22.Font("Calibri");
      WL_Pair22.FontSize(10);
      WL_Pair22.Color(clrBlack);
      WL_Pair22.ColorBackground(clrLightGray);
      WL_Pair22.ColorBorder(clrBlack);
      ObjectSetInteger(0,"WL_Pair22",OBJPROP_ZORDER,100);
      
      WL_Pair23.Create(0,"WL_Pair23",0,X_Delta+140,605+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,625+WatchListButtonsYShift);
      WL_Pair23.Font("Calibri");
      WL_Pair23.FontSize(10);
      WL_Pair23.Color(clrBlack);
      WL_Pair23.ColorBackground(clrLightGray);
      WL_Pair23.ColorBorder(clrBlack);
      ObjectSetInteger(0,"WL_Pair23",OBJPROP_ZORDER,100);
      
      WL_Pair24.Create(0,"WL_Pair24",0,X_Delta+140,630+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,650+WatchListButtonsYShift);
      WL_Pair24.Font("Calibri");
      WL_Pair24.FontSize(10);
      WL_Pair24.Color(clrBlack);
      WL_Pair24.ColorBackground(clrLightGray);
      WL_Pair24.ColorBorder(clrBlack);
      ObjectSetInteger(0,"WL_Pair24",OBJPROP_ZORDER,100);
      
      WL_Pair25.Create(0,"WL_Pair25",0,X_Delta+140,655+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,675+WatchListButtonsYShift);
      WL_Pair25.Font("Calibri");
      WL_Pair25.FontSize(10);
      WL_Pair25.Color(clrBlack);
      WL_Pair25.ColorBackground(clrLightGray);
      WL_Pair25.ColorBorder(clrBlack);
      ObjectSetInteger(0,"WL_Pair25",OBJPROP_ZORDER,100);

      WL_Pair26.Create(0,"WL_Pair26",0,X_Delta+140,655+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,675+WatchListButtonsYShift);
      WL_Pair26.Font("Calibri");
      WL_Pair26.FontSize(10);
      WL_Pair26.Color(clrBlack);
      WL_Pair26.ColorBackground(clrLightGray);
      WL_Pair26.ColorBorder(clrBlack);
      ObjectSetInteger(0,"WL_Pair26",OBJPROP_ZORDER,100);

      WL_Pair27.Create(0,"WL_Pair27",0,X_Delta+140,655+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,675+WatchListButtonsYShift);
      WL_Pair27.Font("Calibri");
      WL_Pair27.FontSize(10);
      WL_Pair27.Color(clrBlack);
      WL_Pair27.ColorBackground(clrLightGray);
      WL_Pair27.ColorBorder(clrBlack);
      ObjectSetInteger(0,"WL_Pair27",OBJPROP_ZORDER,100);

      WL_Pair28.Create(0,"WL_Pair28",0,X_Delta+140,655+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,675+WatchListButtonsYShift);
      WL_Pair28.Font("Calibri");
      WL_Pair28.FontSize(10);
      WL_Pair28.Color(clrBlack);
      WL_Pair28.ColorBackground(clrLightGray);
      WL_Pair28.ColorBorder(clrBlack);
      ObjectSetInteger(0,"WL_Pair28",OBJPROP_ZORDER,100);

      WL_Pair29.Create(0,"WL_Pair29",0,X_Delta+140,655+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,675+WatchListButtonsYShift);
      WL_Pair29.Font("Calibri");
      WL_Pair29.FontSize(10);
      WL_Pair29.Color(clrBlack);
      WL_Pair29.ColorBackground(clrLightGray);
      WL_Pair29.ColorBorder(clrBlack);
      ObjectSetInteger(0,"WL_Pair29",OBJPROP_ZORDER,100);

      WL_Pair30.Create(0,"WL_Pair30",0,X_Delta+140,655+WatchListButtonsYShift,X_Delta+WatchListButtonRightX,675+WatchListButtonsYShift);
      WL_Pair30.Font("Calibri");
      WL_Pair30.FontSize(10);
      WL_Pair30.Color(clrBlack);
      WL_Pair30.ColorBackground(clrLightGray);
      WL_Pair30.ColorBorder(clrBlack);
      ObjectSetInteger(0,"WL_Pair30",OBJPROP_ZORDER,100);


}
    



void InitATRLabels() {

   
   TodayRange_Label.Create(0,"TodayRange_Label",  0,X_Delta-20,5, X_Delta-5,25);
   ATR5_Label.Create  (0,"ATR5_Label",  0,X_Delta-20,20, X_Delta-5,40);
   ATR14_Label.Create (0,"ATR14_Label", 0,X_Delta-20,35,X_Delta-5,55);
   ATR180_Label.Create(0,"ATR180_Label",0,X_Delta-20,50,X_Delta-5,70);
   
   TodayRange_Label.Font("Calibri");
   TodayRange_Label.FontSize(10);
   TodayRange_Label.Color(clrGray);
   ObjectSetString(0,"TodayRange_Label",OBJPROP_TOOLTIP,"Today's Range");
   
   ATR5_Label.Font("Calibri");
   ATR5_Label.FontSize(10);
   ATR5_Label.Color(clrGray);   
   ObjectSetString(0,"ATR5_Label",OBJPROP_TOOLTIP,"ATR 5 Days");
   
   ATR14_Label.Font("Calibri");
   ATR14_Label.FontSize(10);
   ATR14_Label.Color(clrGray);
   ObjectSetString(0,"ATR14_Label",OBJPROP_TOOLTIP,"ATR 14 Days");

   ATR180_Label.Font("Calibri");
   ATR180_Label.FontSize(10);
   ATR180_Label.Color(clrGray);
   ObjectSetString(0,"ATR180_Label",OBJPROP_TOOLTIP,"ATR 180 Days"); 
   
}







void DestroyAllButtons() {
   SetSolidLine_Button.Destroy();
   SetThickLine_Button.Destroy();
   SetDotLine_Button.Destroy();
   SetDashedLine_Button.Destroy();
   ObjectDelete(0,"SetLightSalmon_Button");
   ObjectDelete(0,"AutoCloseTrade_Button");
   ObjectDelete(0,"LineAClose_Button");
   ObjectDelete(0,"AutoTrade_Button");
   ObjectDelete(0,"MessageOnChartLabel");
   CustomColor_Button1_1.Destroy();
   CustomColor_Button1_2.Destroy();
   CustomColor_Button1_3.Destroy();
   CustomColor_Button1_4.Destroy();
   CustomColor_Button2_1.Destroy();
   CustomColor_Button2_2.Destroy();
   CustomColor_Button2_3.Destroy(); 
   CustomColor_Button2_4.Destroy();
   CustomColor_Button3_1.Destroy();
   CustomColor_Button3_2.Destroy();
   CustomColor_Button3_3.Destroy();
   CustomColor_Button3_4.Destroy();

   H1H4_Visibility_Button.Destroy();
   H1D1_Visibility_Button.Destroy();
   ObjectDelete(0,"H1H4_Visibility_Button");
   D1_Visibility_Button.Destroy();
   H1_Visibility_Button.Destroy();
   FixChartScale_Button.Destroy();
   UnselectAll_Button.Destroy();
   FiboReset_Button.Destroy();
   SaveTemplate_Button.Destroy();
   Minimize_Button.Destroy();
   ObjectDelete(0,"WL_UseWL_Button");
   WL_InWL_High_Button.Destroy();
   WL_InWL_Low_Button.Destroy();
   ClearWL_Button.Destroy();
   AutoBFTools_Button.Destroy();
   WL_Prev.Destroy();
   WL_Next.Destroy(); 
   
   WL1_Button.Destroy();
   WL2_Button.Destroy();
   WL3_Button.Destroy();
   WL4_Button.Destroy();
   WL5_Button.Destroy();
   WLX_Button.Destroy();
   
   WL_Pair1.Destroy();
   WL_Pair2.Destroy();
   WL_Pair3.Destroy();
   WL_Pair4.Destroy();
   WL_Pair5.Destroy();
   WL_Pair6.Destroy();
   WL_Pair7.Destroy();
   WL_Pair8.Destroy();
   WL_Pair9.Destroy();
   WL_Pair10.Destroy();
   WL_Pair11.Destroy();
   WL_Pair12.Destroy();
   WL_Pair13.Destroy();
   WL_Pair14.Destroy();
   WL_Pair15.Destroy();
   WL_Pair16.Destroy();
   WL_Pair17.Destroy();
   WL_Pair18.Destroy();
   WL_Pair19.Destroy();
   WL_Pair20.Destroy();
   WL_Pair21.Destroy();
   WL_Pair22.Destroy();
   WL_Pair23.Destroy();
   WL_Pair24.Destroy();
   WL_Pair25.Destroy();
   WL_Pair26.Destroy();
   WL_Pair27.Destroy();
   WL_Pair28.Destroy();
   WL_Pair29.Destroy();
   WL_Pair30.Destroy();
   
   SoundControl_Button.Destroy();
   PushControl_Button.Destroy();
   
   
   TodayRange_Label.Destroy();
   ATR5_Label.Destroy();
   ATR14_Label.Destroy();
   ATR180_Label.Destroy();
   //Print("All objects destroyed");

   /// destroying watch pair labels
   for(int i=0;i<ArraySize(ArrayOfTradeDirLabels);i++)  {
      ArrayOfTradeDirLabels[i].Destroy();
   }
   
   for(int i=0;i<ArraySize(ArrayOfTradeInfoLabels);i++) {
      ArrayOfTradeInfoLabels[i].Destroy();
   }  

   TradeDir_WL_Pair1_Label.Destroy();
   TradeInfo_WL_Pair1_Label.Destroy();
   TradeDir_WL_Pair2_Label.Destroy();
   TradeInfo_WL_Pair2_Label.Destroy();
   TradeDir_WL_Pair3_Label.Destroy();
   TradeInfo_WL_Pair3_Label.Destroy();
   TradeDir_WL_Pair4_Label.Destroy();
   TradeInfo_WL_Pair4_Label.Destroy();
   TradeDir_WL_Pair5_Label.Destroy();
   TradeInfo_WL_Pair5_Label.Destroy();
   TradeDir_WL_Pair6_Label.Destroy();
   TradeInfo_WL_Pair6_Label.Destroy();
   TradeDir_WL_Pair7_Label.Destroy();
   TradeInfo_WL_Pair7_Label.Destroy();
   TradeDir_WL_Pair8_Label.Destroy();
   TradeInfo_WL_Pair8_Label.Destroy();
   TradeDir_WL_Pair9_Label.Destroy();
   TradeInfo_WL_Pair9_Label.Destroy();
   TradeDir_WL_Pair10_Label.Destroy();
   TradeInfo_WL_Pair10_Label.Destroy();
   TradeDir_WL_Pair11_Label.Destroy();
   TradeInfo_WL_Pair11_Label.Destroy();
   TradeDir_WL_Pair12_Label.Destroy();
   TradeInfo_WL_Pair12_Label.Destroy();
   TradeDir_WL_Pair13_Label.Destroy();
   TradeInfo_WL_Pair13_Label.Destroy();
   TradeDir_WL_Pair14_Label.Destroy();
   TradeInfo_WL_Pair14_Label.Destroy();
   TradeDir_WL_Pair15_Label.Destroy();
   TradeInfo_WL_Pair15_Label.Destroy();
   TradeDir_WL_Pair16_Label.Destroy();
   TradeInfo_WL_Pair16_Label.Destroy();
   TradeDir_WL_Pair17_Label.Destroy();
   TradeInfo_WL_Pair17_Label.Destroy();
   TradeDir_WL_Pair18_Label.Destroy();
   TradeInfo_WL_Pair18_Label.Destroy();
   TradeDir_WL_Pair19_Label.Destroy();
   TradeInfo_WL_Pair19_Label.Destroy();
   TradeDir_WL_Pair20_Label.Destroy();
   TradeInfo_WL_Pair20_Label.Destroy();

   TradeDir_WL_Pair21_Label.Destroy();
   TradeInfo_WL_Pair21_Label.Destroy();
   TradeDir_WL_Pair22_Label.Destroy();
   TradeInfo_WL_Pair22_Label.Destroy();
   TradeDir_WL_Pair23_Label.Destroy();
   TradeInfo_WL_Pair23_Label.Destroy();
   TradeDir_WL_Pair24_Label.Destroy();
   TradeInfo_WL_Pair24_Label.Destroy();
   TradeDir_WL_Pair25_Label.Destroy();
   TradeInfo_WL_Pair25_Label.Destroy();
   TradeDir_WL_Pair26_Label.Destroy();
   TradeInfo_WL_Pair26_Label.Destroy();
   TradeDir_WL_Pair27_Label.Destroy();
   TradeInfo_WL_Pair27_Label.Destroy();
   TradeDir_WL_Pair28_Label.Destroy();
   TradeInfo_WL_Pair28_Label.Destroy();
   TradeDir_WL_Pair29_Label.Destroy();
   TradeInfo_WL_Pair29_Label.Destroy();
   TradeDir_WL_Pair30_Label.Destroy();
   TradeInfo_WL_Pair30_Label.Destroy();
   
   RightLowerInfo_Label.Destroy();
   RightLowerInfoSymbol_Label.Destroy();
  
   
   if (ShowMetaKeypad) {
      Crosshair_Button.Destroy();      
      DeleteObject_Button.Destroy();
      ChartNavigateLeft_Button.Destroy();
      ChartNavigateRight_Button.Destroy();
      MakeTrendHorizontalAndExtend_Button.Destroy();
      ToggleTrendRay_Button.Destroy();
      FixVertScale_Button.Destroy();
      ShowHideScenarios_Button.Destroy();
      HideShowAllObjectsExcLevels_Button.Destroy();
      CopyObject_Button.Destroy();
   }
}




void UpdatePositionOfAllButtons(int _EventID, int x_delta) {
   // MOVING ALL CONTROLS AS CHART RESIZES
   
   short row1_indent_top = INDENT_TOP;
   short row2_indent_top = INDENT_TOP + BUTTON_HEIGHT + CONTROLS_GAP_X;
   short row3_indent_top = row2_indent_top + BUTTON_HEIGHT + CONTROLS_GAP_X;
   short row4_indent_top = row3_indent_top + BUTTON_HEIGHT + CONTROLS_GAP_X;
   short row5_indent_top = row4_indent_top + BUTTON_HEIGHT + CONTROLS_GAP_X;
   short row6_indent_top = row5_indent_top + BUTTON_HEIGHT + CONTROLS_GAP_X;
   
   UpdateATRLabelsPosition(x_delta);
   
   // RIGHT-CORNER BUTTONS
   AutoBFTools_Button.Move(x_delta+140,5);
   SoundControl_Button.Move(x_delta+210,5);
   PushControl_Button.Move(x_delta+210,30);
   
   Minimize_Button.Move(x_delta+186,row1_indent_top);
   WL_InWL_High_Button.Move(x_delta+140,30);
   WL_InWL_Low_Button.Move(x_delta+173,30);
   ClearWL_Button.Move(x_delta+163,5);


   int selected_objects_count = SelectedObjectsCount();

   // MAIN UI BUTTONS - visibility controls   
   H1_Visibility_Button.Move(x_delta+0,row1_indent_top);
   H1H4_Visibility_Button.Move(x_delta+35,row1_indent_top);
   H1D1_Visibility_Button.Move(x_delta+70,row1_indent_top);
   D1_Visibility_Button.Move(x_delta+105,row1_indent_top);

   // COLOR CONTROLS
   CustomColor_Button1_1.Move(x_delta+0,  row2_indent_top);
   CustomColor_Button1_2.Move(x_delta+35, row2_indent_top);
   CustomColor_Button1_3.Move(x_delta+70, row2_indent_top);
   CustomColor_Button1_4.Move(x_delta+105,row2_indent_top);

   CustomColor_Button2_1.Move(x_delta+0,   row3_indent_top);
   CustomColor_Button2_2.Move(x_delta+35,  row3_indent_top);
   CustomColor_Button2_3.Move(x_delta+70,  row3_indent_top);
   CustomColor_Button2_4.Move(x_delta+105, row3_indent_top);
   
   CustomColor_Button3_1.Move(x_delta+0,   row4_indent_top);
   CustomColor_Button3_2.Move(x_delta+35,  row4_indent_top);
   CustomColor_Button3_3.Move(x_delta+70,  row4_indent_top);
   CustomColor_Button3_4.Move(x_delta+105, row4_indent_top);
   
   // LINE STYLE CONTROLS
   SetThickLine_Button.Move(x_delta+0,   row5_indent_top);
   SetSolidLine_Button.Move(x_delta+35,  row5_indent_top);
   SetDashedLine_Button.Move(x_delta+70, row5_indent_top);
   SetDotLine_Button.Move(x_delta+105,   row5_indent_top);

   if (selected_objects_count > 0) {
         ShowAllObjectsControlButtons(true);
   }
   else {
         ShowAllObjectsControlButtons(false);
         row6_indent_top = row1_indent_top;
   }

  
   
   FixChartScale_Button.Move(x_delta+0,  row6_indent_top);
   UnselectAll_Button.Move(x_delta+70,   row6_indent_top);
   FiboReset_Button.Move(x_delta+35,     row6_indent_top);
   SaveTemplate_Button.Move(x_delta+105, row6_indent_top);

  
   //----- Watch List Buttons -///////////
   if (_EventID==broadcastEventID) 
   {
      //Print("Broadcast msg received!");
      UpdateChartArrays();
      UpdateWatchPairButtons();
      //HighlightCurrentWatchPairButton();
   }
   
   short row7_indent_top = row6_indent_top + BUTTON_HEIGHT + CONTROLS_GAP_X;
   short row8_indent_top = row7_indent_top + BUTTON_HEIGHT + CONTROLS_GAP_X; 
   
    if (S_Version || !InWatchList) {
      WL_Prev.Move(x_delta + 0,  row7_indent_top);
      WL_Next.Move(x_delta + 70, row7_indent_top);
    }
    else {
      // HOUR DELAY BUTTONS
      WL1_Button.Move(x_delta+0,   row7_indent_top);
      WL2_Button.Move(x_delta+25,  row7_indent_top);
      WL3_Button.Move(x_delta+48,  row7_indent_top);
      WL4_Button.Move(x_delta+71,  row7_indent_top);
      WL5_Button.Move(x_delta+94,  row7_indent_top);
      WLX_Button.Move(x_delta+119, row7_indent_top);

      // Previos Chart / Next Chart buttons
      WL_Prev.Move(x_delta + 0,  row8_indent_top);
      WL_Next.Move(x_delta + 70, row8_indent_top);
    }
    
   
   short keypad_row1_indent_top, keypad_row2_indent_top, keypad_row3_indent_top; 
   if (S_Version || !InWatchList)
      keypad_row1_indent_top = row7_indent_top + BUTTON_HEIGHT + CONTROLS_GAP_X; 
   else 
      keypad_row1_indent_top = row8_indent_top + BUTTON_HEIGHT + CONTROLS_GAP_X; 

   keypad_row2_indent_top = keypad_row1_indent_top  + BUTTON_HEIGHT + CONTROLS_GAP_X; 
   keypad_row3_indent_top = keypad_row2_indent_top  + BUTTON_HEIGHT + CONTROLS_GAP_X; 
   
   
   if (ShowMetaKeypad) {
      int y_delta = 0;
      Crosshair_Button.Move(x_delta+0,keypad_row1_indent_top - y_delta);
      ChartNavigateLeft_Button.Move(x_delta+35,keypad_row1_indent_top - y_delta);
      ChartNavigateRight_Button.Move(x_delta+70,keypad_row1_indent_top - y_delta);
      FixVertScale_Button.Move(x_delta+105,keypad_row1_indent_top - y_delta);  
      
      if (selected_objects_count) {
         MakeTrendHorizontalAndExtend_Button.Move(x_delta+0,keypad_row2_indent_top - y_delta);
         ToggleTrendRay_Button.Move(x_delta+35,keypad_row2_indent_top - y_delta);
         CopyObject_Button.Move(x_delta+70,keypad_row2_indent_top - y_delta);
         DeleteObject_Button.Move(x_delta+105,keypad_row2_indent_top - y_delta);
         
         MakeTrendHorizontalAndExtend_Button.Show();
         ToggleTrendRay_Button.Show();
         CopyObject_Button.Show();
         DeleteObject_Button.Show();
      }
      else {
         keypad_row3_indent_top = keypad_row2_indent_top;
         
         MakeTrendHorizontalAndExtend_Button.Hide();
         ToggleTrendRay_Button.Hide();
         CopyObject_Button.Hide();
         DeleteObject_Button.Hide();
      }
      
      ShowHideScenarios_Button.Move(x_delta+0,keypad_row3_indent_top - y_delta);
      HideShowAllObjectsExcLevels_Button.Move(x_delta+35,keypad_row3_indent_top - y_delta);
      
   }
   
   // Positioning "Body Levels" button
   short row9_indent_top;
   if (ShowMetaKeypad) 
      row9_indent_top  = keypad_row3_indent_top  + BUTTON_HEIGHT + CONTROLS_GAP_X; 
   else
      row9_indent_top  = row8_indent_top  + BUTTON_HEIGHT + CONTROLS_GAP_X; 

   TradeManager.BodyLevels_Button.Move(x_delta+0, row9_indent_top);

   // Positioning "No BE..." button
   short row10_indent_top;
   if (TradeManager.Show_BodyLevels_Button())  
      row10_indent_top = row9_indent_top  + BUTTON_HEIGHT + CONTROLS_GAP_X; 
   else if (ShowMetaKeypad)
      row10_indent_top = row9_indent_top; 
   else
      row10_indent_top = row8_indent_top  + BUTTON_HEIGHT + CONTROLS_GAP_X; 


   TradeManager.TM_NoBE_Button.Move(x_delta+0, row10_indent_top);


   //short row11_indent_top = row10_indent_top + BUTTON_HEIGHT + CONTROLS_GAP_X; 






    
    
   // WATCH PAIR BUTTONS
   WL_Pair1.Move(x_delta+140,55+WatchListButtonsYShift);
   WL_Pair2.Move(x_delta+140,80+WatchListButtonsYShift);
   WL_Pair3.Move(x_delta+140,105+WatchListButtonsYShift);
   WL_Pair4.Move(x_delta+140,130+WatchListButtonsYShift);
   WL_Pair5.Move(x_delta+140,155+WatchListButtonsYShift);
   WL_Pair6.Move(x_delta+140,180+WatchListButtonsYShift);
   WL_Pair7.Move(x_delta+140,205+WatchListButtonsYShift);
   WL_Pair8.Move(x_delta+140,230+WatchListButtonsYShift);
   WL_Pair9.Move(x_delta+140,255+WatchListButtonsYShift);
   WL_Pair10.Move(x_delta+140,280+WatchListButtonsYShift);
   WL_Pair11.Move(x_delta+140,305+WatchListButtonsYShift);
   WL_Pair12.Move(x_delta+140,330+WatchListButtonsYShift);
   WL_Pair13.Move(x_delta+140,355+WatchListButtonsYShift);
   WL_Pair14.Move(x_delta+140,380+WatchListButtonsYShift);
   WL_Pair15.Move(x_delta+140,405+WatchListButtonsYShift);
   WL_Pair16.Move(x_delta+140,430+WatchListButtonsYShift);
   WL_Pair17.Move(x_delta+140,455+WatchListButtonsYShift);
   WL_Pair18.Move(x_delta+140,480+WatchListButtonsYShift);
   WL_Pair19.Move(x_delta+140,505+WatchListButtonsYShift);
   WL_Pair20.Move(x_delta+140,530+WatchListButtonsYShift);
   WL_Pair21.Move(x_delta+140,555+WatchListButtonsYShift);
   WL_Pair22.Move(x_delta+140,580+WatchListButtonsYShift);
   WL_Pair23.Move(x_delta+140,605+WatchListButtonsYShift);
   WL_Pair24.Move(x_delta+140,630+WatchListButtonsYShift);
   WL_Pair25.Move(x_delta+140,655+WatchListButtonsYShift);
   WL_Pair26.Move(x_delta+140,680+WatchListButtonsYShift);
   WL_Pair27.Move(x_delta+140,705+WatchListButtonsYShift);
   WL_Pair28.Move(x_delta+140,730+WatchListButtonsYShift);
   WL_Pair29.Move(x_delta+140,755+WatchListButtonsYShift);
   WL_Pair30.Move(x_delta+140,780+WatchListButtonsYShift);
   
   TradeDir_WL_Pair1_Label.Move(x_delta+205,59+WatchListButtonsYShift);
   TradeInfo_WL_Pair1_Label.Move(x_delta+217,59+WatchListButtonsYShift);
   
   TradeDir_WL_Pair2_Label.Move(x_delta+205,84+WatchListButtonsYShift);
   TradeInfo_WL_Pair2_Label.Move(x_delta+217,84+WatchListButtonsYShift);
   
   
   TradeDir_WL_Pair3_Label.Move(x_delta+205,109+WatchListButtonsYShift);
   TradeInfo_WL_Pair3_Label.Move(x_delta+217,109+WatchListButtonsYShift);
   
   TradeDir_WL_Pair4_Label.Move(x_delta+205,134+WatchListButtonsYShift);
   TradeInfo_WL_Pair4_Label.Move(x_delta+217,134+WatchListButtonsYShift);
   
   TradeDir_WL_Pair5_Label.Move(x_delta+205,159+WatchListButtonsYShift);
   TradeInfo_WL_Pair5_Label.Move(x_delta+217,159+WatchListButtonsYShift);
   
   TradeDir_WL_Pair6_Label.Move(x_delta+205,184+WatchListButtonsYShift);
   TradeInfo_WL_Pair6_Label.Move(x_delta+217,184+WatchListButtonsYShift);
   
   TradeDir_WL_Pair7_Label.Move(x_delta+205,209+WatchListButtonsYShift);
   TradeInfo_WL_Pair7_Label.Move(x_delta+217,209+WatchListButtonsYShift);
   
   TradeDir_WL_Pair8_Label.Move(x_delta+205,234+WatchListButtonsYShift);
   TradeInfo_WL_Pair8_Label.Move(x_delta+217,234+WatchListButtonsYShift);
   
   TradeDir_WL_Pair9_Label.Move(x_delta+205,259+WatchListButtonsYShift);
   TradeInfo_WL_Pair9_Label.Move(x_delta+217,259+WatchListButtonsYShift);
   
   TradeDir_WL_Pair10_Label.Move(x_delta+205,284+WatchListButtonsYShift);
   TradeInfo_WL_Pair10_Label.Move(x_delta+217,284+WatchListButtonsYShift);
   
   TradeDir_WL_Pair11_Label.Move(x_delta+205,309+WatchListButtonsYShift);
   TradeInfo_WL_Pair11_Label.Move(x_delta+217,309+WatchListButtonsYShift);
   
   TradeDir_WL_Pair12_Label.Move(x_delta+205,334+WatchListButtonsYShift);
   TradeInfo_WL_Pair12_Label.Move(x_delta+217,334+WatchListButtonsYShift);
   
   TradeDir_WL_Pair13_Label.Move(x_delta+205,359+WatchListButtonsYShift);
   TradeInfo_WL_Pair13_Label.Move(x_delta+217,359+WatchListButtonsYShift);
   
   TradeDir_WL_Pair14_Label.Move(x_delta+205,384+WatchListButtonsYShift);
   TradeInfo_WL_Pair14_Label.Move(x_delta+217,384+WatchListButtonsYShift);
   
   TradeDir_WL_Pair15_Label.Move(x_delta+205,409+WatchListButtonsYShift);
   TradeInfo_WL_Pair15_Label.Move(x_delta+217,409+WatchListButtonsYShift);
   
   TradeDir_WL_Pair16_Label.Move(x_delta+205,434+WatchListButtonsYShift);
   TradeInfo_WL_Pair16_Label.Move(x_delta+217,434+WatchListButtonsYShift);
   
   TradeDir_WL_Pair17_Label.Move(x_delta+205,459+WatchListButtonsYShift);
   TradeInfo_WL_Pair17_Label.Move(x_delta+217,459+WatchListButtonsYShift);
   
   TradeDir_WL_Pair18_Label.Move(x_delta+205,484+WatchListButtonsYShift);
   TradeInfo_WL_Pair18_Label.Move(x_delta+217,484+WatchListButtonsYShift);
   
   TradeDir_WL_Pair19_Label.Move(x_delta+205,509+WatchListButtonsYShift);
   TradeInfo_WL_Pair19_Label.Move(x_delta+217,509+WatchListButtonsYShift);
   
   TradeDir_WL_Pair20_Label.Move(x_delta+205,534+WatchListButtonsYShift);
   TradeInfo_WL_Pair20_Label.Move(x_delta+217,534+WatchListButtonsYShift);
   
   TradeDir_WL_Pair21_Label.Move(x_delta+205,559+WatchListButtonsYShift);
   TradeInfo_WL_Pair21_Label.Move(x_delta+217,559+WatchListButtonsYShift);
   
   TradeDir_WL_Pair22_Label.Move(x_delta+205,584+WatchListButtonsYShift);
   TradeInfo_WL_Pair22_Label.Move(x_delta+217,584+WatchListButtonsYShift);
   
   TradeDir_WL_Pair23_Label.Move(x_delta+205,609+WatchListButtonsYShift);
   TradeInfo_WL_Pair23_Label.Move(x_delta+217,609+WatchListButtonsYShift);
   
   TradeDir_WL_Pair24_Label.Move(x_delta+205,634+WatchListButtonsYShift);
   TradeInfo_WL_Pair24_Label.Move(x_delta+217,634+WatchListButtonsYShift);
   
   TradeDir_WL_Pair25_Label.Move(x_delta+205,659+WatchListButtonsYShift);
   TradeInfo_WL_Pair25_Label.Move(x_delta+217,659+WatchListButtonsYShift);
   
   TradeDir_WL_Pair26_Label.Move(x_delta+205,684+WatchListButtonsYShift);
   TradeInfo_WL_Pair26_Label.Move(x_delta+217,684+WatchListButtonsYShift);
   
   TradeDir_WL_Pair27_Label.Move(x_delta+205,709+WatchListButtonsYShift);
   TradeInfo_WL_Pair27_Label.Move(x_delta+217,709+WatchListButtonsYShift);
   
   TradeDir_WL_Pair28_Label.Move(x_delta+205,734+WatchListButtonsYShift);
   TradeInfo_WL_Pair28_Label.Move(x_delta+217,734+WatchListButtonsYShift);
   
   TradeDir_WL_Pair29_Label.Move(x_delta+205,759+WatchListButtonsYShift);
   TradeInfo_WL_Pair29_Label.Move(x_delta+217,759+WatchListButtonsYShift);
   
   TradeDir_WL_Pair30_Label.Move(x_delta+205,784+WatchListButtonsYShift);
   TradeInfo_WL_Pair30_Label.Move(x_delta+217,784+WatchListButtonsYShift);
  
   // *************** update position of RightLowerInfo_Label *********************
   long x = (int)ChartGetInteger(ChartID(),CHART_WIDTH_IN_PIXELS);
   long y = (int)ChartGetInteger(ChartID(),CHART_HEIGHT_IN_PIXELS);
   ObjectSetInteger(ChartID(),RightLowerInfo_Label.Name(),OBJPROP_XDISTANCE,x-5);
   ObjectSetInteger(ChartID(),RightLowerInfo_Label.Name(),OBJPROP_YDISTANCE,y-3);
   
   ObjectSetInteger(ChartID(),RightLowerInfoSymbol_Label.Name(),OBJPROP_XDISTANCE,x-5);
   ObjectSetInteger(ChartID(),RightLowerInfoSymbol_Label.Name(),OBJPROP_YDISTANCE,y-25);
   // *****************************************************************************
}



void ShowAllObjectsControlButtons(bool show = true) {

   if (show) {
         H1_Visibility_Button.Show();
         H1H4_Visibility_Button.Show();
         H1D1_Visibility_Button.Show();
         D1_Visibility_Button.Show();
      
         // COLOR CONTROLS
         CustomColor_Button1_1.Show();
         CustomColor_Button1_2.Show();
         CustomColor_Button1_3.Show();
         CustomColor_Button1_4.Show();

         CustomColor_Button2_1.Show();
         CustomColor_Button2_2.Show();
         CustomColor_Button2_3.Show();
         CustomColor_Button2_4.Show();
         
         CustomColor_Button3_1.Show();
         CustomColor_Button3_2.Show();
         CustomColor_Button3_3.Show();
         CustomColor_Button3_4.Show();
         
         // LINE STYLE CONTROLS
         SetThickLine_Button.Show();
         SetSolidLine_Button.Show();
         SetDashedLine_Button.Show();;
         SetDotLine_Button.Show();
   }
   else {
         H1_Visibility_Button.Hide();
         H1H4_Visibility_Button.Hide();
         H1D1_Visibility_Button.Hide();
         D1_Visibility_Button.Hide();
      
         // COLOR CONTROLS
         CustomColor_Button1_1.Hide();
         CustomColor_Button1_2.Hide();
         CustomColor_Button1_3.Hide();
         CustomColor_Button1_4.Hide();

         CustomColor_Button2_1.Hide();
         CustomColor_Button2_2.Hide();
         CustomColor_Button2_3.Hide();
         CustomColor_Button2_4.Hide();
         
         CustomColor_Button3_1.Hide();
         CustomColor_Button3_2.Hide();
         CustomColor_Button3_3.Hide();
         CustomColor_Button3_4.Hide();
         
         // LINE STYLE CONTROLS
         SetThickLine_Button.Hide();
         SetSolidLine_Button.Hide();
         SetDashedLine_Button.Hide();;
         SetDotLine_Button.Hide();
   }

}








void HideShowButtons() {

   Print(__FUNCTION__);

   if ( GlobalVariableGet("BFToolsShowAll") == 1 ) {
      ObjectsHidden = true;
      HideButtons();
   }
   else {
      ObjectsHidden = false;
      ShowButtons();
   }
}




void HideButtons() {
      HideMainButtons();
      WL_InWL_High_Button.Hide();
      WL_InWL_Low_Button.Hide();
      ClearWL_Button.Hide();
      AutoBFTools_Button.Hide();
      SoundControl_Button.Hide();
      PushControl_Button.Hide();
      Minimize_Button.Text("+");
      GlobalVariableSet("BFToolsShowAll",0);
      HideAllWatchPairButtons();
      TradeManager.ShowHideBodyLevelsButton();
      ChartRedraw();
}


void ShowButtons() {
   Print(__FUNCTION__);
      ShowMainButtons();
      WL_InWL_High_Button.Show();
      WL_InWL_Low_Button.Show();
      ClearWL_Button.Show();
      AutoBFTools_Button.Show();
      SoundControl_Button.Show();
      PushControl_Button.Show();
      
      ShowAllWatchPairButtons();

      Minimize_Button.Text("_");
      Minimize_Button.Show();
      GlobalVariableSet("BFToolsShowAll",1);
      //BroadcastEvent(ChartID(),0,"ShowAllUI");
      TradeManager.ShowHideBodyLevelsButton();
      TradeManager.TM_NoBE_Button.Show();
}


void HideMainButtons() {
   SetSolidLine_Button.Hide();
   SetThickLine_Button.Hide();
   SetDotLine_Button.Hide();
   SetDashedLine_Button.Hide();
   CustomColor_Button2_4.Hide();
   CustomColor_Button2_1.Hide();
   CustomColor_Button2_2.Hide();
   CustomColor_Button2_3.Hide();
   CustomColor_Button1_4.Hide();
   CustomColor_Button1_2.Hide();
   CustomColor_Button1_1.Hide();
   CustomColor_Button1_3.Hide();
   CustomColor_Button1_4.Hide();
   CustomColor_Button3_1.Hide();
   CustomColor_Button3_2.Hide();
   CustomColor_Button3_4.Hide();
   CustomColor_Button3_3.Hide();
   H1H4_Visibility_Button.Hide();
   H1D1_Visibility_Button.Hide();
   D1_Visibility_Button.Hide();
   H1_Visibility_Button.Hide();
   FixChartScale_Button.Hide();
   UnselectAll_Button.Hide();
   FiboReset_Button.Hide();
   SaveTemplate_Button.Hide();
   TradeManager.TM_NoBE_Button.Hide();

   ShowHoursDelayButtons(false);

   SoundControl_Button.Hide();
   PushControl_Button.Hide();
   
   WL_Prev.Hide(); 
   WL_Next.Hide();

   //TodayRange_Label.Hide();
   //ATR5_Label.Hide();
   //ATR14_Label.Hide();
   //ATR180_Label.Hide();
   GlobalVariableSet("BFToolsShowMainButtons",0);
   
   if (ShowMetaKeypad) ShowMetaKeyPad(false);
   
}




void ShowMainButtons() {
      Print(__FUNCTION__);
      SetSolidLine_Button.Show();
      SetThickLine_Button.Show();
      SetDotLine_Button.Show();
      SetDashedLine_Button.Show();
      CustomColor_Button2_4.Show();
      CustomColor_Button2_1.Show();
      CustomColor_Button2_2.Show();
      CustomColor_Button2_3.Show();
      CustomColor_Button1_4.Show();
      CustomColor_Button1_2.Show();
      CustomColor_Button1_1.Show();
      CustomColor_Button1_3.Show();
      CustomColor_Button1_4.Show();
      CustomColor_Button3_1.Show();
      CustomColor_Button3_2.Show();
      CustomColor_Button3_3.Show();
      CustomColor_Button3_4.Show();
      H1H4_Visibility_Button.Show();
      H1D1_Visibility_Button.Show();
      D1_Visibility_Button.Show();
      H1_Visibility_Button.Show();
      FixChartScale_Button.Show();
      UnselectAll_Button.Show();
      FiboReset_Button.Show();
      SaveTemplate_Button.Show();
      SoundControl_Button.Show();
      PushControl_Button.Show();
      WL_Prev.Show(); 
      WL_Next.Show();  
      
      if (!S_Version && InWatchList && !ObjectsHidden) 
         ShowHoursDelayButtons(true);
      else 
         ShowHoursDelayButtons(false);    
      
      
      TodayRange_Label.Show();
      ATR5_Label.Show();
      ATR14_Label.Show();
      ATR180_Label.Show();
      GlobalVariableSet("BFToolsShowMainButtons",1);
      
      if (ShowMetaKeypad) ShowMetaKeyPad(true);
      
      ChartRedraw();
}


void ShowHoursDelayButtons(bool show) {

   if (show) {
      WL1_Button.Show();
      WL2_Button.Show();
      WL3_Button.Show();
      WL4_Button.Show();
      WL5_Button.Show();
      WLX_Button.Show(); 
   }
   else
     {
         WL1_Button.Hide();
         WL2_Button.Hide();
         WL3_Button.Hide();
         WL4_Button.Hide();
         WL5_Button.Hide();
         WLX_Button.Hide();  
     }
}



void ShowMetaKeyPad(bool show = true) {

   if (show) {
      Crosshair_Button.Show();
      DeleteObject_Button.Show();
      ChartNavigateLeft_Button.Show();
      ChartNavigateRight_Button.Show();
      MakeTrendHorizontalAndExtend_Button.Show();
      ToggleTrendRay_Button.Show();
      FixVertScale_Button.Show();
      ShowHideScenarios_Button.Show();
      HideShowAllObjectsExcLevels_Button.Show();
      CopyObject_Button.Show();
   }
   else {
      Crosshair_Button.Hide();
      DeleteObject_Button.Hide();
      ChartNavigateLeft_Button.Hide();
      ChartNavigateRight_Button.Hide();
      MakeTrendHorizontalAndExtend_Button.Hide();
      ToggleTrendRay_Button.Hide();
      FixVertScale_Button.Hide();
      ShowHideScenarios_Button.Hide();
      HideShowAllObjectsExcLevels_Button.Hide();
      CopyObject_Button.Hide();

   }


}















void InitArrayOfWatchPairButtons() {
      ArrayOfWatchPairButtons[0] = WL_Pair1;
      ArrayOfWatchPairButtons[1] = WL_Pair2;
      ArrayOfWatchPairButtons[2] = WL_Pair3;
      ArrayOfWatchPairButtons[3] = WL_Pair4;
      ArrayOfWatchPairButtons[4] = WL_Pair5;
      ArrayOfWatchPairButtons[5] = WL_Pair6;
      ArrayOfWatchPairButtons[6] = WL_Pair7;
      ArrayOfWatchPairButtons[7] = WL_Pair8;
      ArrayOfWatchPairButtons[8] = WL_Pair9;
      ArrayOfWatchPairButtons[9] = WL_Pair10;
      ArrayOfWatchPairButtons[10] = WL_Pair11;
      ArrayOfWatchPairButtons[11] = WL_Pair12;
      ArrayOfWatchPairButtons[12] = WL_Pair13;
      ArrayOfWatchPairButtons[13] = WL_Pair14;
      ArrayOfWatchPairButtons[14] = WL_Pair15;
      ArrayOfWatchPairButtons[15] = WL_Pair16;
      ArrayOfWatchPairButtons[16] = WL_Pair17;
      ArrayOfWatchPairButtons[17] = WL_Pair18;
      ArrayOfWatchPairButtons[18] = WL_Pair19;
      ArrayOfWatchPairButtons[19] = WL_Pair20;
      ArrayOfWatchPairButtons[20] = WL_Pair21;
      ArrayOfWatchPairButtons[21] = WL_Pair22;
      ArrayOfWatchPairButtons[22] = WL_Pair23;
      ArrayOfWatchPairButtons[23] = WL_Pair24;
      ArrayOfWatchPairButtons[24] = WL_Pair25;
      ArrayOfWatchPairButtons[25] = WL_Pair26;
      ArrayOfWatchPairButtons[26] = WL_Pair27;
      ArrayOfWatchPairButtons[27] = WL_Pair28;
      ArrayOfWatchPairButtons[28] = WL_Pair29;
      ArrayOfWatchPairButtons[29] = WL_Pair30;

   // Initializing Trade Direction and Trade info Labels
   ArrayResize(ArrayOfTradeDirLabels,30);
   ArrayResize(ArrayOfTradeInfoLabels,30);

   ArrayOfTradeDirLabels[0]  = TradeDir_WL_Pair1_Label;
   ArrayOfTradeInfoLabels[0] = TradeInfo_WL_Pair1_Label;

   ArrayOfTradeDirLabels[1]  = TradeDir_WL_Pair2_Label;
   ArrayOfTradeInfoLabels[1] = TradeInfo_WL_Pair2_Label;
   
   ArrayOfTradeDirLabels[2]  = TradeDir_WL_Pair3_Label;
   ArrayOfTradeInfoLabels[2] = TradeInfo_WL_Pair3_Label;
   
   ArrayOfTradeDirLabels[3]  = TradeDir_WL_Pair4_Label;
   ArrayOfTradeInfoLabels[3] = TradeInfo_WL_Pair4_Label;
   
   ArrayOfTradeDirLabels[4]  = TradeDir_WL_Pair5_Label;
   ArrayOfTradeInfoLabels[4] = TradeInfo_WL_Pair5_Label;
   
   ArrayOfTradeDirLabels[5]  = TradeDir_WL_Pair6_Label;
   ArrayOfTradeInfoLabels[5] = TradeInfo_WL_Pair6_Label;
   
   ArrayOfTradeDirLabels[6]  = TradeDir_WL_Pair7_Label;
   ArrayOfTradeInfoLabels[6] = TradeInfo_WL_Pair7_Label;
   
   ArrayOfTradeDirLabels[7]  = TradeDir_WL_Pair8_Label;
   ArrayOfTradeInfoLabels[7] = TradeInfo_WL_Pair8_Label;
   
   ArrayOfTradeDirLabels[8]  = TradeDir_WL_Pair9_Label;
   ArrayOfTradeInfoLabels[8] = TradeInfo_WL_Pair9_Label;
   
   ArrayOfTradeDirLabels[9]  = TradeDir_WL_Pair10_Label;
   ArrayOfTradeInfoLabels[9] = TradeInfo_WL_Pair10_Label;
   
   ArrayOfTradeDirLabels[10]  = TradeDir_WL_Pair11_Label;
   ArrayOfTradeInfoLabels[10] = TradeInfo_WL_Pair11_Label;
   
   ArrayOfTradeDirLabels[11]  = TradeDir_WL_Pair12_Label;
   ArrayOfTradeInfoLabels[11] = TradeInfo_WL_Pair12_Label;
   
   ArrayOfTradeDirLabels[12]  = TradeDir_WL_Pair13_Label;
   ArrayOfTradeInfoLabels[12] = TradeInfo_WL_Pair13_Label;
   
   ArrayOfTradeDirLabels[13]  = TradeDir_WL_Pair14_Label;
   ArrayOfTradeInfoLabels[13] = TradeInfo_WL_Pair14_Label;
   
   ArrayOfTradeDirLabels[14]  = TradeDir_WL_Pair15_Label;
   ArrayOfTradeInfoLabels[14] = TradeInfo_WL_Pair15_Label;
   
   ArrayOfTradeDirLabels[15]  = TradeDir_WL_Pair16_Label;
   ArrayOfTradeInfoLabels[15] = TradeInfo_WL_Pair16_Label;
   
   ArrayOfTradeDirLabels[16]  = TradeDir_WL_Pair17_Label;
   ArrayOfTradeInfoLabels[16] = TradeInfo_WL_Pair17_Label;
   
   ArrayOfTradeDirLabels[17]  = TradeDir_WL_Pair18_Label;
   ArrayOfTradeInfoLabels[17] = TradeInfo_WL_Pair18_Label;
   
   ArrayOfTradeDirLabels[18]  = TradeDir_WL_Pair19_Label;
   ArrayOfTradeInfoLabels[18] = TradeInfo_WL_Pair19_Label;
   
   ArrayOfTradeDirLabels[19]  = TradeDir_WL_Pair20_Label;
   ArrayOfTradeInfoLabels[19] = TradeInfo_WL_Pair20_Label;
   
   ArrayOfTradeDirLabels[20] = TradeDir_WL_Pair21_Label;
   ArrayOfTradeInfoLabels[20] = TradeInfo_WL_Pair21_Label;

   ArrayOfTradeDirLabels[21] = TradeDir_WL_Pair22_Label;
   ArrayOfTradeInfoLabels[21] = TradeInfo_WL_Pair22_Label;

   ArrayOfTradeDirLabels[22] = TradeDir_WL_Pair23_Label;
   ArrayOfTradeInfoLabels[22] = TradeInfo_WL_Pair23_Label;

   ArrayOfTradeDirLabels[23] = TradeDir_WL_Pair24_Label;
   ArrayOfTradeInfoLabels[23] = TradeInfo_WL_Pair24_Label;

   ArrayOfTradeDirLabels[24] = TradeDir_WL_Pair25_Label;
   ArrayOfTradeInfoLabels[24] = TradeInfo_WL_Pair25_Label;

   ArrayOfTradeDirLabels[25] = TradeDir_WL_Pair26_Label;
   ArrayOfTradeInfoLabels[25] = TradeInfo_WL_Pair26_Label;

   ArrayOfTradeDirLabels[26] = TradeDir_WL_Pair27_Label;
   ArrayOfTradeInfoLabels[26] = TradeInfo_WL_Pair27_Label;

   ArrayOfTradeDirLabels[27] = TradeDir_WL_Pair28_Label;
   ArrayOfTradeInfoLabels[27] = TradeInfo_WL_Pair28_Label;

   ArrayOfTradeDirLabels[28] = TradeDir_WL_Pair29_Label;
   ArrayOfTradeInfoLabels[28] = TradeInfo_WL_Pair29_Label;

   ArrayOfTradeDirLabels[29] = TradeDir_WL_Pair30_Label;
   ArrayOfTradeInfoLabels[29] = TradeInfo_WL_Pair30_Label;



   
   for (int i = 0; i < ArraySize(ArrayOfTradeDirLabels); i++) {
      ArrayOfTradeDirLabels[i].Font("Wingdings");
      ArrayOfTradeDirLabels[i].FontSize(11);
      ArrayOfTradeDirLabels[i].Color(clrBlack);
      ObjectSetInteger(0,ArrayOfTradeDirLabels[i].Name(),OBJPROP_ZORDER,100);
      ObjectSetString(0,ArrayOfTradeDirLabels[i].Name(),OBJPROP_TOOLTIP,"Direction of Last Opened Trade");
      
      ArrayOfTradeInfoLabels[i].Font("Caribri");
      ArrayOfTradeInfoLabels[i].FontSize(9);
      ArrayOfTradeInfoLabels[i].Color(clrBlack);
      ObjectSetInteger(0,ArrayOfTradeInfoLabels[i].Name(),OBJPROP_ZORDER,100);
      ObjectSetString(0,ArrayOfTradeInfoLabels[i].Name(),OBJPROP_TOOLTIP,"Trade Info");
   }
   
   // ==================================== ******* =====================================
}


void InitAutoBFTools_Button() {

   if (AutoBFTools) UpdateAutoBFToolsButton();

   if (!GlobalVariableCheck("AutoBFTools")) { // if variable doesn't exist
      GlobalVariableSet("AutoBFTools",1);     // creating it
      UpdateAutoBFToolsButton();              // updating the button
   }
}

void UpdateSoundPushButtons() {

   if (IsSoundControlON()) HighlightButton(SoundControl_Button,true);
      else HighlightButton(SoundControl_Button,false);
   if (IsPushControlON())  HighlightButton(PushControl_Button,true);
      else HighlightButton(PushControl_Button,false);

}



void UpdateDayPriority() { 
   // find arrow yesterday and define priority for today from that arrow; applied to any strategy
   
   DayPriority = None; // resetting day priority
   
   if (!InWatchList) { 
      DayPriority = None; 
      RefreshComment(); 
      return;
   }
   
   int obj_total=ObjectsTotalMQL4(); //total objects count
   ENUM_OBJECT_PROPERTY_INTEGER ArrowCode;

   // checking arrow object first
   for(int i=0; i<obj_total; i++) { // for each object on the chart
      string ArrowName = ObjectName(0,i,0,-1);    // getting the object name
      ArrowCode = (ENUM_OBJECT_PROPERTY_INTEGER)ObjectGetMQL4(ArrowName,OBJPROP_ARROWCODE);
      if ((ArrowCode == SYMBOL_ARROWUP || ArrowCode == SYMBOL_ARROWDOWN) && IsObjectInYesterday(ArrowName)) {
         // найдена стрелка вверх или вних, расположенная во вчерашнем дне
         if      (ArrowCode == SYMBOL_ARROWUP)   { DayPriority = Buy;    }
         else if (ArrowCode == SYMBOL_ARROWDOWN) { DayPriority = Sell;   }
      }
   }
   
   
   if (DayPriority != None) {
      //Print(__FUNCTION__ + ": detected day prio = '" + EnumToString(DayPriority) + "' based on arrow icon"); 
      RefreshComment();
      return;
   }
   
   else { // day priority based on arrows was not detected
      if ( ArraySize(Levels) > 0 ) {
         // no arrow found - trying to detect closest level type
         short li = CLevel::GetClosestLevelIndexInArray(Levels);
         
         if ( Levels[li].GetTradeDirection() == Sell_Level )
            DayPriority = Sell;
         else
             DayPriority = Buy;
      }
      else if (DebugMode) Print(__FUNCTION__ + ": no levels in the levels[] array");
   
   }
   if (DayPriority != None) 
     // Print(__FUNCTION__ + ": detected day prio = '" + EnumToString(DayPriority) + "' based on closest level");
   //else
   //   Print(__FUNCTION__ + ": day prio was NOT detected and remains '" + EnumToString(DayPriority) + "'. No arrows or closest trade levels found."); 
   
   RefreshComment();
}





void InitFixChartScale_Button() {

   int period = Period();
  
   FixChartScale_Button.Color(clrBlack); 
   FixChartScale_Button.ColorBorder(clrBlack);
      
   if (period == PERIOD_H1) {
     if (sets.FixChartScale_H1_Zoom == -1) { // is OFF
         HighlightButton(FixChartScale_Button,false); 
      }
      else { // is ON 
         HighlightButton(FixChartScale_Button,true); 
      }
   }
   else if (period == PERIOD_H4) {
     if (sets.FixChartScale_H4_Zoom == -1) { // is OFF
         HighlightButton(FixChartScale_Button,false); 
      }
      else { // is ON 
         HighlightButton(FixChartScale_Button,true); 
      }
   }
   else if (period == PERIOD_D1) {
     if (sets.FixChartScale_D1_Zoom == -1) { // is OFF
         HighlightButton(FixChartScale_Button,false); 
      }
      else { // was ON -> is ON
         HighlightButton(FixChartScale_Button,true); 
      }
   }
   else { // block the FIX button
      Print("Deactivate FIX button");
      FixChartScale_Button.Color(clrGray);
      FixChartScale_Button.ColorBorder(clrGray);
   
   }

}







void InitDayOfWeekLabels() {

   if (S_Version || !CreateLabelsOnChart) return;

   if (Period() != PERIOD_H1) return;
   
   ChartSetInteger(ChartID(),CHART_EVENT_OBJECT_DELETE,false);
   ObjectDelete(0,"Mon");
   ObjectDelete(0,"Tue");
   ObjectDelete(0,"Wed");
   ObjectDelete(0,"Thu");
   ObjectDelete(0,"Fri");
   ObjectDelete(0,"Sat");
   ObjectDelete(0,"Sun");
   ChartSetInteger(ChartID(),CHART_EVENT_OBJECT_DELETE,true);

  
   datetime time_pos = Today() + Period()*60*12;
   double price_pos = ChartGetDouble(0,CHART_PRICE_MAX,0) - ChartGetDouble(0,CHART_PRICE_MAX,0)*0.001;
   
   
   
   for (int i=1; i<7; i++) {
   
      if ( (DayOfWeekMQL4() == 0 || DayOfWeekMQL4() == 6) && time_pos < Yesterday() && ( TimeDayOfWeekMQL4(time_pos) == 0 || TimeDayOfWeekMQL4(time_pos) == 6) ) continue;

      if (TimeDayOfWeekMQL4(time_pos) == 0 || TimeDayOfWeekMQL4(time_pos) == 6) {
         time_pos = time_pos - Period()*60*24;
         continue;
      }
      
      CreateWeekDayTextLabel(time_pos, price_pos, DayOfWeekName(TimeDayOfWeekMQL4(time_pos)), DayOfWeekName(TimeDayOfWeekMQL4(time_pos)) + "  " + IntegerToString(TimeDayMQL4(time_pos)) + " " + MonthToShortName((short)TimeMonthMQL4(time_pos)) );
      
      time_pos = time_pos - Period()*60*24;
   
   }
}


void CreateWeekDayTextLabel(datetime time_pos, double price_pos, string text_name, string text) {

   ObjectCreate(ChartID(),text_name,OBJ_TEXT,0,time_pos,price_pos);
   ObjectSetString(ChartID(),text_name,OBJPROP_TEXT,text);
   ObjectSetInteger(ChartID(),text_name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(ChartID(),text_name,OBJPROP_COLOR,clrGray);
   ObjectSetInteger(ChartID(),text_name,OBJPROP_FONTSIZE,9);
   ObjectSetMQL4(text_name, OBJPROP_TIMEFRAMES, OBJ_PERIOD_H1);

}




void DelayedInit() {

   // creating delay
   if (DelayedInitComplete) return;
   short delay = 5; // delay in seconds
   if (DelayedInitCounter < delay) {
      DelayedInitCounter++;
      return;
   }
   // end of delay processing


   // executed only once; 5 sec after normal initialization - move here all non-critical tasks to make  
   
   if ( !ProtectionCheck() ) {
      Print("Protection checked failed");
      OperationAllowed = false;
   }
   else 
      if (DebugMode) {
         if (DemoVersion)
            Print("Demo Version until: " + TimeToString(DemoVersionUntil));
         else
            Print("Protection checked: OK");
      }
    
   // ********************************************************************************************
   // ********** Detecting, if this there is a "WatchlistMark" trend on the chart. 
   // ********** If there is and this chart is not in Watchlist - adding it to Watchlist
   // ********** If there is NO such mark - removing it from the Watchlist 
   // ********************************************************************************************
   
         // is it BF Strategy? Never delete standard pairs from the watchlist
         bool BF_STD_Pair = false;
         string symbol = Symbol();
         if (symbol == "AUDUSD" || symbol == "NZDUSD" || symbol == "EURUSD" || symbol == "GBPUSD" || symbol == "EURGBP" 
                                || symbol == "GBPJPY" || symbol == "EURJPY" || symbol == "USDJPY" || symbol == "USDCAD" 
                                || symbol == "USDCHF") {
            BF_STD_Pair = true;
         }
         
         // check if watchklist mark exists; if yes - add current chart into watchlist
         if (ObjectFind(0,WatchlistMark) == 0) {
         
            // not checking where it is - just adding pair to the watchlist
            string s_prio = ObjectGetString(0,WatchlistMark,OBJPROP_TEXT);
            short prio = (short)StringToInteger(s_prio);
            if (prio == 1) AddChartToWatchlist(LowProbability);
            else if (prio == 2) AddChartToWatchlist(HighProbability);
            else if (prio == 0) AddChartToWatchlist(NoProbability);
            else AddChartToWatchlist(NormalProbability);
            // ========================================================================
         
            /*
               // the mark is found; now checking where is it
               // if mark is in today's morning (pair added today morning, or preious trading day evening (pair is added during weekend, or at today's evening (pair added today 
               // (today is weekend) afternoon and template is being moved also today afternoon) - add this chart to watch list
               datetime time = (datetime)ObjectGetMQL4(WatchlistMark,OBJPROP_TIME1);
               if (time == iTime(Symbol(),PERIOD_D1,0) + 3600*2 || time == iTime(Symbol(),PERIOD_D1,1) + 3600*20  || time == iTime(Symbol(),PERIOD_D1,0) + 3600*20) {
                  // mark should be located either today at 2 a.m., or 20:00, or yesterday (previous trading day) at 20:00
                  // confirmed! adding this pair to watch list
                  // detecting priority (from the WatchlistMark first)
                  string s_prio = ObjectGetString(0,WatchlistMark,OBJPROP_TEXT);
                  short prio = (short)StringToInteger(s_prio);
                  if (prio == 1) AddChartToWatchlist(LowProbability);
                  else if (prio == 2) AddChartToWatchlist(HighProbability);
                  else if (prio == 0) AddChartToWatchlist(NoProbability);
                  else AddChartToWatchlist(NormalProbability);
               }
               else
                  // mark is found, but in the wrong place
                  if (!BF_STD_Pair) RemoveChartFromWatchlist(); // do not remove from Watchlist, if this is std BF pair and strategy is BF
            */
         }
         else {
            // mark is not found - removing pair from the watch list
            if ( !(BF_STD_Pair && Strategy == BF) ) RemoveChartFromWatchlist(); // do not remove from Watchlist, if this is std BF pair and strategy is BF
         }
   // ********* END OF "WatchlistMark" check ***************************************************************
   // ******************************************************************************************************************************
   // ******************************************************************************************************************************
   



   // ********************************************************************************************
   // ********** Spread History 
   // ********************************************************************************************
   SpreadHistory.LoadSpreadHistoryFromDisk();
   AvgSpread = SpreadHistory.AvgSpread();
   // ********* END OF "WatchlistMark" check ***************************************************************
   // ******************************************************************************************************************************
   
   
   // refreshing comment in the left upper corner
   RefreshComment();
  
  #ifdef __MQL4__
     if (!IsDllsAllowed()) {
         DestroyAllButtons();
         Alert(Symbol() + ": BF Tools: Please, enable DLL Import");
         ChartIndicatorDelete(0,0,indicator_short_name);
         OnDeinit(0);
         return;
     }
  #endif 
  

  


   InitDayOfWeekLabels();
   
   if (AutoBFTools) {
      //Print("Updating Fibo's and trend lines");
      ExtendAllFibos();             // first, we extend all fibo's where necessary;
      UpdateFiboLevelsForAll();     // then, we delete broken fibo levels, where necessary
      AllDashDotDotTrendsToSolid(); // DashDotDotTrendsToSolid
      UpdateStatusOfAllTrends();    // solid -> dashed, if broken
   }
   
   
   // Load news from file and draw it on chart
   NewsCalendar.LoadNewsFromFile();
   NewsCalendar.DrawNewsOnChart(0,News_Impact);
   // now array of structures of news are in downloader.Events[]
   //}
   // *********************************************************
   
   
   
   Print(__FUNCTION__ + ": Delayed init is complete. Delay " + IntegerToString(delay) + "s");
   DelayedInitComplete = true;
}
  
