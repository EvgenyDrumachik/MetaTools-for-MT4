#property link "https://www.youtube.com/watch?v=bS_SzQjj6Jg"
#property strict


class CFFNewsCalendar {

protected:
  
   string         mPath;
   string         AllNewsFileName;
   int            mTimeout;

   int            mError;

   bool           ParseNewsRawCSV();
   bool           SaveNewsToFiles();
   bool           IsCountryRelevantToSymbol(string country, string symbol);
   bool           IsImpactRelevant(NewsImpact news_impact_setting, string impact);
   string         GetNewsMarkName(string EventTitle, datetime EventTime);
   void           GetPricesForNewsMarks(long chartid, datetime NewsTime, double &price1, double &price2);
   bool           IsChartNewsFileExists(string symbol);
   string         FilePathBySymbol(string symbol);
   bool           IsDistAboveMoreThanDistBelow(long chartid, datetime NewsTime);
   static   int   DeleteAllNewsMarksOnChart(long chartid);

public:

   // Constructors
   CFFNewsCalendar(void);
   ~CFFNewsCalendar() {};
   
   NewsImpact     News_Impact;
   
   // Properties
   string         NewsRawCSV;
   void           Path(string value)      {  mPath = value;    }
   string         Path()                  {  return(mPath);    }

   void           Timeout(int value)      {  mTimeout = value; }
   int            Timeout()               {  return(mTimeout); }

   // Read only properties
   int            Error()                 {  return(mError);   }

   // Methods
   bool           Download(string url);
   bool           NewsOutdated();
   bool           OpenChartsWithoutNewsFile();
   bool           LoadNewsFromFile(string filepath = "");
   void           DrawNewsOnChart(long chartid, NewsImpact news_impact_setting);
   
   CalendarEvent  Events[];
   int            Count; // number of events downloaded
   short          BrokerTimeZone;
   static   const string MarkNamePrefix;
   
   static   void  DeleteAllNewsMarksOnAllCharts();

};


const string CFFNewsCalendar::MarkNamePrefix = "NewsOnChart";


CFFNewsCalendar::CFFNewsCalendar(void) {
   Path("News");
   Timeout(10000);
   AllNewsFileName = "AllNews.csv";
}


bool CFFNewsCalendar::Download(string url) {

   string   cookie      = NULL;
   string   referer     = NULL;
   int      timeout     = Timeout();
   char     data[];     // array of chars to be sent with web request - not used
   char     response[]; // array of chars that returs from the web request (downloaded data)
   string   headers;
   
   // clean up
   NewsRawCSV   = "";
   ResetLastError();
   
   int      result = WebRequest("GET",url,cookie,referer,timeout,data,0,response,headers);
   
   if (result < 0) {
   
      mError = GetLastError();
      PrintFormat("%s error %i downloading from %s", __FUNCTION__, mError,url);
      return(false);  
   }
   
   NewsRawCSV = CharArrayToString(response);
   
   /* - // Do not whole downloaded text into calendar file. It will be saved into a separate file for each open chart in the ParseNewsRawCSV Function
   int handle = FileOpen(filePath, FILE_WRITE | FILE_BIN);
   if (handle==INVALID_HANDLE) {
      mError = GetLastError();
      PrintFormat("%s error %i opening file %s", __FUNCTION__, mError, filePath);
   }
   
   FileWriteArray(handle,response,0,ArraySize(response));
   FileFlush(handle);
   FileClose(handle);
   */
   
   return(ParseNewsRawCSV() && SaveNewsToFiles());
}



