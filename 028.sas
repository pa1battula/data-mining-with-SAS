libname dt "/home/hui.gong/SASUSER";


/******************* One-Way ANOVA *********************/
*** ANOVA: Analysis Of Variance;
* H0: mu1 = mu2 = mu3 = ... = mun;
* H1: at least one mu is different;
* y = b_0 + b_1 * X;

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
proc anova data=taillite;
	class vehtype;
	model resptime = vehtype;
	means vehtype / tukey lines;
run;


/******************* Two-Way ANOVA *********************/
* y = b_0 + b_1 * x_1 + b_2 * x_2 + b_3 * x_1 * x_2;
* x_1 and x_2 are categorical variable;
* H0: Interaction is not significant;
* H0: x_1 is not significant;
* H0: x_2 is not significant;
proc format;
value $ species_fmt 'h'='Human' 'd'='Dummy';
run;
data force;
	infile '/home/hui.gong/Stat363/Raw_Data/Dummy.txt';
input species $ impactor $ stiff1 stiff2 calcium magnesm;
run;
data force;
	set force;
	label impactor	= 'Type of Impactor'
		 stiff1	= 'Stiffness Measure at Site 1'
			;
	format species species_fmt.;
run;
proc glm data=force;
	class impactor species;
	model stiff1 = impactor species impactor * species;
	means impactor species / tukey lines;
run;


*** Interaction;
*   a b a*b;
*   a b c a*b a*c b*c a*b*c;

*   a | b <=> a b a*b;
*   a | b | c <=> a b c a*b a*c b*c a*b*c;

*** Nested Design;
*  model y = a b(a);
*  model y = state city(state);


proc format;
	value $ type_fmt 'o'='Overhand' 'f'='Figure-8';
	value rope_fmt 1='Cotton' 2='Twine' 3='Nylon';
	value direction_fmt 1='Parallel' 2='Perpendicular';
run;
data knots;
	infile '/home/hui.gong/Stat363/Raw_Data/knots.txt';
input @4 type $1. @7 rope 1.0 @10 directn 1.0 
	@13 weight 3.0;
run;
data knots;
	set knots;
	label weight = 'Weight that Broke the Rope in Pounds';
	format type type_fmt. rope rope_fmt. 
		directn direction_fmt.;
run;

proc glm data=knots;
	class type rope directn;
	model weight = type | rope | directn;
run;

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

