page 60004 "Fee Structure"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Fee Structure";
    RefreshOnActivate = true;
    LinksAllowed = true;

    layout
    {
        area(Content)
        {
            group("Fee Details")
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
                // field("Quarter Fee"; Rec."Quarter Fee")
                // {
                //     ApplicationArea = All;
                // }
                // field("Total Fee"; Rec."Total Fee")
                // {
                //     ApplicationArea = All;
                //     trigger OnDrillDown()
                //     begin
                //        // Rec."Total Fee" := Rec."Admisson Fee" + Rec."Registration Fee" + Rec."Quarter Fee" + Rec."Transportation Fee";
                //     end;
                // }
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

    var
        myInt: Integer;

}