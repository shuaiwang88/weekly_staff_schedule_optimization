################################################################################
# 1. Generate data for dzn file to feed the mzn model;
# 2. Call the model to run.
# 3. Generate plot
################################################################################

import numpy as np
import pymzn as mz


np.random.seed(0)

################################################################################
#       Define Sets
################################################################################

# Employee
num_employee = 100
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
num_shift = len(Shift)


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
# Demand[l,d,sk,h]

np.random.seed(0)
Demand = np.empty((0,24))
for i in np.arange(len(Location) * len(Day) *len(Skill)):
    demand_hour = np.zeros(24)
    demand_hour[8:20] = np.random.randint(1,4, size=12)
    Demand = np.vstack((Demand, demand_hour))

Demand.shape=(len(Location), len(Day), len(Skill), 24)

# Shift length in hour (l,sh)
# ShiftLen = []
# for sh in Shift:
#     shift_len = np.int(sh[2:]) - np.int(sh[:2])
#     ShiftLen.append(shift_len)

ShiftLen = []
for i in np.arange(num_location):
    for sh in Shift:
        shift_len = np.int(sh[2:]) - np.int(sh[:2])
        ShiftLen.append(shift_len)

ShiftLen = np.array(ShiftLen)
ShiftLen.shape = ((num_location, num_shift))

# shift Hour Map (l, sh,h)

# ShiftHourMap = np.empty((0,24),int)
# for sh in Shift:
#     hour_window = np.zeros(24)
#     hour_window[np.int(sh[:2]):np.int(sh[2:])] = 1
#     ShiftHourMap = np.vstack((ShiftHourMap,hour_window))

ShiftHourMap = np.empty((0,24),int)
for i in np.arange(num_location):
    for sh in Shift:
        hour_window = np.zeros(24)
        hour_window[np.int(sh[:2]):np.int(sh[2:])] = 1
        ShiftHourMap = np.vstack((ShiftHourMap,hour_window))

ShiftHourMap.shape = ((num_location, num_shift, len(Hour)))
# Emplpoyee

# Employee Shift Map (e,sh,d)

np.random.seed(0)
EmployeeShiftMap = np.random.randint(2,
        size=(len(Employee)*len(Day), len(Shift)))

EmployeeShiftMap.shape = (len(Employee), len(Shift), len(Day))

# Employee Location preference (e,l)
LocPref = [-2, -1, 0, 1]

EmployeeLocPref = np.empty((0, len(LocPref)))

np.random.seed(0)
for i in np.arange(len(Employee)):
    pref = np.random.choice(LocPref, len(LocPref),
        replace= False)
    EmployeeLocPref = np.vstack((EmployeeLocPref, pref))

EmployeeLocPref


# Employee Skill Map (e,sk)
np.random.seed(0)
EmployeeSkillMap = np.random.randint(2, size = (len(Employee), len(Skill)))


# Employ Max/Min weekly hour
MaxHour = [20, 40]
MinHour = [0, 20]

np.random.seed(0)
EmployeeMaxHour = np.random.choice(MaxHour, len(Employee))
EmployeeMinHour = np.random.choice(MinHour, len(Employee))



# Employee Cost perhour
CostPerHour = [10,12,15]
np.random.seed(0)
EmployeeCost = np.random.choice(CostPerHour, len(Employee))


# mz.dict2dzn({'shift':set(Location)}, fout = "test.mzn")


y = np.zeros((2, 3, 4))
y

mz_data = mz.dict2dzn({
        'Employee':set(Employee),
        'Location':set(Location),
        'Shift': set(Shift),
        'Skill': set(Skill),
        'num_employee': num_employee,
        'num_location': num_location,
        'num_shift': num_shift,
        'num_skill': num_skill,
        'Demand': Demand,
        'ShiftLen': ShiftLen,
        'ShiftHourMap':ShiftHourMap,
        'EmployeeShiftMap': EmployeeShiftMap,
        'EmployeeLocPref': EmployeeLocPref,
        'EmployeeSkillMap':  EmployeeSkillMap,
        'EmployeeMaxHour': EmployeeMaxHour,
        'EmployeeMinHour':EmployeeMinHour,
        'EmployeeCost': EmployeeCost
        }, fout = 'data_simulate.dzn')
