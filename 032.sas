libname dt "/home/hui.gong/SASUSER";

/******* Multiple Linear Regression *************/
*  Outlier: unusually large/small on y-direction;
*  Influential Observation:
	unusually large/small on x-direction;
proc reg data=electric;
	model peak = housize income aircapac applindx
			family / influence;
run;

*** Outlier: RStudent |value|>2;

*** Influential Observation;
**  Hat Diag H (Diagnoal hat matrix): >2p/n;
**  p is the # of indepdent variables;
**  n is the # of observations used in the model;
** Cov Ratio: |Cov Ratio - 1| > 3*p/n;
** DFFITS:  > 2;
** DFBETAS: > 2;

*** Overall: twice of apperance;


*** Model Selection;
**  Automat Selection;
**  Forward, Backward, Stepwise;
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

	







