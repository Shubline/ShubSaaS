page 50002 "E-Invoice (Sales Return)"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "E-Invoice & E-Way Bill";
    SourceTableView = WHERE("Transaction Type" = FILTER('Sales Credit Memo'));
    Permissions = TableData "Sales Cr.Memo Header" = rm;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'Sell-to Customer No.';
                    Editable = false;

                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    Editable = false;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    Caption = 'Ship-to Code';
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Caption = 'Location Code';
                    Editable = false;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    Caption = 'Sell-to Customer Name';
                    Editable = false;
                }
                field("Sell-to Address"; Rec."Sell-to Address")
                {
                    ApplicationArea = All;
                    Caption = 'Sell-to Address';
                    Editable = false;
                }
                field("Sell-to Address 2"; Rec."Sell-to Address 2")
                {
                    ApplicationArea = All;
                    Caption = 'Sell-to Address 2';
                    Editable = false;
                }
                field("Sell-to City"; Rec."Sell-to City")
                {
                    ApplicationArea = All;
                    Caption = 'Sell-to City';
                    Editable = false;
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                    ApplicationArea = All;
                    Caption = 'Sell-to Post Code';
                    Editable = false;
                }
                field("State"; Rec.State)
                {
                    ApplicationArea = All;
                    Caption = 'State';
                    Editable = false;
                }
                field("Location State Code"; Rec."Location State Code")
                {
                    ApplicationArea = All;
                    Caption = 'Location State Code';
                    Editable = false;
                }
                field("Amount to Customer"; Rec."Amount to Customer")
                {
                    ApplicationArea = All;
                    Caption = 'Amount to Customer';
                    Editable = false;
                }
                field("Location GST Reg. No."; Rec."Location GST Reg. No.")
                {
                    ApplicationArea = All;
                    Caption = 'Location GST Reg. No.';
                    Editable = false;
                }
                field("Customer GST Reg. No."; Rec."Customer GST Reg. No.")
                {
                    ApplicationArea = All;
                    Caption = 'Customer GST Reg. No.';
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
                field("Sell-to Country/Region Code"; Rec."Sell-to Country/Region Code")
                {
                    ApplicationArea = All;
                    Caption = 'Sell-to Country/Region Code';
                    Editable = false;
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ApplicationArea = All;
                    Caption = 'Ship-to Post Code';
                    Editable = false;
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = All;
                    Caption = 'Ship-to Country/Region Code';
                    Editable = false;
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                    ApplicationArea = All;
                    Caption = 'Ship-to City';
                    Editable = false;
                }
                field("GST Customer Type"; Rec."GST Customer Type")
                {
                    ApplicationArea = All;
                    Caption = 'GST Customer Type';
                    Editable = false;
                }
                field("E-Invoice IRN No"; Rec."E-Invoice IRN No")
                {
                    ApplicationArea = All;
                    Caption = 'E-Invoice IRN No.';
                    Editable = false;
                }
                field("E-Invoice Acknowledge No."; Rec."E-Invoice Acknowledge No.")
                {
                    ApplicationArea = All;
                    Caption = 'E-Invoice Acknowledge No.';
                    Editable = false;
                }
                field("E-Invoice Acknowledge Date"; Rec."E-Invoice Acknowledge Date")
                {
                    ApplicationArea = All;
                    Caption = 'E-Invoice Acknowledge Date';
                    Editable = false;
                }
                field("E-Invoice IRN Status"; Rec."E-Invoice IRN Status")
                {
                    ApplicationArea = All;
                    Caption = 'E-Invoice IRN Status';
                    Editable = false;
                }
                field("E-Invoice Cancel Reason"; Rec."E-Invoice Cancel Reason")
                {
                    ApplicationArea = All;
                    Caption = 'E-Invoice Cancel Reason';
                    Editable = true;
                }
                field("E-Invoice Cancel Remarks"; Rec."E-Invoice Cancel Remarks")
                {
                    ApplicationArea = All;
                    Caption = 'E-Invoice Cancel Remarks';
                    Editable = true;
                }
                field("E-Invoice QR Code"; Rec."E-Invoice QR Code")
                {
                    ApplicationArea = All;
                    Caption = 'E-Invoice QR Code';
                    Editable = false;
                }
                field("E-Invoice PDF"; Rec."E-Invoice PDF")
                {
                    ApplicationArea = All;
                    Caption = 'E-Invoice PDF';
                    Editable = false;
                }
                field("E-Invoice Status"; Rec."E-Invoice Status")
                {
                    ApplicationArea = All;
                    Caption = 'E-Invoice Status';
                    Editable = false;
                }
                field("E-Invoice Cancel Date"; Rec."E-Invoice Cancel Date")
                {
                    ApplicationArea = All;
                    Caption = 'E-Invoice Cancel Date';
                    Editable = false;
                }
                field("Cancel E-Way Bill by IRN Date"; Rec."Cancel E-Way Bill by IRN Date")
                {
                    ApplicationArea = All;
                    Caption = 'Cancel E-Way Bill by IRN Date';
                    Editable = false;
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
                field("Cancel E-Way Bill No."; Rec."Cancel E-Way Bill No.")
                {
                    ApplicationArea = All;
                    Caption = 'Cancel E-Way Bill No.';
                    Editable = true;
                }
                field("Cancel E-Way Bill Date"; Rec."Cancel E-Way Bill Date")
                {
                    ApplicationArea = All;
                    Caption = 'Cancel E-Way Bill Date';
                    Editable = true;
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
                field("E-Way Bill Report URL"; Rec."E-Way Bill By IRN Report URL")
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
        eInvoiceNotApplicableCustomerErr: Label 'E-Invoicing is not applicable for Unregistered, Export and Deemed Export Customers.';
        eInvoiceNonGSTTransactionErr: Label 'E-Invoicing is not applicable for Non-GST Transactions.';
}
