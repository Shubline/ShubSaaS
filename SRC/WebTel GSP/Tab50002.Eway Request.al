table 60013 "E-Way Bill & E-Invoice Request"
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Entry No."; Integer)
        {
            InitValue = 0;
        }
        field(2; "Gstin"; Text[200]) { } // "29AAACW3775F000",
        field(3; "Irn"; Text[200]) { } // "",
        field(4; "Tran_SupTyp"; Text[200]) { } // "B2B",
        field(5; "Tran_RegRev"; Text[200]) { } // "N",
        field(6; "Tran_Typ"; Text[200]) { } // "REG",
        field(7; "Tran_EcmGstin"; Text[200]) { } // "",
        field(8; "Tran_IgstOnIntra"; Text[200]) { } // "N",
        field(9; "Doc_Typ"; Text[200]) { } // "INV",
        field(10; "Doc_No"; Text[200]) { } // "112211AQX920",
        field(11; "Doc_Dt"; Text[200]) { } // "10/08/2023",
        field(12; "BillFrom_Gstin"; Text[200]) { } // "29AAACW3775F000",
        field(13; "BillFrom_LglNm"; Text[200]) { } // "Webtel Electrosoft P. Ltd.",
        field(14; "BillFrom_TrdNm"; Text[200]) { } // "Webtel Electrosoft P. Ltd.",
        field(15; "BillFrom_Addr1"; Text[200]) { } // "110-114",
        field(16; "BillFrom_Addr2"; Text[200]) { } // "",
        field(17; "BillFrom_Loc"; Text[200]) { } // "Raje Place",
        field(18; "BillFrom_Pin"; Text[200]) { } // "562160",
        field(19; "BillFrom_Stcd"; Text[200]) { } // "29",
        field(20; "BillFrom_Ph"; Text[200]) { } // "",
        field(21; "BillFrom_Em"; Text[200]) { } // "",
        field(22; "BillTo_Gstin"; Text[200]) { } // "07AAACW3775F1Z8",
        field(23; "BillTo_LglNm"; Text[200]) { } // "Webtel Electrosoft P. Ltd.",
        field(24; "BillTo_TrdNm"; Text[200]) { } // "Webtel Electrosoft P. Ltd.",
        field(25; "BillTo_Pos"; Text[200]) { } // "07",
        field(26; "BillTo_Addr1"; Text[200]) { } // "110-114",
        field(27; "BillTo_Addr2"; Text[200]) { } // "",
        field(28; "BillTo_Loc"; Text[200]) { } // "Rajendra Place",
        field(29; "BillTo_Pin"; Text[200]) { } // "110008",
        field(30; "BillTo_Stcd"; Text[200]) { } // "07",
        field(31; "BillTo_Ph"; Text[200]) { } // "",
        field(32; "BillTo_Em"; Text[200]) { } // "",
        field(33; "Item_SlNo"; Text[200]) { } // "1",
        field(34; "Item_PrdDesc"; Text[200]) { } // "Web-e-Invoice Solution",
        field(35; "Item_IsServc"; Text[200]) { } // "Y",
        field(36; "Item_HsnCd"; Text[200]) { } // "9963",
        field(37; "Item_Barcde"; Text[200]) { } // "",
        field(38; "Item_Qty"; Text[200]) { } // "",
        field(39; "Item_FreeQty"; Text[200]) { } // "",
        field(40; "Item_Unit"; Text[200]) { } // "",
        field(41; "Item_UnitPrice"; Text[200]) { } // "100000",
        field(42; "Item_TotAmt"; Text[200]) { } // "100000",
        field(43; "Item_Discount"; Text[200]) { } // "",
        field(44; "Item_PreTaxVal"; Text[200]) { } // "100000",
        field(45; "Item_AssAmt"; Text[200]) { } // "100000",
        field(46; "Item_GstRt"; Text[200]) { } // "18",
        field(47; "Item_IgstAmt"; Text[200]) { } // "18000",
        field(48; "Item_CgstAmt"; Text[200]) { } // "",
        field(49; "Item_SgstAmt"; Text[200]) { } // "",
        field(50; "Item_CesRt"; Text[200]) { } // "",
        field(51; "Item_CesAmt"; Text[200]) { } // "",
        field(52; "Item_CesNonAdvlAmt"; Text[200]) { } // "",
        field(53; "Item_StateCesRt"; Text[200]) { } // "",
        field(54; "Item_StateCesAmt"; Text[200]) { } // "",
        field(55; "Item_StateCesNonAdvlAmt"; Text[200]) { } // "",
        field(56; "Item_OthChrg"; Text[200]) { } // "",
        field(57; "Item_TotItemVal"; Text[200]) { } // "118000",
        field(58; "Item_OrdLineRef"; Text[200]) { } // "",
        field(59; "Item_OrgCntry"; Text[200]) { } // "",
        field(60; "Item_PrdSlNo"; Text[200]) { } // "",
        field(61; "Item_Attrib_Nm"; Text[200]) { } // "Support Type^Tenure",
        field(62; "Item_Attrib_Val"; Text[200]) { } // "On-Site^1-Year",
        field(63; "Item_Bch_Nm"; Text[200]) { } // "",
        field(64; "Item_Bch_ExpDt"; Text[200]) { } // "",
        field(65; "Item_Bch_WrDt"; Text[200]) { } // "",
        field(66; "Val_AssVal"; Text[200]) { } // "100000",
        field(67; "Val_CgstVal"; Text[200]) { } // "",
        field(68; "Val_SgstVal"; Text[200]) { } // "",
        field(69; "Val_IgstVal"; Text[200]) { } // "18000",
        field(70; "Val_CesVal"; Text[200]) { } // "",
        field(71; "Val_StCesVal"; Text[200]) { } // "",
        field(72; "Val_Discount"; Text[200]) { } // "",
        field(73; "Val_OthChrg"; Text[200]) { } // "",
        field(74; "Val_RndOffAmt"; Text[200]) { } // "",
        field(75; "Val_TotInvVal"; Text[200]) { } // "118000",
        field(76; "Val_TotInvValFc"; Text[200]) { } // "",
        field(77; "Pay_Nm"; Text[200]) { } // "",
        field(78; "Pay_AccDet"; Text[200]) { } // "",
        field(79; "Pay_Mode"; Text[200]) { } // "",
        field(80; "Pay_FinInsBr"; Text[200]) { } // "",
        field(81; "Pay_PayTerm"; Text[200]) { } // "",
        field(82; "Pay_PayInstr"; Text[200]) { } // "",
        field(83; "Pay_CrTrn"; Text[200]) { } // "",
        field(84; "Pay_DirDr"; Text[200]) { } // "",
        field(85; "Pay_CrDay"; Text[200]) { } // "",
        field(86; "Pay_PaidAmt"; Text[200]) { } // "",
        field(87; "Pay_PaymtDue"; Text[200]) { } // "",
        field(88; "Ref_InvRm"; Text[200]) { } // "",
        field(89; "Ref_InvStDt"; Text[200]) { } // "",
        field(90; "Ref_InvEndDt"; Text[200]) { } // "",
        field(91; "Ref_PrecDoc_InvNo"; Text[200]) { } // "",
        field(92; "Ref_PrecDoc_InvDt"; Text[200]) { } // "",
        field(93; "Ref_PrecDoc_OthRefNo"; Text[200]) { } // "",
        field(94; "Ref_Contr_RecAdvRefr"; Text[200]) { } // "",
        field(95; "Ref_Contr_RecAdvDt"; Text[200]) { } // "",
        field(96; "Ref_Contr_TendRefr"; Text[200]) { } // "",
        field(97; "Ref_Contr_ContrRefr"; Text[200]) { } // "",
        field(98; "Ref_Contr_ExtRefr"; Text[200]) { } // "",
        field(99; "Ref_Contr_ProjRefr"; Text[200]) { } // "",
        field(100; "Ref_Contr_PORefr"; Text[200]) { } // "",
        field(101; "Ref_Contr_PORefDt"; Text[200]) { } // "",
        field(102; "AddlDoc_Url"; Text[200]) { } // "www.webtel.in^www.gstinindia.in",
        field(103; "AddlDoc_Docs"; Text[200]) { } // "",
        field(104; "AddlDoc_Info"; Text[200]) { } // "",
        field(105; "CDKey"; Text[200]) { } // "1000687",
        field(106; "EInvUserName"; Text[200]) { } // "29AAACW3775F000",
        field(107; "EInvPassword"; Text[200]) { } // "Admin!23..",
        field(108; "EFUserName"; Text[200]) { } // "29AAACW3775F000",
        field(109; "EFPassword"; Text[200]) { } // "Admin!23.."
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "Entry No." = 0 then
            GenerateEntryNo(true);
    end;

    procedure GenerateEntryNo(Validate: Boolean): Integer
    var
        CurrTable: Record "E-Way Bill & E-Invoice Request";
        EntryNo: Integer;
    begin
        CurrTable.Reset();
        if CurrTable.FindLast() then
            EntryNo := CurrTable."Entry No." + 1
        else
            EntryNo := 1;

        if Validate then
            Validate("Entry No.", EntryNo);

        exit(EntryNo);
    end;


    procedure TotalCalcPostedDoc("Document No.": Code[40]): Decimal
    var
        TotalAmount: Decimal;
        TotalGSTTaxes: Decimal;
        GrandTotal: Decimal;
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
    begin
        TotalGSTTaxes := 0;
        // Total Taxes Gst Calculation
        Gst.Reset();
        Gst.SetRange("Entry Type", Gst."Entry Type"::"Initial Entry");
        Gst.SetRange("Transaction Type", Gst."Transaction Type"::Purchase);
        Gst.SetRange("Document Type", Gst."Document Type"::Invoice);
        Gst.SetRange("Document No.", "Document No.");
        if Gst.FindSet() then begin
            repeat
                TotalGSTTaxes += ABS(Gst."GST Amount"); // Calculate total Taxes
            until Gst.Next() = 0;
        end;


        CASE Gst."Document Type" OF
            "GST Document Type"::Invoice:
                Validate(Doc_Typ, 'INV');
            "GST Document Type"::"Credit Memo":
                Validate(Doc_Typ, 'CRN');
        end;

        exit(TotalGSTTaxes);
    end;

    procedure GenerateInvoice(DocNo: Code[25])
    var
        EwayRequest: Record "E-Way Bill & E-Invoice Request";
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        SalesInvoiceHeader.Reset();
        SalesInvoiceHeader.SetRange("No.", DocNo);
        if SalesInvoiceHeader.FindFirst() then begin

            EwayRequest.Reset();
            EwayRequest.Init();
            EwayRequest.GenerateEntryNo(true);
            EwayRequest.Validate(Doc_No, DocNo);
            EwayRequest.Validate(Doc_Dt, Format(SalesInvoiceHeader."Document Date"));
            EwayRequest.Validate(BillFrom_Gstin,SalesInvoiceHeader."Ship-to GST Reg. No.");
            // EwayRequest.Validate(BillFrom_Gstin,SalesInvoiceHeader.);

        end;

        EwayRequest.Insert();
    end;
}

