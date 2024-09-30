codeunit 60002 "Excel Import"
{
    // to Insert data in the table
    trigger OnRun()
    begin
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;

    procedure ReadExcelSheetDataOnPrem()
    var
        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";

        SheetName, ErrorMessage : Text;
        FileInStream: InStream;
        ImportFileLbl: Label 'Please Choose the Excel file.';
    begin
        // Delete Garbage Data if Any
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();

        // Select file and import the file to tempBlob
        FileManagement.BLOBImportWithFilter(TempBlob, ImportFileLbl, '', FileManagement.GetToFilterText('', '.xlsx'), 'xlsx');

        // Select sheet from the excel file
        TempBlob.CreateInStream(FileInStream);
        SheetName := TempExcelBuffer.SelectSheetsNameStream(FileInStream);

        // Open selected sheet
        TempBlob.CreateInStream(FileInStream);
        ErrorMessage := TempExcelBuffer.OpenBookStream(FileInStream, SheetName);
        if ErrorMessage <> '' then
            Error(ErrorMessage);

        TempExcelBuffer.ReadSheet();

        // Process to be done For Each & Every Row
        ImportExcelSheetData();
    end;

    procedure ReadExcelSheetDataOnSAAS()
    var
        FileMgt: Codeunit "File Management";

        IStream: InStream;
        FromFile: Text[100];
        FileName: Text[100];
        SheetName: Text[100];

        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
    begin
        // Delete Garbage Data if Any
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();

        // Select file and Upload the file to the Server/Saas
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);

        // Select File And sheet from the excel file
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            Error(NoFileFoundMsg);

        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();

        TempExcelBuffer.OpenBookStream(IStream, SheetName);
        TempExcelBuffer.ReadSheet();

        // Process to be done For Each & Every Row
        ImportExcelSheetData();
    end;

    procedure GetMaxRowNo(): Integer
    begin
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then
            exit(TempExcelBuffer."Row No.");
    end;

    procedure GetMaxColumnNo(): Integer
    begin
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then
            exit(TempExcelBuffer."Column No.");
    end;

    procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    var
    begin
        TempExcelBuffer.Reset();
        If TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    local procedure ImportExcelSheetData()
    var
        MaxRowNo: Integer;
        MaxColumnNo: Integer;
        ExcelImportSucess: Label 'Excel is successfully imported.';
    begin
        MaxRowNo := 0;
        MaxColumnNo := 0;

        MaxRowNo := GetMaxRowNo();
        MaxColumnNo := GetMaxColumnNo();

        ForEachSheet(TempExcelBuffer, MaxRowNo, MaxColumnNo);

        Message(ExcelImportSucess);
    end;


    procedure ImportExcelSheetDataFromMultipleSheet()
    var
        MaxRowNo: Integer;
        MaxColumnNo: Integer;
        IStream: InStream;
        FromFile: Text[100];
        FileName: Text[100];
        SheetName: Text[100];
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        FileMgt: Codeunit "File Management";
        NamevalueBufferOut: Record "Name/Value Buffer" temporary;
    begin

        // Delete Garbage Data if Any
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();

        // Select file and Upload the file to the Server/Saas
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);

        // Select File And sheet from the excel file
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            TempExcelBuffer.GetSheetsNameListFromStream(Istream, NamevalueBufferOut);
        end else
            Error(NoFileFoundMsg);

        NamevalueBufferOut.Reset();
        if NamevalueBufferOut.FindFirst() then begin
            repeat
                Clear(SheetName);
                SheetName := NamevalueBufferOut.Value;

                // Reading Excel Data For Each & Every Sheet
                TempExcelBuffer.Reset();
                TempExcelBuffer.DeleteAll();
                TempExcelBuffer.OpenBookStream(IStream, SheetName);
                TempExcelBuffer.ReadSheet();

                MaxRowNo := GetMaxRowNo();
                MaxColumnNo := GetMaxColumnNo();

                ForMultipleSheet(NamevalueBufferOut, TempExcelBuffer, SheetName, MaxRowNo, MaxColumnNo);

            until NamevalueBufferOut.Next() = 0;
        end;
    end;


    // uses Orignal "Excel Buffer" Table Not Temporary
    [Obsolete]
    procedure GetExcelTable()
    var
        ExcelBuffer: Record "Excel Buffer";

        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";

        SheetName, ErrorMessage : Text;
        FileInStream: InStream;
        ImportFileLbl: Label 'Please Choose the Excel file.';
    begin
        // Clear Filter if Any
        Clear(ExcelBuffer);

        // Select file and import the file to tempBlob
        FileManagement.BLOBImportWithFilter(TempBlob, ImportFileLbl, '', FileManagement.GetToFilterText('', '.xlsx'), 'xlsx');

        // Select sheet from the excel file
        TempBlob.CreateInStream(FileInStream);
        SheetName := ExcelBuffer.SelectSheetsNameStream(FileInStream);

        // Open selected sheet
        TempBlob.CreateInStream(FileInStream);
        ErrorMessage := ExcelBuffer.OpenBookStream(FileInStream, SheetName);
        if ErrorMessage <> '' then
            Error(ErrorMessage);

        ExcelBuffer.ReadSheet();
    end;

    [IntegrationEvent(false, false)]
    local procedure ForEachSheet(var TempExcelBuffer: Record "Excel Buffer" temporary; MaxRowNo: Integer; MaxColumnNo: Integer)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure ForMultipleSheet(var NamevalueBufferOut: Record "Name/Value Buffer" temporary; var TempExcelBuffer: Record "Excel Buffer" temporary; SheetName: Text; MaxRowNo: Integer; MaxColumnNo: Integer)
    begin
    end;
}