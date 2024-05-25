libname dt "/home/hui.gong/SASUSER";


/***************** Free Format Data ******************/
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

* Single Space;
data city;
	infile "/home/hui.gong/Stat363/Raw_Data/Note10-topten_single_blank.txt";
	input Rank City & $ Pop comma.;
run;
data tmp;
	infile "/home/hui.gong/Stat363/Raw_Data/Note10-topten_single_blank.txt";
	input Rank City & : $30. ;
run;
data tmp;
	set tmp;
	Pop = scan(city, -1, " ");
run;
data tmp;
	set tmp;
	t_1 = scan(city, 1, "");
	t_2 = scan(city, 2, '');
run;
data tmp;
	set tmp;
	if find(t_2, ",") then t_2 = '';
run;
data tmp;
	set tmp;
	New_City = catx(" ", t_1, t_2);
run;


*** Reorder;
data city;
	retain Rank;
	set city;
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