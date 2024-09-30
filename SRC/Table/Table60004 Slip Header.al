table 60004 "Slip Header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
            TableRelation = "No. Series";
        }
        field(2; "Addmission No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = student."Addmission No.";
        }
        field(3; "Name"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Class; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(5; status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Open","Release";
        }
        field(6; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Payment Method Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Method".Code;
        }
        field(8; Session; text[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Method";
        }
        field(9; "Quarter"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "","Q1","Q2","Q3","Q4";
        }
        field(10; Balance; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Student ledger Entries"."Remaning  Amount" where("Addmission No." = field("Addmission No.")));
        }
    }

    keys
    {
        key(pk; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        StudentSetup: record "Student Setup";
    begin
        StudentSetup.Get();
        if "No." = '' then
            InitNoSeries(StudentSetup."Document No.");
    end;

    Procedure InitNoSeries(NoSeriesCode: Code[25])
    var
        NoSeriesMgt: Codeunit "No. Series - Batch";
        // NoSeriesMgt: Codeunit "No. Series";
    begin
        Clear(NoSeriesMgt);
        Validate("No.", (NoSeriesMgt.GetNextNo(NoSeriesCode, 0D, true)));
        NoSeriesMgt.SaveState();
    end;
}