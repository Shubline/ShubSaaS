page 50056 "POS Line"
{
    Caption = 'POS Line';
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "POS Line";
    AutoSplitKey = true;


    layout
    {
        area(Content)
        {
            repeater("POS Line")
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(Purity; Rec.Purity)
                {
                    ApplicationArea = All;
                }
                field("Ornament Category Code"; Rec."ORNAMENT CATEGORY CODE")
                {
                    ToolTip = 'Specifies the value of the Ornament Category Code field.', Comment = '%';
                }
                field("Section ID"; Rec."SECTION ID")
                {
                    ToolTip = 'Specifies the value of the Section ID field.', Comment = '%';
                }
                field("Brand ID"; Rec."BRAND ID")
                {
                    ToolTip = 'Specifies the value of the Brand ID field.', Comment = '%';
                }
                field("No. of PCS"; Rec."No. of PCS")
                {
                    ToolTip = 'Specifies the value of the No. of PCS field.', Comment = '%';
                }
                field("Gross Weight"; Rec."Gross Weight")
                {
                    ApplicationArea = All;
                    DecimalPlaces = 3 : 3;
                }
                field("Net Weight"; Rec."Net Weight")
                {
                    ApplicationArea = All;
                    DecimalPlaces = 3 : 3;
                }
                field("Tag Amount"; Rec."Tag Amount")
                {
                    ApplicationArea = All;
                    DecimalPlaces = 2 : 2;
                }
                field(Discount; Rec.Discount)
                {
                    ToolTip = 'Specifies the value of the Discount field.', Comment = '%';
                    DecimalPlaces = 3 : 3;
                }
                field("Taxable Amount"; Rec."Taxable Amount")
                {
                    ToolTip = 'Specifies the value of the Taxable Amount field.', Comment = '%';
                    DecimalPlaces = 2 : 2;
                }
                field("Tax Amount"; Rec."Tax Amount")
                {
                    ToolTip = 'Specifies the value of the Tax Amount field.', Comment = '%';
                    DecimalPlaces = 2 : 2;
                }
                field("Net Amount"; Rec."Net Amount")
                {
                    ToolTip = 'Specifies the value of the Net Amount field.', Comment = '%';
                    DecimalPlaces = 2 : 2;
                }
                field("Tag No"; Rec."Tag No")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Variant ID"; Rec."Variant ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("ORNAMENT SUB CATEGORY"; Rec."ORNAMENT SUB CATEGORY")
                {
                    ToolTip = 'Specifies the value of the Ornament Sub Category field.', Comment = '%';
                    Visible = false;
                }
                field("DESIGN CODE"; Rec."DESIGN CODE")
                {
                    ToolTip = 'Specifies the value of the Design Code field.', Comment = '%';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
        }
    }
}