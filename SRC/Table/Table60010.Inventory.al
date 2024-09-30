table 60010 Inventory
{
    Caption = 'Inventory';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(3; "Variant Code"; Code[20])
        {
            Caption = 'Variant Code';
        }
        field(4; Description; Text[250])
        {
            Caption = 'Description';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Ledger Entry".Description where("Item No." = field("Item No."), "Variant Code" = field("Variant Code")));
        }
        field(5; "Actual Inventory"; Decimal)
        {
            Caption = 'Actual Inventory';
        }
    }
    keys
    {
        key(PK; "Location Code", "Item No.", "Variant Code")
        {
            Clustered = true;
        }
    }
}
