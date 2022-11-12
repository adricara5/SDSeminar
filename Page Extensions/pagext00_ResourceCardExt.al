pageextension 50100 "CSD ResourceCardExt" extends "Resource Card"
// CSD1.00 - 2022-11-12 - D. E. Veloper
// 1.2 Add fields to the Resource Card Page
// Added new fields:
// - Internal/External
// - Maximum Participants
// Added new FastTab
// Added code to OnOpenPage trigger
{
    layout
    {
        addlast(General) //adds the fields after the last field in the General FastTab
        {
            field("CSD Resource Type"; Rec."CSD Resource Type")
            {

            }

            field("CSD Quantity Per Day"; Rec."CSD Quantity Per Day")
            {

            }

        }
        addafter("Personal Data")
        {
            group("CSD Room") //creating a new FastTab called Room
            {
                Caption = 'Room';
                Visible = ShowMaxField;
                field("CSD Maximum Participants"; Rec."CSD Maximum Participants")
                {

                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        ShowMaxField := (Rec.Type = Rec.Type::Machine); //hiding the Type field if a filter has been set on the Typw field
        CurrPage.Update(false);

    end;

    var
        [InDataSet] //making the variables available to the page as a part of the dataset
        ShowMaxField: Boolean;


}