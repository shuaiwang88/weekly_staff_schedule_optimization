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
num_employee = 50
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


################################################################################
#       Define parameters
################################################################################

# Demand
# Demand[l,d,h,sk]


# Demand = np.array
# np.random.randint(5, size=(2,3))

a = np.zeros((5, 24))
a[0]
# Shift lengh in hour
ShiftLen = [] 
for sh in shift_set:
    shift_len = np.int(sh[2:]) - np.int(sh[:2])
    ShiftLen.append(shift_len)


# shif-h
Shift = np.empty((0,24),int)  
for sh in shift_set:
    hour_window = np.zeros(24)
    hour_window[np.int(sh[:2]):np.int(sh[2:])] = 1
    Shift = np.vstack((Shift,hour_window))



mz.dict2dzn({'shift':set(Location)}, fout = "test.mzn")