bool CFFNewsCalendar::ParseNewsRawCSV(void) {
   // Downloading ALL news: for all countries and all impact
   // https://www.youtube.com/watch?v=bS_SzQjj6Jg
   // Print("Parsing: " + NewsRawCSV);
   
   string   lines[];
   string   columns[]; // columnns of the table (values of 1 line at a time
   int      size  =  StringSplit(NewsRawCSV, '\n', lines); // number of lines in the NewsRawCSV, incl. Header
   
   //Print("Number of lines in NewsRawCSV: " + size);
   
   Count = size - 1; // minus header line = number of lines (News)
   ArrayResize(Events, Count);
   string    dateParts[];
   string    timeParts[];
   for (int i = 0; i<Count; i++) {
      // for each line in the NewsRawCSV, starting after header
      #ifdef __MQL4__
         StringSplit(StringTrimLeft(StringTrimRight(lines[i+1])), ',', columns); // splitting this line into values in string array -> columns
      #endif 
      
      #ifdef __MQL5__
         StringTrimRight(lines[i+1]);
         StringTrimLeft(lines[i+1]);
         StringSplit(lines[i+1], ',', columns);
      #endif 
      
      
      if (ArraySize(columns) == 0) {  // if we read a line without comas - this is most probably the end of the file
         ArrayResize(Events,ArraySize(Events)-1); // decreasing array by 1 element, as the last one was redundant and doesn't contain data
         break;
      }
      Events[i].title   =  columns[0];
      Events[i].country =  columns[1];
      
      
      
      
      // Date and time are stored separately and not in a format easy to convert
      // Together stored as MM-DD-YYYY HH:MM(am/pm)
      // First break up the date and time into parts

      
      if (StringFind(columns[3],"am")!=-1 || StringFind(columns[3],"pm")!=-1) {
            // if column 4 contains am or pm - it is time! then it is coming from the web
            StringSplit(columns[2], '-', dateParts);
            StringSplit(columns[3], ':', timeParts);
      
            // Conver am/pm to 24h: 12 should bee converted to 00
            if (timeParts[0] == "12") {
               timeParts[0]   =  "00";
            }
            
            // If pm, just add 12 hrs
            if (StringSubstr(timeParts[1], 2, 1) == "p") {
               timeParts[0]   =  IntegerToString(StringToInteger(timeParts[0])+12);
            }
            
            // take only the first 2 characters from the minutes, i.e., remove the am/pm part
            timeParts[1]   =  StringSubstr(timeParts[1], 0, 2);
            
            // Join it back together as YYYY.MM.DD HH:MM
            string   timeString  =  dateParts[2] + "." + dateParts[0] + "." + dateParts[1]
                                                 + " "
                                                 + timeParts[0] + ":" + timeParts[1];
            Events[i].time =  StringToTime(timeString); // GMT Time
            
            // Value in forecast and previous may be in different formats
            // therefore saving it as string
            Events[i].impact  =  columns[4];
            Events[i].forecast   =  columns[5];
            Events[i].previous   =  columns[6];  
       }
      else {
         // Date time is already in proper format - it is coming from the previously saved file
         Events[i].time = StringToTime(columns[2]);
         Events[i].impact  =  columns[3];
         Events[i].forecast   =  columns[4];
         Events[i].previous   =  columns[5];
      }      
            
      
       
                                
   } // for
   // Parsing is done

      return true;
}



