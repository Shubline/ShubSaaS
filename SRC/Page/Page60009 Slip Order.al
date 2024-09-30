page 60009 "Slip Order"
{
    Caption = 'Sales Order';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Slip Header";

    AboutTitle = 'About slip order details';
    AboutText = 'Choose the order details and fill in order lines with quantities of what you are selling.';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Addmission No."; Rec."Addmission No.")
                {
                    ApplicationArea = All;
                    TableRelation = student;

                    trigger OnValidate()
                    begin
                        Ledger.Reset();
                        Ledger.SetFilter(Ledger."Addmission No.", Rec."Addmission No.");
                        if Ledger.FindFirst() then begin
                            Rec.Name := Ledger."Student Name";
                            Rec.class := Ledger.class;
                            Rec.Session := Ledger.Session;
                            Rec.Quarter := Ledger.Quarter;
                        end;
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(class; Rec.Class)
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = All;
                }
                field(status; Rec.status)
                {
                    ApplicationArea = All;
                }
            }

            part(SlipLine; "Slip Order Subform")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
            }
            part(SlipDetailLine; "Slip Order Detail Subform")
            {
                Provider = SlipLine;
                ApplicationArea = Basic, Suite;
                SubPageLink = "Document No." = field("Document No."), "Slip Line No." = field("Line No.");
                UpdatePropagation = Both;
                ShowFilter = false;
                SubPageView = sorting("Document No.") where("Addmission No." = filter(<> ' '));
            }
        }

        area(FactBoxes)
        {
            systempart(Links; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group(SlipStatus)
            {
                action(Release)
                {
                    ApplicationArea = All;
                    Image = ReleaseDoc;
                    Caption = 'Release';
                    ToolTip = 'To release the document';

                    trigger OnAction()
                    begin
                        Rec.Status := Rec.Status::Release;
                        Editfield := false;
                        Rec.Modify();
                    end;
                }

                action(ReOpen)
                {
                    ApplicationArea = All;
                    Caption = 'ReOpen';
                    Image = Open;

                    trigger OnAction()
                    begin
                        Rec.Status := Rec.Status::Open;
                        Rec.Modify();
                    end;
                }
            }

            group(posting)
            {
                action(Post)
                {
                    ApplicationArea = All;
                    Caption = 'Post';
                    Image = Post;

                    trigger OnAction()
                    begin
                        if not Confirm(txt001, false) then
                            exit;    //('post invoice');
                        Payme.CheckPayment(Rec);
                        //  Ledger.Modify();
                    end;
                }

                action(PreviewPost)
                {
                    ApplicationArea = All;
                    Caption = 'Preview Post';
                    Image = PreviewChecks;

                    trigger OnAction()
                    begin
                        if not Confirm(txt001, false) then
                            exit;    //('post invoice');
                    end;
                }
            }

            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    ToolTip = 'Approve the requested changes.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    ToolTip = 'Reject the approval request.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Image = Delegate;
                    ToolTip = 'Delegate the approval to a substitute approver.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = ViewComments;
                    ToolTip = 'View or add comments for the record.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
                action(Approvals)
                {
                    ApplicationArea = All;
                    Caption = 'Approvals';
                    Image = Approvals;
                    ToolTip = 'View approval requests.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                    end;
                }
            }
        }

        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                group(Category_Posting)
                {
                    Caption = 'Post', Comment = 'Generated from the PromotedActionCategories property index 1.';
                    ShowAs = SplitButton;

                    actionref(Post_Promoted; Post)
                    {
                    }
                    actionref(Previewpost_Promoted; PreviewPost)
                    {
                    }
                }

                group(Category_Release)
                {
                    Caption = 'Release', Comment = 'Generated from the PromotedActionCategories property index 1.';
                    ShowAs = SplitButton;

                    actionref(Release_Promoted; Release)
                    {
                    }
                    actionref(Reopen_Promoted; Reopen)
                    {
                    }
                }
            }

            group(Category_Approval)
            {
                Caption = 'Approval', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref(Approve_Promoted; Approve)
                {
                }
                actionref(Reject_Promoted; Reject)
                {
                }
                actionref(Delegate_Promoted; Delegate)
                {
                }
                actionref(Comment_Promoted; Comment)
                {
                }
                actionref(Approval_Promoted; Approvals)
                {
                }
            }
        }

    }

    trigger OnOpenPage()
    begin

    end;

    trigger OnAfterGetRecord()
    begin
        if (Rec.Status = Rec.Status::Open) then begin
            Editfield := true;
        end;

        if (Rec.Status = Rec.Status::Release) then begin
            Editfield := false;
        end;
    end;

    var
        myInt: Integer;
        Ledger: Record "Student ledger Entries";
        Editfield: Boolean;
        payme: Codeunit Payment;
        txt001: TextConst ENU = 'Do You want to Post Receipt?';
}