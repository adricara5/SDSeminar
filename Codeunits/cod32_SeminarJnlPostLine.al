codeunit 50132 "CSD Seminar Jnl.-Post Line"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 7 - Lab 2-8
{
    TableNo = "CSD Seminar Journal Line";
    trigger OnRun()
    begin
        RunWithCheck(Rec);
    end;

    var
        SeminarJnlLine: Record "CSD Seminar Journal Line";
        //main record variable that must be available to all the functions in the Seminar Jnl.-Post Line codeunit
        SeminarLedgerEntry: Record "CSD Seminar Ledger Entry";
        SeminarRegister: Record "CSD Seminar Register";
        SeminarJnlCheckLine: Codeunit "CSD Seminar Jnl.-Check Line";
        NextEntryNo: Integer;

    procedure RunWithCheck(var SeminarJnlLine2: Record "CSD Seminar Journal Line");  //function with the parameter for receiving a Seminar Journal Line record by reference
    var

    begin
        with SeminarJnlLine2 do begin
            SeminarJnlLine := SeminarJnlLine2;  //by copying it from the by-reference parameter the whole codeunit has access to the same Seminar Journa Line record
            Code();
            SeminarJnlLine2 := SeminarJnlLine;
        end;
    end;

    local procedure Code()
    var

    begin
        with SeminarJnlLine do begin
            if EmptyLine then
                exit;

            SeminarJnlCheckLine.RunCheck(SeminarJnlLine);

            if NextEntryNo = 0 then begin
                SeminarLedgerEntry.LockTable(); //because when the NextEntryNo is 0 it means that the Code function was called for the 1st time during the posting process
                //this lock is done to maintain transaction integrity
                if SeminarLedgerEntry.FindLast() then
                    NextEntryNo := SeminarLedgerEntry."Entry No.";
                //if there are any other entries in the Seminar Ledge Entry table, then the NextEntryNo is set to the last Entry No. Used
                //if there are no other entities it remains 0 and the table remains on lock
                NextEntryNo += 1; //it is increased by 1 to make sure that it either starts at 1 for the very first ledger entry or at the next available value if there are other ledger entries already available in the table
            end;

            if "Document Date" <> 0D then
                "Document Date" := "Posting Date";

            if SeminarRegister."No." = 0 then //if the No. field of the Seminar Register is 0 then the register record has not yet been created
            begin
                SeminarRegister.LockTable; //the table is locked to maintain transaction integrity in case the register is not yet initialized
                //creating or updating the Seminar Register depending on whether the register record was previously created for this posting
                if (not SeminarRegister.FindLast()) or (SeminarRegister."To Entry No." <> 0) then begin
                    SeminarRegister.Init();
                    SeminarRegister."No." := SeminarRegister."No." + 1;
                    SeminarRegister."From Entry No." := NextEntryNo;  //at this point the NextEntryNo is the first entry for the transaction and it increases by 1 every time the function Code is called
                    SeminarRegister."To Entry No." := NextEntryNo;
                    SeminarRegister."Creation Date" := Today;
                    SeminarRegister."Source Code" := "Source Code";
                    SeminarRegister."Journal Batch Name" := "Journal Batch Name";
                    SeminarRegister."User ID" := USERID;  //gets the username of the user account that is logged in the current session
                    SeminarRegister.Insert();
                end;
            end;
            //the case when the SeminarRegister table record is already created and we need to update it
            SeminarRegister."To Entry No." := NextEntryNo;
            SeminarRegister.Modify();

            SeminarLedgerEntry.Init();
            SeminarLedgerEntry."Seminar No." := "Seminar No.";
            SeminarLedgerEntry."Posting Date" := "Posting Date";
            SeminarLedgerEntry."Document Date" := "Document Date";
            SeminarLedgerEntry."Entry Type" := "Entry Type";
            SeminarLedgerEntry."Document No." := "Document No.";
            SeminarLedgerEntry.Description := Description;
            SeminarLedgerEntry."Bill-to Customer No." := "Bill-to Customer No.";
            SeminarLedgerEntry."Charge Type" := "Charge Type";
            SeminarLedgerEntry.Type := Type;
            SeminarLedgerEntry.Quantity := Quantity;
            SeminarLedgerEntry."Unit Price" := "Unit Price";
            SeminarLedgerEntry."Total Price" := "Total Price";
            SeminarLedgerEntry."Participant Contact No." := "Participant Contact No.";
            SeminarLedgerEntry."Participant Name" := "Participant Name";
            SeminarLedgerEntry.Chargeable := Chargeable;
            SeminarLedgerEntry."Room Resource No." := "Room Resource No.";
            SeminarLedgerEntry."Instructor Resource No." := "Instructor Resource No.";
            SeminarLedgerEntry."Starting Date" := "Starting Date";
            SeminarLedgerEntry."Seminar Registration No." := "Seminar Registration No.";
            SeminarLedgerEntry."Res. Ledger Entry No." := "Res. Ledger Entry No.";
            SeminarLedgerEntry."Source Type" := "Source Type";
            SeminarLedgerEntry."Source No." := "Source No.";
            SeminarLedgerEntry."Journal Batch Name" := "Journal Batch Name";
            SeminarLedgerEntry."Source Code" := "Source Code";
            SeminarLedgerEntry."Reason Code" := "Reason Code";
            SeminarLedgerEntry."No. Series" := "Posting No. Series";
            SeminarLedgerEntry."Entry No." := NextEntryNo;
            SeminarLedgerEntry.Insert();
            NextEntryNo += 1;

        end;
    end;
    //when the Code function is finished, the by-reference parameter is set to the SeminarJnlLine global variable to pass its latest state to the caller
}