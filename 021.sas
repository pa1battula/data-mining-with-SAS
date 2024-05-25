libname dt "/home/hui.gong/SASUSER";

/******************* DO LOOP ***********************/
*** Example: What's the total value of $1000 
	after one year investment with API 7.5%,
	and the interest will be cumulated monthly?;
data total;
	Principle = 1000;
	Rate = 0.075/12;
	do Month = 1 to 12;
		Earned + (Principle + Earned) * Rate;
	end;
run;

data total;
	Principle = 1000;
	Rate = 0.075/12;
	do Month = 1 to 12;
		Earned + (Principle + Earned) * Rate;
		output;
	end;
run;

*** Increasing;
data test;
	do i = 1 to 10 by 3;
		output;
	end;
run;

*** Decreasing;
data test;
	do i = 10 to 1 by -2;
		output;
	end;
run;

*** Non-equal Increment;
data fibonacci;
	do v = 1, 1, 2, 3, 5, 8, 13, 21;
		y = v/lag(v);
		output;
	end;
run;

*** Character Loop;
data week;
	do day = "Mon", "Tue", "Wed", "Thu", "Fri",
		"Sat", "Sun";
		if day not in ("Sat", "Sun") then Work = "Yes";
		else Work = "No";
		output;
	end;
run;

*** Variable Loop;
data region;
	x1 = "New York";
	x2 = "Michigan";
	x3 = "Gerogia";
	x4 = "Oregon";
	do state = x1, x2, x3, x4;
		if State = x1 then region = "Northeast";
		else if state = x2 then region = "Midwest";
		else if state = x3 then region = "South";
		else if state = x4 then region = "West";
		output;
	end;
drop x1-x4;
run;

*** Nesting Loop;
*** Example: What's the total value 
	after three years investment with API 7.5%,
	and the interest will be cumulated monthly,
	and invest $1000 at the beginning of each year?;
data nest;
	do year = 1 to 3;
		invest + 1000;
		do month = 1 to 12;
			Interest = invest*(0.075/12);
			Invest + Interest;
			output;
		end;
	end;
run;

*** Conditional Loop;
*** Example: Invest $2000 Anually with API 7.5%,
		and Interest Compounded Yearly,
		and Stop Investment When Total Value is $50000;
* UNTIL Condition: Stop Loop When Condition is True;
data invest;
	do until (invest >=50000);
		Invest + 2000;
		Invest + Invest * 0.075;
		Year + 1;
	end;
run;
* WHILE Condition: Stop Loop When Condition is False;
data invest;
	do while (invest < 50000);
		Invest + 2000;
		Invest + Invest * 0.075;
		Year + 1;
	end;
run;

*** Sampling;
data subset;
	do sample = 10 to 50 by 5;
		set existing_dataset point=sample;
		output;
	end;
	stop;
run;



/********************* ARRAY ***************************/
*** Example: you want to convert the weekday temperature 
	from Fahrenheit to Celsius;
data temp;
	input mon tue wed thr fri sat sun;
cards;
72 68 83 67 71 77 90
;
run;

data temp_1;
	set temp;
	Mon = (mon-32)*5/9;
	Tue = (tue-32)*5/9;
	Wed = (wed-32)*5/9;
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



***** HW5;
data state5;
	infile "" dlm ="#" firstobs=2;
	input Order State : $20 Admission : anydtdte20.;
	format Admission date9.;
run;
data state5;
set state5;
	day_diff = intck("day", "04Jul1776"d, Admission);
	yr_diff = intck("year", "04Jul1776"d, Admission);
run;
data state5;
set state5;
	bicen = intnx("year", admission, 200);
run;
data state5;
set state5;
	month = month(admisson);
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

** Q2;
proc sort data=one;
by lname fname;
run;
proc sort data=three;
by lname fname;
run;
data Q21;
	merge one(in=a) three(in=b);
	by lname fname;
	if b;
run;

proc sort data=two;
by lname fname;
run;
data Q22;
	merge one(in=a) two(in=b) three(in=c);
	by lname fname;
	if a and b;
run;

data Q23;
	merge one(in=a) three(in=b);
	by lname fname;
	if b;
	drop major;
run;


		