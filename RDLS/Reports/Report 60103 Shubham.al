report 60103 Shubham
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'RDLS\Layouts\Shubham.rdl';
    UseRequestPage = true;

    dataset
    {

        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "No.";

            dataitem(CopyLoop; "Integer")  // to Add multiple Page in Report
            {
                DataItemTableView = SORTING(Number) ORDER(Ascending);

                column(CopyText; CopyText) { } // for Billtype : Orignal,duplicte,Triplicate
                column(PageNo; PageNo) { }

                dataitem(PageLoop; "Integer") // to print the data on the pages
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

                    column(Company_InfoLogo; CompanyInfo.Picture) { }
                    column(Company_Name; CompanyInfoDetails[1]) { }
                    column(Company_Address; CompanyInfoDetails[2]) { }
                    column(Company_City; CompanyInfoDetails[4]) { }
                    column(Company_Post_code; CompanyInfoDetails[3]) { }
                    column(Company_Country; CompanyInfoDetails[8]) { }
                    column(Company_State_Code; CompanyInfoDetails[6]) { }


                    column(Bill_to_Name; "Sales Invoice Header"."Bill-to Name") { }
                    column(Bill_to_Address; "Sales Invoice Header"."Bill-to Address") { }
                    column(Bill_to_Post_Code; "Sales Invoice Header"."Bill-to Post Code") { }
                    column(Bill_to_City; "Sales Invoice Header"."Bill-to City") { }
                    column(GST_Bill_to_State_Code; "Sales Invoice Header"."GST Bill-to State Code") { }
                    column(Bill_to_Country_Region_Code; "Sales Invoice Header"."Bill-to Country/Region Code") { }

                    column(Ship_to_Name; "Sales Invoice Header"."Ship-to Name") { }
                    column(Ship_to_Address; "Sales Invoice Header"."Ship-to Address") { }
                    column(Ship_to_Post_Code; "Sales Invoice Header"."Ship-to Post Code") { }
                    column(Ship_to_City; "Sales Invoice Header"."Ship-to City") { }
                    column(GST_Ship_to_State_Code; "Sales Invoice Header"."GST Ship-to State Code") { }
                    column(Ship_to_Country_Region_Code; "Sales Invoice Header"."Ship-to Country/Region Code") { }

                    column(RecCountry_name; RecCountry."County Name") { }

                    column(No_; "Sales Invoice Header"."No.") { } // Document No.
                    column(Posting_Date; "Sales Invoice Header"."Posting Date") { }
                    column(Document_Date; "Sales Invoice Header"."Document Date") { }

                    dataitem("Sales Invoice Line"; "Sales Invoice Line")
                    {
                        DataItemLinkReference = "Sales Invoice Header";
                        DataItemLink = "Document No." = field("No.");

                        column(sno; sno) { }
                        column(Invoice_No; "No.") { } // Invoice No.
                        column(Description; Description) { }
                        column(Unit_of_Measure; "Unit of Measure") { }
                        column(Quantity; Quantity) { }
                        column(Unit_Price; "Unit Price") { }
                        column(Amount; Amount) { }
                        column(Line_Discount_Amount; "Line Discount Amount") { }

                        column(IGST; IGST) { }
                        column(IGSTRate; IGSTRate) { }
                        column(CGST; CGST) { }
                        column(CGSTRate; CGSTRate) { }
                        column(SGST; SGST) { }
                        column(SGSTRate; SGSTRate) { }
                        column(TotalAmount; TotalAmount) { }
                        column(TotalGSTTaxes; TotalGSTTaxes) { }
                        column(SubTotal; GrandTotal) { }

                        // Sales Invoice Line trigger OnPreDataItem() to intialize variable
                        trigger OnPreDataItem()
                        begin
                            sno := 0;
                            TotalAmount := 0;
                            TotalGSTTaxes := 0;
                            GrandTotal := 0;
                        end;

                        // Sales Invoice Line trigger OnAfterGetRecord
                        trigger OnAfterGetRecord()
                        begin
                            sno += 1;

                            SILINE.Reset(); // Calculate total Amount
                            SILINE.SetRange("Document No.", "Sales Invoice Header"."No.");
                            if SILINE.FindSet() then begin
                                repeat
                                    TotalAmount += SILINE.Amount;
                                until SILINE.Next() = 0;
                            end;

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
                            Gst.SetRange("No.", "Sales Invoice Line"."No.");
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

                            GrandTotal := TotalAmount + TotalGSTTaxes;
                        end;

                    }

                    // Header PageLoop OnAfterGetRecord trigger
                    trigger OnAfterGetRecord()
                    begin
                        if (Copyloop.Number = 1) then begin
                            CopyText := 'Original';
                        end;
                        if (Copyloop.Number = 2) then begin
                            CopyText := 'Duplicate';
                        end;
                        if (Copyloop.Number = 3) then begin
                            CopyText := 'Triplicate';
                        end;
                        if (Copyloop.Number >= 4) then begin
                            CopyText := 'Extra';
                        end;
                    end;

                } // Pageloop End

                // CopyLoop OnPreDataItem trigger OnPreDataItem();
                trigger OnPreDataItem();
                begin
                    if Copies = 0 then
                        Copies := 1;

                    NoOfLoops := ABS(Copies);
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    PageNo := 0;
                end;

                // CopyLoop OnAfterGetRecord trigger
                trigger OnAfterGetRecord();
                begin
                    PageNo += 1; // Increment Page No.
                end;

            } // Copyloop End

            // Sales Invoice Header trigger OnPreDataItem() to filterdata
            trigger OnPreDataItem()
            begin
                // "Sales Invoice Header".SetFilter("No.", SetFilterValue);
            end;

            // Sales Invoice Header trigger OnAfterGetRecord()
            trigger OnAfterGetRecord()
            begin

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

                // Bill To Details
                BillToDetails[1] := "Sales Invoice Header"."Bill-to Name";
                BillToDetails[2] := "Sales Invoice Header"."Bill-to Address";
                BillToDetails[3] := "Sales Invoice Header"."Bill-to Post Code";
                BillToDetails[4] := "Sales Invoice Header"."Bill-to City";
                BillToDetails[5] := "Sales Invoice Header"."GST Bill-to State Code";
                if RecState.Get("Sales Invoice Header"."GST Bill-to State Code") then
                    BillToDetails[6] := RecState.Description;
                BillToDetails[7] := "Sales Invoice Header"."Bill-to Country/Region Code";
                if RecCountry.Get("Sales Invoice Header"."Bill-to Country/Region Code") then
                    BillToDetails[8] := RecCountry.Name;
                BillToDetails[9] := "Sales Invoice Header"."Bill-to Contact";
                BillToDetails[10] := "Sales Invoice Header"."Bill-to Contact No.";
                BillToDetails[11] := "Sales Invoice Header"."Bill-to Customer No.";

                // Ship To Details
                ShipToDetails[1] := "Sales Invoice Header"."Ship-to Name";
                ShipToDetails[2] := "Sales Invoice Header"."Ship-to Address";
                ShipToDetails[3] := "Sales Invoice Header"."Ship-to Post Code";
                ShipToDetails[4] := "Sales Invoice Header"."Ship-to City";
                ShipToDetails[5] := "Sales Invoice Header"."GST Ship-to State Code";
                if RecState.Get("Sales Invoice Header"."GST Ship-to State Code") then
                    ShipToDetails[6] := RecState.Description;
                ShipToDetails[7] := "Sales Invoice Header"."Ship-to Country/Region Code";
                if RecCountry.Get("Sales Invoice Header"."Ship-to Country/Region Code") then
                    ShipToDetails[8] := RecCountry.Name;
                ShipToDetails[9] := "Sales Invoice Header"."Ship-to Contact";
                ShipToDetails[10] := "Sales Invoice Header"."Ship-to GST Reg. No.";

            end;

        } // Sales Invoice Header End
    }

    //=IIf(Sum(Fields!Line_Discount_Amount.Value) = 0, True, False) // Hide visibility in rdl

    // =IIf(Fields!Item_No_.Value = "", True, False)

    requestpage
    {
        layout
        {
            area(content)
            {
                group(General)
                {
                    field(BillType; BillType)
                    {
                        Caption = 'Option';
                        ApplicationArea = All;
                    }
                    field(SetFilterValue; SetFilterValue)
                    {
                        Caption = 'SET FILTER';
                        TableRelation = "Sales Invoice Header"."No.";
                        ApplicationArea = All;
                    }
                    field("Copies To Print"; Copies)
                    {
                        Caption = 'No. of Copies';
                        ApplicationArea = All;
                    }
                }
            }
        }

        // Dead Code For Actions
        actions
        {
            area(processing)
            {
                action("Send Email")
                {
                    ApplicationArea = All;
                    // ApplicationArea = All;
                    // Caption = 'Send Email';
                    // Image = Email;

                    // Promoted = true;
                    // PromotedCategory = Process;
                    // PromotedIsBig = true;
                    // PromotedOnly = true;

                    // trigger OnAction()
                    // begin
                    //     Email."Email Report"('shub', 90117, "Sales Invoice Header");
                    // end;

                }
            }
        }

    }


    trigger OnPreReport()
    begin
        if CompanyInfo.Get() then
            CompanyInfo.CalcFields(Picture);

        if SetFilterValue <> '' then
            "Sales Invoice Header".SetFilter("No.", SetFilterValue);
    end;



    var
        CompanyInfo: Record "company information";

        RecCountry: Record "Country/Region";
        RecState: Record State;
        RecLocation: Record Location;

        CompanyInfoDetails: array[10] of Text;
        BillToDetails: array[11] of Text;
        ShipToDetails: array[10] of Text;

        Gst: Record "Detailed GST Ledger Entry";

        BillToCountryName: Text;
        ShipToCountryName: Text;
        sno: Integer;

        IGST: Integer;
        CGST: Integer;
        SGST: Integer;
        IGSTRate: Integer;
        CGSTRate: Integer;
        SGSTRate: Integer;

        TotalAmount: Decimal;
        TotalGSTTaxes: Decimal;
        GrandTotal: Decimal;
        /////////////////// Important variables /////////////////////
        Copies: Integer;
        BillType: Option Orignal,Duplicate,Triplicate;

        NoOfLoops: Integer;
        CopyText: Text[30];
        PageNo: Integer;

        SetFilterValue: Code[50];
        ///////////////////////////////////////////////////////////////
        SILINE: Record "Sales Invoice Line";



    // Gst.Reset();
    // Gst.SetRange("Entry Type", Gst."Entry Type"::"Initial Entry");
    // Gst.SetRange("Transaction Type", Gst."Transaction Type"::Sales);
    // Gst.SetRange("Document Type", Gst."Document Type"::Invoice);
    // Gst.SetRange("Document No.", "Purchase Header"."No.");
    // if Gst.FindSet() then begin
    //     repeat
    //         TotalGSTTaxes += ABS(Gst."GST Amount"); // Calculate total Taxes
    //     until Gst.Next() = 0;
    // end;

    // // to get the gst rate and amount
    // Gst.SetRange("No.", "Purchase Line"."No.");
    // if Gst.FindFirst() then begin
    //     GSTRate := Gst."GST %";
    //     if (Gst."GST Component Code" = 'IGST') then begin
    //         IGST := ABS(Gst."GST Amount");
    //         IGSTRate := Gst."GST %";
    //         CGST := 0;
    //         CGSTRate := 0;
    //         SGST := 0;
    //         SGSTRate := 0;
    //     end else begin
    //         CGST := ABS(Gst."GST Amount");
    //         CGSTRate := GST."GST %";
    //         SGST := ABS(Gst."GST Amount");
    //         SGSTRate := GST."GST %";
    //         IGST := 0;
    //         IGSTRate := 0;
    //     end;
    // end;


    //  Gst.Reset();
    // Gst.SetRange("Entry Type", Gst."Entry Type"::"Initial Entry");
    // Gst.SetRange("Transaction Type", Gst."Transaction Type"::Sales);
    // Gst.SetRange("Document Type", Gst."Document Type"::Invoice);
    // Gst.SetRange("Document No.", "Purchase Header"."No.");
    // if Gst.FindSet() then begin
    //     repeat
    //         TotalGSTTaxes += ABS(Gst."GST Amount"); // Calculate total Taxes
    //     until Gst.Next() = 0;
    // end;

    // // to get the gst rate and amount
    // Gst.SetRange("No.", "Purchase Line"."No.");
    // if Gst.FindFirst() then begin
    //     GSTRate := Gst."GST %";
    //     if (Gst."GST Component Code" = 'IGST') then begin
    //         IGST := ABS(Gst."GST Amount");
    //         IGSTRate := Gst."GST %";
    //         CGST := 0;
    //         CGSTRate := 0;
    //         SGST := 0;
    //         SGSTRate := 0;
    //     end else begin
    //         CGST := ABS(Gst."GST Amount");
    //         CGSTRate := GST."GST %";
    //         SGST := ABS(Gst."GST Amount");
    //         SGSTRate := GST."GST %";
    //         IGST := 0;
    //         IGSTRate := 0;
    //     end;
    // end;




}