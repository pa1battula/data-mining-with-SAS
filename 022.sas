libname dt "/home/hui.gong/SASUSER";

/********************* ARRAY ***************************/
*** Example: you want to convert the weekday temperature 
	from Fahrenheit to Celsius;
data temp;
	input mon tue wed thr fri sat sun;
cards;
72 68 83 67 71 77 90
;
run;

data temp_2;
	set temp;
	array wkday(7) mon tue wed thr fri sat sun;
	do i = 1 to 7;
		wkday(i) = (wkday(i)-32)*5/9;
	end;
run;

* array sales{4} qtr1 qtr2 qtr3 qtr4;
* array sales{4} qtr1-qtr4;
* array sales{4} qtr96 qtr97 qtr98 qtr99;

data temp_2;
	set temp;
	array wkday(*) mon tue wed thr fri sat sun;
	do i = 1 to dim(wkday);
		wkday(i) = (wkday(i)-32)*5/9;
	end;
run;

data temp_3;
	set temp;
	array wkday(*) mon tue wed thr fri;
	do i = 1 to dim(wkday);
		wkday(i) = (wkday(i)-32)*5/9;
	end;
run;


*** Create Variables;
data temp_4;
	set temp;
	array wkday(*) mon tue wed thr fri sat sun;
	array wkday_c(7);
	do i = 1 to dim(wkday);
		wkday_c(i) = (wkday(i)-32)*5/9;
	end;
drop i;
run;

data temp_4;
	set temp;
	array wkday(*) mon tue wed thr fri sat sun;
	array wkday_c(*) celsius1-celsius7;
	do i = 1 to dim(wkday);
		wkday_c(i) = (wkday(i)-32)*5/9;
	end;
drop i;
run;

*** Character Array;
data city;
	input city1: $15. city2 : $15. city3 : $15.
		city4 : $15.;
cards;
Indianapolis Merriville Portage Valparaiso
;
run;

data city_1;
	set city;
	array city{*} $ city1-city4;
	array city_state{4} $32;
	do i = 1 to 4;
		city_state{i} = trim(city{i})||", "||"Indiana";
	end;
drop i;
run;


*** Assign Initial Values;
* array goal{4} goal1-goal4 (9000 3000 5000 2000);
* array goal{4} goal1-goal4 (9000,3000,5000,2000);
* array color{4} $ ("red", "blue", "orange", "pink");

*** Temporary Array;
data income;
	array base{3} _temporary_ (120, 150, 200);
	array hours{3} _temporary_ (10, 20, 40);
	array salary{3};
	do i = 1 to 3;
		salary{i} = 7.25*hours{i}+base{i};
	end;
drop i;
run;


*** Other Choices;
* array name{*} _numeric_;
* array name{*} _character_;


*** Convert Missing to Zero;
data yourdata;
	set yourdata;
	array change{*} _numeric_;
	do i = 1 to dim(change);
		if change{i} = . then change{i} = 0;
	end;
drop i;
run;



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
proc sort data=state5 out=state6;
	by month;
run;
data state6;
	set state6;
	by month;
	if first.month then Count = 1;
	else Count + 1;
run;
data state6;
set state6;
	by month;
	if last.month;
keep month count;
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
* More Than 1 Class(or By) Variables;
proc means data=dt.heart maxdex=1;
	var arterial heart cardiac urinary;
run;
proc means data=dt.heart maxdex=1;
	class sex;
	var arterial heart cardiac urinary;
run;
proc means data=dt.heart maxdex=1;
	class sex survive;
	var arterial heart cardiac urinary;
run;

*** PROC SUMMARY
	By Default, No Output Printed;
*** PROC MEANS
	By Default, Always Print Output;
proc summary data=dt.heart maxdex=1 print;
	var arterial heart cardiac urinary;
run;