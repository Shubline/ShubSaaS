report 50002 "Table Structure Details"
{
    ApplicationArea = All;
    Caption = 'Table Structure Details';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Excel;
    ExcelLayout = 'Table Structure Details.xlsx';
    
    dataset
    {
        dataitem(Field; "Field")
        {
            RequestFilterFields = TableNo;
            column(TableNo; TableNo)
            {
            }
            column(No; "No.")
            {
            }
            column(TableName; TableName)
            {
            }
            column(FieldName; FieldName)
            {
            }
            column(Type; "Type")
            {
            }
            column(Len; Len)
            {
            }
            column(Class; Class)
            {
            }
            column(PrimaryKey; IsPartOfPrimaryKey)
            {
            }
            column(Enabled; Enabled)
            {
            }
            column(FieldCaption; "Field Caption")
            {
            }
            column(RelationTableNo; RelationTableNo)
            {
            }
            column(RelationFieldNo; RelationFieldNo)
            {
            }
            column(OptionString; OptionString)
            {
            }
            column(DataClassification; "DataClassification")
            {
            }
            column(ObsoleteState; ObsoleteState)
            {
            }
            column(ObsoleteReason; ObsoleteReason)
            {
            }

            trigger OnPreDataItem()
            begin
                Field.SetRange(TableNo, 50000, 99999);
                Field.SetFilter("No.", '<%1', 2000000000);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(General)
                {
                   
                }
            }
        }
    }
}