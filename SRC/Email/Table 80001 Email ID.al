table 80001 "Email ID"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Email ID(s)";
    LookupPageId = "Email ID(s)";

    fields
    {
        field(1; "Email ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Description"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Page No."; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = filter('Page'));

            trigger OnValidate()
            var
                RecObject: Record AllObjWithCaption;
            begin
                RecObject.Reset();
                RecObject.SetRange("Object Type", RecObject."Object Type"::Page);
                RecObject.SetRange("Object ID", "Page No.");
                if RecObject.FindFirst() then
                    "Page Description" := RecObject."Object Caption";
            end;
        }
        field(4; "Page Description"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Action Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Report No."; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = filter('Report'));

            trigger OnValidate()
            var
                RecObject: Record AllObjWithCaption;
            begin
                RecObject.Reset();
                RecObject.SetRange("Object Type", RecObject."Object Type"::Report);
                RecObject.SetRange("Object ID", "Report No.");
                if RecObject.FindFirst() then
                    "Report Description" := RecObject."Object Caption"
                else
                    Clear("Report Description");
            end;
        }
        field(7; "Report Description"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Attach Report"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if ("Attach Report" = false) then
                    "Use Request Page" := false;
            end;
        }
        field(9; "Use Request Page"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if (not "Attach Report") then
                    Dialog.Error('Attach Report Must be True to use this feature');
            end;
        }
        field(10; "Open In Email Editor"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Subject"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Report Format"; Enum "Report Format")
        {
            DataClassification = ToBeClassified;
            InitValue = 'pdf';
        }
        field(13; "Sendor Email Address"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Sendor Email Account"; Guid)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Page No.", "Action Name")
        {
            Clustered = true;
        }

        key(Key2; "Email ID")
        {
            Unique = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Email ID", Description, "Page No.", "Page Description") { }

        fieldgroup(Brick; "Email ID", Description, "Page No.", "Page Description") { }

    }
}