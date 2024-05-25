libname dt "/home/hui.gong/SASUSER";

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


/******************* Formatted Input ******************/
data job;
	infile "/home/hui.gong/Stat363/Raw_Data/Note08-empdata.txt";
	input LastName $ 1-7 FirstName $ 9-13 
		Code 15-17 Salary $ 19-27;
run;

data job;
	infile "/home/hui.gong/Stat363/Raw_Data/Note08-empdata.txt";
	input FirstName $ 9-13  LastName $ 1-7 
		Code 15-17 Salary $ 19-27 FirstJobCode 15;
run;


*** Controller: @;
**  Informat: comma9. or dollar9., $7.;
data job;
	infile "/home/hui.gong/Stat363/Raw_Data/Note08-empdata.txt";
	input @1 LastName $7. @9 FirstName $
		@15 Code @19 Salary dollar9.;
run;

data job;
	infile "/home/hui.gong/Stat363/Raw_Data/Note08-empdata.txt";
	input @15 Code @1 LastName $7. @9 FirstName $
		 @19 Salary dollar9. @15 Code_1;
run;

*** Controller: +;
data job;
	infile "/home/hui.gong/Stat363/Raw_Data/Note08-empdata.txt";
	input LastName $7. +1 FirstName $5. +1 Code 3. 
			+1 Salary comma9.;
run;

data job;
	infile "/home/hui.gong/Stat363/Raw_Data/Note08-empdata.txt";
	input LastName $7. +1 FirstName $5. +5 Salary comma9.;
run;

data job;
	infile "/home/hui.gong/Stat363/Raw_Data/Note08-empdata.txt";
	input LastName $7. +1 FirstName $5. +5 Salary comma9.
		+(-13) Code;
run;

data job;
	infile "/home/hui.gong/Stat363/Raw_Data/Note08-empdata.txt";
	input LastName $7. +1 FirstName $5. +5 Salary comma9.
		@15 Code;
run;

