report 60105 "BarCode & QR-Code"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'BarCode & QR-Code';
    RDLCLayout = 'RDLS\Layouts\Report 60105 BarCode & QR-Code.rdl';
    UseRequestPage = true;

    dataset
    {
        dataitem(Integer; Integer)
        {
            column(EncodeTextCode39; EncodeTextCode39) { }
            column(QRCode; QRCode) { }

            trigger OnPreDataItem()
            begin
                SNO := 0;
            end;

            trigger OnAfterGetRecord()
            begin
                SNO += 1;
                if SNO = 2 then
                    CurrReport.BREAK;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field(Inputtxt; Inputtxt)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        EncodeTextCode39 := CuBarcode.GenerateBarCode39(Inputtxt);
        QRCode := CuBarcode.GenerateQRCode(Inputtxt);
    end;

    var
        EncodeTextCode39: Text;
        Inputtxt: Text;
        SNO: Integer;
        QRCode: Text;
        CuBarcode: Codeunit "BarCode & QRCode";
}