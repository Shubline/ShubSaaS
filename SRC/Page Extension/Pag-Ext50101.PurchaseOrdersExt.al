pageextension 50101 "PurchaseOrderExt" extends "Purchase Order"
{
    layout
    {

        addafter("Buy-from Vendor No.")
        {
            field("Purchase Type"; Rec."Purchase Type")
            {
                ApplicationArea = all;
                trigger OnValidate()
                begin
                    CurrPage.Update();
                    CurrPage.PurchLines.Page.Update();
                end;
            }
        }

        addfirst(factboxes)
        {

        }
    }
}