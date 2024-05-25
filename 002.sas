libname dt "/home/hui.gong/SASUSER";
libname ds "/home/hui.gong/sasuser.v94";

*** Library Name Convention:
* 1. Up to 8 characters: invalid: Valparaiso;
* 2. First place must be letter (a-z) or underscore(_), 
	invalid: 8today, +true;
* 3. After first place, you can use number (0-9);

*** Temporary Library: WORK;
*   dataset: admit2 = work.admit2;


*** SAS Dataset Naming Convention;
* 1. Up to 32 characters;
* 2. First place must be letter (a-z) or underscore(_), 
	invalid: 8today, +true;
* 3. After first place, you can use number (0-9);


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