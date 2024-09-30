codeunit 80010 "Email Report By Shubham"
{
    trigger OnRun()
    begin
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesShptHeaderInsert', '', false, false)]

    local procedure OnBeforeSalesShptHeaderInsert(var SalesShptHeader: Record "Sales Shipment Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; var IsHandled: Boolean; var TempWhseRcptHeader: Record "Warehouse Receipt Header" temporary; WhseReceive: Boolean; var TempWhseShptHeader: Record "Warehouse Shipment Header" temporary; WhseShip: Boolean; InvtPickPutaway: Boolean)
    begin
        SalesShptHeader."No." := SalesHeader."No.";
    end;

    procedure "Email Report By Shubham"(ReportID: Integer; RunRequestPage: Boolean; ReportAttachmentName: Text; SubjectMessage: Text; BodyMessage: Text; ReciepentMail: List of [Text]; CCMail: List of [Text]; BCCMail: List of [Text]; RecTableRef: RecordRef)
    var
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";

        TempBlob: Codeunit "Temp Blob";
        cnv64: Codeunit "Base64 Convert";
        InStr: InStream;
        txtB64: Text;
        OutStr: OutStream;
        format: ReportFormat;
        parameter: text;
    begin

        if RunRequestPage then begin
            // to get the parameters from request Page
            parameter := Report.RunRequestPage(ReportID);

            if parameter = '' then
                Dialog.Error('Report Cannot be Generated Due to Empty Filters');

            // Code To Generate Report as Pdf
            TempBlob.CreateOutStream(OutStr);
            Report.SaveAs(ReportID, parameter, format::Pdf, OutStr);
            TempBlob.CreateInStream(InStr);
            txtB64 := cnv64.ToBase64(InStr, true);
        end
        else begin
            // Another way to write if you don't want to run request page
            TempBlob.CreateOutStream(OutStr);
            Report.SaveAs(ReportID, '', format::Pdf, OutStr, RecTableRef);
            TempBlob.CreateInStream(InStr);
            txtB64 := cnv64.ToBase64(InStr, true);
        end;

        // To Create Email Body
        EmailMessage.Create(ReciepentMail, SubjectMessage, BodyMessage, true, CCMail, BCCMail);
        // To Add Report as an Attachment Pdf
        EmailMessage.AddAttachment(ReportAttachmentName + '.pdf', 'application/pdf', txtB64);

        // HTML Body For Email (if Set True)

        // EmailMessage.AppendToBody('<html>');
        // EmailMessage.AppendToBody('<br>');
        // EmailMessage.AppendToBody('<br> </br>');
        // EmailMessage.AppendToBody('Below are the details of Invoice -</br>');
        // EmailMessage.AppendToBody('<table border="1" cellpadding="3" style="border-style: solid; border-width: 1px">');
        // EmailMessage.AppendToBody('<tr style="background-color:blue;color:white;">');
        // EmailMessage.AppendToBody('<td>ERP Code</td>');
        // EmailMessage.AppendToBody('<td>No. 2</td>');
        // EmailMessage.AppendToBody('<td>ALP Code</td>');
        // EmailMessage.AppendToBody('<td>Item Description</td>');
        // EmailMessage.AppendToBody('<td>Party Ref. #</td>');
        // EmailMessage.AppendToBody('<td>Quantity</td>');
        // EmailMessage.AppendToBody('<td>Unit Of Measure Code</td>');
        // EmailMessage.AppendToBody('<td>No. Of Boxes</td>');
        // EmailMessage.AppendToBody('<td>Your Order No.</td>');
        // EmailMessage.AppendToBody('</tr>');
        // EmailMessage.AppendToBody('Erp code value');
        // EmailMessage.AppendToBody('</table>');
        // EmailMessage.AppendToBody('<br></br>');
        // EmailMessage.AppendToBody('Thanks for your valued order and look forward to your continued support.');
        // EmailMessage.AppendToBody('</br>');
        // EmailMessage.AppendToBody('</html>');


        //Email.OpenInEditor(EmailMessage); // to open popup
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default); // for directly sending the mail

        Message('Email Send');

    end;


    /// Method To Call
    //    action("Email Report By Shubham")
    //             {
    //                 Promoted = true;
    //                 PromotedCategory = Process;
    //                 PromotedIsBig = true;
    //                 PromotedOnly = true;
    //                 ApplicationArea = All;
    //                 Image = Email;

    //                 trigger OnAction()
    //                 var
    //                     EmailCU: Codeunit "Email Report By Shubham";
    //                     SubjectMessage: Text;
    //                     BodyMessage: Text;
    //                     ReciepentMail: List of [Text];
    //                     CCMail: List of [Text];
    //                     BCCMail: List of [Text];
    //                     RecRef: RecordRef;
    //                     SIH: Record "Sales Invoice Header";
    //                 begin
    //                     // Email Addresses
    //                     ReciepentMail.Add('shub@gmail.com');
    //                     CCMail.Add('shubham@gmail.com');
    //                     BCCMail.Add('abhishek@gmail.com');

    //                     // Email Body
    //                     SubjectMessage := 'Invoice No. : ' + Rec."No." + ' Has Been Posted ';  // subject of the email
    //                     BodyMessage := 'The Invoice No. : ' + Rec."No." + ' Successfully Posted'; // body of the email

    //                     SIH.Reset();
    //                     SIH.SetRange("No.", Rec."No.");
    //                     if SIH.FindFirst() then
    //                         RecRef.GetTable(SIH);

    //                     EmailCU."Email Report By Shubham"(1306, False, 'Report', SubjectMessage, BodyMessage, ReciepentMail, CCMail, BCCMail, RecRef);

    //                 end;
    //             }


}