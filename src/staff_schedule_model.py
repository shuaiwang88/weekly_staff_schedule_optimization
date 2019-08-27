################################################################################
# 1. Generate data for dzn file to feed the mzn model;
# 2. Call the model to run.
# 3. Generate plot 

################################################################################

import numpy as np
import pymzn as mz
import pandas as pd


################################################################################
#       Define Sets
################################################################################

# Employee
num_employee = 20
Employee = np.char.add(np.full(num_employee, 'Employee'),
        np.arange(num_employee).astype(str))


# Location
num_location = 4
Location = np.char.add(np.full(num_location, 'Location'),
        np.arange(num_location).astype(str))
Location = Location.astype(set)
Location


# Shift
Shift  = np.array(['0816', '1018','1220','0812', '1014','1216','1418'])


# Skill
num_skill = 3
Skill = np.char.add(np.full(num_skill, 'Skill'),
        np.arange(num_skill).astype(str))

# Days and Hours are defined in the mzn file

Day = np.arange(7)
Hour = np.arange(24)
################################################################################
#       Define parameters
################################################################################

# Demand
# Demand[l,d,h,sk]

Demand = np.empty((0,24))
for i in np.arange(len(Location) * len(Day) * len(Hour)*len(Skill)):
    demand_hour = np.zeros(24)
    demand_hour[8:20] = np.random.randint(1,4, size=12)
    Demand = np.vstack((Demand, demand_hour))

# Shift length in hour
ShiftLen = [] 
for sh in Shift:
    shift_len = np.int(sh[2:]) - np.int(sh[:2])
    ShiftLen.append(shift_len)

# shift Hour Map
ShiftHourMap = np.empty((0,24),int)  
for sh in Shift:
    hour_window = np.zeros(24)
    hour_window[np.int(sh[:2]):np.int(sh[2:])] = 1
    ShiftHourMap = np.vstack((ShiftHourMap,hour_window))





# Emplpoyee 

# Employee Shift Map (e,d,sh)

EmployeeShiftMap 









mz.dict2dzn({'shift':set(Location)}, fout = "test.mzn")















