table 60000 "Student Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Addmission No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Addmission No.';
            TableRelation = "No. Series";
        }
        field(3; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Document No. ';
            TableRelation = "No. Series";
        }
        field(4; "Workflow Header No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Workflow Header No.';
            TableRelation = "No. Series";
        }

    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

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