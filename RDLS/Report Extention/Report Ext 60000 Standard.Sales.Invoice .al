reportextension 60000 "My report extension" extends "Standard Sales - Invoice"
{
    
    RDLCLayout = 'RDLS/Layouts/ShubhamReportExtension.rdl';

    dataset
    {
        // Add changes to dataitems and columns here
        add(Line)
        {
            column(Order_No_;"Order No.")
            {

            }
        }
    }
    
    requestpage
    {
        // Add changes to the requestpage here
    }
}