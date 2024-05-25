libname dt "/home/hui.gong/SASUSER";

/**************** Logistic Regression ****************/
*** Dependent is Categorical;
*** Binary;
*** Ordinal;

*** Model;
* log(p/1-p)=b0+b1*X1+b2*X2+...+bn*Xn;

proc logistic data=dt.moonlake descending;
	model computer = age educ income gender / 
		link = logit;
run;

* log(p/1-p)=-1.2896-0.3764*age+0.5551*educ
	+0.5617*income-0.0784*gender;

* For Example: aged 18-34 (age=1), 
	college graduated (educ=3),	
	income $50000-74999 (income=4),
	female (gender=2);
* p = exp(-1.2896-0.3764*1+0.5551*3
	+0.5617*4-0.0784*2)
	/[1+exp(-1.2896-0.3764*1+0.5551*3
	+0.5617*4-0.0784*2] = 0.8899;



proc logistic data=dt.moonlake;
	model internet = age educ income gender / 
		link = logit;
run;

* log(p/1-p)=-0.0663*internet1+0.2349*internet2
	+1.2377*internet3+1.6734*internet4
	+0.4687*age-0.1577*educ
	-0.1358*income-0.3408*gender;
	
* For Example: aged 18-34 (age=1), 
	college graduated (educ=3),	
	income $50000-74999 (income=4),
	female (gender=2);
*p1 = exp(-0.0663*1+0.2349*0
	+1.2377*0+1.6734*0
	+0.4687*1-0.1577*3
	-0.1358*4-0.3408*2)
	/[1+exp(-0.0663*1+0.2349*0
	+1.2377*0+1.6734*0
	+0.4687*1-0.1577*3
	-0.1358*4-0.3408*2)] = 0.2149;
*p2 = exp(-0.0663*0+0.2349*1
	+1.2377*0+1.6734*0
	+0.4687*1-0.1577*3
	-0.1358*4-0.3408*2)
	/[1+exp(-0.0663*0+0.2349*1
	+1.2377*0+1.6734*0
	+0.4687*1-0.1577*3
	-0.1358*4-0.3408*2)] = 0.4858;	
*p5 = exp(-0.0663*0+0.2349*0
	+1.2377*0+1.6734*0
	+0.4687*1-0.1577*3
	-0.1358*4-0.3408*2)
	/[1+exp(-0.0663*0+0.2349*0
	+1.2377*0+1.6734*0
	+0.4687*1-0.1577*3
	-0.1358*4-0.3408*2)] = 0.2263;
	

/******************** Macro **************************/	
*** macro variable;
%let city = Chesterton;
data &city;
	Address_1 = "123 Main St, &city, IN";
	Address_2 = "456 Broad St, &city, IN";
	Address_3 = "789 Front St, &city, IN";
run;
proc print data = &city;
run;

*** macro program;
%macro year_output(end_year);
data year;
	do year = 1900 to &end_year;
	output;
	end;
run;
%do i = 1900 %to &end_year;
	data year_&i.;
		set year;
		if year = &i.;
	run;
%end;
%mend;
%year_output(1905);
%year_output(1915);


%let city = Chicago;
proc print data=year;
title1 "Data for &city";
title2 'Data for &city';
run;


*** Debug;
options mprint symbolgen;
%let city = Chesterton;


*** To create the histograms for Systolic Blood 
	Pressure and Diastolic Blood Pressure by gender; 
data athlete;
	infile '/home/hui.gong/Stat363/Raw_Data/athlete.txt'
		dlm="*";
input sbp dbp sex $ lifestyle;
run;
data athlete;
	set athlete;
	label sbp = 'Systolic Blood Pressure'
		  dbp = 'Diastolic Blood Pressure';
run;

%macro hist(variable, sex, from, end);
proc univariate data=athlete noprint;
	title "&variable Measure for &sex Athletes";
	where sex = "&sex";
	var &variable;
	histogram &variable 
		/ endpoints = &from to &end by 10;
run;
%mend;

%hist(sbp, M, 90, 140);
%hist(sbp, F, 90, 140);
%hist(dbp, M, 50, 100);
%hist(dbp, F, 50, 100);








*** This macro allows us to investigate the 
	sampling distribution of the mean and variance;
*** The macro generates NSAMPLE samples of size N 
	from a uniform distribution;
*** For each sample, we compute the sample mean 
	and sample variance;
*** These are accumulated in a data set, called b;
*** After we have accumulated the NSAMPLE values, 
	PROC UNIVARIATE allows us to look at histograms 
	of the sample means and sample variances;
*** The macro illustrates the use of %do loops 
	as well as the use of conditional statement %if;

%macro CLT(nsample, n, title);
%do i = 1 %to &nsample;
%* Generate the Random Samples;
data a;
	do j = 1 to &n;
	x = ranuni(29027+&i);
	output;
	end;
run;
%* Compute the sample mean and variance and store them in a data set called mean;
proc means data=a noprint;
	var x;
	output out=mean mean=xbar var=s2;
run;
%* Accumulate the sample mean and variance in data set b;
data b;
	%if &i = 1 %then set mean;
	%else set b mean;
	;
	keep xbar s2;
run;
%* 	Look at a histogram of the first sample;
	%if &i = 1 %then %do;
	proc univariate data=a noprint;
		var x;
		histogram x;
	title "Distribution of the First Sample";
	run;
	%end;
%end; %* End of do loop;
%* Look at histograms of the sample means and the sample variances;
%* Overlay a normal distribution and a gamma distribution;
proc univariate data=b;
	var xbar s2;
	histogram xbar / normal(color=black);
	histogram s2 / gamma(color=black);
title "&title";
run;
%mend;
%clt(1000, 10, Random Samples from a Uniform Distribution);


*** Double Ampersands (&&);





*** More Than 2 Ampersands;





*** Reference Marco Variable with Period (.);