bool CFFNewsCalendar::SaveNewsToFiles() {

   // 1) first save entire content of Events[] array into a AllNews.csv
   // this is needed for further cross-checks, like: if each opened chart (that is present in AllNews.csv) also has
   // corresponding .csv file
   string filePath = Path() + "\\" + AllNewsFileName;     
   int handle = FileOpen(filePath, FILE_WRITE | FILE_CSV);
   if (handle==INVALID_HANDLE) {
      mError = GetLastError();
      PrintFormat("%s error %i opening file %s", __FUNCTION__, mError, filePath);
      return false;
   }
   FileWriteString(handle,"",0);
   FileWriteString(handle,"Title,Country,Date,Time,Impact,Forecast,Previous" + "\n");
    
   // for each event - writing a line into file
   for (int n=0; n<ArraySize(Events); n++) {
      // Convert GMT time to Broker Server Time, so it will later correctly display on the chart
      Events[n].time = Events[n].time + this.BrokerTimeZone*3600;
         
      FileWriteString(handle,Events[n].title + "," + Events[n].country 
      + "," + TimeToString(Events[n].time)
      + "," + Events[n].impact 
      + "," + Events[n].forecast
      + "," + Events[n].previous
      + "\n",0);
    }
   
   FileFlush(handle);
   FileClose(handle);
         
         
         

   // 2) saving result (Events[] array) to files - 1 file for each open chart
      int count=0;
      long chartid=ChartFirst();
      string  ChartSymbols[];
      
      // form array of symbols of open charts 
      do
        {
         ArrayResize(ChartSymbols, ArraySize(ChartSymbols)+1);
         ChartSymbols[count] = ChartSymbol(chartid);
         //Print("New symbol: " + ChartSymbol(chartid));
         
         chartid=ChartNext(chartid);
         count++;
        }
      while(chartid!=-1);
      
      // cycle through the each open chart (symbols in the array)
      for (int i = 0; i < ArraySize(ChartSymbols); i++) {
         // cycle through all the news array (Events)
         CalendarEvent EventsForChart[];
         for (int y = 0; y < ArraySize(Events); y++) {
            // find all news in the Events array that are relevant to this chart
            
            //if (ChartSymbols[i] == "SPX500") Print("Checking relevance for SPX500");
            
            if (IsCountryRelevantToSymbol(Events[y].country,ChartSymbols[i])) {
               // form chart-specific array of Events
               // if (IsImpactRelevant(Events[y].impact)) { // selecting only impact level set in settings -> this condition is moved to MetaTools
               // thus, we save news of any impact 
                  ArrayResize(EventsForChart,ArraySize(EventsForChart)+1);
                  EventsForChart[ArraySize(EventsForChart)-1] = Events[y];
               //}
            }
         }
         
         Print("News found for " + ChartSymbols[i] + ": " + IntegerToString(ArraySize(EventsForChart)));
                      
                
         // recording all the news for this symbol into separate chart-dedicated csv file  
         //filePath = Path() + "\\" + ChartSymbols[i] + ".csv";   
         filePath = FilePathBySymbol(ChartSymbols[i]);  
             
         handle = FileOpen(filePath, FILE_WRITE | FILE_CSV);
         if (handle==INVALID_HANDLE) {
            mError = GetLastError();
            PrintFormat("%s error %i opening file %s", __FUNCTION__, mError, filePath);
            return false;
         }
         FileWriteString(handle,"",0);
         FileWriteString(handle,"Title,Country,Date,Time,Impact,Forecast,Previous" + "\n");
          
         // for each event - writing a line into file
         for (int n=0; n<ArraySize(EventsForChart); n++) {
            //PrintFormat("Title=%s, Country=%s, Date=%s, Impact=%s, Forecast=%s, Previous=%s",
            //            EventsForChart[n].title,
            //            EventsForChart[n].country,
            //            TimeToString(EventsForChart[n].time),
            //            EventsForChart[n].impact,
            //            EventsForChart[n].forecast,
            //            EventsForChart[n].previous);
            
            // Convert GMT time to Broker Server Time, so it will later correctly display on the chart

            //Print("Adding time shift");
            #ifdef PROGRAM_TYPE
               //Print("Adding time shift to: " + EventsForChart[n].time);
               //EventsForChart[n].time = EventsForChart[n].time + this.BrokerTimeZone*3600;
               //Print("New time is: " + EventsForChart[n].time);
            #endif 
               
            FileWriteString(handle,EventsForChart[n].title + "," + EventsForChart[n].country 
            + "," + TimeToString(EventsForChart[n].time)
            + "," + EventsForChart[n].impact 
            + "," + EventsForChart[n].forecast
            + "," + EventsForChart[n].previous
            + "\n",0);
          }
         
         FileFlush(handle);
         FileClose(handle);
                           
      } // for through each open chart
      return true;
}


