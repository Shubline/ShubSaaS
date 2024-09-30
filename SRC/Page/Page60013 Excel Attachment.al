page 60017 "Excel Attachment"
{
    ApplicationArea = All;
    Caption = 'Excel Attachment';
    PageType = List;
    SourceTable = "Excel Attachment";
    UsageCategory = Lists;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
            }
        }

        area(FactBoxes)
        {

            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(Database::"Excel Attachment"),
                              "No." = FIELD("Code");
            }
            systempart(Links; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = Notes;
            }
        }

    }
}
