pageextension 50102 "Sales Order Ext1" extends "Sales Order"
{

    actions
    {
        // modify(Release)
        // {
            // trigger OnBeforeAction()
            // var
            //  now: DotNet MyDateTime;
            // begin
            //     Calculate_Total_Amount_and_Taxes(Rec."No.");
            // end;
        // }
    }

    local procedure Calculate_Total_Amount_and_Taxes(DocNo: Code[30])
    var
        RecSalesLine: Record "Sales Line";
        GSTRate: Integer;
        IGSTRate: Integer; 
        CGSTRate: Integer;
        SGSTRate: Integer;
        UTGSTRate: Integer;
        IGST: Decimal;
        CGST: Decimal;
        SGST: Decimal;
        UTGST: Decimal;
        J: Integer;
        GSTComponentCode: array[20] of Integer;
        GST: Record "Detailed GST Ledger Entry";
        TaxTrnasactionValue: Record "Tax Transaction Value";
        TaxTrnasactionValue1: Record "Tax Transaction Value";
        TotalAmount: Decimal;
        TotalGSTTaxes: Decimal;
        GrandTotal: Decimal;
    begin


        // GST Calcucation
        SGST := 0;
        IGST := 0;
        CGST := 0;
        // UTGST := 0;
        // GSTRate := 0;
        // SGSTRate := 0;
        // IGSTRate := 0;
        // CGSTRate := 0;
        // UTGSTRate := 0;

        RecSalesLine.Reset();
        RecSalesLine.SetRange("Document No.", DocNo);
        if RecSalesLine.FindSet() then BEGIN
            j := 1;
            TaxTrnasactionValue.Reset();
            TaxTrnasactionValue.SetRange("Tax Record ID", RecSalesLine.RecordId);
            TaxTrnasactionValue.SetRange("Tax Type", 'GST');
            TaxTrnasactionValue.SetRange("Value Type", TaxTrnasactionValue."Value Type"::COMPONENT);
            TaxTrnasactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTrnasactionValue.FindSet() then BEGIN
                repeat
                    j := TaxTrnasactionValue."Value ID";
                    GSTComponentCode[j] := TaxTrnasactionValue."Value ID";
                    TaxTrnasactionValue1.Reset();
                    TaxTrnasactionValue1.SetRange("Tax Record ID", RecSalesLine.RecordId);
                    TaxTrnasactionValue1.SetRange("Tax Type", 'GST');
                    TaxTrnasactionValue1.SetRange("Value Type", TaxTrnasactionValue."Value Type"::COMPONENT);
                    TaxTrnasactionValue1.SetRange("Value ID", GSTComponentCode[j]);
                    if TaxTrnasactionValue1.FindSet() then BEGIN

                        repeat
                            if j = 6 then begin
                                SGST := TaxTrnasactionValue1.Amount;
                            end;
                            if j = 2 then begin
                                CGST := TaxTrnasactionValue1.Amount;
                            end;
                            if j = 3 then begin
                                IGST := TaxTrnasactionValue1.Amount;
                            end;
                            if j = 5 then begin
                                UTGST := TaxTrnasactionValue1.Amount;
                            end;
                        until TaxTrnasactionValue1.Next() = 0;

                        if (SGST = 0) And (IGST = 0) then begin
                            Dialog.Error('Gst Base Amount is Zero in Line %1', RecSalesLine."Line No.");
                        end;

                    END;
                    j += 1;

                until TaxTrnasactionValue.Next() = 0;
            END;

        END;
    END;
}
// dotnet
// {
//     assembly(mscorlib)
//     {
//         type(System.DateTime; MyDateTime){}
//     }
// }