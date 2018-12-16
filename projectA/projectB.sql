
-- Question 1--
SELECT Course.name AS CourseName, COUNT(Student.id) AS StudentNum
FROM Course JOIN Student ON Course.id = Student.course GROUP BY Course.name;

-- Question 2--
SELECT CONCAT(yearlevel, code) AS SubjectName, COUNT(student) AS NumberOfFailures FROM StudentTakesSubject
WHERE 50 > result
GROUP BY yearlevel, area, code
HAVING COUNT(*) > 1;

-- Question 3--
SELECT student AS StudentID, 300 - SUM(creditpoints) AS Credits_Needed
FROM StudentTakesSubject 
NATURAL JOIN Subject
WHERE result >= 50 AND student in 
(SELECT Student.id FROM Student WHERE course like 'B%')
GROUP BY student;

-- Question 4--
SELECT student AS StudentID, lastname, course AS CourseName, SUM(result * creditpoints) / SUM(creditpoints) AS GPA
FROM StudentTakesSubject 
NATURAL JOIN Subject
JOIN Student ON Student.id = StudentTakesSubject.student
WHERE result IS NOT NULL AND course like 'B%'
GROUP BY id HAVING COUNT(result) > 4;

-- Question 5--
SELECT CONCAT(Lecturer.firstname,' ', Lecturer.lastname) AS LecturerName, result AS Mark,
CONCAT(area, yearlevel, code) AS Subject
FROM Lecturer JOIN Subject
NATURAL JOIN StudentTakesSubject
ON Lecturer.id = Subject.lecturer 
WHERE result IN (SELECT MAX(result) FROM StudentTakesSubject);

-- Question 6--
SELECT CONCAT(Student.firstname, Student.lastname) AS Name, result,
	 CASE 
		WHEN 50 > result THEN 'N'
        WHEN 65 > result AND result >= 50 THEN 'P'
        WHEN 70 > result AND result >= 65 THEN 'H3'
        WHEN 75 > result AND result >= 70 THEN 'H2B'
        WHEN 80 > result AND result >= 75 THEN 'H2A'
        WHEN 100 > result AND result >= 80 THEN 'H1'
	 END AS Grade
        FROM Student JOIN StudentTakesSubject ON 
        Student.id = StudentTakesSubject.student
		WHERE CONCAT(area, yearlevel, code) = 'COMP10001';

-- Question 7--
SELECT CONCAT(firstname, ' ', lastname) AS LecturerName FROM Lecturer 
WHERE Lecturer.id IN 
(SELECT DISTINCT lecturer FROM Subject WHERE yearlevel = 9) 
AND Lecturer.id 
IN (SELECT DISTINCT lecturer FROM Subject WHERE yearlevel != 9);

-- Question 8--
SELECT CONCAT(firstname, ' ', lastname) AS LecturerName 
FROM Lecturer JOIN Subject
ON Lecturer.id = Subject.lecturer
GROUP BY lecturer
HAVING COUNT(DISTINCT area) = (SELECT COUNT(DISTINCT id) FROM StudyArea);

-- Question 9--
SELECT CONCAT(firstname, ' ', lastname) AS StudentName
FROM Student NATURAL JOIN Suburb 
JOIN StudentTakesSubject ON Student.id = StudentTakesSubject.student
WHERE Suburb.name = 'Gilberton' 
AND Student.id in (SELECT student FROM StudentTakesSubject WHERE 50 > result) 
GROUP BY student
HAVING COUNT(*) > 1;

-- Question 10--
DROP TABLE IF EXISTS `StudentEvaluation`;

CREATE TABLE `StudentEvaluation` (
  `id` MEDIUMINT(8) NOT NULL,
  `evaluation` VARCHAR(50) NULL,
  `Lecturer_id` MEDIUMINT(8) UNSIGNED NOT NULL,
  `Subject_area` CHAR(4) NOT NULL,
  `Subject_yearlevel` TINYINT(3) UNSIGNED NOT NULL,
  `Subject_code` CHAR(4) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_StudentEvaluation_Lecturer1_idx` (`Lecturer_id` ASC),
  INDEX `fk_StudentEvaluation_Subject1_idx` (`Subject_area` ASC, `Subject_yearlevel` ASC, `Subject_code` ASC),
  CONSTRAINT `fk_StudentEvaluation_Lecturer1`
    FOREIGN KEY (`Lecturer_id`)
    REFERENCES `Lecturer` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_StudentEvaluation_Subject1`
    FOREIGN KEY (`Subject_area` , `Subject_yearlevel` , `Subject_code`)
    REFERENCES `Subject` (`area` , `yearlevel` , `code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE=InnoDB DEFAULT CHARSET=utf8;
