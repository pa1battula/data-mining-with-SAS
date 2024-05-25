libname dt "/home/hui.gong/SASUSER";

proc format;
value dfmt 1 = 'Drug' 2 = 'Placebo';
run;
data sclera;
	infile '/home/hui.gong/Stat363/Raw_Data/Sclera.txt';
input clinic 1-2 id 4-5 drug 8 thick1 11-12 thick2 15-16
		mobility1 19-21 mobility2 24-26 assess1 29 
		assess2 32;
improve = assess1 - assess2;
run;

proc univariate data=sclera;
	class drug;
	var improve;
run;

* Output Results;
proc univariate data=sclera;
	class drug;
	var improve;
	output out=results mean=mean p1=p1 
		p5=p5 p25=p25;
run;

proc univariate data=sclera plot;
	class drug;
	var improve;
run;

** Get Better Plots;
* Histogram;
* Q-Q (Normal Probality) Plot;
proc univariate data=sclera normal;
	var improve;
	class drug;
	histogram improve 
		/ normal midpoints = -5 to 5 by 1;
	probplot improve 
		/ normal (mu=est sigma=est) square;
run;

*** Boxplot;
proc sort data=sclera;
by drug;
run;
proc boxplot data=sclera;
	plot improve * drug ;
run;
proc boxplot data=sclera;
	plot improve * drug /boxstyle=schematic;
run;



/******************* GChart *********************/
proc gchart data=sclera;
	vbar improve / discrete space=0 width=8
					subgroup = drug;
	format drug dfmt.;
run;

data parking;
infile "/home/hui.gong/Stat363/Raw_Data/parking.txt";
input id miles conv carpool years empstat 
	ridebus busmon bustues buswed busthurs 
		busfri drive permit meters paylots;
run;

data parking;
	set parking;
	/* Change code of 99 to missing for employment status */
	if empstat = 99 then empstat = .;
	/* Create new character variable for employment status */
	length employ $25.;
	if empstat = 1 then employ = 'Work on campus';
		else if empstat = 2 
			then employ = 'Work off campus';
		else if empstat = 3 
			then employ = 'Work both on/off campus';
		else if empstat = 4 
			then employ = 'Don''t work';
		else employ = '';
run;

proc gchart data=parking;
	hbar employ ;
run;
proc gchart data=parking;
	hbar employ / type = pct;
run;


/******************* X-Y Plot *********************/
data trade;
	infile "/home/hui.gong/Stat363/Raw_Data/China#1.txt";
input year 1-4 total 6-10 export 12-16 import 18-22;
run;

symbol value = dot i=j;
proc gplot data=trade;
	plot import * year;
run;

symbol1 value=dot color=green;
symbol2 value=plus color=orange;
axis1 label=("Import/Export");
proc gplot data=trade;
	plot import*year=1 export*year=2 /overlay legend
		vaxis=axis1;
run;


data athlete;
	infile "/home/hui.gong/Stat363/Raw_Data/athlete.txt" 
		dlm="*";
input systolic diastolic sex $ lifestyle;
run;

proc gplot data=athlete;
	plot systolic * diastolic = sex;
run;

/******************* Correlation *********************/
data grades;
	infile "/home/hui.gong/Stat363/Raw_Data/Grades.txt";
input id $ gender $ class quiz exam1 exam2 lab final;
run;
data grades;
	set grades;
	label exam1='First Exam Grade'
		 exam2 = 'Second Exam Grade'
		 final = 'Final Exam Grade'
		;
run;

proc corr data=grades;
	var exam1 exam2 final;
run;


data bonescore;
	infile "/home/hui.gong/Stat363/Raw_Data/Bonescor.txt";
input singh ccratio csi calcar bonescor young;
run;
data bonescore;
	set bonescore;
	label	singh	= 'Singh Index'
			ccratio	= 'CC Ratio'
			csi		= 'Cortical Shaft Index'
			calcar	= 'Calcar Width'
			bonescor= 'Renee''s Bone Score'
			young	= '% Young Normal'
			;
run;

proc corr data=bonescore;
	var singh ccratio csi calcar bonescor young;
run;
proc corr data=bonescore;
	var singh ccratio csi calcar young;
	with bonescor;
run;