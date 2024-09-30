page 50000 "Response Logs"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Response Logs";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    DelayedInsert = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Document No.";Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Status";Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Called API";Rec."Called API")
                {
                    ApplicationArea = All;
                }
                field("Response Date";Rec."Response Date")
                {
                    ApplicationArea = All;
                }
                field("Response Time";Rec."Response Time")
                {
                    ApplicationArea = All;
                }
                field("Response Log 1";Rec."Response Log 1")
                {
                    ApplicationArea = All;
                }
                field("Response Log 2";Rec."Response Log 2")
                {
                    ApplicationArea = All;
                }
                field("Response Log 3";Rec."Response Log 3")
                {
                    ApplicationArea = All;
                }
                field("Response Log 4";Rec."Response Log 4")
                {
                    ApplicationArea = All;
                }
                field("Response Log 5";Rec."Response Log 5")
                {
                    ApplicationArea = All;
                }
                field("Response Log 6";Rec."Response Log 6")
                {
                    ApplicationArea = All;
                }
                field("Response Log 7";Rec."Response Log 7")
                {
                    ApplicationArea = All;
                }
                field("Response Log 8";Rec."Response Log 8")
                {
                    ApplicationArea = All;
                }
                field("Response Log 9";Rec."Response Log 9")
                {
                    ApplicationArea = All;
                }
                field("Response Log 10";Rec."Response Log 10")
                {
                    ApplicationArea = All;
                }
                field("Response Log 11";Rec."Response Log 11")
                {
                    ApplicationArea = All;
                }
                field("Response Log 12";Rec."Response Log 12")
                {
                    ApplicationArea = All;
                }
                field("Response Log 13";Rec."Response Log 13")
                {
                    ApplicationArea = All;
                }
                field("Response Log 14";Rec."Response Log 14")
                {
                    ApplicationArea = All;
                }
                field("Response Log 15";Rec."Response Log 15")
                {
                    ApplicationArea = All;
                }
                field("Response Log 16";Rec."Response Log 16")
                {
                    ApplicationArea = All;
                }
                field("Response Log 17";Rec."Response Log 17")
                {
                    ApplicationArea = All;
                }
                field("Response Log 18";Rec."Response Log 18")
                {
                    ApplicationArea = All;
                }
                field("Response Log 19";Rec."Response Log 19")
                {
                    ApplicationArea = All;
                }
                field("Response Log 20";Rec."Response Log 20")
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
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()begin
                end;
            }
        }
    }
    var myInt: Integer;
}
