table 60006 "Excel Attachment"
{
    Caption = 'Excel Attachment';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[30])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[2048])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
