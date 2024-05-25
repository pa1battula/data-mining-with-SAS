libname dt "/home/hui.gong/SASUSER";

/******************* Formatted Input ******************/
data job;
	infile "/home/hui.gong/Stat363/Raw_Data/Note08-empdata.txt";
	input LastName $ 1-7 FirstName $ 9-13 
		Code 15-17 Salary $ 19-27;
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

/***************** Free Format Data ******************/
*** List Input;
data credit;
	infile "/home/hui.gong/Stat363/Raw_Data/Note09-creditcard.txt";
	input Gender $ Age BankCard FreqBank DeptCard FreqDept;
run;

* Note: The variable value cannot contain delimiter;
data credit;
	infile "/home/hui.gong/Stat363/Raw_Data/Note09-creditcard_comma.txt"
	dlm=",";
	input Gender $ Age BankCard FreqBank DeptCard FreqDept;
run;

*** Character Variable: Be Careful of Length;
*** Default is 8 Charaters;
data city;
	infile "/home/hui.gong/Stat363/Raw_Data/Note09-citydata.txt";
	length CityName $15.;
	input CityName $ Pop70 Pop80;
run;

*** Missover: Missing value in the middle or end of each row;
data credit;
	infile "/home/hui.gong/Stat363/Raw_Data/Note09-creditcard_miss_end.txt"
		missover;
	input Gender $ Age BankCard FreqBank DeptCard FreqDept;
run;

*** DSD: Missing value in the beginning of each row;
*** DSD: Change default delimter to comma (,);
data credit;
	infile "/home/hui.gong/Stat363/Raw_Data/Note09-creditcard_missing.txt"
		missover dsd dlm=" ";
	input Gender $ Age BankCard FreqBank DeptCard FreqDept;
run;


data credit;
	infile "/home/hui.gong/Stat363/Raw_Data/Note09-creditcard_miss_middle_asterisk.txt"
		missover dsd dlm="*";
	input Gender $ Age BankCard FreqBank DeptCard FreqDept;
run;

*** DSD: can remove quotation marks;
*** DSD: Treat two consecutive delimiters as missing value;
data credit;
	infile "/home/hui.gong/Stat363/Raw_Data/Note09-creditcard_quotation.txt"
		missover dsd dlm=" ";
	input Gender $ Age BankCard FreqBank DeptCard FreqDept;
run;

*** Tab delimiter: dlm="09"x;
data empdata;
	infile "/home/hui.gong/Stat363/Raw_Data/Note08-empdata.txt"
	dlm = " ";
	input Lname $ Fname $ Code Salary : comma.;
run;
