page 50102 "CSD Seminar List"
//list page is used to view multiple records in the master table, but unlike the card page it cannot be used to edit the master table
//list pages are set as the LookupPageID and DrillDownPageId of the master table
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CSD Seminar";
    Caption = 'Seminar List';
    Editable = false;  //no change can be made directly from the list page
    CardPageId = 50101;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Seminar Duration"; Rec."Seminar Duration")
                {
                    ApplicationArea = All;
                }
                field("Seminar Price"; Rec."Seminar Price")
                {
                    ApplicationArea = All;
                }
                field("Minimum participants"; Rec."Minimum participants")
                {
                    ApplicationArea = All;
                }
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)  //enable users to see relevant information about data that is shown in the page
        {
            systempart("Links"; Links)
            {

            }

            systempart("Notes"; Notes)
            {

            }
        }
    }
    actions
    {
        area(Navigation)
        {
            group("&Seminar")
            {
                // >> Lab 8 1-3
                action("Ledger Entries")  //action to run the Seminar Ledger Entries page for the current Seminar record
                {
                    Caption = 'Ledger Entries';
                    RunObject = page "CSD Seminar Ledger Entries";
                    RunPageLink = "Seminar No." = field("No.");
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortcutKey = "Ctrl+F7";
                    Image = WarrantyLedger;
                }
                // << Lab 8 1-3
                action("Co&mments")
                {
                    RunObject = page "CSD Seminar Comment Sheet";
                    RunPageLink = "Table Name" = const(Seminar), "No." = field("No.");
                    Image = Comment;
                }

                // >> Lab 8 1-2
                action("&Registrations")
                {
                    Caption = '&Registrations';
                    RunObject = page "CSD Seminar Registration List";
                    RunPageLink = "Seminar No." = field("No.");
                    Image = Timesheet;
                    Promoted = true;
                    PromotedCategory = Process;
                }
                // << Lab 8 1-2
            }
        }
        // >> Lab 8 1-2
        area(Processing)
        {
            action("Seminar Registration")  //action to create a new Seminar Registration
            {
                RunObject = page "CSD Seminar Registration";
                RunPageLink = "Seminar No." = field("No.");
                RunPageMode = Create;
                Image = NewTimesheet;
                Promoted = true;
                PromotedCategory = New;
            }
        }
        // << Lab 8 1-2
    }
}