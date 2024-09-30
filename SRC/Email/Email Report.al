codeunit 90903 "Email Report"
{

    var
        ArrayOfEmailMessage: array[5] of Text;

    procedure FindEmailID(PageNo: Integer; ActionName: Text[50]): Record "Email ID"
    var
        EmailID: Record "Email ID";
    begin
        EmailID.Reset();
        EmailID.SetRange("Page No.", PageNo);
        EmailID.SetRange("Action Name", ActionName);
        if EmailID.FindFirst() then
            exit(EmailID)
        else
            Dialog.Message('Email ID Not Find For this Page and Action');
    end;

    procedure SendEmail(EmailID: Record "Email ID"; RecTableRef: RecordRef)
    var
        ReciepentMail: List of [Text];
        CCmailMail: List of [Text];
        BCCMail: List of [Text];

        EmailList: Record "Emails";

        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        EmailConnector: Enum "Email Connector";
        EmailAccount: Record "Email Account";

        ReportGenerationText: Text;
    begin
        // Adding Email Reciepent
        EmailList.Reset();
        EmailList.SetRange("Email ID", EmailID."Email ID");
        if EmailList.FindSet() then begin
            repeat
                case EmailList."Sender Type" of

                    Emaillist."Sender Type"::"Reciepent Mail":
                        ReciepentMail.Add(EmailList."Email Address");

                    EmailList."Sender Type"::"CC Mail":
                        CCmailMail.Add(EmailList."Email Address");

                    EmailList."Sender Type"::"BCC Mail":
                        BCCMail.Add(EmailList."Email Address");
                end;
            until EmailList.Next() = 0;
        end;

        EmailMessage := EmailContent(EmailID, ReciepentMail, CCmailMail, BCCMail, ReportGenerationText, RecTableRef);

        if EmailID."Open In Email Editor" then
            Email.OpenInEditor(EmailMessage)  // to open popup
        else begin
            // if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then  // for directly sending the mail
            // if EmailAccount.Get(EmailID."Sendor Email Account",EmailConnector::SMTP) Then
            if Email.Send(EmailMessage, EmailID."Sendor Email Account", EmailConnector::SMTP) then
            Message('Email Send');
        end;

    end;

    procedure EmailContent(EmailID: Record "Email ID"; ReciepentMail: List of [Text]; CCmailMail: List of [Text]; BCCMail: List of [Text]; txtB64: Text; RecRef: RecordRef) EmailMessage: Codeunit "Email Message";
    var
        BodyMessage: Text;
        SubjectMessage: Text;
    begin
        // To Create Email Body
        EmailMessage.Create(ReciepentMail, GenerateEmailSubject(RecRef, EmailID), GenerateEmailBody(RecRef), true, CCmailMail, BCCMail);

        // To Add Report as an Attachment
        if EmailID."Attach Report" then begin
            EmailMessage.AddAttachment(Format(RecRef.RecordId) + '.' + ReportFormat(EmailID), 'application/' + ReportFormat(EmailID), GenerateReport(EmailID, RecRef));
        end;

        exit(EmailMessage);
    end;

    procedure GenerateReport(EmailID: Record "Email ID"; RecRef: RecordRef) txtB64: Text;
    var
        TempBlob: Codeunit "Temp Blob";
        cnv64: Codeunit "Base64 Convert";
        InStr: InStream;
        OutStr: OutStream;
        format: ReportFormat;
        parameter: text;
    begin
        Commit();

        case EmailID."Report Format" of
            "Report Format"::Excel:
                begin
                    format := format::Excel;
                end;
            "Report Format"::Html:
                begin
                    format := format::Html;
                end;
            "Report Format"::Pdf:
                begin
                    format := format::Pdf;
                end;
            "Report Format"::Word:
                begin
                    format := format::Word;
                end;
            "Report Format"::Xml:
                begin
                    format := format::Xml;
                end;
        end;

        // To Add Report as an Attachment
        if EmailID."Use Request Page" then begin

            parameter := Report.RunRequestPage(EmailID."Report No."); // to get the parameters from request Page

            if parameter = '' then
                Dialog.Error('Report Cannot be Generated Due to Empty Filters');

            // // Code To Generate Report as Pdf
            TempBlob.CreateOutStream(OutStr);
            Report.SaveAs(EmailID."Report No.", parameter, format, OutStr);
            TempBlob.CreateInStream(InStr);
            txtB64 := cnv64.ToBase64(InStr, true);
        end
        else begin
            // Another way to write if you don't want to run request page
            TempBlob.CreateOutStream(OutStr);
            Report.SaveAs(EmailID."Report No.", '', format, OutStr, RecRef);
            TempBlob.CreateInStream(InStr);
            txtB64 := cnv64.ToBase64(InStr, true);
        end;

        // Code To Generate Report as Pdf
        TempBlob.CreateOutStream(OutStr);

        exit(txtB64)
    end;


    procedure ReportFormat(EmailID: Record "Email ID") ReportType: Text
    begin
        case EmailID."Report Format" of
            "Report Format"::Excel:
                begin
                    exit('xlsx');
                end;
            "Report Format"::Html:
                begin
                    exit('html');
                end;
            "Report Format"::Pdf:
                begin
                    exit('pdf');
                end;
            "Report Format"::Word:
                begin
                    exit('docx');
                end;
            "Report Format"::Xml:
                begin
                    exit('xml');
                end;
        end;
    end;

    procedure GenerateEmailSubject(RecRef: RecordRef; EmailID: Record "Email ID") EmailSubject: Text;
    var
        EmailList: Record "Emails";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        PurchaseHeader: Record "Purchase Header";
    begin
        case RecRef.Number of
            DataBase::"Sales Invoice Header":
                begin
                    RecRef.SetTable(SalesInvoiceHeader);
                    EmailSubject := EmailID.Subject + SalesInvoiceHeader."No.";
                end;
            Database::"Purchase Header":
                begin
                    RecRef.SetTable(PurchaseHeader);
                    EmailSubject := EmailID.Subject + PurchaseHeader."No."
                end;
        end;
    end;

    procedure GenerateEmailBody(RecRef: RecordRef) EmailBody: Text
    var
        BodyMessage: Text;
    begin
        AddEmailHeaderLines(RecRef, EmailBody);
        EmailBody += AddEmailBodyLines(RecRef, BodyMessage);
        // AddEmailBodyLines(RecRef, EmailBody);
        AddEmailFooterLines(EmailBody);
    end;

    local procedure AddEmailHeaderLines(RecRef: RecordRef; var EmailBody: Text)
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        case RecRef.Number of
            DataBase::"Sales Invoice Header":
                begin
                    RecRef.SetTable(SalesInvoiceHeader);
                    EmailBody := 'Dear Customer <b>' + SalesInvoiceHeader."Sell-to Customer Name" + '</b>,</br></br>' +
                        'Please find attached Invoice ' + SalesInvoiceHeader."No." + '</br></br>' +
                        'We will expect you to process it as soon as possible.' + '</br></br></br>';
                end;
            Database::"Purchase Header":
                begin
                    RecRef.SetTable(PurchaseHeader);
                    EmailBody := 'Dear <b>' + PurchaseHeader."Buy-from Vendor Name" + '</b>,</br></br>' +
                    'Please find attached the order confirmation for ' + PurchaseHeader."No." + '</br></br>' +
                     'We will expect you to process it as soon as possible.' + '</br></br></br>';
                end;
        end;
    end;

    local procedure AddEmailBodyLines(RecRef: RecordRef; EmailBody: Text): Text
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        case RecRef.Number of
            DataBase::"Sales Invoice Header":
                begin
                    RecRef.SetTable(SalesInvoiceHeader);
                    SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
                    if SalesInvoiceLine.FindSet() then begin
                        EmailBody := EmailBody + '<table border="1" cellpadding="3" style="border-style: solid; border-width: 1px"> ';
                        EmailBody := EmailBody + '<tr style="background-color:blue;color:white;"> ';
                        EmailBody := EmailBody + '<th>Item No</th>';
                        EmailBody := EmailBody + '<th>Description</th>';
                        EmailBody := EmailBody + '<th>Quantity</th>';
                        EmailBody := EmailBody + '<th>Amount</th>';
                        EmailBody := EmailBody + '</tr>';
                        repeat
                            EmailBody := EmailBody + '<tr border="1" style="border-style: solid; border-width: 1px"> ';
                            EmailBody := EmailBody + '<td>' + SalesInvoiceLine."No." + '</td>';
                            EmailBody := EmailBody + '<td>' + SalesInvoiceLine.Description + '</td>';
                            EmailBody := EmailBody + '<td>' + Format(SalesInvoiceLine.Quantity) + '</td>';
                            EmailBody := EmailBody + '<td>' + Format(SalesInvoiceLine.Amount) + '</td>';
                            EmailBody := EmailBody + '</tr>';
                        until (SalesInvoiceLine.Next() = 0);
                        EmailBody := EmailBody + '</table>';
                        EmailBody := EmailBody + '</br></br>';
                    end;
                end;

            Database::"Purchase Header":
                begin
                    RecRef.SetTable(PurchaseHeader);
                    PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
                    PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                    if PurchaseLine.FindSet() then begin
                        EmailBody := EmailBody + '<table border="1" cellpadding="3" style="border-style: solid; border-width: 1px"> ';
                        EmailBody := EmailBody + '<tr style="background-color:blue;color:white;"> ';
                        EmailBody := EmailBody + '<th>Item No</th>';
                        EmailBody := EmailBody + '<th>Description</th>';
                        EmailBody := EmailBody + '<th>Quantity</th>';
                        EmailBody := EmailBody + '<th>Qty. To Receive</th>';
                        EmailBody := EmailBody + '</tr>';
                        repeat
                            EmailBody := EmailBody + '<tr border="1" style="border-style: solid; border-width: 1px"> ';
                            EmailBody := EmailBody + '<td>' + PurchaseLine."No." + '</td>';
                            EmailBody := EmailBody + '<td>' + PurchaseLine.Description + '</td>';
                            EmailBody := EmailBody + '<td>' + Format(PurchaseLine.Quantity) + '</td>';
                            EmailBody := EmailBody + '<td>' + Format(PurchaseLine."Qty. to Receive") + '</td>';
                            EmailBody := EmailBody + '</tr>';
                        until (PurchaseLine.Next() = 0);
                        EmailBody := EmailBody + '</table>';
                        EmailBody := EmailBody + '</br></br>';
                    end;
                end;
        end;
        exit(EmailBody);
    end;

    local procedure AddEmailFooterLines(var EmailBody: Text)
    var
        CompanyInformation: Record "Company Information";
    begin
        CompanyInformation.Get();
        EmailBody := EmailBody +
         'Kind regards,' +
         '<b></br>' + CompanyInformation.Name + '</b></br>' + CompanyInformation.Address + '</br>' +
         CompanyInformation.City + '</br>' + CompanyInformation."Post Code" + '</br>' +
         CompanyInformation."Country/Region Code" + '</br>' + CompanyInformation."Phone No." + '</br>' +
         CompanyInformation."E-Mail";
    end;
}