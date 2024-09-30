page 50007 "SalesInvoice"
{
    PageType = API;

    APIVersion = 'v2.0';
    APIPublisher = 'shubham';
    APIGroup = 'mpj';

    EntityCaption = 'Sales Invoice';
    EntitySetCaption = 'Sales Invoices';
    EntityName = 'SalesInvoice';
    EntitySetName = 'SalesInvoices';

    // ODataKeyFields = "Document Type", "No.";
    ODataKeyFields = SystemId;
    SourceTable = "Sales Header";

    Extensible = false;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {

            field(SystemId; Rec.SystemId) { }
            field("DocumentType"; Rec."Document Type") { }
            field("No"; Rec."No.") { }
            field("CustomerNo"; Rec."Sell-to Customer No.") { }
            field("CustomerName"; Rec."Sell-to Customer Name") { }

            part(SalesLines; SalesLines)
            {
                SubPageLink = "Document No." = field("No.");

                EntityName = 'SalesLine';
                EntitySetName = 'SalesLines';
            }
        }
    }
}


page 50008 "SalesLines"
{
    PageType = API;

    APIVersion = 'v2.0';
    APIPublisher = 'shubham';
    APIGroup = 'mpj';

    EntityCaption = 'Sales Line';
    EntitySetCaption = 'Sales Linees';
    EntityName = 'SalesLine';
    EntitySetName = 'SalesLines';

    // ODataKeyFields = "Document Type", "Document No.", "Line No.";
    ODataKeyFields = SystemId;
    SourceTable = "Sales Line";

    Extensible = false;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            field(SystemId; Rec.SystemId) { }
            field("DocumentType"; Rec."Document Type") { }
            field("DocumentNo"; Rec."Document No.") { }
            field("LineNo"; Rec."Line No.") { }
            field("ItemNo"; Rec."No.") { }
            field(Description; Rec.Description) { }
        }
    }
}