table 50003 "POS Cue"
{
    Caption = 'POS Cue';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[25])
        {
            Caption = 'Primary Key';
        }

        field(2; "Estimate(s)"; Integer)
        {
            Caption = 'Estimate(s)';
        }
        field(3; "Customer"; Integer)
        {
            Caption = 'Customer';
        }
        field(4; "Quick Customer"; Integer)
        {
            Caption = 'Quick Customer';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
