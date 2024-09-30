codeunit 60007 "System Initialization Ext"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"System Initialization", 'OnAfterLogin', '', false, false)]
    internal procedure OnAfterLogin()
    var
        MainMenuID: Integer;
        CompanyInformation: Record "Company Information";
        UserSetup: Record "User Setup";
    begin
        // Message('Welcome Shubham \ ...........');
        //   LogInStart;
    End;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Company Triggers", 'OnCompanyOpenCompleted', '', false, false)]
    local procedure OnCompanyOpenCompleted()
    var
        Page_UserResponsibilityCentre: Page "User Responsibility Centre";
    begin
        // Clear(Page_UserResponsibilityCentre);
        // Page_UserResponsibilityCentre.LookupMode := true;
        // if Page_UserResponsibilityCentre.RunModal() = Action::LookupOK then begin end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::LogInManagement, 'OnLogInEndOnAfterGetUserSetupRegisterTime', '', false, false)]
    local procedure OnLogInEndOnAfterGetUserSetupRegisterTime(var UserSetup: Record "User Setup");
    begin
    end;
}