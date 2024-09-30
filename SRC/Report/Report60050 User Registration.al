report 60050 "Student Registration"
{
    ApplicationArea = All;
    Caption = 'Student Registration';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    UseRequestPage = true;
    dataset
    {
        dataitem(Student; Student)
        {
            RequestFilterFields = "Addmission No.";

            trigger OnAfterGetRecord()  // to Get the last record of student (Addmission no.)
            var
                EntryNo: Integer;
            begin
                SLEntry.Reset();
                if SLEntry.FindLast then
                    EntryNo := SLEntry."Entry No." + 1
                else
                    EntryNo := 1;

                SLEntry.Reset();
                SLEntry.Init();
                SLEntry.Validate("Entry No.", EntryNo);
                SLEntry.Validate("Addmission No.", "Addmission No.");
                SLEntry.Validate("Student Name", Name);
                SLEntry.Validate("Fee Type", SLEntry."Fee Type"::"Quarter Fee");
                SLEntry.Validate(Open, true);
                // SLEntry.Validate(Month,);
                SLEntry.Validate(Amount, RecFeeStr.ClaculateTotalFeesAmount(ClassCode, Transportation, NewAdmn, NoOfMonth));
                SLEntry.Validate("Remaning  Amount", RecFeeStr.ClaculateTotalFeesAmount(ClassCode, Transportation, NewAdmn, 12) - SLEntry.Amount);

                // To insert Session, Quarter, Period

                // intYear := Date2DMY(Today, 3);
                // SLEntry.Session := Format(intYear) + '-' + Format(intYear + 1);

                // if int = 1 then begin
                //     SLEntry.Quarter := SLEntry.Quarter::Q1;
                //     SLEntry.Period := SLEntry.Period::"Apr-Jun";
                //     TxtDate := Format('04-20') + '-' + Format(intYear);
                //     Evaluate(SLEntry."Due Date", TxtDate);
                // end else
                //     if int = 2 then begin
                //         SLEntry.Quarter := SLEntry.Quarter::Q2;
                //         SLEntry.Period := SLEntry.Period::"Jul-Sep";
                //         TxtDate := Format('07-20') + '-' + Format(intYear);
                //         Evaluate(SLEntry."Due Date", TxtDate);
                //     end else
                //         if int = 3 then begin
                //             SLEntry.Quarter := SLEntry.Quarter::Q3;
                //             SLEntry.Period := SLEntry.Period::"Oct-Dec";
                //             TxtDate := Format('10-20') + '-' + Format(intYear);
                //             Evaluate(SLEntry."Due Date", TxtDate);
                //         end else begin
                //             SLEntry.Quarter := SLEntry.Quarter::Q4;
                //             SLEntry.Period := SLEntry.Period::"Jan-Mar";
                //             TxtDate := Format('01-20') + '-' + Format(intYear + 1);
                //             Evaluate(SLEntry."Due Date", TxtDate);
                //         end;
                SLEntry.Insert();

            end;

        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(General)
                {
                    field(ClassCode; ClassCode)
                    {
                        Caption = 'Class';
                        TableRelation = "Fee Structure"."Class Code";
                        ApplicationArea = All;
                    }
                    field(NoOfMonth; NoOfMonth)
                    {
                        Caption = 'No. of Month';
                        ApplicationArea = All;
                    }
                    field(NewAdmn; NewAdmn)
                    {
                        Caption = 'New Admission';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }




    trigger OnPreReport()
    begin
        // intMonth := Date2DMY(Today, 2);
        // if intMonth > 10 then
        //     Error('Registrations are Closed');
    end;

    trigger OnPostReport()
    begin
        Message('Student %1 Registered for the Session.', Student."Addmission No.");
    end;


    var
        SLEntry: Record "Student Ledger Entries";
        ClassCode: Code[10];
        NewAdmn: Boolean;
        int: Integer;
        NoOfMonth: Integer;
        RecFeeStr: Record "Fee Structure";
        intMonth: Integer;
        intYear: Integer;
        TxtDate: Text;

}
