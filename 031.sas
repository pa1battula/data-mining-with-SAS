libname dt "/home/hui.gong/SASUSER";

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
*  Outlier: unusually large/small on y-direction;
*  Influential Observation:
	unusually large/small on x-direction;
proc reg data=electric;
	model peak = housize income aircapac applindx
			family / influence;
run;

*** Outlier: RStudent |value|>2;
*   9, 29, 43, 50, 57;

*** Influential Observation;
**  Hat Diag H (Diagnoal hat matrix): >2p/n;
**  p is the # of indepdent variables;
**  n is the # of observations used in the model;
**  p=5, n=60, 2p/n=2(5)/60=0.167;
*   3, 41, 49, 57;

** Cov Ratio: |Cov Ratio - 1| > 3*p/n;
** Cov Ratio > 1.25 or Cov Ratio < 0.75;
*  1, 2, 3, 9, 10, 29, 41, 57;

** DFFITS:  > 2;
*  None;

** DFBETAS: > 2;
*  None;

** Overall: twice of apperance;
*  3, 41, 57;

*** Model Selection;
**  Automat Selection;
**  Forward, Backward, Stepwise;
proc reg data=electric;
	model peak = housize income aircapac applindx
			family / selection=forward;
run;

proc reg data=electric;
	model peak = housize income aircapac applindx
			family / selection=backward;
run;

* sle=: signficance for forward/stepwise
	forward, default=0.5, stepwise, default=0.15;
* sls=: signficance for backward/stepwise
	backward, default=0.1, stepwise, default=0.15;
proc reg data=electric;
	model peak = housize income aircapac applindx
			family / selection=stepwise
					sle=0.05 sls=0.05;
run;

** Manual Selection: Best Subset;
proc reg data=electric;
	model peak = housize income aircapac applindx
			family / selection=rsquare cp 
					adjrsq mse;
run;
* Adjusted R-Square: Bigger, Better;
* C(p): Smaller, Better;
* MSE: Smaller, Better;
* Less Independent Variables if Possible;


*** Model Checking;
proc reg data=electric;
	model peak = housize aircapac applindx
			family;
	plot student.*housize;
	plot student.*aircapac;
	plot student.*applindx;
	plot student.*family;
	plot student.*p.;
	output out=residual 
		predicted=y_hat student=sresid;
run;
proc univariate data=residual normal;
	var sresid;
run;

