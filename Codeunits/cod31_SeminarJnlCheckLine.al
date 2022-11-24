codeunit 50131 "CSD Seminar Jnl.-Check Line"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 7 - Lab 2-1
{
    TableNo = "CSD Seminar Journal Line";  //sets the source table number for the codeunit

    trigger OnRun()
    begin
        RunCheck(Rec);
    end;

    var
        GlSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        AllowPostingFrom: Date;
        AllowPostingTo: Date;
        ClosingDateTxt: Label 'cannot be a closing date.';
        PostingDateTxt: Label 'is not allowed in your range of allowed posting dates.';
    //these variables are text constants that display errors if entries are posted on closing dates or outside the allowed posting periods
    //used in FieldError() procedure

    procedure RunCheck(var SemJnlLine: Record "CSD Seminar Journal Line");
    var
        myInt: Integer;
    begin
        With SemJnlLine do begin   //"with" is used to include the record parameter that is passed to the function
            if EmptyLine then
                exit;

            TestField("Posting Date"); //makes sure that a field is not empty(in this case Posting Date field)
            TestField("Instructor Resource No.");
            TestField("Seminar No.");

            case "Charge Type" of  //depending on the value of the Charge Type field
                "Charge Type"::Instructor:
                    TestField("Instructor Resource No.");
                "Charge Type"::Room:
                    TestField("Room Resource No.");
                "Charge Type"::Participant:
                    TestField("Participant Contact No.");
            end;

            if Chargeable then
                TestField("Bill-to Customer No.");

            if "Posting Date" = ClosingDate("Posting Date") then  //shows an error if the Posting Date is a closing Date
                FieldError("Posting Date", ClosingDateTxt);

            //standard check in all journal posting codeunits
            //it checks if the Posting Date is between Allow Posting From field value and Allow Posting To field value in the User Setup Table
            //it also checks in case these fields are not defined in the User Setup table and then uses G/L Setup Table to retrieve the values of these fields
            if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then begin
                if UserId <> '' then // <> same as !=
                    if UserSetup.GET(UserId) then begin
                        AllowPostingFrom := UserSetup."Allow Posting From";
                        AllowPostingTo := UserSetup."Allow Posting To";
                    end;
                if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D)
                then begin
                    GLSetup.Get;
                    AllowPostingFrom := GLSetup."Allow Posting From";
                    AllowPostingTo := GLSetup."Allow Posting To";
                end;
                if AllowPostingTo = 0D then
                    AllowPostingTo := DMY2Date(31, 12, 9999);
            end;
            if ("Posting Date" < AllowPostingFrom) OR ("Posting Date" > AllowPostingTo) then
                FieldError("Posting Date", PostingDateTxt);
            //only executed the first time the Seminar Check-Line codeunit is run because the variables are global

            //showing an error if the Document Date field is a closing date
            if ("Document Date" <> 0D) then
                if ("Document Date" = ClosingDate("Document Date")) then
                    FieldError("Document Date", PostingDateTxt);
        end;
    end;
}