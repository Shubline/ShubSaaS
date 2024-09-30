table 60005 "Slip Line"
{
    DrillDownPageId = "Student ledger Entries";
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Pre Receipt","Post Receipt";

        }
        field(2; "Document No."; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Addmission No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(5; Class; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(50; Amount; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(60; "Payment"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Fee Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Quater Fee","Yearly Fee";

        }
        field(8; Session; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(9; Quarter; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Q1","Q2","Q3","Q4";

        }
    }

    keys
    {
        key(pk; "Document No.", "Line No.")
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


table 60080 "Slip Detail Line"
{
    DrillDownPageId = "Student ledger Entries";
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Pre Receipt","Post Receipt";

        }
        field(2; "Document No."; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Addmission No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(5; Class; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(50; Amount; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(60; "Payment"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Fee Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Quater Fee","Yearly Fee";

        }
        field(8; Session; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(9; Quarter; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Q1","Q2","Q3","Q4";

        }
        field(10; "Slip Line No."; Integer)
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(pk; "Document No.", "Slip Line No.", "Line No.")
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