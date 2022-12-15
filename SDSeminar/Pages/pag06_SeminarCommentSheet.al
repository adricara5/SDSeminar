page 50106 "CSD Seminar Comment Sheet"
// enables users to enter and change data in the SeminarCommentLine table
{
    PageType = List;
    Caption = 'Seminar Comment Sheet';
    SourceTable = "CSD Seminar Comment Line";
    AutoSplitKey = true;
    ApplicationArea = All;
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Date; Rec.Date)
                {
                    Caption = 'Date';

                }
                field(Code; Rec.Code)
                {
                    Caption = 'Comment';
                    Visible = false;
                }
                field(Comment; Rec.Comment)
                {
                    Caption = 'Comment';
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetupNewLine();
    end;
}