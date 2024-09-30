report 50001 "Inventory Update"
{
    ApplicationArea = All;
    Caption = 'Inventory Update';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    UseRequestPage = true;
    dataset
    {
        dataitem(Integer; Integer)
        {
            trigger OnPreDataItem()
            var
                Inventory: Record Inventory;
            begin
                InventoryQuery.Open();

                Clear(Inventory);
                Inventory.Reset();
                Inventory.DeleteAll(true);
            end;

            trigger OnAfterGetRecord()
            var
                Inventory: Record Inventory;
            begin
                if not InventoryQuery.Read() then
                    CurrReport.Break();

                Inventory.Init();
                Inventory.Validate("Location Code", InventoryQuery.LocationCode);
                Inventory.Validate("Item No.", InventoryQuery.ItemNo);
                Inventory.Validate("Variant Code", InventoryQuery.VariantCode);
                Inventory.Validate("Actual Inventory", InventoryQuery.Inventory);
                Inventory.Insert(true);
            end;

            trigger OnPostDataItem()
            begin
                InventoryQuery.Close();
            end;
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
    }

    trigger OnPreReport()
    begin

    end;

    trigger OnPostReport()
    begin

    end;

    var
        InventoryQuery: Query "Inventory Query";
}
