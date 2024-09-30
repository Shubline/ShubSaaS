report 60201 "Sales Register"
{
    // UsageCategory = ReportsAndAnalysis;
    Caption = 'Update Sales register';
    // ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = TableData "Sales Invoice Line" = rmd,
        TableData "Sales Cr.Memo Line" = rmd,
        Tabledata "Transfer Shipment Line" = rmd;

    dataset
    {
        dataitem("Sales Invoice Line"; "Sales Invoice Line")
        {
            DataItemTableView = WHERE("Exported to Sales Register" = FILTER(false), Quantity = filter(<> 0));

            trigger OnPreDataItem()
            begin
                RemainingStatus := 0;
                RowNo := 0;
                Window.OPEN('Transferring Sales Data....\\' + '@1@@@@@@@@@@@@@@@@@@@@@@@@@', RemainingStatus);
                TotalRec := COUNT;
                IF NOT blnRunSale THEN CurrReport.BREAK;
                if "Sales Invoice Line".Exempted = true then
                    exem := '';
            end;

            trigger OnAfterGetRecord()
            begin
                RowNo += 1;
                RemainingStatus := ROUND((RowNo / TotalRec) * 10000, 1);
                Window.UPDATE;
                InsertSalesInv("Sales Invoice Line");
            end;
        }
        dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
        {
            DataItemTableView = WHERE("Exported to Sales Register" = FILTER(false), Quantity = filter(<> 0));
            trigger OnPreDataItem()
            begin
                RemainingStatus := 0;
                RowNo := 0;
                Window.OPEN('Transfering Sales Return Data....\\' + '@1@@@@@@@@@@@@@@@@@@@@@@@@@', RemainingStatus);
                TotalRec := COUNT;
                IF NOT blnRunSaleCr THEN CurrReport.BREAK;
            end;

            trigger OnAfterGetRecord()
            begin
                RowNo += 1;
                RemainingStatus := ROUND((RowNo / TotalRec) * 10000, 1);
                Window.UPDATE;
                InsertSalesCrMemo("Sales Cr.Memo Line");
            end;
        }
        dataitem("Transfer Shipment Header"; "Transfer Shipment Header")
        {
            trigger OnPreDataItem()
            begin
                RemainingStatus := 0;
                RowNo := 0;
                Window.OPEN('Transfering Trf. Shipment Data....\\' + '@1@@@@@@@@@@@@@@@@@@@@@@@@@', RemainingStatus);
                TotalRec := COUNT;
                IF NOT blnRunTransShpt THEN CurrReport.BREAK;
            end;

            trigger OnAfterGetRecord()
            begin
                RowNo += 1;
                RemainingStatus := ROUND((RowNo / TotalRec) * 10000, 1);
                Window.UPDATE;
                InsertTransShpt("Transfer Shipment Header");
            end;
        }

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Update Data")
                {
                    field("Update Sales"; blnRunSale)
                    {
                        ApplicationArea = All;
                    }
                    field("Update Sales Cr. Memo"; blnRunSaleCr)
                    {
                        ApplicationArea = All;
                    }
                    Field("Update Transfer Shipment"; blnRunTransShpt)
                    {
                        ApplicationArea = All;
                    }
                    Field("Update Trans. Sales Entry"; blnRunTransSalesEntry)
                    {
                        ApplicationArea = All;
                    }
                }
                group("Delete Data")
                {
                    field("Delete Sales Line"; blnRegenerateSales)
                    {
                        ApplicationArea = All;
                    }
                    field("Delete Sales Cr. Memo Line"; blnRegenerateSalesCr)
                    {
                        ApplicationArea = All;
                    }
                    field("Delete Transfer Shipment Line"; blnRegenerateTransShpt)
                    {
                        ApplicationArea = All;
                    }
                    field("Delete Trans. Sales Line"; blnRegenerateTransSalesLine)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;
                }
            }
        }
    }


    procedure InsertSalesInv(VAR lSalesInvLine: Record "Sales Invoice Line")
    var
        lSalesInvHdr: Record "Sales Invoice Header";
    begin
        With lSalesInvLine do begin
            lSalesInvHdr.GET("Document No.");
            Loc.GET("Location Code");
            Cust.GET(lSalesInvHdr."Sell-to Customer No.");
            IF recCustPriceGroup.GET(lSalesInvHdr."Customer Price Group") THEN;
            IF (Type = Type::"G/L Account") AND ("No." = CPG."Invoice Rounding Account") AND ("Line No." <> 10000) THEN BEGIN
                SalesRegister1.RESET;
                SalesRegister1.SETRANGE("Document Type", SalesRegister1."Document Type"::"Sales Invoice");
                SalesRegister1.SETRANGE("Source Document No.", "Document No.");
                SalesRegister1.FIND('+');
                SalesRegister1."Round Off Amount" := Amount;
                //SalesRegister1."Net Amount" += Amount;
                SalesRegister1.MODIFY;
            END
            ELSE BEGIN
                SalesRegister.INIT;
                SalesRegisterNew.Reset();
                SalesRegisterNew.SetRange("Document Type", SalesRegisterNew."Document Type"::"Sales Invoice");
                if SalesRegisterNew.FindLast() then
                    SalesRegister."Transaction No." := SalesRegisterNew."Transaction No." + 1
                else
                    SalesRegister."Transaction No." := 1;

                SalesRegister."Document Type" := SalesRegister."Document Type"::"Sales Invoice";
                SalesRegister."Source Document No." := "Document No.";
                SalesRegister."Source Line No." := "Line No.";
                SalesRegister."Posting Date" := lSalesInvHdr."Posting Date";
                //RK 09May22 Begin
                SalesRegister."Document Date" := lSalesInvHdr."Document Date";
                recTCSEntry.Reset();
                recTCSEntry.SetRange("Document No.", lSalesInvHdr."No.");
                if recTCSEntry.FindFirst() then
                    SalesRegister."TCS Amount" := recTCSEntry."TCS Amount";
                //recCustLedgEntry.Reset();
                //recCustLedgEntry.SetRange("Document No.", lSalesInvHdr."No.");
                //if recCustLedgEntry.FindFirst() then
                //recCustLedgEntry.CalcFields("Amount (LCY)");
                //SalesRegister."Total Bill Amount" := recCustLedgEntry."Amount (LCY)";
                SalesRegister."Vehicle Type" := lSalesInvHdr."Vehicle Type";
                SalesRegister."Vehicle No." := lSalesInvHdr."Vehicle No.";

                recDefaultDimension.Reset();
                recDefaultDimension.SetRange("Table ID", 18);
                recDefaultDimension.SetRange("No.", lSalesInvHdr."Sell-to Customer No.");
                recDefaultDimension.SetRange("Dimension Code", 'CUSTOMER TYPE');
                if recDefaultDimension.FindFirst() then
                    SalesRegister."Customer Type" := recDefaultDimension."Dimension Value Code";

                SalesRegister."Customer Disc. Group" := lSalesInvHdr."Customer Disc. Group";
                recCustDiscGroup.Reset();
                recCustDiscGroup.SetRange(Code, lSalesInvHdr."Customer Disc. Group");
                if recCustDiscGroup.FindFirst() then
                    SalesRegister."Customer Disc. Group Name" := recCustDiscGroup.Description;


                SalesRegister."Source Line Description" := Description;
                SalesRegister."Document Salesperson Code" := lSalesInvHdr."Salesperson Code";
                SalesRegister."Order No." := lSalesInvHdr."Order No.";
                IF lSalesInvHdr."Salesperson Code" <> '' THEN BEGIN
                    IF Salesperson.GET(lSalesInvHdr."Salesperson Code") THEN;
                    SalesRegister."Document Salesperson Name" := Salesperson.Name;
                END;

                txtPostedComment := '';
                recPostedComment.Reset();
                recPostedComment.SetRange("No.", lSalesInvHdr."No.");
                if recPostedComment.FindFirst() then
                    repeat
                        txtPostedComment += recPostedComment.Comment + ' ';
                    until recPostedComment.Next() = 0;
                SalesRegister."Narration/Comments" := CopyStr(txtPostedComment, 1, 250);

                recEWayBillEinvoice.Reset();
                recEWayBillEinvoice.SetRange("No.", lSalesInvHdr."No.");
                if recEWayBillEinvoice.FindFirst() then begin
                    SalesRegister."E-Invoice No." := recEWayBillEinvoice."E-Invoice IRN No";
                    SalesRegister."E-Way Bill No." := recEWayBillEinvoice."E-Way Bill No.";
                end;

                // SalesRegister."Delivery Boy" := lSalesInvHdr."Delivery Boy";

                SalesRegister."Ship-To Code" := lSalesInvHdr."Ship-to Code";
                SalesRegister."Ship-To Name" := lSalesInvHdr."Ship-to Name";

                SalesRegister."Payment Term Code" := lSalesInvHdr."Payment Terms Code";
                SalesRegister."Due date" := lSalesInvHdr."Due Date";
                SalesRegister."Source Type" := SalesRegister."Source Type"::Customer;
                SalesRegister."Source No." := lSalesInvHdr."Sell-to Customer No.";
                SalesRegister."Source Name" := Cust.Name;
                SalesRegister."Source City" := Cust.City;
                SalesRegister."External Document No." := lSalesInvHdr."External Document No.";
                SalesRegister."Source State Code" := Cust."State Code";
                IF recState.GET(Cust."State Code") THEN BEGIN
                    SalesRegister."Source State Name" := recState.Description;
                END;
                SalesRegister.Remarks := '';
                SalesRegister."Location GST Registration No." := lSalesInvHdr."Location GST Reg. No.";
                SalesRegister."Shipping Address" := lSalesInvHdr."Ship-to Address" + ' ' + lSalesInvHdr."Ship-to Address 2";
                SalesRegister."Customer Posting Group" := lSalesInvHdr."Customer Posting Group";
                SalesRegister."Customer Posting Group" := Cust."Customer Posting Group";
                SalesRegister."Customer Price Group" := lSalesInvHdr."Customer Price Group";
                SalesRegister."Currency Code" := lSalesInvHdr."Currency Code";
                SalesRegister."Currency Fector" := lSalesInvHdr."Currency Factor";
                SalesRegister."Customer Price Group Name" := recCustPriceGroup.Description;
                SalesRegister."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                GBPG.GET("Gen. Bus. Posting Group");
                SalesRegister."GBPG Description" := GBPG.Description;
                GPPG.GET("Gen. Prod. Posting Group");
                SalesRegister."GPPG Description" := GPPG.Description;
                SalesRegister."Country/Region Code" := Cust."Country/Region Code";
                IF Cust."Country/Region Code" <> '' THEN BEGIN
                    Country.GET(Cust."Country/Region Code");
                    SalesRegister."Country/Region Name" := Country.Name;
                END;
                SalesRegister."Master Salesperson Code" := Cust."Salesperson Code";
                SalesRegister."Master Cust. Posting Group" := Cust."Customer Posting Group";
                IF Cust."Salesperson Code" <> '' THEN BEGIN
                    IF Salesperson.GET(Cust."Salesperson Code") THEN;
                    SalesRegister."Master Salesperson Name" := Salesperson.Name;
                END;
                SalesRegister."Territory Dimension Name" := DimValue.Name;
                SalesRegister."Outward Location Code" := "Location Code";
                SalesRegister."Outward State Code" := Loc."State Code";
                IF recState.GET(Loc."State Code") THEN BEGIN
                    SalesRegister."Outward State Name" := recState.Description;
                END;
                intDay := DATE2DMY(lSalesInvHdr."Posting Date", 1);
                intMonth := DATE2DMY(lSalesInvHdr."Posting Date", 2);
                intYear := DATE2DMY(lSalesInvHdr."Posting Date", 3);
                CASE intMonth OF
                    1:
                        cdMonthName := 'JAN';
                    2:
                        cdMonthName := 'FEB';
                    3:
                        cdMonthName := 'MAR';
                    4:
                        cdMonthName := 'APR';
                    5:
                        cdMonthName := 'MAY';
                    6:
                        cdMonthName := 'JUN';
                    7:
                        cdMonthName := 'JUL';
                    8:
                        cdMonthName := 'AUG';
                    9:
                        cdMonthName := 'SEP';
                    10:
                        cdMonthName := 'OCT';
                    11:
                        cdMonthName := 'NOV';
                    12:
                        cdMonthName := 'DEC';
                END;
                IF intMonth < 4 THEN BEGIN
                    cdFinYear := FORMAT(intYear - 1) + '-' + FORMAT(intYear - 2000);
                    cdQuarter := 'Q4';
                END
                ELSE
                    IF intMonth < 7 THEN BEGIN
                        cdFinYear := FORMAT(intYear) + '-' + FORMAT(intYear - 2000 + 1);
                        cdQuarter := 'Q1';
                    END
                    ELSE
                        IF intMonth < 10 THEN BEGIN
                            cdFinYear := FORMAT(intYear) + '-' + FORMAT(intYear - 2000 + 1);
                            cdQuarter := 'Q2';
                        END
                        ELSE BEGIN
                            cdFinYear := FORMAT(intYear) + '-' + FORMAT(intYear - 2000 + 1);
                            cdQuarter := 'Q3';
                        END;

                if "Sales Invoice Line".Exempted = true then begin
                    SalesRegister."GST Base Amount" := "Sales Invoice Line"."Line Amount";
                    SalesRegister."GST Group" := "Sales Invoice Line"."GST Group Code";
                end;


                SalesRegister."Fin. Year" := cdFinYear;
                SalesRegister.Quarter := cdQuarter;
                SalesRegister."Month Name" := cdMonthName;
                SalesRegister.Year := intYear;
                SalesRegister.Month := intMonth;
                SalesRegister.Day := intDay;
                IF (Type = Type::Item) AND ("No." <> '') THEN BEGIN
                    Item.GET("No.");
                    SalesRegister."Inventory Posting Group" := Item."Inventory Posting Group";
                    SalesRegister."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                    SalesRegister."Item Category Code" := Item."Item Category Code";
                    IF Item."Item Category Code" <> '' THEN BEGIN
                        ICC.GET(Item."Item Category Code");
                        SalesRegister."Item Category Description" := ICC.Description;
                    END;

                    recItemAttributeValueMapping.Reset();
                    recItemAttributeValueMapping.SetRange("Table ID", 27);
                    recItemAttributeValueMapping.SetRange("No.", Item."No.");
                    recItemAttributeValueMapping.SetRange("Item Attribute ID", 1);
                    if recItemAttributeValueMapping.FindFirst() then begin
                        recItemAttributeValue.Reset();
                        recItemAttributeValue.SetRange(id, recItemAttributeValueMapping."Item Attribute Value ID");
                        if recItemAttributeValue.FindFirst() then
                            SalesRegister.Brand := recItemAttributeValue.Value;
                    END;

                    SalesRegister.Type := Type;
                    SalesRegister."No." := "No.";
                    SalesRegister."Variant Code" := "Variant Code";
                    SalesRegister."Item Description" := Description;
                    SalesRegister."Gross Weight" := Item."Gross Weight";
                    SalesRegister."Net Weight" := Item."Net Weight";
                    SalesRegister."MRP Price" := Item."Unit Price";
                    SalesRegister."Qty. in KG" := lSalesInvLine.Quantity * SalesRegister."Net Weight";//RK 09May22
                    SalesRegister."Unit of Measure" := "Unit of Measure Code";
                    IF SalesRegister."Variant Code" <> '' THEN BEGIN
                        ItemVariant.GET(SalesRegister."No.", SalesRegister."Variant Code");
                        SalesRegister."Variant Description" := ItemVariant."Description 2";
                    END;
                    //if lSalesInvLine."Line No." = 10000 then begin
                    recCustLedgEntry.Reset();
                    recCustLedgEntry.SetRange("Document No.", lSalesInvHdr."No.");
                    if recCustLedgEntry.FindFirst() then
                        recCustLedgEntry.CalcFields("Amount (LCY)");
                    SalesRegister."Total Bill Amount" := recCustLedgEntry."Amount (LCY)";
                    //end;

                    SalesRegister.Quantity := Quantity;
                    SalesRegister."Unit Price" := "Unit Price";
                    SalesRegister.Amount := Quantity * "Unit Price";
                    SalesRegister."Line Discount Amount" := "Line Discount Amount";
                    SalesRegister."Line Amount" := "Line Amount";
                    SalesRegister."TDS Base Amount" := 0;
                    SalesRegister."TDS Amount" := 0;

                    recDGLE.Reset();
                    recDGLE.SetRange("No.", lSalesInvLine."Document No.");
                    recDGLE.SetRange("Document Line No.", lSalesInvLine."Line No.");
                    recDGLE.SetRange("GST Component Code", 'CESS');
                    if recDGLE.FindFirst() then begin
                        SalesRegister."Cess Amount" := recDGLE."GST Amount";
                    end;

                    SalesRegister."eCESS on TDS Amount" := 0;
                    SalesRegister."TDS Nature of Deduction" := '';
                    SalesRegister."TDS %" := 0;
                    SalesRegister."eCESS % on TDS" := 0;
                    SalesRegister."Tax Group Code" := "Tax Group Code";
                    SalesRegister."Tax Area" := "Tax Area Code";
                    IF "Tax Area Code" <> '' THEN BEGIN
                        TaxAreaLine.RESET;
                        TaxAreaLine.SETRANGE("Tax Area", "Tax Area Code");
                        TaxAreaLine.FIND('-');
                        SalesRegister."Tax Jurisdiction Code" := TaxAreaLine."Tax Jurisdiction Code";
                        TaxJuris.GET(TaxAreaLine."Tax Jurisdiction Code");
                        AddTaxAmt := 0;
                        TaxAmt := 0;
                        TaxPer := 0;
                        AddTaxPer := 0;
                        IF SalesRegister."Tax Type" = SalesRegister."Tax Type"::CST THEN
                            SalesRegister."CST Amount" := TaxAmt
                        ELSE
                            SalesRegister."VAT Amount" := TaxAmt;
                        SalesRegister."Tax %" := TaxPer;
                    END;
                    IF SalesRegister."Tax Type" = SalesRegister."Tax Type"::VAT THEN SalesRegister."Tax Type" := SalesRegister."Tax Type"::VAT;
                    SalesRegister."Line Discount %" := "Line Discount %";
                    SalesRegister."Applies-to Doc. Type" := lSalesInvHdr."Applies-to Doc. Type";
                    SalesRegister."Applies-to Doc. No." := lSalesInvHdr."Applies-to Doc. No.";
                    SalesRegister."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                    SalesRegister."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                    SalesRegister."No. Series" := lSalesInvHdr."No. Series";

                    // if "Sales Invoice Line".Exempted = true then begin
                    //     SalesRegister."GST Base Amount" := "Sales Invoice Line"."Line Amount";
                    //     SalesRegister."GST Group" := "Sales Invoice Line"."GST Group Code";
                    // end;

                    //SalesRegister."Net Amount" := Amount;
                    recDtGSTLedg.RESET();
                    recDtGSTLedg.SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
                    recDtGSTLedg.SETRANGE("Document Line No.", "Sales Invoice Line"."Line No.");
                    recDtGSTLedg.SETRANGE("GST Component Code", 'CGST');
                    IF recDtGSTLedg.FIND('-') THEN BEGIN
                        SalesRegister."CGST %" := ABS(recDtGSTLedg."GST %");
                        SalesRegister."CGST Amount" := -1 * (recDtGSTLedg."GST Amount");





                        /// changed///
                        // if lSalesInvLine.Exempted = true then begin
                        //     SalesRegister."GST Base Amount" := "lSalesInvLine"."Line Amount";
                        //     SalesRegister."GST Group" := "lSalesInvLine"."GST Group Code";
                        // end
                        // else begin
                        //     SalesRegister."GST Base Amount" := -1 * (recDtGSTLedg."GST Base Amount");
                        //     SalesRegister."GST Group" := recDtGSTLedg."GST Group Code";
                        // end;



                        SalesRegister."HSN/SAC Code" := recDtGSTLedg."HSN/SAC Code";
                        SalesRegister."Location Reg. No." := recDtGSTLedg."Location  Reg. No.";
                        SalesRegister."Customer Reg. No." := recDtGSTLedg."Buyer/Seller Reg. No.";
                        SalesRegister."GST Place of Supply" := FORMAT(recDtGSTLedg."GST Place of Supply");
                    END;
                    recDtGSTLedg.RESET();
                    recDtGSTLedg.SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
                    recDtGSTLedg.SETRANGE("Document Line No.", "Sales Invoice Line"."Line No.");
                    recDtGSTLedg.SETRANGE("GST Component Code", 'SGST');
                    IF recDtGSTLedg.FIND('-') THEN BEGIN
                        SalesRegister."SGST %" := ABS(recDtGSTLedg."GST %");
                        SalesRegister."SGST Amount" := -1 * (recDtGSTLedg."GST Amount");
                        SalesRegister."GST Base Amount" := -1 * (recDtGSTLedg."GST Base Amount");
                        SalesRegister."GST Group" := recDtGSTLedg."GST Group Code";
                        SalesRegister."HSN/SAC Code" := recDtGSTLedg."HSN/SAC Code";
                        SalesRegister."Location Reg. No." := recDtGSTLedg."Location  Reg. No.";
                        SalesRegister."Customer Reg. No." := recDtGSTLedg."Buyer/Seller Reg. No.";
                        SalesRegister."GST Place of Supply" := FORMAT(recDtGSTLedg."GST Place of Supply");
                    END;
                    recDtGSTLedg.RESET();
                    recDtGSTLedg.SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
                    recDtGSTLedg.SETRANGE("Document Line No.", "Sales Invoice Line"."Line No.");
                    recDtGSTLedg.SETRANGE("GST Component Code", 'IGST');
                    IF recDtGSTLedg.FIND('-') THEN BEGIN
                        SalesRegister."IGST %" := ABS(recDtGSTLedg."GST %");
                        SalesRegister."IGST Amount" := -1 * (recDtGSTLedg."GST Amount");
                        SalesRegister."GST Base Amount" := -1 * (recDtGSTLedg."GST Base Amount");
                        SalesRegister."GST Group" := recDtGSTLedg."GST Group Code";
                        SalesRegister."HSN/SAC Code" := recDtGSTLedg."HSN/SAC Code";
                        SalesRegister."Location Reg. No." := recDtGSTLedg."Location  Reg. No.";
                        SalesRegister."Customer Reg. No." := recDtGSTLedg."Buyer/Seller Reg. No.";
                        SalesRegister."GST Place of Supply" := FORMAT(recDtGSTLedg."GST Place of Supply");
                    END;
                    SalesRegister."Total GST Amount" := ABS(SalesRegister."CGST Amount" + SalesRegister."SGST Amount" + SalesRegister."IGST Amount" + SalesRegister."Cess Amount");
                    //SalesRegister."Net Amount" := "Line Amount" - lSalesInvLine."Line Discount Amount" + ABS(SalesRegister."CGST Amount" + SalesRegister."SGST Amount" + SalesRegister."IGST Amount" + SalesRegister."Cess Amount");
                    SalesRegister."Net Amount" := lSalesInvLine."Line Amount" + ABS(SalesRegister."Total GST Amount");

                    if SalesRegister.Type = SalesRegister.Type::Item then begin
                        Item.Get("No.");
                        if SalesRegister."HSN/SAC Code" = '' then
                            SalesRegister."HSN/SAC Code" := Item."HSN/SAC Code";
                    end;

                    IF ("Gen. Prod. Posting Group" <> '') AND ("Gen. Bus. Posting Group" <> '') THEN BEGIN
                        IF GPS.GET("Gen. Bus. Posting Group", "Gen. Prod. Posting Group") THEN BEGIN
                            SalesRegister."Revenue Account Code" := GPS."Sales Account";
                            IF GLAcc.GET(GPS."Sales Account") THEN SalesRegister."Revenue Account Description" := GLAcc.Name;
                        END;
                    END;
                    IF (lSalesInvHdr."Customer Posting Group" <> '') THEN
                        IF (SalesRegister1."Customer Posting Group" <> '') THEN BEGIN
                            CPG.GET(lSalesInvHdr."Customer Posting Group");
                            CPG.GET(SalesRegister1."Customer Posting Group");
                            SalesRegister."Receivable Account Code" := CPG."Receivables Account";
                            IF GLAcc.GET(CPG."Receivables Account") THEN SalesRegister."Receivable Account Description" := GLAcc.Name;
                        END;
                END;

                recVE.Reset();
                recVE.SetRange("Document No.", lSalesInvLine."Document No.");
                recVE.SetRange("Document Line No.", lSalesInvLine."Line No.");
                if recVE.FindFirst() then begin
                    recILE.Reset();
                    recILE.SetRange("Entry No.", recVE."Item Ledger Entry No.");
                    if recILE.FindFirst() then begin
                        SalesRegister."Lot No." := recILE."Lot No.";
                        SalesRegister."Expiry Date" := recILE."Expiration Date";
                    end;
                end;

                SalesRegister.INSERT;
            END;
            lSalesInvLine."Exported to Sales Register" := True;
            lSalesInvLine.Modify();
        END;
    end;





















    procedure InsertSalesCrMemo(VAR lSalesCrMemoLine: Record "Sales Cr.Memo Line")
    var
        lSalesCrMemoHdr: Record "Sales Cr.Memo Header";
        lSalesRegister: Record "Sales/Transfer Register";
    begin
        WITH lSalesCrMemoLine do begin
            lSalesCrMemoHdr.GET("Document No.");
            IF Loc.GET("Location Code") THEN;
            Cust.GET("Sell-to Customer No.");

            IF recCustPriceGroup.GET(lSalesCrMemoHdr."Customer Price Group") THEN;
            IF (Type = Type::"G/L Account") AND ("No." = CPG."Invoice Rounding Account") AND ("Line No." <> 10000) THEN BEGIN
                SalesRegister1.RESET;
                SalesRegister1.SETRANGE("Document Type", SalesRegister1."Document Type"::"Sales Cr. Memo");
                SalesRegister1.SETRANGE("Source Document No.", "Document No.");
                SalesRegister1.FIND('+');
                SalesRegister1."Round Off Amount" := Amount;
                //SalesRegister1."Net Amount" += Amount;
                SalesRegister1.MODIFY;
            END
            ELSE BEGIN
                SalesRegister.INIT;
                SalesRegisterNew.Reset();
                SalesRegisterNew.SetRange("Document Type", SalesRegisterNew."Document Type"::"Sales Cr. Memo");
                if SalesRegisterNew.FindLast() then
                    SalesRegister."Transaction No." := SalesRegisterNew."Transaction No." + 1
                else
                    SalesRegister."Transaction No." := 1;
                SalesRegister."Document Type" := SalesRegister."Document Type"::"Sales Cr. Memo";
                SalesRegister."Source Document No." := "Document No.";
                SalesRegister."Source Line No." := "Line No.";
                SalesRegister."Posting Date" := "Posting Date";
                SalesRegister."Source Line Description" := Description;
                SalesRegister."Document Salesperson Code" := lSalesCrMemoHdr."Salesperson Code";
                SalesRegister."External Document No." := lSalesCrMemoHdr."External Document No.";

                recDefaultDimension.Reset();
                recDefaultDimension.SetRange("Table ID", 18);
                recDefaultDimension.SetRange("No.", lSalesCrMemoHdr."Sell-to Customer No.");
                recDefaultDimension.SetRange("Dimension Code", 'CUSTOMER TYPE');
                if recDefaultDimension.FindFirst() then
                    SalesRegister."Customer Type" := recDefaultDimension."Dimension Value Code";

                SalesRegister."Customer Disc. Group" := lSalesCrMemoHdr."Customer Disc. Group";
                recCustDiscGroup.Reset();
                recCustDiscGroup.SetRange(Code, lSalesCrMemoHdr."Customer Disc. Group");
                if recCustDiscGroup.FindFirst() then
                    SalesRegister."Customer Disc. Group Name" := recCustDiscGroup.Description;
                //RK 09May22
                SalesRegister."Document Date" := lSalesCrMemoHdr."Document Date";
                recTCSEntry.Reset();
                recTCSEntry.SetRange("Document No.", lSalesCrMemoHdr."No.");
                if recTCSEntry.FindFirst() then
                    SalesRegister."TCS Amount" := recTCSEntry."TCS Amount";
                //recCustLedgEntry.Reset();
                //recCustLedgEntry.SetRange("Document No.", lSalesCrMemoHdr."No.");
                //if recCustLedgEntry.FindFirst() then
                //recCustLedgEntry.CalcFields("Amount (LCY)");
                //SalesRegister."Total Bill Amount" := recCustLedgEntry."Amount (LCY)";
                SalesRegister."Vehicle Type" := lSalesCrMemoHdr."Vehicle Type";
                SalesRegister."Vehicle No." := lSalesCrMemoHdr."Vehicle No.";
                //RK End

                txtPostedComment := '';
                recPostedComment.Reset();
                recPostedComment.SetRange("No.", lSalesCrMemoHdr."No.");
                if recPostedComment.FindFirst() then
                    repeat
                        txtPostedComment += recPostedComment.Comment + ' ';
                    until recPostedComment.Next() = 0;
                SalesRegister."Narration/Comments" := CopyStr(txtPostedComment, 1, 250);

                recEWayBillEinvoice.Reset();
                recEWayBillEinvoice.SetRange("No.", lSalesCrMemoHdr."No.");
                if recEWayBillEinvoice.FindFirst() then begin
                    SalesRegister."E-Invoice No." := recEWayBillEinvoice."E-Invoice IRN No";
                    SalesRegister."E-Way Bill No." := recEWayBillEinvoice."E-Way Bill No.";
                end;

                recReferenceInv.Reset();
                recReferenceInv.SetRange("Document No.", lSalesCrMemoHdr."No.");
                recReferenceInv.SetRange("Source Type", recReferenceInv."Source Type"::Customer);
                if recReferenceInv.FindFirst() then begin
                    recSalesInvHeader.Reset();
                    recSalesInvHeader.SetRange("No.", recReferenceInv."Reference Invoice Nos.");
                    if recSalesInvHeader.FindFirst() then begin
                        SalesRegister."Ship-To Code" := recSalesInvHeader."Ship-to Code";
                        SalesRegister."Ship-To Name" := recSalesInvHeader."Ship-to Name";
                        SalesRegister."Shipping Address" := recSalesInvHeader."Ship-to Address" + ' ' + recSalesInvHeader."Ship-to Address 2";
                    end;
                end;

                IF lSalesCrMemoHdr."Salesperson Code" <> '' THEN BEGIN
                    IF Salesperson.GET(lSalesCrMemoHdr."Salesperson Code") THEN;
                    SalesRegister."Document Salesperson Name" := Salesperson.Name;
                END;
                SalesRegister."Payment Term Code" := lSalesCrMemoHdr."Payment Terms Code";
                SalesRegister."Currency Code" := lSalesCrMemoHdr."Currency Code";
                SalesRegister."Currency Fector" := lSalesCrMemoHdr."Currency Factor";
                SalesRegister."Supplier's Ref." := '';
                SalesRegister."Due date" := lSalesCrMemoHdr."Due Date";
                SalesRegister."Source Type" := SalesRegister."Source Type"::Customer;
                SalesRegister."Source No." := "Sell-to Customer No.";
                SalesRegister."Source Name" := Cust.Name;
                SalesRegister."Source City" := Cust.City;
                SalesRegister."Source State Code" := Cust."State Code";
                IF recState.GET(Cust."State Code") THEN BEGIN
                    SalesRegister."Source State Name" := recState.Description;
                END;
                SalesRegister.Remarks := '';
                SalesRegister."Location GST Registration No." := lSalesCrMemoHdr."Location GST Reg. No.";
                // SalesRegister."Gen. Journal Template Code" := lSalesCrMemoHdr."Gen. Journal Template Code";
                SalesRegister."Customer Posting Group" := lSalesCrMemoHdr."Customer Posting Group";
                SalesRegister."CPG Desc" := CPG.Description;
                SalesRegister."Customer Price Group" := lSalesCrMemoHdr."Customer Price Group";
                SalesRegister."Customer Price Group Name" := recCustPriceGroup.Description;
                SalesRegister."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                GBPG.GET("Gen. Bus. Posting Group");
                SalesRegister."GBPG Description" := GBPG.Description;
                GPPG.GET("Gen. Prod. Posting Group");
                SalesRegister."GPPG Description" := GPPG.Description;
                SalesRegister."Country/Region Code" := Cust."Country/Region Code";
                IF Cust."Country/Region Code" <> '' THEN BEGIN
                    Country.GET(Cust."Country/Region Code");
                    SalesRegister."Country/Region Name" := Country.Name;
                END;
                SalesRegister."Master Salesperson Code" := Cust."Salesperson Code";
                SalesRegister."Master Cust. Posting Group" := Cust."Customer Posting Group";
                IF Cust."Salesperson Code" <> '' THEN BEGIN
                    IF Salesperson.GET(Cust."Salesperson Code") THEN;
                    SalesRegister."Master Salesperson Name" := Salesperson.Name;
                END;
                SalesRegister."Territory Dimension Name" := DimValue.Name;
                SalesRegister."Outward Location Code" := "Location Code";
                SalesRegister."Outward State Code" := Loc."State Code";
                IF recState.GET(Loc."State Code") THEN BEGIN
                    SalesRegister."Outward State Name" := recState.Description;
                END;
                intDay := DATE2DMY(lSalesCrMemoHdr."Posting Date", 1);
                intMonth := DATE2DMY(lSalesCrMemoHdr."Posting Date", 2);
                intYear := DATE2DMY(lSalesCrMemoHdr."Posting Date", 3);
                CASE intMonth OF
                    1:
                        cdMonthName := 'JAN';
                    2:
                        cdMonthName := 'FEB';
                    3:
                        cdMonthName := 'MAR';
                    4:
                        cdMonthName := 'APR';
                    5:
                        cdMonthName := 'MAY';
                    6:
                        cdMonthName := 'JUN';
                    7:
                        cdMonthName := 'JUL';
                    8:
                        cdMonthName := 'AUG';
                    9:
                        cdMonthName := 'SEP';
                    10:
                        cdMonthName := 'OCT';
                    11:
                        cdMonthName := 'NOV';
                    12:
                        cdMonthName := 'DEC';
                END;
                IF intMonth < 4 THEN BEGIN
                    cdFinYear := FORMAT(intYear - 1) + '-' + FORMAT(intYear - 2000);
                    cdQuarter := 'Q4';
                END
                ELSE
                    IF intMonth < 7 THEN BEGIN
                        cdFinYear := FORMAT(intYear) + '-' + FORMAT(intYear - 2000 + 1);
                        cdQuarter := 'Q1';
                    END
                    ELSE
                        IF intMonth < 10 THEN BEGIN
                            cdFinYear := FORMAT(intYear) + '-' + FORMAT(intYear - 2000 + 1);
                            cdQuarter := 'Q2';
                        END
                        ELSE BEGIN
                            cdFinYear := FORMAT(intYear) + '-' + FORMAT(intYear - 2000 + 1);
                            cdQuarter := 'Q3';
                        END;
                SalesRegister."Fin. Year" := cdFinYear;
                SalesRegister.Quarter := cdQuarter;
                SalesRegister."Month Name" := cdMonthName;
                SalesRegister.Year := intYear;
                SalesRegister.Month := intMonth;
                SalesRegister.Day := intDay;
                SalesRegister.Type := Type;
                SalesRegister."No." := "No.";
                SalesRegister."Variant Code" := "Variant Code";
                SalesRegister."Item Description" := Description;
                SalesRegister."Gross Weight" := Item."Gross Weight";
                SalesRegister."Net Weight" := Item."Net Weight";
                SalesRegister."MRP Price" := Item."Unit Price";
                SalesRegister."Qty. in KG" := lSalesCrMemoLine.Quantity * SalesRegister."Net Weight";//RK 09May22
                SalesRegister."Unit of Measure" := "Unit of Measure Code";
                IF SalesRegister."Variant Code" <> '' THEN BEGIN
                    ItemVariant.GET(SalesRegister."No.", SalesRegister."Variant Code");
                    SalesRegister."Variant Description" := ItemVariant."Description 2";
                END;
                IF (Type = Type::Item) AND ("No." <> '') THEN BEGIN
                    Item.GET("No.");
                    SalesRegister."Inventory Posting Group" := Item."Inventory Posting Group";
                    SalesRegister."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                    SalesRegister."Item Category Code" := Item."Item Category Code";
                    // SalesRegister."Product Group Code" := Item."LSC Retail Product Code";//RK 09May22
                    IF Item."Item Category Code" <> '' THEN BEGIN
                        ICC.GET(Item."Item Category Code");
                        SalesRegister."Item Category Description" := ICC.Description;
                    END;
                    //RK 09May22 Begin
                    recItemAttributeValueMapping.Reset();
                    recItemAttributeValueMapping.SetRange("Table ID", 27);
                    recItemAttributeValueMapping.SetRange("No.", Item."No.");
                    recItemAttributeValueMapping.SetRange("Item Attribute ID", 1);
                    if recItemAttributeValueMapping.FindFirst() then begin
                        recItemAttributeValue.Reset();
                        recItemAttributeValue.SetRange(id, recItemAttributeValueMapping."Item Attribute Value ID");
                        if recItemAttributeValue.FindFirst() then
                            SalesRegister.Brand := recItemAttributeValue.Value;
                        //RK End

                    end;

                END;
                //if lSalesCrMemoLine."Line No." = 10000 then begin
                recCustLedgEntry.Reset();
                recCustLedgEntry.SetRange("Document No.", lSalesCrMemoHdr."No.");
                if recCustLedgEntry.FindFirst() then
                    recCustLedgEntry.CalcFields("Amount (LCY)");
                SalesRegister."Total Bill Amount" := recCustLedgEntry."Amount (LCY)";
                //end;
                SalesRegister.Quantity := -Quantity;
                SalesRegister."Unit Price" := -"Unit Price";
                SalesRegister.Amount := -(Quantity * "Unit Price");
                SalesRegister."Line Discount Amount" := -"Line Discount Amount";
                SalesRegister."Line Amount" := -"Line Amount";
                SalesRegister."TDS Base Amount" := 0;
                SalesRegister."TDS Amount" := 0;

                recDGLE.Reset();
                recDGLE.SetRange("No.", lSalesCrMemoLine."Document No.");
                recDGLE.SetRange("Document Line No.", lSalesCrMemoLine."Line No.");
                recDGLE.SetRange("GST Component Code", 'CESS');
                if recDGLE.FindFirst() then begin
                    SalesRegister."Cess Amount" := recDGLE."GST Amount";
                end;

                SalesRegister."eCESS on TDS Amount" := 0;
                SalesRegister."TDS Nature of Deduction" := '';
                SalesRegister."TDS %" := 0;
                SalesRegister."eCESS % on TDS" := 0;
                SalesRegister."Tax Group Code" := "Tax Group Code";
                SalesRegister."Tax Area" := "Tax Area Code";
                IF "Tax Area Code" <> '' THEN BEGIN
                    TaxAreaLine.RESET;
                    TaxAreaLine.SETRANGE("Tax Area", "Tax Area Code");
                    TaxAreaLine.FIND('-');
                    SalesRegister."Tax Jurisdiction Code" := TaxAreaLine."Tax Jurisdiction Code";
                    TaxJuris.GET(TaxAreaLine."Tax Jurisdiction Code");
                    AddTaxAmt := 0;
                    TaxAmt := 0;
                    TaxPer := 0;
                    AddTaxPer := 0;
                    IF SalesRegister."Tax Type" = SalesRegister."Tax Type"::CST THEN
                        SalesRegister."CST Amount" := TaxAmt
                    ELSE
                        SalesRegister."VAT Amount" := TaxAmt;
                    SalesRegister."Tax %" := TaxPer;
                END;
                IF SalesRegister."Tax Type" = SalesRegister."Tax Type"::VAT THEN SalesRegister."Tax Type" := SalesRegister."Tax Type"::VAT;
                SalesRegister."Line Discount %" := "Line Discount %";
                SalesRegister."Applies-to Doc. Type" := lSalesCrMemoHdr."Applies-to Doc. Type";
                SalesRegister."Applies-to Doc. No." := lSalesCrMemoHdr."Applies-to Doc. No.";
                SalesRegister."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                SalesRegister."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                SalesRegister."No. Series" := lSalesCrMemoHdr."No. Series";
                //SalesRegister."Net Amount" := -Amount;

                if "Sales Cr.Memo Line".Exempted = true then begin
                    SalesRegister."GST Base Amount" := -1 * "Sales Cr.Memo Line"."Line Amount";
                    SalesRegister."GST Group" := "Sales Cr.Memo Line"."GST Group Code";
                end;

                decFreight := 0;
                decInsurance := 0;
                decTD := 0;
                decCD := 0;
                decSD := 0;
                decSSD := 0;
                SalesRegister.Freight := ABS(decFreight);
                SalesRegister.Insurance := ABS(decInsurance);
                SalesRegister."Trade Discount" := ABS(decTD);
                SalesRegister."Cash Discount" := ABS(decCD);
                SalesRegister."Scheme Discount" := ABS(decSD);
                recDtGSTLedg.RESET();
                recDtGSTLedg.SETRANGE("Document No.", "Sales Cr.Memo Line"."Document No.");
                recDtGSTLedg.SETRANGE("Document Line No.", "Sales Cr.Memo Line"."Line No.");
                recDtGSTLedg.SETRANGE("GST Component Code", 'CGST');
                IF recDtGSTLedg.FIND('-') THEN BEGIN
                    SalesRegister."CGST %" := ABS(recDtGSTLedg."GST %");
                    SalesRegister."CGST Amount" := -1 * (recDtGSTLedg."GST Amount");
                    SalesRegister."GST Base Amount" := -1 * (recDtGSTLedg."GST Base Amount");
                    SalesRegister."GST Group" := recDtGSTLedg."GST Group Code";
                    SalesRegister."HSN/SAC Code" := recDtGSTLedg."HSN/SAC Code";
                    SalesRegister."Location Reg. No." := recDtGSTLedg."Location  Reg. No.";
                    SalesRegister."Customer Reg. No." := recDtGSTLedg."Buyer/Seller Reg. No.";
                    SalesRegister."GST Place of Supply" := FORMAT(recDtGSTLedg."GST Place of Supply");
                END;

                recDtGSTLedg.RESET();
                recDtGSTLedg.SETRANGE("Document No.", "Sales Cr.Memo Line"."Document No.");
                recDtGSTLedg.SETRANGE("Document Line No.", "Sales Cr.Memo Line"."Line No.");
                recDtGSTLedg.SETRANGE("GST Component Code", 'SGST');
                IF recDtGSTLedg.FIND('-') THEN BEGIN
                    SalesRegister."SGST %" := ABS(recDtGSTLedg."GST %");
                    SalesRegister."SGST Amount" := -1 * (recDtGSTLedg."GST Amount");
                    SalesRegister."GST Base Amount" := -1 * (recDtGSTLedg."GST Base Amount");
                    SalesRegister."GST Group" := recDtGSTLedg."GST Group Code";
                    SalesRegister."HSN/SAC Code" := recDtGSTLedg."HSN/SAC Code";
                    SalesRegister."Location Reg. No." := recDtGSTLedg."Location  Reg. No.";
                    SalesRegister."Customer Reg. No." := recDtGSTLedg."Buyer/Seller Reg. No.";
                    SalesRegister."GST Place of Supply" := FORMAT(recDtGSTLedg."GST Place of Supply");
                END;
                recDtGSTLedg.RESET();
                recDtGSTLedg.SETRANGE("Document No.", "Sales Cr.Memo Line"."Document No.");
                recDtGSTLedg.SETRANGE("Document Line No.", "Sales Cr.Memo Line"."Line No.");
                recDtGSTLedg.SETRANGE("GST Component Code", 'IGST');
                IF recDtGSTLedg.FIND('-') THEN BEGIN
                    SalesRegister."IGST %" := ABS(recDtGSTLedg."GST %");
                    SalesRegister."IGST Amount" := -1 * (recDtGSTLedg."GST Amount");
                    SalesRegister."GST Base Amount" := -1 * (recDtGSTLedg."GST Base Amount");
                    SalesRegister."GST Group" := recDtGSTLedg."GST Group Code";
                    SalesRegister."HSN/SAC Code" := recDtGSTLedg."HSN/SAC Code";
                    SalesRegister."Location Reg. No." := recDtGSTLedg."Location  Reg. No.";
                    SalesRegister."Customer Reg. No." := recDtGSTLedg."Buyer/Seller Reg. No.";
                    SalesRegister."GST Place of Supply" := FORMAT(recDtGSTLedg."GST Place of Supply");
                END;
                SalesRegister."Total GST Amount" := SalesRegister."CGST Amount" + SalesRegister."SGST Amount" + SalesRegister."IGST Amount" + SalesRegister."Cess Amount";
                //SalesRegister."Net Amount" := (SalesRegister.Amount + SalesRegister."Total GST Amount") - lSalesCrMemoLine."Line Discount Amount";
                SalesRegister."Net Amount" := -(lSalesCrMemoLine."Line Amount" + ABS(SalesRegister."Total GST Amount"));

                if SalesRegister.Type = SalesRegister.Type::Item then begin
                    Item.Get("No.");
                    if SalesRegister."HSN/SAC Code" = '' then
                        SalesRegister."HSN/SAC Code" := Item."HSN/SAC Code";
                end;

                IF ("Gen. Prod. Posting Group" <> '') AND ("Gen. Bus. Posting Group" <> '') THEN BEGIN
                    IF GPS.GET("Gen. Bus. Posting Group", "Gen. Prod. Posting Group") THEN BEGIN
                        SalesRegister."Revenue Account Code" := GPS."Sales Account";
                        IF GLAcc.GET(GPS."Sales Account") THEN SalesRegister."Revenue Account Description" := GLAcc.Name;
                    END;
                END;
                IF (lSalesCrMemoHdr."Customer Posting Group" <> '') THEN BEGIN
                    CPG.GET(lSalesCrMemoHdr."Customer Posting Group");
                    SalesRegister."Receivable Account Code" := CPG."Receivables Account";
                    IF GLAcc.GET(CPG."Receivables Account") THEN SalesRegister."Receivable Account Description" := GLAcc.Name;
                END;

                recVE.Reset();
                recVE.SetRange("Document No.", lSalesCrMemoLine."Document No.");
                recVE.SetRange("Document Line No.", lSalesCrMemoLine."Line No.");
                if recVE.FindFirst() then begin
                    recILE.Reset();
                    recILE.SetRange("Entry No.", recVE."Item Ledger Entry No.");
                    if recILE.FindFirst() then begin
                        SalesRegister."Lot No." := recILE."Lot No.";
                        SalesRegister."Expiry Date" := recILE."Expiration Date";
                    end;
                end;

                SalesRegister.INSERT;
            END;
            "Exported to Sales Register" := TRUE;
            MODIFY;
        END;
    end;








    Procedure InsertTransShpt(VAR lTransShptHdr: Record "Transfer Shipment Header")
    Begin
        NetAmt := 0;
        lTransShptLine.RESET;
        lTransShptLine.SETRANGE("Document No.", lTransShptHdr."No.");
        lTransShptLine.SETFILTER("Item No.", '<>%1', '');
        lTransShptLine.SetFilter(Quantity, '<>%1', 0);
        lTransShptLine.SETRANGE("Exported to Sales Register", FALSE);
        IF lTransShptLine.FIND('-') THEN BEGIN
            REPEAT
                WITH lTransShptLine DO BEGIN
                    Loc.GET("Transfer-from Code");
                    Loc2.GET("Transfer-to Code");
                    SalesRegister.INIT;
                    SalesRegisterNew.Reset();
                    SalesRegisterNew.SetRange("Document Type", SalesRegisterNew."Document Type"::"Transfer Shpt.");
                    if SalesRegisterNew.FindLast() then
                        SalesRegister."Transaction No." := SalesRegisterNew."Transaction No." + 1
                    else
                        SalesRegister."Transaction No." := 1;
                    SalesRegister."Document Type" := SalesRegister."Document Type"::"Transfer Shpt.";
                    SalesRegister."Source Document No." := "Document No.";
                    SalesRegister."Source Line No." := "Line No.";
                    SalesRegister."Posting Date" := lTransShptHdr."Posting Date";
                    SalesRegister."Order No." := lTransShptHdr."Transfer Order No.";
                    SalesRegister."Source Line Description" := Description;
                    SalesRegister."Source Type" := SalesRegister."Source Type"::Location;
                    SalesRegister."Source No." := Loc2.Code;
                    SalesRegister."Source Name" := Loc2.Name;
                    SalesRegister."Source City" := Loc2.City;
                    SalesRegister."LR/RR No." := lTransShptHdr."LR/RR No.";
                    SalesRegister."LR/RR Date" := lTransShptHdr."LR/RR Date";
                    SalesRegister."External Document No." := lTransShptHdr."External Document No.";
                    SalesRegister."Global Dimension 1 Code" := lTransShptHdr."Shortcut Dimension 1 Code";
                    SalesRegister."Customer Price Group Name" := recCustPriceGroup.Description;
                    SalesRegister.Remarks := FORMAT(Remarks);
                    if recLocation.Get(lTransShptHdr."Transfer-to Code") then
                        SalesRegister."Location GST Registration No." := recLocation."GST Registration No.";
                    SalesRegister."Shipping Address" := lTransShptHdr."Transfer-from Address" + ' ' + lTransShptHdr."Transfer-from Address 2";
                    IF GPPG.GET("Gen. Prod. Posting Group") THEN;
                    SalesRegister."Country/Region Code" := Loc2."Country/Region Code";
                    IF Loc2."Country/Region Code" <> '' THEN BEGIN
                        Country.GET(Loc2."Country/Region Code");
                        SalesRegister."Country/Region Name" := Country.Name;
                    END;
                    SalesRegister."Outward Location Code" := Loc.Code;
                    intDay := DATE2DMY(lTransShptHdr."Posting Date", 1);
                    intMonth := DATE2DMY(lTransShptHdr."Posting Date", 2);
                    intYear := DATE2DMY(lTransShptHdr."Posting Date", 3);
                    CASE intMonth OF
                        1:
                            cdMonthName := 'JAN';
                        2:
                            cdMonthName := 'FEB';
                        3:
                            cdMonthName := 'MAR';
                        4:
                            cdMonthName := 'APR';
                        5:
                            cdMonthName := 'MAY';
                        6:
                            cdMonthName := 'JUN';
                        7:
                            cdMonthName := 'JUL';
                        8:
                            cdMonthName := 'AUG';
                        9:
                            cdMonthName := 'SEP';
                        10:
                            cdMonthName := 'OCT';
                        11:
                            cdMonthName := 'NOV';
                        12:
                            cdMonthName := 'DEC';
                    END;
                    IF intMonth < 4 THEN BEGIN
                        cdFinYear := FORMAT(intYear - 1) + '-' + FORMAT(intYear - 2000);
                        cdQuarter := 'Q4';
                    END
                    ELSE
                        IF intMonth < 7 THEN BEGIN
                            cdFinYear := FORMAT(intYear) + '-' + FORMAT(intYear - 2000 + 1);
                            cdQuarter := 'Q1';
                        END
                        ELSE
                            IF intMonth < 10 THEN BEGIN
                                cdFinYear := FORMAT(intYear) + '-' + FORMAT(intYear - 2000 + 1);
                                cdQuarter := 'Q2';
                            END
                            ELSE BEGIN
                                cdFinYear := FORMAT(intYear) + '-' + FORMAT(intYear - 2000 + 1);
                                cdQuarter := 'Q3';
                            END;
                    SalesRegister."Fin. Year" := cdFinYear;
                    SalesRegister.Quarter := cdQuarter;
                    SalesRegister."Month Name" := cdMonthName;
                    SalesRegister.Year := intYear;
                    SalesRegister.Month := intMonth;
                    SalesRegister.Day := intDay;
                    SalesRegister."No." := "Item No.";
                    SalesRegister."Item Description" := Description;
                    SalesRegister."Gross Weight" := Item."Gross Weight";
                    SalesRegister."Net Weight" := Item."Net Weight";
                    SalesRegister."MRP Price" := Item."Unit Price";
                    SalesRegister."Unit of Measure" := "Unit of Measure Code";
                    IF ("Item No." <> '') THEN BEGIN
                        Item.GET("Item No.");
                        SalesRegister."Inventory Posting Group" := Item."Inventory Posting Group";
                        SalesRegister."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                        SalesRegister."Item Category Code" := Item."Item Category Code";
                        IF Item."Item Category Code" <> '' THEN BEGIN
                            ICC.GET(Item."Item Category Code");
                            SalesRegister."Item Category Description" := ICC.Description;
                        END;
                    END;
                    SalesRegister.Quantity := Quantity;
                    SalesRegister."Unit Price" := "Unit Price";
                    SalesRegister.Amount := Quantity * "Unit Price";
                    decFreight := 0;
                    decInsurance := 0;
                    decTD := 0;
                    decCD := 0;
                    decSD := 0;
                    decBD := 0;
                    SalesRegister.Freight := ABS(decFreight);
                    SalesRegister.Insurance := ABS(decInsurance);
                    SalesRegister."Trade Discount" := ABS(decTD);
                    SalesRegister."Cash Discount" := ABS(decCD);
                    SalesRegister."Scheme Discount" := ABS(decSD);

                    Item.Get("Item No.");
                    if SalesRegister."HSN/SAC Code" = '' then
                        SalesRegister."HSN/SAC Code" := Item."HSN/SAC Code";

                    recVE.Reset();
                    recVE.SetRange("Document No.", lTransShptLine."Document No.");
                    recVE.SetRange("Document Line No.", lTransShptLine."Line No.");
                    if recVE.FindFirst() then begin
                        recILE.Reset();
                        recILE.SetRange("Entry No.", recVE."Item Ledger Entry No.");
                        if recILE.FindFirst() then begin
                            SalesRegister."Lot No." := recILE."Lot No.";
                            SalesRegister."Expiry Date" := recILE."Expiration Date";
                        end;
                    end;

                END;
                SalesRegister.INSERT;
                lTransShptLine."Exported to Sales Register" := TRUE;
                lTransShptLine.MODIFY;
            UNTIL lTransShptLine.NEXT = 0;
        END;
    end;

    trigger OnInitReport()
    Begin
        blnRunSale := TRUE;
        blnRunSaleCr := TRUE;
        blnRunTransShpt := TRUE;
        blnRunTransSalesEntry := true;
    End;

    trigger OnPreReport()
    begin
        IF blnRegenerateSales THEN BEGIN
            SalesRegister.RESET;
            SalesRegister.SETRANGE("Document Type", SalesRegister."Document Type"::"Sales Invoice");
            SalesRegister.DELETEALL;
            lSalesInvLine.RESET;
            lSalesInvLine.MODIFYALL("Exported to Sales Register", FALSE);
        END;
        IF blnRegenerateSalesCr THEN BEGIN
            SalesRegister.RESET;
            SalesRegister.SETRANGE("Document Type", SalesRegister."Document Type"::"Sales Cr. Memo");
            SalesRegister.DELETEALL;
            lSalesCrMemoLine.RESET;
            lSalesCrMemoLine.MODIFYALL("Exported to Sales Register", FALSE);
        END;
        IF blnRegenerateTransShpt THEN BEGIN
            SalesRegister.RESET;
            SalesRegister.SETFILTER("Document Type", '%1|%2', SalesRegister."Document Type"::"Transfer Shpt.", SalesRegister."Document Type"::"Transfer Rcpt.");
            SalesRegister.DELETEALL;
            lTransShptLine.RESET;
            lTransShptLine.MODIFYALL("Exported to Sales Register", FALSE);
        END;
    end;

    trigger OnPostReport()
    Begin
        MESSAGE('Sales register updated successfully');
    End;

    Var
        recVE: Record "Value Entry";
        recILE: Record "Item Ledger Entry";
        SalesRegister: Record "Sales/Transfer Register";
        Cust: Record Customer;
        Loc: Record Location;
        Item: Record Item;
        GenJnlTemplate: Record "Gen. Journal Template";
        blnRegenerateSales: Boolean;
        ItemVariant: Record "Item Variant";
        CPG: Record "Customer Posting Group";
        SalesRegister1: Record "Sales/Transfer Register";
        Loc1: Record Location;
        AddTaxAmt: Decimal;
        TaxAmt: Decimal;
        TaxPer: Decimal;
        AddTaxPer: Decimal;
        Territory: Record Territory;
        Salesperson: Record "Salesperson/Purchaser";
        Country: Record "Country/Region";
        GBPG: Record "Gen. Business Posting Group";
        ICC: Record "Item Category";
        Window: Dialog;
        TotalRec: Integer;
        RemainingStatus: Integer;
        RowNo: Integer;
        GLEntry: Record "G/L Entry";
        TaxAreaLine: Record "Tax Area Line";
        TaxJuris: Record "Tax Jurisdiction";
        GPS: Record "General Posting Setup";
        GLAcc: Record "G/L Account";
        blnRegenerateSalesCr: Boolean;
        blnRegenerateTransShpt: Boolean;
        intDay: Integer;
        intMonth: Integer;
        intYear: Integer;
        cdFinYear: Code[7];
        cdMonthName: Code[3];
        cdQuarter: Code[2];
        TaxAreaLine2: Record "Tax Area Line";
        recState: Record State;
        DimValue: Record "Dimension Value";
        GPPG: Record "Gen. Product Posting Group";
        FrtAmt: Decimal;
        DiscAmt: Decimal;
        OtherCharges: Decimal;
        NetAmt: Decimal;
        blnRunSale: Boolean;
        blnRunSaleCr: Boolean;
        blnRunTransShpt: Boolean;
        recCustPriceGroup: Record "Customer Price Group";
        decTD: Decimal;
        decSD: Decimal;
        decCD: Decimal;
        decBD: Decimal;
        decFreight: Decimal;
        decOffSeason: Decimal;
        Loc2: Record Location;
        lSalesInvLine: Record "Sales Invoice Line";
        lSalesCrMemoLine: Record "Sales Cr.Memo Line";
        lTransShptLine: Record "Transfer Shipment Line";
        decInsurance: Decimal;
        decSSD: Decimal;
        recDtGSTLedg: Record "Detailed GST Ledger Entry";
        decTrLoDisc: Decimal;
        decFOCDisc: Decimal;
        recSalesInvHead: Record "Sales Invoice Header";
        recSaleCrHead: Record "Sales Cr.Memo Header";
        recLocation: Record Location;
        recItemAttributeValue: Record "Item Attribute Value";
        recItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        recTCSEntry: Record "TCS Entry";
        recCustLedgEntry: Record "Cust. Ledger Entry";
        recDefaultDimension: Record "Default Dimension";
        recCustDiscGroup: Record "Customer Discount Group";
        recPostedComment: Record "Sales Comment Line";
        txtPostedComment: Text;
        recEWayBillEinvoice: Record "E-Invoice & E-Way Bill";
        recDGLE: Record "Detailed GST Ledger Entry";
        recReferenceInv: Record "Reference Invoice No.";
        recSalesInvHeader: Record "Sales Invoice Header";
        blnRunTransSalesEntry: Boolean;
        blnRegenerateTransSalesLine: Boolean;
        SalesRegisterNew: Record "Sales/Transfer Register";
        recResource: Record Resource;
        Exempted: Boolean;
        exem: Text;
}
