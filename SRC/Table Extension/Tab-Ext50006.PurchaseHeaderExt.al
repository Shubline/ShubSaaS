tableextension 50006 "PurchaseHeader Ext" extends "Purchase Header"
{
    fields
    {
        field(50001; "Purchase Type"; Enum "Purchase Type")
        {
            Caption = 'Purchase Type';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                PurchaseLine: Record "Purchase Line";
            begin
                if Rec."Purchase Type" <> xRec."Purchase Type" then begin
                    if Dialog.Confirm('Purchase Line Will Delete, Do you want to Change the Purchase Type', false) then begin
                        PurchLine.Reset();
                        PurchaseLine.SetRange("Document No.", Rec."No.");
                        PurchaseLine.DeleteAll(true);
                    end
                end;
            end;
        }
    }
}
