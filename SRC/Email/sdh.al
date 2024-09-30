
codeunit 50007 "SDH Email Subject Body"
{
    procedure GeneratePurchaseOrderEmailSubject(PurchaseHeader: Record "Purchase Header"): Text[250]
    begin
        case PurchaseHeader."Document Type" of
            PurchaseHeader."Document Type"::Order:
                exit('Order Confirmation ' + PurchaseHeader."No.");
        end;
    end;

    procedure GeneratePurchaseOrderEmailBody(PurchaseHeader: Record "Purchase Header"): Text
    var
        CompanyInformation: Record "Company Information";
    begin
        CompanyInformation.Get();
        case PurchaseHeader."Document Type" of
            PurchaseHeader."Document Type"::Order:
                exit('Dear ' + PurchaseHeader."Buy-from Vendor Name" + ',' +
                     'Please find attached the order confirmation for ' + PurchaseHeader."No." +
                     'We will expect you to process it as soon as possible.' +
                     'Kind regards,' +
                     CompanyInformation.Name + ' ' + CompanyInformation.Address + ' ' + CompanyInformation.City + ' ' +
                     CompanyInformation."Post Code" + ' ' + CompanyInformation."Country/Region Code" + ' ' +
                     CompanyInformation."Phone No." + ' ' + CompanyInformation."E-Mail");
        end;
    end;

    procedure GeneratePurchaseOrderHtmlEmailBody(PurchaseHeader: Record "Purchase Header") EmailBody: Text
    begin
        case PurchaseHeader."Document Type" of
            PurchaseHeader."Document Type"::Order:
                begin
                    AddEmailHeaderLines(PurchaseHeader, EmailBody);
                    AddEmailFooterLines(EmailBody);
                end;
        end;
    end;

    procedure GeneratePurchaseOrderDetailedHtmlEmailBody(PurchaseHeader: Record "Purchase Header") EmailBody: Text
    begin
        case PurchaseHeader."Document Type" of
            PurchaseHeader."Document Type"::Order:
                begin
                    AddEmailHeaderLines(PurchaseHeader, EmailBody);
                    AddEmailBodyLines(PurchaseHeader, EmailBody);
                    AddEmailFooterLines(EmailBody);
                end;
        end;
    end;

    procedure GeneratePurchaseOrderEmailBodyReport(PurchaseHeader: Record "Purchase Header") BodyText: Text
    var
        ReportLayoutSelection: Record "Report Layout Selection";
        TempBlob: Codeunit "Temp Blob";
        PurchaseHeaderRecordRef: RecordRef;
        ReportInStream: InStream;
        ReportOutStream: OutStream;
        LayoutCode: Code[20];
        ReportId: Integer;
    begin
        TempBlob.CreateOutStream(ReportOutStream);
        PurchaseHeaderRecordRef := SetPurchaseRecordRef(PurchaseHeader);
        ReportLayoutSelection := GetPurchOrderReportandLayoutCode(ReportId, LayoutCode, false);

        ReportLayoutSelection.SetTempLayoutSelected(LayoutCode);
        Report.SaveAs(ReportId, '', ReportFormat::Html, ReportOutStream, PurchaseHeaderRecordRef);
        ReportLayoutSelection.SetTempLayoutSelected('');

        TempBlob.CreateInStream(ReportInStream);
        ReportInStream.ReadText(BodyText);
    end;

    procedure SetPurchaseRecordRef(PurchaseHeader: Record "Purchase Header") ReturnRecordRef: RecordRef
    var
        PurchaseHeader2: Record "Purchase Header";
    begin
        PurchaseHeader2.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseHeader2.SetRange("No.", PurchaseHeader."No.");
        PurchaseHeader2.Findfirst();
        ReturnRecordRef.GetTable(PurchaseHeader2);
    end;

    procedure GetPurchOrderReportandLayoutCode(var ReportId: Integer; var LayoutCode: Code[20]; IsAttachment: Boolean) ReportLayoutSelection: Record "Report Layout Selection"
    var
        Reportselections: Record "Report Selections";
    begin
        Reportselections.Reset();
        Reportselections.SetRange(Usage, Reportselections.Usage::"P.Order");
        if IsAttachment then
            Reportselections.SetRange("Use for Email Attachment", true)
        else
            Reportselections.SetRange("Use for Email Body", true);
        if Reportselections.Findfirst() then begin
            LayoutCode := Reportselections."Email Body Layout Code";
            ReportId := Reportselections."Report ID";
            if ReportLayoutSelection.Get(ReportId, CompanyName) then;
        end;
    end;

    local procedure AddEmailHeaderLines(PurchaseHeader: Record "Purchase Header"; var EmailBody: Text)
    begin
        EmailBody := 'Dear <b>' + PurchaseHeader."Buy-from Vendor Name" + '</b>,</br></br>' +
                     'Please find attached the order confirmation for ' + PurchaseHeader."No." + '</br></br>' +
                     'We will expect you to process it as soon as possible.' + '</br></br></br>';
    end;

    local procedure AddEmailBodyLines(PurchaseHeader: Record "Purchase Header"; var EmailBody: Text)
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        if PurchaseLine.FindSet() then begin
            EmailBody := EmailBody + '<table border="1">';
            EmailBody := EmailBody + '<tr>';
            EmailBody := EmailBody + '<th>Item No</th>';
            EmailBody := EmailBody + '<th>Description</th>';
            EmailBody := EmailBody + '<th>Quantity</th>';
            EmailBody := EmailBody + '<th>Qty. To Receive</th>';
            EmailBody := EmailBody + '</tr>';
            repeat
                EmailBody := EmailBody + '<tr>';
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

codeunit 50006 "SDH Custom Emails"
{
    procedure SendSimpleEmail()
    begin
        if Confirm('Do you want to send email with Old Style?') then
            SendSimpleEmailOldStyle()
        else
            SendSimpleEmailNewStyle();
    end;

    local procedure SendSimpleEmailOldStyle()
    var
        TempEmailItem: Record "Email Item" temporary;
        EmailScenrio: Enum "Email Scenario";
    begin
        TempEmailItem."Send to" := 'shubham.rajawat.2001@gmail.com';
        TempEmailItem."Subject" := 'Test Email';
        TempEmailItem.SetBodyText('This is a test email.');
        TempEmailItem.Send(false, EmailScenrio::"Purchase Order");
    end;

    local procedure SendSimpleEmailNewStyle()
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        EmailScenrio: Enum "Email Scenario";
    begin
        EmailMessage.Create('shubham.rajawat.2001@gmail.com', 'Test Email', 'This is a test email.');
        Email.OpenInEditor(EmailMessage, EmailScenrio::Default);
        //Email.Send(EmailMessage, EmailScenrio::Default);
    end;

    //Sending Purchase Order Emails
    procedure SendPurchaseOrderEmail(PurchaseHeader: Record "Purchase Header")
    var
        Selection, DefaultSelection : Integer;
        EmailTypeQst: Label 'E-Mail Item,E-Mail Message';
    begin
        DefaultSelection := 1;
        Selection := StrMenu(EmailTypeQst, DefaultSelection);

        Case Selection of
            1:
                SendPurchaseOrderWithEmailItem(PurchaseHeader);
            2:
                SendPurchaseOrderWithEmailMessage(PurchaseHeader);
        end;
    end;

    local procedure SendPurchaseOrderWithEmailItem(PurchaseHeader: Record "Purchase Header")
    var
        TempEmailItem: Record "Email Item" temporary;
        EmailSubjectBody: Codeunit "SDH Email Subject Body";
        EmailScenrio: Enum "Email Scenario";
        Selection, DefaultSelection : Integer;
        EmailBodyTypeQst: Label 'Basic E-Mail Body,HTML E-Mail Body,Detailed HTML E-Mail Body,Word Layout Body,AI Email Body';
    begin
        TempEmailItem."Send to" := 'shubham.rajawat.2001@gmail.com';
        TempEmailItem."Subject" := EmailSubjectBody.GeneratePurchaseOrderEmailSubject(PurchaseHeader);

        DefaultSelection := 1;
        Selection := StrMenu(EmailBodyTypeQst, DefaultSelection);

        Case Selection of
            1:
                TempEmailItem.SetBodyText(EmailSubjectBody.GeneratePurchaseOrderEmailBody(PurchaseHeader));
            2:
                TempEmailItem.SetBodyText(EmailSubjectBody.GeneratePurchaseOrderHtmlEmailBody(PurchaseHeader));
            3:
                TempEmailItem.SetBodyText(EmailSubjectBody.GeneratePurchaseOrderDetailedHtmlEmailBody(PurchaseHeader));
            4:
                TempEmailItem.SetBodyText(EmailSubjectBody.GeneratePurchaseOrderEmailBodyReport(PurchaseHeader));
        end;
        AddAttachmentToPurchaseOrderEmail(TempEmailItem, PurchaseHeader);
        AddMasterAttachmentExcelToPurchaseOrderEmail(TempEmailItem);
        AddRelatedTable(TempEmailItem, PurchaseHeader);
        TempEmailItem.Send(false, EmailScenrio::"Purchase Order");
    end;

    local procedure SendPurchaseOrderWithEmailMessage(PurchaseHeader: Record "Purchase Header")
    var
        EmailMessage: Codeunit "Email Message";
        EmailSubjectBody: Codeunit "SDH Email Subject Body";
        Email: Codeunit Email;
        EmailScenrio: Enum "Email Scenario";
        Selection, DefaultSelection : Integer;
        EmailBodyTypeQst: Label 'Basic E-Mail Body,HTML E-Mail Body,Detailed HTML E-Mail Body,Word Layout Body,AI Email Body';
    begin
        DefaultSelection := 1;
        Selection := StrMenu(EmailBodyTypeQst, DefaultSelection);

        Case Selection of
            1:
                EmailMessage.Create('shubham.rajawat.2001@gmail.com', EmailSubjectBody.GeneratePurchaseOrderEmailSubject(PurchaseHeader),
        EmailSubjectBody.GeneratePurchaseOrderEmailBody(PurchaseHeader), true);
            2:
                EmailMessage.Create('shubham.rajawat.2001@gmail.com', EmailSubjectBody.GeneratePurchaseOrderEmailSubject(PurchaseHeader),
        EmailSubjectBody.GeneratePurchaseOrderHtmlEmailBody(PurchaseHeader), true);
            3:
                EmailMessage.Create('shubham.rajawat.2001@gmail.com', EmailSubjectBody.GeneratePurchaseOrderEmailSubject(PurchaseHeader),
        EmailSubjectBody.GeneratePurchaseOrderDetailedHtmlEmailBody(PurchaseHeader), true);
            4:
                EmailMessage.Create('shubham.rajawat.2001@gmail.com', EmailSubjectBody.GeneratePurchaseOrderEmailSubject(PurchaseHeader),
        EmailSubjectBody.GeneratePurchaseOrderEmailBodyReport(PurchaseHeader), true);
        end;

        AddAttachmentToPurchaseOrderEmail(EmailMessage, PurchaseHeader);
        AddMasterAttachmentExcelToPurchaseOrderEmail(EmailMessage);
        AddRelatedTable(Email, EmailMessage, PurchaseHeader);
        Email.OpenInEditor(EmailMessage, EmailScenrio::Default);
    end;

    local procedure AddAttachmentToPurchaseOrderEmail(var TempEmailItem: Record "Email Item" temporary; PurchaseHeader: Record "Purchase Header")
    var
        ReportLayoutSelection: Record "Report Layout Selection";
        TempBlob: Codeunit "Temp Blob";
        SDHEmailSubjectBody: Codeunit "SDH Email Subject Body";
        PurchaseHeaderRecordRef: RecordRef;
        ReportInStream: InStream;
        ReportOutStream: OutStream;
        LayoutCode: Code[20];
        ReportId: Integer;
        AttachmentFileNameLbl: Label 'Purchase Order %1.pdf', Comment = '%1 Purchase Order No.';
    begin
        TempBlob.CreateOutStream(ReportOutStream);
        PurchaseHeaderRecordRef := SDHEmailSubjectBody.SetPurchaseRecordRef(PurchaseHeader);
        ReportLayoutSelection := SDHEmailSubjectBody.GetPurchOrderReportandLayoutCode(ReportId, LayoutCode, true);

        if LayoutCode <> '' then begin
            ReportLayoutSelection.SetTempLayoutSelected(LayoutCode);
            Report.SaveAs(ReportId, '', ReportFormat::Pdf, ReportOutStream, PurchaseHeaderRecordRef);
            ReportLayoutSelection.SetTempLayoutSelected('');
        end else
            Report.SaveAs(ReportId, '', ReportFormat::Pdf, ReportOutStream, PurchaseHeaderRecordRef);

        TempBlob.CreateInStream(ReportInStream);
        TempEmailItem.AddAttachment(ReportInStream, StrSubstNo(AttachmentFileNameLbl, PurchaseHeader."No."));
    end;

    local procedure AddAttachmentToPurchaseOrderEmail(var EmailMessage: Codeunit "Email Message"; PurchaseHeader: Record "Purchase Header")
    var
        ReportLayoutSelection: Record "Report Layout Selection";
        TempBlob: Codeunit "Temp Blob";
        SDHEmailSubjectBody: Codeunit "SDH Email Subject Body";
        PurchaseHeaderRecordRef: RecordRef;
        ReportInStream: InStream;
        ReportOutStream: OutStream;
        LayoutCode: Code[20];
        ReportId: Integer;
        AttachmentFileNameLbl: Label 'Purchase Order %1.pdf', Comment = '%1 Purchase Order No.';
    begin
        TempBlob.CreateOutStream(ReportOutStream);
        PurchaseHeaderRecordRef := SDHEmailSubjectBody.SetPurchaseRecordRef(PurchaseHeader);
        ReportLayoutSelection := SDHEmailSubjectBody.GetPurchOrderReportandLayoutCode(ReportId, LayoutCode, true);

        if LayoutCode <> '' then begin
            ReportLayoutSelection.SetTempLayoutSelected(LayoutCode);
            Report.SaveAs(ReportId, '', ReportFormat::Pdf, ReportOutStream, PurchaseHeaderRecordRef);
            ReportLayoutSelection.SetTempLayoutSelected('');
        end else
            Report.SaveAs(ReportId, '', ReportFormat::Pdf, ReportOutStream, PurchaseHeaderRecordRef);

        TempBlob.CreateInStream(ReportInStream);
        EmailMessage.AddAttachment(StrSubstNo(AttachmentFileNameLbl, PurchaseHeader."No."), '', ReportInStream);
    end;

    local procedure AddMasterAttachmentExcelToPurchaseOrderEmail(var TempEmailItem: Record "Email Item" temporary)
    var
        // SDHExcelMultipleSheets: Codeunit "SDH Excel Multiple Sheets";
        TempBlob: Codeunit "Temp Blob";
        ReportInStream: InStream;
        ReportOutStream: OutStream;
    begin
        TempBlob.CreateOutStream(ReportOutStream);
        TempBlob.CreateInStream(ReportInStream);
        // SDHExcelMultipleSheets.SaveExcelInStream(ReportOutStream);
        TempEmailItem.AddAttachment(ReportInStream, 'Master Data List.xlsx');
    end;

    local procedure AddMasterAttachmentExcelToPurchaseOrderEmail(var EmailMessage: Codeunit "Email Message")
    var
        // SDHExcelMultipleSheets: Codeunit "SDH Excel Multiple Sheets";
        TempBlob: Codeunit "Temp Blob";
        ReportInStream: InStream;
        ReportOutStream: OutStream;
    begin
        TempBlob.CreateOutStream(ReportOutStream);
        TempBlob.CreateInStream(ReportInStream);
        // SDHExcelMultipleSheets.SaveExcelInStream(ReportOutStream);
        EmailMessage.AddAttachment('Master Data List.xlsx', '', ReportInStream);
    end;

    local procedure AddRelatedTable(var TempEmailItem: Record "Email Item" temporary; PurchaseHeader: Record "Purchase Header")
    var
        Vendor: Record Vendor;
        Location: Record Location;
        SourceTables: List of [Integer];
        SourceIDs: List of [Guid];
        SourceRelationTypes: List of [Integer];
    begin
        Vendor.Get(PurchaseHeader."Buy-from Vendor No.");

        SourceTables.Add(Database::"Purchase Header");
        SourceIDs.Add(PurchaseHeader.SystemId);
        SourceRelationTypes.Add(Enum::"Email Relation Type"::"Primary Source".AsInteger());

        SourceTables.Add(Database::"Vendor");
        SourceIDs.Add(Vendor.SystemId);
        SourceRelationTypes.Add(Enum::"Email Relation Type"::"Related Entity".AsInteger());

        if Location.Get(PurchaseHeader."Location Code") then begin
            SourceTables.Add(Database::"Location");
            SourceIDs.Add(Location.SystemId);
            SourceRelationTypes.Add(Enum::"Email Relation Type"::"Related Entity".AsInteger());
        end;

        TempEmailItem.SetSourceDocuments(SourceTables, SourceIDs, SourceRelationTypes);
    end;

    local procedure AddRelatedTable(var Email: Codeunit Email; EmailMessage: Codeunit "Email Message"; PurchaseHeader: Record "Purchase Header")
    var
        Vendor: Record Vendor;
        Location: Record Location;
    begin
        Vendor.Get(PurchaseHeader."Buy-from Vendor No.");
        Email.AddRelation(EmailMessage, Database::"Purchase Header", PurchaseHeader.SystemId, Enum::"Email Relation Type"::"Primary Source", Enum::"Email Relation Origin"::"Compose Context");
        Email.AddRelation(EmailMessage, Database::"Vendor", Vendor.SystemId, Enum::"Email Relation Type"::"Related Entity", Enum::"Email Relation Origin"::"Compose Context");
        if Location.Get(PurchaseHeader."Location Code") then
            Email.AddRelation(EmailMessage, Database::"Location", Location.SystemId, Enum::"Email Relation Type"::"Related Entity", Enum::"Email Relation Origin"::"Compose Context");
    end;
}
