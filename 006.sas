libname dt "/home/hui.gong/SASUSER";

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

******* Calculation: Total and Subtotal;
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


**************** Reading in External File;
*** Column Input;
*** Each Variable's values start at the same column;

filename xyz "/home/hui.gong/Stat363/Raw_Data/Note07-tmill.txt";

data stress;
	infile xyz;
	input ID $ 1-4 Name $ 6-25 RestHR 27-29 MaxHR 31-33
		RecHR 35-37 TimeMin 39-40 TimeSec 42-43
		Tolerance $ 45;
run;

filename xyz "/home/hui.gong/Stat363/Raw_Data";
data stress_t;
	infile xyz(Note07-tmill.txt);
	input ID $ 1-4 Name $ 6-25 RestHR 27-29 MaxHR 31-33
		RecHR 35-37 TimeMin 39-40 TimeSec 42-43
		Tolerance $ 45;
run;
data stress_y;
	infile xyz(Note07-ymill.txt);
	input ID $ 1-4 Name $ 6-25 RestHR 27-29 MaxHR 31-33
		RecHR 35-37 TimeMin 39-40 TimeSec 42-43
		Tolerance $ 45;
run;


data stress;
	infile "/home/hui.gong/Stat363/Raw_Data/Note07-tmill.txt";
	input ID $ 1-4 Name $ 6-25 RestHR 27-29 MaxHR 31-33
		RecHR 35-37 TimeMin 39-40 TimeSec 42-43
		Tolerance $ 45;
run;


data stress;
	infile "/home/hui.gong/Stat363/Raw_Data/Note07-tmill.txt"
		firstobs=2;
	input Name $ 6-25 ID $ 1-4 RestHR 27-29 MaxHR 31-33
		RecHR 35-37 TimeMin 39-40 TimeSec 42-43
		Tolerance $ 45 Name $ 6-25;
run;



************************ Output Dataset;
data _null_;
	set stress;
	file "/home/hui.gong/Stat363/006-test.txt";
	put Name $ 6-25 ID $ 1-4 RestHR 27-29 MaxHR 31-33
		RecHR 35-37 TimeMin 39-40 TimeSec 42-43
		Tolerance $ 45;
run;
