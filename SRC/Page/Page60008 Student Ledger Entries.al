page 60008 "Student Ledger Entries"
{
    Caption = 'Student ledger Entries';
    PageType = List;
    ApplicationArea = All;
    SourceTable = "Student ledger Entries";
    UsageCategory = Lists;
    Editable = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater("Student Ledger")
            {

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Addmission No."; Rec."Addmission No.")
                {
                    ApplicationArea = All;
                }
                field("Student Name"; Rec."Student Name")
                {
                    ApplicationArea = All;
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = All;
                }
                field("Payment Amount"; Rec."Payment Amount")
                {
                    ApplicationArea = All;
                }
                field("Remaning  Amount"; Rec."Remaning  Amount")
                {
                    ApplicationArea = All;
                }
                field(Quarter; Rec.Quarter)
                {
                    ApplicationArea = All;
                }

                field(Month; Rec.Month)
                {
                    ApplicationArea = All;
                }

            }
        }

        area(FactBoxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
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

                trigger OnAction()
                begin

                end;
            }
        }
    }

    trigger OnOpenPage()
    begin

    end;

    var
        myInt: Integer;



}