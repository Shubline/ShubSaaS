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


    procedure OpenTracking()
    var
        CreateTrackingSpecification: Codeunit "Custom Tracking Specification";
        ItemTracking: Enum "Item Tracking Entry Type";
        ResevationStatus: Enum "Reservation Status";
        ReservationEntry: Record "Reservation Entry";
        TrackingSpecification: Record "Tracking Specification" temporary;
        CustomItemTrackingLines: Page "Custom Item Tracking Lines";
    begin
        Clear(ReservationEntry);
        Clear(TrackingSpecification);
        Clear(CustomItemTrackingLines);
        ReservationEntry.SetRange("Source ID", 'nn');
        if ReservationEntry.FindFirst() then begin
            TrackingSpecification.CopyTrackingFromReservEntry(ReservationEntry);

            CustomItemTrackingLines.SetTableView(TrackingSpecification);
            CustomItemTrackingLines.LookupMode := true;
            if CustomItemTrackingLines.RunModal() = Action::LookupOK then begin

            end else begin

            end;

        end else begin
            Clear(CreateTrackingSpecification);
            CreateTrackingSpecification.InitTrackingSpecification();
            // CreateReservation.SourceID(Rec."Journal Template Name", Rec."Journal Batch Name", LineNo);
            // CreateReservation.DefineTracking(ItemTracking::"Lot No.", LotNo, '', '');
            // CreateReservation.Reservation(ItemJornalLine."Location Code", ItemJornalLine."Item No.", ItemJornalLine."Variant Code", 0);
            CreateTrackingSpecification.SourceType(83, 3);


            TrackingSpecification := CreateTrackingSpecification.ExitTrackingSpecification();
            CustomItemTrackingLines.SetTableView(TrackingSpecification);
            CustomItemTrackingLines.LookupMode := true;
            if CustomItemTrackingLines.RunModal() = Action::LookupOK then begin

            end else begin

            end;
        end;
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

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", OnBeforeRegisterChange, '', false, false)]
    local procedure "Item Tracking Lines_OnBeforeRegisterChange"(var OldTrackingSpecification: Record "Tracking Specification"; var NewTrackingSpecification: Record "Tracking Specification"; CurrentSignFactor: Integer; FormRunMode: Option; var IsHandled: Boolean; CurrentPageIsOpen: Boolean; ChangeType: Option; ModifySharedFields: Boolean; var ResultOK: Boolean)
    begin
        CurrentSignFactor := 1;
    end;





}
