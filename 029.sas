libname dt "/home/hui.gong/SASUSER";

/******************* Two-Way ANOVA *********************/
* y = b_0 + b_1 * x_1 + b_2 * x_2 + b_3 * x_1 * x_2;
* x_1 and x_2 are categorical variable;
* H0: Interaction is not significant;
* H0: x_1 is not significant;
* H0: x_2 is not significant;
proc glm data=force;
	class impactor species;
	model stiff1 = impactor species 
					impactor*species;
	means impactor species / tukey lines;
run;


*** Interaction;
*   a | b <=> a b a*b;
*   a | b | c <=> a b c a*b a*c b*c a*b*c;

*** Nested Design;
*  model y = a b(a);
*  model y = state city(state);


* Fixed Effect;
* Random Effect;
* If Random Effect Exists, ANOVA doesn't Work;
* If one variable is random effect, all terms
	with this variable must be included in random;
proc glm data= knots;
	class type rope directn;
	model weight = type | rope | directn;
	random type rope type*directn rope*directn
		rope*type rope*type*directn / test;
run;






/************** Simple Linear Regression ***************/
data assay;
	infile '/home/hui.gong/Stat363/Raw_Data/Assay.txt';
input concen absorb;
run;
data assay;
	set assay;
	concen = log(concen);
	label concen = 'ln(Conc of DNase)'
		  absorb = 'Optical Density';
run;
** Simple Regression: Y = b_0 + b1*X;
* Option p: show predicted y values;
proc reg data=assay simple;
	model absorb = concen / p;
	plot absorb * concen;
run;
* absorb = 0.63420	+ 0.41350 * concen;

* Option clm: confidence interval;
* Option cli: prediction interval;
* CI: Given an X value, the average y value's interval;
* PI: Given an X value, one y value's interval;
proc reg data=assay simple;
	model absorb = concen / clm cli;
run;

*** Model Check;
*** Check the Residual = y - y_hat;
*** 4 Assumptions:
*   1. residuals are indepdent;
*   2. residuals have a mean 0;
*   3. residuals have a constant variance;
*   4. residuals are normally distributed;

**  Assumption 1, 2, 3: Residual vs. X;
proc reg data=assay;
	model absorb = concen;
	plot absorb * concen;
	plot absorb * p.; * p. is the p-hat (predicted y);
	plot student. * concen; * student. is the standardized residual;
	plot student. * p.;
run;

* Simple Regression: student. * concen and student. * p. Same;
* Assumption 1: no pattern;
*	If violated, open upward/downward, add a squared term;
*	             wave pattern, add a squared and cubic terms;
* Assumption 2: roughly half above 0, and half below 0;
* Assumption 3: no pattern;
*	If violated, transformation of x and/or y;

*** Assumption 4: Q-Q plot, Normality Test;
*   If violated, tranformation of x and/or y;
**  Need Proc Univariate;
**  Need Output Residual First;
proc reg data=assay;
	model absorb = concen;
	output out=assay_r predicted=yhat residual=resid
			student=stdresid;
run;
proc univariate data=assay_r normal;
	var stdresid;
	probplot stdresid / normal square;
run;

*** Additional Plots;
symbol1 value = none i=rlclm95 color=black;
symbol2 value = none i=rlcli95 color=red;
symbol3 value = none i=join color=blue;
proc gplot data=assay_r;
	plot absorb * concen = 1
		absorb * concen = 2
		absorb * concen = 3 / overlay;
run;




