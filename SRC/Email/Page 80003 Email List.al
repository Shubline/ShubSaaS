page 80003 "Email List"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "Emails";
    DataCaptionFields = "Email ID";
    UsageCategory = Lists;
    CardPageId = 80004;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater("Email Lists")
            {
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                }
                field("Email ID"; Rec."Email ID")
                {
                    ApplicationArea = All;
                }
                field("Sender Type"; Rec."Sender Type")
                {
                    ApplicationArea = All;
                }
                field("Email Address"; Rec."Email Address")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {


        }
    }
}
