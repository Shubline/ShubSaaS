page 60006 "User Responsibility Centre"
{
    PageType = StandardDialog;
    ApplicationArea = All;
    UsageCategory = Administration;
    // SourceTable = TableName;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                Caption = 'Welcome, Shubham';
                field(Name; User."Full Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if User.Get(UserSecurityId) then;
    end;


    Var
        User: Record User;
}