page 60013 Inventory
{
    ApplicationArea = All;
    Caption = 'Inventory';
    PageType = List;
    SourceTable = Inventory;
    UsageCategory = Lists;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ToolTip = 'Specifies the value of the Variant Code field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Actual Inventory"; Rec."Actual Inventory")
                {
                    ToolTip = 'Specifies the value of the Actual Inventory field.';
                }
            }
        }
    }
}
