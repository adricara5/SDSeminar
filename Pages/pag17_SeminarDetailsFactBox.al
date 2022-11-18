page 50117 "CSD Seminar Details FactBox"
{
    // CSD1.00 - 2018-01-01 - D. E. Veloper
    //   Chapter 6 - Lab 2
    //     - Created new page

    Caption = 'Seminar Details';
    PageType = CardPart;
    SourceTable = "CSD Seminar";

    layout
    {
        area(content)
        {
            field("No."; Rec."No.")
            {
            }
            field(Name; Rec.Name)
            {
            }
            field("Seminar Duration"; Rec."Seminar Duration")
            {
            }
            field("Minimum Participants"; Rec."Minimum Participants")
            {
            }
            field("Maximum Participants"; Rec."Maximum Participants")
            {
            }
            field("Seminar Price"; Rec."Seminar Price")
            {
            }
        }
    }

    actions
    {
    }
}

