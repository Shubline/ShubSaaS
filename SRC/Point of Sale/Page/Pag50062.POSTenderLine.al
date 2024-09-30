page 50062 "POS Tender Line"
{
    Caption = 'POS Tender Line';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    AutoSplitKey = true;
    SourceTable = "POS Tender Line";


    layout
    {
        area(Content)
        {
            repeater("POS Tender Line")
            {

                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = All;
                }
                field("Tender Type"; Rec."Tender Type")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
            }
        }
    }
}