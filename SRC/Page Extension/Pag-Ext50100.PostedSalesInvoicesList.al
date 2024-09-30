pageextension 50100 "Posted Sales Invoices Ext1" extends "Posted Sales Invoices"
{
    actions
    {
        addfirst(processing)
        {
            action("Email Shubham")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                Image = Email;

                trigger OnAction()
                var
                    EmailCU: Codeunit "Email Report";
                    sales: Record "Sales Invoice Header";
                    EmailID: Record "Email ID";
                    PageNo: Integer;
                    RecRef: RecordRef;
                    SIH: Record "Sales Invoice Header";
                begin
                    SIH.Reset();
                    SIH.SetRange("No.", Rec."No.");
                    if SIH.FindFirst() then
                    RecRef.GetTable(SIH);

                    // RecRef.Get(Rec.RecordId);
                    Evaluate(PageNo, CopyStr(CurrPage.ObjectId(false), 6));
                    EmailCU.SendEmail(EmailCU.FindEmailID(PageNo, 'Email Shubham'), RecRef);

                end;
            }
            action("Email Report By Shubham")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                Image = Email;

                trigger OnAction()
                var
                    EmailCU: Codeunit "Email Report By Shubham";
                    SubjectMessage: Text;
                    BodyMessage: Text;
                    ReciepentMail: List of [Text];
                    CCMail: List of [Text];
                    BCCMail: List of [Text];
                    RecRef: RecordRef;
                    SIH: Record "Sales Invoice Header";
                begin
                    // Email Addresses
                    ReciepentMail.Add('shubham.rajawat.2001@gmail.com');
                    // CCMail.Add('shubham@gmail.com');
                    // BCCMail.Add('abhishek@gmail.com');

                    // Email Body
                    SubjectMessage := 'Invoice No. : ' + Rec."No." + ' Has Been Posted ';  // subject of the email
                    BodyMessage := 'The Invoice No. : ' + Rec."No." + ' Successfully Posted'; // body of the email

                    SIH.Reset();
                    SIH.SetRange("No.", Rec."No.");
                    if SIH.FindFirst() then
                        RecRef.GetTable(SIH);

                    EmailCU."Email Report By Shubham"(1306, False, 'Report', SubjectMessage, BodyMessage, ReciepentMail, CCMail, BCCMail, RecRef);

                end;
            }

            action("Tax Invoice")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                Image = Email;

                trigger OnAction()
                var
                    PageNo: Integer;
                    RecRef: RecordRef;
                    SIH: Record "Sales Invoice Header";
                begin
                    SIH.Reset();
                    SIH.SetRange("No.", Rec."No.");
                    if SIH.FindFirst() then
                        Report.Run(60102, true, false, SIH);
                end;
            }

            action("Excel Export")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                Image = Export;

                trigger OnAction()
                var
                    SIH: Record "Sales Invoice Header";
                begin
                    SIH.Reset();
                    Report.Run(60104, true, false, SIH);
                end;
            }

        }
    }
}