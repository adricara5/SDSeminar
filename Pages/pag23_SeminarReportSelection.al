page 50123 "CSD Seminar Report Selection"
{
    // CSD1.00 - 2018-01-01 - D. E. Veloper
    //   Chapter 9 - Lab 1
    //     - Created new page

    Caption = 'Seminar Report Selection';
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "CSD Seminar Report Selections";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(ReportUsage2; ReportUsage2)
            {
                Caption = 'Usage';
                OptionCaption = 'Registration';

                trigger OnValidate();
                begin
                    SetUsageFilter;
                    ReportUsage2OnAfterValidate;
                end;
            }
            repeater(General)
            {
                field(Sequence; Rec.Sequence)
                {
                }
                field("Report ID"; Rec."Report ID")
                {
                    LookupPageID = Objects;
                }
                field("Report Name"; Rec."Report Name")
                {
                    DrillDown = false;
                    LookupPageID = Objects;
                }
            }
        }
        area(factboxes)
        {
            systempart("Links"; Links)
            {
                Visible = false;
            }
            systempart("Notes"; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        Rec.NewRecord;
    end;

    trigger OnOpenPage();
    begin
        SetUsageFilter;
    end;

    var
        ReportUsage2: Option Registration;

    local procedure SetUsageFilter();
    begin
        Rec.FILTERGROUP(2);
        CASE ReportUsage2 OF
            ReportUsage2::Registration:
                Rec.SETRANGE(Rec.Usage, Rec.Usage::Registration);
        end;
        Rec.FILTERGROUP(0);
    end;

    local procedure ReportUsage2OnAfterValidate();
    begin
        CurrPage.UPDATE;
    end;
}

