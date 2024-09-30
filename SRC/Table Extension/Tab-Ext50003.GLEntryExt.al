tableextension 50003 "G/L Entry Ext" extends "G/L Entry"
{
    fields
    {
        field(50000; "Insurance No"; Code[30])
        {
            Caption = 'Insurance No';
            DataClassification = ToBeClassified;
        }
    }
}
