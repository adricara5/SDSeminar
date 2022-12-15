page 50107 "CSD Seminar Comment List"
// Chapter 7 - Lab 4-8
// Added Action Post
// This page is used as Lookup And DrillDown page for the Semianr Comment Line table
{
    ApplicationArea = All;
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
    actions
    {
        area(Navigation)
        {
            group("&Seminar Comment List")
            {
                Caption = 'Seminar Comment List';
                action("&Post")
                {
                    Caption = '&Post';
                    Image = PostDocument;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    ShortcutKey = F9;
                    RunObject = codeunit "CSD Seminar-Post (Yes/No)";

                }
            }
        }
    }
}