libname dt "/home/hui.gong/SASUSER";

/*********** Functions *********************/
data one;
	input x y;
cards;
3 6
4 10
;
run;
data one;
	set one;
	my_ave = mean(x, y);
	my_sum = sum(x, y);
run;
data one;
	input x1 x2 x3 x4;
cards;
3 6 9 10
4 10 13 8
;
run;
data one;
	set one;
	my_ave_1 = mean(x1, x2, x3, x4);
	my_ave_2 = mean(of x1-x4);
run;

data one;
	input x_24 x_y x_2143 x_674;
cards;
3 0 9 10
4 10 13 8
;
run;
data one;
	set one;
	my_ave_1 = mean(x_24, x_y, x_2143, x_674);
	my_ave_2 = mean(of x_:);
run;

*** Convert from Character to Numeric;
*   Automatic Convert;
data one;
	input price $ quantity ;
cards;
13.4 10
90.56 5
;
run;
data one;
	set one;
	Sale = price * quantity;
/* 	Sale = input(price, 10.2) * quantity; */
run;
*  Convert with Function: input;
data one;
	input price $ quantity ;
cards;
$13.4 10
$90.56 5
;
run;
data one;
	set one;
	Sale = input(price, comma9.2) * quantity;
run;


*** Convert from Numeric to Character;
*   Automatic Convert;
data one;
	input Num Street $15.;
cards;
123 Main St
456 Maple Ave
;
run;
data one;
	set one;
	Address = Num ||" "|| Street;
run;
*   Convert with Function: put;
data one;
	set one;
	Address = put(num, 3.)||" "||Street;
run;
data two;
	input City : $15. Zip;
cards;
Boston 02108
Valparaiso 46383
;
run;
data two;
	set two;
	Zipcode = put(zip, z5.);
run;

*** Functions for Time and Date;
data one;
	date_1 = today();
	date_2 = date();
	date_3 = time();
	format date_1 mmddyy10. date_2 date9.
		date_3 time20.;
run;
data one;
	set one;
	year = year(date_1);
	month = month(date_1);
run;
data two;
	year = year(50000);
	month = month(50000);
	quater = qtr(50000);
	day = day(50000);
	wkd = weekday(50000);
run;

*** MDY;
data one;
	today = mdy(2, 28, 2024);
run;
data one;
	input month day year;
cards;
11 4 1970
3 18 2001
;
run;
data one;
	set one;
	date=mdy(month, day, year);
	format date mmddyy10.;
run;

*** INTCK;
data one;
	input date_1 mmddyy10. date_2 : mmddyy10.;
cards;
12/31/2000 01/01/2001
;
run;
data one;
	set one;
	diff_1=intck("day", date_1, date_2);
	diff_2=intck("month", date_1, date_2);
	diff_3=intck("qtr", date_1, date_2);
	diff_4=intck("year", date_1, date_2);
run;

*** INTNX;
data one;
	input date_1 : mmddyy10.;
cards;
02/05/1994
;
run;
data one;
	set one;
	date_2 = intnx("month", date_1, 3, "s");
	format date_1 date_2 mmddyy10.;
run;

*** DATDIF;
data test;
	diff = datdif("01Jan2000"d, "02Jan2001"d, "30/360");
run;

*** YRDIF;
data test;
	diff_1 = yrdif("01Jan2000"d, "02Jan2001"d, 
		"30/360");
	diff_2 = yrdif("01Jan2000"d, "02Jan2001"d, 
		"ACT/ACT");
	diff_3 = yrdif("01Jan2000"d, "02Jan2001"d, 
		"ACT/360");
	diff_4 = yrdif("01Jan2000"d, "02Jan2001"d, 
		"ACT/365");
run;

/************** Character Variable ***********/
*** SCAN;
data scan;
	scan_1 = scan("12/16/2009", 2);
	scan_2 = scan("SAS#BASE#Cert", 3, "#");
run;

*** SUBSTR;
data substr;
	substr_1 = substr("12/16/2009", 3, 5);
	substr_2 = substr("SAS#BASE#Cert", 3, 4);
run;

data substr;
	substr_1 = "12/16/2009";
	substr_2 = "SAS#BASE#Cert";
	substr(substr_1, 7, 4) = "3010";
	substr(substr_2, 5, 4) = "ADVANCE";
run;

*** TRIM: remove trailing blanks;
data trim;
	address = "1900 Chapel Drive     ";
	city = "Valparaiso";
	Comb_1 = address || city;
	Comb_2 = trim(address) || city;
run;

*** CATX;
data catx;
	address = "1900 Chapel Dr    ";
	city = "Valparaiso     ";
	zip = "46383        ";
	comb_1 = address || city || zip;
	comb_2 = trim(address)||", "||trim(city)||
		", "||trim(zip);
	comb_3 = catx(", ", address, city, zip);
run;

*** INDEX;
data index;
	input location $50.;
cards;
Washington State
University of Washington
George Washington University, Washington D.C.
WashingtoN County
;
run;
data index;
	set index;
	value = index(location, "Washington");
run;

*** FIND;
data index;
	set index;
	value_1 = find(location, "Washington");
	value_2 = find(location, "Washington", 'i');
	value_3 = find(location, "Washington", 25);
run;

*** UPCASE and LOWCASE;
data case;
	upper = upcase("Valparaiso");
	lower = lowcase("UniVerSitY");
run;

*** PROPCASE;
data prop;
	input job $30.;
cards;
WORD PROFESSOR
math consultant
ADMIN. Asst.
;
run;
data prop;
	set prop;
	New_Job = propcase(job);
run;

*** TRANWRD;
data tran;
	input name $30.;
cards;
Mr. John DB
Ms. Jane DB
Dr. Joseph Smith
;
run;
data tran;
	set tran;
	new_1 = tranwrd(name, "DB", "Doe");
	new_1 = tranwrd(new_1, "Dr. ", "");
run;


/*********** Numeric Variable *************/
*** INT;
data test;
	int_1 = int(3.14159265);
	int_2 = int(0.382);
run;

*** ROUND;
data test;
	r_1 = round(326.54);
	r_2 = round(326.54, 0.1);
	r_3 = round(326.54, 10);
run;

*** CEIL: Round Up;
*** FLOOR: Round Down;
data test;
	input number;
cards;
3.14
0.618
-0.618
-3.14
;
run;
data test;
	set test;
	up = ceil(number);
	down = floor(number);
run;


