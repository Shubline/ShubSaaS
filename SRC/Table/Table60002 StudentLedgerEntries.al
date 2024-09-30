table 60002 "Student Ledger Entries"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Student ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Addmission No."; Code[20])
        {
            DataClassification = ToBeClassified;
            // FieldClass=FlowField;
            // CalcFormula=lookup(student."Addmission No." );
        }
        field(3; "Student Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Class"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Payment Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Remaning  Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; Quarter; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Q1","Q2","Q3","Q4";
        }
        field(20; "Quarter Fee"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Financial Year"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Fee Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Year Fee","Quarter Fee";
        }
        field(11; "Period"; Option)
        {
            OptionMembers = "Apr-jun","Jul-Sep","Oct-Dec","Jan-Mar";
            DataClassification = ToBeClassified;
        }
        field(12; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(13; Open; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14; Session; text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(15; Month; Enum months)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }

    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin
        if "Entry No." = 0 then
            GenerateEntryNo(true);
    end;


    procedure GenerateEntryNo(Validate: Boolean): Integer
    var
        CurrTable: Record "Student Ledger Entries";
        EntryNo: Integer;
    begin
        CurrTable.Reset();
        if CurrTable.FindLast() then
            EntryNo := CurrTable."Entry No." + 1
        else
            EntryNo := 1;

        if Validate then
            Validate("Entry No.", EntryNo);

        exit(EntryNo);
    end;
}