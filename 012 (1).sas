libname dt "/home/hui.gong/SASUSER";

/********* Creating a Single Obervation ************/
/********* 	   from Multiple Records    ************/
data dept;
	infile "/home/hui.gong/Stat363/Raw_Data/Note12-patdata.txt";
	input LName $ FName $;
	input Department $12. JobCode $;
	input Salary : comma12.2;
	format Salary dollar12.2;
run;

*** Controller: /;
*** Readin Must Be Sequentially;
data dept;
	infile "/home/hui.gong/Stat363/Raw_Data/Note12-patdata.txt";
	input LName $ FName $ / Department $12.
			JobCode $ / Salary : comma12.2;
run;

*** Controller: #;
*** Readin Can Be Unsequentially;
data dept;
	infile "/home/hui.gong/Stat363/Raw_Data/Note12-patdata.txt";
	input #1 LName $ FName $ #2 Department $12.
			JobCode $
			#3 Salary : comma12.2;
run;

/********* Creating Multiple Obervations **********/
/********* 	   from a Single Record    ************/
*** Block Data;
data temp;
	infile "/home/hui.gong/Stat363/Raw_Data/Note13-tempdata.txt";
	input Date : date7. temp @@;
	format Date date9.;
run;

data sales_1;
	infile "/home/hui.gong/Stat363/Raw_Data/Note13-data97.txt";
	input ID Q1 : comma. Q2: comma. Q3 : comma. Q4 : comma.;
run;


* ID Quarter Sales;
data sales_2;
	infile "/home/hui.gong/Stat363/Raw_Data/Note13-data97.txt";
	input ID @;
	Quarter = 1;
	input Sales : comma. @;
	output;
	Quarter = 2;
	input Sales : comma. @;
	output;
	Quarter = 3;
	input Sales : comma. @;
	output;
	Quarter = 4;
	input Sales : comma. @;
	output;
	
run;

* More Efficient;
data sales_2;
	infile "/home/hui.gong/Stat363/Raw_Data/Note13-data97.txt";
	input ID @;
	do Quarter = 1 to 4;
		Input Sales : comma. @;
		Output;
	end;
run;

*** Vary Example;
data sales_3;
	infile "/home/hui.gong/Stat363/Raw_Data/Note13-data97_vary.txt"
		missover;
	input ID @;
	Quarter = 1;
	input Sales : comma. @;
	output;
	Quarter = 2;
	input Sales : comma. @;
	output;
	Quarter = 3;
	input Sales : comma. @;
	output;
	Quarter = 4;
	input Sales : comma. @;
	output;
run;

data sales_3;
	infile "/home/hui.gong/Stat363/Raw_Data/Note13-data97_vary.txt"
		missover;
		input ID @;
	do Quarter = 1 to 4;
		Input Sales : comma. @;
		Output;
	end;
run;
data sales_3;
	set sales_3;
	where sales ne .;
run;


*** MISSOVER and @@ Cannot Be Used Together;


*** Reading Small Size Data;

data paper;
	input type : $12. size;
	cards; *** Datalines;
legal .36
legal .51
newspring .52
newspring .52
origami .50
origami .62
;
run;

data paper;
	infile datalines dlm=",";
	input type : $12. size;
	cards; 
legal, .36
legal, .51
newspring, .52
newspring, .52
origami, .50
origami, .62
;
run;

