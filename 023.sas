libname dt "/home/hui.gong/SASUSER";

/************* Descriptive Statistics ******************/
*** Function: Row Calculation;
*** Calculation of Columns;
proc means data=dt.survey mean;
	var item1 item2 item10-item18;
run;
proc means data=dt.survey mean median max;
	var item:;
run;
* Defaul;
proc means data=dt.survey;
	var item:;
run;
* Limit Decimals;
proc means data=dt.survey maxdec=2;
	var item:;
run;

***** HW5;
data state5;
	infile "/home/hui.gong/Stat363/HW5-States.txt" 
		dlm ="#" firstobs=2;
	input Order State : $20. Admission : anydtdte20.;
	format Admission date9.;
run;
* Find How Many States Were Admitted Each Month;
data state5;
set state5;
	month = month(admission);
run;
* A More Effecient;
data state5;
set state5;
	month = month(admission);
	State_Count = 1;
run;
* CLASS Statement;
proc means data=state5 sum maxdec=0;
	class month;
	var state_count;
run;
* BY Statement;
proc sort data=state5;
	by month;
run;
proc means data=state5 sum maxdec=0;
	by month;
	var state_count;
run;

*** PROC SUMMARY
	By Default, No Output Printed;
*** PROC MEANS
	By Default, Always Print Output;
proc summary data=dt.heart maxdex=1 print;
	var arterial heart cardiac urinary;
run;


*** Another Efficient Way;
* A More Effecient;
data state5;
set state5;
	month = month(admission);
run;
proc freq data=state5;
tables month ;
run;


proc freq data=dt.diabetes;
tables height;
run;
proc freq data=dt.diabetes;
tables weight;
run;
* Two-Way Table;
proc freq data=dt.diabetes;
tables height * weight;
run;

proc format;
	value wtfmt low-139="<140"
				140-180="140-180"
				181-high=">180";
	value htfmt low-64="<5'5"
				65-70="5'5-5'10"
				71-high=">5'10";
run;
proc freq data=dt.diabetes;
tables height * weight;
format height htfmt. weight wtfmt.;
run;

proc freq data=dt.diabetes;
tables height * weight / list;
format height htfmt. weight wtfmt.;
run;

*** Three-Way Table;
proc freq data=dt.diabetes;
tables sex*height * weight;
format height htfmt. weight wtfmt.;
run;
proc freq data=dt.diabetes;
tables sex*height * weight 
	/ nofreq nopercent norow nocol;
format height htfmt. weight wtfmt.;
run;