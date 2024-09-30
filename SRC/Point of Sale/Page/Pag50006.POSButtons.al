page 50006 "POS Buttons"
{
    ApplicationArea = All;
    Caption = 'POS Buttons';
    PageType = CardPart;
    SourceTable = "POS Header";

    layout
    {
        area(Content)
        {
            field(PhoneNo; PhoneNo)
            {
                Style = StandardAccent;
                ApplicationArea = suite;
                trigger OnDrillDown()
                begin
                    Message(PhoneNo);
                end;
            }

            // usercontrol("BackSpace"; ALButton)
            // {
            //     Visible = true;
            //     ApplicationArea = All;

            //     trigger OnLoad()
            //     begin
            //         CurrPage.BackSpace.SetOption('caption', 'backspace');
            //         CurrPage.BackSpace.SetOption('title', 'Remove');
            //         CurrPage.BackSpace.SetOption('type', 'primary');
            //     end;

            //     trigger OnClick(buttonId: Text)
            //     begin
            //         if PhoneNo <> '' then
            //             PhoneNo := CopyStr(PhoneNo, 1, StrLen(PhoneNo) - 1);
            //         CurrPage.Update(true);
            //     end;
            // }

            cuegroup("Actions")
            {
                Caption = ' ';

                field("1"; Tender(1))
                {
                    Caption = ' ';
                    StyleExpr = 'Favorable';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        PhoneNo += '1';
                        CurrPage.Update(true);
                    end;
                }
                field("2"; Tender(2))
                {
                    Caption = ' ';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        PhoneNo += '2';
                        CurrPage.Update(true);
                    end;
                }
                field("3"; Tender(3))
                {
                    Caption = ' ';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        PhoneNo += '3';
                        CurrPage.Update(true);
                    end;
                }
                field("4"; Tender(4))
                {
                    Caption = ' ';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        PhoneNo += '4';
                        CurrPage.Update(true);
                    end;
                }
                field("5"; Tender(5))
                {
                    Caption = ' ';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        PhoneNo += '5';
                        CurrPage.Update(true);
                    end;
                }
                field("6"; Tender(6))
                {
                    Caption = ' ';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        PhoneNo += '6';
                        CurrPage.Update(true);
                    end;
                }
                field("7"; Tender(7))
                {
                    Caption = ' ';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        PhoneNo += '7';
                        CurrPage.Update(true);
                    end;
                }
                field("8"; Tender(8))
                {
                    Caption = ' ';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        PhoneNo += '8';
                        CurrPage.Update(true);
                    end;
                }
                field("9"; Tender(9))
                {
                    Caption = ' ';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        PhoneNo += '9';
                        CurrPage.Update(true);
                    end;
                }
                field("0"; Tender(0))
                {
                    Caption = ' ';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        PhoneNo += '0';
                        CurrPage.Update(true);
                    end;
                }

                field("Remove"; Remove)
                {
                    CaptionML = ENU = 'Remove';
                    StyleExpr = 'UnFavorable';
                    Style= Unfavorable;
            
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        if PhoneNo <> '' then
                            PhoneNo := CopyStr(PhoneNo, 1, StrLen(PhoneNo) - 1);
                        CurrPage.Update(true);
                    end;
                }
            }
        }
    }

    var
        PhoneNo: Text[20];
        Remove: Text;

    local procedure Tender(Tender: Integer): Integer
    begin
        exit(Tender);
    end;
}