string CFFNewsCalendar::FilePathBySymbol(string symbol) {

   return Path() + "\\" + symbol + ".csv"; 

}



bool CFFNewsCalendar::IsImpactRelevant(NewsImpact news_impact_setting, string impact) {
   // compare the impact to the Properly News_Impact which is set externally
   // news_impact_setting - value set by user in settings
   // impact - impact of the news being processed
   // impact must be included into (relevant to) News_Impact to return true

   switch(news_impact_setting) {

      case No_News:
         return false;

      case All_Impact:
         return true;
   
      case Low_Impact:
         if (impact == "Low") return true;
         else return false;
      
      case Medium_Impact:
         if (impact == "Medium") return true;
         else return false;
      
      case High_Impact:
         if (impact == "High") return true;
         else return false;
      
      case Medium_and_High:
         if (impact == "Medium" || impact == "High") return true;
         else return false;
   
      default:
         return true;
   }

}



bool CFFNewsCalendar::IsCountryRelevantToSymbol(string country, string symbol) {
   // country - name of the currency indicated in the news
   // symbol  - name of the chart symbol in the terminal

   if (StringFind(symbol,country) != -1)
      return true;
   else {
   
      if (country == "USD" && (isCRYPTO(symbol) || isDOGECOIN(symbol) || isSOLANA(symbol) || isOIL(symbol) || symbol == "SPX500" || symbol == "NQ100" ) )
         // if country symbol is not found in the name of the symbol, but country is 'USD', 
         // then still consider that country is relevant to the symbol
         // because it is likely that the symbol is in this case a crypto or an index
         return true;
      else 
         return false;  
   }
}



bool CFFNewsCalendar::OpenChartsWithoutNewsFile() {
   // this function is to be able to detect, if there were any new charts opened since last update of the news. 
   // if such chart is open, then it means it doesn't yet have .csv file with list of news
   // it means we will need to reload all the news for all open charts
   
   // How to tell, if there is an open chart with, but it doesn't have corrensponding .csv file?
   // - if symbol of that open chart exists among symbols in AllNews.csv AND does NOT exist as a dedicated .csv file in the News folder 

   
   // this function returns TRUE if there is at least one open chart in the terminal (that exist in AllNews.csv) but that
   // doesn't have corresponding CSV file



   // Cycle though each open chart.....
   // 2) Then return TRUE - to trigger news refresh and re-creation of all the files


   // 1) Reading and parsing all the news from the master .csv file
   if (!this.LoadNewsFromFile(mPath+"\\"+AllNewsFileName))
      return true; // reading was not successful, assuming there is no AllNews file yet - reload of nwes is required!
   // Now all news are in the Events[] array, type of elements in this array is CalendarEvent
   
   // 2) Forming string array of chart symbols 'ChartSymbols' that are now open in terminal
   int count=0;
   long chartid=ChartFirst();
   string OpenSymbols[];
   do
     {
      ArrayResize(OpenSymbols, ArraySize(OpenSymbols)+1);
      OpenSymbols[count] = ChartSymbol(chartid);      
      chartid=ChartNext(chartid);
      count++;
     }
   while(chartid!=-1);
   // Now symbol names of all the charts open in terminal are in the string array OpenSymbols[]
   
   
   
   // 3) Cycle though all the symbols (open charts) in OpenSymbols[]
   for (int i = 0; i < ArraySize(OpenSymbols); i++) {
      // for each open chart - check, if its symbol exists in the Events[] array (in the country field)
      // cycle through all the events in the Events[] array
      for (int y = 0; y < ArraySize(Events); y++) {
         if ( IsCountryRelevantToSymbol(Events[y].country,OpenSymbols[i])) {
            // .country of this event is found in this name of this opened chart
            // now, checking, if this opened chart has its corresponding news .csv file
            if (!IsChartNewsFileExists(OpenSymbols[i])) {
               // we found an open chart, which has some news in the AllNews file, 
               // but for which .csv file does not exist - returning true (signaling that all news must be refreshed
               // and thereby hopefully the news file for this open chart will be created
               Print("Opened chart '" + OpenSymbols[i] + "' does NOT have a news .csv file! Reloading news...");
               return true;
            }
         }
      }
   }
   // no open charts without .csv file found - no need to reload news now
   return false;
}

