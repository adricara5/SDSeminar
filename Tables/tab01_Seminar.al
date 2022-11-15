table 50101 "CSD Seminar"
{
    Caption = 'CSD Seminar';
    LookupPageId = "CSD Seminar List";
    DrillDownPageId = "CSD Seminar List";

    fields
    {
        field(10; "No."; Code[20])
        {
            Caption = 'No.';
            trigger OnValidate();
            begin
                if "No." <> Rec."No." then begin  //<> checks if the value of the No. field is changed by the user
                    SeminarSetup.GET;
                    NoSeriesMgt.TestManual(SeminarSetup."Seminar Nos."); //validates that the nr. series that is used to assign numbers allows manual numbers
                    "No. Series" := '';  //sets the value of the No. Series field to blank
                end;
            end;
        }
        field(20; Name; Code[50])
        {
            Caption = 'Name';
            trigger OnValidate();
            //sets the SearchName field if it was equal to the uppercase of the previous value of the Name field
            begin
                if ("Search Name" = Uppercase(Rec.Name)) or ("Search Name" = '') then
                    "Search Name" := Name;
            end;
        }
        field(30; "Seminar Duration"; Decimal)
        {
            Caption = 'Seminar Duration';
            DecimalPlaces = 0 : 1;
        }
        field(40; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
        }
        field(50; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
        }
        field(60; "Search Name"; Code[50])
        {
            Caption = 'Search Name';
        }
        field(70; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(80; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(90; Comment; Boolean)
        {
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
            //CalcFormula = exist("CSD Seminar Comment Line" where("Table Name" = const("Seminar"),"No." = Field("No.")));
            //shows if related records exist in the Seminar Comment Line table

        }
        field(100; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            AutoFormatType = 1;  //this makes sure that the value is always formated as an amount
        }
        field(110; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
            trigger OnValidate()
            begin
                if (Rec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group") then begin
                    if GenProdPostingGroup.ValidateVatProdPostingGroup(GenProdPostingGroup, "Gen. Prod. Posting Group") then
                        Validate("VAT Prod. Posting Group", GenProdPostingGroup."Def. VAT Prod. Posting Group");
                    //sets the VAT Prod. Posting Group to the value of the Def. VAT Prod. Posting Group field from the Gen. Product Posting Group table
                end;
            end;
        }
        field(120; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(130; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Key1; "Search Name")
        {
            Clustered = false;
        }
    }

    var
        SeminarSetup: Record "CSD Seminar Setup";
        CommentLine: Record "CSD Seminar Comment Line";
        Seminar: Record "CSD Seminar";
        GenProdPostingGroup: Record "Gen. Product Posting Group";
        NoSeriesMgt: codeunit NoSeriesManagement;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SeminarSetup.GET;
            SeminarSetup.TestField("Seminar Nos.");
            NoSeriesMgt.InitSeries(SeminarSetup."Seminar Nos.", Rec."No. Series", 0D, "No.", "No. Series");
        end;
        // logic:
        // If there is no value in the No. field, assign the next value from the number series that is specified
        // in the Seminar Nos. number series in the Seminar Setup table
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today; //sets the Last Date Modified field to the system date when user modifies something
    end;

    trigger OnDelete()
    //deleting any comment lines for the seminar record being deleted
    begin
        CommentLine.Reset;
        CommentLine.SetRange("Table Name", CommentLine."Table Name"::Seminar);
        CommentLine.SetRange("No.", "No.");
        CommentLine.DeleteAll;
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := Today;
    end;

    procedure AssistEdit(): boolean;
    begin
        with Seminar do begin
            Seminar := Rec;
            SeminarSetup.get;
            SeminarSetup.TestField("Seminar Nos.");
            if NoSeriesMgt.SelectSeries(SeminarSetup."Seminar Nos.", Rec."No. Series", "No. Series") then begin
                NoSeriesMgt.SetSeries("No.");
                Rec := Seminar;
                exit(true);
            end;
        end;
    end;


}