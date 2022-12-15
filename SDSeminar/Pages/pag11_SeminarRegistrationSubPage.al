page 50111 "CSD Seminar Reg. Subpage"
{
    // CSD1.00 - 2018-01-01 - D. E. Veloper
    //   Chapter 6 - Lab 3
    //     - Created new page
    // ListPart subpage used to display multiple line records at a time for the document line table
    // the key fields from the lines table are not displayed but instead they link to the main table through the subpagelink property that actually populates the linked key fields with the values from the main table
    ApplicationArea = All;
    Caption = 'Lines';
    DelayedInsert = true;
    PageType = ListPart;  //document subpages must be of ListPart type
    SourceTable = "CSD Seminar Registration Line";
    AutoSplitKey = true;  //All document subpages must set this property to enable BC to automatically assign the values in the Line No. field when user creates new rows in the subpage

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                //none of the primary key fields are included on this page
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                }
                field("Participant Contact No."; Rec."Participant Contact No.")
                {
                }
                field("Participant Name"; Rec."Participant Name")
                {
                }
                field(Participated; Rec.Participated)
                {
                }
                field("Registration Date"; Rec."Registration Date")
                {
                }
                field("Confirmation Date"; Rec."Confirmation Date")
                {
                }
                field("To Invoice"; Rec."To Invoice")
                {
                }
                field(Registered; Rec.Registered)
                {
                }
                field("Seminar Price"; Rec."Seminar Price")
                {
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
            }
        }
    }
}

