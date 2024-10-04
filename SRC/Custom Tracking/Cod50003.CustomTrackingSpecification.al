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

    procedure SetItemData(ItemNo: Code[20]; ItemDescription: Text[100]; LocationCode: Code[10]; VariantCode: Code[10]; BinCode: Code[20]; QtyPerUoM: Decimal)
    begin
        IsInitialize();
        TrackingSpecification."Item No." := ItemNo;
        TrackingSpecification.Description := ItemDescription;
        TrackingSpecification."Location Code" := LocationCode;
        TrackingSpecification."Variant Code" := VariantCode;
        TrackingSpecification."Bin Code" := BinCode;
        TrackingSpecification."Qty. per Unit of Measure" := QtyPerUoM;
    end;

    procedure SetQuantities(QtyBase: Decimal; QtyToHandle: Decimal; QtyToHandleBase: Decimal; QtyToInvoice: Decimal; QtyToInvoiceBase: Decimal; QtyHandledBase: Decimal; QtyInvoicedBase: Decimal)
    begin
        IsInitialize();
        TrackingSpecification."Quantity (Base)" := QtyBase;
        TrackingSpecification."Qty. to Handle" := QtyToHandle;
        TrackingSpecification."Qty. to Handle (Base)" := QtyToHandleBase;
        TrackingSpecification."Qty. to Invoice" := QtyToInvoice;
        TrackingSpecification."Qty. to Invoice (Base)" := QtyToInvoiceBase;
        TrackingSpecification."Quantity Handled (Base)" := QtyHandledBase;
        TrackingSpecification."Quantity Invoiced (Base)" := QtyInvoicedBase;
    end;

    procedure SetSourceType(SourceType: Integer; SourceSubType: Integer)
    begin
        IsInitialize();
        TrackingSpecification.Validate("Source Type", SourceType);

        if SourceSubType In [0 .. 10] then begin
            TrackingSpecification.Validate("Source Subtype", SourceSubType)
        end else begin
            Dialog.Error('Source SubType is Invalid');
        end;
    end;

    procedure SetSourceID(SourceID: Code[40]; SourceBatchName: Code[40]; SourceRefNo: Integer)
    begin
        IsInitialize();
        TrackingSpecification.Validate("Source ID", SourceID);
        if SourceBatchName <> '' then
            TrackingSpecification.Validate("Source Batch Name", SourceBatchName);
        TrackingSpecification.Validate("Source Ref. No.", SourceRefNo);
    end;

    procedure CallItemTrackingLines()
    var
        ItemTrackingLines: Page "Item Tracking Lines";
    begin
        ItemTrackingLines.SetSourceSpec(TrackingSpecification, WorkDate());
        ItemTrackingLines.RunModal();
    end;

    procedure ExitTrackingSpecification() TrackingSpecificationLines: Record "Tracking Specification"
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



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", OnAfterSignFactor, '', false, false)]
    local procedure "Create Reserv. Entry_OnAfterSignFactor"(ReservationEntry: Record "Reservation Entry"; var Sign: Integer)
    begin
        case ReservationEntry."Source Type" of
            Database::"Karigar Issue Line":
                if ReservationEntry."Source Subtype" in [0, 1] then // Credit memo, Return Order = supply
                    Sign := 1
                else
                    Sign := -1;
        end;
    end;

    // procedure CallItemTracking(PurchLine: Record "Purchase Line"; ItemNo: Code[20]; ItemDescription: Text[100]; LocationCode: Code[10]; VariantCode: Code[10]; BinCode: Code[20]; QtyPerUoM: Decimal)
    // var
    //     TrackingSpecification: Record "Tracking Specification";
    //     ItemTrackingLines: Page "Item Tracking Lines";
    // begin
    //     TrackingSpecification.Init();

    //     TrackingSpecification.SetItemData(ItemNo, ItemDescription, LocationCode, VariantCode, BinCode, QtyPerUoM);

    //     TrackingSpecification.SetSource(Database::"Purchase Line", PurchLine."Document Type".AsInteger(), PurchLine."Document No.", PurchLine."Line No.", '', 0);

    //     TrackingSpecification.SetQuantities(
    //       PurchLine."Quantity (Base)", PurchLine."Return Qty. to Ship", PurchLine."Return Qty. to Ship (Base)",
    //       PurchLine."Qty. to Invoice", PurchLine."Qty. to Invoice (Base)", PurchLine."Return Qty. Shipped (Base)",
    //       PurchLine."Qty. Invoiced (Base)");

    //     ItemTrackingLines.SetSourceSpec(TrackingSpecification, PurchLine."Expected Receipt Date");
    //     ItemTrackingLines.RunModal();
    // End;

}
