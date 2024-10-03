codeunit 50003 "Custom Tracking Specification"
{
    TableNo = "Tracking Specification";

    var
        TrackingSpecification: Record "Tracking Specification" temporary;
        IsInIt: Boolean;

    procedure InitTrackingSpecification()
    begin
        IsInIt := true;
        TrackingSpecification.Init();
        TrackingSpecification.Validate("Entry No.", TrackingSpecification.GetLastEntryNo() + 1);
    end;

    procedure SourceID(SourceID: Code[40]; SourceBatchName: Code[40]; SourceRefNo: Integer)
    begin
        IsInitialize();
        TrackingSpecification.Validate("Source ID", SourceID);
        if SourceBatchName <> '' then
            TrackingSpecification.Validate("Source Batch Name", SourceBatchName);
        TrackingSpecification.Validate("Source Ref. No.", SourceRefNo);
    end;

    procedure SourceType(SourceType: Integer; SourceSubType: Integer)
    begin
        IsInitialize();
        TrackingSpecification.Validate("Source Type", SourceType);

        if SourceSubType In [0 .. 10] then begin
            TrackingSpecification.Validate("Source Subtype", SourceSubType)
        end else begin
            Dialog.Error('Source SubType is Invalid');
        end;
    end;

    procedure Reservation(LocationCode: Code[20]; ItemNo: Code[20]; VariantCode: Code[20]; Quantity: Decimal)
    begin
        IsInitialize();
        TrackingSpecification.Validate("Location Code", LocationCode);
        TrackingSpecification.Validate("Item No.", ItemNo);
        TrackingSpecification.Validate("Variant Code", VariantCode);
    end;


    procedure ExitTrackingSpecification() Tracking: Record "Tracking Specification"
    begin
        TrackingSpecification.Insert(true);
        exit(TrackingSpecification);
    end;
    
    local procedure IsInitialize()
    begin
        if not IsInIt then
            Dialog.Error('First Intialize the Reservation Entry Use : "InitTrackingSpecification"');
    end;

    /////////////////////////////////////////////////////////////////////////////////////////////////////


    procedure CallItemTracking(PurchLine: Record "Purchase Line"; ItemNo: Code[20]; ItemDescription: Text[100]; LocationCode: Code[10]; VariantCode: Code[10]; BinCode: Code[20]; QtyPerUoM: Decimal)
    var
        TrackingSpecification: Record "Tracking Specification";
        ItemTrackingLines: Page "Item Tracking Lines";
    begin
        TrackingSpecification.Init();

        TrackingSpecification."Item No." := ItemNo;
        TrackingSpecification.Description := ItemDescription;
        TrackingSpecification."Location Code" := LocationCode;
        TrackingSpecification."Variant Code" := VariantCode;
        TrackingSpecification."Bin Code" := BinCode;
        TrackingSpecification."Qty. per Unit of Measure" := QtyPerUoM;

        TrackingSpecification.SetSource(Database::"Purchase Line", PurchLine."Document Type".AsInteger(), PurchLine."Document No.", PurchLine."Line No.", '', 0);


        TrackingSpecification.SetQuantities(
          PurchLine."Quantity (Base)", PurchLine."Return Qty. to Ship", PurchLine."Return Qty. to Ship (Base)",
          PurchLine."Qty. to Invoice", PurchLine."Qty. to Invoice (Base)", PurchLine."Return Qty. Shipped (Base)",
          PurchLine."Qty. Invoiced (Base)");


        ItemTrackingLines.SetSourceSpec(TrackingSpecification, PurchLine."Expected Receipt Date");
        ItemTrackingLines.RunModal();
    End;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", OnAfterSignFactor, '', false, false)]
    local procedure "Create Reserv. Entry_OnAfterSignFactor"(ReservationEntry: Record "Reservation Entry"; var Sign: Integer)
    begin
        case ReservationEntry."Source Type" of
            Database::"Sales Line":
                if ReservationEntry."Source Subtype" in [3, 5] then // Credit memo, Return Order = supply
                    Sign := 1
                else
                    Sign := -1;
        end;
    end;




}
