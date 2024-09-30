page 50005 "Extension Download"
{
    ApplicationArea = All;
    Caption = 'Extension Download';
    PageType = List;
    SourceTable = "NAV App Installed App";
    UsageCategory = Lists;
    Editable = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    DelayedInsert = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ID; Rec."App ID")
                {
                    ToolTip = 'Specifies the value of the ID field.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the name of the extension.';
                }
                field(Publisher; Rec.Publisher)
                {
                    ToolTip = 'Specifies the publisher of the extension.';
                }
                field("Extension Version"; Version())
                {
                    ToolTip = 'Specifies the value of the Version Major field.';
                }
                field("Extension Deatils"; ExtensionDetail())
                {
                    ToolTip = 'Specifies the value of the Version Major field.';
                }
            }
        }
    }

    procedure Version() VersionName: Text
    begin
        VersionName := Format(Rec."Version Major") + '.' + Format(Rec."Version Minor") + '.' + Format(Rec."Version Build") + '.' + Format(Rec."Version Revision");
    end;

    procedure ExtensionDetail() ext: Text
    var
        IDs: Text;
    begin
        IDs := Format(Rec."App ID");
        IDs := DelChr(StrSubstNo(IDs), '=', '{');
        IDs := DelChr(StrSubstNo(IDs), '=', '}');
        ext := '{ ' + '"id": "' + IDs + '",' + '"name": "' + Format(Rec.Name) + '",' +
        '"version":"' + Version() + '",' + '"publisher": "' + Format(Rec.Publisher) + '"'

        + '}' + ',';
    end;
}
