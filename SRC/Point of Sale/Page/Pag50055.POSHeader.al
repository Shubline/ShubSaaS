page 50055 "POS Header"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "POS Header";

    layout
    {
        area(Content)
        {
            grid(POS)
            {
                GridLayout = Columns;
                field("Mobile No."; Rec."Mobile No.")
                {
                    ApplicationArea = All;
                    trigger OnAssistEdit()
                    begin
                    end;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }
            }
            part(POSLine; "POS Line")
            {
                Caption = 'POS Line';
                ApplicationArea = Basic, Suite;
                SubPageLink = "Receipt No." = field("Receipt No."), "Store No." = field("Store No.");
                UpdatePropagation = Both;
            }
        }

        area(factboxes)
        {
            part("POS Document Summary"; "POS Document Summary")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'POS Document Details';
                SubPageLink = "Receipt No." = field("Receipt No."),
                              "Store No." = field("Store No.");
                UpdatePropagation = Both;
                Visible = not FactVisible;
            }
            part(POSButtons; "POS Buttons")
            {
                ApplicationArea = All;
                Caption = 'POS Document';
                SubPageLink = "Receipt No." = field("Receipt No."),
                              "Store No." = field("Store No.");
                UpdatePropagation = Both;
                Visible = FactVisible;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Statics")
            {
                ApplicationArea = All;
                Caption = 'Statics', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Statistics;

                trigger OnAction()
                begin
                    if not FactVisible then
                        FactVisible := true
                    else
                        FactVisible := false;
                    CurrPage.Update(true);                    
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
// CurrPage.POSButtons.u
    end;

    var
        myInt: Integer;
        BlnEMI: Boolean;
        BlnEstimate: Boolean;
        BlnOldGold: Boolean;
        BlnSalesReturn: Boolean;
        BlnAdvance: Boolean;
        FactVisible: Boolean;
}