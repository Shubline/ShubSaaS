codeunit 60004 "BarCode & QRCode"
{
    trigger OnRun()
    begin

    end;

    procedure GenerateBarCode39(BarcodeString: Code[40]) EncodeTextCode39: Text
    var
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeFontProvider: Interface "Barcode Font Provider";
    begin
        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
        BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
        EncodeTextCode39 := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
    end;

    procedure GenerateQRCode(QRcodeString: Text) QRCode: Text
    var
        BarcodeSymbology2D: Enum "Barcode Symbology 2D";
        BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
    begin
        BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
        BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
        QRCode := BarcodeFontProvider2D.EncodeFont(QRcodeString, BarcodeSymbology2D);
    end;

    procedure GenerateQRImage(QRcodeString: Code[200]): InStream
    var
        InStr: InStream;
        TempBlob: Codeunit "Temp Blob";
        QRGenerator: Codeunit "QR Generator";
    begin
        TempBlob.CreateInStream(InStr);
        QRGenerator.GenerateQRCodeImage(QRcodeString, TempBlob);
        // Image.ImportStream(InStr, 'QR code', 'image/jpeg');
        exit(InStr);
    end;
}