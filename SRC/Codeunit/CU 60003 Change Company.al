codeunit 60003 Schedulertsk //"Excel Export"
{
    trigger OnRun()
    var
        RecCompany: Record "Company Information";
    begin
        //  TaskScheduler.CreateTask(Codeunit::Schedulertsk, 0, true, 'Shubline');

        if RecCompany.ChangeCompany('CRONUS India Ltd.') then begin
            if RecCompany.FindFirst() then
                Message('%1', RecCompany.Name);
        end;

        if RecCompany.ChangeCompany('Shubline') then begin
            if RecCompany.FindFirst() then
                Message('%1', RecCompany.Name);
        end;

    end;

    local procedure Export()
    var
    begin

    end;


    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        RecCompany: Record "Company Information";

}