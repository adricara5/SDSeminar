table 50101 "CSD Seminar"  //master record
//Master tables contain information about the primary focus subject of an application area
{
    Caption = 'CSD Seminar';
    LookupPageId = "CSD Seminar List";  //specifies which page provides the standard lookup behavior when users are looking up information from another table
    DrillDownPageId = "CSD Seminar List";
    DataClassification = AccountData;

    fields
    {
        field(10; "No."; Code[20])
        {
            Caption = 'No.';
            trigger OnValidate();  // this trigger checks whether the users can change the assigned number
            begin
                if "No." <> Rec."No." then begin  //<> checks if the value of the No. field is changed by the user
                    SeminarSetup.GET;
                    NoSeriesMgt.TestManual(SeminarSetup."Seminar Nos."); //validates that the nr. series that is used to assign numbers allows manual numbers
                    "No. Series" := '';  //sets the value of the No. Series field to blank
                end;
            end;
        }
        field(20; Name; Code[50])  //description field
        {
            Caption = 'Name';
            trigger OnValidate();
            //sets the SearchName field if it was equal to the uppercase of the previous value of the Name field
            begin
                if ("Search Name" = UpperCase(xRec.Name)) or ("Search Name" = '') then
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
        field(70; Blocked; Boolean)  //indicates whether users can use the master record in transactions(ex. a customer stops being your customer but the record is still saved(in blocked mode) for analysis purposes)
        {
            Caption = 'Blocked';
        }
        field(80; "Last Date Modified"; Date)  //lets users know when a specific master record is changed
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(90; Comment; Boolean)
        {
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;  //calculated field
            //setting the calculation formula for the flow field
            CalcFormula = exist("CSD Seminar Comment Line" where("Table Name" = const("Seminar"), "No." = Field("No.")));
            //shows if related records exist in the Seminar Comment Line table

        }
        field(100; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            AutoFormatType = 1;  //this makes sure that the value is always formated as an amount
        }
        // posting groups control the accounts that are used during different kinds of transactions
        field(110; "Gen. Prod. Posting Group"; Code[10])  //general product posting groups define the posting rules for the objects od the transaction
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
            trigger OnValidate()
            begin
                if (xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group") then begin
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
        field(130; "No. Series"; Code[10]) //this field keeps track of the number series from which the No. field was assigned
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
        key(SK; "Search Name")
        {
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
            NoSeriesMgt.InitSeries(SeminarSetup."Seminar Nos.", xRec."No. Series", 0D, "No.", "No. Series");
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

    // this function lets users select alternative number series in order to support the number series functionality
    procedure AssistEdit(): boolean;
    begin
        Seminar := Rec;
        SeminarSetup.get;
        SeminarSetup.TestField("Seminar Nos.");
        if NoSeriesMgt.SelectSeries(SeminarSetup."Seminar Nos.", xRec."No. Series", "No. Series") then begin
            NoSeriesMgt.SetSeries("No.");
            Rec := Seminar;
            exit(true);
        end;
    end;


}