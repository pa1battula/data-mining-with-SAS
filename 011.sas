libname dt "/home/hui.gong/SASUSER";

/********************* Date and Time **********************/
*** Read Date and Time as Numerical;
data test;
	input date mmddyy8.; * Informat;
	format date mmddyy8.; * format;
	cards;
10/15/99
;
run;

data test;
	input date date7.;
	cards;
15OCT99
;
run;

data test;
	input date mmddyy8.;
	cards;
10-15-99
;
run;

data test;
	input date mmddyy6.;
	cards;
101599
;
run;

data test;
	input date mmddyy8.;
	cards;
10151999
;
run;

data test;
	input date yymmdd8.;
	cards;
99-10-15
;
run;


data try;
	input time time5.;
	format time time5.;
	cards;
17:00
;
run;

data try;
	input time time11.;
	format time time11.;
	cards;
17:00:01.34
;
run;

*** Informat timew., the minimum w is 5;
data try;
	input time time5.;
	format time time5.;
	cards;
2:34
;
run;



data test;
	input date mmddyy8.;
	format date weekdate25.;
	cards;
10-15-99
;
run;

data test;
	input date mmddyy8.;
	format date worddate25.;
	cards;
10-15-99
;
run;

data test;
	input date mmddyy8.;
	format date date9.;
	cards;
10-15-99
;
run;

data test;
	input date anydtdte20.;
	cards;
October 15, 1999
;
run;


/********* Creating a Single Obervation ************/
/********* 	   from Multiple Records    ************/
data dept;
	infile "/home/hui.gong/Stat363/Raw_Data/Note12-patdata.txt";
	input LName $ FName $;
	input Department $12. JobCode $;
	input Salary : comma12.2;
	format Salary dollar12.2;
run;

*** Controller: /;
*** Readin Must Be Sequentially;
data dept;
	infile "/home/hui.gong/Stat363/Raw_Data/Note12-patdata.txt";
	input LName $ FName $ / Department $12.
			JobCode $ / Salary : comma12.2;
run;

*** Controller: #;
*** Readin Can Be Unsequentially;
data dept;
	infile "/home/hui.gong/Stat363/Raw_Data/Note12-patdata.txt";
	input #1 LName $ FName $ #2 Department $12.
			JobCode $
			#3 Salary : comma12.2;
run;

data dept;
	infile "/home/hui.gong/Stat363/Raw_Data/Note12-patdata.txt";
	input #2 Department $12. JobCode $
			#3 Salary : comma12.2
			#1 LName $ FName $;
run;

data dept;
	infile "/home/hui.gong/Stat363/Raw_Data/Note12-patdata.txt";
	input #2 JobCode $ 15-19
			#1 LName $ FName $
			#2 Department $12.
			#3 Salary : comma12.2;
run;


data dept;
	infile "/home/hui.gong/Stat363/Raw_Data/Note12-patdata.txt";
	input LName $ FName $ / Department $12.
		#3 Salary : comma12.2;
run;



data memdata;
	infile "/home/hui.gong/Stat363/Raw_Data/Note12-memdata.txt";
	input #1 FName $ LName $
		  #2 Address & : $25.
		  #3 City & : $15. State $ Zip $;
run;

