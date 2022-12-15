page 50141 "CSD My Seminars"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 10 - Lab 1 - 4
// - Created new page
// A ListPart of the RoleCenter that lets users to manage their list of favourite seminars
// Every user can decide which records, to include in the list. The list is different for each user, and users manage their own lists independently.
{
    PageType = ListPart;
    SourceTable = "CSD My Seminar";
    Caption = 'My Seminars';
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Seminar No."; Rec."Seminar No.")
                {
                }
                field(Name; Seminar.Name)
                {
                }
                field(Duration; Seminar."Seminar Duration")
                {
                }
                field(Price; Seminar."Seminar Price")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Open)
            {
                trigger OnAction();
                begin
                    OpenSeminarCard;
                end;
            }
        }
    }

    var
        Seminar: record "CSD Seminar";

    trigger OnOpenPage();
    begin
        Rec.SetRange(Rec."User ID", UserId); //showing only records from the actual user
    end;

    trigger OnAfterGetRecord()
    begin
        if Seminar.get(Rec."Seminar No.") then; //geting the seminar record
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(Seminar);
    end;

    local procedure OpenSeminarCard()
    begin
        if Seminar."No." <> '' then
            Page.Run(Page::"CSD Seminar Card", Seminar);
    end;
}