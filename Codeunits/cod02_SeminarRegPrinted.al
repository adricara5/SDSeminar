codeunit 50102 "CSD SeminarRegPrinted"
// Chapter 9 - Lab 1-2
// - Added Codeunit
{
    TableNo = "CSD Seminar Reg. Header";

    trigger OnRun()
    begin
        rec.Find;  //finds a record in the table that is based on the values stored in keys
        rec."No. Printed" += 1;
        rec.Modify;  //modifies the record
        Commit;  //ends the write transaction

    end;
}