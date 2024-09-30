query 50001 QueryApi
{
    Caption = 'QueryApi';
    QueryType = API;

    APIVersion = 'v2.0';
    APIPublisher = 'shubham';
    APIGroup = 'mpj';

    // EntityCaption = 'Sales Invoice';
    // EntitySetCaption = 'Sales Invoices';
    EntityName = 'Inventory';
    EntitySetName = 'Inventory';

    elements
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            column(LocationCode; "Location Code") { }
            column(ItemNo; "Item No.") { }
            column(VariantCode; "Variant Code") { }
            column(Inventory; "Remaining Quantity")
            {
                Method = Sum;
                ColumnFilter = Inventory = filter(> 0);
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
