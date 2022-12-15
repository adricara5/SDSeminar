pageextension 50102 "CSD SourceCodeSetupExt" extends "Source Code Setup"
// CSD1.00 - 2012-06-15 - D. E. Veloper
// Chapter 7 - Lab 1-8
{
    layout
    {
        addafter("Cost Accounting")
        {
            group("CSD SeminarGroup")
            {
                Caption = 'Seminar';
                field(Seminar; rec."CSD Seminar")
                {
                    //The Seminar group and the seminar field needs to be given different identifiers. That is to ensure that we can reference them with the addbefore or addafter commands. The caption can be the same though.
                }
            }
        }
    }
}