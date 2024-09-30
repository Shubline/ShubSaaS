pageextension 87254 "Lot No. Information Card Ext" extends "Lot No. Information Card"
{
    layout
    {
        addafter("Lot No.")
        {
            field(Barcode; Rec.Barcode)
            {
                ApplicationArea = all;
            }
        }
    }
}
pageextension 87654 "Item Ledger Entries Ext" extends "Item Ledger Entries"
{
    layout
    {
        modify("Lot No.")
        {
            Visible = true;
        }
        addafter("Lot No.")
        {
            field(Barcode; Rec.Barcode)
            {
                ApplicationArea = all;
            }
        }
    }
}
pageextension 87655 "Item Tracking Lines Ext" extends "Item Tracking Lines"
{
    layout
    {
        addafter("Lot No.")
        {
            field(Barcode; Rec.Barcode)
            {
                ApplicationArea = all;
            }
        }
    }
}