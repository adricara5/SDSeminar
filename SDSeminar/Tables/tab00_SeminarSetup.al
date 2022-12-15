table 50100 "CSD Seminar Setup"
//Setup tables contain 1 record that holds general information about an application area, in this case Seminar
//Provides that settings that define the behavior of the business logic in the application area
{
    Caption = 'Seminar Setup';
    DataClassification = AccountData;

    fields
    {
        field(10; "Primary Key"; Code[10])
        //it is always left blank as only 1 record for each table is permitted
        {
            Caption = 'Primary Key';

        }
        field(20; "Seminar Nos."; Code[20])
        {
            Caption = 'Seminar Nos.';
            TableRelation = "No. Series";
        }
        field(30; "Seminar Registration Nos."; Code[20])
        {
            Caption = 'Seminar Registration Nos.';
            TableRelation = "No. Series";
        }
        field(40; "Posted Seminar Reg. Nos."; Code[20])
        {
            Caption = 'Posted Seminar Reg. Nos.';
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

}