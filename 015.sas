libname dt "/home/hui.gong/SASUSER";

*** Delete Obs;
data stress;
	set stress;
	if tolerance = "I" then delete;
run;

*** Keep or Drop Variables;
* Slowest;
data stress_1;
	set stress;
	keep id name;
run;
* Fastest;
data stress_2;
	set stress(keep=id name);
run;
data stress_3(keep=id name);
	set stress;
run;

*** Assign Labels and Formats;
data stress;
	set stress;
	label RestHR = "Heart Rate when Rest";
	label MaxHR = "Maximal Heart Rate";
	format RestHR comma10.2 MaxHR comma8.3;
run;

*** Remove Labels;
data stress_1;
	set stress;
	label RestHR = '';
run;
* Remove All Labels at Once;
data stress_1;
	set stress;
	attrib _all_ label='';
run;
proc datasets;
	modify stress;
	attrib _all_ label='';
run;

* Remove Format;
data stress_2;
	set stress;
	format RestHR;
run;
* Remove All Formats At Once;
proc datasets;
	modify stress;
	attrib _all_ format=;
run;

*** Group Statements;
* Do-End;
data stress;
	set dt.stress;
	TotalSec = timemin * 60 + timesec;
	if totalsec > 800 then do;
		TestLength = "Long";
		Message = "Run Blood Test";
		Alert = "Alert to Dr";
	end;
run;

* Count Observations: _N_;
data stress;
	set dt.stress;
	Count = _N_;
run;

* First and Last Variables;
proc sort data=dt.stress out=stress;
	by tolerance;
run;
data stress;
	set stress;
	by tolerance;
	if first.tolerance then Count = 1;
	else count + 1;
run;
data stress_1;
	set stress;
	by tolerance;
	if last.tolerance;
	keep tolerance count;
run;

*** InClass Practice 16;
data states;
	infile "/home/hui.gong/my_shared_file_links/hui.gong/c_8977/STAT363/Note16-InClass-Practice.txt"
	firstobs=2;
	input State & : $20. Area : comma.
		Population : comma. Region : $10.;
run;
data states;
	set states;
	label Area = "Area in Squared Miles";
	label Population = "Population in 1000";
run;
proc sort data=states;
	by region;
run;
data states_1;
	set states;
	by region;
	if first.region then Region_Count = 1;
	else Region_Count + 1;
run;
data states_2;	
	set states_1;
	by region;
	if last.region;
	keep region region_count;
run;
proc sort data=states;
	by region area;
run;
data states_3;
	set states;
	by region area;
	if first.region then Note = "Smallest State";
	if last.region then Note = "Largest State";
run;
data states_4;
	set states;
	Total_Population + Population;
	Total_Area + Area;
run;
data states_5;
	set states;
	if state in ("Indiana", "Pennsylvania");
	keep state population area region;
run;

/******* Self-Defined Format *************/
data employee;
	infile "/home/hui.gong/Stat363/Raw_Data/Note17-employee.txt";
	input FName $ LName $ JobCode Salary Response $;
run;

proc format;
	value jobfmt
		103 = "Manager"
		105 = "Text Processor"
		111 = "Associate Writer"
		112 = "Writer"
		113 = "Senoir Writer";
	value $responsefmt
		"Y" = "Yes"
		"N" = "No"
		"U" = "Undecided"
		"NOP" = "No Opinion";
run;
data employee;
	set employee;
	format jobcode jobfmt.
		response $responsefmt.;
run;

data person;
	input Name $ Age;
cards;
John 10
Jane 20
Joseph 67
Joshua 16
Jenny 5
Jacob 33
Joy 55
Jesse .
Jake 105
;
run;
proc format;
	value agefmt
		low-<13 = "Child"
		13-<20 = "Teenage"
		20-<65 = "Adult"
		65-high = "Senior"
		other = "Unknown";
run;
data person;
	set person;
	format age agefmt.;
run;
proc print data=person;
run;
