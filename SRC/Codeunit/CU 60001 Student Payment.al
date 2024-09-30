codeunit 60001 Payment
{
    TableNo = "Slip Header";
    trigger OnRun();
    begin
        CheckPayment(Rec)
    end;

    procedure CheckPayment(var Header: Record "Slip Header")
    begin

        line2.Reset();
        Line2.SetRange("Addmission No.", Header."Addmission No.");
        Line2.SetRange("Document No.", Header."No.");

        if Line2.FindSet() then begin
            repeat
                Ledger.Reset();
                Ledger.SetRange("Addmission No.", Line2."Addmission No.");
                Ledger.SetRange(Quarter, Line2.Quarter);
                Ledger.SetFilter("Remaning  Amount", '<>%1', 0);
                if Ledger.FindFirst() then begin
                    Ledger."Remaning  Amount" := Ledger."Remaning  Amount" - Line2.Payment;
                    Ledger.Modify();
                    Message('ledger remain payment %1', Ledger."Remaning  Amount");
                end;
            until Line2.Next = 0;
            Line2.DeleteAll();     //
        end;
    end;
    
    var

        Ledger: Record "Student Ledger Entries";
        Line: Record "Slip Line";
        LedgerPage: Page "Student Ledger Entries";
        SLEntry: Record "Student Ledger Entries";
        pay: Decimal;
        Line2: Record "Slip Line";
        RecSLE: Record "Student Ledger Entries";
}