table 80003 "Emails"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Email List";
    LookupPageId = "Email List";

    fields
    {
        field(1; "Serial No."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Email ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Email ID"."Email ID";
            ValidateTableRelation = false;
        }
        field(3; "Sender Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Reciepent Mail","CC Mail","BCC Mail";
        }
        field(4; "Email Address"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Serial No.", "Email ID", "Email Address")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Serial No.", "Email ID") { }

        fieldgroup(Brick; "Serial No.", "Email ID") { }
    }

    trigger OnInsert()
    var
        CurrentTable: Record "Emails";
    begin
        CurrentTable.Reset();
        CurrentTable.SetCurrentKey("Serial No.");
        CurrentTable.SetAscending("Serial No.", true);
        if CurrentTable.FindLast() then
            "Serial No." := CurrentTable."Serial No." + 1
        else
            "Serial No." := 1;
    end;
}