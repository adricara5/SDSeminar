table 50133 "CSD Seminar Register"
//Register Tables are tables of contents for their corresponding ledger table or tables.
//It is a table that keeps history of all transactions
//There is 1 record per posting process
//Cannot be changed by users
//A list page is used to view the records in the register tables
//Each functional area that includes a ledger also includes a register
//For each transaction, it always keeps track of the first and the last Ledger Entry record
//It keeps the transaction log for posted seminars
{
    // CSD1.00 - 2018-01-01 - D. E. Veloper
    //   Chapter 7 - Lab 1
    //     - Created new table

    Caption = 'Seminar Register';

    fields
    {
        field(1; "No."; Integer)
        //the primary key is always incremented by 1 by the posting routine that controls the register
        {
            Caption = 'No.';
        }
        field(2; "From Entry No."; Integer)
        {
            Caption = 'From Entry No.';
            TableRelation = "CSD Seminar Ledger Entry";
        }
        field(3; "To Entry No."; Integer)
        {
            Caption = 'To Entry No.';
            TableRelation = "CSD Seminar Ledger Entry";
        }
        field(4; "Creation Date"; Date)
        //the date when the transaction was posted
        {
            Caption = 'Creation Date';
        }
        field(5; "Source Code"; Code[10])
        //indicates the source of the transaction
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(6; "User ID"; Code[50])
        //specifies which user has posted the transaction
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            //here I changed what the book instructed to do because the procedure was removed in the latest release
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                UserSelection: Codeunit "User Selection";
            begin
                UserSelection.ValidateUserName("User ID");
            end;


        }
        field(8; "Journal Batch Name"; Code[10])
        //inidcates the journal from which the transaction was posted
        {
            Caption = 'Journal Batch Name';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Creation Date")
        {
        }
        key(Key3; "Source Code", "Creation Date")
        {
        }
    }
}

