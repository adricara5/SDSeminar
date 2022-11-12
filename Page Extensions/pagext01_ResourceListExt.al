pageextension 50101 "CSD ResourceListExt" extends "Resource List"
// CSD1.00 - 2022-11-12 - D. E. Veloper
// 1.3 Add Field to the Resource List Page
// Changed property on the Type field
// Added new fields:
// - Internal/External
// - Maximum Participants
// Added code to OnOpenPage trigger
{
    layout
    {
        modify(Type)
        {
            Visible = Showtype;
        }

        addafter("Type")
        {
            field("CSD Resource Type"; Rec."CSD Resource Type")
            {

            }
            field("CSD Maximum Participants"; Rec."CSD Maximum Participants")
            {
                Visible = ShowMaxField;
            }
        }
    }

    trigger OnOpenPage();
    begin
        Showtype := (Rec.GetFilter(Type) = '');
        ShowMaxField := (Rec.GetFilter(Type) = format(Rec.Type::machine));

    end;

    var
        [InDataSet]
        ShowMaxField: Boolean;
        [InDataSet]
        Showtype: Boolean;
}