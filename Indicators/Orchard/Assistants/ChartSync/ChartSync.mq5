//+------------------------------------------------------------------+
//|                                                    ChartSync.mq5 |
//|                               Copyright 2013-2020, Orchard Forex |
//|                                         https://orchardforex.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013-2020, Orchard Forex"
#property link      "https://orchardforex.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

string	CurrentSymbol;
string	GvPart	=	"ChartSync";
int		GvLen		=	StringLen(GvPart);

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

	GetCurrentSymbol3();
	if (Symbol()!=CurrentSymbol) {
		SwitchCharts(CurrentSymbol, Symbol());
	}
   
//---
   return(INIT_SUCCEEDED);
  }
  
void OnDeinit(const int reason)
  {
  
  	SetCurrentSymbol3(Symbol());
   
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---

   
  }
//+------------------------------------------------------------------+


void	SwitchCharts(string oldSymbol, string newSymbol) {

	for (long id=ChartFirst(); id>=0; id=ChartNext(id)) {
		if (ChartSymbol(id)==oldSymbol) {
			PrintFormat("ChartSync switching chart %s(%s) to %s", ChartSymbol(id), EnumToString(ChartPeriod(id)), newSymbol);
			ChartSetSymbolPeriod(id, newSymbol, ChartPeriod(id));
		}
	}
	SetCurrentSymbol3(newSymbol);
	
}

void	SetCurrentSymbol3(string newSymbol) {

	string	gvName		=	GvPart + "_" + newSymbol;
	double	chartID		=	(double)ChartID();
	long		chartCheck	=	-1;
	GlobalVariableSet(gvName, chartID);
	int		cnt			=	GlobalVariablesTotal();
	for (int i = cnt-1; i>=0; i--) {
		if (GlobalVariableName(i)!=gvName && StringSubstr(GlobalVariableName(i), 0, GvLen)==GvPart && GlobalVariableGet(GlobalVariableName(i))==chartID) {
			GlobalVariableDel(GlobalVariableName(i));
		}
	}
	
}

void	GetCurrentSymbol3() {

	double	chartID		=	(double)ChartID();
	int		cnt			=	GlobalVariablesTotal();

	for (int i = cnt-1; i>=0; i--) {
		if (StringSubstr(GlobalVariableName(i), 0, GvLen)==GvPart && GlobalVariableGet(GlobalVariableName(i))==chartID) {
			CurrentSymbol	=	StringSubstr(GlobalVariableName(i), GvLen+1);
			return;
		}
	}
	
	CurrentSymbol	=	Symbol();
	
	return;

}

//void	SetCurrentSymbol2(string newSymbol) {
//
//	int	cnt	=	SymbolsTotal(false);
//	for (int i = 0; i<cnt; i++) {
//		if (SymbolName(i, false)==newSymbol) {
//			GlobalVariableSet("ChartSync", i);
//			return;
//		}
//	}
//	
//}
//
//void	GetCurrentSymbol2() {
//
//	int	cnt		=	(int)GlobalVariableGet("ChartHopper");
//	CurrentSymbol	=	SymbolName(cnt, false);
//
//}

//void	SetCurrentSymbol(string newSymbol) {
//
//	string objectName	=	"ChartHopper";
//	ObjectDelete(0, objectName);
//	if (newSymbol!="") {
//		ObjectCreate(0, objectName, OBJ_TEXT, 0, Time[0], Bid);
//		ObjectSetString(0, objectName, OBJPROP_TEXT, 0, newSymbol);
//	}
//
//	//if (ObjectFind(0, objectName)) {
//	//	if (newSymbol=="") {
//	//		ObjectDelete(0, objectName);
//	//	} else {
//	//		ObjectSetString(0, objectName, OBJPROP_TEXT, newSymbol);
//	//	}
//	//} else {
//	//	ObjectCreate(0, objectName, OBJ_LABEL, 0, Time[0], Bid);
//		
//	return;
//	
//}
//
//void	GetCurrentSymbol() {
//
//	string objectName	=	"ChartHopper";
//	if (ObjectFind(objectName)) {
//		CurrentSymbol	=	ObjectGetString(0, objectName, OBJPROP_TEXT);
//	} else {
//		PrintFormat("Object not found %s", objectName);
//		//CurrentSymbol	=	"";
//	}
//	
//	return;
//	
//}
		
		