bool CFFNewsCalendar::IsChartNewsFileExists(string symbol) {

   string filepath = FilePathBySymbol(symbol);
   if (FileIsExist(filepath)) 
      return true;
   else
      return false;

}


bool CFFNewsCalendar::NewsOutdated() {

   string   filename; // name of the first file in the News folder - it can be any file
   // Searching for the first file in "MQL4\Files\News\"
   long     handle         = FileFindFirst(mPath+"\\*",filename);
   if(handle == INVALID_HANDLE) {
      Print("Couldn't find the first news file in " + mPath);
      return true; // assuming that if no first file is found - there are no files in this folder - so, we should update the news
   }
   FileFindClose(handle);
      
   // file name of the first file is found
   datetime LastEdit       = (datetime)FileGetInteger(mPath+"\\"+filename,FILE_MODIFY_DATE);
   
   //Print("First news file found in '" + mPath + "' is '" + filename + "', Last Edit: " + TimeToString(LastEdit));
   
   
   double HrsSinceLastEdit = double( (TimeLocal() - LastEdit) / 3600);
   //Print("HrsSinceLastEdit = " + DoubleToString(HrsSinceLastEdit,2));
   if ( HrsSinceLastEdit < 12 ) {
      FileClose((int)handle);
      return false; // news is not yet out of date
   }
   // the first found news file is out of date - deleting it
   FileDelete(mPath+"\\"+filename);
   FileClose((int)handle);
   
   return true;

}



bool CFFNewsCalendar::LoadNewsFromFile(string filepath = "") {

   // 1. search for file with the same name as current symbol in the Files\News folder (if filepath is not specified)
   // 2. read its content into NewsRawCSV string variable
   // 3. parse it into Events structure array
   
   if (filepath == "")
      filepath = Path() + "\\" + _Symbol + ".csv";
   
   int      handle   = FileOpen(filepath,FILE_READ);
   if(handle == INVALID_HANDLE) {
      Print("Couldn't read the news file");
      return false;
   }
   
   //Print("News file " + filepath + " found!");
   
   // read file into events[] array
   
   NewsRawCSV = "";
   while(!FileIsEnding(handle)) {
      NewsRawCSV = NewsRawCSV + FileReadString(handle) + "\n";
   }
   
   FileClose(handle);
   
   ParseNewsRawCSV(); // NewsRawCSV -> Events[] array
   
   return true;
}




