page 50059 "Karigar Line Subform"
{
    ApplicationArea = All;
    Caption = 'Karigar Line Subform';
    PageType = ListPart;
    SourceTable = "Karigar Issue Line";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Issue No."; Rec."Issue No.")
                {
                    ToolTip = 'Specifies the value of the Issue No. field.', Comment = '%';
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ToolTip = 'Specifies the value of the Item Description field.', Comment = '%';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ToolTip = 'Specifies the value of the Lot No. field.', Comment = '%';
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field("Alternate Quantity"; Rec."Alternate Quantity")
                {
                    ToolTip = 'Specifies the value of the Quantity (In Pcs) field.', Comment = '%';
                    Visible = false;
                }
                field(UOM; Rec.UOM)
                {
                    ToolTip = 'Specifies the value of the UOM field.', Comment = '%';
                }
                field(Rate; Rec.Rate)
                {
                    ToolTip = 'Specifies the value of the Rate field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Item Tracking")
            {
                ApplicationArea = All;
                Caption = 'Item Tracking Lines', comment = 'NLB="YourLanguageCaption"';
                Image = ItemTracking;

                trigger OnAction()
                var
                    ItemTracking: page "Item Tracking Lines";
                    TrackingSpecification: Record "Tracking Specification";
                    KarigarIssueHeader: Record "Karigar Issue Header";
                    CustomTrackingSpecification: Codeunit "Custom Tracking Specification";
                begin
                    KarigarIssueHeader.Get(Rec."Issue No.");

                    CustomTrackingSpecification.InitTrackingSpecification();
                    CustomTrackingSpecification.SetItemData(Rec."Item No.", Rec."Item Description", KarigarIssueHeader."From Location", Rec."Variant Code", '', 1);
                //    CustomTrackingSpecification.SetQuantities();
                    CustomTrackingSpecification.SetSourceType(Database::"Karigar Issue Line", 0);
                    CustomTrackingSpecification.SetSourceID(Rec."Issue No.", '', Rec."Line No.");
                    CustomTrackingSpecification.CallItemTrackingLines();

                    // CallItemTracking(Rec, Rec."Item No.", Rec."Item Description", KarigarIssueHeader."From Location", '', '', 1);
                end;
            }
        }
    }

    // procedure CallItemTracking(PurchLine: Record "Karigar Issue Line"; ItemNo: Code[20]; ItemDescription: Text[100]; LocationCode: Code[10]; VariantCode: Code[10]; BinCode: Code[20]; QtyPerUoM: Decimal)
    // var
    //     TrackingSpecification: Record "Tracking Specification";
    //     ItemTrackingLines: Page "Item Tracking Lines";
    // begin
    //     TrackingSpecification.Init();

    //     TrackingSpecification."Item No." := ItemNo;
    //     TrackingSpecification.Description := ItemDescription;
    //     TrackingSpecification."Location Code" := LocationCode;
    //     TrackingSpecification."Variant Code" := VariantCode;
    //     TrackingSpecification."Bin Code" := BinCode;
    //     TrackingSpecification."Qty. per Unit of Measure" := QtyPerUoM;

    //     TrackingSpecification.SetSource(Database::"Karigar Issue Line" , 1, PurchLine."Issue No.", PurchLine."Line No.", '', 0);

    //     TrackingSpecification.SetQuantities(
    //       PurchLine.Quantity, PurchLine.Quantity, PurchLine.Quantity,
    //       PurchLine.Quantity, PurchLine.Quantity, PurchLine.Quantity,
    //       PurchLine.Quantity);

    //     ItemTrackingLines.SetSourceSpec(TrackingSpecification, Today);
    //     ItemTrackingLines.RunModal();
    // End;
}