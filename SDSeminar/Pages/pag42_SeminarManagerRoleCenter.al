page 50142 "CSD Seminar Manager RoleCenter"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 10 - Lab 1 - 5
// - Created new page
// The Role Center page
//Each Role Center is represented by a page object
//A Role Center is a composite page which consists of: other pages such as activities and lists, systemparts such as notifications and outlook, definition of the actions in the ribbon, and definitions of the navigation pane and its contents
//The Role Center links users to processes in which they participate
{
    Caption = 'Seminar Manger RoleCenter';
    PageType = RoleCenter;  //the components are: Ribbon, Navigation Pane and Role Center Area(Content Area)
    //RoleCenter pages do not have triggers
    ApplicationArea = All;

    layout
    {
        area(RoleCenter)
        {
            group(Column1)
            {
                part("Seminar Manager Activities"; "CSD Seminar Manager Activites")
                {
                }
                part("My Seminars"; "CSD My Seminars")
                {
                }
            }
            group(Column2)
            {
                part("My Customers"; "My Customers")
                {
                }
                systempart(MyNotifications; MyNotes)
                {
                }
                part(ReportInbox; "Report Inbox Part")
                {
                }
            }
        }
    }

    actions
    {  //the ribbon organizes action types into tabs and groups for easy access by users
        area(Embedding)
        {
            action(SeminarRegistrations)
            {
                Caption = 'Seminar Registrations';
                Image = List;
                RunObject = page "CSD Posted Seminar Reg. List";
                ToolTip = 'Create Seminar Registrations';
            }
            action(Seminars)
            {
                Caption = 'Seminars';
                Image = List;
                RunObject = page "CSD Seminar List";
                ToolTip = 'View all seminars';
            }
            action(Instructors)
            {
                Caption = 'Instructors';
                Image = List;
                RunObject = page "Resource List";
                RunPageView = WHERE(Type = const(Person));
                ToolTip = 'View all resources registered as persons';
            }
            action(Rooms)
            {
                Caption = 'Rooms';
                Image = List;
                RunObject = page "Resource List";
                RunPageView = WHERE(Type = const(Machine));
                ToolTip = 'View all resources registered as machines';
            }
            action(SalesInvoices)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales Invoices';
                Image = Invoice;
                RunObject = page "Sales Invoice List";
                ToolTip = 'Register your sales to customers';
            }
            action(SalesCreditMemo)
            {
                Caption = 'Sales Credit Memo';
                Image = List;
                RunObject = page "Sales Credit Memos";
                ToolTip = 'Revert the financial transactions involved when your customers want to cancel a purchase';
            }
            action(Customers)
            {
                Caption = 'Customers';
                Image = Customer;
                RunObject = page "Customer List";
                ToolTip = 'View or edit detailed information for the customers that you trade with';
            }
        }

        area(Sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                ToolTip = 'View history for sales, shipments and inventory';
                action("Posted Seminar Registrations")
                {
                    Caption = 'Posted Seminar Registrations';
                    Image = Timesheet;
                    RunObject = page "CSD Posted Seminar Reg. List";
                    ToolTip = 'Open the list of posted Registrations';
                }
                action("Posted Sales Invoices")
                {
                    Caption = 'Posted Sales Invoices';
                    Image = PostedOrder;
                    RunObject = page "Posted Sales Invoices";
                    ToolTip = 'Open the list of posted sales invoices';
                }
                action("Posted Sales Credit Memos")
                {
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedOrder;
                    RunObject = page "Posted Sales Credit Memos";
                    ToolTip = 'Open the list of posted sales credit memos';
                }
                action("Registers")
                {
                    Caption = 'Seminar Registers';
                    Image = PostedShipment;
                    RunObject = page "CSD Seminar Registers";
                    ToolTip = 'Open the list of Seminar Registers';
                }
            }
        }

        area(Creation)
        {
            action(NewSeminarRegistrations)
            {
                Caption = 'Seminar Registration';
                Image = Timesheet;
                RunObject = page "CSD Seminar Registration";
                RunPageMode = Create;
            }
            action(NewSalesInvoice)
            {
                Caption = 'Sales Invoice';
                Image = NewSalesInvoice;
                RunObject = page "Sales Invoice";
                RunPageMode = Create;
            }

        }

        area(Processing)
        {
            action(CreateInvoices)
            {
                Caption = 'Create Invoices';
                Image = CreateJobSalesInvoice;
                RunObject = report "CSD Create Seminar Invoices";
            }
            action(Navigate)
            {
                Caption = 'Navigate to Sales Invoice';
                Image = Navigate;
                RunObject = page Navigate;
                RunPageMode = Edit;
            }
        }
    }
}