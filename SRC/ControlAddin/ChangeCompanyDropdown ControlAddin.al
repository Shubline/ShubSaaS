controladdin "ChangeCompanyDropdown"
{
    // RequestedHeight = 36;
    // MinimumHeight = 32;
    // MinimumWidth = 84;
    // VerticalStretch = false;
    // HorizontalStretch = true;
    // VerticalShrink = true;
    // HorizontalShrink = true;
    HorizontalShrink = true;
    VerticalShrink = true;

    MaximumHeight = 0;
    MaximumWidth = 0;

    RequestedHeight = 0;
    RequestedWidth = 0;
    Scripts = 'Scripts/ChangeCompany/BaseControl.js',
    'Scripts/ChangeCompany/ChangeCompanyDropdown/ChangeCompanyDropdown.js';

    StartupScript = 'Scripts/ChangeCompany/ChangeCompanyDropdown/startup.js';

    //#region Base Events
    event OnLoad();
    event OnError(message: Text);
    //#endregion
    procedure SetOption("key": Text; "value": Text);
    procedure SetCompany(name: Text; title: Text);
    procedure SetCurrentCompany(name: Text);
}
