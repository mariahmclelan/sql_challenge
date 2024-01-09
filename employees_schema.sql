--create tables exported from quick dbd
CREATE TABLE "departments" (
    "dept_no" VARCHAR (4) NOT NULL,
    "dept_name" VARCHAR (30)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "department_employees" (
    "emp_no" INTEGER NOT NULL,
    "dept_no" VARCHAR(4) NOT NULL,
    CONSTRAINT "pk_department_employees" PRIMARY KEY (
        "emp_no","dept_no"
     )
);

CREATE TABLE "department_mang" (
    "dept_no" VARCHAR(4) NOT NULL,
    "emp_no" INTEGER NOT NULL,
    CONSTRAINT "pk_department_mang" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "employees" (
    "emp_no" INTEGER NOT NULL,
    "emp_title_id" VARCHAR(30)  NOT NULL,
    "birth_date" VARCHAR(10)   NOT NULL,
    "first_name" VARCHAR(50)   NOT NULL,
    "last_name" VARCHAR(50)   NOT NULL,
    "sex" VARCHAR(10)  NOT NULL,
    "hire_date" VARCHAR(10)  NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INTEGER NOT NULL,
    "salary" INTEGER   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "titles" (
    "title_id" VARCHAR(5)  NOT NULL,
    "title" VARCHAR(30) NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

ALTER TABLE "department_employees" ADD CONSTRAINT "fk_department_employees_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "department_employees" ADD CONSTRAINT "fk_department_employees_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "department_mang" ADD CONSTRAINT "fk_department_mang_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "department_mang" ADD CONSTRAINT "fk_department_mang_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");


--data analysis 
--1. List the employee number, last name, first name, sex, and salary of each employee.
SELECT 
    e.emp_no, 
    e.first_name,
    e.last_name, 
    e.sex, 
    s.salary
FROM employees e
JOIN salaries s ON
    s.emp_no=e.emp_no;

--2. List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT 
    first_name, 
    last_name, 
    hire_date
FROM employees
WHERE EXTRACT(YEAR FROM hire_date::date) = 1986;

--3. List the manager of each department along with their department number, department name, employee number, last name, and first name.
--number number?
SELECT 
    dm.emp_no,
    dm.dept_no, 
    e.first_name,
    e.last_name,
    e.emp_no
FROM employees e
JOIN department_mang dm ON
    dm.emp_no=e.emp_no;

--4. List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
--All not managers
SELECT 
    
    e.emp_no
    e.last_name,
    e.first_name,
    d.dept_no,
    d.dept_name,
FROM 
    employees e
JOIN 
    department_employees de ON e.emp_no = de.emp_no
JOIN 
    departments d ON de.dept_no = d.dept_no;

--5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

--6. List each employee in the Sales department, including their employee number, last name, and first name.
SELECT 
    e.emp_no
    e.last_name,
    e.first_name
FROM 
    departments d
JOIN 
    department_employees de ON d.dept_no = de.dept_no
JOIN 
    employees e ON de.emp_no = e.emp_no
WHERE 
    d.dept_name = 'Sales';

--7. List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT 
    e.emp_no,
    e.last_name,
    e.first_name,
    d.dept_name
FROM 
    departments d
JOIN 
    department_employees de ON d.dept_no = de.dept_no
JOIN 
    employees e ON de.emp_no = e.emp_no
WHERE 
    d.dept_name = 'Sales' OR d.dept_name = 'Development';
    
--8. List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT last_name, COUNT(*) AS last_name_count
FROM employees
GROUP BY last_name
ORDER BY last_name_count DESC;