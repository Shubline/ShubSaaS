codeunit 70000 "Customize Workflow Management"
{

    var
        WorkflowMgt: Codeunit "Workflow Management";
        RUNWORKFLOWONSENDFORAPPROVALCODE: Label 'RUNWORKFLOWONSEND%1FORAPPROVALCODE';
        RUNWORKFLOWONCANCELFORAPPROVALCODE: Label 'RUNWORKFLOWONCANCEL%1FORAPPROVALCODE';
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
        WorkflowSendForApprovalEventDescTxt: Label 'Approval of %1 is requested.';
        WorkflowCancelForApprovalEventDescTxt: Label 'Approval of %1 is canceled.';

    procedure CheckApprovalsWorkflowEnabled(var RecRef: RecordRef): Boolean
    begin
        if not WorkflowMgt.CanExecuteWorkflow(RecRef, GetWorkflowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef)) then
            Error(NoWorkflowEnabledErr);
        exit(true);
    end;

    procedure GetWorkflowCode(WorkflowCode: code[128]; RecRef: RecordRef): Code[128]
    begin
        exit(DelChr(StrSubstNo(WorkflowCode, RecRef.Name), '=', ' '));
    end;

    procedure GetWorkflowEventDesc(WorkflowEventDesc: Text; RecRef: RecordRef): Text
    begin
        exit(StrSubstNo(WorkflowEventDesc, RecRef.Name));
    end;

    // subscribe
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Customize Workflow Management", 'OnSendWorkflowForApproval', '', false, false)]
    local procedure RunWorkflowOnSendWorkflowForApproval(var RecRef: RecordRef)
    begin
        WorkflowMgt.HandleEvent(GetWorkflowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef), RecRef);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Customize Workflow Management", 'OnCancelWorkflowForApproval', '', false, false)]
    local procedure RunWorkflowOnCancelWorkflowForApproval(var RecRef: RecordRef)
    begin
        WorkflowMgt.HandleEvent(GetWorkflowCode(RUNWORKFLOWONCANCELFORAPPROVALCODE, RecRef), RecRef);
    end;

    // Add events to the library
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibrary()
    var
        RecRef: RecordRef;
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        RecRef.Open(Database::"Indent Header");
        WorkflowEventHandling.AddEventToLibrary(GetWorkflowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef), Database::"Indent Header",
          GetWorkflowEventDesc(WorkflowSendForApprovalEventDescTxt, RecRef), 0, false);
        WorkflowEventHandling.AddEventToLibrary(GetWorkflowCode(RUNWORKFLOWONCANCELFORAPPROVALCODE, RecRef), DATABASE::"Indent Header",
          GetWorkflowEventDesc(WorkflowCancelForApprovalEventDescTxt, RecRef), 0, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', True, True)]
    local procedure OnAddWorkflowResponsesToLibrary()
    var
        RecRef: RecordRef;
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    begin
        RecRef.Open(Database::"Indent Header");
    End;

    // handle the document;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        IndentWorkflowHdr: Record "Indent Header";
    begin
        case RecRef.Number of
            Database::"Indent Header":
                begin
                    RecRef.SetTable(IndentWorkflowHdr);
                    IndentWorkflowHdr.Validate(Status, IndentWorkflowHdr.Status::Open);
                    IndentWorkflowHdr.Modify(true);
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        IndentWorkflowHdr: Record "Indent Header";
    begin
        case RecRef.Number of
            DataBase::"Indent Header":
                begin
                    RecRef.SetTable(IndentWorkflowHdr);
                    IndentWorkflowHdr.Validate(Status, IndentWorkflowHdr.Status::Released);
                    IndentWorkflowHdr.Modify(true);
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    local procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        IndentWorkflowHdr: Record "Indent Header";
    begin
        case RecRef.Number of
            Database::"Indent Header":
                begin
                    RecRef.SetTable(IndentWorkflowHdr);
                    IndentWorkflowHdr.Validate(Status, IndentWorkflowHdr.Status::"Pending for Approval");
                    IndentWorkflowHdr.Modify(true);
                    Variant := IndentWorkflowHdr;
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        IndentWorkflowHdr: Record "Indent Header";
    begin
        case RecRef.Number of
            DataBase::"Indent Header":
                begin
                    RecRef.SetTable(IndentWorkflowHdr);
                    ApprovalEntryArgument."Document No." := IndentWorkflowHdr."No.";
                end;
        end;
    end;

    // on After Approval is Complete
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnApproveApprovalRequest, '', false, false)]
    local procedure OnApproveApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        RecRef: RecordRef;
        IndentWorkflowHdr: Record "Indent Header";
        OpenApprovalEntries: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        RecRef.Get(ApprovalEntry."Record ID to Approve");

        case RecRef.Number of
            DataBase::"Indent Header":
                begin
                    RecRef.SetTable(IndentWorkflowHdr);
                    if not ApprovalsMgmt.HasOpenOrPendingApprovalEntries(ApprovalEntry."Record ID to Approve") then begin
                        IndentWorkflowHdr.Validate(Status, IndentWorkflowHdr.Status::Released);
                        IndentWorkflowHdr.Modify(true);
                    end;
                end;
        end;


        // Another Way to Write it
        // if ApprovalEntry."Table ID" = 50026 then begin
        //     begin
        //         if not ApprovalsMgmt.HasOpenOrPendingApprovalEntries(ApprovalEntry."Record ID to Approve") then begin
        //             IndentWorkflowHdr.Reset();
        //             IndentWorkflowHdr.SetRange("No.", ApprovalEntry."Document No.");
        //             if IndentWorkflowHdr.Find('-') then begin
        //                 IndentWorkflowHdr.Validate(Status, IndentWorkflowHdr.Status::Released);
        //                 IndentWorkflowHdr.Modify(true);
        //             end;
        //         end;
        //     end;
        // end;

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    local procedure OnRejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        RecRef: RecordRef;
        IndentWorkflowHdr: Record "Indent Header";
    begin
        case ApprovalEntry."Table ID" of
            DataBase::"Indent Header":
                begin
                    if IndentWorkflowHdr.Get(ApprovalEntry."Document No.") then begin
                        IndentWorkflowHdr.Validate(Status, IndentWorkflowHdr.Status::Rejected);
                        IndentWorkflowHdr.Modify(true);
                    end;
                end;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    var
        RecRef: RecordRef;
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        RecRef.Open(Database::"Indent Header");
        case EventFunctionName of
            WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode():
                WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode(), GetWorkflowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef));

            WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode():
                WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode(), GetWorkflowCode(RUNWORKFLOWONCANCELFORAPPROVALCODE, RecRef));
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', True, True)]
    local procedure OnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    var
        RecRef: RecordRef;
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    begin
        RecRef.Open(Database::"Indent Header");
        case ResponseFunctionName of
            WorkflowResponseHandling.SetStatusToPendingApprovalCode():
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode(), GetWorkflowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef));

            WorkflowResponseHandling.CreateApprovalRequestsCode():
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode(), GetWorkflowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef));

            WorkflowResponseHandling.SendApprovalRequestForApprovalCode():
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), GetWorkflowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef));

            WorkflowResponseHandling.OpenDocumentCode():
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, GetWorkflowCode(RUNWORKFLOWONCANCELFORAPPROVALCODE, RecRef));

            WorkflowResponseHandling.CancelAllApprovalRequestsCode():
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode(), GetWorkflowCode(RUNWORKFLOWONCANCELFORAPPROVALCODE, RecRef));
        end;
    end;

    // for Wokflow UserGroup
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforeApproveSelectedApprovalRequest', '', false, false)]
    local procedure OnBeforeApproveSelectedApprovalRequest(var ApprovalEntry: Record "Approval Entry"; var IsHandled: Boolean)
    var
        ApprovalEntry1: Record "Approval Entry";
    begin
        ApprovalEntry1.Reset();
        ApprovalEntry1.SetRange("Document No.", ApprovalEntry."Document No.");
        ApprovalEntry1.SetRange("Sender ID", ApprovalEntry."Sender ID");
        ApprovalEntry1.SetRange("Date-Time Sent for Approval", ApprovalEntry."Date-Time Sent for Approval");
        ApprovalEntry1.SetRange("Approval Code", ApprovalEntry."Approval Code");
        ApprovalEntry1.SetRange("Sequence No.", (ApprovalEntry."Sequence No." + 1));
        if ApprovalEntry1.FindLast() then begin
            ApprovalEntry1.Validate(Status, ApprovalEntry.Status::Open);
            ApprovalEntry1.Modify();
        end;
    end;


    [IntegrationEvent(false, false)]
    procedure OnSendWorkflowForApproval(var RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelWorkflowForApproval(var RecRef: RecordRef)
    begin
    end;
}