CREATE DEFINER=`root`@`localhost` PROCEDURE `terminate_student_enrollment`(
-- This procedure accepts four parameters
  StudentID_in varchar(45),
  CourseCode_in varchar(45),
  Section_in varchar(45),
  EffectiveDate_in date
)
BEGIN

DECLARE ID_Student_out int;
DECLARE ID_Class_out int;
-- SET EffectiveDate = NOW();

-- You can assign a value to a variable by using the SET command
SET ID_Student_out = (SELECT ID_Student FROM Student WHERE StudentID = StudentID_in);

-- You can also assign a value by SELECTing INTO the variable
SELECT
  ID_Class
INTO
  ID_Class_out
FROM
  Class c
  INNER JOIN COURSE co
  ON c.ID_Course = co.ID_Course
WHERE
  CourseCode = CourseCode_in
  AND Section = Section_in;

UPDATE classparticipant SET `EndDate` = EffectiveDate_in WHERE (ID_Class  = ID_Class_out AND ID_Student = ID_Student_out);

-- Inset into the ClassParticipant table the dereferenced values
-- INSERT INTO ClassParticipant(ID_Student, ID_Class, StartDate)
-- VALUES (ID_Student_out, ID_Class_out, StartDate_in);
--  DELETE FROM classparticipant WHERE (ID_Class  = ID_Class_out AND ID_Student = ID_Student_out);

END