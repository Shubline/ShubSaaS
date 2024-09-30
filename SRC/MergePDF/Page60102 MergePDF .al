page 60102 MergePDF
{
    Caption = 'Merge PDF';
    PageType = CardPart;
    UsageCategory = Administration;
    SourceTable = Integer;
    SourceTableTemporary = true;
    InsertAllowed = false;
    DelayedInsert = true;
    ApplicationArea = all;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            usercontrol(PDF; PDF)
            {
                ApplicationArea = all;

                trigger DownloadPDF(pdfToNav: text)
                var
                    Convert64: Codeunit "Base64 Convert";
                    TempBlob: Codeunit "Temp Blob";
                    Ins: InStream;
                    Outs: OutStream;
                begin
                    if pdfToNav <> '' then begin
                        Clear(TempBlob);
                        TempBlob.CreateInStream(Ins);
                        TempBlob.CreateOutStream(Outs);
                        Convert64.FromBase64(pdfToNav, Outs);
                        DownloadFromStream(Ins, DialogTitle1, ToFolder1, ToFilter1, ToFile1);
                    end;
                end;
            }

            usercontrol("ALButton2"; ALButton)
            {
                Visible = true;
                ApplicationArea = All;


                trigger OnLoad()
                begin
                    CurrPage.ALButton2.SetOption('caption', 'Merge PDF');
                    CurrPage.ALButton2.SetOption('title', 'This is a vanilia Javascript Button shubham');
                    CurrPage.ALButton2.SetOption('type', 'primary');
                end;

                trigger OnClick(buttonId: Text)
                begin
                    DownloadPDF('Download', 'D:\Shubham', '', 'Merge file' + '.pdf');
                    MergePDF();
                    Message('Primary Button Clicked!');
                end;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(PurchaseOrder)
            {
                ApplicationArea = All;
                Caption = 'Add Purchase Order';
                Image = Order;

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    Recref1: RecordRef;
                begin
                    //Get any record
                    PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
                    PurchaseHeader.FindFirst();
                    PurchaseHeader.SetRange("No.", PurchaseHeader."No.");
                    Recref1.GetTable(PurchaseHeader);
                    AddReportToMerge(60101, Recref1);
                    Message(DocumentAdded, PurchaseHeader."No.");
                end;
            }
            action(SalesInvoice)
            {
                ApplicationArea = All;
                Caption = 'Add Posted Sales Invoice';
                Image = Order;

                trigger OnAction()
                var
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                    Recref2: RecordRef;
                begin
                    SalesInvoiceHeader.FindFirst();
                    SalesInvoiceHeader.SetRange("No.", SalesInvoiceHeader."No.");
                    Recref2.GetTable(SalesInvoiceHeader);
                    AddReportToMerge(60102, Recref2);
                    Message(DocumentAdded, SalesInvoiceHeader."No.");
                end;
            }
            action(Merge)
            {
                ApplicationArea = All;
                Caption = 'Merge documents';
                Image = Print;

                trigger OnAction()
                begin
                    DownloadPDF('Download', 'D:\Shubham', '', Navtext + '.pdf');
                    MergePDF();
                end;
            }
            action(Clear)
            {
                ApplicationArea = All;
                Caption = 'Clear documents';
                Image = Delete;

                trigger OnAction()
                begin
                    ClearPDF();
                end;
            }
        }
    }

    var
        DocumentAdded: Label 'Document %1 added';
        PDF: ControlAddIn PDF;
        Navtext: Text;

    //HOW TO USE
    //Just call the AddReportToMerge or AddBase64pdf functions as many times as needed and later get call the GetJArray function.
    //You will get an array with all your pdfs in base64 to provide to the javascript function of the controladd-in
    var
        JObjectPDFToMerge: JsonObject;
        JArrayPDFToMerge: JsonArray;
        JObjectPDF: JsonObject;

    protected var
        DialogTitle1: Text;
        ToFolder1: Text;
        ToFilter1: Text;
        ToFile1: Text;

    procedure AddReportToMerge(ReportID: Integer; RecRef: RecordRef)
    var
        Tempblob: Codeunit "Temp Blob";
        Ins: InStream;
        Outs: OutStream;
        Parameters: Text;
        Convert: Codeunit "Base64 Convert";
    begin
        Tempblob.CreateInStream(Ins);
        Tempblob.CreateOutStream(Outs);
        Parameters := '';
        Report.SaveAs(ReportID, Parameters, ReportFormat::Pdf, Outs, RecRef);
        Clear(JObjectPDFToMerge);
        JObjectPDFToMerge.Add('pdf', Convert.ToBase64(Ins));
        JArrayPDFToMerge.Add(JObjectPDFToMerge);
    end;

    procedure AddBase64pdf(base64pdf: text)
    begin
        Clear(JObjectPDFToMerge);
        JObjectPDFToMerge.Add('pdf', base64pdf);
        JArrayPDFToMerge.Add(JObjectPDFToMerge);
    end;

    procedure MergePDF()
    begin
        //To check the JsonArray
        CurrPage.PDF.MergePDF(format(GetJArray()));
    end;

    procedure DownloadPDF(DialogTitle: Text; ToFolder: Text; ToFilter: Text; ToFile: Text)
    begin
        DialogTitle1 := DialogTitle;
        ToFolder1 := ToFolder;
        ToFilter1 := ToFilter;
        ToFile1 := ToFile;
    end;

    procedure ClearPDF()
    begin
        Clear(JArrayPDFToMerge);
    end;

    procedure GetJArray() JArrayPDF: JsonArray;
    begin
        JArrayPDF := JArrayPDFToMerge;
    end;
}