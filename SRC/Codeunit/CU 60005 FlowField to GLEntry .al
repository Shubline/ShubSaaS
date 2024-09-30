codeunit 60005 "FlowField to GL Entry"
{
    // Purchase Line to Gl Entry
    // Purchase Line to Invoice Posting Buffer
    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPreparePurchase', '', true, true)]
    local procedure OnAfterInvPostBufferPreparePurchase(var PurchaseLine: Record "Purchase Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
        InvoicePostBuffer."Insurance No." := PurchaseLine."Insurance No";
    end;

    // Sales Line to Gl Entry
    // Sales Line to Invoice Posting Buffer
    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPrepareSales', '', true, true)]
    local procedure OnAfterInvPostBufferPrepareSales(var SalesLine: Record "Sales Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
        InvoicePostBuffer."Insurance No." := SalesLine."Job No.";
    end;

    // Purchase & Sales Line to Gl Entry
    // Invoice Posting Buffer to Gen. Jnl Line
    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterCopyToGenJnlLine', '', true, true)]
    local procedure OnAfterCopyToGenJnlLine(var GenJnlLine: Record "Gen. Journal Line"; InvoicePostBuffer: Record "Invoice Post. Buffer");
    begin
        GenJnlLine."Insurance No" := InvoicePostBuffer."Insurance No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyGLEntryFromGenJnlLine(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line");
    var
        InvoicePostingBuffer: Record "Invoice Posting Buffer";
    begin
        GLEntry."Insurance No" := GenJournalLine."Insurance No";
    end;

    // New implementation
    // [EventSubscriber(ObjectType::Table, Database::"Invoice Posting Buffer", 'OnAfterPreparePurchase', '', true, true)]
    // local procedure OnAfterPreparePurchase(var PurchaseLine: Record "Purchase Line"; var InvoicePostingBuffer: Record "Invoice Posting Buffer")
    // begin
    //     InvoicePostingBuffer."Insurance No." := PurchaseLine."Insurance No";
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Invoice Posting Buffer", 'OnAfterPrepareSales', '', true, true)]
    // local procedure OnAfterPrepareSales(var SalesLine: Record "Sales Line"; var InvoicePostingBuffer: Record "Invoice Posting Buffer")
    // begin
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Invoice Posting Buffer", 'OnAfterCopyToGenJnlLine', '', true, true)]
    // local procedure OnAfterCopyToGenJnlLine(var GenJnlLine: Record "Gen. Journal Line"; InvoicePostingBuffer: Record "Invoice Posting Buffer");
    // begin
    //     GenJnlLine."Insurance No" := InvoicePostingBuffer."Insurance No.";
    // end;
}