page 60010 "Slip Order Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Slip Line";
    // SourceTableView = WHERE("Document Type" = FILTER(Invoice));

    layout
    {
        area(Content)
        {
            repeater("Slip Line")
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if (Header."No." = Rec."Document No.") then begin
                            Header.Reset();
                            Header.SetFilter(Header."No.", Rec."Document No.");
                            if Header.FindFirst() then begin
                                Rec.Class := Header.class;
                                Rec."Addmission No." := Header."Addmission No.";
                                Rec.Session := Header.Session;
                                Rec.Quarter := Header.Quarter;
                                Rec.Modify();
                            end;
                        end;
                    end;

                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;

                }
                field("Addmission No."; Rec."Addmission No.")
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
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;

                }
                field("Fee Type"; Rec."Fee Type")
                {
                    ApplicationArea = All;

                }
                field(Payment; Rec.Payment)
                {

                }
                field(session; Rec.session)
                {
                    ApplicationArea = All;

                }
                field(Quarter; Rec.Quarter)
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
            action("Get Fee Receipt")
            {
                ApplicationArea = All;
                Image = Receipt;
                // trigger OnAction()
                // begin
                // Header.Reset();
                // Header.SetFilter(Header."Document No.", Rec."Document No.");
                // if Header.FindFirst() then begin
                //     Rec.Class := Header.class;
                //     Rec."Addmission No." := Header."Addmission No.";
                //     Rec.Session := Header.Session;
                //     Rec.Quarter := Header.Quarter;
                //     Rec.Modify();
                // end;
                // FieldClass = FlowField;
                // CalcFormula = sum("Student ledger Entries"."Remaning  Amount" where("Addmission No."= field("Addmission No.")));
                // end;

                trigger OnAction()
                begin
                    // Payme.CheckPayment(Rec);

                end;

            }

            action("Get Balance")
            {
                ApplicationArea = All;
                Image = Receipt;

                trigger OnAction()
                begin

                    Clear(LedgerPage);
                    RecHeader.Get(Rec."Document No.");

                    RecHeader.Testfield(status, RecHeader.status::Release);
                    RecLeader.SetRange("Addmission No.", RecHeader."Addmission No.");
                    RecLeader.SetFilter("Remaning  Amount", '<>0');
                    LedgerPage.SetTableview(RecLeader);
                    LedgerPage.LookupMode := true;
                    if LedgerPage.RunModal() = Action::Lookupok then begin
                        RecLine.SetRange("Document Type", RecLine."Document Type"::"pre Receipt");
                        RecLine.SetRange("Document No.", RecHeader."No.");

                        if RecLine.Findlast then
                            Rec."Line No." := RecLine."line No." + 10000
                        else
                            Rec."Line No." := 10000;

                        LedgerPage.SetselectionFilter(RecLeader);
                        if RecLeader.FindSet then begin
                            repeat
                                RecLine.Init;
                                RecLine."Document Type" := RecLine."Document Type"::"Pre Receipt";
                                RecLine."Document No." := RecHeader."No.";
                                RecLine."Line No." := Rec."Line No.";
                                RecLine.Validate("Addmission No.", RecLeader."Addmission No.");
                                RecLine.Validate(Class, RecLeader.Class);
                                RecLine.Validate(Amount, RecLeader.Amount);
                                RecLine.Validate("Posting Date", RecHeader."Posting Date");
                                RecLine.validate("Fee Type", RecLeader."Fee Type");
                                RecLine.Validate(Session, RecLeader.Session);
                                RecLine.Validate(Quarter, RecLeader.Quarter);
                                //RecLine.Validate(Period, RecLeader.Period);
                                RecLine.Insert();
                                Rec."Line No." += 10000;
                            until RecLeader.Next() = 0;
                        end;
                    end;
                end;
            }
        }
    }

    var

        myInt: Integer;
        Header: Record "Slip Header";
        RecHeader: Record "Slip Header";
        LedgerPage: Page "Student Ledger Entries";
        RecLeader: Record "Student Ledger Entries";
        RecLine: Record "Slip Line";
        Ledger: Record "Student Ledger Entries";

        payme: Codeunit Payment;

}