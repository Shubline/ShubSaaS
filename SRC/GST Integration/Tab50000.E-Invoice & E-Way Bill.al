table 50000 "E-Invoice & E-Way Bill"
{
    DataClassification = ToBeClassified;
    Permissions = TableData "Sales Invoice Header" = rm,
        TableData "Sales Cr.Memo Header" = rm;

    fields
    {
        field(1; "Sell-to Customer No."; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sell-to Customer No.';
            TableRelation = "Customer";
        }
        field(2; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'No.';
        }
        field(3; "Ship-to Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Sell-to Customer No."));
        }
        field(4; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Posting Date';
        }
        field(5; "Location Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(6; "Sell-to Customer Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sell-to Customer Name';
        }
        field(7; "Sell-to Address"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sell-to Address';
        }
        field(8; "Sell-to Address 2"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sell-to Address 2';
        }
        field(9; "Sell-to City"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sell-to City';
            TableRelation = "Post Code".City;
        }
        field(10; "Sell-to Post Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sell-to Post Code';
            TableRelation = "Post Code";
        }
        field(11; "State"; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'State';
            TableRelation = State;
        }
        field(12; "LR/RR No."; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'LR/RR No.';
        }
        field(13; "LR/RR Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'LR/RR Date';
        }
        field(14; "Vehicle No."; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vehicle No.';
        }
        field(15; "Mode of Transport"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Mode of Transport';
        }
        field(16; "Location State Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Location State Code';
            TableRelation = "State";
        }
        field(17; "Amount to Customer"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount to Customer';
        }
        field(18; "Vehicle Type"; Enum "GST Vehicle Type")
        {
            DataClassification = ToBeClassified;
            Caption = 'Vehicle Type';
            //OptionMembers = " ","regular","over dimensional cargo";
            //OptionCaption = ' ,regular,over dimensional cargo';
        }
        field(19; "Location GST Reg. No."; Code[15])
        {
            DataClassification = ToBeClassified;
            Caption = 'Location GST Reg. No.';
            TableRelation = "GST Registration Nos.";
        }
        field(20; "Customer GST Reg. No."; Code[15])
        {
            DataClassification = ToBeClassified;
            Caption = 'Customer GST Reg. No.';
        }
        field(21; "Distance (Km)"; Text[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Distance (Km)';
        }
        field(22; "Transporter Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transporter Code';
            TableRelation = "Vendor"."No.";
        }
        field(23; "Sell-to Country/Region Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sell-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(24; "Ship-to Post Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Ship-to Post Code';
            TableRelation = IF ("Ship-to Country/Region Code" = CONST()) "Post Code"
            ELSE
            IF ("Ship-to Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Ship-to Country/Region Code"));
        }
        field(25; "Ship-to Country/Region Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Ship-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(26; "Ship-to City"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Ship-to City';
            TableRelation = IF ("Ship-to Country/Region Code" = CONST()) "Post Code"."City"
            ELSE
            IF ("Ship-to Country/Region Code" = FILTER(<> '')) "Post Code"."City" WHERE("Country/Region Code" = FIELD("Ship-to Country/Region Code"));
        }
        field(27; "E-Way Bill Date"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'E-Way Bill Date';
        }
        field(28; "E-Way Bill Valid Upto"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'E-Way Bill Valid Upto';
        }
        field(29; "Vehicle Update Date"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vehicle Update Date';
        }
        field(30; "Vehicle Valid Upto"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vehicle Valid Upto';
        }
        field(31; "Cancel E-Way Bill Date"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Cancel E-Way Bill Date';
        }
        field(32; "E-Way Bill Status"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'E-Way Bill Status';
        }
        field(33; "E-Way Bill No."; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'E-Way Bill No.';

            trigger OnValidate()
            var
                recSalesInvHdr: Record "Sales Invoice Header";
                recSalesCrMemoHdr: Record "Sales Cr.Memo Header";
                recTransferShipHdr: Record "Transfer Shipment Header";
                recPurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
            begin
                IF "Transaction Type" = 'Sales Invoice' THEN BEGIN
                    recSalesInvHdr.RESET();
                    recSalesInvHdr.SETRANGE("No.", Rec."No.");
                    IF recSalesInvHdr.FIND('-') THEN BEGIN
                        recSalesInvHdr."E-Way Bill No." := Rec."E-Way Bill No.";
                        recSalesInvHdr.MODIFY;
                    END;
                END
                ELSE
                    IF "Transaction Type" = 'Sales Credit Memo' THEN BEGIN
                        recSalesCrMemoHdr.RESET();
                        recSalesCrMemoHdr.SETRANGE("No.", Rec."No.");
                        IF recSalesCrMemoHdr.FIND('-') THEN BEGIN
                            recSalesCrMemoHdr."E-Way Bill No." := Rec."E-Way Bill No.";
                            recSalesCrMemoHdr.MODIFY;
                        END;
                    END
                    ELSE
                        IF "Transaction Type" = 'Purchase Credit Memo' THEN BEGIN
                            recPurchCrMemoHdr.RESET();
                            recPurchCrMemoHdr.SETRANGE("No.", Rec."No.");
                            IF recPurchCrMemoHdr.FIND('-') THEN BEGIN
                                recPurchCrMemoHdr."E-Way Bill No." := Rec."E-Way Bill No.";
                                recPurchCrMemoHdr.MODIFY;
                            END;
                        END;
            end;
        }
        field(34; "Old Vehicle No."; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Old Vehicle No.';
        }
        field(35; "Reason Code for Cancel"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Reason Code for Cancel';
            OptionMembers = " ","Duplicate","Order Cancelled","Data Entry mistake","Others";
            OptionCaption = ' ,Duplicate,Order Cancelled,Data Entry mistake,Others';

            trigger OnValidate()
            var
                recSalesInvHdr: Record "Sales Invoice Header";
            begin
                recSalesInvHdr.RESET();
                recSalesInvHdr.SETRANGE(recSalesInvHdr."No.", Rec."No.");
                IF recSalesInvHdr.FIND('-') THEN BEGIN
                    //recSalesInvHdr.VALIDATE("Reason Code for Cancel", Rec."Reason Code for Cancel");
                    recSalesInvHdr.MODIFY;
                END;
            end;
        }
        field(36; "Reason for Cancel Remarks"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Reason for Cancel Remarks';

            trigger OnValidate()
            var
                recSalesInvHdr: Record "Sales Invoice Header";
            begin
                recSalesInvHdr.RESET();
                recSalesInvHdr.SETRANGE(recSalesInvHdr."No.", Rec."No.");
                IF recSalesInvHdr.FIND('-') THEN BEGIN
                    //recSalesInvHdr.VALIDATE("Reason for Cancel Remarks", Rec."Reason for Cancel Remarks");
                    recSalesInvHdr.MODIFY;
                END;
            end;
        }
        field(37; "Reason Code for Vehicle Update"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Reason Code for Vehicle Update';
            OptionMembers = " ","Due to Break Down","Due to Transhipment","Others","First Time";
            OptionCaption = ' ,Due to Break Down,Due to Transhipment,Others,First Time';
        }
        field(38; "Reason for Vehicle Update"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Reason for Vehicle Update';
        }
        field(39; "E-Way Bill By IRN Report URL"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'E-Way Bill By IRN Report URL';
        }
        field(40; "GST Customer Type"; enum "GST Customer Type")
        {
            DataClassification = ToBeClassified;
            Caption = 'GST Customer Type';
            //OptionMembers = " ","Registered","Unregistered","Export","Deemed Export","Exempted","SEZ Development","SEZ Unit";
            //OptionCaption = ' ,Registered,Unregistered,Export,Deemed Export,Exempted,SEZ Development,SEZ Unit';
        }
        field(41; "E-Invoice IRN No"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'E-Invoice IRN No';

            trigger OnValidate()
            var
                recSalesInvHdr: Record "Sales Invoice Header";
                recSalesCrMemoHdr: Record "Sales Cr.Memo Header";
            begin
                IF "Transaction Type" = 'Sales Invoice' THEN BEGIN
                    recSalesInvHdr.RESET();
                    recSalesInvHdr.SETRANGE("No.", Rec."No.");
                    IF recSalesInvHdr.FIND('-') THEN BEGIN
                        recSalesInvHdr."IRN Hash" := Rec."E-Invoice IRN No";
                        recSalesInvHdr.MODIFY;
                    END;
                END
                ELSE
                    IF "Transaction Type" = 'Sales Credit Memo' THEN BEGIN
                        recSalesCrMemoHdr.RESET();
                        recSalesCrMemoHdr.SETRANGE("No.", Rec."No.");
                        IF recSalesCrMemoHdr.FIND('-') THEN BEGIN
                            recSalesCrMemoHdr."IRN Hash" := Rec."E-Invoice IRN No";
                            recSalesCrMemoHdr.MODIFY;
                        END;
                    END;
            end;
        }
        field(42; "E-Invoice IRN Status"; Text[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'E-Invoice IRN Status';
        }
        field(43; "E-Invoice Cancel Reason"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'E-Invoice Cancel Reason';
            OptionMembers = " ","Duplicate","Wrong entry";
            OptionCaption = ' ,Duplicate,Wrong entry';
        }
        field(44; "E-Invoice Cancel Remarks"; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'E-Invoice Cancel Remarks';
        }
        field(45; "E-Invoice Status"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'E-Invoice Status';
        }
        field(46; "E-Invoice Cancel Date"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'E-Invoice Cancel Date';

            trigger OnValidate()
            begin
                IF "E-Invoice Cancel Date" <> '' THEN BEGIN
                    TimeFormat := 'AM';
                    EVALUATE(Year, COPYSTR("E-Invoice Cancel Date", 1, 4));
                    EVALUATE(Month, COPYSTR("E-Invoice Cancel Date", 6, 2));
                    EVALUATE(Day, COPYSTR("E-Invoice Cancel Date", 9, 2));
                    EVALUATE(Hour, COPYSTR("E-Invoice Cancel Date", 12, 2));
                    EVALUATE(Minute, COPYSTR("E-Invoice Cancel Date", 15, 2));
                    EVALUATE(Sec, COPYSTR("E-Invoice Cancel Date", 18, 2));
                    IF (Hour >= 12) THEN BEGIN
                        Hour := Hour - 12;
                        TimeFormat := 'PM';
                    END;
                    text1 := FORMAT(Hour) + ':' + FORMAT(Minute) + ':' + FORMAT(Sec) + ' ' + TimeFormat;
                    EVALUATE(Timee, text1);
                END
                ELSE BEGIN
                    recSalesInvHeader.RESET();
                    recSalesInvHeader.SETRANGE("No.", Rec."No.");
                    IF recSalesInvHeader.FINDFIRST THEN BEGIN
                        recSalesInvHeader."E-Inv. Cancelled Date" := 0DT;
                        recSalesInvHeader.MODIFY;
                    END;
                END;
                IF "E-Invoice Cancel Date" <> '' THEN BEGIN
                    recSalesInvHeader.RESET();
                    recSalesInvHeader.SETRANGE("No.", Rec."No.");
                    IF recSalesInvHeader.FINDFIRST THEN BEGIN
                        recSalesInvHeader."E-Inv. Cancelled Date" := CREATEDATETIME(DMY2DATE(Day, Month, Year), Timee);
                        recSalesInvHeader.MODIFY;
                    END;
                END;
                IF "E-Invoice Cancel Date" <> '' THEN BEGIN
                    recSalesCrMemoHeader.RESET();
                    recSalesCrMemoHeader.SETRANGE("No.", Rec."No.");
                    IF recSalesCrMemoHeader.FINDFIRST THEN BEGIN
                        recSalesCrMemoHeader."E-Inv. Cancelled Date" := CREATEDATETIME(DMY2DATE(Day, Month, Year), Timee);
                        recSalesCrMemoHeader.MODIFY;
                    END;
                END
                ELSE BEGIN
                    recSalesCrMemoHeader.RESET();
                    recSalesCrMemoHeader.SETRANGE("No.", Rec."No.");
                    IF recSalesCrMemoHeader.FINDFIRST THEN BEGIN
                        recSalesCrMemoHeader."E-Inv. Cancelled Date" := 0DT;
                        recSalesCrMemoHeader.MODIFY;
                    END;
                END;
            end;
        }
        field(47; "E-Invoice QR Code"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'E-Invoice QR Code';
        }
        field(48; "E-Invoice PDF"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'E-Invoice PDF';
        }


        field(49; "E-Invoice Acknowledge No."; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'E-Invoice Acknowledge No.';

            trigger OnValidate()
            begin
                IF Rec."Transaction Type" = 'Sales Invoice' THEN BEGIN
                    recSalesInvHeader.RESET();
                    recSalesInvHeader.SETRANGE("No.", Rec."No.");
                    IF recSalesInvHeader.FINDFIRST THEN BEGIN
                        recSalesInvHeader."Acknowledgement No." := "E-Invoice Acknowledge No.";
                        recSalesInvHeader.MODIFY;
                    END;
                END;
                IF Rec."Transaction Type" = 'Sales Credit Memo' THEN BEGIN
                    recSalesCrMemoHeader.RESET();
                    recSalesCrMemoHeader.SETRANGE("No.", Rec."No.");
                    IF recSalesCrMemoHeader.FINDFIRST THEN BEGIN
                        recSalesCrMemoHeader."Acknowledgement No." := "E-Invoice Acknowledge No.";
                        recSalesCrMemoHeader.MODIFY;
                    END;
                END;
            end;
        }
        field(50; "E-Invoice Acknowledge Date"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'E-Invoice Acknowledge Date';

            trigger OnValidate()
            begin
                TimeFormat := 'AM';
                EVALUATE(Year, COPYSTR("E-Invoice Acknowledge Date", 1, 4));
                EVALUATE(Month, COPYSTR("E-Invoice Acknowledge Date", 6, 2));
                EVALUATE(Day, COPYSTR("E-Invoice Acknowledge Date", 9, 2));
                EVALUATE(Hour, COPYSTR("E-Invoice Acknowledge Date", 12, 2));
                IF Hour >= 12 THEN BEGIN
                    Hour := Hour - 12;
                    TimeFormat := 'PM';
                END;
                EVALUATE(Minute, COPYSTR("E-Invoice Acknowledge Date", 15, 2));
                EVALUATE(Sec, COPYSTR("E-Invoice Acknowledge Date", 18, 2));
                text1 := FORMAT(Hour) + ':' + FORMAT(Minute) + ':' + FORMAT(Sec) + ' ' + TimeFormat;
                EVALUATE(Timee, text1);
                IF Rec."Transaction Type" = 'Sales Invoice' THEN BEGIN
                    recSalesInvHeader.RESET();
                    recSalesInvHeader.SETRANGE("No.", Rec."No.");
                    IF recSalesInvHeader.FINDFIRST THEN BEGIN
                        recSalesInvHeader."Acknowledgement Date" := CREATEDATETIME(DMY2DATE(Day, Month, Year), Timee);
                        recSalesInvHeader.MODIFY;
                    END;
                END;
                IF Rec."Transaction Type" = 'Sales Credit Memo' THEN BEGIN
                    recSalesCrMemoHeader.RESET();
                    recSalesCrMemoHeader.SETRANGE("No.", Rec."No.");
                    IF recSalesCrMemoHeader.FINDFIRST THEN BEGIN
                        recSalesCrMemoHeader."Acknowledgement Date" := CREATEDATETIME(DMY2DATE(Day, Month, Year), Timee);
                        recSalesCrMemoHeader.MODIFY;
                    END;
                END;
            end;
        }
        field(51; "Rec ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Rec ID';
            //AutoIncrement = true;
        }
        field(52; "Transaction Type"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transaction Type';
        }
        field(53; "Amount to Transfer"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount to Transfer';
        }
        field(54; "Port Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Port Code';
        }
        field(55; "Buy-from Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Buy-from Vendor No.';
            TableRelation = "Vendor";
        }
        field(56; "Amount to Vendor"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount to Vendor';
        }
        field(57; "Order Address Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Order Address Code';
            TableRelation = "Order Address".Code WHERE("Vendor No." = FIELD("Buy-from Vendor No."));
        }
        field(58; "Buy-from City"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Buy-from City';
            TableRelation = IF ("Buy-from Country/Region Code" = CONST()) "Post Code"."City"
            ELSE
            IF ("Buy-from Country/Region Code" = FILTER(<> '')) "Post Code"."City" WHERE("Country/Region Code" = FIELD("Buy-from Country/Region Code"));
        }
        field(59; "Buy-from Post Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Buy-from Post Code';
            TableRelation = IF ("Buy-from Country/Region Code" = CONST()) "Post Code"
            ELSE
            IF ("Buy-from Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Buy-from Country/Region Code"));
        }
        field(60; "Buy-from Country/Region Code"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Buy-from Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(61; "GST Vendor Type"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'GST Vendor Type';
            OptionMembers = " ","Registered","Composite","Unregistered","Import","Exempted","SEZ";
            OptionCaption = ' ,Registered,Composite,Unregistered,Import,Exempted,SEZ';
        }
        field(62; "Vendor GST Reg. No."; Code[15])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor GST Reg. No.';
        }
        field(63; "Order Address Post Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Order Address Post Code';
            TableRelation = "Post Code";
        }
        field(64; "Order Address Country Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Order Address Country Code';
            TableRelation = "Country/Region";
        }
        field(65; "Order Address City"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Order Address City';
            TableRelation = "Post Code"."City";
        }
        field(66; "Transportation Mode"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Transportation Mode';
            OptionMembers = " ","Road","Rail","Air","Ship";
            OptionCaption = ' ,Road,Rail,Air,Ship';
        }
        field(67; "Transfer-to Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transfer-to Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(68; "QR Code"; Blob)
        {
            DataClassification = ToBeClassified;
            Caption = 'QR Code';
        }
        field(69; "Transporter GSTIN"; Text[15])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transporter GSTIN';
        }
        field(70; "Transporter Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transporter Name';
        }
        field(71; "Responsibility Center"; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(72; "Posting User ID"; Code[70])
        {
            DataClassification = ToBeClassified;
            Caption = 'Posting User ID';
        }
        field(73; "Posting Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Caption = 'Posting Date Time';
        }
        field(74; "Cancel Reason E-Way By Irn"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Cancel Reason E-Way By Irn';
            OptionMembers = " ","Only E-Invoice will get cancel","Only E-Way Bill will get cancel","Both will get cancel";
            OptionCaption = ' ,Only E-Invoice will get cancel,Only E-Way Bill will get cancel,Both will get cancel';
        }
        field(75; "E-Invoice Cancel IRN No"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'E-Invoice Cancel IRN No';
        }
        field(76; "Cancel E-Way Bill by IRN No"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Cancel E-Way Bill by IRN Date';
        }
        field(77; "Cancel E-Way Bill by IRN Date"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Cancel E-Way Bill by IRN Date';
        }


        field(78; "Cancel E-Way Bill No."; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Cancel E-Way Bill No.';
        }


        field(79; "E-Way Bill Report URL"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'E-Way Bill Report URL';
        }

        //standalone
        field(80; "Standalone E way bill Pdf"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'E-Invoice PDF';
        }
        field(81; "StandaloneEWay Bill Report URL"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'StandaloneE-Way Bill Report URL';
        }

        // cancel e way bill remark new 
        field(84; "E-way bill Cancel Remarks"; Text[500])
        {
            DataClassification = ToBeClassified;
            Caption = 'E-way bill Cancel Remarks';
            trigger OnValidate()
            var
                recSalesInvHdr: Record "Sales Invoice Header";
            begin
                recSalesInvHdr.RESET();
                recSalesInvHdr.SETRANGE(recSalesInvHdr."No.", Rec."No.");
                IF recSalesInvHdr.FIND('-') THEN BEGIN
                    //recSalesInvHdr.VALIDATE("Reason for Cancel Remarks", Rec."Reason for Cancel Remarks");
                    recSalesInvHdr.MODIFY;
                END;
            end;
        }

        // cancel e way bill remark new 

        // acx 19-5-23


        // field(82; "Standalone Eway billno."; Text[100])
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'E-Invoice IRN No';

        //     trigger OnValidate()
        //     var
        //         recSalesInvHdr: Record "Sales Invoice Header";
        //     begin
        //         IF "Transaction Type" = 'Sales Invoice' THEN BEGIN
        //             recSalesInvHdr.RESET();
        //             recSalesInvHdr.SETRANGE("No.", Rec."No.");
        //             IF recSalesInvHdr.FIND('-') THEN BEGIN
        //                 recSalesInvHdr."IRN Hash" := Rec."E-Way Bill No.";
        //                 recSalesInvHdr.MODIFY;
        //             END;
        //         END
        //     end;

        // }
        // field(83; "cancel Stand Alone E-wayBill No."; Text[100])
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'cancel Stand Alone Eway Bill No';
        // }

        // field(84; "E-Way bill Cancel Date"; Text[50])
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'E-Way bill Cancel Date';

        //     trigger OnValidate()
        //     begin
        //         IF "E-Way bill Cancel Date" <> '' THEN BEGIN
        //             TimeFormat := 'AM';
        //             EVALUATE(Year, COPYSTR("E-Way bill Cancel Date", 1, 4));
        //             EVALUATE(Month, COPYSTR("E-Way bill Cancel Date", 6, 2));
        //             EVALUATE(Day, COPYSTR("E-Way bill Cancel Date", 9, 2));
        //             EVALUATE(Hour, COPYSTR("E-Way bill Cancel Date", 12, 2));
        //             EVALUATE(Minute, COPYSTR("E-Way bill Cancel Date", 15, 2));
        //             EVALUATE(Sec, COPYSTR("E-Way bill Cancel Date", 18, 2));
        //             IF (Hour >= 12) THEN BEGIN
        //                 Hour := Hour - 12;
        //                 TimeFormat := 'PM';
        //             END;
        //             text1 := FORMAT(Hour) + ':' + FORMAT(Minute) + ':' + FORMAT(Sec) + ' ' + TimeFormat;
        //             EVALUATE(Timee, text1);
        //         END
        //         ELSE BEGIN
        //             recSalesInvHeader.RESET();
        //             recSalesInvHeader.SETRANGE("No.", Rec."No.");
        //             IF recSalesInvHeader.FINDFIRST THEN BEGIN
        //                 recSalesInvHeader."E-Inv. Cancelled Date" := 0DT;
        //                 recSalesInvHeader.MODIFY;
        //             END;
        //         END;
        //         IF "E-Way bill Cancel Date" <> '' THEN BEGIN
        //             recSalesInvHeader.RESET();
        //             recSalesInvHeader.SETRANGE("No.", Rec."No.");
        //             IF recSalesInvHeader.FINDFIRST THEN BEGIN
        //                 recSalesInvHeader."E-Inv. Cancelled Date" := CREATEDATETIME(DMY2DATE(Day, Month, Year), Timee);
        //                 recSalesInvHeader.MODIFY;
        //             END;
        //         END;
        //     end;
        // }


    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }
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

    var
        PostCode: Record "Post Code";
        recSalesInvHeader: Record "Sales Invoice Header";
        Day: Integer;
        Month: Integer;
        Year: Integer;
        Timee: Time;
        Minute: Integer;
        Sec: Integer;
        Hour: Integer;
        TimeCalc: Integer;
        TimeFormat: Text;
        text1: Text;
        recSalesCrMemoHeader: Record "Sales Cr.Memo Header";
}
