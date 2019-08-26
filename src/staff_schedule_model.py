################################################################################
# 1. Generate data for dzn file to feed the mzn model;
# 2. Call the model to run.
# 3. Generate plot 

################################################################################

import numpy as np
import pymzn as mz



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
Location

# Shift
shift_set = np.array(['0816', '1018','1220','0812', '1014','1216','1418'])

ShiftLen = [] 
for sh in shift_set:
    shift_len = np.int(sh[2:]) - np.int(sh[:2])
    ShiftLen.append(shift_len)


Shift = np.matrix()
sh = 
for sh in shift_set:
    hour_window = np.zeros(24)
    hour_window[np.int(sh[:2]):np.int(sh[2:])] = 1
    Shift.append(hour_window, axis = 0)






