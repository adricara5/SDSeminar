page 50139 "CSD Posted Seminar Charges"
{
    // CSD1.00 - 2018-01-01 - D. E. Veloper
    //   Chapter 7 - Lab 3
    //     - Created new page

    AutoSplitKey = true;
    Caption = 'Seminar Charges';
    Editable = false;
    PageType = List;
    SourceTable = "CSD Posted Seminar Charge";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; rec."No.")
                {
                }
                field(Description; rec.Description)
                {
                }
                field(Quantity; rec.Quantity)
                {
                }
                field("Unit of Measure Code"; rec."Unit of Measure Code")
                {
                }
                field("Bill-to Customer No."; rec."Bill-to Customer No.")
                {
                }
                field("Gen. Prod. Posting Group"; rec."Gen. Prod. Posting Group")
                {
                }
                field("Unit Price"; rec."Unit Price")
                {
                }
                field("Total Price"; rec."Total Price")
                {
                }
                field("To Invoice"; rec."To Invoice")
                {
                }
            }
        }
    }

    actions
    {
    }
}

