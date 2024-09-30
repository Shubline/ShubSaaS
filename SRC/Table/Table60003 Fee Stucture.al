table 60003 "Fee Structure"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Class Code"; Code[20])
        {
            Caption = 'Class Code';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[240])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(3; "Fees Amount"; Decimal)
        {
            Caption = 'Fees Amount';
            DataClassification = ToBeClassified;
        }
        field(4; "Transportaion Charges"; Decimal)
        {
            Caption = 'Transportaion Charges';
            DataClassification = ToBeClassified;
        }
        field(5; "New Addmission Charge"; Decimal)
        {
            Caption = 'New Addmission Charge';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Class Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Class Code", Description)
        {
        }
        fieldgroup(Brick; "Class Code", Description)
        {
        }

    }

    procedure ClaculateTotalFeesAmount("Class Code": Code[20]; Transportation: Boolean; "New Addmission": Boolean; "No. of Month": integer): Decimal
    var
        FeeStructure: Record "Fee Structure";
        Sum: Decimal;
    begin
        Clear(Sum);

        if FeeStructure.Get("Class Code") then begin
            if Transportation then
                Sum += FeeStructure."Transportaion Charges" * "No. of Month";

            if "New Addmission" then
                Sum += FeeStructure."New Addmission Charge";

            Sum += FeeStructure."Fees Amount" * "No. of Month";
        end;
        exit(Sum);
    end;
}