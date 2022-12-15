codeunit 50100 "CSD Seminar-Post"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 7 - Lab 4-7
// This codeunit is the central document posting codeunit.
// It copies the document into the posted document and also analyzes the document and translates it into a series of journal line from different journals.
// For each journal line it calls the corresponding Journal-Check Line and Journal-Post Line codeunits.
// Cannot be called directly by the users
// Its asks users whether to post and then calls Post Batch
{
    // CSD1.00 - 2018-01-01 - D. E. Veloper
    //   Chapter 7 - Lab 5-2
    //     - Created new codeunit

    TableNo = 50110;

    trigger OnRun();
    begin
        ClearAll(); //clears all variables
        //it takes the Seminar Registration Header as a parameter and processes the information that is contained in it to produce a Posted Seminar Registration Header document
        SeminarRegHeader := Rec; //sets the SeminarRegHeader record variable to the current record

        SeminarRegHeader.TestField("Posting Date");
        SeminarRegHeader.TestField("Document Date");
        SeminarRegHeader.TestField("Seminar No.");
        SeminarRegHeader.TestField(Duration);
        SeminarRegHeader.TestField("Instructor Resource No.");
        SeminarRegHeader.TestField("Room Resource No.");
        SeminarRegHeader.TestField(Status, SeminarRegHeader.Status::Closed); //making sure that the Status field value is Closed

        //if there are no line for the current document throw an error
        SeminarRegLine.Reset();
        SeminarRegLine.SetRange("Document No.", SeminarRegHeader."No.");
        if SeminarRegLine.Isempty then
            Error(Text001);
        //opening a dialog box to show the posting progress
        Window.Open('#1#################################\\' + Text002);  //backslash is used to start a new line ---- # is used to insert variable values into the string
        Window.Update(1, StrSubstNo('%1 %2', Text003, SeminarRegHeader."No.")); //replaces the numbers with the provided variables or values

        if SeminarRegHeader."Posting No." = '' then BEGIN
            SeminarRegHeader.TestField("Posting No. Series");
            SeminarRegHeader."Posting No." := NoSeriesMgt.GetNextNo(SeminarRegHeader."Posting No. Series", SeminarRegHeader."Posting Date", true);  //assinging the Posting No. to the next number from the posting nr series
            SeminarRegHeader.modify;  //modifying the header
            Commit;
        end;
        SeminarRegLine.LockTable;

        SourceCodeSetup.GET;
        SourceCode := SourceCodeSetup."CSD Seminar";

        PstdSeminarRegHeader.Init();
        PstdSeminarRegHeader.TransferFields(SeminarRegHeader);
        PstdSeminarRegHeader."No." := SeminarRegHeader."Posting No.";
        PstdSeminarRegHeader."No. Series" := SeminarRegHeader."Posting No. Series";
        PstdSeminarRegHeader."Source Code" := SourceCode;
        PstdSeminarRegHeader."User Id" := USERID();
        PstdSeminarRegHeader.Insert();

        //updating the dialog box
        Window.Update(1, StrSubstNo(Text004, SeminarRegHeader."No.", PstdSeminarRegHeader."No."));

        //copying the comment lines and charges form the registration header to the posted version by calling the functions below
        CopyCommentLines(
            SeminarCommentLine."Table Name"::"Seminar Registration",
            SeminarCommentLine."Table Name"::"Posted Seminar Registration",
            SeminarRegHeader."No.",
            PstdSeminarRegHeader."No."
        );
        CopyCharges(SeminarRegHeader."No.", PstdSeminarRegHeader."No.");

        //preparing the loop for the registration lines of the current registration header
        LineCount := 0;
        SeminarRegLine.Reset();
        SeminarRegLine.SetRange("Document No.", SeminarRegHeader."No.");
        if SeminarRegLine.FindSet() then BEGIN
            repeat
                LineCount += 1;
                Window.Update(2, LineCount);
                SeminarRegLine.TestField("Bill-to Customer No.");
                SeminarRegLine.TestField("Participant Contact No.");
                //if the line should not be invoiced, reset the below fields to zero
                if not SeminarRegLine."To Invoice" then begin
                    SeminarRegLine."Seminar Price" := 0;
                    SeminarRegLine."Line Discount %" := 0;
                    SeminarRegLine."Line Discount Amount" := 0;
                    SeminarRegLine.Amount := 0;
                end;

                //posting seminar Entry
                PostSeminarJnlLine(2); //posting the participant line

                //inserting the posted seminar registration lines
                PstdSeminarRegLine.Init();
                PstdSeminarRegLine.TransferFields(SeminarRegLine);
                PstdSeminarRegLine."Document No." := PstdSeminarRegHeader."No.";
                PstdSeminarRegLine.Insert();
            until SeminarRegLine.NEXT = 0;

            //posting charges to seminar ledger
            PostCharges;
            //posting instructor to seminar ledgers
            PostSeminarJnlLine(0);
            //posting seminar room to seminar ledgers
            PostSeminarJnlLine(1);
            //Deleting the registration header,lines,comments and Charges
            SeminarRegHeader.Delete(true);  //fires the OnDelete trigger on the Seminar Registration header
        end;
        Rec := SeminarRegHeader;
    end;

    var
        SeminarRegHeader: Record "CSD Seminar Reg. Header";
        SeminarRegLine: Record "CSD Seminar Registration Line";
        PstdSeminarRegHeader: Record "CSD Posted Seminar Reg. Header";
        PstdSeminarRegLine: Record "CSD Posted Seminar Reg. Line";
        SeminarCommentLine: Record "CSD Seminar Comment Line";
        SeminarCommentLine2: Record "CSD Seminar Comment Line";
        SeminarCharge: Record "CSD Seminar Charge";
        PstdSeminarCharge: Record "CSD Posted Seminar Charge";
        Room: Record Resource;
        Instructor: Record Resource;
        Customer: Record Customer;
        ResLedgEntry: Record "Res. Ledger Entry";
        SeminarJnlLine: Record "CSD Seminar Journal Line";
        SourceCodeSetup: Record "Source Code Setup";
        ResJnlLine: Record "Res. Journal Line";
        SeminarJnlPostLine: Codeunit "CSD Seminar Jnl.-Post Line";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;
        Window: Dialog;
        SourceCode: Code[10];
        LineCount: Integer;
        Text001: Label 'There is no participant to post.';
        Text002: Label 'Posting lines              #2######\';
        Text003: Label 'Registration';
        Text004: Label 'Registration %1  -> Posted Reg. %2';
        Text005: Label 'The combination of dimensions used in %1 is blocked. %2';
        Text006: Label 'The combination of dimensions used in %1,  line no. %2 is blocked. %3';
        Text007: Label 'The dimensions used in %1 are invalid. %2';
        Text008: Label 'The dimensions used in %1, line no. %2 are invalid. %3';

    local procedure CopyCommentLines(FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20]);
    begin
        SeminarCommentLine.Reset();  //removes all the filters, changes fields select for looking back to all and changes the current key to primary key
        SeminarCommentLine.SetRange("Table Name", FromDocumentType);
        SeminarCommentLine.SetRange("No.", FromNumber);
        if SeminarCommentLine.FindSet() then
            repeat  //Finds a set of records on the table based on the current filter and key(FromDocumentType and FromNumber)
                    //for each record, it inserts a copy of the old record, with the Document Tyoe and No, set to ToDocumentTyoe and ToNumber
                SeminarCommentLine2 := SeminarCommentLine;
                SeminarCommentLine2."Table Name" := ToDocumentType;
                SeminarCommentLine2."No." := ToNumber;
                SeminarCommentLine2.Insert();
            until SeminarCommentLine.NEXT = 0;
    end;

    local procedure CopyCharges(FromNumber: Code[20]; ToNumber: Code[20]);
    begin
        SeminarCharge.reset();
        SeminarCharge.SetRange("Document No.", FromNumber);
        if SeminarCharge.FindSet() then  //finds all Seminar Charge records that correspond to the specified FromNumber
            repeat
                //For each record found, the function transfers the values to a new Posted Seminar Charge record, by using the ToNumber as the Seminar Registration No.
                PstdSeminarCharge.TransferFields(SeminarCharge); //copies all matching fields in one record into another record when the have the same field types and numbers
                PstdSeminarCharge."Document No." := ToNumber;
                PstdSeminarCharge.Insert();
            until SeminarCharge.NEXT = 0;

    end;

    local procedure PostResJnlLine(Resource: Record Resource): Integer;
    begin
        Resource.TestField("CSD Quantity Per Day");  //Makes sure that the Quantity Per Day field on the Resource record is not empty
        ResJnlLine.Init();
        ResJnlLine."Entry Type" := ResJnlLine."Entry Type"::Usage;
        ResJnlLine."Document No." := PstdSeminarRegHeader."No.";
        ResJnlLine."Resource No." := Resource."No.";
        //append the code that assigns the following field values from the Seminar Registration Header record
        ResJnlLine."Posting Date" := SeminarRegHeader."Posting Date";
        ResJnlLine."Reason Code" := SeminarRegHeader."Reason Code";
        ResJnlLine.Description := SeminarRegHeader."Seminar Name";
        ResJnlLine."Gen. Prod. Posting Group" := SeminarRegHeader."Gen. Prod. Posting Group";
        ResJnlLine."Posting No. Series" := SeminarRegHeader."Posting No. Series";
        ResJnlLine."Source Code" := SourceCode;
        ResJnlLine."Resource No." := Resource."No.";
        ResJnlLine."Unit of Measure Code" := Resource."Base Unit of Measure";
        ResJnlLine."Unit Cost" := Resource."Unit Cost";
        ResJnlLine."Qty. per Unit of Measure" := 1;
        //append the code that calculates the Quantity field as the product of the Duration field from the SeminarRegHeader record variable
        ResJnlLine.Quantity := SeminarRegHeader.Duration * Resource."CSD Quantity Per Day";  //Duration is taken directly because of the "with SeminarRegHeader" at the beggining
        //Calculating Total Cost field as the product of the Unit Cost and Quantity field values
        ResJnlLine."Total Cost" := Resource."Unit Cost" * ResJnlLine.Quantity;
        ResJnlLine."CSD Seminar No." := SeminarRegHeader."Seminar No.";
        ResJnlLine."CSD Seminar Registration No." := PstdSeminarRegHeader."No.";
        ResJnlPostLine.RunWithCheck(ResJnlLine);
        //finding the last Resource Ledger Entry and returning its Entry No. field value as the function return value
        ResLedgEntry.FindLast;
        exit(ResLedgEntry."Entry No.");
    end;

    local procedure PostSeminarJnlLine(ChargeType: Option Instructor,Room,Participant,Charge);
    begin
        SeminarJnlLine.Init();
        SeminarJnlLine."Seminar No." := SeminarRegHeader."Seminar No.";
        SeminarJnlLine."Posting Date" := SeminarRegHeader."Posting Date";
        SeminarJnlLine."Document Date" := SeminarRegHeader."Document Date";
        SeminarJnlLine."Document No." := PstdSeminarRegHeader."No.";
        SeminarJnlLine."Charge Type" := ChargeType;
        SeminarJnlLine."Instructor Resource No." := SeminarRegHeader."Instructor Resource No.";
        SeminarJnlLine."Starting Date" := SeminarRegHeader."Starting Date";
        SeminarJnlLine."Seminar Registration No." := PstdSeminarRegHeader."No.";
        SeminarJnlLine."Room Resource No." := SeminarRegHeader."Room Resource No.";
        SeminarJnlLine."Source Type" := SeminarJnlLine."Source Type"::Seminar;
        SeminarJnlLine."Source No." := SeminarRegHeader."Seminar No.";
        SeminarJnlLine."Source Code" := SourceCode;
        SeminarJnlLine."Reason Code" := SeminarRegHeader."Reason Code";
        SeminarJnlLine."Posting No. Series" := SeminarRegHeader."Posting No. Series";

        //append the code that compares the ChargeType parameter to all the possible values that it can have
        case ChargeType of
            ChargeType::Instructor:
                begin
                    Instructor.GET(SeminarRegHeader."Instructor Resource No.");
                    SeminarJnlLine.Description := Instructor.Name;
                    SeminarJnlLine.Type := SeminarJnlLine.Type::Resource;
                    SeminarJnlLine.Chargeable := false;
                    SeminarJnlLine.Quantity := SeminarRegHeader.Duration;
                    //post to resource ledger
                    SeminarJnlLine."Res. Ledger Entry No." := PostResJnlLine(Instructor);
                end;

            ChargeType::Room:
                begin
                    Room.GET(SeminarRegHeader."Room Resource No.");
                    SeminarJnlLine.Description := Room.Name;
                    SeminarJnlLine.Type := SeminarJnlLine.Type::Resource;
                    SeminarJnlLine.Chargeable := false;
                    SeminarJnlLine.Quantity := SeminarRegHeader.Duration;
                    SeminarJnlLine."Res. Ledger Entry No." := PostResJnlLine(Room);
                end;

            ChargeType::Participant:
                begin
                    SeminarJnlLine."Bill-to Customer No." := SeminarRegLine."Bill-to Customer No.";
                    SeminarJnlLine."Participant Contact No." := SeminarRegLine."Participant Contact No.";
                    SeminarJnlLine."Participant Name" := SeminarRegLine."Participant Name";
                    SeminarJnlLine.Description := SeminarRegLine."Participant Name";
                    SeminarJnlLine.Type := SeminarJnlLine.Type::Resource;
                    SeminarJnlLine.Chargeable := SeminarRegLine."To Invoice";
                    SeminarJnlLine."Unit Price" := SeminarRegLine.Amount;
                    SeminarJnlLine."Total Price" := SeminarRegLine.Amount;
                end;

            ChargeType::Charge:
                begin
                    SeminarJnlLine.Description := SeminarCharge.Description;
                    SeminarJnlLine."Bill-to Customer No." := SeminarCharge."Bill-to Customer No.";
                    SeminarJnlLine.Type := SeminarCharge.Type;
                    SeminarJnlLine.Quantity := SeminarCharge.Quantity;
                    SeminarJnlLine."Unit Price" := SeminarCharge."Unit Price";
                    SeminarJnlLine."Total Price" := SeminarCharge."Total Price";
                    SeminarJnlLine.Chargeable := SeminarCharge."To Invoice";
                end;

        end;

        //posting the SeminarJnlLine through the Seminar Jnl. Post Line codeunit
        SeminarJnlPostLine.RunWithCheck(SeminarJnlLine);
    end;

    local procedure PostCharges();
    begin
        //calling the PostSeminarJnlLine function for every SeminarCharge for the current SeminarRegHeader
        SeminarCharge.Reset();
        SeminarCharge.SetRange("Document No.", SeminarRegHeader."No.");
        if SeminarCharge.FindSet(false, false) then
            repeat
                PostSeminarJnlLine(3); //Charge
            until SeminarCharge.NEXT = 0;
    end;
}

