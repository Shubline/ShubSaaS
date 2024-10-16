report 50003 "Detailded Table Structure"
{
    ApplicationArea = All;
    Caption = 'Detailded Table Structure';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem(AllObjWithCaption; AllObjWithCaption)
        {
            DataItemTableView = where("Object Type" = filter('Table'));

            dataitem(Field; Field)
            {
                DataItemLinkReference = AllObjWithCaption;
                DataItemLink = TableNo = field("Object ID");

                trigger OnPreDataItem()
                begin
                    Field.SetFilter("No.", '<%1', 2000000000);
                end;

                trigger OnAfterGetRecord()
                begin
                    MakeBody();
                end;

                trigger OnPostDataItem()
                begin
                    if NewBook then
                        CreateExcelSheet(Field.TableName, false)
                    else begin
                        CreateExcelSheet(Field.TableName, True);
                        NewBook := true;
                    end;
                end;
            }

            trigger OnPreDataItem()
            begin
                AllObjWithCaption.SetRange("Object ID", 50000, 99999);
            end;

            trigger OnAfterGetRecord()
            begin
                MakeHeader();
            end;
        }
    }

    trigger OnInitReport()
    begin
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
    end;

    trigger OnPostReport()
    begin
        CreateExcelbook;
    end;

    local procedure MakeHeader()
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Object Type', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AllObjWithCaption."Object Type", FALSE, '', False, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Object ID', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AllObjWithCaption."Object ID", FALSE, '', False, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Object Name', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AllObjWithCaption."Object Name", FALSE, '', False, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);

        TempExcelBuffer.NewRow();
        TempExcelBuffer.NewRow();
        // TempExcelBuffer.AddColumn('Table No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        // TempExcelBuffer.AddColumn('Table Name', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Field No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Field Name', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Type', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Field Lenght', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Class', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Primary Key', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Enabled', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Field Caption', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Relation Table No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Relation Field No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Option String', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Data Classification', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeBody()
    var
        FieldLenth: Integer;
    begin
        TempExcelBuffer.NewRow();
        // TempExcelBuffer.AddColumn(Field.TableNo, FALSE, '', False, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);
        // TempExcelBuffer.AddColumn(Field.TableName, FALSE, '', False, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Field."No.", FALSE, '', False, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Field.FieldName, FALSE, '', False, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Field.Type, FALSE, '', False, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Field.Len, FALSE, '', False, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Field.Class, FALSE, '', False, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Field.IsPartOfPrimaryKey, FALSE, '', False, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Field.Enabled, FALSE, '', False, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Field."Field Caption", FALSE, '', False, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Field.RelationTableNo, FALSE, '', False, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Field.RelationFieldNo, FALSE, '', False, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);

        if 250 > FieldLenth then
            TempExcelBuffer.AddColumn(Field.OptionString, FALSE, '', False, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text)
        else
            TempExcelBuffer.AddColumn('More then 250 Error', FALSE, '', False, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);

        TempExcelBuffer.AddColumn(Field.DataClassification, FALSE, '', False, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
    end;

    procedure CreateExcelbook()
    begin
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename('Detailded Table Structure');
        TempExcelBuffer.OpenExcel();
    end;

    local procedure CreateExcelSheet(SheetName: Text[250]; NewBook: Boolean)
    begin
        if NewBook then
            TempExcelBuffer.CreateNewBook(SheetName)
        else
            TempExcelBuffer.SelectOrAddSheet(SheetName);
        TempExcelBuffer.WriteSheet(SheetName, CompanyName, UserId);
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.ClearNewRow();
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        NewBook: Boolean;
}