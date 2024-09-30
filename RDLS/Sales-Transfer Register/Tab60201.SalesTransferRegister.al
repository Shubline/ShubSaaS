table 60201 "Sales/Transfer Register"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = ,"Sales Invoice","Sales Cr. Memo","Transfer Shpt.","Transfer Rcpt.","Purchase Invoice","Purchase Cr. Memo","POS Sale";
            OptionCaptionML = ENU = ' ,Sales Invoice,Sales Cr. Memo,Transfer Shpt.,Transfer Rcpt.,Purchase Invoice,Purchase Cr. Memo,POS Sale', ENN = ' ,Sales Invoice,Sales Cr. Memo,Transfer Shpt.,Transfer Rcpt.,Purchase Invoice,Purchase Cr. Memo,POS Sale';
        }
        field(2; "Gen. Journal Template Code"; Code[30])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(3; "Source Document No."; Code[30])
        {
        }
        field(4; "Source Line No."; Integer)
        {
        }
        field(5; "Posting Date"; Date)
        {
        }
        field(6; Type; Enum "Sales Line Type")
        {
        }
        field(7; "Source Line Description"; text[100])
        {
        }
        field(8; "Document Salesperson Code"; Code[30])
        {
            TableRelation = "Salesperson/Purchaser";
        }
        field(9; "Document Salesperson Name"; Text[100])
        {
        }
        field(10; "Payment Term Code"; Code[30])
        {
            TableRelation = "Payment Terms";
        }
        field(11; "Freight Payment Type"; Option)
        {
            OptionMembers = ,"To Pay",Paid,"Debit Note/Credit Note/Paid";
            OptionCaptionML = ENN = ' ,To Pay,Paid,Debit Note/Credit Note/Paid', ENU = ' ,To Pay,Paid,Debit Note/Credit Note/Paid';
        }
        field(12; "Shipping Bill No."; Code[30])
        {
        }
        field(13; "B/L No."; Code[30])
        {
        }
        field(14; "B/L daate"; date)
        {
        }
        field(15; "Transporter Code"; code[30])
        {
        }
        field(16; "Destination Port"; Code[30])
        {
            TableRelation = "Entry/Exit Point";
        }
        field(17; "Challan No."; Code[30])
        {
        }
        field(18; "Supplier's Ref."; Code[30])
        {
        }
        field(19; "Due Date"; Date)
        {
        }
        field(20; "Source type"; Option)
        {
            OptionMembers = ,Customer,Vendor,Location;
            OptionCaptionML = ENU = ' ,Customer,Vendor,Location', ENN = ' ,Customer,Vendor,Location';
        }
        field(21; "Source No."; Code[30])
        {
            TableRelation = IF ("Source Type" = CONST(Customer)) Customer."No."
            ELSE
            IF ("Source Type" = CONST(Vendor)) Vendor."No."
            ELSE
            IF ("Source Type" = CONST(Location)) Location.Code;
        }
        field(22; "Source City"; Text[30])
        {
            TableRelation = "Post Code".City;
        }
        field(23; "Source State Code"; Code[30])
        {
        }
        field(24; "Source Name"; text[100])
        {
        }
        field(25; "Customer Posting Group"; code[30])
        {
            TableRelation = "Customer Posting Group";
        }
        field(26; "CPG Desc"; Text[100])
        {
        }
        field(27; "Customer Price Group"; code[30])
        {
            TableRelation = "Customer Price Group";
        }
        field(28; "Customer Price Group Name"; Text[100])
        {
        }
        field(29; "Gen. Bus. Posting Group"; Code[30])
        {
        }
        field(30; "GBPG Description"; Text[100])
        {
        }
        field(31; "Country/Region Code"; Code[30])
        {
            TableRelation = "Country/Region";
        }
        field(32; "Country/Region Name"; Text[100])
        {
        }
        field(33; "Master Salesperson Code"; Code[30])
        {
            TableRelation = "Salesperson/Purchaser";
        }
        field(34; "Master Salesperson Name"; Text[100])
        {
        }
        field(35; "Territory Dimension Code"; Code[30])
        {
        }
        field(36; "Territory Dimension Name"; text[100])
        {
        }
        field(37; "Outward Location Code"; Code[30])
        {
            TableRelation = Location;
        }
        field(38; "Outward State Code"; Code[30])
        {
            TableRelation = State;
        }
        field(39; "Outward State Name"; text[100])
        {
        }

        field(40; "Location Type"; Option)
        {
            OptionMembers = ,Factory,"Branch Office",CSA,"C&F",HO,"Job Worker";
            OptionCaptionML = ENU = ' ,Factory,Branch Office,CSA,C&F,HO,Job Worker', ENN = ' ,Factory,Branch Office,CSA,C&F,HO,Job Worker';
        }
        field(41; "Fin. year"; code[7])
        {
        }
        field(42; Quarter; code[2])
        {
        }
        field(43; "Month Name"; code[3])
        {
        }
        field(44; Day; Integer)
        {
        }
        field(45; Month; Integer)
        {
        }
        field(46; Year; Integer)
        {
        }
        field(47; "No."; code[30])
        {
            TableRelation = IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge";
        }
        field(48; "Varient Code"; code[30])
        {
            TableRelation = IF (Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("No."));
        }
        field(49; "Item Description"; Text[100])
        {
        }
        field(50; "Varient Description"; Text[100])
        {
        }
        field(51; "Inventory Posting Group"; Code[30])
        {
            TableRelation = "Inventory Posting Group";
        }
        field(52; "Gen. Prod. Posting Group"; code[30])
        {
            TableRelation = "Gen. Product Posting Group";
        }
        field(53; "Item Print Name"; Text[100])
        {
        }
        field(54; "Item License No."; text[100])
        {
        }
        field(55; "CIB Registration No."; Text[100])
        {
        }
        field(56; "Packing Type"; Code[30])
        {
        }
        field(57; "Packing Size"; Code[30])
        {
        }
        field(58; "Technical Name"; Text[100])
        {
        }
        field(59; "Gross Weight"; Decimal)
        {
        }
        field(60; "Net Weight"; Decimal)
        {
        }
        field(61; "Unit of Measure"; Code[30])
        {
            TableRelation = "Unit of Measure";
        }
        field(62; "Item Type"; Option)
        {
            OptionMembers = ,FG,WIP,PM,RM,OTHERS;
            OptionCaptionML = ENU = ' ,FG,WIP,PM,RM,OTHERS', ENN = ' ,FG,WIP,PM,RM,OTHERS';
        }
        field(63; Quantity; Decimal)
        {
        }
        field(64; "Unit Price"; Decimal)
        {
        }
        field(65; Amount; Decimal)
        {
        }
        field(66; "Line Discount Amount"; Decimal)
        {
        }
        field(67; "Line Amount"; Decimal)
        {
        }
        field(68; "Excise Amount"; Decimal)
        {
        }
        field(69; "BED Amount"; Decimal)
        {
        }
        field(70; "Excise Base Amount"; Decimal)
        {
        }
        field(71; "ECess Amount"; Decimal)
        {
        }
        field(72; "SHECess Amount"; Decimal)
        {
        }
        field(73; "SAED Amount"; Decimal)
        {
        }
        field(74; "BED %"; Decimal)
        {
        }
        field(75; "ECess %"; Decimal)
        {
        }
        field(76; "SHECess %"; Decimal)
        {
        }
        field(77; "SAED %"; Decimal)
        {
        }
        field(78; "Assessable Amount"; Decimal)
        {
        }
        field(79; "MRP Price"; Decimal)
        {
        }
        field(80; "Abetment %"; Decimal)
        {
        }
        field(81; "Service Tax Base Amount"; Decimal)
        {
        }
        field(82; "Service Tax Amount"; Decimal)
        {
        }
        field(83; "Service Tax eCess Amount"; Decimal)
        {
        }
        field(84; "Service Tax SHECess Amount"; Decimal)
        {
        }
        field(85; "Servide Tax %"; Decimal)
        {
        }
        field(86; "Service Tax eCess %"; Decimal)
        {
        }
        field(87; "Service Tax SHECess %"; Decimal)
        {
        }
        field(88; "Service Tax Group"; code[30])
        {
        }
        field(89; "Service Tax Registration No."; code[30])
        {
        }
        field(90; "TDS Base Amount"; Decimal)
        {
        }
        field(91; "TDS Amount"; Decimal)
        {
        }
        field(92; "eCess on TDS Amount"; Decimal)
        {
        }
        field(93; "SHECess on TDS Amount"; Decimal)
        {
        }
        field(94; "TDS %"; Decimal)
        {
        }
        field(95; "eCess % on TDS"; Decimal)
        {
        }
        field(96; "SHECess % on TDS"; Decimal)
        {
        }
        field(97; "TDS nature of Deduction"; Code[30])
        {
        }
        field(98; "Tax Base Amount"; Decimal)
        {
        }
        field(99; "CST Amount"; Decimal)
        {
        }
        field(100; "VAT Amount"; Decimal)
        {
        }
        field(101; "Tax Area"; code[30])
        {
            TableRelation = "Tax Area";
        }
        field(102; "Tax Jurisdiction Code"; Code[30])
        {
            TableRelation = "Tax Jurisdiction";
        }
        field(103; "Tax Type"; Option)
        {
            OptionMembers = ,VAT,CST;
            OptionCaptionML = ENU = ' ,VAT,CST', ENN = ' ,VAT,CST';
        }
        field(104; "Tax %"; Decimal)
        {
        }
        field(105; "Form Code"; Code[30])
        {
        }
        field(106; "Form no."; code[30])
        {
        }
        field(107; "Line Discount %"; Decimal)
        {
        }
        field(108; "Applies-to Doc. Type"; enum "Gen. Journal Document Type")
        {
        }
        field(109; "Applies-to Doc. No."; Code[30])
        {
        }
        field(110; "Round off Amount"; Decimal)
        {
        }
        field(111; "Net Amount"; Decimal)
        {
        }
        field(112; "Tax Amount"; Decimal)
        {
        }
        field(113; "Item Category Code"; Code[30])
        {
            TableRelation = "Item Category";
        }
        field(114; "Item Category Description"; text[100])
        {
        }
        field(115; "Product Group Code"; Code[30])
        {
        }
        field(116; "Product Group Description"; text[100])
        {
        }
        field(117; "Tax Group Code"; code[30])
        {
            TableRelation = "Tax Group";
        }
        field(118; "Global Dimension 1 Code"; code[30])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(119; "Global Dimension 2 Code"; Code[30])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(120; "T.I.N No."; Code[11])
        {
        }
        field(121; "Trade Discount"; Decimal)
        {
        }
        field(122; "Cash Discount"; Decimal)
        {
        }
        field(123; "Scheme Discount"; Decimal)
        {
        }
        field(124; "OffSeason Discount"; Decimal)
        {
        }
        field(125; Freight; Decimal)
        {
        }
        field(126; "Master Cust. Posting Group"; Code[30])
        {
            TableRelation = "Customer Posting Group";
        }
        field(127; "GST Group"; Code[30])
        {
        }
        field(128; "HSN/SAC Code"; Code[10])
        {
        }
        field(129; "GST Base Amount"; Decimal)
        {
        }
        field(130; "Cess %"; Decimal)
        {
        }
        field(131; "Revenue Account Code"; code[30])
        {
            TableRelation = "G/L Account";
        }
        field(132; "Revenue Account Description"; Text[100])
        {
        }
        field(133; "Receivable Account Code"; Code[30])
        {
            TableRelation = "G/L Account";
        }
        field(134; "Receivable Account Description"; Text[100])
        {
        }
        field(135; "No. Series"; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(136; Insurance; Decimal)
        {
        }
        field(137; "Currency Code"; Code[10])
        {
            TableRelation = Currency;
        }
        field(138; "Currency Fector"; Decimal)
        {
        }
        field(139; "External Document No."; code[100])
        {
        }
        field(140; "Actual Tax %"; Decimal)
        {
        }
        field(141; "Order No."; Code[30])
        {
        }
        field(142; "LR/RR No."; Code[30])
        {
        }
        field(143; "LR/RR Date"; Date)
        {
        }
        field(144; "GST Assessable Value"; Decimal)
        {
        }
        field(145; "Total GST Amount"; Decimal)
        {
        }
        field(146; "CGST %"; Decimal)
        {
        }
        field(147; "SGST %"; Decimal)
        {
        }
        field(148; "IGST %"; Decimal)
        {
        }
        field(149; "CGST Amount"; Decimal)
        {
        }
        field(150; "SGST Amount"; Decimal)
        {
        }
        field(151; "IGST Amount"; Decimal)
        {
        }
        field(152; "Cess Amount"; Decimal)
        {
        }
        field(153; "GST Place of Supply"; Text[100])
        {
        }
        field(154; "Location Reg. No."; Code[15])
        {
        }
        field(155; "Customer Reg. No."; Code[15])
        {
        }
        field(156; "Source State Name"; Text[100])
        {
        }
        field(157; "Variant Code"; Code[30])
        {
        }
        field(158; "Variant Description"; Text[50])
        {
        }
        field(159; "GPPG Description"; Text[100])
        {
        }
        field(160; "Shipping Address"; Text[150])
        {
        }
        field(161; "Location GST Registration No."; Code[16])
        {
        }
        field(162; "Remarks"; Text[100])
        {
        }
        //RK 09May22 Begin
        field(163; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(164; Brand; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(165; "TCS Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(166; "Total Bill Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(167; "Vehicle Type"; Enum "GST Vehicle Type")
        {
            DataClassification = ToBeClassified;
        }
        field(168; "Vehicle No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(169; "Qty. in KG"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(170; "Customer Type"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(171; "Customer Disc. Group"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(172; "Customer Disc. Group Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        //RK End
        field(173; "Ship-To Code"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(174; "Ship-To Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(175; "E-Invoice No."; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(176; "E-Way Bill No."; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(177; "Delivery Boy"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(178; "Narration/Comments"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(179; "Lot No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(180; "Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(181; "Transaction No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        //acx Pragati 14-6-23
        field(182; "Outward Location name"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        // AcxPragati 14-6-23
        field(183; "Return Reason Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        // AcxPragati 14-6-23
    }
    keys
    {
        key(PK; "Document Type", "Source Document No.", "Source Line No.", "Transaction No.")
        {
            Clustered = true;
        }
    }
    var
        myInt: Integer;

    trigger OnInsert()
    begin
    end;

    trigger OnModify()
    begin
    end;

    trigger OnDelete()
    begin
    end;

    trigger OnRename()
    begin
    end;
}
