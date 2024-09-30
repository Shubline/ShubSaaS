page 80004 "Email Card Page"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Emails";
    DataCaptionFields = "Email ID";

    layout
    {
        area(Content)
        {
            group("Email Lists")
            {
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
