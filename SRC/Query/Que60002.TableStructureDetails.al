query 60002 "Table Structure Details"
{
    Caption = 'Table Structure Details';
    QueryType = Normal;

    elements
    {
        dataitem("Field"; "Field")
        {
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
            column("Type"; "Type")
            {
            }
            column(Len; Len)
            {
            }
            column(PrimaryKey; IsPartOfPrimaryKey)
            {
            }
            column(Class; Class)
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
            column("DataClassification"; "DataClassification")
            {
            }
            column(ObsoleteState; ObsoleteState)
            {
            }
            column(ObsoleteReason; ObsoleteReason)
            {
            }
        }
    }

    trigger OnBeforeOpen()
    begin
    end;
}
