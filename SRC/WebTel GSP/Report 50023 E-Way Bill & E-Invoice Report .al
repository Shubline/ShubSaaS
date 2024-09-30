report 50023 "E-Way Bill & E-Invoice Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(General)
                {
                    field(DocNO; DocNO)
                    {
                        ApplicationArea = All;
                        Caption = 'Document No.';
                    }
                }
            }
        }
    }

    trigger OnInitReport()
    begin

    end;

    trigger OnPreReport()
    begin
        GeneretaeEwayBill();
    end;

    trigger OnPostReport()
    begin

    end;

    var
        DocNO: Code[25];

    procedure GeneretaeEwayBill()
    var
        CUAl: Codeunit WebtelGSp;
    begin
        CUAl.SetDocNo(DocNO);
        CUAl.GetAccessToken();
    end;
}