page 70022 "Indent list"
{
    ApplicationArea = All;
    Caption = 'Indent list';
    PageType = List;
    SourceTable = "Indent Header";
    UsageCategory = Lists;
    CardPageId = "Indent Header";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }
}