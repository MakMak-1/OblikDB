import csv
import random
import lorem

random.seed(31)

def organization():
    header = ['id', 'orgName', 'city', 'street', 'buildingNumber', 'activityType', 'ownershipForm']
    row = [1, 'AAAAAAA', 'Chernihiv', 'Shevchenka', 6, 'industrial', 'private']
    with open("Organizations.csv", mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(header)
        writer.writerow(row)

def positions():
    header = ['id', 'positionName', 'wageRate', 'category', 'payment']
    postion_names = []
    categories = ['fahivets', 'slujbovets', 'robitnik']
    payment_forms = ['pohodinna', 'vidryadna']
    with open('lists\\position_names.txt', 'r') as file:
        postion_names = file.read().split('\n')

    with open("Positions.csv", mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(header)
        for i in range(1, 201):
            id = i
            positionName = random.choice(postion_names)
            wageRate = random.randint(40, 500)
            category = random.choice(categories)
            payment = random.choice(payment_forms)

            if category != 'robitnik':
                payment = 'pohodinna'
            if payment == 'vidryadna':
                wageRate = ''
            row = [id, positionName, wageRate, category, payment]
            writer.writerow(row)

def worker_categories():
    header = ['category', 'coefficient']
    with open("WorkerCategories.csv", mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(header)
        writer.writerow([1, 1.0])
        writer.writerow([2, 1.2])
        writer.writerow([3, 1.35])
        writer.writerow([4, 1.5])
        writer.writerow([5, 1.7])
        writer.writerow([6, 2.0])

def employee_positions():
    header = ['id', 'appointmentDate', 'annualLeave', 'positionID', 'workerCategory', 'departmentID', 'positionStatus', 'employeeID']
    positions = []
    statuses = ['past', 'current']
    with open('Positions.csv', mode='r') as file:
        csv_reader = csv.reader(file)
        positions = list(csv_reader)
    
    k = 1
    with open("EmployeePositions.csv", mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(header)
        for i in range(1, 1001):
            past_year = 2020
            past_month = 1
            past_day = 1
            employeeID = i

            row = []
            flag = True
            while random.randint(1, 3) == 1 or flag:
                if len(row) > 0:
                    writer.writerow(row)

                id = k
                year = random.randint(past_year, 2025)
                if year == past_year:
                    month = random.randint(past_month, 12)
                else:
                    month = random.randint(1, 12)
                if year == past_year and month == past_month:
                    day = random.randint(past_day, 28)
                else:
                    day = random.randint(1, 28)
                appointmentDate = f'{year}-{month}-{day}'
                annualLeave = random.randint(24, 59)
                positionID = random.randint(1, 200)
                workerCategory = random.randint(1, 6)
                if positions[positionID][3] != 'robitnik':
                    workerCategory = ''
                departmentID = random.randint(1, 15)

                row = [id, appointmentDate, annualLeave, positionID, workerCategory, departmentID, statuses[0], employeeID]
                k += 1
                flag = False
                past_year = year
                past_month = month
                past_day = day

            row[6] = statuses[1]
            writer.writerow(row)

def employees():
    header = ['id', 'employeeName', 'surname', 'middlename', 'sex', 'education', 'birthDate', 'specialty', 'qualification']
    names = []
    surnames = []
    middlenames = []
    sexes = ['M', 'F']
    educations = ['primary', 'bachelor', 'master', 'phd']
    qualifications = ['high', 'normal', 'small']

    with open('lists\\names.txt', 'r') as file:
        names = file.read().split('\n')

    with open('lists\\surnames.txt', 'r') as file:
        surnames = file.read().split('\n')

    with open('lists\\middlenames.txt', 'r') as file:
        middlenames = file.read().split('\n')

    with open("Employees.csv", mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(header)
        for i in range(1, 1023):
            id = i
            employeeName = random.choice(names)
            surname = random.choice(surnames).capitalize()
            middlename = random.choice(middlenames)
            sex = random.choice(sexes)
            education = random.choice(educations)
            year = random.randint(1965, 2004)
            month = random.randint(1, 12)
            day = random.randint(1, 28)
            birthDate = f'{year}-{month}-{day}'
            specialty = 'specialty ' + str(random.randint(1, 50))
            qualification = random.choice(qualifications)

            row = [id, employeeName, surname, middlename, sex, education, birthDate, specialty, qualification]
            writer.writerow(row)

def departments():
    header = ['id', 'managerID', 'departmentName']

    with open("Departments.csv", mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(header)
        for i in range(1, 16):
            id = i
            departmentName = "Department " + str(i)
            managerID = random.randint(1, 6)
            if i <= 6:
                managerID = i

            row = [id, managerID, departmentName]
            writer.writerow(row)

def managers():
    header = ['id', 'orgID', 'employeeID']

    with open("Managers.csv", mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(header)
        for i in range(1, 7):
            id = i
            orgID = 1
            employeeID = 1015 + i

            row = [id, orgID, employeeID]
            writer.writerow(row)

def documents():
    header = ['id', 'employeeID', 'documentType', 'document']

    with open("Documents.csv", mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(header)
        for i in range(1, 3001):
            id = i
            employeeID = random.randint(1, 1022)
            documentType = random.choice(['nakaz', 'zajava', 'dovidka'])
            document = ''

            row = [id, employeeID, documentType, document]
            writer.writerow(row)

def bonuses():
    header = ['id', 'bonusType', 'precentage']

    with open("Bonuses.csv", mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(header)
        for i in range(1, 11):
            id = i
            bonusType = lorem.sentence()
            precentage = random.randint(1, 80)

            row = [id, bonusType, precentage]
            writer.writerow(row)

def allowances():
    header = ['id', 'allowanceType', 'precentage']

    with open("Allowances.csv", mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(header)
        for i in range(1, 100):
            a = random.randint(2, 4)

        for i in range(1, 11):
            id = i
            allowanceType = lorem.sentence()
            precentage = random.randint(1, 80)

            row = [id, allowanceType, precentage]
            writer.writerow(row)

def employeepos_bonuses():
    header = ['employeePositionID', 'bonusID']

    with open("EmployeePositionsBonuses.csv", mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(header)

        for i in range(1, 1549):
            employeePositionID = i
            used = [-1]
            while random.randint(1, 3) == 1:
                bonusID = -1
                while used.count(bonusID) != 0:
                    bonusID = random.randint(1, 10)
                used.append(bonusID)
                row = [employeePositionID, bonusID]
                writer.writerow(row)

def employeepos_allowances():
    header = ['employeePositionID', 'allowanceID']

    with open("EmployeePositionsAllowances.csv", mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(header)

        for i in range(1, 100):
            a = random.randint(2, 4)

        for i in range(1, 1549):
            employeePositionID = i
            used = [-1]
            while random.randint(1, 3) == 1:
                allowanceID = -1
                while used.count(allowanceID) != 0:
                    allowanceID = random.randint(1, 10)
                used.append(allowanceID)
                row = [employeePositionID, allowanceID]
                writer.writerow(row)

def products():
    header = ['id', 'productName', 'timeToMake']

    with open("Products.csv", mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(header)

        for i in range(1, 101):
            id = i
            productName = "product " + str(i)
            timeToMake = random.randint(1, 10)

            row = [id, productName, timeToMake]
            writer.writerow(row)

def work_accounting():
    header = ['id', 'productID', 'productAmount', 'employeePositionID', 'workDate']
    positions = []
    curr_positions = []

    with open('Positions.csv', mode='r') as file:
        csv_reader = csv.reader(file)
        positions = list(csv_reader)

    with open('EmployeePositions.csv', mode='r') as file:
        csv_reader = csv.reader(file)
        next(csv_reader)
        curr_positions = list(csv_reader)

    with open("WorkAccounting.csv", mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(header)

        k = 1
        for currpos_row in curr_positions:
            positionID = int(currpos_row[3])
            position_row = positions[positionID]
            payment = position_row[4]

            if payment == 'vidryadna':
                start_date = currpos_row[1]
                (start_year, start_month, start_day) = start_date.split('-')
                start_year = int(start_year)
                start_month = int(start_month)
                start_day = int(start_day)

                next_pos = curr_positions[int(currpos_row[0])]
                (end_year, end_month, end_day) = (2025, 12, 28)
                if (next_pos[-1] == currpos_row[-1]):
                    end_date = next_pos[1]
                    (end_year, end_month, end_day) = end_date.split('-')
                    end_year = int(end_year)
                    end_month = int(end_month)
                    end_day = int(end_day)
                (curr_end_month, curr_end_day) = (12, 28)

                for year in range(start_year, end_year + 1):
                    if (year == end_year):
                        curr_end_month = end_month

                    for month in range(start_month, curr_end_month + 1):
                        if (year == end_year and month == end_month):
                            curr_end_day = end_day

                        for day in range(start_day, curr_end_day + 1):
                            id = k
                            productID = random.randint(1, 100)
                            productAmount = random.randint(1, 4)
                            employeePositionID = int(currpos_row[0])
                            workDate = f'{year}-{month}-{day}'

                            row = [id, productID, productAmount, employeePositionID, workDate]
                            writer.writerow(row)
                            k += 1
                        start_day = 1
                    start_month = 1

def timesheets():
    header = ['id', 'dateYear', 'dateMonth', 'employeePositionID']
    curr_positions = []

    with open('EmployeePositions.csv', mode='r') as file:
        csv_reader = csv.reader(file)
        next(csv_reader)
        curr_positions = list(csv_reader)
    
    with open("Timesheets.csv", mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(header)

        k = 1
        for currpos_row in curr_positions:
            start_date = currpos_row[1]
            (start_year, start_month, _) = start_date.split('-')
            start_year = int(start_year)
            start_month = int(start_month)

            next_pos = []
            if int(currpos_row[0]) < len(curr_positions):
                next_pos = curr_positions[int(currpos_row[0])]
            
            (end_year, end_month) = (2025, 12)
            if (len(next_pos) != 0 and next_pos[-1] == currpos_row[-1]):
                end_date = next_pos[1]
                (end_year, end_month, _) = end_date.split('-')
                end_year = int(end_year)
                end_month = int(end_month)
            curr_end_month = 12

            for year in range(start_year, end_year + 1):
                if year == end_year:
                    curr_end_month = end_month

                for month in range(start_month, curr_end_month + 1):
                    id = k
                    dateYear = year
                    dateMonth = month
                    employeePositionID = int(currpos_row[0])
                    row = [id, dateYear, dateMonth, employeePositionID]

                    writer.writerow(row)
                    k += 1
                start_month = 1

def time_spendings():
    header = ['id', 'dateDay', 'hoursAmount', 'spendingType', 'timesheetID']
    timesheets = []

    with open('EmployeePositions.csv', mode='r') as file:
        csv_reader = csv.reader(file)
        next(csv_reader)
        curr_positions = list(csv_reader)

    with open('Timesheets.csv', mode='r') as file:
        csv_reader = csv.reader(file)
        next(csv_reader)
        timesheets = list(csv_reader)

    k = 1
    counter = 1
    with open("TimeSpendings.csv", mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(header)

        for timesheet_row in timesheets:
            pos_id = int(timesheet_row[3])
            year = int(timesheet_row[1])
            month = int(timesheet_row[2])

            currpos_row = curr_positions[pos_id - 1]
            start_date = currpos_row[1]
            (start_year, start_month, start_day) = start_date.split('-')
            start_year = int(start_year)
            start_month = int(start_month)
            start_day = int(start_day)
            next_pos = []
            if int(currpos_row[0]) < len(curr_positions):
                next_pos = curr_positions[int(currpos_row[0])]
            (end_year, end_month, end_day) = (2025, 12, 28)
            if (len(next_pos) != 0 and next_pos[-1] == currpos_row[-1]):
                end_date = next_pos[1]
                (end_year, end_month, end_day) = end_date.split('-')
                end_year = int(end_year)
                end_month = int(end_month)
                end_day = int(end_day)
            
            if not (year == start_year and month == end_month):
                start_day = 1

            if not (year == end_year and month == end_month):
                end_day = 28 

            for dateDay in range(start_day, end_day + 1):
                id = k
                spendingType = 'P'
                hoursAmount = 8
                if counter == 6 or counter == 7:
                    spendingType = 'X'
                    hoursAmount = 0
                if random.randint(1, 20) == 1:
                    spendingType = 'B'
                    hoursAmount = 0
                elif random.randint(1, 365) == 1:
                    spendingType = 'H3'
                    hoursAmount = 0
                timesheetID = int(timesheet_row[0])

                row = [id, dateDay, hoursAmount, spendingType, timesheetID]
                writer.writerow(row)
                k += 1
                counter = (counter % 7) + 1
