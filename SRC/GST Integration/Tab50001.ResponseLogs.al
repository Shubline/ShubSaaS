table 50001 "Response Logs"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1;"Rec ID";Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Rec ID';
            AutoIncrement = true;
        }
        field(2;"Document No.";Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Document No.';
        }
        field(3;"Status";Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Status';
        }
        field(4;"Response Log 1";Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Response Log 1';
        }
        field(5;"Response Log 2";Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Response Log 2';
        }
        field(6;"Response Log 3";Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Response Log 3';
        }
        field(7;"Response Log 4";Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Response Log 4';
        }
        field(8;"Response Log 5";Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Response Log 5';
        }
        field(9;"Response Date";Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Response Date';
        }
        field(10;"Response Time";Time)
        {
            DataClassification = ToBeClassified;
            Caption = 'Response Time';
        }
        field(11;"Called API";Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Called API';
        }
        field(12;"Response Log 6";Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Response Log 6';
        }
        field(13;"Response Log 7";Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Response Log 7';
        }
        field(14;"Response Log 8";Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Response Log 8';
        }
        field(15;"Response Log 9";Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Response Log 9';
        }
        field(16;"Response Log 10";Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Response Log 10';
        }
        field(17;"Response Log 11";Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Response Log 11';
        }
        field(18;"Response Log 12";Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Response Log 12';
        }
        field(19;"Response Log 13";Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Response Log 13';
        }
        field(20;"Response Log 14";Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Response Log 14';
        }
        field(21;"Response Log 15";Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Response Log 15';
        }
        field(22;"Response Log 16";Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Response Log 16';
        }
        field(23;"Response Log 17";Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Response Log 17';
        }
        field(24;"Response Log 18";Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Response Log 18';
        }
        field(25;"Response Log 19";Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Response Log 19';
        }
        field(26;"Response Log 20";Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Response Log 20';
        }
    }
    keys
    {
        key(Key1;"Rec ID")
        {
            Clustered = true;
        }
    }
    var myInt: Integer;
    trigger OnInsert()begin
    end;
    trigger OnModify()begin
    end;
    trigger OnDelete()begin
    end;
    trigger OnRename()begin
    end;
}