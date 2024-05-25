libname dt "/home/hui.gong/SASUSER";
libname ds "/home/hui.gong/sasuser.v94";

*** Description Part;
proc contents data=dt.admit; * Alphabetical Order;
run;

proc contents data=dt.admit varnum; * Logical Order of Variables;
run;

* Show All Datasets In The Library;
proc contents data=dt._all_;
run;

* Show All Datasets In The Library, But No Detail;
proc contents data=dt._all_ nods;
run;

*** Data Part;
* Row: Observation;
* Column: Variable;

*** SAS Variable Naming Convention;
* 1. Up to 32 characters;
* 2. First place must be letter (a-z) or underscore(_), 
	invalid: 8today, +true;
* 3. After first place, you can use number (0-9);

*** Type: Numerical (right justfied) and Character (left 
	justified);
data try;
	input id_1 id_2 $;
	cards;
01234 01234
;
run;

*** Missing Value: Numerical (.) and Character ( );

*** Length: Numerical (8 bytes) and Character (default 8);
data test;
	input name $10.;
	cards;
John
Elizebath
;
run;

*** Format;
data admit;
	set dt.admit;
	format fee dollar10.3;
run;

*** Informat;
data test;
	input toll $20.; * Read in as character variable;
	cards;
$1,234,567.90
$2,450,200.11
;
run;

data test;
	input toll dollar20.2;  * informat, read in as numerical;
	format toll dollar20.2; * format;
	cards;
$1,234,567.90
$2,450,200.11
;
run;

*** Label: upto 256 characters, special characters;
data test;
	set test;
	label toll = "Toll Collected for PA Turnpike in $";
run;


*** Description Part;
proc contents data=dt.admit; * Alphabetical Order;
run;
proc datasets;
	contents data=dt.admit;
run;

proc contents data=dt.admit varnum; * Logical Order of Variables;
run;
proc datasets;
	contents data=dt.admit varnum;
run;

* Show All Datasets In The Library;
proc contents data=dt._all_;
run;
proc datasets;
	contents data=dt._all_;
run;

* Show All Datasets In The Library, But No Detail;
proc contents data=dt._all_ nods;
run;
proc datasets;
	contents data=dt._all_ nods;
run;


*** Delete a Dataset;
data test;
	set dt.admit;
run;
proc datasets;
	delete test;
run;


*** System Options;
options nodate nonumber; * Remove Date and Page Number on the
	result window;
options date number;

options pageno=100; * Reset Page Number;

options pagesize = 15; * Define the Number of Lines of Each
	Page on the Result window;

options linesize = 60; * Define the Number of Columns of 
	Each Page on the Result window;

*** Options Yearcutoff=;
*** OnDemand: 1940-2039;
data test;
	date_1 = "01Jan39"d;
	date_2 = "01Jan40"d;
run;
proc print data=test;
format date_1 mmddyy10. date_2 date9.;
run;

options yearcutoff = 1950;  * 1950-2049;
proc print data=test;
format date_1 date_2 date9.;
run;

proc print data=dt.admit;
run;
options firstobs= 2 obs=5; *Global options;
proc print data=dt.admit;
run;
proc print data=dt.admit(firstobs=3 obs=10);  *Local options;
run;
proc print data=dt.acities;
run;

options firstobs=1 obs=max; * Reset;

*** Syntax Error;
proc prin data=dt.admit; * Misspell;
run;

proc print data=dt.admit * Missing semicolon
run;

proc print data=dt.admit; * Unbalanced Quotation Marks;
where sex = "M
run;";

proc print data=dt.admit keylabel; * Wrong Options;
run;

*** Comment;
* Use Astrisk;
* /* */;

/******************** Examples ***************************/


/********************************************************/

*proc print data=dt.admit;
*run;

** Hot Keys: Ctrl + / for Comment and Uncomment;
proc print data=dt.admit;
run;
