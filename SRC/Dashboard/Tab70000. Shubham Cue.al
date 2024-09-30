table 70000 "Shubham Cue"
{
    Caption = 'Shubham Cue';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[25])
        {
            Caption = 'Primary Key';
        }
        field(2; "Job Cue Error"; Integer)
        {
            Caption = 'Job Cue Error';
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