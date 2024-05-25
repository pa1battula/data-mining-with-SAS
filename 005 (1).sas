libname dt "/home/hui.gong/SASUSER";
libname ds "/home/hui.gong/sasuser.v94";

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




*********** Sort;
* Without out=, the original dataset will be sorted;
* Missing value is treated as smallest value;
proc sort data=dt.admit out=admit2;
	by age;
run;

proc sort data=admit2;
	by age height;
run;

proc sort data=admit2;
	by descending age;
run;

proc sort data=admit2;
	by descending age height;
run;

proc sort data=admit2;
	by descending age descending height descending weight;
run;

******* Calculation;
proc print data=dt.admit;
run;
proc print data=dt.admit;
	sum fee;
run;

* If by statement is needed to use,
	proc sort first;
proc sort data=dt.admit out=admit2;
	by sex;
run;
proc print data=admit2;
	sum fee;
	by sex;
run;

proc sort data=dt.admit out=admit2;
	by descending sex;
run;
proc print data=admit2;
	sum fee;
	by descending sex;
run;

******* Title and Footnote;
title1 "Hospital Cost";
title2 "Sorted by Sex";
footnote1 "Source from Health Dept";
proc sort data=dt.admit out=admit2;
	by sex;
run;
proc print data=admit2;
	sum fee;
	by sex;
run;

*** Remove Title and Footnote;
title;
footnote;

*** Label;
*   Temperary Label;
proc print data=dt.admit label;
	label actlevel = "Activty Level Based on %";
run;

* Permanent Lable;
data admit2;
	set dt.admit;
	label actlevel = "Activty Level Based on %";
run;
proc print data=admit2 label;
run;

proc print data=dt.admit label;
	label actlevel = "Activty Level Based on %";
	label height = "Height in Inch";
	label weight = "Weight in Pound";
run;
* OR;
proc print data=dt.admit label;
		label actlevel = "Activty Level Based on %"
				height = "Height in Inch"
				weight = "Weight in Pound";
run;

****** Format;
* Temperary: PROC PRINT;
* Permanent: DATA;
* Doesn't Change the value, but only the appearance;
proc print data=dt.salary;
	format wagerate dollar15.2;
run;
data salary;
	set dt.salary;
	format wagerate dollar15.2;
run;

data zip;
	input zipcode;
cards;
01275
09871
;
run;
data zip;
	set zip;
	Zip = put(zipcode, z5.);
run;


