codeunit 50132 "CSD Seminar Jnl.-Post Line"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 7 - Lab 2-8
// This codeunit posts each line and creates the Seminar Ledger Entry records for the journal posting transaction
// Journal Post-Line codeunit reads information from a single journal line and then WRITES corresponding ledger entry or entries
// It only posts one journal line at a time and it does not examine previous or upcoming records
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
    //calls the Check Line codeunit and then calls the Code function
    begin
        SeminarJnlLine := SeminarJnlLine2;  //by copying it from the by-reference parameter the whole codeunit has access to the same Seminar Journal Line record
        Code();
        SeminarJnlLine2 := SeminarJnlLine;  //When the code function is finished, the by-reference parameter is set to the SeminarJnlLine global variable to pass its latest state to the caller
    end;

    local procedure Code()
    begin
        if SeminarJnlLine.EmptyLine then  //skips empty lines by exiting and this guarantees that empty lines are not inserted into the ledger
            exit;
        // Next it checks important table relations and it needs to read the database , that is why it is done here instead of in Check Line which cannot interact with the database
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

        if SeminarJnlLine."Document Date" <> 0D then
            SeminarJnlLine."Document Date" := SeminarJnlLine."Posting Date";

        if SeminarRegister."No." = 0 then begin  //if the No. field of the Seminar Register is 0 then the register record has not yet been created
            SeminarRegister.LockTable; //the table is locked to maintain transaction integrity in case the register is not yet initialized
            //Before writing to the ledger it writes to the register
            //creating or updating the Seminar Register depending on whether the register record was previously created for this posting
            if (not SeminarRegister.FindLast()) or (SeminarRegister."To Entry No." <> 0) then begin
                SeminarRegister.Init();
                SeminarRegister."No." := SeminarRegister."No." + 1;
                SeminarRegister."From Entry No." := NextEntryNo;  //at this point the NextEntryNo is the first entry for the transaction and it increases by 1 every time the function Code is called
                SeminarRegister."To Entry No." := NextEntryNo;  // the program changes the record by incrementing the To Entry No. field
                SeminarRegister."Creation Date" := Today;
                SeminarRegister."Source Code" := SeminarJnlLine."Source Code";
                SeminarRegister."Journal Batch Name" := SeminarJnlLine."Journal Batch Name";
                SeminarRegister."User ID" := USERID;  //gets the username of the user account that is logged in the current session
                SeminarRegister.Insert();  //inserts the ledger record
            end;
        end;
        //the case when the SeminarRegister table record is already created and we need to update it
        SeminarRegister."To Entry No." := NextEntryNo;
        SeminarRegister.Modify();
        SeminarLedgerEntry.Init();
        SeminarLedgerEntry."Seminar No." := SeminarJnlLine."Seminar No.";
        SeminarLedgerEntry."Posting Date" := SeminarJnlLine."Posting Date";
        SeminarLedgerEntry."Document Date" := SeminarJnlLine."Document Date";
        SeminarLedgerEntry."Entry Type" := SeminarJnlLine."Entry Type";
        SeminarLedgerEntry."Document No." := SeminarJnlLine."Document No.";
        SeminarLedgerEntry.Description := SeminarJnlLine.Description;
        SeminarLedgerEntry."Bill-to Customer No." := SeminarJnlLine."Bill-to Customer No.";
        SeminarLedgerEntry."Charge Type" := SeminarJnlLine."Charge Type";
        SeminarLedgerEntry.Type := SeminarJnlLine.Type;
        SeminarLedgerEntry.Quantity := SeminarJnlLine.Quantity;
        SeminarLedgerEntry."Unit Price" := SeminarJnlLine."Unit Price";
        SeminarLedgerEntry."Total Price" := SeminarJnlLine."Total Price";
        SeminarLedgerEntry."Participant Contact No." := SeminarJnlLine."Participant Contact No.";
        SeminarLedgerEntry."Participant Name" := SeminarJnlLine."Participant Name";
        SeminarLedgerEntry.Chargeable := SeminarJnlLine.Chargeable;
        SeminarLedgerEntry."Room Resource No." := SeminarJnlLine."Room Resource No.";
        SeminarLedgerEntry."Instructor Resource No." := SeminarJnlLine."Instructor Resource No.";
        SeminarLedgerEntry."Starting Date" := SeminarJnlLine."Starting Date";
        SeminarLedgerEntry."Seminar Registration No." := SeminarJnlLine."Seminar Registration No.";
        SeminarLedgerEntry."Res. Ledger Entry No." := SeminarJnlLine."Res. Ledger Entry No.";
        SeminarLedgerEntry."Source Type" := SeminarJnlLine."Source Type";
        SeminarLedgerEntry."Source No." := SeminarJnlLine."Source No.";
        SeminarLedgerEntry."Journal Batch Name" := SeminarJnlLine."Journal Batch Name";
        SeminarLedgerEntry."Source Code" := SeminarJnlLine."Source Code";
        SeminarLedgerEntry."Reason Code" := SeminarJnlLine."Reason Code";
        SeminarLedgerEntry."No. Series" := SeminarJnlLine."Posting No. Series";
        SeminarLedgerEntry."Entry No." := NextEntryNo;
        SeminarLedgerEntry.Insert();
        NextEntryNo += 1;
    end;
    //when the Code function is finished, the by-reference parameter is set to the SeminarJnlLine global variable to pass its latest state to the caller
}