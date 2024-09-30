page 50058 "POS List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "POS Header";
    CardPageId = "POS Header";
    SourceTableView = where("POS Posted" = const(false));

    layout
    {
        area(Content)
        {
            repeater(POS)
            {
                field("Receipt No."; Rec."Receipt No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Mobile No."; Rec."Mobile No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
        }
    }

    var
        myInt: Integer;
}