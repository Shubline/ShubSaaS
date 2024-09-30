page 60103 ALButtonTestPage
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Item;

    layout
    {

        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }

                usercontrol(ALButtonGroup; ALButtonGroup)
                {
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnLoad()
                    begin
                        CurrPage.ALButtonGroup.AddButton('Primary', 'Primary style button', 'btn1', 'primary');
                        CurrPage.ALButtonGroup.AddButton('Normal', 'Normal button', 'btn2', '');
                        CurrPage.ALButtonGroup.AddButton('Info', 'Info style button', 'btn3', 'info');
                        CurrPage.ALButtonGroup.AddButton('Danger', 'Danger style button', 'btn4', 'danger');
                    end;

                    trigger OnClick(id: Text)
                    begin
                        Message('%1 button was clicked.', id);
                    end;
                }

                usercontrol("ALButton"; ALButton)
                {
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnLoad()
                    begin
                        CurrPage.ALButton.SetOption('caption', 'OK');
                        CurrPage.ALButton.SetOption('title', 'This is a vanilia Javascript Button');
                    end;

                    trigger OnClick(buttonId: Text)
                    begin
                        Message('Custom Button Clicked!');
                    end;

                    trigger OnError(message: Text)
                    begin
                        Error('Something happened: %1', message);
                    end;
                }

                usercontrol("ALButton2"; ALButton)
                {
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnLoad()
                    begin
                        CurrPage.ALButton2.SetOption('caption', 'Primary Button');
                        CurrPage.ALButton2.SetOption('title', 'This is a vanilia Javascript Button');
                        CurrPage.ALButton2.SetOption('type', 'primary');
                    end;

                    trigger OnClick(buttonId: Text)
                    begin
                        Message('Primary Button Clicked!');
                    end;
                }
            }
        }
    }
}