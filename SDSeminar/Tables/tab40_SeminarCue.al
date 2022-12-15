table 50140 "CSD Seminar Cue"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 10 - Lab 1 - 1
// - Created new page
// It contains the flow fields for the cues on the Activities page part of the Role Center page
// The source table for the Activities page that shows the cues
// It can only contain a single record
// Every cue is defined as an integer field of FlowField class and it uses Count method
{
    Caption = 'Seminar Cue';

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = ToBeClassified;
        }
        field(20; Planned; Integer)
        {
            Caption = 'Planned';
            FieldClass = FlowField;
            CalcFormula = Count("CSD Seminar Reg. Header" where(Status = const(Planning)));

        }
        field(30; Registered; Integer)
        {
            Caption = 'Registered';
            FieldClass = FlowField;
            CalcFormula = Count("CSD Seminar Reg. Header" where(Status = const(Registration)));
        }
        field(40; Closed; Integer)
        {
            Caption = 'Closed';
            FieldClass = FlowField;
            CalcFormula = Count("CSD Seminar Reg. Header" where(Status = const(Closed)));

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