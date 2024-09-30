page 60002 "Student Card Page"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = student;
    RefreshOnActivate = true;
    LinksAllowed = true;

    layout
    {
        area(Content)
        {
            group("Student Details")
            {
                field("Addmission No."; Rec."Addmission No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    trigger OnAssistEdit()
                    var
                        StudentSetup: record "Student Setup";

                        NoSeries: Codeunit "No. Series";
                        NewNoSeriesCode: Code[20];
                        DefaultNoSeriesCode: Code[20];
                    begin
                        StudentSetup.Get();
                        if NoSeries.LookupRelatedNoSeries(StudentSetup."Addmission No.", DefaultNoSeriesCode, NewNoSeriesCode) then begin
                            Rec."Addmission No." := NoSeries.GetNextNo(NewNoSeriesCode);
                        end;
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Editable = Editfield;
                    ShowMandatory = true;
                }
                field("Parent Name"; Rec."Parent Name")
                {
                    ApplicationArea = All;
                    Editable = Editfield;
                    ShowMandatory = true;
                }
                field(DOB; Rec.DOB)
                {
                    ApplicationArea = All;
                    Editable = Editfield;
                    ShowMandatory = true;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    Editable = Editfield;
                    ShowMandatory = true;
                }
                field(Address2; Rec.Address2)
                {
                    ApplicationArea = All;
                    Editable = Editfield;
                }
                field(PostalCode; Rec."PostalCode")
                {
                    ApplicationArea = All;
                    Editable = Editfield;
                    TableRelation = "Post Code";
                }
                field(city; Rec.city)
                {
                    ApplicationArea = All;
                }
                field("Mobile No."; Rec."Mobile No.")
                {
                    ApplicationArea = All;
                    Editable = Editfield;
                    ShowMandatory = true;
                }
                field(Transportation; Rec.Transportation)
                {
                    ApplicationArea = All;
                    Editable = Editfield;
                }
                field(class; Rec.class)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(balance; Rec.balance)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Image; Rec.Picture)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the picture that has been set up for the Student, such as a Passport Size Photo.';

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                    end;
                }
                field("Date time"; Rec."Date time")
                {
                    ApplicationArea = All;
                }

            }
        }

        area(FactBoxes)
        {
            part(Control149; "Student Picture")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Addmission No." = FIELD("Addmission No.");
            }
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(Database::Student),
                              "No." = FIELD("Addmission No.");
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Action21)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action(Release)
                {
                    ApplicationArea = Suite;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';
                    ToolTip = 'Release the document to the next stage of processing. You must reopen the document before you can make changes to it.';
                    trigger OnAction()
                    begin
                        Editfield := false;
                        Rec.Status := Rec.Status::Release;
                        Rec.Modify();

                        Rec.TestField(Name);
                        Rec.TestField(Address);
                        Rec.TestField(DOB);
                        Rec.TestField("Parent Name");
                    end;

                }
                action(Reopen)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Re&open';
                    Image = ReOpen;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';

                    trigger OnAction()
                    begin
                        Rec.TestField(Status, Rec.Status::Release);
                        Editfield := true;
                        Rec.Status := Rec.Status::Open;
                        Rec.Modify();
                    end;
                }
            }

            action("Post")
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Caption = 'Student Document';
                Image = Document;

                trigger OnAction()
                begin
                    Rec.TestField(Status, Rec.Status::Release);
                end;
            }

            action("Student Ledger Entries")
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Caption = 'Student Ledger Entries';
                Image = Ledger;

                trigger OnAction()
                begin

                    Clear(LedgerPage);
                    ledger.reset();
                    ledger.SetFilter("Addmission No.", Rec."Addmission No.");
                    LedgerPage.SetTableView(ledger);
                    LedgerPage.LookupMode := True;
                    if (LedgerPage.RunModal() = Action::LookupOK) then begin
                        ledger.SetFilter("Addmission No.", Rec."Addmission No.");
                    end;

                end;
            }

            action("New Fee Structure")
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Caption = 'New Fee Structure';
                Image = NewBank;

                trigger OnAction()
                begin
                    page.Run(60003);
                end;
            }

            action("New Student Registration")
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Caption = 'New Student Registration';
                Image = Report;
                trigger OnAction()
                begin
                    if (Rec.Status = Rec.Status::Release) then begin
                        RecStudent.SetRange("Addmission No.", Rec."Addmission No.");
                        report.Run(60050, true, false, RecStudent);
                    end
                    else begin
                        Message('Please Release The Status For Registration');
                    end;
                end;

            }

            action("Student Document")
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Caption = 'Student Document';
                Image = Document;

                trigger OnAction()
                begin
                    page.Run(60060);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if (Rec.Status = Rec.Status::Open) then begin
            Editfield := true;
        end;

        if (Rec.Status = Rec.Status::Release) then begin
            Editfield := false;
        end;
    end;


    trigger OnClosePage()
    begin
        // Rec.TestField("Addmission No.");
        // Rec.TestField(Address);
        // Rec.TestField(DOB);
        // Rec.TestField("Parent Name");
    end;

    trigger OnAfterGetCurrRecord()
    begin

    end;

    var
        Editfield: Boolean;
        Checkfield: Boolean;
        LedgerPage: Page "Student Ledger Entries";
        ledger: Record "Student Ledger Entries";
        RecAddmissioncurr: Code[20];
        RecStudent: Record Student;



}


