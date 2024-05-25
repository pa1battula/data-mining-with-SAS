libname dt "/home/hui.gong/SASUSER";
libname ds "/home/hui.gong/sasuser.v94";

*** Description Part;
proc contents data=dt.admit; * Alphabetical Order;
run;
proc datasets;
	contents data=dt.admit;
run;

proc contents data=dt.admit varnum; * Logical Order of Variables;
run;
proc datasets;
	contents data=dt.admit varnum;
run;

* Show All Datasets In The Library;
proc contents data=dt._all_;
run;
proc datasets;
	contents data=dt._all_;
run;

* Show All Datasets In The Library, But No Detail;
proc contents data=dt._all_ nods;
run;
proc datasets;
	contents data=dt._all_ nods;
run;


*** Delete a Dataset;
data test;
	set dt.admit;
run;
proc datasets;
	delete test;
run;


*** System Options;
options nodate nonumber; * Remove Date and Page Number on the
	result window;
options date number;

options pageno=100; * Reset Page Number;

options pagesize = 15; * Define the Number of Lines of Each
	Page on the Result window;

options linesize = 60; * Define the Number of Columns of 
	Each Page on the Result window;

*** Options Yearcutoff=;
*** OnDemand: 1940-2039;
data test;
	date_1 = "01Jan39"d;
	date_2 = "01Jan40"d;
run;
proc print data=test;
format date_1 mmddyy10. date_2 date9.;
run;

options yearcutoff = 1950;  * 1950-2049;
proc print data=test;
format date_1 date_2 date9.;
run;

proc print data=dt.admit;
run;
options firstobs=2 obs=5; *Global options;
proc print data=dt.admit;
run;
proc print data=dt.admit(firstobs=3 obs=10);  *Local options;
run;
proc print data=dt.acities;
run;

options firstobs=1 obs=max; * Reset;

*** Syntax Error;
proc prin data=dt.admit; * Misspell;
run;

proc print data=dt.admit * Missing semicolon
run;

proc print data=dt.admit; * Unbalanced Quotation Marks;
where sex = "M
run;";

proc print data=dt.admit keylabel; * Wrong Options;
run;

*** Comment;
* Use Astrisk;
/* */;

/******************** Examples ***************************/


/********************************************************/

*proc print data=dt.admit;
*run;

** Hot Keys: Ctrl + / for Comment and Uncomment;
proc print data=dt.admit;
run;


********* Print;
proc print data=dt.admit;
run;

proc print data=dt.admit;
	var id age height weight;
run;

proc print data=dt.admit noobs; * Remove Obs;
run; 

proc print data=dt.admit double; * Increase space b/w lines;
run;

proc print data=dt.month;
run;

proc print data=dt.month;
	id id;
run;

*** Select Observations;
options firstobs = 4 obs=10;

data admit2;
	set dt.admit;
	where sex = "M";
run;

data admit2;
	set dt.admit;
	where age > 30;
run;

* >, >=, <, <=, =, ^=;
* gt, ge, lt, le, eq, ne;
data admit2;
	set dt.admit;
	where age >= 30;
run;

* and, or;
* &, |;
data admit2;
	set dt.admit;
	where sex = "M" and age > 30;
run;
data admit2;
	set dt.admit;
	where sex = "M" or age > 30;
run;

* contains;
* ?;
data admit2;
	set dt.admit;
	where name contains "an";
run;

data admit2;
	set dt.admit;
where age < 55;
where sex="M" and height > 60;
where weight > 170;
run;

where state = "IN" or state = "IL" or state = "WI"
		or state = "MI";
where state in ("IN", "IL", "WI", "MI");

where age in (30, 35, 40, 45, 50, 55, 60);


where (age<=55 and heart_rate>70) or area = "A";
where age<=55 and (heart_rate>70 or area = "A");

*** IF;
data admit2;
	set dt.admit;
	if sex = "M";
run;

*** IF vs. Where;
* Where: DATA or PROC, Running Faster;
* If: DATA, Running Slower, Can Create New Variable;

proc print data=dt.admit;
	where sex = "M";
run;
proc print data=dt.admit;
	if sex = "M";
run;

data admit2;
	set dt.admit;
	if age >= 50 then Group = "Senior";
run;
data admit2;
	set dt.admit;
	where age >= 50 then Group = "Senior";
run;