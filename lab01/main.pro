
implement main
    open core, file, stdio

domains
    educational_program = нпи; нфи; нфз.

class facts - students
    student : (string Id, string Student_name, string Email, integer* Marks).
    group : (integer Id, educational_program Educational_program, integer Group, integer Year).
    find_group : (integer GroupId, string StudentId).
    group_leader : (integer GroupId, string StudentId).
    subject : (integer Id, string SubjectName, educational_program Educational_program, integer Course).

class predicates
    group_students : (educational_program Educational_program, integer Group, integer Year) nondeterm.
    group_leaders : (educational_program Educational_program) nondeterm.
    studied_subjects : (string StudentId) nondeterm.
    sumlist : (integer* Marks, integer Counter [out]) nondeterm.
    average_mark : (string StudentId) nondeterm.
    good_marks : (string StudentId) nondeterm.

clauses
    group_students(Educational_program, Group, Year) :-
        group(GroupID, Educational_program, Group, Year),
        find_group(GroupID, StudentID),
        student(StudentID, Student_name, _, _),
        write(Student_name, " учится в ", Educational_program, "-0", Group, "-", Year, "\n").

    group_leaders(Educational_program) :-
        group(GroupID, Educational_program, _, _),
        group_leader(GroupID, StudentID),
        student(StudentID, Student_name, _, _),
        write(Student_name, " староста направления ", Educational_program, "\n").

    studied_subjects(StudentId) :-
        student(StudentId, _, _, _),
        find_group(GroupId, StudentId),
        group(GroupId, Educational_program, _, _),
        subject(_, SubjectName, Educational_program, _),
        write("    ", SubjectName, "\n").

    sumlist([], 0).
    sumlist([H | T], Sum) :-
        sumlist(T, S1),
        Sum = H + S1.

    average_mark(StudentId) :-
        student(StudentId, Student_name, _, Marks),
        sumlist(Marks, A),
        write("    Средний балл студента ", Student_name, ": ", A / 10, "\n").

    good_marks(StudentId) :-
        student(StudentId, Student_name, _, Marks),
        sumlist(Marks, A),
        A / 10 > 4,
        write("    ", Student_name, ": ", A / 10, "\n").

    run() :-
        console::init(),
        reconsult("..\\database.txt", students),
        write("Список всех студентов:\n"),
        student(StudentID, Student_name, _, _),
        write("    ", Student_name, " (студ. билет: ", StudentID, ")\n"),
        fail.
    run() :-
        write("\n\n"),
        student(StudentID, Student_name, _, _),
        write("\nСписок курсов для студента:", Student_name, "\n"),
        studied_subjects(StudentID),
        fail.
    run() :-
        write("\n\n"),
        write("Средние оценки студентов:\n"),
        student(StudentID, _, _, _),
        average_mark(StudentID),
        fail.
    run() :-
        write("\n\n"),
        write("Список студентов со средним баллом больше 4:\n"),
        student(StudentID, _, _, _),
        good_marks(StudentID),
        fail.
    run() :-
        succeed.

end implement main

goal
    console::run(main::run).
