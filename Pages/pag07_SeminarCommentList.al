page 50107 "CSD Seminar Comment List"
{
    PageType = List;
    Caption = 'Seminar Comment List';
    SourceTable = "CSD Seminar Comment Line";
    Editable = false;

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