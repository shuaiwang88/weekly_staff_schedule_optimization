%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Weekly staffing model Goal: create a weekly staffing model with constraints 
% Reqiurment: 
%    1. Forecasting of demand in labor hours (or just # of labors)
%    2. Pre-configured shift plan with start and end hour. 
%   
% Output:
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Define Sets
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* 1. Employees */  
% index: e. 
% data: employee1, employee2, etc.
enum Employee;

/* 2. Locations */
% index: l
% data: location1, location2, etc.
enum Location;

/* 3. Shifts */
% index: sh
% data: {f412, f513, p1620,etc}
% note: full time and part time shift are both avaiable. 
enum Shift;


/* 4. Skills/Positions */ 
% index: sk
% data: skill1, skill2, skill3
enum Skll;

/* 5. Days */
% index: d
% data: 1-8
set of int: Days = 1..8;

/* 6. Hours */
% index: t
% data: 1-24
set of int: Hours = 1..24;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Define Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Demand --------------------------------------------------------
/* Demand */
% index: l,d,h,sk
% data: demand by location, day, hour, and skills
% note: in labor hours. change to number of labor if it's too granluar
array[Location, Day, Hour, Skill] of float: Demand;

% Shift --------------------------------------------------------
/* Shift Lengh */
% index: shift 
% note: the length of shift in hours 
array[Location, Shift] of float: ShiftLen;


/* Shift Hour Map */
% index: l,sh,h
% data: 0-1 matrix
array[Location, Shift, Hour] of int: ShiftHourMap;


% Employee --------------------------------------------------------

/* Employee Shift Map */
% index: e,d,sh
% note: 0-1 matrix. Employee's avaiablility on day d for shift sh
array[Employee, Day, Shift] of int: EmployeeShiftMap;

/* Employee Location Preference */
% index: e, l
% data: the problem has 4 location. we initialize the data as {-2,-1,0,1}
% note: smaller number means dislike 
array[Employee, Location] of int: EmployeeLocPref;

/* Employee Skill Map */
% index: e, sk
% note: 0-1 matrix. Employee's avaiablity for skills 
array[Employee, Skill] of int: EmployeeSkillMap;

/* Employee Max/Min Weekly Working Hours */
% index: e
array[Employee] of float: EmployeeMaxHour;

array[Employee] of float: EmployeeMinHour;


/* Employee Cost */
% index: e
array[Employee] of float: EmployeeCost;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Define Vairable
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* Assignment */
% index: e,l,d,sh,sk
% note: binary. if assign shift to e at location l on day d for skill sk
array[Employee, Location, Day, Shift, Skill] of var 0..1: Assign;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Define Objective
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* Total Employee Cost */

var TotalEmployeeCost = 
sum(e in Employee, l in Location, d in Day, sh in Shift, sk in Skill)
(Assign[e,l,d,sh,sk] * EmployeeCost[e]);


/* penality for location preference */

float: Penalty_Location = 10000;

var PenaltyCost = 
PenaltyCost *
sum(e in Employee, l in Location, d in Day, sh in Shift, sk in Skill)
(Assign[e,l,d,sh,sk] * EmployeeLocPref[e,l]);

/* Objective */

var float: objective = TotalEmployeeCost + PenaltyCost;




