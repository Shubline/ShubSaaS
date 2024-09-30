report 60102 "PostedSalesInvoice"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'RDLS\Layouts\Report 60102 Posted Sales Invoice.rdl';
    UseRequestPage = true;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "No.";

            dataitem(CopyLoop; "Integer")  // to Add multiple Page in Report
            {
                DataItemTableView = SORTING(Number) ORDER(Ascending);

                column(TenderType; TenderType) { } // for Billtype : Orignal,duplicte,Triplicate
                column(PageNo; PageNo) { }
                column(Copies; Copies) { }

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


                    column(Bill2VendorNo; BillToDetails[10]) { }
                    column(Bill2Name; "Sales Invoice Header"."Bill-to Name") { }
                    column(Bill2Address; "Sales Invoice Header"."Bill-to Address") { }
                    column(Bill2Post_Code; "Sales Invoice Header"."Bill-to Post Code") { }
                    column(Bill2City; "Sales Invoice Header"."Bill-to City") { }
                    column(Bill2State_Code; "Sales Invoice Header".State) { }
                    column(VendorGST; BillToDetails[11]) { }
                    column(GST_Bill2State_Code; BillToDetails[7]) { }
                    column(GST_Bill2State_Name; BillToDetails[6]) { }
                    column(Bill2Country_Region_Code; "Sales Invoice Header"."Bill-to Country/Region Code") { }

                    column(Ship2Name; "Sales Invoice Header"."Ship-to Name") { }
                    column(Ship2Address; "Sales Invoice Header"."Ship-to Address") { }
                    column(Ship2Post_Code; "Sales Invoice Header"."Ship-to Post Code") { }
                    column(Ship2City; "Sales Invoice Header"."Ship-to City") { }
                    column(GST_Ship2State_Code; "Sales Invoice Header"."Ship-to Code") { }
                    column(Ship2Country_Region_Code; "Sales Invoice Header"."Ship-to Country/Region Code") { }


                    column(DocNo; "Sales Invoice Header"."No.") { } // Document No.
                    column(Posting_Date; Format("Sales Invoice Header"."Posting Date", 0, 0)) { }
                    column(Document_Date; Format("Sales Invoice Header"."Document Date", 0, 0)) { }

                    dataitem("Sales Invoice Line"; "Sales Invoice Line")
                    {
                        DataItemLinkReference = "Sales Invoice Header";
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

                        // Sales Invoice Line trigger OnPreDataItem() to intialize variable
                        trigger OnPreDataItem()
                        begin
                            SNo := 0;
                            TotalAmount := 0;
                            TotalGSTTaxes := 0;
                            GrandTotal := 0;
                        end;

                        // Sales Invoice Line trigger OnAfterGetRecord
                        trigger OnAfterGetRecord()
                        begin
                            SNo += 1;

                            // GST Calcucation
                            Gst.Reset();
                            Gst.SetRange("Entry Type", Gst."Entry Type"::"Initial Entry");
                            Gst.SetRange("Transaction Type", Gst."Transaction Type"::Sales);
                            Gst.SetRange("Document Type", Gst."Document Type"::Invoice);
                            Gst.SetRange("Document No.", "Sales Invoice Header"."No.");
                            if Gst.FindSet() then begin
                                repeat
                                    TotalGSTTaxes += ABS(Gst."GST Amount"); // Calculate total Taxes
                                until Gst.Next() = 0;
                            end;

                            // to get the gst rate and amount
                            Gst.SetRange("Document Line No.", "Sales Invoice Line"."Line No.");
                            if Gst.FindFirst() then begin
                                if (Gst."GST Component Code" = 'IGST') then begin
                                    IGST := ABS(Gst."GST Amount");
                                    IGSTRate := Gst."GST %";
                                    CGST := 0;
                                    CGSTRate := 0;
                                    SGST := 0;
                                    SGSTRate := 0;
                                end else begin
                                    CGST := ABS(Gst."GST Amount");
                                    CGSTRate := GST."GST %";
                                    SGST := ABS(Gst."GST Amount");
                                    SGSTRate := GST."GST %";
                                    IGST := 0;
                                    IGSTRate := 0;
                                end;
                            end;


                            NetLineAmount := 0;
                            RecSalesInvoiceLine.Reset(); // Calculate Net Line Amount
                            RecSalesInvoiceLine.SetRange("Document No.", "Sales Invoice Header"."No.");
                            RecSalesInvoiceLine.SetRange("Line No.", "Sales Invoice Line"."Line No.");
                            if RecSalesInvoiceLine.FindFirst() then begin
                                NetLineAmount := RecSalesInvoiceLine.Amount + CGST + SGST + IGST;
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
                    "Sales Invoice Header".SetFilter("No.", SetFilterValue);
                end;
            end;

            // Purchase Header trigger OnAfterGetRecord()
            trigger OnAfterGetRecord()
            begin

                DocNo := "Sales Invoice Header"."No.";

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
                BillToDetails[1] := "Sales Invoice Header"."Bill-to Name";
                BillToDetails[2] := "Sales Invoice Header"."Bill-to Address";
                BillToDetails[3] := "Sales Invoice Header"."Bill-to Post Code";
                BillToDetails[4] := "Sales Invoice Header"."Bill-to City";
                BillToDetails[5] := "Sales Invoice Header".state;
                if RecState.Get("Sales Invoice Header"."Location State Code") then
                    BillToDetails[6] := RecState.Description;
                BillToDetails[7] := RecState."State Code (GST Reg. No.)";
                BillToDetails[8] := "Sales Invoice Header"."Bill-to Country/Region Code";
                if RecCountry.Get("Sales Invoice Header"."Bill-to Country/Region Code") then
                    BillToDetails[9] := RecCountry.Name;
                BillToDetails[10] := "Sales Invoice Header"."Bill-to Customer No.";
                if RecCustomer.Get("Sales Invoice Header"."Bill-to Customer No.") then
                    BillToDetails[11] := RecCustomer."GST Registration No.";
                BillToDetails[12] := "Sales Invoice Header"."Bill-to Contact";
                BillToDetails[13] := "Sales Invoice Header"."Bill-to Contact No.";


                // Ship To Details
                ShipToDetails[1] := "Sales Invoice Header"."Ship-to Name";
                ShipToDetails[2] := "Sales Invoice Header"."Ship-to Address";
                ShipToDetails[3] := "Sales Invoice Header"."Ship-to Post Code";
                ShipToDetails[4] := "Sales Invoice Header"."Ship-to City";
                ShipToDetails[5] := "Sales Invoice Header"."Ship-to Code";
                if RecState.Get("Sales Invoice Header"."Ship-to Code") then
                    ShipToDetails[6] := RecState.Description;
                ShipToDetails[7] := "Sales Invoice Header"."Ship-to Country/Region Code";
                if RecCountry.Get("Sales Invoice Header"."Ship-to Country/Region Code") then
                    ShipToDetails[8] := RecCountry.Name;
                ShipToDetails[9] := "Sales Invoice Header"."Ship-to Contact";
            end;

        } // Purchase Header End
    }

    // Hide visibility in rdl
    //=IIf(Sum(Fields!Line_Discount_Amount.Value) = 0, True, False) 
    //=IIf(Fields!Line_Discount_Amount.Value = 0, True, False)

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
                        TableRelation = "Sales Invoice Header"."No.";
                        ApplicationArea = All;
                    }
                }
            }
        }
    }


    trigger OnPreReport()
    begin
        if CompanyInfo.Get() then
            CompanyInfo.CalcFields(Picture);
    end;

    procedure TotalCalcPostedDoc("Document No.": Code[40])
    var
        myInt: Integer;
    begin

        // Total AMT calculation
        RecSalesInvoiceLine.Reset();
        RecSalesInvoiceLine.SetRange("Document No.", "Document No.");
        if RecSalesInvoiceLine.FindFirst() then begin
            repeat
                TotalAmount += RecSalesInvoiceLine.Amount
            until RecSalesInvoiceLine.Next() = 0;
        end;

        // Total Taxes Gst Calculation
        Gst.Reset();
        Gst.SetRange("Entry Type", Gst."Entry Type"::"Initial Entry");
        Gst.SetRange("Transaction Type", Gst."Transaction Type"::Sales);
        Gst.SetRange("Document Type", Gst."Document Type"::Invoice);
        Gst.SetRange("Document No.", "Document No.");
        if Gst.FindSet() then begin
            repeat
                TotalGSTTaxes += ABS(Gst."GST Amount"); // Calculate total Taxes
            until Gst.Next() = 0;
        end;

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
        RecSalesInvoiceLine: Record "Sales Invoice Line";
        DocNo: Code[30];
        RecVendor: Record vendor;
        RecCustomer: Record Customer;
}