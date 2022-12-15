table 50110 "CSD Seminar Reg. Header"
//Document tables are secondary transactional tables that enable entries for one or multiple app. areas at the same time
//They are secondary because the information is posted to ledgers through journal tables and not directly
//Primary means of entering a transaction
//A document header table holds the main transaction information that applies to all the lines in the document
//This table contains information about one SCHEDULED seminar a.k.a registration(Info about the seminar, the room and the instructor)
// Documents combine multiple transactions into a single transaction
{
    // CSD1.00 - 2022-11-17 - D. E. Veloper
    //   Chapter 6 - Lab 1-3 & Lab 1-4
    //     - Created new table
    Caption = 'Seminar Registration Header';
    DataClassification = AccountData;

    fields
    {
        field(1; "No."; Code[20])
        //contains the document number
        {
            Caption = 'No.';
            trigger OnValidate();
            begin
                //makes sure that changes to the No. field are permitted
                if "No." <> xRec."No." then begin
                    SeminarSetup.Get;
                    NoSeriesMgt.TestManual(SeminarSetup."Seminar Registration Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            trigger OnValidate();
            begin
                //makes sure that the Starting Date field can be changed only for Seminar Registrations in status Planning
                if "Starting Date" <> xRec."Starting Date" then
                    TestField(Status, Status::Planning);  //TestField is used when you need to throw an error if the value of a field does not match a specific value
            end;
        }
        field(3; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            TableRelation = "CSD Seminar";

            trigger OnValidate();
            begin
                //it makes sure that you cannot change the Seminar No. if there are participants in the seminar
                if "Seminar No." <> xRec."Seminar No." then begin
                    SeminarRegLine.Reset;
                    SeminarRegLine.SetRange("Document No.", "No.");
                    SeminarRegLine.SetRange(Registered, true);
                    if not SeminarRegLine.Isempty then
                        ERROR(
                          Text002,
                          FieldCaption("Seminar No."),
                          SeminarRegLine.TableCaption,
                          SeminarRegLine.FieldCaption(Registered),
                          true);
                    //this code makes it possible to retrieve the Seminar record
                    //and populates the default values from the selected Seminar record into the Seminar Registration Header record
                    Seminar.Get("Seminar No.");
                    Seminar.TestField(Blocked, false);
                    Seminar.TestField("Gen. Prod. Posting Group");
                    Seminar.TestField("VAT Prod. Posting Group");
                    "Seminar Name" := Seminar.Name;
                    Duration := Seminar."Seminar Duration";
                    "Seminar Price" := Seminar."Seminar Price";
                    "Gen. Prod. Posting Group" := Seminar."Gen. Prod. Posting Group";
                    "VAT Prod. Posting Group" := Seminar."VAT Prod. Posting Group";
                    "Minimum Participants" := Seminar."Minimum Participants";
                    "Maximum Participants" := Seminar."Maximum Participants";
                end;
            end;
        }
        field(4; "Seminar Name"; Text[50])
        {
            Caption = 'Seminar Name';
        }
        field(5; "Instructor Resource No."; Code[20])  //the field is related to Resource table therefore it includes it in the name + the primary key field name
        {
            Caption = 'Instructor Resource No.';
            TableRelation = Resource where(Type = const(Person));

            trigger OnValidate();
            begin
                CalcFields("Instructor Name");
            end;
        }
        field(6; "Instructor Name"; Text[100])
        {
            Caption = 'Instructor Name';
            CalcFormula = Lookup(Resource.Name where("No." = Field("Instructor Resource No."), Type = const(Person)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Planning,Registration,Closed,Canceled';
            OptionMembers = Planning,Registration,Closed,Canceled;
        }
        field(8; Duration; Decimal)
        {
            Caption = 'Duration';
            DecimalPlaces = 0 : 1;
        }
        field(9; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
        }
        field(10; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
        }
        field(11; "Room Resource No."; Code[20])
        {
            Caption = 'Room Resource No.';
            TableRelation = Resource where(Type = const(Machine));

            trigger OnValidate();
            begin
                //populating the Seminar Room fields
                if "Room Resource No." = '' then begin  //it cleans the fields if the user has specified an empty value
                    "Room Name" := '';
                    "Room Address" := '';
                    "Room Address 2" := '';
                    "Room Post Code" := '';
                    "Room City" := '';
                    "Room County" := '';
                    "Room Country/Reg. Code" := '';
                end
                else begin  //it populates the fields from the selected resource if the user has specified a non-empty value
                    SeminarRoom.GET("Room Resource No.");
                    "Room Name" := SeminarRoom.Name;
                    "Room Address" := SeminarRoom.Address;
                    "Room Address 2" := SeminarRoom."Address 2";
                    "Room Post Code" := SeminarRoom."Post Code";
                    "Room City" := SeminarRoom.City;
                    "Room County" := SeminarRoom.County;
                    "Room Country/Reg. Code" := SeminarRoom."Country/Region Code";

                    //it checks whether the seminar can register more participants if the room has more capacity than the maximum that is defined by seminar master record
                    if (CurrFieldNo <> 0) then begin
                        if (SeminarRoom."CSD Maximum Participants" <> 0) and
                           (SeminarRoom."CSD Maximum Participants" < "Maximum Participants")
                        then begin
                            //Creates a Yes/No dialog box to ask the user if the Seminar room can recieve more participants
                            if Confirm(Text004,
                                 true,
                                 "Maximum Participants",
                                 SeminarRoom."CSD Maximum Participants",
                                 FieldCaption("Maximum Participants"),
                                 "Maximum Participants",
                                 SeminarRoom."CSD Maximum Participants")
                            then
                                "Maximum Participants" := SeminarRoom."CSD Maximum Participants";
                        end;
                    end;
                end;
            end;
        }
        field(12; "Room Name"; Text[30])
        {
            Caption = 'Room Name';
        }
        field(13; "Room Address"; Text[30])
        {
            Caption = 'Room Address';
        }
        field(14; "Room Address 2"; Text[30])
        {
            Caption = 'Room Address 2';
        }
        field(15; "Room Post Code"; Code[20])
        {
            Caption = 'Room Post Code';
            TableRelation = "Post Code".Code;
            ValidateTableRelation = false;

            trigger OnValidate();
            begin
                //when an address field is used , it is required to use the Post Code, County and Country/Region Code Fields
                //this makes it possible to use the standard functions of the Post Code table.
                PostCode.ValidatePostCode("Room City", "Room Post Code", "Room County", "Room Country/Reg. Code", (CurrFieldNo <> 0) and GuiAllowed);
                //this populates all other fields based on the choice in either Post Code or City fields
            end;
        }
        field(16; "Room City"; Text[30])
        {
            Caption = 'Room City';
            trigger OnValidate();
            begin
                PostCode.ValidateCity("Room City", "Room Post Code", "Room County", "Room Country/Reg. Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(17; "Room Country/Reg. Code"; Code[10])
        {
            Caption = 'Room Country/Reg. Code';
            TableRelation = "Country/Region";
        }
        field(18; "Room County"; Text[30])
        {
            Caption = 'Room County';
        }
        field(19; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            AutoFormatType = 1;

            trigger OnValidate();
            begin
                if ("Seminar Price" <> xRec."Seminar Price") and
                   (Status <> Status::Canceled)
                then begin
                    SeminarRegLine.Reset;
                    SeminarRegLine.SetRange("Document No.", "No.");
                    SeminarRegLine.SetRange(Registered, false);
                    //checks for registered participants then updates the seminar price for each participant when the user confirms it
                    if SeminarRegLine.FindSet(false, false) then
                        if Confirm(Text005, false,
                             FieldCaption("Seminar Price"),
                             SeminarRegLine.TableCaption)
                        then begin
                            repeat
                                SeminarRegLine.VALIDATE("Seminar Price", "Seminar Price");
                                SeminarRegLine.modify;
                            until SeminarRegLine.NEXT = 0;
                            modify;
                        end;
                end;
            end;
        }
        field(20; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group".Code;
        }
        field(21; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group".Code;
        }
        field(22; Comment; Boolean)
        {
            Caption = 'Comment';
            CalcFormula = Exist("CSD Seminar Comment Line" where("Table Name" = const("Seminar Registration"), "No." = Field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(24; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(25; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code".Code;
        }
        field(26; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series".Code;
        }
        field(27; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series".Code;

            trigger OnLookup();  //runs when a lookup page is displayed -- in this case Posted Seminar Reg. Header
            begin
                SeminarRegHeader := Rec;
                SeminarSetup.GET;
                SeminarSetup.TestField("Seminar Registration Nos.");
                SeminarSetup.TestField("Posted Seminar Reg. Nos.");
                if NoSeriesMgt.LookupSeries(SeminarSetup."Posted Seminar Reg. Nos.", "Posting No. Series")
                then begin
                    VALIDATE("Posting No. Series");
                end;
                Rec := SeminarRegHeader;
            end;

            trigger OnValidate();
            begin
                if "Posting No. Series" <> '' then begin
                    SeminarSetup.GET;
                    SeminarSetup.TestField("Seminar Registration Nos.");
                    SeminarSetup.TestField("Posted Seminar Reg. Nos.");
                    NoSeriesMgt.TestSeries(SeminarSetup."Posted Seminar Reg. Nos.", "Posting No. Series");  //it uses the NoSeriesManagement codeunit to test whether the user has entered a valid nr. series
                end;
                TestField("Posting No.", '');  //makes sure the user can change the number series only if the Posting No. Series fields has not yet been assigned
            end;
        }
        field(28; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
        }

        // Chapter 9 - Lab 1-1
        // - Added new field "No. Printed" used for SeminarRegParticipantList report
        field(40; "No. Printed"; Integer)
        {
            Caption = 'No. Printed';
            Editable = false;
        }

    }

    keys
    {
        key(PK; "No.")
        {
        }
        key(Key2; "Room Resource No.")
        {
            SumIndexFields = Duration;
        }
    }

    var
        PostCode: Record "Post Code";
        Seminar: Record "CSD Seminar";
        SeminarCommentLine: Record "CSD Seminar Comment Line";
        SeminarCharge: Record "CSD Seminar Charge";
        SeminarRegHeader: Record "CSD Seminar Reg. Header";
        SeminarRegLine: Record "CSD Seminar Registration Line";
        SeminarRoom: Record Resource;
        SeminarSetup: Record "CSD Seminar Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text001: Label 'You cannot delete the Seminar Registration, because there is at least one %1 where %2=%3.';
        Text002: Label 'You cannot change the %1, because there is at least one %2 with %3=%4.';
        Text004: Label 'This Seminar is for %1 participants. \The selected Room has a maximum of %2 participants \Do you want to change %3 for the Seminar from %4 to %5?';
        Text005: Label 'Should the new %1 be copied to all %2 that are not yet invoiced?';
        Text006: Label 'You cannot delete the Seminar Registration, because there is at least one %1.';

    trigger OnDelete();  //makes sure that only the seminars in status cancelled can be deleted if the Delete function is called from the Seminar Registration page
    begin
        //verifying that the value of the Status field is Canceled because only Seminars of status Canceled should be deleted
        if (CurrFieldNo > 0) then  //CurrFieldNo is a system variable that automatically is set to the field number of the cursor position in the page
                                   //it is set to 0 when the delete funstion is called from the code
            TestField(Status, Status::Canceled);
        SeminarRegLine.RESET;
        SeminarRegLine.SETRANGE("Document No.", "No.");
        SeminarRegLine.SETRANGE(Registered, true);  //makes sure no lines in status Registered exist
        // if such lines exist the code throws an error
        if SeminarRegLine.FIND('-') then
            ERROR(
              Text001,
              SeminarRegLine.TableCaption,
              SeminarRegLine.FieldCaption(Registered),
              true);
        SeminarRegLine.SETRANGE(Registered);
        SeminarRegLine.deleteALL(true);

        //deleting all the Seminar Charge records for the current Seminar Registratio Header record
        SeminarCharge.RESET;
        SeminarCharge.SETRANGE("Document No.", "No.");
        if not SeminarCharge.ISEMPTY then
            ERROR(Text006, SeminarCharge.TableCaption);

        //deleting all the Seminar Comment Line records for the current Seminar Registration Record
        SeminarCommentLine.RESET;
        SeminarCommentLine.SETRANGE("Table Name", SeminarCommentLine."Table Name"::"Seminar Registration");
        SeminarCommentLine.SETRANGE("No.", "No.");
        SeminarCommentLine.deleteALL;
    end;

    trigger OnInsert();  //contains the code that initializes the nr. series that is based on the Seminar Setup table
    begin
        if "No." = '' then begin
            SeminarSetup.GET;
            SeminarSetup.TestField("Seminar Registration Nos.");
            NoSeriesMgt.InitSeries(SeminarSetup."Seminar Registration Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
        InitRecord();  //initializes the fields to certain defaults

        // >> Lab 8 1-1
        if GetFilter("Seminar No.") <> '' then  //checks if there is a filter on the Seminar No. field
            if GetRangeMin("Seminar No.") = GetRangeMax("Seminar No.")  //then chechks if the filter applies to a single Seminar No.
            then
                Validate("Seminar No.", GetRangeMin("Seminar No."));  //validates Seminar No. field to the value in the filter on the Seminar No. field
        //this makes sure that a new document is assigned automatically to the master record that the master page passed as the record link to the document page
        // << Lab 8 1-1
    end;

    local procedure InitRecord();
    begin
        if "Posting Date" = 0D then
            //initializes the fields to certain defaults
            "Posting Date" := WORKDATE;
        "Document Date" := WORKDATE;
        SeminarSetup.GET;
        NoSeriesMgt.SetDefaultSeries("Posting No. Series", SeminarSetup."Posted Seminar Reg. Nos.");
    end;

    procedure AssistEdit(OldSeminarRegHeader: Record "CSD Seminar Reg. Header"): Boolean;
    begin
        SeminarRegHeader := Rec;
        SeminarSetup.GET;
        SeminarSetup.TestField("Seminar Registration Nos.");
        if NoSeriesMgt.SelectSeries(SeminarSetup."Seminar Registration Nos.", OldSeminarRegHeader."No. Series", "No. Series") then begin
            SeminarSetup.GET;
            SeminarSetup.TestField("Seminar Registration Nos.");
            NoSeriesMgt.SetSeries("No.");
            Rec := SeminarRegHeader;
            exit(true);
        end;
    end;
}

