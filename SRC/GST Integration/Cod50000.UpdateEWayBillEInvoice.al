codeunit 50000 "Update E-Way Bill & E-Invoice"
{
    Permissions = tabledata "Sales Invoice Header" = rm,
        tabledata "Sales Invoice Line" = rm,
        tabledata "Sales Cr.Memo Header" = rm,
        tabledata "Sales Cr.Memo Line" = rm,
        tabledata "Transfer Shipment Header" = rm,
        tabledata "Transfer Shipment Line" = rm,
        tabledata "E-Invoice & E-Way Bill" = rm;

    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterSalesInvHeaderInsert', '', false, false)]
    local procedure OnAfterSalesInvHeaderInsert(var SalesInvHeader: Record "Sales Invoice Header";
    SalesHeader: Record "Sales Header";
    CommitIsSuppressed: Boolean;
    WhseShip: Boolean;
    WhseReceive: Boolean;
    var TempWhseShptHeader: Record "Warehouse Shipment Header";
    var TempWhseRcptHeader: Record "Warehouse Receipt Header")
    var
        EwayBillandEinvoice: Record "E-Invoice & E-Way Bill";
        Cust: Record Customer;
        Location: Record Location;
        SalePost: Codeunit "Sales-Post";
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        recVendor: Record Vendor;
        EwayBillandEinvoice1: Record "E-Invoice & E-Way Bill";
    begin
        EwayBillandEinvoice.INIT;
        EwayBillandEinvoice."Sell-to Customer No." := SalesInvHeader."Sell-to Customer No.";
        EwayBillandEinvoice."No." := SalesInvHeader."No.";
        EwayBillandEinvoice."Ship-to Code" := SalesInvHeader."Ship-to Code";
        EwayBillandEinvoice."Posting Date" := SalesInvHeader."Posting Date";
        EwayBillandEinvoice."Location Code" := SalesInvHeader."Location Code";
        EwayBillandEinvoice."Sell-to Customer Name" := SalesInvHeader."Sell-to Customer Name";
        EwayBillandEinvoice."Sell-to Address" := SalesInvHeader."Sell-to Address";
        EwayBillandEinvoice."Sell-to Address 2" := SalesInvHeader."Sell-to Address 2";
        EwayBillandEinvoice."Sell-to City" := SalesInvHeader."Sell-to City";
        EwayBillandEinvoice."Sell-to Post Code" := SalesInvHeader."Sell-to Post Code";
        EwayBillandEinvoice.State := SalesInvHeader.State;
        EwayBillandEinvoice."Vehicle No." := SalesInvHeader."Vehicle No.";
        EwayBillandEinvoice."Mode of Transport" := UPPERCASE(SalesInvHeader."Mode of Transport");
        EwayBillandEinvoice."Location State Code" := SalesInvHeader."Location State Code";
        // ACX-Shubham
        // EwayBillandEinvoice."Transporter Code" := SalesInvHeader."Transporter Code";
        // if recVendor.Get(SalesInvHeader."Transporter Code") then begin
        //     EwayBillandEinvoice."Transporter Name" := recVendor.Name;
        //     EwayBillandEinvoice."Transporter GSTIN" := recVendor."GST Registration No.";
        // end;
        IF SalesInvHeader."Vehicle Type" = SalesInvHeader."Vehicle Type"::" " THEN BEGIN
            EwayBillandEinvoice."Vehicle Type" := EwayBillandEinvoice."Vehicle Type"::" ";
        END
        ELSE
            IF SalesInvHeader."Vehicle Type" = SalesInvHeader."Vehicle Type"::ODC THEN BEGIN
                EwayBillandEinvoice."Vehicle Type" := EwayBillandEinvoice."Vehicle Type"::ODC;
            END
            ELSE
                IF SalesInvHeader."Vehicle Type" = SalesInvHeader."Vehicle Type"::Regular THEN BEGIN
                    EwayBillandEinvoice."Vehicle Type" := EwayBillandEinvoice."Vehicle Type"::Regular;
                END;
        IF SalesInvHeader."Location Code" = '' THEN BEGIN
            EwayBillandEinvoice."Location GST Reg. No." := '';
        END
        ELSE BEGIN
            Location.GET(SalesInvHeader."Location Code");
            EwayBillandEinvoice."Location GST Reg. No." := Location."GST Registration No.";
        END;
        IF Cust.GET(SalesInvHeader."Sell-to Customer No.") THEN BEGIN
            IF NOT (SalesInvHeader."GST Customer Type" IN ["GST Customer Type"::Export]) THEN EwayBillandEinvoice."Customer GST Reg. No." := Cust."GST Registration No.";
        END;
        EwayBillandEinvoice."Sell-to Country/Region Code" := SalesInvHeader."Sell-to Country/Region Code";
        EwayBillandEinvoice."Ship-to Post Code" := SalesInvHeader."Ship-to Post Code";
        EwayBillandEinvoice."Ship-to Country/Region Code" := SalesInvHeader."Ship-to Country/Region Code";
        EwayBillandEinvoice."Ship-to City" := SalesInvHeader."Ship-to City";
        EwayBillandEinvoice."GST Customer Type" := SalesInvHeader."GST Customer Type";
        EwayBillandEinvoice."Transaction Type" := 'Sales Invoice';
        EwayBillandEinvoice.VALIDATE("Responsibility Center", SalesInvHeader."Responsibility Center");
        EwayBillandEinvoice."Posting User ID" := USERID;
        EwayBillandEinvoice."Posting Date Time" := CURRENTDATETIME;
        EwayBillandEinvoice.INSERT;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterSalesCrMemoHeaderInsert', '', false, false)]
    local procedure OnAfterSalesCrMemoHeaderInsert(var SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    SalesHeader: Record "Sales Header";
    CommitIsSuppressed: Boolean;
    WhseShip: Boolean;
    WhseReceive: Boolean;
    var TempWhseShptHeader: Record "Warehouse Shipment Header";
    var TempWhseRcptHeader: Record "Warehouse Receipt Header")
    var
        EwayBillandEinvoice: Record "E-Invoice & E-Way Bill";
        Cust: Record Customer;
        Location: Record Location;
        SalePost: Codeunit "Sales-Post";
        recVendor: Record Vendor;
    begin
        EwayBillandEinvoice.INIT;
        EwayBillandEinvoice."Sell-to Customer No." := SalesCrMemoHeader."Sell-to Customer No.";
        EwayBillandEinvoice."No." := SalesCrMemoHeader."No.";
        EwayBillandEinvoice."Ship-to Code" := SalesCrMemoHeader."Ship-to Code";
        EwayBillandEinvoice."Posting Date" := SalesCrMemoHeader."Posting Date";
        EwayBillandEinvoice."Location Code" := SalesCrMemoHeader."Location Code";
        EwayBillandEinvoice."Sell-to Customer Name" := SalesCrMemoHeader."Sell-to Customer Name";
        EwayBillandEinvoice."Sell-to Address" := SalesCrMemoHeader."Sell-to Address";
        EwayBillandEinvoice."Sell-to Address 2" := SalesCrMemoHeader."Sell-to Address 2";
        EwayBillandEinvoice."Sell-to City" := SalesCrMemoHeader."Sell-to City";
        EwayBillandEinvoice."Sell-to Post Code" := SalesCrMemoHeader."Sell-to Post Code";
        EwayBillandEinvoice.State := SalesCrMemoHeader.State;
        EwayBillandEinvoice."Vehicle No." := SalesCrMemoHeader."Vehicle No.";
        EwayBillandEinvoice."Location State Code" := SalesCrMemoHeader."Location State Code";
        // Acx-Shubham
        // EwayBillandEinvoice."Transporter Code" := SalesCrMemoHeader."Transporter Code";
        // if recVendor.Get(SalesCrMemoHeader."Transporter Code") then begin
        //     EwayBillandEinvoice."Transporter Name" := recVendor.Name;
        //     EwayBillandEinvoice."Transporter GSTIN" := recVendor."GST Registration No.";
        // end;
        IF SalesCrMemoHeader."Vehicle Type" = SalesCrMemoHeader."Vehicle Type"::" " THEN BEGIN
            EwayBillandEinvoice."Vehicle Type" := EwayBillandEinvoice."Vehicle Type"::" ";
        END
        ELSE
            IF SalesCrMemoHeader."Vehicle Type" = SalesCrMemoHeader."Vehicle Type"::ODC THEN BEGIN
                EwayBillandEinvoice."Vehicle Type" := EwayBillandEinvoice."Vehicle Type"::ODC;
            END
            ELSE
                IF SalesCrMemoHeader."Vehicle Type" = SalesCrMemoHeader."Vehicle Type"::Regular THEN BEGIN
                    EwayBillandEinvoice."Vehicle Type" := EwayBillandEinvoice."Vehicle Type"::Regular;
                END;
        IF SalesCrMemoHeader."Location Code" = '' THEN BEGIN
            EwayBillandEinvoice."Location GST Reg. No." := '';
        END
        ELSE BEGIN
            Location.GET(SalesCrMemoHeader."Location Code");
            EwayBillandEinvoice."Location GST Reg. No." := Location."GST Registration No.";
        END;
        IF Cust.GET(SalesCrMemoHeader."Sell-to Customer No.") THEN BEGIN
            IF NOT (SalesCrMemoHeader."GST Customer Type" IN ["GST Customer Type"::Export]) THEN EwayBillandEinvoice."Customer GST Reg. No." := Cust."GST Registration No.";
        END;
        EwayBillandEinvoice."Sell-to Country/Region Code" := SalesCrMemoHeader."Sell-to Country/Region Code";
        EwayBillandEinvoice."Ship-to Post Code" := SalesCrMemoHeader."Ship-to Post Code";
        EwayBillandEinvoice."Ship-to Country/Region Code" := SalesCrMemoHeader."Ship-to Country/Region Code";
        EwayBillandEinvoice."Ship-to City" := SalesCrMemoHeader."Ship-to City";
        EwayBillandEinvoice."GST Customer Type" := SalesCrMemoHeader."GST Customer Type";
        EwayBillandEinvoice."Transaction Type" := 'Sales Credit Memo';
        EwayBillandEinvoice.VALIDATE("Responsibility Center", SalesCrMemoHeader."Responsibility Center");
        EwayBillandEinvoice."Posting User ID" := USERID;
        EwayBillandEinvoice."Posting Date Time" := CURRENTDATETIME;
        EwayBillandEinvoice.INSERT;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterInsertTransShptHeader', '', false, false)]
    local procedure OnAfterInsertTransShptHeader(var TransferHeader: Record "Transfer Header";
    var TransferShipmentHeader: Record "Transfer Shipment Header")
    var
        EwayBillandEinvoice: Record "E-Invoice & E-Way Bill";
        recTransportMenthod: Record "Transport Method";
        TransMethd: Code[10];
        Location: Record Location;
        TransferOrderPostShipment: Codeunit "TransferOrder-Post Shipment";
        recVendor: Record Vendor;
    begin
        EwayBillandEinvoice.INIT;
        EwayBillandEinvoice."No." := TransferShipmentHeader."No.";
        EwayBillandEinvoice."Posting Date" := TransferShipmentHeader."Posting Date";
        Location.RESET();
        Location.SETRANGE(Code, TransferShipmentHeader."Transfer-from Code");
        IF Location.FIND('-') THEN BEGIN
            EwayBillandEinvoice."Location Code" := TransferShipmentHeader."Transfer-from Code";
            EwayBillandEinvoice."Location State Code" := Location."State Code";
            EwayBillandEinvoice."Location GST Reg. No." := Location."GST Registration No.";
        END;
        Location.RESET();
        Location.SETRANGE(Code, TransferShipmentHeader."Transfer-to Code");
        IF Location.FIND('-') THEN BEGIN
            EwayBillandEinvoice."Transfer-to Code" := TransferShipmentHeader."Transfer-to Code";
            EwayBillandEinvoice."Sell-to Customer Name" := Location.Name;
            EwayBillandEinvoice."Sell-to Address" := Location.Address;
            EwayBillandEinvoice."Sell-to Address 2" := Location."Address 2";
            EwayBillandEinvoice."Sell-to City" := Location.City;
            EwayBillandEinvoice."Sell-to Post Code" := Location."Post Code";
            EwayBillandEinvoice.State := Location."State Code";
            EwayBillandEinvoice."Customer GST Reg. No." := Location."GST Registration No.";
            EwayBillandEinvoice."Sell-to Country/Region Code" := Location."Country/Region Code";
        END;
        // Acx-Shubham
        // EwayBillandEinvoice."Transporter Code" := TransferShipmentHeader."Transporter Code";
        // if recVendor.Get(TransferShipmentHeader."Transporter Code") then begin
        //     EwayBillandEinvoice."Transporter Name" := recVendor.Name;
        //     EwayBillandEinvoice."Transporter GSTIN" := recVendor."GST Registration No.";
        // end;
        EwayBillandEinvoice."Distance (Km)" := FORMAT(TransferShipmentHeader."Distance (Km)");
        IF TransferShipmentHeader."Vehicle Type" = TransferShipmentHeader."Vehicle Type"::" " THEN BEGIN
            EwayBillandEinvoice."Vehicle Type" := EwayBillandEinvoice."Vehicle Type"::" ";
        END
        ELSE
            IF EwayBillandEinvoice."Vehicle Type" = TransferShipmentHeader."Vehicle Type"::ODC THEN BEGIN
                EwayBillandEinvoice."Vehicle Type" := EwayBillandEinvoice."Vehicle Type"::ODC;
            END
            ELSE
                IF EwayBillandEinvoice."Vehicle Type" = TransferShipmentHeader."Vehicle Type"::Regular THEN BEGIN
                    EwayBillandEinvoice."Vehicle Type" := EwayBillandEinvoice."Vehicle Type"::Regular;
                END;
        EwayBillandEinvoice."LR/RR No." := TransferShipmentHeader."LR/RR No.";
        EwayBillandEinvoice."LR/RR Date" := TransferShipmentHeader."LR/RR Date";
        EwayBillandEinvoice."Vehicle No." := TransferShipmentHeader."Vehicle No.";
        EwayBillandEinvoice."Mode of Transport" := UPPERCASE(TransferShipmentHeader."Mode of Transport");
        EwayBillandEinvoice."Transaction Type" := 'Transfer Shipment';
        EwayBillandEinvoice."Posting User ID" := USERID;
        EwayBillandEinvoice."Posting Date Time" := CURRENTDATETIME;
        EwayBillandEinvoice.INSERT;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterInsertTransShptLine', '', false, false)]
    local procedure OnAfterInsertTransShptLine(var TransShptLine: Record "Transfer Shipment Line";
    TransLine: Record "Transfer Line";
    CommitIsSuppressed: Boolean)
    var
        EwayBillandEinvoice: Record "E-Invoice & E-Way Bill";
        TransferOrderPostShipment: Codeunit "TransferOrder-Post Shipment";
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
    begin
        EwayBillandEinvoice.Reset();
        EwayBillandEinvoice.SetRange("No.", TransShptLine."Document No.");
        if EwayBillandEinvoice.FindFirst() then begin
            DetailedGSTLedgerEntry.Reset();
            DetailedGSTLedgerEntry.SetRange("Document No.", TransShptLine."Document No.");
            DetailedGSTLedgerEntry.SetRange("Document Line No.", TransShptLine."Line No.");
            if DetailedGSTLedgerEntry.FindFirst() then begin
                EwayBillandEinvoice."Amount to Transfer" += (TransShptLine.Amount + DetailedGSTLedgerEntry."GST Amount");
                EwayBillandEinvoice.MODIFY;
            end
            else begin
                EwayBillandEinvoice."Amount to Transfer" += (TransShptLine.Amount);
                EwayBillandEinvoice.MODIFY;
            end;
        end;
    end;
    /*
        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
        local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean)
        var
            EwayBillandEinvoice: Record "E-Invoice & E-Way Bill";
        begin
            EwayBillandEinvoice.Reset();
            EwayBillandEinvoice.SetRange("No.", SalesInvHdrNo);
            if EwayBillandEinvoice.FindFirst() then
                Page.Run(Page::"E-Invoice (Sales Invoice)", EwayBillandEinvoice);
        end;
    */
}
