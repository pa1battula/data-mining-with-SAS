libname dt "/home/hui.gong/SASUSER";

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


/******* Multiple Linear Regression *************/
*** Y = b0 + b1*X1 + b2*X2 + ... + bk*Xk;
* Create a Squared Term;
data assay;
	set assay;
	concen2 = concen ** 2;
run;
proc reg data=assay;
	model absorb = concen concen2;
	plot student.* p.;
run;
* Create a Cubic Term;
data assay;
	set assay;
	concen3 = concen ** 3;
run;
proc reg data=assay;
	model absorb = concen concen2 concen3;
	plot student.*p.;
run;
* Transformation Y;
data assay;
	set assay;
	absorb_log = log(absorb);
run;
proc reg data=assay;
	model absorb_log = concen;
	plot student. * p.;
run;
proc reg data=assay;
	model absorb_log = concen concen2;
	plot student. * p.;
run;
proc reg data=assay;
	model absorb_log = concen concen2 concen3;
	plot student. * p.;
run;






data electric;
	infile '/home/hui.gong/Stat363/Raw_Data/Electric.txt';
input housize 1-3 income 6-11 aircapac 14-16 
		applindx 19-23 family 26-28 peak 31-35;
run;
data electric;
	set electric;
	label housize = 'House Size'
		  income  = 'Family Income'
		  aircapac= 'Air Conditioning Capacity'
		  applindx= 'Appliance Index'
		  family  = 'Number of Family Members'
		  peak    = 'Peak Hour Electric Load';
run;

proc corr data=electric;
	var housize income aircapac applindx family;
	with peak;
run;
proc gplot data=electric;
	plot peak * housize peak * income;
run;

* Multicollinearity;
* VIF: Variance Inflation Factor, >5;
* Tolerance, <0.2;
* VIF = 1/Tolerance;
proc reg data=electric;
	model peak = housize income aircapac applindx
			family / vif tol collin spec;
run;

** Rule: Parsimony;
*  Outlier;
*  Influential Observation;



