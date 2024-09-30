page 70000 "Shubham Cue"
{
    Caption = 'Shubham Activities Cue';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Shubham Cue";
    ApplicationArea = All;
    ShowFilter = false;

    layout
    {
        area(content)
        {
            usercontrol(ChangeCompanyDropdown; "ChangeCompanyDropdown")
            {
                ApplicationArea = All;

                trigger OnLoad()
                var
                    Comp: Record Company;
                begin
                    CurrPage.ChangeCompanyDropdown.SetOption('id', 'ChangeCompanyDropdown');
                    CurrPage.ChangeCompanyDropdown.SetOption('caption', 'Change Company');
                    CurrPage.ChangeCompanyDropdown.SetOption('title', 'Change current company.');
                    if Comp.FindSet() then
                        repeat
                            CurrPage.ChangeCompanyDropdown.SetCompany(Comp.Name, Comp."Display Name");
                        until Comp.Next() = 0;
                    CurrPage.ChangeCompanyDropdown.SetCurrentCompany(CompanyName());
                end;
            }
            cuegroup("Home")
            {
                field("Job Cue Error"; Rec."Job Cue Error")
                {
                    ApplicationArea = suite;
                    Image = People;

                    trigger OnDrillDown()
                    var
                        SessionSetting: SessionSettings;
                    begin
                        SessionSetting.Init();
                        Message(SessionSetting.ProfileId);
                        Page.Run(60006);
                    end;
                }
                field("Students"; Student.Count)
                {
                    ApplicationArea = suite;
                    Image = People;

                    trigger OnDrillDown()
                    begin
                        Page.Run(60001);
                    end;
                }
                field("Email ID(s)"; EmailID.Count)
                {
                    ApplicationArea = suite;

                    trigger OnDrillDown()
                    begin
                        Page.Run(80001);
                    end;
                }
                field("Email List"; EmailList.Count)
                {
                    ApplicationArea = suite;

                    trigger OnDrillDown()
                    begin
                        Page.Run(80003);
                    end;
                }
                field(Slip; Slip.Count)
                {
                    ApplicationArea = suite;

                    trigger OnDrillDown()
                    begin
                        Page.Run(60011);
                    end;
                }
            }
            group(UpdateTime)
            {
                Caption = 'Last Updated';
                field(LastUpdated; LastUpdated)
                {
                    ShowCaption = false;
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    MultiLine = true;
                    Style = StrongAccent;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(RefreshData)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Refresh Data';
                Image = Refresh;
                ToolTip = 'Refreshes the data needed to make complex calculations.';

                trigger OnAction()
                begin
                    Rec."Job Cue Error" := 5;
                    Rec.Modify();
                    CurrPage.Update(false);
                end;
            }
            action("Set Up Cues")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Set Up Cues';
                Image = Setup;
                ToolTip = 'Set up the cues (status tiles) related to the role.';

                trigger OnAction()
                var
                    CueRecordRef: RecordRef;
                    CuesAndKpis: Codeunit "Cues And KPIs";
                begin
                    CueRecordRef.GetTable(Rec);
                    CuesAndKpis.OpenCustomizePageForCurrentUser(CueRecordRef.Number);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        BackgroundUpdate();
    end;

    local procedure BackgroundUpdate()
    var
        TaskParameters: Dictionary of [Text, Text];
    begin
        TaskParameters.Add('Sleep', Format(1000));

        CurrPage.EnqueueBackgroundTask(TaskID, Codeunit::"Background Sleep", TaskParameters, 2000, PageBackgroundTaskErrorLevel::Error);
    end;

    trigger OnPageBackgroundTaskCompleted(TaskId: Integer; Results: Dictionary of [Text, Text])
    begin
        // Change Comapny Function will only work if below code is commented
        LastUpdated := Format(CurrentDateTime, 0, 3);
        // BackgroundUpdate();
    end;

    var

        TaskID: Integer;
        LastUpdated: Text;
        EmailList: Record "Emails";
        EmailID: Record "Email ID";
        Student: Record Student;
        Slip: Record "Slip Header";

}