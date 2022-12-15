tableextension 50101 "CSD SourceCodeSetupExt" extends "Source Code Setup"
// CSD1.00 - 2012-06-15 - D. E. Veloper
// Chapter 7 - Lab 1-7
// - Added new fields:
// - Seminar
// It is the core feature for auditing transactions
// It adds a field to support the audit trail source code for the seminar reg. transaction history
{
    fields
    {
        field(50100; "CSD Seminar"; Code[10])  //idntifies the new transaction type introduced
        {
            Caption = 'Seminar';
            TableRelation = "Source Code";
        }
    }
}