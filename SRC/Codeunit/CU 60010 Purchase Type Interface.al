codeunit 60010 PurchaseType implements "Purchase Type"
{
    procedure IsVisible(PurchLine: Record "Purchase Line"): Boolean
    begin
        if PurchLine."Purchase Type" = PurchLine."Purchase Type"::"Job Work" then
            exit(true)
        else
            exit(false);
    end;
}