xmlport 50000 Lotinfo
{
    Caption = 'Lotinfo';

    schema
    {
        textelement(RootNodeName)
        {
            tableelement(LotNoInformation; "Lot No. Information")
            {
            }
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        
        actions
        {
            area(processing)
            {
            }
        }
    }
}
