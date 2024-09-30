table 50217 "POS Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Estimate Document No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Tag No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Estimate Line No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Item Type"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Purity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Net Weight"; Decimal)
        {
            DecimalPlaces = 3 : 3;
            DataClassification = ToBeClassified;
        }
        field(7; "Gross Weight"; Decimal)
        {
            DecimalPlaces = 3 : 3;
            DataClassification = ToBeClassified;
        }
        field(8; "Metal Value"; Decimal)
        {
            DecimalPlaces = 3 : 3;
            DataClassification = ToBeClassified;
        }
        field(9; "Diamond Value"; Decimal)
        {
            DecimalPlaces = 3 : 3;
            DataClassification = ToBeClassified;
        }
        field(10; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item."No.";
        }
        field(11; "Item Description"; text[500])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
        }
        field(12; "No. of PCS"; Integer)
        {
        }
        field(13; "Tag Amount"; Decimal)
        {
        }
        field(14; "Discount"; Decimal)
        {
        }
        field(15; "Tax Amount"; Decimal)
        {
        }

        field(16; "ORNAMENT CATEGORY CODE"; Code[20])
        {
            Caption = 'Ornament Category Code';
        }
        field(17; "ORNAMENT SUB CATEGORY"; Code[20])
        {
            Caption = 'Ornament Sub Category';
        }
        field(18; "SECTION ID"; Code[20])
        {
            Caption = 'Section ID';
        }
        field(19; "BRAND ID"; Code[20])
        {
            Caption = 'Brand ID';
        }
        field(20; "DESIGN CODE"; Code[20])
        {
            Caption = 'Design Code';
        }
        
        field(22; "Net Amount"; Decimal)
        {
        }
        field(23; "Variant ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
        }
        field(24; "Pre Document No"; Code[20])
        {
            Editable = false;
            //     DataClassification = ToBeClassified;
        }
        field(25; "Posted"; Boolean)
        {
            Editable = false;
            // FieldClass = FlowField;
            // CalcFormula = sum("Tender Line".Amount where("Document No" = field("Document No")));
        }
        field(26; "Taxable Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Outward Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Outward Discount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Outward Coupon"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Outward Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Receipt No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(33; "Customer Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(34; "Salesperson"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
        field(35; "Mobile No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(36; "Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Store No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(38; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(39; "SchemeEntryNo"; Code[20])
        {
            Caption = 'Scheme Entry No.';
            DataClassification = ToBeClassified;
        }
        field(40; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(41; "Pre Estimate Document No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(42; "Pre Receipt No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(43; "POS Posted"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Receipt No.", "Line No.", "Store No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnModify()
    begin

    end;

    // trigger OnDelete()
    // var
    //     EstimateDetailLine: Record "Estimate Detail Line";
    // begin
    //     EstimateDetailLine.Reset();
    //     EstimateDetailLine.SetRange("Document No", "Document No");
    //     EstimateDetailLine.SetRange("Estimate Line No.", "Line No");
    //     if EstimateDetailLine.FindSet() then
    //         repeat
    //             EstimateDetailLine.Delete(true);
    //         until EstimateDetailLine.Next() = 0;
    // end;

    trigger OnRename()
    begin

    end;

}