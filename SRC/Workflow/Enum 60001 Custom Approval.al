enum 70000 "Custom Approval Enum"
{
    Extensible = false;

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; "Pending for Approval")
    {
        Caption = 'Pending for Approval';
    }
    value(2; Released)
    {
        Caption = 'Released';
    }
    value(3; Rejected)
    {
        Caption = 'Rejected';
    }
    value(4; Approved)
    {
        Caption = 'Approved';
    }
}
