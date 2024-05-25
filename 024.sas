libname dt "/home/hui.gong/SASUSER";

proc format;
value dfmt 1 = 'Drug' 2 = 'Placebo';
run;
data sclera;
	infile '/home/hui.gong/Stat363/Raw_Data/Sclera.txt';
input clinic 1-2 id 4-5 drug 8 thick1 11-12 thick2 15-16
		mobility1 19-21 mobility2 24-26 assess1 29 
		assess2 32;
run;
** Create a Random Name for Each ID;
data name;
	do id = 1 to 76;
		RandLetter1=choosec(rand('integer',21),
		'b','c','d','f','g',
		'h','j','k','l','m','n',
		'p','q','r','s','t',
		'v','w','x','y','z');
		RandLetter2=choosec(rand('integer',5),
		'a','e','i','o','u');
		RandLetter3=choosec(rand('integer',21),
		'b','c','d','f','g',
		'h','j','k','l','m','n',
		'p','q','r','s','t',
		'v','w','x','y','z');
		output;
	end;
run;
data name;
	set name;
	Name = compress(upcase(catx('', randletter1, 
			randletter2, randletter3)));
run;
data sclera;
	merge sclera name(keep=name id);
	by id;
run;
data sclera;
	set sclera;
improve = assess1 - assess2;
	label
		id			= 'Patient ID Number'
		thick1		= 'Skin Thickening at 1st Visit'
		thick2		= 'skin Thickening at 2nd Visit'
		mobility1		= 'Skin Mobility at 1st Visit'
		mobility2		= 'Skin Mobility at 2nd Visit'
		assess1		= 'Patient Assessment at 1st Visit'
		assess2		= 'Patient Assessment at 2nd Visit'
		improve		= 'Improvement in Assessment Score';
	format drug dfmt.;
run;

proc univariate data=sclera;
	var improve;
run;

proc univariate data=sclera;
	id name;
	var improve;
run;

proc univariate data=sclera;
	id name;
	class drug;
	var improve;
run;

proc sort data=sclera;
	by drug;
run;
proc univariate data=sclera;
	id name;
	by drug;
	var improve;
run;

* Output Results;
proc univariate data=sclera;
	id name;
	by drug;
	var improve;
	output out=results mean=mean p1=p1 
		p5=p5 p25=p25;
run;

proc univariate data=sclera plot;
	id name;
	by drug;
	var improve;
run;

** Get Better Plots;
* Histogram;
proc univariate;
	var improve;
	id name;
	by drug;
	histogram improve 
		/ normal midpoints = -5 to 5 by 1;
run;

* Q-Q (Normal Probality) Plot;
proc univariate data=sclera normal;
	var improve;
	id name;
	by drug;
	probplot improve 
		/ normal (mu=est sigma=est) square;
run;

** Combine;
proc univariate data=sclera normal;
	var improve;
	id name;
	by drug;
	histogram improve 
		/ normal midpoints = -5 to 5 by 1;
	probplot improve 
		/ normal (mu=est sigma=est) square;
run;

*** Boxplot;
proc boxplot data=sclera;
	plot improve * drug ;
run;
proc boxplot data=sclera;
	plot improve * drug /boxstyle=schematic;
run;
