tableextension 50002 "Gen. Journal Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        field(50000; "Insurance No"; Code[30])
        {
            Caption = '"Insurance No"';
            DataClassification = ToBeClassified;
        }
    }
}
