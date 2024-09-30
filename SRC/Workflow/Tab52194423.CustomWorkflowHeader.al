table 70005 "Indent Header"
{
    Caption = 'Indent Header';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Indent list";
    LookupPageId = "Indent list";
    fields
    {
        field(1; "No."; Code[10])
        {
            Caption = 'No.';
            Editable = false;
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    StudentSetup.Get();
                    NoSeriesMgt.TestManual(StudentSetup."Workflow Header No.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(3; Status; Enum "Custom Approval Enum")
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            StudentSetup.Get();
            StudentSetup.TestField("Workflow Header No.");
            // NoSeriesMgt.InitSeries(StudentSetup."Workflow Header No.", xRec."No. Series", 0D, "No.", "No. Series");
            "No." := NoSeriesMgt.GetNextNo(StudentSetup."Workflow Header No.", 0D, true)
        end;
    end;

    var
        StudentSetup: Record "Student Setup";
        NoSeriesMgt: Codeunit "No. Series";
}

