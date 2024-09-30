page 50057 "Karigar Metal Issue"
{
    ApplicationArea = All;
    Caption = 'Karigar Metal Issue';
    PageType = Document;
    SourceTable = "Karigar Issue Header";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Issue No."; Rec."Issue No.")
                {
                    ToolTip = 'Specifies the value of the Issue No. field.', Comment = '%';
                }
                field("Issue Date"; Rec."Issue Date")
                {
                    ToolTip = 'Specifies the value of the Issue Date field.', Comment = '%';
                }
                field("From Location"; Rec."From Location")
                {
                    ToolTip = 'Specifies the value of the From Location field.', Comment = '%';
                }
                field(Remark; Rec.Remark)
                {
                    ToolTip = 'Specifies the value of the Remark field.', Comment = '%';
                    MultiLine = true;
                }
                group("Karigar Info.")
                {
                    field("Karigar No."; Rec."Karigar No.")
                    {
                        ToolTip = 'Specifies the value of the Karigar No. field.', Comment = '%';
                        trigger OnValidate()
                        begin
                            CurrPage.Update();
                        end;
                    }
                    field("Karigar Name"; Rec."Karigar Name")
                    {
                        ToolTip = 'Specifies the value of the Karigar Name field.', Comment = '%';
                    }
                    field("To Location"; Rec."To Location")
                    {
                        ToolTip = 'Specifies the value of the To Location field.', Comment = '%';
                        trigger OnValidate()
                        begin
                            CurrPage.Update();
                        end;
                    }
                    field("Pre Alloy Issue"; Rec."Pre Alloy Issue")
                    {
                        ApplicationArea = All;
                    }
                }
            }

            part(KarigarLines; "Karigar Line Subform")
            {
                ApplicationArea = all;
                SubPageLink = "Issue No." = field("Issue No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Released)
            {
                Caption = 'Release';
                action(Release)
                {
                    ApplicationArea = All;
                    Caption = 'Release', comment = 'NLB="YourLanguageCaption"';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = ReleaseDoc;

                    trigger OnAction()
                    begin
                        TestField();

                    end;
                }
                action(ReOpen)
                {
                    ApplicationArea = All;
                    Caption = 'Re Open', comment = 'NLB="YourLanguageCaption"';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = ReOpen;

                    trigger OnAction()
                    begin
                    end;
                }
            }

            action(Dimensions)
            {
                AccessByPermission = TableData Dimension = R;
                ApplicationArea = Dimensions;
                Caption = 'Dimensions';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Dimensions;
                ShortCutKey = 'Alt+D';
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                trigger OnAction()
                begin
                    Rec.ShowDocDim();
                    CurrPage.SaveRecord();
                end;
            }
        }
    }

    local procedure TestField()
    begin
        Rec.TestField("Issue No.");
        Rec.TestField("Issue Date");
        Rec.TestField("Karigar No.");
    end;

}