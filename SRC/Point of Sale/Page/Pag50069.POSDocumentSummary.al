page 50069 "POS Document Summary"
{
    PageType = CardPart;
    Caption = 'POS Document Summary';
    Editable = false;
    LinksAllowed = false;
    SourceTable = "POS Header";

    layout
    {
        area(Content)
        {
            group("Summary")
            {
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Mobile No."; Rec."Mobile No.")
                {
                    ApplicationArea = All;
                }
                field("Base Amount"; BaseTotal)
                {
                    ApplicationArea = All;
                }
                field("Discount Amount"; DiscountTotal)
                {
                    ApplicationArea = All;
                }
                field("Tax Amount"; TaxtTotal)
                {
                    ApplicationArea = All;
                }
                field("Net Amount"; NetTotal)
                {
                    ApplicationArea = All;
                }
                field("Payments Amount"; PaymentAmount)
                {
                    ApplicationArea = All;
                }
                field("Balance Amount"; BalanceAmount)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    // actions
    // {
    //     area(Processing)
    //     {
    //         action(ActionName)
    //         {
    //             ApplicationArea = All;

    //             trigger OnAction()
    //             begin

    //             end;
    //         }
    //     }
    // }

    trigger OnAfterGetCurrRecord()
    begin
        BaseTotal := 0;
        DiscountTotal := 0;
        TaxtTotal := 0;
        NetTotal := 0;
        recPOSLine.Reset();
        recPOSLine.SetRange("Receipt No.", Rec."Receipt No.");
        if recPOSLine.FindSet() then begin
            recPOSLine.CalcSums("Taxable Amount");
            recPOSLine.CalcSums(Discount);
            recPOSLine.CalcSums("Tax Amount");
            recPOSLine.CalcSums("Net Amount");
            BaseTotal := recPOSLine."Taxable Amount";
            DiscountTotal := recPOSLine.Discount;
            TaxtTotal := recPOSLine."Tax Amount";
            NetTotal := recPOSLine."Net Amount";
        end;

        PaymentAmount := 0;
        recPOSTenderLine.Reset();
        recPOSTenderLine.SetRange("Receipt No.", Rec."Receipt No.");
        if recPOSTenderLine.FindSet() then begin
            recPOSTenderLine.CalcSums(Amount);
            PaymentAmount := recPOSTenderLine.Amount;
        end;

        BalanceAmount := 0;
        BalanceAmount := NetTotal - PaymentAmount;
    end;

    var
        BaseTotal: Decimal;
        DiscountTotal: Decimal;
        TaxtTotal: Decimal;
        NetTotal: Decimal;
        PaymentAmount: Decimal;
        BalanceAmount: Decimal;
        recPOSLine: Record "POS Line";
        recPOSTenderLine: Record "POS Tender Line";
        Sa: Page "Sales Doc. Check Factbox";
}