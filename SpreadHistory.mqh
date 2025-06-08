#property strict
class CSpreadHistory
  {
private:
   string m_FileName;

public:
                     CSpreadHistory();
                    ~CSpreadHistory();
                    
   bool              LoadSpreadHistoryFromDisk();
   bool              SaveCurrentSpeadToDisk();
   
   double            SpreadArray[];
   double            AvgSpread();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSpreadHistory::CSpreadHistory()
  {
  
  this.m_FileName = "MetaTools_SpreadHistory_" + Symbol() + "_" + IntegerToString(ChartID()) + ".txt";
  
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSpreadHistory::~CSpreadHistory()
  {
  }
//+------------------------------------------------------------------+


bool CSpreadHistory::LoadSpreadHistoryFromDisk() {

   // loads previously saved spread values from file into this.SpreadArray[]

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
	
	ArrayResize(this.SpreadArray,0);
	
	while (!FileIsEnding(fh))
	{
	   string str = FileReadString(fh);
	   if (str != "") { // make sure we do not pick up empty lines
   	   double spread = (double)str;
   	   
         if (spread != 0) { // collect only non zero values
            ArrayResize(SpreadArray,ArraySize(SpreadArray)+1);
            SpreadArray[ArraySize(SpreadArray)-1] = spread;
         }
      }
	}
	
	FileClose(fh);
	
	return true;
}


bool CSpreadHistory::SaveCurrentSpeadToDisk() {

   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(_Symbol ,Latest_Price); // Assign current prices to structure

   double spread = (Latest_Price.ask-Latest_Price.bid)/_Point;

   this.LoadSpreadHistoryFromDisk();
   
   
   // depending on the size of the existing data in the file...
   if (ArraySize(this.SpreadArray) <= 100) {
      // opening the file
   	int fh;
   	fh = FileOpen(m_FileName, FILE_CSV|FILE_READ|FILE_WRITE);
   	if (fh == INVALID_HANDLE)
   	{
   		Print("Failed to open file for writing: " + this.m_FileName + ". Error: " + IntegerToString(GetLastError()));
   		return(false);
   	}
      // going to the end of the file to add new data
      if(FileSeek(fh, 0, SEEK_END)) {
         FileWrite(fh, DoubleToString(spread,0));
      }
   	
   	FileClose(fh);
   	return(true);
	}
	else {
	   // number of historical spreads is more than 100
	   // deleting content of the file
	   int fh = FileOpen(m_FileName, FILE_CSV|FILE_WRITE);
	   if (fh != INVALID_HANDLE) {
	      FileWrite(fh,""); // writing emtpy string
	      FileClose(fh);
	   }
	   else return false;
	   // delete first (oldest) 10 from the array and record this array back to file.
	   fh = FileOpen(m_FileName, FILE_CSV|FILE_READ|FILE_WRITE);
	   for (int i = 10; i < ArraySize(this.SpreadArray); i++) {
	      // return back to the file only last 90 values (in such a way we get rid of the 10 oldest values)
	      FileWrite(fh,this.SpreadArray[i]);
	   }
	   // write the current spread to the end of the file
	   FileWrite(fh, DoubleToString(spread,0));
	   
   	FileClose(fh);
   	return(true);
	}
}


double CSpreadHistory::AvgSpread() {

   // run this.LoadSpreadHistoryFromDisk() first

   if (ArraySize(this.SpreadArray) == 0) return 0;

   double total = 0;

   for (int i = 0; i < ArraySize(this.SpreadArray); i++) {
   
      total = total + this.SpreadArray[i];
   
   }
   double avg_spread = NormalizeDouble(total / ArraySize(this.SpreadArray),1) / 10;
   
   if (IsCommodity()) {
      avg_spread = avg_spread / 10;
   }
   
   return avg_spread;

}