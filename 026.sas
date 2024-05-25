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

/******************* GChart *********************/
proc gchart data=sclera;
	vbar improve / discrete space=0 width=8
					subgroup = drug;
	format drug dfmt.;
run;

/******************* X-Y Plot *********************/
symbol value = dot i=j;
proc gplot data=sclera;
	plot improve * id;
run;

/******************* Correlation *********************/
proc corr data=bonescore;
	var singh ccratio csi calcar bonescor young;
run;
proc corr data=bonescore;
	var singh ccratio csi calcar young;
	with bonescor;
run;





/******************* One-Sample Test *******************/
*** Hypothesis Test;
* H0: No Change, No Effect;
* H1: Change, Effect;

*** One Sample T-Test;
* H0: mu = mu_0;
* H1: mu >, <, not equal mu_0;

data well;
	infile '/home/hui.gong/Stat363/Raw_Data/Well#15.txt';
input @1 date $char5. year tds;
run;
* Test If Average TDS not 975;
* PROC Means: H0 mu = 0;
* H1: Not Equal;
data well;
	set well;
	tds_test = tds - 975;
run;
proc means data=well mean t probt;
	var tds_test;
run;
** H1: > or <;
** p is the 2-tailed Test p-Value;
* If mean > 0 and H1 is >, then new p-value = p/2;
* If mean > 0 and H1 is <, then new p-value = (1-p)/2;
** This Example;
* mean = 22.88 > 0;
* So if H1 > 0, then p-value = .0176/2;
* So if H1 < 0, then p-value = (1-.0176)/2;

*** One-Sample Proportion Test;
* H0: p = p_0;
* H1: p >, <, not equal to p_0;
proc format;
value tfmt 0 = 'Manual' 1 = 'Automatic';
run;
data gas;
	infile '/home/hui.gong/Stat363/Raw_Data/Gas.txt';
input transmission 43;	
run;
*** Test if More Than 60% of Transmission is Auto;
* H0: p=0.6;
* H1: p>0.6;
proc freq data=gas;
	table transmission / chisq testp=(0.4, 0.6);
run;
** Proc Freq Chisq: H1 not equal;
*  If p_hat > p_0, and H1 is p > p_0, then 
	new p-value = p / 2;
* If p_hat > p_0, and H1 is p < p_0, then
	new p-value = (1-p)/2;
** Example:
* p_hat = 0.7667 > p_0 = 0.6;
* H1: p > 0.6, then p-value = 0.0624/2 = 0.0312;

*** Test if More Than 80% of Transmission is Auto;
* H0: p=0.8;
* H1: p>0.8;
proc freq data=gas;
	table transmission / chisq testp=(0.2, 0.8);
run;
** Example:
* p_hat = 0.7667 < p_0 = 0.8;
* H1: p > 0.8, then p-value = (1-0.6481)/2;




/******************* Two-Sample t-Test *******************/
data running;
	infile '/home/hui.gong/Stat363/Raw_Data/running.txt';
input class sex $ @5 minute1 1.0 @7 second1 2.0 @10
		minute2 1.0 @12 second2 2.0;
run;
data running;
	set running;
	time1=minute1*60+second1;
	time2=minute2*60+second2;
	label class = 'Grade in School'
		 sex	= 'F= Female M=Male'
		 time1= 'Running Time for First Race'
		 time2= 'Running Time for Second Race';
run;

*** Test If Male and Female Run Different in 1st Run;
*** Two-Sample t-Test;
* H0: mu_1 = mu_2;
* H1: mu_1 >, <, not equal mu_2;
* Standard Deviations Equal or Not:
	sigma_1 = sigma_2 or not;

proc ttest data=running;
	var time1;
	class sex;
run;
* Equality of Variances: sigma_1 = sigma_2 or not;
* If sigma_1 = sigma_2: use pooled test;
* If sigma_1 not equal sigma_2, use Satterthwaite test;

** Example: p-value = 0.0382: sigma_1 not equal sigma_2;
*  Use Satterthwaite test: p-value = 0.0411;

*** Test If Male is Faster Than Female in 2nd Run;
* H0: mu_1 = mu_2;
* H1: mu_1 > mu_2   mu_1 is F, mu_2 is M;
proc ttest data=running;
	var time2;
	class sex;
run;



******* Matched-Pair t-Test;
data grades;
	infile '/home/hui.gong/Stat363/Raw_Data/Grades.txt';
input exam1 13-14 exam2 17-18;
run;
** Option 1: Use Proc Means;
data grades;
	set grades;
	diff = exam1 - exam2;
run;
proc means data=grades mean t probt;
	var diff;
run;

** Option 2: Use Proc Ttest;
proc ttest data=grades;
	paired exam1 * exam2;
run;
