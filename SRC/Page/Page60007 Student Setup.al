page 60007 "Student Setup"
{
    PageType = Card;
    ApplicationArea = All;
    Caption = 'Student Setup';
    UsageCategory = Administration;
    SourceTable = "Student Setup";
    InsertAllowed = false;
    DeleteAllowed = false;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Addmission No."; Rec."Addmission No.") { }
                field("Document No."; Rec."Document No.") { }
                field("Workflow Header No."; Rec."Workflow Header No.") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Setup Action")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;

}