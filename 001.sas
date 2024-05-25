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


DatA dt.admit2;
	set dt.admit;
	where age > 39;
run;

proc print data=admit2;
run;

proc sort data=admit2;
	by sex;
run;


