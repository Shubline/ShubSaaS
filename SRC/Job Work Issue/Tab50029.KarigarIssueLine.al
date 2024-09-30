table 50029 "Karigar Issue Line"
{
    Caption = 'Karigar Issue Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Issue No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Item."No.";
            NotBlank = true;
            trigger OnValidate()
            var
                Item: Record Item;
            begin
                if Item.Get("Item No.") then begin
                    Validate("Item Description", Item.Description);
                    Validate(UOM, Item."Base Unit of Measure");
                    Validate(Rate, Item."Unit Cost");
                    Clear("Variant Code");
                    Clear(Quantity);
                    Clear("Alternate Quantity");
                end;
            end;
        }
        field(4; "Item Description"; Text[200])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(5; "Variant Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 3 : 3;
            trigger OnValidate()
            begin
                Amount := Rate * Quantity;
            end;
        }
        field(7; "Alternate Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 3:3;
        }
        field(8; "UOM"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(9; "Rate"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Amount := Rate * Quantity;
            end;
        }
        field(10; "Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Rate := Amount / Quantity;
            end;
        }
        field(11; Alloy; Boolean)
        {
            DataClassification = CustomerContent;
        }

    }


    keys
    {
        key(PK; "Issue No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(Dropdown; "Issue No.", "Line No.", "Item No.", "Variant Code", "Item Description", Quantity)
        {
        }
        fieldgroup(Brick; "Issue No.", "Line No.", "Item No.", "Variant Code", "Item Description", Quantity)
        {
        }
    }

    trigger OnDelete()
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        Clear(ReservationEntry);
        ReservationEntry.SetRange("Source ID", Rec."Issue No.");
        if ReservationEntry.FindSet() then begin
            repeat
                ReservationEntry.Delete(true);
            until ReservationEntry.Next() = 0;
        end;
    end;

    procedure IsLotEditable(): Boolean
    var
        Item: Record Item;
        KarigarIssueLine: Record "Karigar Issue Line";
    begin
        if Item.Get(Rec."Item No.") then begin
            if Item."Item Tracking Code" <> '' then
                exit(true)
            else
                exit(false);
        end;
    end;
}
