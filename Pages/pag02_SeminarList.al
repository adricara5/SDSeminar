page 50102 "CSD Seminar List"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CSD Seminar";
    Caption = 'Seminar List';
    Editable = false;
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
        area(FactBoxes)
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
                action("Co&mments")
                {
                    //RunObject = page "CSD Seminar Comment Sheet";
                    //RunPageLink = "Table Name" = const(Seminar), "No." = field("No.");
                    Image = Comment;
                }
            }
        }
    }
}