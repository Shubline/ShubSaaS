codeunit 70001 "Background Sleep"
{
    trigger OnRun()
    var
        Sleep: Integer;
    begin
        Evaluate(Sleep, Page.GetBackgroundParameters().Get('Sleep'));
        Sleep(Sleep);
    end;
}
