tableextension 50001 purchaseLineExt extends "Purchase Line"
{
        
     
    fields
    {
        field(50000; "Insurance No"; Code[30])
        {
            Caption = 'Insurance No';
            DataClassification = ToBeClassified;
        }
        field(50001; "Purchase Type"; Enum "Purchase Type")
        {
            Caption = 'Purchase Type';
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header"."Purchase Type" where("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }

    }
}
