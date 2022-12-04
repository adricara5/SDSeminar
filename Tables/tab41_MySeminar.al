table 50141 "CSD My Seminar"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 10 - Lab 1 - 3
// - Created new page
{
    DataClassification = ToBeClassified;
    Caption = 'My Seminar';

    fields
    {
        field(10; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User;
            DataClassification = ToBeClassified;

        }
        field(20; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            TableRelation = "CSD Seminar";
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "User ID", "Seminar No.")
        {
            Clustered = true;
        }
    }
}