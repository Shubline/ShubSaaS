page 60011 "Slip List"
{
    Caption = 'Slips';
    DataCaptionFields = "No.";
    Editable = false;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Slip Header";
    CardPageId = 60009;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater("Slip(s)")
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Addmission No."; Rec."Addmission No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(class; Rec.Class)
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = All;
                }
                field(status; Rec.status)
                {
                    ApplicationArea = All;
                }
            }
        }

        area(FactBoxes)
        {
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
}