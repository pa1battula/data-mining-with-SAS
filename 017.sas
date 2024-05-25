libname dt "/home/hui.gong/SASUSER";

/**************** Produce HTML Output *********************/
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

/*************** Combining SAS Datasets **************/
*** One-to-One Merge;
data one;
	input Num VarA $;
cards;
1 A1
2 A2
5 A5
;
run;
data two;
	input Num VarB $;
cards;
2 B1
4 B4
;
run;
data two;
	input Num VarA;
cards;
2 100
4 200
;
run;
data two;
	input Num VarA $;
cards;
2 B222222
4 B444444
;
run;
* Shared Variable: Latter Cover Former;
* New Dataset Size Decided by Smaller One;
* Shared Variable Must Be the Same Type;
data three;
	set one;
	set two;
run;
proc print data=one noobs;
run;
proc print data=two noobs;
run;
proc print data=three noobs;
run;

*** Concatenating;
data one;
	input Num VarA $;
cards;
1 A1
2 A2
5 A5
;
run;
data two;
	input Num VarB $;
cards;
2 B1
4 B4
;
run;
data two;
	input Num VarA;
cards;
2 100
4 200
;
run;
data two;
	input Num VarA $;
cards;
2 B222222
4 B444444
;
run;
* Shared Variable Must Be the Same Type;
data three;
	set one two;
run;
proc print data=one noobs;
run;
proc print data=two noobs;
run;
proc print data=three noobs;
run;

*** Append;
data one;
	input Num VarA $;
cards;
1 A1
2 A2
5 A5
;
run;
data two;
	input Num VarA $;
cards;
2 B1
4 B4
;
run;
data two;
	input Num VarA ;
cards;
2 200
4 400
;
run;
* Base dataset will be Overwritten;
* Shared Variable Must Be the Same Type;
proc append base=one data=two;
run;
proc print data=one noobs;
run;
proc print data=two noobs;
run;
data one;
	input Num VarA $;
cards;
1 A1
2 A2
5 A5
;
run;
data two;
	input Num VarB $;
cards;
2 B1
4 B4
;
run;
proc append base=one data=two force;
run;

data one;
	input Num VarA $;
cards;
1 A1
2 A2
5 A5
;
run;
data two;
	input Num VarA $;
cards;
2 B1111111
4 B4444444
;
run;
proc append base=one data=two force;
run;

*** Remove Duplicates;
proc sort data=one nodupkey;
	by num;
run;

*** Match Merging;
data one;
	input Num VarA $;
cards;
1 A1
2 A2
5 A5
;
run;
data two;
	input Num VarB $;
cards;
3 B3
2 B1
4 B4
;
run;
proc sort data=one;
by descending num;
run;
proc sort data=two;
by descending num;
run;
data three;
	merge one two;
	by descending num;
run;

proc sort data=one;
by num;
run;
proc sort data=two;
by num;
run;
* Only Obs in Both;
data three;
	merge one(in=a) two(in=b);
	by num;
	if a and b;
run;
proc print data=three noobs;
run;
* Only Obs in One;
data three;
	merge one(in=x) two(in=y);
	by num;
	if x;
run;
proc print data=three noobs;
run;
* Only Obs in Two;
data three;
	merge one(in=x) two(in=y);
	by num;
	if y;
run;
proc print data=three noobs;
run;
* Only Obs in One, But Not in Two;
data three;
	merge one(in=m) two(in=n);
	by num;
	if m and not n;
run;
proc print data=three noobs;
run;
* Only Obs in Two, But Not in One;
data three;
	merge one(in=m) two(in=n);
	by num;
	if not m and n;
run;
proc print data=three noobs;
run;

* One to Multiple Merge;
data one;
	input Num VarA $;
cards;
1 A1
2 A2
5 A5
;
run;
data two;
	input Num VarB $;
cards;
2 B3
2 B1
4 B4
;
run;
proc sort data=one;
by num;
run;
proc sort data=two;
by num;
run;
data three;
	merge one two;
	by num;
run;

* Multiple to Multiple Merge;
data one;
	input Num VarA $;
cards;
1 A1
2 A2
2 A4
5 A5
;
run;
data two;
	input Num VarB $;
cards;
2 B3
2 B1
4 B4
;
run;
proc sort data=one;
by num;
run;
proc sort data=two;
by num;
run;
data three;
	merge one two;
	by num;
run;
proc print data=one noobs;
run;
proc print data=two noobs;
run;
proc print data=three noobs;
run;
