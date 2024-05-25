libname dt "/home/hui.gong/SASUSER";

/******************* One-Sample Test *******************/
*** Hypothesis Test;
* H0: No Change, No Effect;
* H1: Change, Effect;

*** One Sample T-Test;
* H0: mu = mu_0;
* H1: mu >, <, not equal mu_0;
* PROC Means: H0 mu = 0;
* H1: Not Equal;

** H1: > or <;
** p is the 2-tailed Test p-Value;
* If mean > 0 and H1 is >, then new p-value = p/2;
* If mean > 0 and H1 is <, then new p-value = (1-p)/2;

*** One-Sample Proportion Test;
* H0: p = p_0;
* H1: p >, <, not equal to p_0;

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


/******************* Two-Sample t-Test *******************/
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


******* Matched-Pair t-Test;
** Use Proc Ttest;
proc ttest data=grades;
	paired exam1 * exam2;
run;



/******************* One-Way ANOVA *********************/
*** ANOVA: Analysis Of Variance;
* H0: mu1 = mu2 = mu3 = ... = mun;
* H1: at least one mu is different;
proc format;
value vfmt 1='Pickup' 2='Cargo Van' 
	3='Minivan' 4='Straight Truck';
run;
data taillite;
	infile '/home/hui.gong/Stat363/Raw_Data/Taillite.txt';
input id vehtype group positn speedzn resptime 
	follotme folltmec;
run;
data taillite;
	set taillite;
	if group = 1;
	label vehtype	= 'Vehicle Type'
		  resptime	= 'Response Time'
		 ;
	format vehtype vfmt.;
run;
* PROC GLM: Generalized Linear Model;
* ANOVA: class statement needed;
proc glm data=taillite;
	class vehtype;
	model resptime = vehtype;
run;
* Multiple Comparison;
proc glm data=taillite;
	class vehtype;
	model resptime = vehtype;
	means vehtype / tukey lines;
run;


* PROC ANOVA;
* Need Balanced Samples;
proc freq data=taillite;
	tables vehtype / missing list;
run;

data package;
	infile '/home/hui.gong/Stat363/Raw_Data/Package_Alternative.txt' 
dlm='#' firstobs=2;
	input Package Sales_1 Sales_2 Sales_3 Sales_4 Sales_5;
run;
* H0: mu1 = mu2 = mu3 = mu4;
data package_1;
	set package;
	array tmp{*} Sales_1-Sales_5;
	do store = 1 to dim(tmp);
		Sales = tmp{store};
		output;
	end;
	drop sales_1 - sales_5;
run;
proc anova data=package_1;
	class package;
	model sales = package;
	means package / tukey lines;
run;
