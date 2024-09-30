controladdin ALButton
{
    RequestedHeight = 36;
    MinimumHeight = 32;
    MinimumWidth = 84;
    VerticalStretch = false;
    HorizontalStretch = true;
    VerticalShrink = true;
    HorizontalShrink = true;
    Scripts = 'Scripts/ALButton/BaseControl.js', 'Scripts/ALButton/Button/Button.js';
    StyleSheets = 'Scripts/ALButton/BaseControl.css', 'Scripts/ALButton/Button/Button.css';
    StartupScript = 'Scripts/ALButton/Button/startup.js';

    //#region Base Events
    event OnLoad();
    event OnError(message: Text);
    //#endregion
    event OnClick(buttonId: Text);
    procedure SetOption("key": Text; "value": Text);
}

controladdin ALButtonGroup
{
    RequestedHeight = 40;
    MinimumHeight = 32;
    MinimumWidth = 84;
    VerticalStretch = false;
    HorizontalStretch = true;
    VerticalShrink = true;
    HorizontalShrink = true;
    Scripts = 'Scripts/ALButton/BaseControl.js', 'Scripts/ALButton/Button/Button.js', 'Scripts/ALButton/ButtonGroup/ButtonGroup.js';
    StyleSheets = 'Scripts/ALButton/BaseControl.css', 'Scripts/ALButton/Button/Button.css', 'Scripts/ALButton/ButtonGroup/ButtonGroup.css';
    StartupScript = 'Scripts/ALButton/ButtonGroup/startup.js';

    //#region Base Events
    event OnLoad();
    event OnError(message: Text);
    //#endregion
    event OnClick(id: Text);
    procedure AddButton(caption: Text; title: Text; id: Text; "type": Text);
    procedure RemoveButton(id: Text);
}
