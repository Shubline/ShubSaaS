table 60014 "Webtel Integration Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "URL to Generate IRN"; Text[2000])
        {
            DataClassification = ToBeClassified;
            Caption = 'URL to Generate IRN';
        }
        field(3; "URL to Cancel IRN"; Text[2000])
        {
            DataClassification = ToBeClassified;
            Caption = 'URL to Cancel IRN';
        }
        field(4; "URL to Generate Eway-Invoice"; Text[2000])
        {
            DataClassification = ToBeClassified;
            Caption = 'URL to Generate Eway-Invoice';
        }
        field(5; "URL to Print Eway-Invoice"; Text[2000])
        {
            DataClassification = ToBeClassified;
            Caption = 'URL to Print Eway-Invoice';
        }
        field(6; "CDKEY"; Text[25])
        {
            DataClassification = ToBeClassified;
            Caption = 'CDKEY';
        }
        field(7; "EFUSERNAME"; Text[25])
        {
            DataClassification = ToBeClassified;
            Caption = 'EFUSERNAME';
        }
        field(8; "EFPASSWORD"; Text[25])
        {
            DataClassification = ToBeClassified;
            Caption = 'EFPASSWORD';
        }
        field(9; "EINVUSERNAME"; Text[25])
        {
            DataClassification = ToBeClassified;
            Caption = 'EINVUSERNAME';
        }
        field(10; "EINVPASSWORD"; Text[25])
        {
            DataClassification = ToBeClassified;
            Caption = 'EINVPASSWORD';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}