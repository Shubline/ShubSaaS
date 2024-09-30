page 60201 "Sales/Transfer Register"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Sales/Transfer Register";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(group)
            {
                Editable = false;
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                }
                field("Source Document No."; Rec."Source Document No.")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                }
                field("Item Category Description"; Rec."Item Category Description")
                {
                    ApplicationArea = All;
                }
                field("Product Group Code"; Rec."Product Group Code")
                {
                    ApplicationArea = All;
                }

                field(Brand; Rec.Brand)
                {
                    ApplicationArea = all;
                }

                field("Source Line No."; Rec."Source Line No.")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                }
                field("Source Line Description"; Rec."Source Line Description")
                {
                    ApplicationArea = All;
                }
                field("GST Group"; Rec."GST Group")
                {
                    ApplicationArea = all;
                }
                field("HSN/SAC Code"; Rec."HSN/SAC Code")
                {
                    ApplicationArea = all;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = all;
                }
                field("Variant Description"; Rec."Variant Description")
                {
                    ApplicationArea = all;
                }
                field("MRP Price"; Rec."MRP Price")
                {
                    ApplicationArea = All;
                }

                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = All;
                }
                field("Source Name"; Rec."Source Name")
                {
                    ApplicationArea = All;
                }
                field("Shipping Address"; Rec."Shipping Address")
                {
                    ApplicationArea = all;
                }
                field("Customer Reg. No."; Rec."Customer Reg. No.")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Outward Location Code"; Rec."Outward Location Code")
                {
                    ApplicationArea = All;
                }
                field("Outward State Name"; Rec."Outward State Name")
                {
                    ApplicationArea = All;
                }
                field("Outward Location name"; Rec."Outward Location name")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = All;
                }
                field("GST Base Amount"; Rec."GST Base Amount")
                {
                    ApplicationArea = All;
                }
                field("CGST Amount"; Rec."CGST Amount")
                {
                    ApplicationArea = All;
                }
                field("SGST Amount"; Rec."SGST Amount")
                {
                    ApplicationArea = All;
                }
                field("IGST Amount"; Rec."IGST Amount")
                {
                    ApplicationArea = All;
                }
                field("Total GST Amount"; Rec."Total GST Amount")
                {
                    ApplicationArea = All;
                }
                field("Round Off Amount"; Rec."Round Off Amount")
                {
                    ApplicationArea = All;
                }
                field("Net Amount"; Rec."Net Amount")
                {
                    ApplicationArea = All;
                }
                field("TCS Amount"; Rec."TCS Amount")
                {
                    ApplicationArea = all;
                }
                field("Total Bill Amount"; Rec."Total Bill Amount")
                {
                    ApplicationArea = all;
                }
                field("Document Salesperson Code"; Rec."Document Salesperson Code")
                {
                    ApplicationArea = All;
                }
                field("Document Salesperson Name"; Rec."Document Salesperson Name")
                {
                    ApplicationArea = All;
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                }
                field("LR/RR No."; Rec."LR/RR No.")
                {
                    ApplicationArea = All;
                }
                field("LR/RR Date"; Rec."LR/RR Date")
                {
                    ApplicationArea = All;
                }
                field("Transporter Code"; Rec."Transporter Code")
                {
                    ApplicationArea = All;
                }
                field("Vehicle Type"; Rec."Vehicle Type")
                {
                    ApplicationArea = all;
                }
                field("Vehicle No."; Rec."Vehicle No.")
                {
                    ApplicationArea = all;
                }
                field("Due date"; Rec."Due date")
                {
                    ApplicationArea = All;
                }

                field("Source City"; Rec."Source City")
                {
                    ApplicationArea = All;
                }
                field("Source State Code"; Rec."Source State Code")
                {
                    ApplicationArea = All;
                }
                field("Outward State Code"; Rec."Outward State Code")
                {
                    ApplicationArea = All;
                }
                field("Location GST Registration No.";  Rec."Location GST Registration No.")
                {
                    ApplicationArea = all;
                }
                field("Fin. Year"; Rec."Fin. Year")
                {
                    ApplicationArea = All;
                }
                field(Quarter; Rec.Quarter)
                {
                    ApplicationArea = All;
                }
                field(Month; Rec.Month)
                {
                    ApplicationArea = All;
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = All;
                }
                field("Net Weight"; Rec."Net Weight")
                {
                    ApplicationArea = All;
                }
                field("Qty. in KG"; Rec."Qty. in KG")
                {
                    ApplicationArea = all;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Revenue Account Code"; Rec."Revenue Account Code")
                {
                    ApplicationArea = All;
                }
                field("Revenue Account Description"; Rec."Revenue Account Description")
                {
                    ApplicationArea = All;
                }
                field("Customer Type"; Rec."Customer Type")
                {
                    ApplicationArea = all;
                }
                field("Receivable Account Code"; Rec."Receivable Account Code")
                {
                    ApplicationArea = All;
                }
                field("Receivable Account Description"; Rec."Receivable Account Description")
                {
                    ApplicationArea = All;
                }
                field("Gen. Journal Template Code"; Rec."Gen. Journal Template Code")
                {
                    ApplicationArea = All;
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                }
                field("Payment Term Code"; Rec."Payment Term Code")
                {
                    ApplicationArea = All;
                }
                field("Customer Price Group"; Rec."Customer Price Group")
                {
                    ApplicationArea = All;
                }
                field("Customer Price Group Name"; Rec."Customer Price Group Name")
                {
                    ApplicationArea = All;
                }
                field("Customer Disc. Group"; Rec."Customer Disc. Group")
                {
                    ApplicationArea = all;
                }
                field("Customer Disc. Group Name"; Rec."Customer Disc. Group Name")
                {
                    ApplicationArea = all;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("Country/Region Name"; Rec."Country/Region Name")
                {
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = all;
                }
                field("Ship-To Code";  Rec."Ship-To Code")
                {
                    ApplicationArea = all;
                }
                field("Ship-To Name";  Rec."Ship-To Name")
                {
                    ApplicationArea = all;
                }
                field("CGST %";  Rec."CGST %")
                {
                    ApplicationArea = all;
                }
                field("Cess Amount";  Rec."Cess Amount")
                {
                    ApplicationArea = all;
                }
                field("E-Invoice No.";  Rec."E-Invoice No.")
                {
                    ApplicationArea = all;
                }
                field("E-Way Bill No.";  Rec."E-Way Bill No.")
                {
                    ApplicationArea = all;
                }
                field("Delivery Boy";  Rec."Delivery Boy")
                {
                    ApplicationArea = all;
                }
                field("Narration/Comments";  Rec."Narration/Comments")
                {
                    ApplicationArea = all;
                }
                field("Lot No.";  Rec."Lot No.")
                {
                    ApplicationArea = All;
                }
                field("Expiry Date";  Rec."Expiry Date")
                {
                    ApplicationArea = All;
                }
                field("Return Reason Code";  Rec."Return Reason Code")
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
            action("Update Sales/Transfer Register")
            {
                ApplicationArea = All;
                RunObject = report "Sales Register";
                PromotedCategory = Report;
                Promoted = true;

                trigger OnAction()
                begin
                end;
            }
        }
    }
    var
}
