page 80002 "Email ID"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Email ID";
    DataCaptionFields = "Email ID";

    layout
    {
        area(Content)
        {
            group("Email IDs")
            {
                field("Email ID"; Rec."Email ID")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Page No."; Rec."Page No.")
                {
                    ApplicationArea = All;
                }
                field("Page Description"; Rec."Page Description")
                {
                    ApplicationArea = All;
                }
                field("Action Name"; Rec."Action Name")
                {
                    ApplicationArea = All;
                }
                field("Sendor Email Address"; Rec."Sendor Email Address")
                {
                    ApplicationArea = All;
                    Editable = false;
                    trigger OnAssistEdit()
                    var
                        EmailAccountPage: Page "Email Account Page";
                        EmailAccount: Record "Email Account";
                    begin
                        Clear(EmailAccountPage);

                        EmailAccountPage.LookupMode := true;
                        if EmailAccountPage.RunModal() = Action::LookupOK then begin
                            EmailAccountPage.GetAccount(EmailAccount);
                            Rec."Sendor Email Account" := EmailAccount."Account Id";
                            Rec."Sendor Email Address" := EmailAccount."Email Address";
                        end;
                    end;
                }
                field("Attach Report"; Rec."Attach Report")
                {
                    ApplicationArea = All;
                }
                field("Report No."; Rec."Report No.")
                {
                    ApplicationArea = All;
                    Editable = Rec."Attach Report";
                }
                field("Report Description"; Rec."Report Description")
                {
                    ApplicationArea = All;
                }
                field("Report Format"; Rec."Report Format")
                {
                    ApplicationArea = All;
                    Editable = Rec."Attach Report";
                }
                field("Use Request Page"; Rec."Use Request Page")
                {
                    ApplicationArea = All;
                    Editable = Rec."Attach Report";
                }
                field("Open In Email Editor"; Rec."Open In Email Editor")
                {
                    ApplicationArea = All;
                }
            }

            group("Email Details")
            {
                Caption = 'Email Details';

                grid("Email Details Grid")
                {
                    group("Email Inner Details")
                    {
                        ShowCaption = false;

                        field("Email Editor"; Rec.Subject)
                        {
                            Caption = 'Message';
                            ApplicationArea = All;
                            ToolTip = 'Specifies the content of the email.';
                            MultiLine = true;

                            trigger OnValidate()
                            begin

                            end;
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Email")
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Image = Email;

                trigger OnAction()
                var
                    EmailCU: Codeunit "Email Report";
                    sales: Record "Sales Invoice Header";
                    EmailID: Record "Email ID";
                    PageNo: Integer;
                    RecRef: RecordRef;
                begin

                end;
            }
        }
    }

    var
        EmailBody: Text;
}
