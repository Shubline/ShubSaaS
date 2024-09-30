page 80005 "Email Account Page"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Email Account";
    DataCaptionFields = Name;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater("Email Accounts")
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Email Address"; Rec."Email Address")
                {
                    ApplicationArea = All;
                }
                field("Account Id"; Rec."Account Id")
                {
                    ApplicationArea = All;
                }
                field(Connector; Rec.Connector)
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

        }
    }

    trigger OnOpenPage()
    var
        FeatureTelemetry: Codeunit "Feature Telemetry";
    begin
        FeatureTelemetry.LogUptake('0000CTA', 'Emailing', Enum::"Feature Uptake Status"::Discovered);
        Rec.SetCurrentKey("Account Id", Connector);
        UpdateEmailAccounts();
        ShowLogo := true;
    end;

    trigger OnAfterGetRecord()
    begin
        // Updating the accounts is done via OnAfterGetRecord in the cases when an account was changed from the corresponding connector's page
        if UpdateAccounts then begin
            UpdateAccounts := false;
            UpdateEmailAccounts();
        end;


        DefaultTxt := '';

        IsDefault := DefaultEmailAccount."Account Id" = Rec."Account Id";
        if IsDefault then
            DefaultTxt := '✓';
    end;

    local procedure UpdateEmailAccounts()
    var
        EmailAccount: Codeunit "Email Account";
        EmailScenario: Codeunit "Email Scenario";
        IsSelected: Boolean;
        SelectedAccountId: Guid;
    begin
        // We need this code block to maintain the same selected record.
        SelectedAccountId := Rec."Account Id";
        IsSelected := not IsNullGuid(SelectedAccountId);

        EmailAccount.GetAllAccounts(true, Rec); // Refresh the email accounts
        EmailScenario.GetDefaultEmailAccount(DefaultEmailAccount); // Refresh the default email account

        if IsSelected then begin
            Rec."Account Id" := SelectedAccountId;
            if Rec.Find() then;
        end else
            if Rec.FindFirst() then;

        HasEmailAccount := not Rec.IsEmpty();

        CurrPage.Update(false);
    end;

    local procedure ShowAccountInformation()
    var
        Connector: Interface "Email Connector";
    begin
        UpdateAccounts := true;

        Connector := Rec.Connector;
        Connector.ShowAccountInformation(Rec."Account Id");
    end;

    /// <summary>
    /// Gets the selected email account.
    /// </summary>
    /// <param name="EmailAccount">The selected email account</param>
    procedure GetAccount(var EmailAccount: Record "Email Account")
    begin
        EmailAccount := Rec;
    end;

    /// <summary>
    /// Sets an email account to be selected.
    /// </summary>
    /// <param name="EmailAccount">The email account to be initially selected on the page</param>
    procedure SetAccount(var EmailAccount: Record "Email Account")
    begin
        Rec := EmailAccount;
    end;

    /// <summary>
    /// Enables the lookup mode on the page.
    /// </summary>


    var
        DefaultEmailAccount: Record "Email Account";

        IsDefault: Boolean;
        RateLimit: Integer;
        CanUserManageEmailSetup: Boolean;
        DefaultTxt: Text;
        UpdateAccounts: Boolean;
        ShowLogo: Boolean;
        HasEmailAccount: Boolean;
        EmailConnectorHasBeenUninstalledMsg: Label 'The selected email extension has been uninstalled. To view information about the email account, you must reinstall the extension.';


}
