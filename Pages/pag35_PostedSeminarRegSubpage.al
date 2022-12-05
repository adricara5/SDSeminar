page 50135 "CSD Posted Seminar Reg.Subpage"
{
    // CSD1.00 - 2018-01-01 - D. E. Veloper
    //   Chapter 7 - Lab 3
    //     - Created new page

    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "CSD Posted Seminar Reg. Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Bill-to Customer No."; rec."Bill-to Customer No.")
                {
                }
                field("Participant Contact No."; rec."Participant Contact No.")
                {
                }
                field("Participant Name"; rec."Participant Name")
                {
                }
                field(Participated; rec.Participated)
                {
                }
                field("Registration Date"; rec."Registration Date")
                {
                }
                field("Confirmation Date"; rec."Confirmation Date")
                {
                }
                field("To Invoice"; rec."To Invoice")
                {
                }
                field(Registered; rec.Registered)
                {
                }
                field("Seminar Price"; rec."Seminar Price")
                {
                }
                field("Line Discount %"; rec."Line Discount %")
                {
                }
                field("Line Discount Amount"; rec."Line Discount Amount")
                {
                }
                field(Amount; rec.Amount)
                {
                }
            }
        }
    }
}

