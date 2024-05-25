libname dt "/home/hui.gong/SASUSER";

/*********** Functions *********************/
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


/******************* DO LOOP ***********************/
*** Example: What's the total value of $1000 
	after one year investment with API 7.5%,
	and the interest will be cumulated monthly?;
data total;
	jan = 1000 * (1+0.075/12);
	feb = jan * (1+0.075/12);
run;

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
data invest;
	do year = 1 to ?;
		Invest + 2000;
		Invest + Invest * 0.075;
	end;
run;
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


data invest;
	do year = 1 to 25 until (invest >=50000);
		Invest + 2000;
		Invest + Invest * 0.075;
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
