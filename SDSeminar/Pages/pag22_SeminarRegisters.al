page 50122 "CSD Seminar Registers"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 7 - Lab 2-11
// Register tables provide quick means to show the ledger entries that result from the selected transaction in the register
// It displays registers that are created when seminar registrations are posted
{
    Caption = 'Seminar Registers';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CSD Seminar Register";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {

                }
                field("Creation Date"; Rec."Creation Date")
                {

                }
                field("User ID"; Rec."User ID")
                {

                }
                field("Source Code"; Rec."Source Code")
                {

                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {

                }
            }
        }
        area(Factboxes)
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
            //running the Seminar Reg.-Show Ledger codeunit
            action("Seminar Ledgers")
            {
                Image = WarrantyLedger;
                RunObject = Codeunit "CSD Seminar Reg.-Show Ledger";  //sets the objects you want to run immediately when the action is activated
            }
        }
    }
}