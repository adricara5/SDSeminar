page 50100 "CSD Seminar Setup"
// it allows changing the information but does not allow inserting or deleting records
{
    PageType = Card;
    SourceTable = "CSD Seminar Setup";
    Caption = 'Seminar Setup';
    InsertAllowed = false;  //makes sure there can only be 1 record in the table
    DeleteAllowed = false;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(Numbering)
            {
                field("Seminar Nos."; rec."Seminar Nos.")
                {
                }
                field("Seminar Registration Nos."; rec."Seminar Registration Nos.")
                {
                }
                field("Posted Seminar Reg. Nos."; rec."Posted Seminar Reg. Nos.")
                {
                }
            }
        }
    }

    trigger OnOpenPage(); //trigger to insert a new record, if there is not a record in the Seminar Setup table
    begin
        if not rec.Get() then begin
            rec.Init();
            rec.Insert();
        end;
    end;
}