page 60001 Students
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Student;
    CardPageId = 60002;
    // ModifyAllowed = false;
    // Editable = false;
    DataCaptionFields = "Addmission No.";
    Caption = 'Students';
    RefreshOnActivate = true;
    LinksAllowed = true;

    layout
    {
        area(Content)
        {
            repeater("Student Details")
            {
                field("Addmission No."; Rec."Addmission No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Nameflow())
                {
                    ApplicationArea = All;
                }
                field("Parent Name"; Rec."Parent Name")
                {
                    ApplicationArea = All;
                }
                field(DOB; Rec.DOB)
                {
                    ApplicationArea = All;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                }
                field(Address2; Rec.Address2)
                {
                    ApplicationArea = All;
                }
                field(PostalCode; Rec."PostalCode")
                {
                    ApplicationArea = All;
                }
                field("Mobile No."; Rec."Mobile No.")
                {
                    ApplicationArea = All;
                }
                field(Transportation; Rec.Transportation)
                {
                    ApplicationArea = All;
                }
                field(class; Rec.class)
                {
                    ApplicationArea = All;
                }
                field(balance; Rec.balance)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
        }

        area(FactBoxes)
        {
            part(Control149; "Student Picture")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Addmission No." = FIELD("Addmission No.");
            }
            part(MergePDF; MergePDF)
            {
                ApplicationArea = Basic, Suite;
            }
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(Database::Student),
                "No." = FIELD("Addmission No.");
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(selected)
            {
                ApplicationArea = All;
                Caption = 'Message', comment = '="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Receipt;

                trigger OnAction()
                begin
                    Message('%1', Rec."Addmission No.");
                end;
            }

            action("Import Excel Sheet")
            {
                ApplicationArea = All;
                Caption = 'Import Excel Sheet', comment = '="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Receipt;

                trigger OnAction()
                var
                    ExcelImport: Codeunit "Excel Import";
                begin
                    Clear(ExcelImport);
                    ExcelImport.ImportExcelSheetDataFromMultipleSheet();
                end;
            }
            action("Copy Notes")
            {
                ApplicationArea = All;
                Caption = 'Copy Notes', comment = '="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Receipt;

                trigger OnAction()
                var
                    CopyLinksAndNotes: Codeunit "Copy Links & Notes";
                    Student: Record Student;
                begin
                    if Student.Get('ADM0018') then
                        CopyLinksAndNotes.CopyLinksAndNotes(Rec.RecordId, Student.RecordId);
                    Message('Done');
                end;
            }

            action("Download PDF")
            {
                ApplicationArea = All;
                Caption = 'Download PDF', comment = '="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Receipt;

                trigger OnAction()
                var
                    ExcelImport: Codeunit "Download PDF From Url";
                    URL: Text;
                begin
                    Clear(ExcelImport);
                    URL := 'http://einvsandbox.webtel.in/PrintHTMLTemplates/e1b610ad117e3fdf9088a96681c1f9955c5e07c51bb1b683aa09b768ba838952.pdf';

                    Rec.PDF.ImportStream(ExcelImport.DownloadPdf(URL, 'Einvoice.pdf'), 'Pdf', 'Pdf/pdf');
                    Rec.Modify();
                end;
            }

            action("Download PDF 2")
            {
                ApplicationArea = All;
                Caption = 'Download PDF 2', comment = '="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Receipt;

                trigger OnAction()
                var
                    ExcelImport: Codeunit "Download PDF From Url";
                    URL: Text;
                    OutStr: OutStream;
                    InStr: InStream;
                    TempBlob: Codeunit "Temp Blob";
                    FileName: Text;
                begin
                    TempBlob.CreateOutStream(OutStr);
                    TempBlob.CreateInStream(InStr);

                    FileName := Rec."Addmission No." + '.pdf';
                    Rec.PDF.ExportStream(OutStr);

                    DownloadFromStream(InStr, 'Download', '', '', FileName);
                end;
            }

            action("Import From Excel Sheet 2")
            {
                ApplicationArea = All;
                Caption = 'Import From Excel Sheet 2', comment = '="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Receipt;

                trigger OnAction()
                var
                    ExcelImport: Codeunit "Excel Import";
                    RowNo: Integer;
                    MaxRowNo: Integer;
                    TempExcelBuffer: Record "Excel Buffer";
                begin
                    Clear(ExcelImport);
                    ExcelImport.GetExcelTable();

                    for RowNo := 2 to 5 do begin
                        if TempExcelBuffer.Get(RowNo, 1) then
                            message(' Value is : %1', TempExcelBuffer."Cell Value as Text");
                    end;
                end;
            }

            action("WebTel integratrion")
            {
                ApplicationArea = All;
                Caption = 'WebTel integratrion', comment = '="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Receipt;

                trigger OnAction()
                var
                    EwayReport: Report "E-Way Bill & E-Invoice Report";
                    txt: Text;
                // TataIntegration
                begin
                    txt := EwayReport.RunRequestPage();
                    EwayReport.GeneretaeEwayBill();
                end;
            }

            action("BarCode")
            {
                ApplicationArea = All;
                Caption = 'BarCode', comment = '="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Receipt;

                trigger OnAction()
                var
                begin
                    Report.Run(60105);
                end;
            }

            action("AmountInWords")
            {
                ApplicationArea = All;
                Caption = 'AmountInWords', comment = '="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Receipt;

                trigger OnAction()
                var
                    RepCheck: Report "Check";
                    NoText: array[2] of Text;
                    AmountInWords: Text;
                begin
                    RepCheck.InitTextVariable();
                    RepCheck.FormatNoText(NoText, 800789456, 'USA');
                    AmountInWords := NoText[1];
                end;
            }

            action("Merge PDF")
            {
                ApplicationArea = All;
                Caption = 'Merge PDF', comment = '="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Receipt;

                trigger OnAction()
                var
                    MergePDF: Page MergePDF;
                    RecRef: RecordRef;
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                    Recref2: RecordRef;
                    int: Record Integer;
                    PDF: ControlAddIn PDF;
                begin
                    SalesInvoiceHeader.FindFirst();
                    SalesInvoiceHeader.SetRange("No.", SalesInvoiceHeader."No.");
                    Recref2.GetTable(SalesInvoiceHeader);

                    Clear(MergePDF);
                    MergePDF.AddReportToMerge(60102, Recref2);
                    MergePDF.AddReportToMerge(60102, Recref2);

                    MergePDF.LookupMode := True;
                    if MergePDF.RunModal() = Action::LookupCancel then begin

                    end;
                end;
            }

            action("Barcode Report")
            {
                ApplicationArea = All;
                Caption = 'Barcode Report', comment = '="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Receipt;

                trigger OnAction()
                var
                    RecRef: RecordRef;
                begin
                    Report.Run(60105);
                end;
            }
        }
    }

    var
        myInt: Integer;
        Length: Integer;
        NewStr: Text[10];
        PostCode: Record "Post Code";
        Editfield: Boolean;
        Checkfield: Boolean;


    procedure AmountInword(Value: Decimal; CurrencyCode: Code[20]) AmountInWords: Text;
    var
        RepCheck: Report "Check";
        NoText: array[2] of Text;
    begin
        RepCheck.InitTextVariable();
        RepCheck.FormatNoText(NoText, Value, CurrencyCode);
        AmountInWords := NoText[1];
        exit(DelChr(AmountInwords, '=', '*'));
    end;

    procedure AmountInwtord()
    var
        TotalInclTaxAmount: Decimal;

        CalcStatistics: Codeunit "Calculate Statistics";
    begin
        // CalcStatistics.GetSalesStatisticsAmount(Rec, TotalInclTaxAmount);
    end;

    local procedure Nameflow(): Text
    begin
        exit(Rec.Name);
    end;


    var
        Globaltxt: Text;

    local procedure PrinterBar(Txt: Text)
    var
        typehelp: Codeunit "Type Helper";
        crlf: Text[2];
    begin
        crlf := typehelp.CRLFSeparator();
        Globaltxt := Txt + crlf;
    end;
}