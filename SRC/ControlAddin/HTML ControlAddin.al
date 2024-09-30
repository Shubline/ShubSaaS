controladdin HTML
{
    // RequestedHeight = 700;
    // MinimumHeight = 700;
    // MaximumHeight = 700;
    // RequestedWidth = 700;
    // MinimumWidth = 700;
    // MaximumWidth = 700;

    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;

    StartupScript = 'Scripts/HTML/startup.js';

    Scripts = 'Scripts/HTML/script.js', 'Scripts/Clock/clock.js';

    StyleSheets = 'Scripts/clock/Clock.css';

    event ControlReady();
   
    procedure Render(HTML: Text);
}