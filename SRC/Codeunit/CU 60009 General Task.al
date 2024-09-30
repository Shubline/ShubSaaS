codeunit 60009 "General Task"
{
    procedure Indiantime(Times: Time) FinalTime: Time;
    var
        T: Time;
        Durations: Duration;
    begin
        T := 053000T;
        Durations := t - 000000T;
        FinalTime := Times - Durations;
        exit(FinalTime);
    end;


    procedure DownloadRep()
    var
        InStr: InStream;
        OutStr: OutStream;
        TempBlob: Codeunit "Temp Blob";
        FileMgmt: Codeunit "File Management";
    begin
        Clear(InStr);
        Clear(OutStr);
        Clear(TempBlob);
        TempBlob.CreateInStream(InStr);
        TempBlob.CreateOutStream(OutStr);

        FileMgmt.BLOBExport(TempBlob, 'Stock Staus.pdf', TRUE);
    end;


    // local procedure QueryForStock()
    //     var
    //         querystock: Query "Stock Staus";
    //         
    //         filemgt: Codeunit "File Management";
    //     begin
    //         Clear(querystock);
    //         Clear(TempBlob);
    //         TempBlob.CreateOutStream(Outstr);

    //         querystock.SetFilter(PostingDate, '<=%1', EndDate);
    //         querystock.SetFilter(GlobalDimensionCode, '<>%1', '');

    //         if Rec.Location <> '' then
    //             querystock.SetRange(LocationCode, Rec.Location);
    //         if Rec.Branch <> '' then
    //             querystock.SetRange(GlobalDimensionCode, Rec.Branch);
    //         if Rec."Item Code" <> '' then
    //             querystock.SetRange(ItemNo, Rec."Item Code");

    //         querystock.Open();

    //         while querystock.Read() do begin
    //             querystock.SaveAsCsv(Outstr);
    //         end;

    //         FileMgt.BLOBExport(TempBlob, 'Stock Staus.csv', TRUE);

    //         querystock.Close();
    //     end;
    // }


    procedure CreateReservation()
    var
        CreateReservation: Codeunit "Create Reservation";
        ItemTracking: Enum "Item Tracking Entry Type";
        ResevationStatus: Enum "Reservation Status";
    begin
        Clear(CreateReservation);
        CreateReservation.InitReservation();
        // CreateReservation.SourceID(Rec."Journal Template Name", Rec."Journal Batch Name", LineNo);
        // CreateReservation.DefineTracking(ItemTracking::"Lot No.", LotNo, '', '');
        // CreateReservation.Reservation(ItemJornalLine."Location Code", ItemJornalLine."Item No.", ItemJornalLine."Variant Code", 1);
        CreateReservation.SourceType(83, 3);
        CreateReservation.CreateReservation(false, WorkDate(), ResevationStatus::Prospect);
    end;

    local procedure GetGStRates(GSTGroupCode: Code[20]; HSNCode: Code[20]): Decimal
    var
        GSTSetup: Record "GST Setup";
        TaxSetupMatrixMgmt: Codeunit "Tax Setup Matrix Mgmt.";
        AttributeManagement: Codeunit "Tax Attribute Management";
        RangeAttribute: array[1000] of Boolean;
        AttributeValue: array[1000] of Text;
        AttributeCaption: array[1000] of Text;
        AttributeID: array[1000] of Integer;
        GlobalTaxType: Code[20];
        ColumnCount: Integer;
        TaxRate: Record "Tax Rate";

        CGstTaxRate: Decimal;
        SGstTaxRate: Decimal;
        IGstTaxRate: Decimal;
        GstTaxRate: Decimal;
    begin
        GSTSetup.Get();
        GSTSetup.TestField(GSTSetup."GST Tax Type");
        GlobalTaxType := GSTSetup."GST Tax Type";
        TaxSetupMatrixMgmt.FillColumnArray(GlobalTaxType, AttributeCaption, AttributeValue, RangeAttribute, AttributeID, ColumnCount);

        Clear(TaxRate);
        if TaxRate.FindSet() then begin
            repeat
                TaxSetupMatrixMgmt.FillColumnValue(TaxRate.ID, AttributeValue, RangeAttribute, AttributeID);
                if ((AttributeValue[1] = GSTGroupCode) AND (AttributeValue[2] = HSNCode)) then begin
                    Evaluate(SGstTaxRate, (AttributeValue[7]));
                    Evaluate(CGstTaxRate, (AttributeValue[8]));
                    Evaluate(IGstTaxRate, (AttributeValue[9]));
                    GstTaxRate := (SGstTaxRate + CGstTaxRate + IGstTaxRate);
                    exit(GstTaxRate);
                end;
            until
            TaxRate.Next() = 0;
        end;
    end;

}