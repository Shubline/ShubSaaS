query 60001 "Inventory Query"
{
    Caption = 'Inventory Query';
    QueryType = Normal;

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
}