void CFFNewsCalendar::DrawNewsOnChart(long chartid, NewsImpact news_impact_setting) {

   if (_Period != PERIOD_H1 && _Period != PERIOD_M30 && _Period != PERIOD_M15 && _Period != PERIOD_M5 && _Period != PERIOD_M1) return;

   // TASK: make this function abstract for a Chart ID !!!!

   // drawing news on the chart with ID = chartid

   // assuming that NewsDownloader.Events[] is already updated with news relevant for this chart
      
   // first delete all the news marks (just in case user changes settings to display less news
   // E.g., user selected to show only High impact news now. Then we need to make sure that e.g. Medium impact news will be deleted, if they were drawn earlier
   int n = 0;
   
   // Delete previously visualized news
   for (int i=0; i < ArraySize(this.Events); i++) {
      string name = this.GetNewsMarkName(this.Events[i].title, this.Events[i].time);
      ObjectDeleteSilent(chartid, name);
      ObjectDeleteSilent(chartid, name + " solid");
      n++;
   }
   //Print("News marks deleted: " + IntegerToString(n));
   
   // declare array for names of all news
   string EventNames[100]; // assuming number of events per symbol will never reach 100; decided not to use dynamic array due its potential slow performance
   short EventNameIndex = 0;
   
   string ShiftedNews[2]; // news one time of which is shifted and therefore should not be shifted again
   
   
   double WindPriceMin = 0;
   double WindPriceMax = 0;
   ChartID_Last_14_Days_MinMax(chartid, WindPriceMin, WindPriceMax);
   
   
   // for each news: 1) check if it is relevant by Impact (vs user settings) and then 2) display it
   for (int i=0; i < ArraySize(this.Events); i++) {
         //Print("checking impact for " + this.Events[i].impact);
         if (!this.IsImpactRelevant(news_impact_setting, this.Events[i].impact)) continue;
         // create a vertical line on the chart for this found news
         string name = this.GetNewsMarkName(this.Events[i].title, this.Events[i].time);
         EventNames[EventNameIndex] = name;
         EventNameIndex++;
         
         datetime time = this.Events[i].time;

         double price1, price2;
         this.GetPricesForNewsMarks(chartid, this.Events[i].time, price1, price2);
         ObjectCreate(chartid,name,OBJ_TREND,0,time,price1,time,price2);
         ObjectSetInteger(chartid,name,OBJPROP_RAY,0);
         ObjectSetInteger(chartid,name,OBJPROP_WIDTH,1);
         ObjectSetInteger(chartid,name,OBJPROP_STYLE,STYLE_DOT);
         ObjectSetInteger(chartid,name,OBJPROP_SELECTED,0);
         
         // ***   creating solid part of the line ****
         string solid_line_name = name + " solid";
         if (IsDistAboveMoreThanDistBelow(chartid, time)) {
            //Print(1);
            double price2_solid = price1 - (WindPriceMax - WindPriceMin) * 0.03;
            ObjectCreate(chartid, solid_line_name,OBJ_TREND,0,time,price1,time,price2_solid);
         }
         else {
            //Print(0);
            double price2_solid = price1 + (WindPriceMax - WindPriceMin) * 0.03;
            ObjectCreate(chartid, solid_line_name,OBJ_TREND,0,time,price1,time,price2_solid);
         }
         ObjectSetInteger(chartid,solid_line_name,OBJPROP_RAY,0);
         ObjectSetInteger(chartid,solid_line_name,OBJPROP_WIDTH,1);
         ObjectSetInteger(chartid,solid_line_name,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSetInteger(chartid,solid_line_name,OBJPROP_SELECTED,0);
         ObjectSetMQL4(solid_line_name, OBJPROP_TIMEFRAMES, OBJ_PERIOD_H1 | OBJ_PERIOD_M30 | OBJ_PERIOD_M15 | OBJ_PERIOD_M5 | OBJ_PERIOD_M1);
         // *** END OF CREATING SOLID PART OF THE LINE ****
         
         
         string hrs = IntegerToString(TimeHour(this.Events[i].time));
         if (TimeHour(this.Events[i].time) < 10) hrs = "0" + hrs;
         string min = IntegerToString(TimeMinute(this.Events[i].time));
         if (TimeMinute(this.Events[i].time) < 10) min = "0" + min;
         
         string s_descr = hrs + ":" + min;
         s_descr = s_descr + " | " + this.Events[i].country + " | " + this.Events[i].title + " | " + this.Events[i].impact;
         ObjectSetString(chartid,name,OBJPROP_TEXT,s_descr);
         ObjectSetText(name,s_descr,14);
         if (this.Events[i].impact == "High") {
            ObjectSetInteger(chartid,name,OBJPROP_COLOR,clrRed);
            ObjectSetInteger(chartid,solid_line_name,OBJPROP_COLOR,clrRed);
         }
         else if (this.Events[i].impact == "Medium") {
            ObjectSetInteger(chartid,name,OBJPROP_COLOR,clrOrange);
            ObjectSetInteger(chartid,solid_line_name,OBJPROP_COLOR,clrOrange);
         }
         else if (this.Events[i].impact == "Low") {
            ObjectSetInteger(chartid,name,OBJPROP_COLOR,clrGray);
            ObjectSetInteger(chartid,solid_line_name,OBJPROP_COLOR,clrGray);
         }
         ObjectSetMQL4(name, OBJPROP_TIMEFRAMES, OBJ_PERIOD_H1 | OBJ_PERIOD_M30 | OBJ_PERIOD_M15 | OBJ_PERIOD_M5 | OBJ_PERIOD_M1);
   }
   // ** FINISHED drawing all event marks on the chart ***** 
   
   // cycle through all events (using array of names EventNames[])
   // and counting how many events are placed on the same hour bar
   // shifting marks for hours with more than 1 event
   for (int i = 0; i < ArraySize(EventNames); i++) {
      ShiftedNews[0] = "";
      ShiftedNews[1] = "";
      // checking if this news is already shifted (present in the ShiftedNews array)
      bool already_shifted = false;
      for (int r=0; r < ArraySize(ShiftedNews); r++) {
         if (ShiftedNews[r] == EventNames[i]) {
            already_shifted = true;
            break;
         }
      }
      if (already_shifted) continue; // do not shift already shifted news
      
      
      if (EventNames[i] == "") break; // if this is the end of the array
      // cycle though all the array recursively - to check if time of the i-event is the same (hour) as y-event
      short count = 1; // counting how many news are on the same hour
      string OverlappingNews[3]; // names of the overlapping news
      OverlappingNews[0] = EventNames[i]; // current news is the first one
      // searching for more, max two more 
      for (int y = 0; y < ArraySize(EventNames); y++) {
         if (EventNames[i] == EventNames[y])
            continue; // if this is the name event - skip - do not count it
         else {
            datetime time_i = (datetime)ObjectGetInteger(chartid,EventNames[i],OBJPROP_TIME1);
            datetime time_y = (datetime)ObjectGetInteger(chartid,EventNames[y],OBJPROP_TIME1);
            bool same_hr    = TimeHour(time_i) == TimeHour(time_y);
            bool same_day   = TimeDay(time_i) == TimeDay(time_y);
            bool same_month = TimeMonth(time_i) == TimeMonth(time_y);
            if (same_hr && same_day && same_month) {
               OverlappingNews[count] = EventNames[y];
               count++;
               if (count == 3)
                  break; // 3rd news on the same time is found - this is max
            }
         }
      }
      // now we know that there is 'count' news on the same hour, incl. this current news 'i'
      
      if (count > 1) {
         datetime NewsTime = (datetime)ObjectGetInteger(chartid, EventNames[i],OBJPROP_TIME1);
         bool DistAboveMoreThanDistBelow = IsDistAboveMoreThanDistBelow(chartid, NewsTime);
         datetime time_current = (datetime)ObjectGetInteger(chartid,OverlappingNews[0],OBJPROP_TIME1);
         // two or three news on the same hour
         if (DistAboveMoreThanDistBelow) { //
            // shifting Price1 of two first news
            ObjectSetInteger(chartid,OverlappingNews[0],OBJPROP_TIME2,time_current+HR1);
            ObjectSetInteger(chartid,OverlappingNews[1],OBJPROP_TIME2,time_current-HR1);
         }
         else {
            // shifting Price2 of two first news
            ObjectSetInteger(chartid,OverlappingNews[0],OBJPROP_TIME2,time_current+HR1);
            ObjectSetInteger(chartid,OverlappingNews[1],OBJPROP_TIME2,time_current-HR1);
         }
         // add these two shifted news into the array ShiftedNews; not to shift it again
         ArrayResize(ShiftedNews, ArraySize(ShiftedNews)+2);
         ShiftedNews[0] = OverlappingNews[0];
         ShiftedNews[1] = OverlappingNews[1];
         if (count == 3)
            ShiftedNews[2] = OverlappingNews[2];
      }
   }
}



string CFFNewsCalendar::GetNewsMarkName(string EventTitle, datetime EventTime) {

   return this.MarkNamePrefix + " " + StringSubstr(EventTitle,0,20) + "... | " + TimeToString(EventTime);

}

void CFFNewsCalendar::GetPricesForNewsMarks(long chartid, datetime NewsTime, double &price1, double &price2) {

   string symbol = ChartSymbol(chartid);
   
   int D1_Bar_Index = iBarShift(symbol,PERIOD_D1,NewsTime);
   
   double day_high = iHigh(symbol,PERIOD_D1,D1_Bar_Index);
   double day_low  = iLow(symbol,PERIOD_D1,D1_Bar_Index);
   

   double WindPriceMin = 0;
   double WindPriceMax = 0;
   ChartID_Last_14_Days_MinMax(chartid, WindPriceMin, WindPriceMax);
   
   if (IsDistAboveMoreThanDistBelow(chartid, NewsTime)) {
      // high of this day is lower than 1/2 of the screen -> drawing marks above the day high
      price1 = day_high + (WindPriceMax - WindPriceMin) * 0.05; // dist from day high
      price2 = price1 + (WindPriceMax - WindPriceMin) * 0.04;   // size of the mark
   }   
   else {
      // -> drawing marks below the day low
      price1 = day_low - (WindPriceMax - WindPriceMin) * 0.05; // dist from day low
      price2 = price1 - (WindPriceMax - WindPriceMin) * 0.04;  // size of the mark
   }
}


bool CFFNewsCalendar::IsDistAboveMoreThanDistBelow(long chartid, datetime NewsTime) {

   double WindPriceMin = 0;
   double WindPriceMax = 0;
   string symbol = ChartSymbol(chartid);
   
   ChartID_Last_14_Days_MinMax(chartid, WindPriceMin, WindPriceMax);

   int D1_Bar_Index = iBarShift(symbol,PERIOD_D1,NewsTime);
   
   double day_high = iHigh(symbol,PERIOD_D1,D1_Bar_Index);
   double day_low  = iLow(symbol,PERIOD_D1,D1_Bar_Index);

   double dist_above = WindPriceMax - day_high;
   double dist_below = day_low - WindPriceMin;

   if (dist_above >= dist_below) 
      return true;
   else
      return false;
}



int CFFNewsCalendar::DeleteAllNewsMarksOnChart(long chartid) {

   int obj_total=ObjectsTotal(chartid); //total objects count
   string name = "";
   int n=0; // counting how many marks deleted
   for(int i = obj_total; i >= 0; i--) 
     { // for each object on the chart
      name = ObjectName(chartid,i);    // getting the object name
      if(StringFind(name,CFFNewsCalendar::MarkNamePrefix) != -1) {    
            ObjectDeleteSilent(chartid,name);
            n++;
        }
     }
   return n;
}



void CFFNewsCalendar::DeleteAllNewsMarksOnAllCharts() {

   long     currChartID=ChartFirst();
   int      NewsMarksDeleted = 0;
   int      ChartsScanned = 0;
   short    i = 0;
   while(i < 99) {
      NewsMarksDeleted = NewsMarksDeleted + DeleteAllNewsMarksOnChart(currChartID);
      i++; 
      ChartsScanned++;
      currChartID = ChartNext(currChartID);
      if(currChartID < 0)  break;
   }
   
   EventChartCustom(ChartFirst(),UPDATE_NEWS,0,0,""); // sending command to the first chart to reload all news
   Print("Charts scanned: " + IntegerToString(ChartsScanned) + " | News marks deleted: " + IntegerToString(NewsMarksDeleted));
}

