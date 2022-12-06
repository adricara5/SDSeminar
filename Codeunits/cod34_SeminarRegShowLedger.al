codeunit 50134 "CSD Seminar Reg.-Show Ledger"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 7 - Lab 2-10
{
    TableNo = "CSD Seminar Ledger Entry";
    trigger OnRun()
    begin
        SeminarLedgerEntry.SETRANGE("Entry No.", SeminarRegister."From Entry No.", SeminarRegister."To Entry No.");
        page.Run(Page::"CSD Seminar Ledger Entries", SeminarLedgerEntry);
    end;

    var
        SeminarLedgerEntry: Record "CSD Seminar Ledger Entry";
        SeminarRegister: Record "CSD Seminar Register";  //we do i need to add this
}