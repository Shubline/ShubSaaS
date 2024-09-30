tableextension 50133 "TableExtSalesCrMemoLine" extends "Sales Cr.Memo Line"
{
    fields
    {
        field(50000;"Exported to Sales Register";Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Exported to Sales Register';
        }
         field(50010; "Location GST Reg. No."; Code[20])
        {
            Caption = 'Location GST Reg. No.';
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Cr.Memo Header"."Location GST Reg. No." WHERE("No." = FIELD("Document No.")));
        }
    }
    var myInt: Integer;
}
