pageextension 50101 "CSD ResourceListExt" extends "Resource List"
// CSD1.00 - 2022-11-12 - D. E. Veloper
// 1.3 Add Field to the Resource List Page of the Resource Master table that is extended in this solution
// Changed property on the Type field
// Added new fields:
// - Internal/External
// - Maximum Participants
// Added code to OnOpenPage trigger
// This page is customized so the users can only see the records relevant to either instructors or rooms
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
        Showtype := (Rec.GetFilter(Type) = '');  //hides the type field if a filter has been set on the Type field
        ShowMaxField := (Rec.GetFilter(Type) = format(Rec.Type::machine));  //hides the max. participants field if a filter has been set on the Type field to only show persons(instructors)

    end;

    var
        [InDataSet]
        ShowMaxField: Boolean;
        [InDataSet]
        Showtype: Boolean;
}