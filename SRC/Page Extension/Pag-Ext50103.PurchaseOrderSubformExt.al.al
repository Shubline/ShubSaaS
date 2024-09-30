pageextension 50103 "Purchase Order Subform Ext" extends "Purchase Order Subform"
{
    layout
    {
        addafter("No.")
        {
            field("Purchase Type"; Rec."Purchase Type")
            {
                ApplicationArea = all;
            }
            // field(Name;   )
            // {
            //     ApplicationArea = All;
            //     trigger OnValidate()
            //     begin
            //         if Rec."Purchase Type" = Rec."Purchase Type"::"Job Work" then begin
            //             Message('Value is %1', Format(Enum1));
            //         end else begin
            //             Message('Value is %1', Format(Enum2));
            //         end;
            //     end;
            // }
            field("Insurance No"; Rec."Insurance No")
            {
                ApplicationArea = all;
            }
            field("Gen. Prod. Posting Group1"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = all;
            }
            field("Gen. Bus. Posting Group1"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        Enum1: Option "11","22";
        Enum2: Option "33","44";

    procedure EnumValue(): Option
    begin
        if Rec."Purchase Type" = Rec."Purchase Type"::"Job Work" then begin
            exit(Enum1);
        end else begin
            exit(Enum2);
        end;
    end;
}