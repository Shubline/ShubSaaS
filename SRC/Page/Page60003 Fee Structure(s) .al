page 60003 "Fee Structure(s)"
{
    PageType = List;
    CardPageId = 60004;
    ApplicationArea = All;
    SourceTable = "Fee Structure";
    UsageCategory = Lists;
    Editable = false;
    DataCaptionFields = "Class Code";
    RefreshOnActivate = true;
    LinksAllowed = true;
    Caption = 'Fee Structure(s)';

    layout
    {
        area(Content)
        {
            repeater("Fee Details")
            {
                field(Class; Rec."Class Code")
                {
                    ApplicationArea = All;
                }
                field(Descripton; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Admisson Fee"; Rec."Fees Amount")
                {
                    ApplicationArea = All;
                }
                field("Registration Fee"; Rec."New Addmission Charge")
                {
                    ApplicationArea = All;
                }
                field("Transportation Fee"; Rec."Transportaion Charges")
                {
                    ApplicationArea = All;
                }
            }
        }

        area(FactBoxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(Database::"Fee Structure"),
                              "No." = FIELD("Class Code");
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
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

}