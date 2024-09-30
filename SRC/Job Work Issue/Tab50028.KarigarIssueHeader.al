table 50028 "Karigar Issue Header"
{
    Caption = 'Karigar Issue Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Issue No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Issue Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Karigar No."; Code[20])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                Vendor: Record Vendor;
            begin
                if Vendor.Get("Karigar No.") then begin
                    "Karigar Name" := Vendor.Name;
                    "To Location" := Vendor."Vendor Location";
                end;
            end;
        }
        field(4; "Karigar Name"; Text[200])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(5; "From Location"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Location.Code;
        }
        field(6; "To Location"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Location.Code where("Subcontracting Location" = const(true));
        }
       
        field(8; "Remark"; Text[2000])
        {
            DataClassification = CustomerContent;
        }
       
        field(12; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                Rec.ShowDocDim();
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }
        field(13; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(14; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(15; "Pre Alloy Issue"; Boolean)
        {
            DataClassification = CustomerContent;
        }
       

        field(50010; "Posted Karigar Issue No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Issue No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(Dropdown; "Issue No.", "Karigar No.", "Karigar Name", "From Location", "To Location")
        {
        }
        fieldgroup(Brick; "Issue No.", "Karigar No.", "Karigar Name", "From Location", "To Location")
        {
        }
    }

    trigger OnInsert()
    var
        Locaion: Record Location;
        UserSetup: Record "User Setup";
        NoSeries: Codeunit "No. Series - Batch";
    begin
      
    end;

    trigger OnDelete()
    var
        KarigarIssueLine: Record "Karigar Issue Line";
    begin
        Clear(KarigarIssueLine);
        KarigarIssueLine.SetRange("Issue No.", Rec."Issue No.");
        if KarigarIssueLine.FindSet() then begin
            repeat
                KarigarIssueLine.Delete(True)
            until KarigarIssueLine.Next() = 0;
        end;
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            Rec, "Dimension Set ID", StrSubstNo('%1 %2', TableCaption(), "Issue No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        if OldDimSetID <> "Dimension Set ID" then begin
            Modify();
            //     if TransferLinesExist() then
            //         UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin

        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");

        if OldDimSetID <> "Dimension Set ID" then begin
            Modify();
            //     if TransferLinesExist() then
            //         UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;

    end;

    procedure KarigarIssueLinesExist(): Boolean
    Var
        KarigarIssueLine: Record "Karigar Issue Line";
    begin
        KarigarIssueLine.Reset();
        KarigarIssueLine.SetRange("Issue No.", "Issue No.");
        exit(KarigarIssueLine.FindFirst());
    end;

    var
        DimMgt: Codeunit DimensionManagement;


}
