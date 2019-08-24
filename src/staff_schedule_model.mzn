%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Weekly staffing model 
% Goal: create a weekly staffing model with constraints
% 
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
enum EmployeeSet;

/* 2. Locations */
% index: l
% data: location1, location2, etc.
enum LocationSet;

/* 3. Shifts */
% index: sh
% data: {f412, f513, p1620,etc}
% note: full time and part time shift are both avaiable. 
enum ShiftSet;


/* 4. Skills/Positions */ 
% index: sk
% data: skill1, skill2, skill3
enum SkllSet;

/* 5. Days */
% index: d
% data: 1-8
set of int: Days = 1..8;

/* 6. Hours */
% index: t
% data: 1-24
set of int: Hours = 1..24;









































































































