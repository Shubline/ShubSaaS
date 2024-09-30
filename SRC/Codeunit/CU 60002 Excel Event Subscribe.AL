codeunit 61002 "Excel Event Subscribe"
{
    var

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Excel Import", ForMultipleSheet, '', true, true)]
    local procedure ForMultipleSheet(var NamevalueBufferOut: Record "Name/Value Buffer" temporary; var TempExcelBuffer: Record "Excel Buffer" temporary; SheetName: Text; MaxRowNo: Integer; MaxColumnNo: Integer)
    var
        RowNo: Integer;
        ColumnNo: Integer;
    begin
        for RowNo := 2 to MaxRowNo do begin
            for ColumnNo := 1 to MaxColumnNo do begin
                ForEachColumn(SheetName, TempExcelBuffer, RowNo, ColumnNo);
            end;
            ForEachRow(SheetName, TempExcelBuffer, RowNo, ColumnNo);
        end;
    end;

    procedure GetValueAtCell(var TempExcelBuffer: Record "Excel Buffer"; RowNo: Integer; ColumnNo: Integer): Text
    begin
        TempExcelBuffer.Reset();
        If TempExcelBuffer.Get(RowNo, ColumnNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    local procedure ForEachRow(SheetName: Text; var TempExcelBuffer: Record "Excel Buffer"; RowNo: Integer; ColumnNo: Integer)
    var
        myInt: Integer;
    begin
        case SheetName of
            'Header':
                begin
                    // Function
                end;
            'Line':
                begin
                    // Function
                end;
        end;
    end;

    local procedure ForEachColumn(SheetName: Text; var TempExcelBuffer: Record "Excel Buffer"; RowNo: Integer; ColumnNo: Integer)
    var
        myInt: Integer;
    begin
        case SheetName of

        end;
    end;
}