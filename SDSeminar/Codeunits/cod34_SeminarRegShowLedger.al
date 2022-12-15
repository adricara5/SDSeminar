codeunit 50134 "CSD Seminar Reg.-Show Ledger"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 7 - Lab 2-10
// This codeunit shows the ledger entries that result from a single journal posting
{
    TableNo = "CSD Seminar Register";
    trigger OnRun()
    begin
        SeminarLedgerEntry.SETRANGE("Entry No.", Rec."From Entry No.", Rec."To Entry No.");
        page.Run(Page::"CSD Seminar Ledger Entries", SeminarLedgerEntry);
    end;

    var
        SeminarLedgerEntry: Record "CSD Seminar Ledger Entry";
}