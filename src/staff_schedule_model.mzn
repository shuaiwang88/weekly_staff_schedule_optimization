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
int: num_employee;
set of int: Employee = 1..num_employee;  
% array[EmployeeNum] of string: Employee; 
% enum Employee;

% array[Products] of int: profit;
% array[Products] of string: pname; 


/* 2. Locations */
% index: l
% data: location1, location2, etc.
int: num_location;
set of int: Location = 1..num_location;  
% array[LocationNum] of string: Location; 
% enum Location;


/* 3. Shifts */
% index: sh
% data: {f412, f513, p1620,etc}
% note: full time and part time shift are both avaiable. 
int: num_shift;
% enum Shift;
set of int: Shift = 1..num_shift;  


/* 4. Skills/Positions */ 
% index: sk
% data: skill1, skill2, skill3
int: num_skill;
% enum Skill;
set of int: Skill = 1..num_skill;  


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
% index: l,d,sk, h
% data: demand by location, day, hour, and skills
% note: in labor hours. change to number of labor if it's too granluar
/* array[Location, Day, Skill, Hour] of float: Demand; */
array[Location, Day, Skill, Hour] of float: Demand;

% Shift --------------------------------------------------------
/* Shift Lengh */
% index: shift 
% note: the length of shift in hours 
/* array[location, Shift] of float: ShiftLen; */
array[Location, Shift] of float: ShiftLen;


/* Shift Hour Map */
% index: l,sh,h
% data: 0-1 matrix
array[Location, Shift, Hour] of float: ShiftHourMap;


% Employee --------------------------------------------------------

/* Employee Shift Map */
% index: e,sh,d
% note: 0-1 matrix. Employee's avaiablility on day d for shift sh
array[Employee, Shift, Day] of int: EmployeeShiftMap;

/* Employee Location Preference */
% index: e, l
% data: the problem has 4 location. we initialize the data as {-2,-1,0,1}
% note: smaller number means dislike 
array[Employee, Location] of float: EmployeeLocPref;

/* Employee Skill Map */
% index: e, sk
% note: 0-1 matrix. Employee's avaiablity for skills 
array[Employee, Skill] of int: EmployeeSkillMap;

/* Employee Max/Min Weekly Working Hours */
% index: e
array[Employee] of int: EmployeeMaxHour;

array[Employee] of int: EmployeeMinHour;


/* Employee Cost */
% index: e
array[Employee] of float: EmployeeCost;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Define Vairable
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* Assignment */
% index: e,l,d,sh,sk
% note: binary. if assign shift to e at location l on day d for skill sk
% array[Employee, Location, Day, Skill, Shift] of var 0..1: Assign;
array[Employee, Location, Day, Skill, Shift] of var 0..1: Assign;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Define Objective
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* Total Employee Cost */

var  float: TotalEmployeeCost= 
sum(e in Employee, l in Location, d in Day, sh in Shift, sk in Skill)
(Assign[e,l,d,sk,sh] * EmployeeCost[e]);
% sum(Employee, Location, Day, Shift, Skill)
% (Assign[Employee, Location, Day, Skill, Shift] * EmployeeCost[Employee]);

/* penality for location preference */

float: Penalty_Location = 10000;

% var float: PenaltyCost = 
% Penalty_Location *
% sum(e in Employee, l in Location, d in Day, sh in Shift, sk in Skill)
% (Assign[e,l,d,sk,sh] * EmployeeLocPref[e,l]);

/* Objective */

var float: objective = TotalEmployeeCost;%+ PenaltyCost;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Define Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* 1. Only one shift is allowed one day, one location, one position */
% âlâshâskAssigne,l,d,sh,skâ¤1,â e, d

constraint
forall(e in Employee, d in Day)(
    sum(l in Location, sh in Shift, sk in Skill)(
    Assign[e, l, d, sk, sh]) <= 1 
);

/* 2. Satisfy demand */
/* âeAssigne,l,d,sh,skâShiftHourMapl,sh,hâ¥Demandl,d,h,sk,â l, d, sh, sk */
 
constraint
forall(l in Location, d in Day,  sk in Skill, h in Hour)(
sum(e in Employee, sh in Shift)(
        Assign[e, l, d, sk, sh]* ShiftHourMap[l,sh,h]) >= Demand[l,d,sk,h]
 
);

/* Assignment Satisfies Shift: If the employeeâs is available for a shift, then
* he/she can be assigned. */
/* âlâskAssigne,l,d,sh,skâ¤EmployeeShiftMape,d,sh,â e, d, sh */
constraint
forall(e in Employee, d in Day, sh in Shift)(
    sum(l in Location, sk in Skill)(Assign[e, l, d, sk, sh]) <=
                                                    EmployeeShiftMap[e, sh, d]
);

/* Assignment Satisfies skills: If the emplpoyee has he needed skill for a */
/* position, then he/she can be assigned. */
/* Assigne,l,d,sh,skâ¤EmployeeSkillMape,sk,â e, l, d, sh, sk */
constraint
forall(e in Employee, l in Location, d in Day, sh in Shift, sk in Skill)(
    Assign[e, l, d, sk, sh] <= EmployeeSkillMap[e,sk]
);

% /* Employeeâs weekly hour limit: */
/* âlâdâshâskAssigne,l,d,sh,skâShiftLenl,shâ¤EmployeeMaxHoure,â e */
constraint
forall(e in Employee)(
    sum(l in Location, d in Day, sh in Shift, sk in Skill)(
    Assign[e, l, d, sk, sh]*ShiftLen[l,sh]) <= EmployeeMaxHour[e]
   
);

% constraint
% forall(e in Employee)(
%     sum(l in Location, d in Day, sh in Shift, sk in Skill)(
%     Assign[e, l, d, sk, sh]*ShiftLen[l,sh]) >= EmployeeMinHour[e]
% );

% no day shift after a night shift
% constraint 
% forall(t in Hour, k in Zone) (
%    sum(s in Hour where s >= (t - Window_Start[k]) /\ s <= (t - Window_End))
%   (PickScheduling[s,k,t] + OverPickScheduling[s,k,t]) = Demand[t,k]
% );

% constraint
% sum(f in ShiftSet where Shift_Len[f] > Hour_Part)
%    (Shift_Assign[f]) >= 
%    Ratio_Full_to_Part*sum(f in ShiftSet where Shift_Len[f] <= Hour_Part)
%    (Shift_Assign[f]);


%  For each nurse i = 1, . . . , I, and for k = 1, . . . , K â 2:
% forall(e in Employee, l in Location, d in Day[], sh in Shift)
% Assign[e, l, d, sk, sh] +  Assign[e, l, d, sk, sh] < 2 








solve minimize objective;
% output ["Objective: "++show(objective) ++ "\n" ++ show(Assign)]; 

output [show(Day[1..card(Day)-1])]; 


