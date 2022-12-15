page 50140 "CSD Seminar Manager Activites"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 10 - Lab 1 - 2
// - Created new page
// RoleCenter part page that contains stacks of documents(Cues)
// Cues show the number of documents of a specific type that exist in the app and also let users quickly access the list of documents with an appropriate filter applied
{
    Caption = 'Seminar Manager Activites';
    PageType = CardPart;
    Editable = false;
    SourceTable = "CSD Seminar Cue";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {   //cuegroup type usergroups are used to show cues
            cuegroup(Registrations)
            {
                Caption = 'Registrations';
                field(Planned; Rec.Planned)
                {
                }
                field(Registered; Rec.Registered)
                {
                }
                actions
                {
                    action(New)
                    {
                        Caption = 'New';
                        //creating a new Registration Header
                        RunObject = page "CSD Seminar Registration";
                        RunPageMode = Create;
                    }
                }
            }
            cuegroup("For Posting")
            {
                Caption = 'For Posting';
                field(Closed; Rec.Closed)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        //inserting a new record if there is no record in the Seminar Cue table
        if not Rec.get then begin
            Rec.init;
            Rec.insert;
        end;
    end;
}