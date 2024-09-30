page 50054 "Karigar Metal Issue List"
{
    ApplicationArea = All;
    Caption = 'Karigar Metal Issue List';
    PageType = List;
    SourceTable = "Karigar Issue Header";
    UsageCategory = Lists;
    CardPageId = "Karigar Metal Issue";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Issue No."; Rec."Issue No.")
                {
                    ToolTip = 'Specifies the value of the Issue No. field.', Comment = '%';
                }
                field("Issue Date"; Rec."Issue Date")
                {
                    ToolTip = 'Specifies the value of the Issue Date field.', Comment = '%';
                }
                field("Karigar No."; Rec."Karigar No.")
                {
                    ToolTip = 'Specifies the value of the Karigar No. field.', Comment = '%';
                }
                field("Karigar Name"; Rec."Karigar Name")
                {
                    ToolTip = 'Specifies the value of the Karigar Name field.', Comment = '%';
                }
                field("From Location"; Rec."From Location")
                {
                    ToolTip = 'Specifies the value of the From Location field.', Comment = '%';
                }
                field("To Location"; Rec."To Location")
                {
                    ToolTip = 'Specifies the value of the To Location field.', Comment = '%';
                }
                field(Remark; Rec.Remark)
                {
                    ToolTip = 'Specifies the value of the Remark field.', Comment = '%';
                }
            }
        }
    }
}
