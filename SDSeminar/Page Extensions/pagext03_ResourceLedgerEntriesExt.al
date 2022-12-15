pageextension 50103 "CSD ResourceLedgerEntriesExt" extends "Resource Ledger Entries"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 7 - Lab 4-3
// You typically want to show the new fields in the Ledger Entries page
{
    layout
    {
        addlast(Content)
        {
            field("Seminar No."; rec."CSD Seminar No.")
            {
            }
            field("Seminar Registration No."; rec."CSD Seminar Registration No.")
            {

            }
        }
    }
}