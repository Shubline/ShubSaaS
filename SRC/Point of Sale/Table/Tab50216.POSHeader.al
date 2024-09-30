table 50216 "POS Header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(2; "Receipt No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Store No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(4; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if Customer.Get(Rec."Customer No.") then begin
                    Rec.Validate("Customer Name", Customer.Name);
                    Rec.Validate("Mobile No.", Customer."Phone No.");
                end
                else begin
                    Rec.Validate("Customer Name", '');
                end;
            end;
        }
        field(5; "Customer Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Salesperson"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
        field(7; "Mobile No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Estimate No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Posted Estimate No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "POS Posted"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Pre Receipt No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Sales Type"; Option)
        {
            OptionMembers = " ",EMI,Estimate,Purchase,"Sales Return",Advance;
        }
    }

    keys
    {
        key(Key1; "Receipt No.", "Store No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        recUserSetup: Record "User Setup";
        Location: Record Location;
    begin
     
            Rec.validate(Date, Today);
        end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}