report 50101 "CSD SeminarRegParticipantList"
// This is a list of participants registered for a seminar
// This report should be available from both the main Seminar menu and the Seminar Registration page.
{
    Caption = 'Seminar Reg. Participant List';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/SeminarRegParticipantList.rdl';  //sets the RDL layout that is used on a report and returns it as a data stream
    //to render a report from inside the RoleTailored client, you must create a RDLC report layout(Created using Sql Server Report Builder)

    dataset
    {
        dataitem(SeminarRegistrationHeader; "CSD Seminar Reg. Header")
        {
            DataItemTableView = sorting("No."); //sets the key based on which to sort the sort order and the filters for the data item
            RequestFilterFields = "No.", "Seminar No.";  //sets which fields are included on the tab of the request page that is related to this data item
            column(No_; "No.")
            {
                IncludeCaption = true; //captions are available for the fields of both data items
            }

            column(SeminarNo_; "Seminar No.")
            {
                IncludeCaption = true;
            }

            column(Seminar_Name; "Seminar Name")
            {
                IncludeCaption = true;
            }

            column(Starting_Date; "Starting Date")
            {
                IncludeCaption = true;
            }

            column(Duration_; "Duration")
            {
                IncludeCaption = true;
            }

            column(Instructor_Name; "Instructor Name")
            {
                IncludeCaption = true;
            }
            column(Room_Name; "Room Name")
            {
                IncludeCaption = true;
            }

            dataitem(SeminarRegistrationLine; "CSD Seminar Registration Line")
            {
                DataItemTableView = sorting("Document No.", "Line No.");
                DataItemLink = "Document No." = field("No.");  //data item links to the Document No. if the line data item is equal to the No. field in the header data item 
                column(Bill_to_Customer_No_; "Bill-to Customer No.")
                {
                    IncludeCaption = true;
                }

                column(Participant_Contact_No_; "Participant Contact No.")
                {
                    IncludeCaption = true;
                }

                column(Participant_Name; "Participant Name")
                {
                    IncludeCaption = true;
                }
            }
        }

        dataitem("Company Information"; "Company Information")
        {
            column(Company_Name; Name)
            {

            }
        }
    }

    labels
    {
        SeminarRegistrationHeaderCap = 'Seminar Registration List';
    }
}

//use ctrl+shift+B to create the layout file