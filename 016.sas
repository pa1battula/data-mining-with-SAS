libname dt "/home/hui.gong/SASUSER";

/******* Self-Defined Format *************/
data employee;
	infile "/home/hui.gong/Stat363/Raw_Data/Note17-employee.txt";
	input FName $ LName $ JobCode Salary Response $;
run;

proc format;
	value jobfmt
		103 = "Manager"
		105 = "Text Processor"
		111 = "Associate Writer"
		112 = "Writer"
		113 = "Senoir Writer";
	value $responsefmt
		"Y" = "Yes"
		"N" = "No"
		"U" = "Undecided"
		"NOP" = "No Opinion";
run;
data employee;
	set employee;
	format jobcode jobfmt.
		response $responsefmt.;
run;

data person;
	input Name $ Age;
cards;
John 10
Jane 20
Joseph 67
Joshua 16
Jenny 5
Jacob 33
Joy 55
Jesse .
Jake 105
;
run;
proc format;
	value agefmt
		low-<13 = "Child"
		13-<20 = "Teenage"
		20-<65 = "Adult"
		65-high = "Senior"
		other = "Unknown";
run;
data person;
	set person;
	format age agefmt.;
run;
proc print data=person;
run;

/**************** Produce HTML Output *********************/
ods html body="/home/hui.gong/Stat363/Out_Data/admit.html";
proc print data=dt.admit;
run;
ods html close;
ods html body="/home/hui.gong/Stat363/Out_Data/new.html";
proc print data=dt.admit;
run;
proc print data=dt.before;
run;
ods html close;

ods html body = "/home/hui.gong/Stat363/Out_Data/body.html"
	contents="/home/hui.gong/Stat363/Out_Data/contents.html"
	frame="/home/hui.gong/Stat363/Out_Data/frame.html";
proc print data=dt.admit;
run;
proc print data=dt.salary;
run;
proc print data=dt.y2000;
run;
ods html close;


ods html body = "/home/hui.gong/Stat363/Out_Data/body.html"
	(url="http://mysite.com/myreports/body.html")
	contents="/home/hui.gong/Stat363/Out_Data/contents.html"
	(url="http://mysite.com/myreports/contents.html")
	frame="/home/hui.gong/Stat363/Out_Data/frame.html"
	(url="http://mysite.com/myreports/frame.html");
proc print data=dt.admit;
run;
proc print data=dt.salary;
run;
proc print data=dt.y2000;
run;
ods html close;


ods html path="/home/hui.gong/Stat363/Out_Data"
	body = "body.html"
	contents="contents.html"
	frame="frame.html";
proc print data=dt.admit;
run;
proc print data=dt.salary;
run;
proc print data=dt.y2000;
run;
ods html close;

ods html body="/home/hui.gong/Stat363/Out_Data/admit.html"
	style = banker;
proc print data=dt.admit;
run;
ods html body="/home/hui.gong/Stat363/Out_Data/admit.html"
	style = BarrettsBlue;
proc print data=dt.admit;
run;
ods html close;
ods html body="/home/hui.gong/Stat363/Out_Data/admit.html"
	style = statistical;
proc print data=dt.admit;
run;
ods html close;

/********** Reading SAS Dataset ***************/
data two;	* Create this New One;
	set one;  * Using this Existing One;
run;
data one;	* Overwrite this Existing One;
	set one;  * Using this Existing One;
run;

data two;
	set one(obs=10 firstobs=2);
run;

data obs5;
	obsnum = 5;
	set dt.salary point=obsnum;
	output;
	stop;
run;

data salary;
	set dt.salary end=last;
	if wagecat = "S" then Income = wagerate * 12;
	else if wagecat = "H" then Income = wagerate * 2000;
	Payroll + Income;
	if last;
run;
proc print data=salary;
var payroll;
run;

proc sort data=dt.salary out=salary;
by wagecat;
run;
data salary_1;
	set salary;
	by wagecat;
	if wagecat = "S" then Income = wagerate * 12;
	else if wagecat = "H" then Income = wagerate * 2000;
	if first.wagecat then Payment = Income;
	else Payment + Income;
	if last.wagecat;
run;
proc print data=salary_1;
var wagecat payment;
run;
