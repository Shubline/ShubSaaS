codeunit 60011 "Create Reservation"
{
    TableNo = "Reservation Entry";

    var
        ReservationEntry: Record "Reservation Entry";
        IsInIt: Boolean;

    procedure InitReservation()
    begin
        IsInIt := true;
        ReservationEntry.Init();
        ReservationEntry.Validate("Entry No.", ReservationEntry.GetLastEntryNo() + 1);
    end;

    procedure SourceID(SourceID: Code[40]; SourceBatchName: Code[40]; SourceRefNo: Integer)
    begin
        IsInitialize();
        ReservationEntry.Validate("Source ID", SourceID);
        if SourceBatchName <> '' then
            ReservationEntry.Validate("Source Batch Name", SourceBatchName);
        ReservationEntry.Validate("Source Ref. No.", SourceRefNo);
    end;

    procedure SourceType(SourceType: Integer; SourceSubType: Integer)
    begin
        IsInitialize();
        ReservationEntry.Validate("Source Type", SourceType);

        if SourceSubType In [0 .. 10] then begin
            ReservationEntry.Validate("Source Subtype", SourceSubType)
        end else begin
            Dialog.Error('Source SubType is Invalid');
        end;
    end;

    procedure Reservation(LocationCode: Code[20]; ItemNo: Code[20]; VariantCode: Code[20]; Quantity: Decimal)
    begin
        IsInitialize();
        ReservationEntry.Validate("Location Code", LocationCode);
        ReservationEntry.Validate("Item No.", ItemNo);
        ReservationEntry.Validate("Variant Code", VariantCode);
        ReservationEntry.Validate("Quantity (Base)", Quantity);
        ReservationEntry.Validate(Quantity, Quantity);
    end;

    procedure DefineTracking(ItemTracking: Enum "Item Tracking Entry Type"; LotNo: Code[50]; PackingNo: Code[50]; SerialNo: Code[50])
    begin
        IsInitialize();
        ReservationEntry.Validate("Item Tracking", ItemTracking);

        if LotNo <> '' then
            ReservationEntry.Validate("Lot No.", LotNo);

        if PackingNo <> '' then
            ReservationEntry.Validate("Package No.", PackingNo);

        if SerialNo <> '' then
            ReservationEntry.Validate("Serial No.", SerialNo);
    end;

    procedure NewTracking(NewLotNo: Code[50]; NewPackingNo: Code[50]; NewSerialNo: Code[50])
    begin
        IsInitialize();

        if NewLotNo <> '' then
            ReservationEntry.Validate("New Lot No.", NewLotNo);

        if NewPackingNo <> '' then
            ReservationEntry.Validate("New Package No.", NewPackingNo);

        if NewSerialNo <> '' then
            ReservationEntry.Validate("New Serial No.", NewSerialNo);
    end;

    procedure CreateReservation(Positive: Boolean; Date: Date; ResevationStatus: Enum "Reservation Status")
    begin
        IsInitialize();
        ReservationEntry.Validate(Positive, Positive);
        ReservationEntry.Validate("Reservation Status", ResevationStatus);

        if Positive then begin
            ReservationEntry.Validate("Expected Receipt Date", Date)

        end else begin
            ReservationEntry.Validate("Shipment Date", Date);
            ReservationEntry.Validate("Quantity (Base)", ReservationEntry."Quantity (Base)" * -1);
            ReservationEntry.Validate(Quantity, ReservationEntry.Quantity * -1);
        end;

        ReservationEntry.Validate("Creation Date", Date);
        ReservationEntry.Validate("Created By", UserId);
        ReservationEntry.Insert(true);
    end;

    local procedure IsInitialize()
    begin
        if not IsInIt then
            Dialog.Error('First Intialize the Reservation Entry Use : "InitReservation()"');
    end;


    var
        Git: Decimal;
        Vat: Decimal;
        TotalAmount: Decimal;
        TotalVat: Decimal;

}
