page 50110 "CSD Seminar Registration"
{
    // CSD1.00 - 2018-01-01 - D. E. Veloper
    //   Chapter 6 - Lab 3-1
    //     - Created new page

    Caption = 'Seminar Registration';
    PageType = Document;  //Document pages must also include subpages
    SourceTable = "CSD Seminar Reg. Header";
    UsageCategory = tasks;

    layout
    {
        area(content)
        {
            //there are 3 group controls that represent FastTabs
            group(General)
            {
                field("No."; Rec."No.")
                {
                    AssistEdit = true;
                    trigger OnAssistEdit();
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.UPDATE;
                    end;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Seminar No."; Rec."Seminar No.")
                {
                }
                field("Seminar Name"; Rec."Seminar Name")
                {
                }
                field("Instructor Code"; Rec."Instructor Resource No.")
                {
                }
                field("Instructor Name"; Rec."Instructor Name")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(Duration; Rec.Duration)
                {
                }
                field("Minimum Participants"; Rec."Minimum Participants")
                {
                }
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                }
            }

            part(SeminarRegistrationLines; "CSD Seminar Reg. Subpage")
            {
                Caption = 'Lines';
                SubPageLink = "Document No." = field("No.");
            }
            group("Seminar Room")
            {
                field("Room Code"; Rec."Room Resource No.")
                {
                }
                field("Room Name"; Rec."Room Name")
                {
                }
                field("Room Address"; Rec."Room Address")
                {
                }
                field("Room Address 2"; Rec."Room Address 2")
                {
                }
                field("Room Post Code"; Rec."Room Post Code")
                {
                }
                field("Room City"; Rec."Room City")
                {
                }
                field("Room Country/Reg. Code"; Rec."Room Country/Reg. Code")
                {
                }
                field("Room County"; Rec."Room County")
                {
                }
            }
            group(Invoicing)
            {
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                }
                field("Seminar Price"; Rec."Seminar Price")
                {
                }
            }
        }
        area(factboxes)
        {
            part("Seminar Details FactBox"; "CSD Seminar Details FactBox")
            {
                SubPageLink = "No." = field("Seminar No.");  //links a page part to the parent page
                //it enables the page part to show the information related to the record shown in the parent page
            }
            part("Customer Details FactBox"; "CSD Seminar Details FactBox")
            {
                Provider = SeminarRegistrationLines;  //Provider specifies the subpage that provides the source table for the subpage link
                SubPageLink = "No." = field("Bill-to Customer No.");
                //link the Customer No. field on the Customer Details FactBox page to the Bill-to Customer No. field on the Seminar Reg. Subpage page
            }
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
        area(navigation)
        {
            group("&Seminar Registration")
            {
                Caption = '&Seminar Registration';
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = Comment;
                    RunObject = Page 50106;
                    RunPageLink = "No." = Field("No.");
                    RunPageView = where("Table Name" = Const("Seminar Registration"));
                }
                action("&Charges")
                {
                    Caption = '&Charges';
                    Image = Costs;
                    RunObject = Page 50124;
                    RunPageLink = "Document No." = Field("No.");
                }

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

