page 80001 "Email ID(s)"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Email ID";
    DataCaptionFields = "Email ID";
    CardPageId = 80002;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater("Email IDs")
            {
                field("Email ID"; Rec."Email ID")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Page No."; Rec."Page No.")
                {
                    ApplicationArea = All;
                    // LookupPageID = Objects;
                    // TableRelation = AllObj."Object ID" WHERE("Object Type" = filter('Page'));
                }
                field("Page Description"; Rec."Page Description")
                {
                    ApplicationArea = All;
                }
                field("Action Name"; Rec."Action Name")
                {
                    ApplicationArea = All;
                }
                field("Report No."; Rec."Report No.")
                {
                    ApplicationArea = All;
                    // LookupPageID = Objects;
                    // TableRelation = AllObj."Object ID" WHERE("Object Type" = filter('Report'));
                }
                field("Report Description"; Rec."Report Description")
                {
                    ApplicationArea = All;
                }
                field("Attach Report"; Rec."Attach Report")
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

            action("Email")
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Image = Email;

                trigger OnAction()
                var
                    EmailCU: Codeunit "Email Report";
                    sales: Record "Sales Invoice Header";
                    EmailID: Record "Email ID";
                    PageNo: Integer;
                    RecRef: RecordRef;
                begin
                    
                end;
            }       
        }
    }

}
