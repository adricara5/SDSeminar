codeunit 50139 "CSD EventSubscriptions"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 7 - Lab 4-4
{
    [EventSubscriber(ObjectType::Codeunit, 212, 'OnBeforeResLedgEntryInsert', '', true, true)]
    local procedure PostResJnlLineOnBeforeResLedgEntryInsert(var ResLedgerEntry: Record "Res. Ledger Entry"; ResJournalLine: Record "Res. Journal Line");
    var
    //C212: Codeunit "Res. Jnl.-Post Line";  //to copy all the parameters from the OnBeforeResLedgEntryInsert procedure on the Res. Jnl.-Post Line codeunit
    begin
        ResLedgerEntry."CSD Seminar No." := ResJournalLine."CSD Seminar No.";
        ResLedgerEntry."CSD Seminar Registration No." := ResJournalLine."CSD Seminar Registration No.";
    end;

    // >> Lab 8 2-2 Creating Integration Subscriptions to the Navigate page so it can search for PostedSeminarRegHeader and SeminarLedgerEntry records

    [EventSubscriber(ObjectType::Page, 344, 'OnAfterNavigateFindRecords', '', true, true)]  //to find records
    local procedure ExtendNavigateOnAterNavigateFindRecords(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text);
    var
        SeminarLedgerEntry: record "CSD Seminar Ledger Entry";
        PostedSeminarRegHeader: record "CSD Posted Seminar Reg. Header";
        DocNoOfRecords: Integer;
        NextEntryNo: Integer;
    begin
        //enabling Navigate to Find records from Posted Seminar Reg. Header table
        if PostedSeminarRegHeader.ReadPermission then begin  //checks whether the user has permision to read from the table that is being searched
            PostedSeminarRegHeader.Reset();  //removes all filters
            PostedSeminarRegHeader.SetFilter("No.", DocNoFilter);
            PostedSeminarRegHeader.SetFilter("Posting Date", PostingDateFilter);
            DocNoOfRecords := PostedSeminarRegHeader.Count; // counts the number of records in the table

            //using record variable from the temporary Document Entry table
            if DocNoOfRecords = 0 then  //if there are no records
                exit;
            if DocumentEntry.FindLast then
                NextEntryNo := DocumentEntry."Entry No." + 1
            else
                NextEntryNo := 1;
            DocumentEntry.Init;  //initializes the record on the table
            DocumentEntry."Entry No." := NextEntryNo;
            DocumentEntry."Table ID" := Database::"CSD Posted Seminar Reg. Header";
            DocumentEntry."Document Type" := 0;
            DocumentEntry."Table Name" := COPYSTR(PostedSeminarRegHeader.TableCaption, 1, MaxStrLen(DocumentEntry."Table Name"));
            DocumentEntry."No. of Records" := DocNoOfRecords;
            DocumentEntry.Insert;  //inserts the record into the table without executing the code in OnInsert trigger
        end;

        //enabling Navigate to Find records from Seminar Ledger Entries
        if SeminarLedgerEntry.ReadPermission then begin
            SeminarLedgerEntry.Reset();
            SeminarLedgerEntry.SetFilter("Document No.", DocNoFilter);
            SeminarLedgerEntry.SetFilter("Posting Date", PostingDateFilter);
            DocNoOfRecords := SeminarLedgerEntry.Count;


            if DocNoOfRecords = 0 then
                exit;
            if DocumentEntry.FindLast then
                NextEntryNo := DocumentEntry."Entry No." + 1
            else
                NextEntryNo := 1;
            DocumentEntry.Init;
            DocumentEntry."Entry No." := NextEntryNo;
            DocumentEntry."Table ID" := Database::"CSD Seminar Ledger Entry";
            DocumentEntry."Document Type" := 0;
            DocumentEntry."Table Name" := COPYSTR(SeminarLedgerEntry.TableCaption, 1, MaxStrLen(DocumentEntry."Table Name"));
            DocumentEntry."No. of Records" := DocNoOfRecords;
            DocumentEntry.Insert;
        end;
    end;

    [EventSubscriber(ObjectType::Page, 344, 'OnAfterNavigateShowRecords', '', true, true)]
    local procedure ExtendNavigateOnAfterNavigateShowRecords(TableID: Integer; DocNoFilter: Text; PostingDateFilter: Text; ItemTrackingSearch: Boolean);
    var
        SeminarLedgerEntry: record "CSD Seminar Ledger Entry";
        PostedSeminarRegHeader: record "CSD Posted Seminar Reg. Header";
    begin
        //enabling Navigate to show records from both the Seminar Ledger Entries and the Posted Seminar Reg. Header tables
        case TableID of
            Database::"CSD Posted Seminar Reg. Header":
                begin
                    PostedSeminarRegHeader.SetFilter("No.", DocNoFilter);
                    PostedSeminarRegHeader.SetFilter("Posting Date", PostingDateFilter);
                    Page.Run(0, PostedSeminarRegHeader); //the call to open the page passes the value 0 to the Page.Run function. This causes the system to open the default lookup page for the table.            
                end;
            Database::"CSD Seminar Ledger Entry":
                begin
                    SeminarLedgerEntry.SetFilter("Document No.", DocNoFilter);
                    SeminarLedgerEntry.SetFilter("Posting Date", PostingDateFilter);
                    Page.Run(0, SeminarLedgerEntry);
                end;
        end;
    end;

    // << Lab 8 2-2

}