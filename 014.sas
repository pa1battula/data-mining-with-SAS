libname dt "/home/hui.gong/SASUSER";

/************* Output to CSV/XLS/XLSX **********/
proc export data = sample
	outfile = "C:/users/STAT363/Sample.csv"
	dbms=csv /* XLS or XLSX */
	replace;
run;

/************* Create and Manage Variables **********/
** Assign A Value to A variabel;
data stress;
	set dt.stress;
	TotalSec = TimeMin * 60 + TimeSec;
	retain Cumulative 5000;
	Cumulative + TotalSec;
run;

*** Create Variable Conditionally;
** If-Then are NOT Mutually Exclusive;
data stress;
	set dt.stress;
	TotalSec = TimeMin * 60 + TimeSec;
	length TestLength $10.;
	if totalsec > 800 then TestLength = "Long";
	if 800 >= totalsec >= 750 then TestLength = "Normal";
	if totalsec < 750 then TestLength = "Short";
run;

** If-Then-Else Are Mutually Exclusive;
data stress;
	set dt.stress;
	TotalSec = TimeMin * 60 + TimeSec;
	length TestLength $10.;
	if totalsec > 800 then TestLength = "Long";
	else if totalsec >= 750 then TestLength = "Normal";
	else TestLength = "Short";
run;

*** Delete Obs;
data stress;
	set stress;
	if tolerance = "I" then delete;
run;

*** Keep or Drop Variables;
* Slowest;
data stress_1;
	set stress;
	keep id name;
run;
* Fastest;
data stress_2;
	set stress(keep=id name);
run;
data stress_3(keep=id name);
	set stress;
run;

*** Assign Labels and Formats;
data stress;
	set stress;
	label RestHR = "Heart Rate when Rest";
	label MaxHR = "Maximal Heart Rate";
	format RestHR comma10.2 MaxHR comma8.3;
run;

*** Remove Labels;
data stress_1;
	set stress;
	label RestHR = '';
run;
* Remove All Labels at Once;
data stress_1;
	set stress;
	attrib _all_ label='';
run;
proc datasets;
	modify stress;
	attrib _all_ label='';
run;

* Remove Format;
data stress_2;
	set stress;
	format RestHR;
run;
* Remove All Formats At Once;
proc datasets;
	modify stress;
	attrib _all_ format=;
run;

*** Group Statements;
data stress;
	set dt.stress;
	TotalSec = timemin * 60 + timesec;
	if totalsec > 800 then TestLength = "Long";
	if totalsec > 800 then Message = "Run Blood Test";
	if totalsec > 800 then Alert = "Alert to Dr";
run;
* Do-End;
data stress;
	set dt.stress;
	TotalSec = timemin * 60 + timesec;
	if totalsec > 800 then do;
		TestLength = "Long";
		Message = "Run Blood Test";
		Alert = "Alert to Dr";
	end;
run;

* Count Observations: _N_;
data stress;
	set dt.stress;
	Count = _N_;
run;

* First and Last Variables;
proc sort data=dt.stress out=stress;
	by tolerance;
run;
data stress;
	set stress;
	by tolerance;
	var_1 = first.tolerance;
	var_2 = last.tolerance;
run;
data stress;
	set stress;
	by tolerance;
	if first.tolerance then Count = 1;
	else count + 1;
run;
data stress_1;
	set stress;
	by tolerance;
	if last.tolerance;
	keep tolerance count;
run;

