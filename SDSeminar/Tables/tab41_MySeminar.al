table 50141 "CSD My Seminar"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 10 - Lab 1 - 3
// - Created new table
// Contains the list of Seminars that each user has included in the My Seminars list
// To manage the lists for different users, every list page uses the source table that has the following characteristics:
// It is named after the record type of the list, preceded by the word “my.” 
// It contains only two fields: User ID that specifies to which user the record belongs, and another field that relates to the specific record of the type that list page shows. 
// Its primary key always contains both fields.
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