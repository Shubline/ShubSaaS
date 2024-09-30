page 50003 "E-Way Bill (Transfer)"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "E-Invoice & E-Way Bill";
    SourceTableView = WHERE("Transaction Type" = FILTER('Transfer Shipment'));
    Permissions = TableData "Transfer Shipment Header" = rm;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                    Editable = false;
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    ApplicationArea = All;
                    Caption = 'Transfer-to Code';
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Caption = 'Transfer-from Code';
                    Editable = false;
                }
                field("Amount to Transfer"; Rec."Amount to Transfer")
                {
                    ApplicationArea = All;
                    Caption = 'Amount to Transfer';
                    Editable = false;
                }
                field("Location GST Reg. No."; Rec."Location GST Reg. No.")
                {
                    ApplicationArea = All;
                    Caption = 'Location GST Reg. No.';
                    Editable = false;
                }
                field("Distance (Km)"; Rec."Distance (Km)")
                {
                    ApplicationArea = All;
                    Caption = 'Distance (Km)';
                    Editable = false;
                }
                field("LR/RR No."; Rec."LR/RR No.")
                {
                    ApplicationArea = All;
                    Caption = 'LR/RR No.';
                    Editable = true;
                }
                field("LR/RR Date"; Rec."LR/RR Date")
                {
                    ApplicationArea = All;
                    Caption = 'LR/RR Date';
                    Editable = true;
                }
                field("Vehicle No."; Rec."Vehicle No.")
                {
                    ApplicationArea = All;
                    Caption = 'Vehicle No.';
                    Editable = true;
                }
                field("Mode of Transport"; Rec."Mode of Transport")
                {
                    ApplicationArea = All;
                    Caption = 'Mode of Transport';
                    Editable = true;
                }
                field("Vehicle Type"; Rec."Vehicle Type")
                {
                    ApplicationArea = All;
                    Caption = 'Vehicle Type';
                    Editable = true;
                }
                field("Port Code"; Rec."Port Code")
                {
                    ApplicationArea = All;
                    Caption = 'Port Code';
                    Editable = true;
                }
                field("Transporter Code"; Rec."Transporter Code")
                {
                    ApplicationArea = All;
                    Caption = 'Transporter Code';
                    Editable = true;
                }
                field("E-Way Bill No."; Rec."E-Way Bill No.")
                {
                    ApplicationArea = All;
                    Caption = 'E-Way Bill No.';
                    Editable = false;
                }
                field("E-Way Bill Date"; Rec."E-Way Bill Date")
                {
                    ApplicationArea = All;
                    Caption = 'E-Way Bill Date';
                    Editable = false;
                }
                field("E-Way Bill Valid Upto"; Rec."E-Way Bill Valid Upto")
                {
                    ApplicationArea = All;
                    Caption = 'E-Way Bill Valid Upto';
                    Editable = false;
                }
                field("Reason Code for Cancel"; Rec."Reason Code for Cancel")
                {
                    ApplicationArea = All;
                    Caption = 'Reason Code for Cancel';
                    Editable = true;
                }
                field("Reason for Cancel Remarks"; Rec."Reason for Cancel Remarks")
                {
                    ApplicationArea = All;
                    Caption = 'Reason for Cancel Remarks';
                    Editable = true;
                }
                field("E-Way Bill Report URL"; Rec."E-Way Bill Report URL")
                {
                    ApplicationArea = All;
                    Caption = 'E-Way Bill Report URL';
                    Editable = false;
                }
                field("E-Way Bill Status"; Rec."E-Way Bill Status")
                {
                    ApplicationArea = All;
                    Caption = 'E-Way Bill Status';
                    Editable = false;
                }
                field("Posting User ID"; Rec."Posting User ID")
                {
                    ApplicationArea = All;
                    Caption = 'Posting User ID';
                    Editable = false;
                }
                field("Posting Date Time"; Rec."Posting Date Time")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date Time';
                    Editable = false;
                }
            }
        }
    }
    actions
    {
    }

    var
}
