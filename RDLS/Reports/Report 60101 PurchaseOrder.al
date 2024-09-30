report 60101 PurchaseOrder
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'RDLS\Layouts\Report 60101 PurchaseOrder.rdl';
    UseRequestPage = true;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            RequestFilterFields = "No.";

            dataitem(CopyLoop; "Integer")  // to Add multiple Page in Report
            {
                DataItemTableView = SORTING(Number) ORDER(Ascending);

                column(TenderType; TenderType) { } // for Billtype : Orignal,duplicte,Triplicate
                column(PageNo; PageNo) { }

                dataitem(PageLoop; "Integer") // to print the data on the pages
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

                    column(CompanyLogo; CompanyInfo.Picture) { }
                    column(CompanyName; CompanyInfoDetails[1]) { }
                    column(CompanyAddress; CompanyInfoDetails[2]) { }
                    column(CompanyPostcode; CompanyInfoDetails[3]) { }
                    column(CompanyCity; CompanyInfoDetails[4]) { }
                    column(CompanyStateCode; CompanyInfoDetails[5]) { }
                    column(CompanyStateName; CompanyInfoDetails[6]) { }
                    column(CompanyCountry; CompanyInfoDetails[8]) { }
                    column(CompanyGSTNo; CompanyInfoDetails[9]) { }
                    column(CompanyPanNo; CompanyInfoDetails[10]) { }
                    column(Companyphone; CompanyInfoDetails[11]) { }
                    column(companyemail; CompanyInfoDetails[12]) { }


                    column(Pay2VendorNo; PayToDetails[10]) { }
                    column(Pay2Name; "Purchase Header"."Pay-to Name") { }
                    column(Pay2Address; "Purchase Header"."Pay-to Address") { }
                    column(Pay2Post_Code; "Purchase Header"."Pay-to Post Code") { }
                    column(Pay2City; "Purchase Header"."Pay-to City") { }
                    column(Pay2State_Code; "Purchase Header".State) { }
                    column(VendorGST; PayToDetails[11]) { }
                    column(GST_Pay2State_Code; PayToDetails[7]) { }
                    column(GST_Pay2State_Name; PayToDetails[6]) { }
                    column(Pay2Country_Region_Code; "Purchase Header"."Pay-to Country/Region Code") { }

                    column(Ship2Name; "Purchase Header"."Ship-to Name") { }
                    column(Ship2Address; "Purchase Header"."Ship-to Address") { }
                    column(Ship2Post_Code; "Purchase Header"."Ship-to Post Code") { }
                    column(Ship2City; "Purchase Header"."Ship-to City") { }
                    column(GST_Ship2State_Code; "Purchase Header"."Ship-to Code") { }
                    column(Ship2Country_Region_Code; "Purchase Header"."Ship-to Country/Region Code") { }


                    column(DocNo; "Purchase Header"."No.") { } // Document No.
                    column(Posting_Date; Format("Purchase Header"."Posting Date", 0, 0)) { }
                    column(Document_Date; Format("Purchase Header"."Document Date", 0, 0)) { }

                    dataitem("Purchase Line"; "Purchase Line")
                    {
                        DataItemLinkReference = "Purchase Header";
                        DataItemLink = "Document No." = field("No.");

                        column(SNo; SNo) { }
                        column(ItemNo; "No.") { } // Item No.
                        column(HSN_SAC_Code; "HSN/SAC Code") { }
                        column(Description; Description) { }
                        column(UOM; "Unit of Measure") { }
                        column(Quantity; Quantity) { }
                        column(Unit_Cost; "Unit Cost") { }
                        column(Amount; Amount) { }
                        column(Line_Discount_Percent; "Line Discount %") { }
                        column(Line_Discount_Amount; "Line Discount Amount") { }
                        column(GSTRate; GSTRate) { }
                        column(IGST; IGST) { }
                        column(IGSTRate; IGSTRate) { }
                        column(CGST; CGST) { }
                        column(CGSTRate; CGSTRate) { }
                        column(SGST; SGST) { }
                        column(SGSTRate; SGSTRate) { }
                        column(NetLineAmount; NetLineAmount) { }
                        column(TotalAmount; TotalAmount) { }
                        column(TotalGSTTaxes; TotalGSTTaxes) { }
                        column(GrandTotal; GrandTotal) { }

                        // Purchase Line trigger OnPreDataItem() to intialize variable
                        trigger OnPreDataItem()
                        begin
                            SNo := 0;
                            TotalAmount := 0;
                            TotalGSTTaxes := 0;
                            GrandTotal := 0;

                            Calculate_Total_Amount_and_Taxes();

                        end;

                        // Purchase Line trigger OnAfterGetRecord
                        trigger OnAfterGetRecord()
                        begin
                            SNo += 1;

                            // GST Calcucation
                            SGST := 0;
                            IGST := 0;
                            CGST := 0;
                            UTGST := 0;
                            GSTRate := 0;
                            SGSTRate := 0;
                            IGSTRate := 0;
                            CGSTRate := 0;
                            UTGSTRate := 0;
                            if ("Purchase Line".Type <> "Purchase Line".Type::" ") then BEGIN
                                j := 1;
                                TaxTrnasactionValue.Reset();
                                TaxTrnasactionValue.SetRange("Tax Record ID", "Purchase Line".RecordId);
                                TaxTrnasactionValue.SetRange("Tax Type", 'GST');
                                TaxTrnasactionValue.SetRange("Value Type", TaxTrnasactionValue."Value Type"::COMPONENT);
                                TaxTrnasactionValue.SetFilter(Percent, '<>%1', 0);
                                if TaxTrnasactionValue.FindSet() then BEGIN
                                    repeat
                                        j := TaxTrnasactionValue."Value ID";
                                        GSTComponentCode[j] := TaxTrnasactionValue."Value ID";
                                        TaxTrnasactionValue1.Reset();
                                        TaxTrnasactionValue1.SetRange("Tax Record ID", "Purchase Line".RecordId);
                                        TaxTrnasactionValue1.SetRange("Tax Type", 'GST');
                                        TaxTrnasactionValue1.SetRange("Value Type", TaxTrnasactionValue."Value Type"::COMPONENT);
                                        TaxTrnasactionValue1.SetRange("Value ID", GSTComponentCode[j]);
                                        if TaxTrnasactionValue1.FindSet() then BEGIN
                                            repeat
                                                if j = 6 then begin
                                                    GSTRate := TaxTrnasactionValue1.Percent;
                                                    SGSTRate := TaxTrnasactionValue1.Percent;
                                                    SGST := TaxTrnasactionValue1.Amount;
                                                end;
                                                if j = 2 then begin
                                                    GSTRate := TaxTrnasactionValue1.Percent;
                                                    CGSTRate := TaxTrnasactionValue1.Percent;
                                                    CGST := TaxTrnasactionValue1.Amount;
                                                end;
                                                if j = 3 then begin
                                                    GSTRate := TaxTrnasactionValue1.Percent;
                                                    IGSTRate := TaxTrnasactionValue1.Percent;
                                                    IGST := TaxTrnasactionValue1.Amount;
                                                end;
                                                if j = 5 then begin
                                                    GSTRate := TaxTrnasactionValue1.Percent;
                                                    UTGSTRate := TaxTrnasactionValue1.Percent;
                                                    UTGST := TaxTrnasactionValue1.Amount;
                                                end;
                                            until TaxTrnasactionValue1.Next() = 0;
                                        END;
                                        j += 1;

                                    until TaxTrnasactionValue.Next() = 0;
                                END;

                            END;


                            NetLineAmount := 0;
                            RecPurchaseLine.Reset(); // Calculate Net Line Amount
                            RecPurchaseLine.SetRange("Document No.", "Purchase Header"."No.");
                            RecPurchaseLine.SetRange("Line No.", "Purchase Line"."Line No.");
                            if RecPurchaseLine.FindFirst() then begin
                                NetLineAmount := RecPurchaseLine.Amount + CGST + SGST + IGST;
                            end;

                        end;
                    }

                    // Header PageLoop OnAfterGetRecord trigger
                    trigger OnAfterGetRecord()
                    begin
                        if TenderType1 = TenderType1::" " then begin
                            if (Copyloop.Number = 1) then begin
                                TenderType := TenderType::Orignal;
                            end;
                            if (Copyloop.Number = 2) then begin
                                TenderType := TenderType::Duplicate;
                            end;
                            if (Copyloop.Number = 3) then begin
                                TenderType := TenderType::Triplicate;
                            end;
                            if (Copyloop.Number >= 4) then begin
                                TenderType := TenderType::Extra;
                            end;
                        end
                        else begin
                            TenderType := TenderType1;
                        end;
                    end;

                } // Pageloop End

                // CopyLoop OnPreDataItem trigger OnPreDataItem();
                trigger OnPreDataItem();
                begin
                    if Copies = 0 then
                        Copies := 1;

                    NoOfLoops := ABS(Copies);
                    //TenderType := TenderType::" ";
                    SETRANGE(Number, 1, NoOfLoops);
                    PageNo := 0;
                end;

                // CopyLoop OnAfterGetRecord trigger
                trigger OnAfterGetRecord();
                begin
                    PageNo += 1; // Increment Page No.
                end;

            } // Copyloop End

            // Purchase Header trigger OnPreDataItem() to filterdata
            trigger OnPreDataItem()
            begin
                if SetManualFilter then begin
                    "Purchase Header".SetFilter("No.", SetFilterValue);
                end;
            end;

            // Purchase Header trigger OnAfterGetRecord()
            trigger OnAfterGetRecord()
            begin

                DocNo := "Purchase Header"."No.";

                //Company Information Details
                CompanyInfoDetails[1] := CompanyInfo.Name;
                CompanyInfoDetails[2] := CompanyInfo.Address;
                CompanyInfoDetails[3] := CompanyInfo."Post Code";
                CompanyInfoDetails[4] := CompanyInfo.City;
                CompanyInfoDetails[5] := CompanyInfo."State Code";
                if RecState.Get(CompanyInfo."State Code") then
                    CompanyInfoDetails[6] := RecState.Description;
                CompanyInfoDetails[7] := CompanyInfo."Country/Region Code";
                if RecCountry.Get(CompanyInfo."Country/Region Code") then
                    CompanyInfoDetails[8] := RecCountry.Name;
                CompanyInfoDetails[9] := CompanyInfo."GST Registration No.";
                CompanyInfoDetails[10] := CompanyInfo."P.A.N. No.";
                CompanyInfoDetails[11] := CompanyInfo."Phone No.";
                CompanyInfoDetails[12] := CompanyInfo."E-Mail";

                // Bill To Details
                PayToDetails[1] := "Purchase Header"."Pay-to Name";
                PayToDetails[2] := "Purchase Header"."Pay-to Address";
                PayToDetails[3] := "Purchase Header"."Pay-to Post Code";
                PayToDetails[4] := "Purchase Header"."Pay-to City";
                PayToDetails[5] := "Purchase Header".state;
                if RecState.Get("Purchase Header"."Location State Code") then
                    PayToDetails[6] := RecState.Description;
                PayToDetails[7] := RecState."State Code (GST Reg. No.)";
                PayToDetails[8] := "Purchase Header"."Pay-to Country/Region Code";
                if RecCountry.Get("Purchase Header"."Pay-to Country/Region Code") then
                    PayToDetails[9] := RecCountry.Name;
                PayToDetails[10] := "Purchase Header"."Pay-to Vendor No.";
                if RecVendor.Get("Purchase Header"."Pay-to Vendor No.") then
                    PayToDetails[11] := RecVendor."GST Registration No.";
                PayToDetails[12] := "Purchase Header"."Pay-to Contact";
                PayToDetails[13] := "Purchase Header"."Pay-to Contact No.";


                // Ship To Details
                ShipToDetails[1] := "Purchase Header"."Ship-to Name";
                ShipToDetails[2] := "Purchase Header"."Ship-to Address";
                ShipToDetails[3] := "Purchase Header"."Ship-to Post Code";
                ShipToDetails[4] := "Purchase Header"."Ship-to City";
                ShipToDetails[5] := "Purchase Header"."Ship-to Code";
                if RecState.Get("Purchase Header"."Ship-to Code") then
                    ShipToDetails[6] := RecState.Description;
                ShipToDetails[7] := "Purchase Header"."Ship-to Country/Region Code";
                if RecCountry.Get("Purchase Header"."Ship-to Country/Region Code") then
                    ShipToDetails[8] := RecCountry.Name;
                ShipToDetails[9] := "Purchase Header"."Ship-to Contact";
            end;

        } // Purchase Header End
    }

    // Hide visibility in rdl
    //=IIf(Sum(Fields!Line_Discount_Amount.Value) = 0, True, False) 

    requestpage
    {
        layout
        {
            area(content)
            {
                group(General)
                {
                    field(PrintMultipleCopies; PrintMultipleCopies)
                    {
                        Caption = 'Print Multiple Copies';
                        ApplicationArea = All;
                    }
                    field(SetManualFilter; SetManualFilter)
                    {
                        Caption = 'Set Manual Filter';
                        ApplicationArea = All;
                    }
                    field(TenderType1; TenderType1)
                    {
                        Caption = 'Tender Type';
                        ApplicationArea = All;
                    }
                }
                group("Multiple Copies To Print")
                {
                    Visible = PrintMultipleCopies;
                    field("Copies To Print"; Copies)
                    {
                        Caption = 'No. of Copies';
                        ApplicationArea = All;
                    }
                }
                group("Manual Filter")
                {
                    Visible = SetManualFilter;
                    field(SetFilterValue; SetFilterValue)
                    {
                        Caption = 'SET FILTER';
                        TableRelation = "Purchase Header"."No.";
                        ApplicationArea = All;
                    }
                }
            }
        }
    }


    trigger OnPreReport()
    var
        GstRates: Record "Tax Rate";
    begin
        if CompanyInfo.Get() then
            CompanyInfo.CalcFields(Picture);
    end;

    procedure GetGSTAmount(PurchaseHeader: Record "Purchase Header") GSTAmount: Decimal
    var
        GSTStatsManagement: Codeunit "GST Stats Management";
        GSTPurchaseSubscribers: Codeunit "GST Purchase Subscribers";
    begin
        GSTPurchaseSubscribers.ReCalculateGST(PurchaseHeader."Document Type", PurchaseHeader."No.");
        GSTAmount := GSTStatsManagement.GetGstStatsAmount();
        GSTStatsManagement.ClearSessionVariable();
    end;


    local procedure Calculate_Total_Amount_and_Taxes()
    begin
        RecPurchaseLine.Reset(); // Calculate total Amount
        RecPurchaseLine.SetRange("Document No.", DocNo);
        if RecPurchaseLine.FindSet() then begin
            repeat
                TotalAmount += RecPurchaseLine.Amount;
            until RecPurchaseLine.Next() = 0;
        end;

        // Total GST Calcucation
        SGST := 0;
        IGST := 0;
        CGST := 0;
        UTGST := 0;
        GSTRate := 0;
        SGSTRate := 0;
        IGSTRate := 0;
        CGSTRate := 0;
        UTGSTRate := 0;
        RecPurchaseLine.Reset();
        RecPurchaseLine.SetRange("Document No.", DocNo);
        if RecPurchaseLine.FindSet() then BEGIN
            repeat
                TaxTrnasactionValue1.Reset();
                TaxTrnasactionValue1.SetRange("Tax Record ID", RecPurchaseLine.RecordId);
                TaxTrnasactionValue1.SetRange("Tax Type", 'GST');
                TaxTrnasactionValue1.SetRange("Value Type", TaxTrnasactionValue."Value Type"::COMPONENT);
                TaxTrnasactionValue1.SetFilter("Value ID", '=%1|=%2|=%3|=%4', 2, 3, 5, 6);
                if TaxTrnasactionValue1.FindFirst() then BEGIN
                    repeat
                        TotalGSTTaxes += TaxTrnasactionValue1.Amount;
                    until TaxTrnasactionValue1.Next() = 0;
                END;
            until RecPurchaseLine.Next() = 0;
        END;

        GrandTotal := TotalAmount + TotalGSTTaxes;

    end;


    var
        CompanyInfo: Record "company information";

        RecCountry: Record "Country/Region";
        RecState: Record State;
        RecLocation: Record Location;

        CompanyInfoDetails: array[15] of Text;
        BillToDetails: array[15] of Text;
        PayToDetails: array[15] of Text;
        ShipToDetails: array[15] of Text;

        ///////////////// GST Varuiables ////////////////////////////
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
        ////////////////////  Amount //////////////////
        TotalAmount: Decimal;
        TotalGSTTaxes: Decimal;
        GrandTotal: Decimal;
        NetLineAmount: Decimal;
        /////////////////// Important variables /////////////////////
        SNo: Integer;
        Copies: Integer;
        TenderType: Option " ",Orignal,Duplicate,Triplicate,Extra;
        TenderType1: Option " ",Orignal,Duplicate,Triplicate,Extra;
        NoOfLoops: Integer;
        PageNo: Integer;
        PrintMultipleCopies: Boolean;
        SetManualFilter: Boolean;

        SetFilterValue: Code[50];
        ///////////////////////////////////////////////////////////////
        RecPurchaseLine: Record "Purchase Line";

        DocNo: Code[30];
        RecVendor: Record vendor;
}