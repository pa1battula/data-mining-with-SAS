libname dt "/home/hui.gong/SASUSER";

/*************** Matrix: IML ************************/
*** Imput a Matrix;
proc iml;
	A = {1 3 5,
		2 4 6};
run;
print A;

*** Convert Dataset to Matrix;
data xy;
	input x1 x2 y1;
cards;
1 3 5
2 4 6
;
run;
proc iml;
	use xy;
	read all var{x1 x2} into X;
	read all var{y1} into Y;
run;
print X Y;

*** Addition, Substraction, Multiplication;
proc iml;
	A = {1 3 5, 2 4 6};
	B = {1, 7, 3};
	D = A + 2;
	E = B - 3;
	F = A * B;
print A B;
print 'A+2=' D;
print 'B-3=' E;
print 'A*B=' F;

*** Elementwise Addition, Subtraction;
proc iml;
	A = {1 3 5, 2 4 6};
	B = {1, 7, 3};
	D = 5#A;
	E = B/7;
print A B;
print '5#A=' D;
print 'B/7=' E;

*** Transpose, Joint Matrices (Horizontal, Vertical);
proc iml;
	A = {1 3 5, 2 4 6};
	B = {1, 7};
	C = {0 2 5, -1 -7 2, 9 -4 2};
	D = A`;
	E = A||B;
	F = A//C;
print A B C;
print 'A`=' D;
print 'A||B=' E;
print 'A//C=' F;

*** Subset of Matrix;
proc iml;
	A = {1 3 5, 2 4 6};
	D = A(|2, |);
	E = A(|, 3|);
	F = A(|, 2:3|);
	G = A(|1, 2:3|);
print A;
print 'A(|2, |) =' D;
print 'A(|, 3|) = ' E;
print 'A(|, 2:3|) =' F;
print 'A(|1, 2:3|) =' G;

*** Function: Square Root, Transpose;
proc iml;
	A = {1 3 5, 2 4 6};
	D = sqrt(A);
	E = t(A);
print A;
print 'sqrt(A) =' D;
print 't(A) =' E;

*** Function: Determinant, Inverse;
**  Only for Square Matrices;
proc iml;
	A = {1 3 5, 2 4 6, 7 8 0};
	D = det(A);
	E = inv(A);
print A;
print 'det(A) = ' D;
print 'inv(A) = ' E;

*** Function: Trace, Diag;
**  Only for Square Matrices;
proc iml;
	A = {1 3 5, 2 4 6, 7 8 0};
	F = trace(A);
	G = diag(A);
print A;
print 'trace(A) = ' F;
print 'diag(A) = ' G;

*** Function: Create Identity Matrix;
**            Create n*m Identical Matrix;
proc iml;
	D = i(3);
	E = j(2, 4, -7);
print 'i(3)= ' D;
print 'j(2, 4, -7) = ' E;

*** Function: Eigenvector, Eigenvalue, Solve;
proc iml;
	A = {1 3 5, 2 4 6, 7 8 0};
	B = {5, 4, 8};
	F = eigval(A);
	G = eigvec(A);
	H = solve(A, B); *** AX=B;
print A B;
print 'eigval(A) = ' F;
print 'eigvec(A) = ' G;
print 'solve(A, B) = ' H;

	

/**************** Proc SQL **********************/
proc sql;
	create table admit2 as
	select *
	from dt.admit
	where age >= 30;
	

data lefttab;
   input Continent $ Export $ Country $;
   datalines;
NA   wheat Canada
EUR  corn  France
EUR  rice  Italy
AFR  oil   Egypt
;

data righttab;
  input Continent $ Export $ Country $;
   datalines;
NA   sugar USA
EUR  corn  Spain
EUR  beets Belgium
ASIA rice  Vietnam
;
proc print data=lefttab;
run;
proc print data=righttab;
run;

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
data table1;
	input x y z;
cards;
1 2 3
2 1 8
6 5 4
2 5 6
;
run;
data table2;
	input x b z;
cards;
1 5 3
3 5 4
2 7 8
6 0 4
;
run;
proc print data=table1;
run;
proc print data=table2;
run;
proc sql;
	select *
	from table1 natural join table2;
	

*** More Than 2 Tables;
data Comm;
	input Continent $ Export $ Country $;
cards;
NA wheat Canada
EUR corn France
EUR rice Italy
AFR oil Egypt
;
run;
data Price;
	input Export $ Price;
cards;
rice 3.56
corn 3.45
oil 18
wheat 2.98
;
run;
data Amount;
	input Country $ Quantity;
cards;
Canada 16000
France 2400
Italy 500
Egypt 10000
;
run;
proc print data=comm;
proc print data=price;
proc print data=amount;

proc sql;
	select c.country, p.export, p.price,
		a.quantity, a.quantity*p.price as Total
	from comm as c join price as p
		on (c.export = p.export)
		join amount as a
		on (c.country = a.country);

*** CASE;
data States;
	infile cards dlm="|";
	input Name $ Continent : $20.;
cards;
Indiana | North America
Chile | South America
Sweden | Europia
Iraq | Asia
Chad | Africa
Palau | Oceania
Maine | North America
Ireland | Europia
Fiji | Oceania
Japan | Asia
Florida | North America
;
run;
proc print data=states noobs;
run;

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
data summary;
	input x y z;
cards;
1 3 4
2 4 5
8 9 4
4 5 4
;
run;
proc print data=summary;

proc sql;
	select x,min(x) as x_min,
			y, min(y) as y_min,
			z, max(z) as z_max,
			sum(x, y, z) as rowsum
	from summary;
	