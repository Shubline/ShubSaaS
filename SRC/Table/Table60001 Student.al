table 60001 Student
{
    DataClassification = ToBeClassified;
    DrillDownPageId = 60001;
    LookupPageId = 60001;

    fields
    {
        field(1; "Addmission No."; code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            var
                InStr: InStream;
                TempBlob: Codeunit "Temp Blob";
                QRGenerator: Codeunit "QR Generator";
            begin
                TempBlob.CreateInStream(InStr);
                QRGenerator.GenerateQRCodeImage(Rec."Addmission No.", TempBlob);
                Image.ImportStream(InStr, 'QR code', 'image/jpeg');
            end;
        }
        field(2; Name; Text[100])
        {
            DataClassification = ToBeClassified;
            InitValue = 'Shubham';
        }
        field(3; "Parent Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; DOB; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; Address; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(6; Address2; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "PostalCode"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Post Code";
            trigger OnValidate()
            var
                PostCode: Record "Post Code";
            begin
                PostCode.Reset();
                Postcode.SetFilter(code, Rec."PostalCode");
                if PostCode.FindFirst() then
                    city := PostCode.City;
            end;
        }
        field(8; city; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; "Mobile No."; Text[10])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                Length: Integer;
                NewStr: Text[10];
            begin
                Length := StrLen(Rec."Mobile No.");

                if (Length <> 10) then
                    Error('length should be 10');

                NewStr := CopyStr(Rec."Mobile No.", 1, 1);

                if (NewStr IN ['1' .. '5']) then
                    Error('Intial should be 6,7,8 & 9');

            end;
        }
        field(10; Transportation; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(11; class; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fee Structure"."Class Code";
        }
        field(12; balance; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Student ledger Entries"."Remaning  Amount" where("Addmission No." = field("Addmission No."))); // , open = const(true)
            Editable = false;
        }
        field(13; Status; Option)
        {
            OptionMembers = "Open","Release",Post;
            DataClassification = ToBeClassified;
        }
        field(14; Picture; Blob)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(15; "Image"; Media)
        {
            Caption = 'Image';
            ExtendedDatatype = Person;
        }
        field(16; "PDF"; Media)
        {
            Caption = 'PDF';
            ExtendedDatatype = Person;
        }
        field(17; "Date time"; Time)
        {
            Caption = 'Date time';
            trigger OnValidate()
            var
                ttime: time;
            begin
                Evaluate(ttime, Format(Rec."Date time", 0, '<Hours24>.<Minutes,2>.<Seconds,2>'));
                Rec."Date time" := ttime;
            end;
        }
    }

    keys
    {
        key(Key1; "Addmission No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        StudentSetup: record "Student Setup";
    begin
        StudentSetup.Get();
        if "Addmission No." = '' then
            InitNoSeries(StudentSetup."Addmission No.");
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

    protected var
        addcurr: code[20]; // protected var

    var
        myLocalInt: Integer; // local var


    Procedure InitNoSeries(NoSeriesCode: Code[25])
    var
        NoSeriesMgt: Codeunit "No. Series - Batch";
    begin
        Clear(NoSeriesMgt);
        Validate("Addmission No.", (NoSeriesMgt.GetNextNo(NoSeriesCode, 0D, true)));
        NoSeriesMgt.SaveState();
    end;
}