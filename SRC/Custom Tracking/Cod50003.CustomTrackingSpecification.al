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

    procedure SetSourceID(SourceID: Code[40]; SourceBatchName: Code[40]; SourceRefNo: Integer; SourceProdOrderLine: Integer)
    begin
        IsInitialize();
        TrackingSpecification.Validate("Source ID", SourceID);
        if SourceBatchName <> '' then
            TrackingSpecification.Validate("Source Batch Name", SourceBatchName);
        TrackingSpecification.Validate("Source Ref. No.", SourceRefNo);
        TrackingSpecification.Validate("Source Prod. Order Line", SourceProdOrderLine);
    end;

    procedure SetItemData(ItemNo: Code[20]; ItemDescription: Text[100]; LocationCode: Code[10]; VariantCode: Code[10]; BinCode: Code[20]; QtyPerUoM: Decimal)
    begin
        IsInitialize();
        TrackingSpecification.Validate("Item No.", ItemNo);
        TrackingSpecification.Validate(Description, ItemDescription);
        TrackingSpecification.Validate("Location Code", LocationCode);
        TrackingSpecification.Validate("Variant Code", VariantCode);
        TrackingSpecification.Validate("Bin Code", BinCode);
        TrackingSpecification.Validate("Qty. per Unit of Measure", QtyPerUoM);
    end;

    procedure SetQuantities(QtyBase: Decimal; QtyToHandle: Decimal; QtyToHandleBase: Decimal; QtyToInvoice: Decimal; QtyToInvoiceBase: Decimal; QtyHandledBase: Decimal; QtyInvoicedBase: Decimal)
    begin
        IsInitialize();
        TrackingSpecification.Validate("Quantity (Base)", QtyBase);
        TrackingSpecification.Validate("Qty. to Handle", QtyToHandle);
        TrackingSpecification.Validate("Qty. to Handle (Base)", QtyToHandleBase);
        TrackingSpecification.Validate("Qty. to Invoice", QtyToInvoice);
        TrackingSpecification.Validate("Qty. to Invoice (Base)", QtyToInvoiceBase);
        // TrackingSpecification.Validate("Quantity Handled (Base)" , QtyHandledBase);
        // TrackingSpecification.Validate("Quantity Invoiced (Base)" , QtyInvoicedBase);
    end;

    procedure CallItemTrackingLines()
    var
        ItemTrackingLines: Page "Item Tracking Lines";
        ReservationEntry: Record "Reservation Entry";
        RunMode: Enum "Item Tracking Run Mode";
        LookupMode: Enum "Item Tracking Type";
    begin
        ReservationEntry := FindReservationEntry(TrackingSpecification."Source Type", TrackingSpecification."Source Subtype", TrackingSpecification."Source ID", TrackingSpecification."Source Batch Name", TrackingSpecification."Source Ref. No.", TrackingSpecification."Source Prod. Order Line", true);

        if ReservationEntry."Source ID" <> '' then begin

            // ItemTrackingLines.GetRunMode()
            // ItemTrackingLines.SetRunMode();
            // ItemTrackingLines.LookupAvailable(LookupMode::"Lot No.");

            CopyTrackingFromReservEntry(ReservationEntry);

            ItemTrackingLines.SetSourceSpec(TrackingSpecification, WorkDate());
            ItemTrackingLines.RunModal();

        end else begin
            ItemTrackingLines.SetSourceSpec(TrackingSpecification, WorkDate());
            ItemTrackingLines.RunModal();
        end;
    end;


    procedure ExitTrackingSpecification() TrackingSpecificationLines: Record "Tracking Specification"
    begin
        TrackingSpecification.Insert(true);
        exit(TrackingSpecification);
    end;

    procedure DeleteReservation(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer; SourceBatchName: Code[10]; SourceProdOrderLine: Integer)
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        ReservationEntry := FindReservationEntry(SourceType, SourceSubtype, SourceID, SourceBatchName, SourceRefNo, SourceProdOrderLine, true);

        if ReservationEntry."Source ID" <> '' then begin
            if Dialog.Confirm('Do You Want to Delete Item Tracking Lines', true) then begin
                repeat
                    ReservationEntry.Delete(True);
                until
                ReservationEntry.Next() = 0;
            end;
        end else begin

        end;
    end;

    local procedure IsInitialize()
    begin
        if not IsInIt then
            Dialog.Error('First Intialize the Reservation Entry Use : "InitTrackingSpecification"');
    end;

    local procedure FindReservationEntry(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[40]; SourceBatchName: Code[40]; SourceRefNo: Integer; SourceProdOrderLine: Integer; HideDialog: Boolean) ReservationEntry: Record "Reservation Entry"
    begin
        Clear(ReservationEntry);
        ReservationEntry.SetRange("Source Type", SourceType);
        ReservationEntry.SetRange("Source Subtype", SourceSubtype);
        ReservationEntry.SetRange("Source ID", SourceID);
        ReservationEntry.SetRange("Source Batch Name", SourceBatchName);
        ReservationEntry.SetRange("Source Ref. No.", SourceRefNo);
        ReservationEntry.SetRange("Source Prod. Order Line", SourceProdOrderLine);
        if ReservationEntry.FindFirst() then begin
            exit(ReservationEntry);
        end else begin
            if Not HideDialog then
                Dialog.Message('Could Not Found Reservation Entries For the Record');
        end;
    end;

    local procedure IsTrackingExists(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[40]; SourceBatchName: Code[40]; SourceRefNo: Integer; SourceProdOrderLine: Integer) IsReservationExists: Boolean
    var
        ReservationEntry: Record "Reservation Entry";
        IsEmpty: Boolean;
    begin

        ReservationEntry := FindReservationEntry(SourceType, SourceSubtype, SourceID, SourceBatchName, SourceRefNo, SourceProdOrderLine, true);

        if ReservationEntry."Source ID" <> '' then begin
            IsReservationExists := true;
        end else begin
            IsReservationExists := false;
        end;

        exit(IsReservationExists);
    end;

    local procedure CopyTrackingFromReservEntry(ReservationEntry: Record "Reservation Entry")
    var
    begin
        Clear(TrackingSpecification);

        begin
            repeat
                Clear(TrackingSpecification);

                InitTrackingSpecification();

                SetSourceType(ReservationEntry."Source Type", ReservationEntry."Source Subtype");
                SetSourceID(ReservationEntry."Source ID", ReservationEntry."Source Batch Name", ReservationEntry."Source Ref. No.", ReservationEntry."Source Prod. Order Line");

                SetItemData(ReservationEntry."Item No.", ReservationEntry.Description, ReservationEntry."Location Code", ReservationEntry."Variant Code", '', ReservationEntry."Qty. per Unit of Measure");

                TrackingSpecification.Validate("Quantity (Base)", Abs(ReservationEntry."Quantity (Base)"));
                // TrackingSpecification.Validate("Quantity Handled (Base)" , Abs(ReservationEntry.Quantity) );
                TrackingSpecification.Validate("Quantity Invoiced (Base)", Abs(ReservationEntry."Quantity Invoiced (Base)"));

                TrackingSpecification.Validate("Lot No.", ReservationEntry."Lot No.");
                TrackingSpecification.Validate("Serial No.", ReservationEntry."Serial No.");
                TrackingSpecification.Validate("Package No.", ReservationEntry."Package No.");
                TrackingSpecification.Validate("New Lot No.", ReservationEntry."New Lot No.");
                TrackingSpecification.Validate("New Serial No.", ReservationEntry."New Serial No.");
                TrackingSpecification.Validate("New Package No.", ReservationEntry."New Package No.");

                TrackingSpecification.Validate(Positive, ReservationEntry.Positive);

                TrackingSpecification.Validate("Item Ledger Entry No.", ReservationEntry."Item Ledger Entry No.");

                TrackingSpecification.Validate("Creation Date", ReservationEntry."Creation Date");
                TrackingSpecification.Validate("Warranty Date", ReservationEntry."Warranty Date");
                // TrackingSpecification.Validate("Expiration Date", ReservationEntry."Expiration Date");
                // TrackingSpecification.Validate("New Expiration Date", ReservationEntry."New Expiration Date");

                TrackingSpecification.Insert();

            until
            ReservationEntry.Next() = 0;
        end;
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
