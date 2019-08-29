%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Weekly staffing model Goal: create a weekly staffing model with constraints 
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
int: num_employee;

/* 2. Locations */
% index: l
% data: location1, location2, etc.
enum Location;
int: num_location;

/* 3. Shifts */
% index: sh
% data: {f412, f513, p1620,etc}
% note: full time and part time shift are both avaiable. 
enum Shift;
int: num_shift;


/* 4. Skills/Positions */ 
% index: sk
% data: skill1, skill2, skill3
enum Skill;
int: num_skill;

/* 5. Days */
% index: d
% data: 1-8
set of int: Day = 1..7;

/* 6. Hours */
% index: t
% data: 1-24
set of int: Hour = 1..24;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Define Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Demand --------------------------------------------------------
/* Demand */
% index: l,d,h,sk
% data: demand by location, day, hour, and skills
% note: in labor hours. change to number of labor if it's too granluar
/* array[Location, Day, Skill, Hour] of float: Demand; */
array[1..num_location, Day, 1..num_skill, Hour] of float: Demand;

% Shift --------------------------------------------------------
/* Shift Lengh */
% index: shift 
% note: the length of shift in hours 
/* array[location, Shift] of float: ShiftLen; */
array[1..num_location, 1..num_shift] of float: ShiftLen;


/* Shift Hour Map */
% index: l,sh,h
% data: 0-1 matrix
array[1..num_location, 1..num_shift, Hour] of float: ShiftHourMap;


% Employee --------------------------------------------------------

/* Employee Shift Map */
% index: e,sh,d
% note: 0-1 matrix. Employee's avaiablility on day d for shift sh
array[1..num_employee, 1..num_shift, Day] of int: EmployeeShiftMap;

/* Employee Location Preference */
% index: e, l
% data: the problem has 4 location. we initialize the data as {-2,-1,0,1}
% note: smaller number means dislike 
array[1..num_employee, 1..num_location] of float: EmployeeLocPref;

/* Employee Skill Map */
% index: e, sk
% note: 0-1 matrix. Employee's avaiablity for skills 
array[1..num_employee, 1..num_skill] of int: EmployeeSkillMap;

/* Employee Max/Min Weekly Working Hours */
% index: e
array[1..num_employee] of int: EmployeeMaxHour;

array[1..num_employee] of int: EmployeeMinHour;


/* Employee Cost */
% index: e
array[1..num_employee] of float: EmployeeCost;


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

var  float: TotalEmployeeCost= 
sum(e in Employee, l in Location, d in Day, sh in Shift, sk in Skill)
(Assign[e,l,d,sh,sk] * EmployeeCost[e]);


/* penality for location preference */

float: Penalty_Location = 10000;

var float: PenaltyCost = 
Penalty_Location *
sum(e in Employee, l in Location, d in Day, sh in Shift, sk in Skill)
(Assign[e,l,d,sh,sk] * EmployeeLocPref[e,l]);

/* Objective */

var float: objective = TotalEmployeeCost;%+ PenaltyCost;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Define Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* 1. Only one shift is allowed one day, one location, one position */
% ∑l∑sh∑skAssigne,l,d,sh,sk≤1,∀ e, d

constraint
forall(e in Employee, d in Day)(
    sum(l in Location, sh in Shift, sk in Skill)(
    Assign[e, l, d, sh, sk]) <= 1 
);

/* 2. Satisfy demand */
/* ∑eAssigne,l,d,sh,sk∗ShiftHourMapl,sh,h≥Demandl,d,h,sk,∀ l, d, sh, sk */
 
% constraint


% constraint
% forall(l in Location, d in Day,  sk in Skill, h in Hour)(
% sum(e in Employee, sh in Shift)(
%         Assign[e, l, d, sh, sk]* ShiftHourMap[l,sh,h]) >= Demand[l,d,sk,h]
 
% );





/* Assignment Satisfies Shift: If the employee’s is available for a shift, then
* he/she can be assigned. */
/* ∑l∑skAssigne,l,d,sh,sk≤EmployeeShiftMape,d,sh,∀ e, d, sh */
% constraint
% forall(e in Employee, d in Day, sh in Shift)(
%     sum(l in Location, sk in Skill)(Assign[e, l, d, sh, sk]) <=
%                                                     EmployeeShiftMap[e, sh, d]
% );


/* Assignment Satisfies skills: If the emplpoyee has he needed skill for a */
/* position, then he/she can be assigned. */
/* Assigne,l,d,sh,sk≤EmployeeSkillMape,sk,∀ e, l, d, sh, sk */
constraint
forall(e in Employee, l in Location, d in Day, sh in Shift, sk in Skill)(
    Assign[e, l, d, sh, sk] <= EmployeeSkillMap[e,sk]
);

/* Employee’s weekly hour limit: */
/* ∑l∑d∑sh∑skAssigne,l,d,sh,sk∗ShiftLenl,sh≤EmployeeMaxHoure,∀ e */
constraint
forall(e in Employee)(
    sum(l in Location, d in Day, sh in Shift, sk in Skill)(
    Assign[e, l, d, sh, sk]*ShiftLen[l,sh]) <= EmployeeMaxHour[e]
   
);
constraint
forall(e in Employee)(
    sum(l in Location, d in Day, sh in Shift, sk in Skill)(
    Assign[e, l, d, sh, sk]*ShiftLen[l,sh]) >= EmployeeMinHour[e]
);



solve minimize objective;
output ["Objective: "++show(objective) ++ "\n" ++
show(Assign)
];



