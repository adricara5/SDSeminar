table 50131 "CSD Seminar Journal Line"
//Journal tables enable transaction entry for an app. area.
//All the transactions, whether entered by a user or generated from another posting routine, pass through the journal table to eventually be posted to a ledger table
//Journals are temporary work areas for users
//Users can insert,change and delete all records in journals
//Journal line tables store information about the transaction itself
//Lines belong to batches and batches belong to templates
//For each Journal table there is a group of codeunits that is responsible for muving data from the journal tables to the ledger tables
//In this solution, only document posting functionality is needed and that is why I have not provided all the journal tables and pages but anyway you must provide journal posting functionality to enable documents to post ledger entries in a way that is consistent with both practices


{
    // CSD1.00 - 2018-01-01 - D. E. Veloper
    //   Chapter 7 - Lab 1
    //     - Created new table

    Caption = 'Seminar Journal Line';

    fields
    {
        field(1; "Journal Template Name"; Code[10])  //set by the the Journal Page that the user accesses
        //relates to the journal template table
        {
            Caption = 'Journal Template Name';
        }
        field(2; "Line No."; Integer) //is set automatically by the AutoSplitKey property
        {
            Caption = 'Line No.';
        }
        field(3; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            TableRelation = "CSD Seminar";
        }
        field(4; "Posting Date"; Date)  //specifies the date for the entry(when the transaction occurred)
        {
            Caption = 'Posting Date';
            trigger OnValidate()
            begin
                Validate("Document Date", "Posting Date");
                //sets the document date field to the value of the posting date field when users edit the Posting Date field
            end;
        }
        field(5; "Document Date"; Date)   //specifies the date for the document
        {
            Caption = 'Document Date';
        }
        //by default this equals the Posting Date
        //users may change this date because transaction may be entered and posted on different dates
        field(6; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Registration,Cancelation';
            OptionMembers = Registration,Cancelation;
        }
        field(7; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(8; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(10; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
        field(11; "Charge Type"; Option)
        {
            Caption = 'Charge Type';
            OptionCaption = 'Instructor,Room,Participant,Charge';
            OptionMembers = Instructor,Room,Participant,Charge;
        }
        field(12; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Resource,G/L Account';
            OptionMembers = Resource,"G/L Account";
        }
        field(13; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(14; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
        }
        field(15; "Total Price"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Price';
        }
        field(16; "Participant Contact No."; Code[20])
        {
            Caption = 'Participant Contact No.';
            TableRelation = Contact;
        }
        field(17; "Participant Name"; Text[50])
        {
            Caption = 'Participant Name';
        }
        field(18; Chargeable; Boolean)
        {
            Caption = 'Chargeable';
            InitValue = true;
        }
        field(19; "Room Resource No."; Code[20])
        {
            Caption = 'Room Resource No.';
            TableRelation = Resource where(Type = const(Machine));
        }
        field(20; "Instructor Resource No."; Code[20])
        {
            Caption = 'Instructor Resource No.';
            TableRelation = Resource where(Type = const(Person));
        }
        field(21; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(22; "Seminar Registration No."; Code[20])
        {
            Caption = 'Seminar Registration No.';
        }
        field(23; "Res. Ledger Entry No."; Integer)
        {
            Caption = 'Res. Ledger Entry No.';
            TableRelation = "Res. Ledger Entry";
        }
        field(30; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = '" ,Seminar"';
            OptionMembers = " ",Seminar;
        }
        field(31; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = if ("Source Type" = const(Seminar)) "CSD Seminar";
        }
        field(32; "Journal Batch Name"; Code[10])  //set by the Journal Page but users can change this field at the top of the page
        //relates to the journal batch table
        {
            Caption = 'Journal Batch Name';
        } //this field must exist in all journal tables but is frequently located after all the fields that describe the transaction
        field(33; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            Editable = false;
            TableRelation = "Source Code";
        }   //specifies the source for the entry
        //sources map directly to journal templates => they map to transaction types
        //forms the basis of the audit trail that BC leaves for every transaction
        field(34; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }   //specifies the reason why the entry was posted
        field(35; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
        }
    }

    procedure EmptyLine(): Boolean;  //all Journal Line tables must contain the EmptyLine function, which is called during the posting process to make sure no empty lines are posted
    begin
        exit(("Seminar No." = '') AND (Quantity = 0));  //defines if a line is empty
        //number of conditions in the EmptyLine function depends on the complexity of the journal transaction. In this case 2 conditions define if the line is empty
        //exit keyword ends the procedure with the specified exit value(in this case boolean true or false)
    end;
}

