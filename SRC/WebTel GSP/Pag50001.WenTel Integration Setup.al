page 60024 "Webtel Integration Setup"
{
    PageType = Card;
    ApplicationArea = All;
    Caption = 'Webtel Integration Setup';
    UsageCategory = Administration;
    SourceTable = "Webtel Integration Setup";

    layout
    {
        area(Content)
        {
            group("URL")
            {
                field("URL to Generate IRN"; Rec."URL to Generate IRN") { }
                field("URL to Generate Eway-Invoice"; Rec."URL to Generate Eway-Invoice") { }
                field("URL to Cancel IRN"; Rec."URL to Cancel IRN") { }
                field("URL to Print Eway-Invoice"; Rec."URL to Print Eway-Invoice") { }
            }
            group("WebTel Credentials")
            {
                field(CDKEY; Rec.CDKEY) { }
                field(EFUSERNAME; Rec.EFUSERNAME) { }
                field(EFPASSWORD; Rec.EFPASSWORD) { }
            }
            group("MPJ User Credentials")
            {
                Visible = IsVisible;
                field(EINVUSERNAME; Rec.EINVUSERNAME) { }
                field(EINVPASSWORD; Rec.EINVPASSWORD) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("E-Invoice Transcation")
            {
                ApplicationArea = All;
                Caption = 'E-Invoice Transcation', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = LedgerEntries;

                trigger OnAction()
                begin

                end;
            }

            action("MPJ Credentials")
            {
                ApplicationArea = All;
                Caption = 'MPJ Credentials', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Lock;

                trigger OnAction()
                var
                begin
                    IsVisible := true;
                end;
            }
        }
    }

    var
        IsVisible: Boolean;
}