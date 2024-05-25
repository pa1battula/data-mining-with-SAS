libname dt "/home/hui.gong/SASUSER";

/********************** Modifier ************************/
*** Modifer: &;
*** & Must be Before $ or any Informat;
*** Delimiter Before and After & Must Have At Least 2 Spaces;
*** If Delimiter is Not Space, Don't Need &;
data city;
	infile "/home/hui.gong/Stat363/Raw_Data/Note10-topten_two_blanks.txt";
	length City $15.;
	input Rank City & $ Pop comma.;
run;

*** Modifier : ;
*** Inform SAS to Use Informat;
data city;
	infile "/home/hui.gong/Stat363/Raw_Data/Note10-topten_two_blanks.txt";
	input Rank City & : $15. Pop : comma.;
run;


**** Output;
data _null_;
	set dt.finance;
	file "/home/hui.gong/Stat363/Out_Data/finance.txt";
	put ssn name salary date;
run;

data _null_;
	set dt.finance;
	file "/home/hui.gong/Stat363/Out_Data/finance_1.txt";
	put ssn name salary date : date9.;
run;

data _null_;
	set dt.finance;
	file "/home/hui.gong/Stat363/Out_Data/finance_2.txt";
	put ssn name salary : dollar12. date : date9.;
run;

data _null_;
	set dt.finance;
	file "/home/hui.gong/Stat363/Out_Data/finance_3.txt"
	dlm=",";
	put ssn name salary : dollar12. date : date9.;
run;

data _null_;
	set dt.finance;
	file "/home/hui.gong/Stat363/Out_Data/finance_4.txt"
	dsd;
	put ssn name salary : dollar12. date : date9.;
run;

/********************* Date and Time **********************/
*** Read Date and Time as Numerical;
data test;
	date = "01Jan1960"d;
run;

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



