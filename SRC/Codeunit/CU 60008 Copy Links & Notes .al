codeunit 60008 "Copy Links & Notes"
{
    procedure CopyLinksAndNotes(Source: RecordId; Target: RecordId)
    var
        SourceRecordLink: Record "Record Link";
        TargetRecordLink: Record "Record Link";
        RecordLinkType: Option Link,Note;
    begin
        SourceRecordLink.Reset();
        SourceRecordLink.SetRange("Record ID", Source);
        if SourceRecordLink.FindSet() then begin
            repeat
                TargetRecordLink.Reset();
                TargetRecordLink.Init();
                SourceRecordLink.CalcFields(Note);
                TargetRecordLink.Copy(SourceRecordLink);
                TargetRecordLink."Link ID" := GetLastLinkID() + 1;
                TargetRecordLink."Record ID" := Target;
                TargetRecordLink.Insert();
            until SourceRecordLink.Next() = 0;
        end;
    end;

    procedure CopyLinks(Source: RecordId; Target: RecordId)
    var
        SourceRecordLink: Record "Record Link";
        TargetRecordLink: Record "Record Link";
        RecordLinkType: Option Link,Note;
    begin
        SourceRecordLink.Reset();
        SourceRecordLink.SetRange("Record ID", Source);
        SourceRecordLink.SetRange(Type, RecordLinkType::Link);
        if SourceRecordLink.FindSet() then begin
            repeat
                TargetRecordLink.Init();
                TargetRecordLink.Copy(SourceRecordLink);
                TargetRecordLink."Link ID" := GetLastLinkID() + 1;
                TargetRecordLink."Record ID" := Target;
                TargetRecordLink.Insert();
            until SourceRecordLink.Next() = 0;
        end;
    end;

    procedure CopyNotes(Source: RecordId; Target: RecordId)
    var
        SourceRecordLink: Record "Record Link";
        TargetRecordLink: Record "Record Link";
        RecordLinkType: Option Link,Note;
    begin
        SourceRecordLink.Reset();
        SourceRecordLink.SetRange("Record ID", Source);
        SourceRecordLink.SetRange(Type, RecordLinkType::Note);
        if SourceRecordLink.FindSet() then begin
            repeat
                TargetRecordLink.Init();
                if RecordLinkType = RecordLinkType::Note then
                    SourceRecordLink.CalcFields(Note);
                TargetRecordLink.Copy(SourceRecordLink);
                TargetRecordLink."Link ID" := GetLastLinkID() + 1;
                TargetRecordLink."Record ID" := Target;
                TargetRecordLink.Insert();
            until SourceRecordLink.Next() = 0;
        end;
    end;

    local procedure GetLastLinkID() LastLinkID: Integer
    var
        RecordLink: Record "Record Link";
    begin
        RecordLink.Reset();
        if RecordLink.FindLast() then
            LastLinkID := RecordLink."Link ID"
        else
            LastLinkID := 0;
    end;

}