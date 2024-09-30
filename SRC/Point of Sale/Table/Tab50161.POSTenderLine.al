table 50161 "POS Tender Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Receipt No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Tender Line No"; Integer)
        {
            Caption = 'Tender Line';
            DataClassification = ToBeClassified;
        }
        field(4; "Payment Type"; Code[20])
        {
            TableRelation = "Payment Method";
            DataClassification = ToBeClassified;

            trigger OnValidate()
            Var

            begin
                // //Update Amount//
                // AmountToCust := 0;
                // EstimatedHeader.Reset();
                // EstimatedHeader.SetRange("Document No", rec."Document No");
                // if EstimatedHeader.FindFirst() then begin
                //     TenderLine.Reset();
                //     TenderLine.SetRange("Document No", rec."Document No");
                //     if TenderLine.FindSet() then begin
                //         repeat
                //             AmountToCust += TenderLine.Amount;
                //         until TenderLine.Next() = 0;
                //         if AmountToCust <> EstimatedHeader."Amount to Customer" then
                //             rec.Amount := EstimatedHeader."Amount to Customer" - AmountToCust;
                //     end else begin
                //         rec.Amount := EstimatedHeader."Amount to Customer";
                //     end;
                // end;
            end;
        }
        field(5; "Tender Type"; Option)
        {
            OptionMembers = " ","Cash","Cheque","Credit Card","UPI","Credit Note","Gift Voucher","Advance";
            DataClassification = ToBeClassified;
        }

        field(6; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Pre Document No"; Code[20])
        {
            Editable = false;
        }
        field(8; "Posted"; Boolean)
        {
            Editable = false;
        }
        field(9; "Customer Code"; Text[20])
        {
            TableRelation = customer;
            Caption = ' Customer Code';
            Editable = false;
        }
        field(10; "Date"; Date)
        {
            Editable = false;
        }
        field(11; "Scheme Entry"; Boolean)
        {
            Editable = false;
        }
        field(12; "Pre Estimate No."; Code[20])
        {
            Editable = false;
        }
        field(13; "Posted Estimate No."; Code[20])
        {
            Editable = false;
        }
        field(14; "POS Posted"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Pre Receipt No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }

    }
    keys
    {
        key(Pk; "Receipt No.", "Tender Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        PaymentMethod: Record "Payment Method";
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