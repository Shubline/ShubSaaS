tableextension 50134 "TableExtTransferShipmentLine" extends "Transfer Shipment Line"
{
    fields
    {
        field(50000;"Exported to Sales Register";Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Exported to Sales Register';
        }
        field(50001;"Remarks";Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Remarks';
            OptionMembers = " ", "General Order", "Short Received", "Expiry Return", "Customer Complain", "Packing Issue", "Quality Issue", "Printing Issue", "Item Mismatch", "Reorder", "Transfer (Within Store)";
            OptionCaption = ' ,General Order,Short Received,Expiry Return,Customer Complain,Packing Issue,Quality Issue,Printing Issue,Item Mismatch,Reorder,Transfer (Within Store)';
        }
    }
    
    var myInt: Integer;
}