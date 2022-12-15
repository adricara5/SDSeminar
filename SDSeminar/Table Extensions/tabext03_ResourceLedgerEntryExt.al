tableextension 50103 "CSD ResourceLedgerEntryExt" extends "Res. Ledger Entry"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 7 - Lab 4-1
// Adding fields to link the resource ledger entries to the seminars and posted seminar reg. documents
{
    fields
    {
        field(50100; "CSD Seminar No."; Code[20])  //lets you keep track of which instructor or room is connected with a seminar
        {
            Caption = 'Seminar No.';
            TableRelation = "CSD Seminar";
        }
        field(50101; "CSD Seminar Registration No."; Code[20])  //Links the posted seminar registration so that users can easily move to all instructor or room resource ledger entries from a posted seminar registration
        {
            Caption = 'Seminar Registration No.';
            TableRelation = "CSD Seminar Reg. Header";
        }
    }
}