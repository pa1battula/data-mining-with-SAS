libname dt "/home/hui.gong/SASUSER";

/**************** Proc SQL **********************/
proc sql;
	create table admit2 as
	select *
	from dt.admit
	where age >= 30;
	

*** Inner Joint;
proc sql;
	select *
	from lefttab, righttab;
* OR;
proc sql;
	select *
	from lefttab as a inner join
		righttab as b
	on a.continent=b.continent;

*** Outer Join;
**  Left;
proc sql;
	select *
	from lefttab as a left join righttab as b
	on a.continent = b.continent;
**  Right;
proc sql;
	select *
	from lefttab as a right join righttab as b
	on a.continent = b.continent;
**  Full;
proc sql;
	select *
	from lefttab as a full join righttab as b
	on a.continent = b.continent;

*** Cross Join;
proc sql;
	select *
	from lefttab as a cross join righttab as b;
* Equivalent;
proc sql;
	select *
	from lefttab, righttab;

*** Union Join;
proc sql;
	select *
	from lefttab union join righttab;


*** Natural Join;
proc sql;
	select *
	from table1 natural join table2;
	

*** More Than 2 Tables;
proc sql;
	select c.country, p.export, p.price,
		a.quantity, a.quantity*p.price as Total
	from comm as c join price as p
		on (c.export = p.export)
		join amount as a
		on (c.country = a.country);

*** CASE;
proc sql;
	select Name, Continent, case
			when Continent = "North America" 
			then "Continental U.S."
			when Continent = "Oceania"
			then "Pacific Islands"
			else "None"
			end as Region
	from states;
** OR;
proc sql;
	select Name, Continent, case Continent
			when "North America" 
			then "Continental U.S."
			when "Oceania"
			then "Pacific Islands"
			else "None"
			end as Region
	from states;	

*** Summary Function;
*   AVE, COUNT, CSS, MAX, MEDIAN, MIN,
	NMISS, STD, RANGE, T, VAR;
proc sql;
	select x,min(x) as x_min,
			y, min(y) as y_min,
			z, max(z) as z_max,
			sum(x, y, z) as rowsum
	from summary;



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
data Valparaiso;
	Address_1 = "123 Main St, Valparaiso, IN";
	Address_2 = "456 Broad St, Valparaiso, IN";
	Address_3 = "789 Front St, Valparaiso, IN";
run;
proc print data = Valparaiso;
run;

*** macro variable;
%let city = Chesterton;
data &city;
	Address_1 = "123 Main St, &city, IN";
	Address_2 = "456 Broad St, &city, IN";
	Address_3 = "789 Front St, &city, IN";
run;
proc print data = &city;
run;

data year;
	do year = 1900 to 1910;
	output;
	end;
run;
data year_1900;
	set year;
	if year = 1900;
run;

*** macro program;
%macro year_output;
%do i = 1900 %to 1910;
	data year_&i.;
		set year;
		if year = &i.;
	run;
%end;
%mend;
%year_output;

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



data sales2008;
	input city $ 1 sales 3-5 revenue 7-10;
	datalines;
A 125 3581
B 111 2319		/*macro variables can NOT be referenced here*/
C 198 4276
D 102 1895
;
run;

*** Debug;
options mprint symbolgen;
%let city = Chesterton;
data &city;
	Address_1 = "123 Main St, &city, IN";
	Address_2 = "456 Broad St, &city, IN";
	Address_3 = "789 Front St, &city, IN";
run;
proc print data = &city;
run;



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
