page 50106 "CSD Seminar Comment Sheet"
{
    PageType = List;
    Caption = 'Seminar Comment Sheet';
    SourceTable = "CSD Seminar Comment Line";

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
}