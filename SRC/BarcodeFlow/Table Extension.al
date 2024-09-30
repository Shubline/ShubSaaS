tableextension 89794 "Lot No. Information Ext" extends "Lot No. Information"
{
    fields
    {
        field(50000; "Barcode"; code[30])
        {
            DataClassification = ToBeClassified;
        }
    }
}

tableextension 89795 "Tracking Specification Ext" extends "Tracking Specification"
{
    fields
    {
        field(50000; "Barcode"; code[30])
        {
            DataClassification = ToBeClassified;
        }
    }
}
tableextension 89797 "Reservation Entry Ext" extends "Reservation Entry"
{
    fields
    {
        field(50000; "Barcode"; code[30])
        {
            DataClassification = ToBeClassified;
        }
    }
}

tableextension 89796 "Item Ledger Entry Ext" extends "Item Ledger Entry"
{
    fields
    {
        field(50000; "Barcode"; code[30])
        {
            DataClassification = ToBeClassified;
        }
    }
}

tableextension 89798 "Item Journal Line Ext" extends "Item Journal Line"
{
    fields
    {
        field(50000; "Barcode"; code[30])
        {
            DataClassification = ToBeClassified;
        }
    }
}