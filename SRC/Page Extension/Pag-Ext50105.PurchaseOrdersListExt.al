pageextension 50105 "Purchase Orders Ext" extends "Purchase Order List"
{
    layout
    {
        addfirst(factboxes)
        {
            part(TaxInformatiojn; "Tax Information Factbox")
            {
                Provider = TaxInformatiojn;
                // SubPageLink = "Table ID Filter" = const(39), "Document Type Filter" = field("Document Type"), "Document No. Filter" = field("Document No."), "Line No. Filter" = field("Line No.");
                // ApplicationArea = Basic, Suite;
            }
        }

        addafter("Buy-from Vendor No.")
        {
            field("Purchase Type"; Rec."Purchase Type")
            {
                ApplicationArea = all;
            }
        }

    }
    actions
    {
        addfirst(Action9)
        {
            group("Shubham")
            {
                action(Email)
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Order Email';
                    ToolTip = 'Executes the Sample Email action.';
                    Image = Email;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    trigger OnAction()
                    var
                        EmailCU: Codeunit "Email Report";
                        EmailID: Record "Email ID";
                        PageNo: Integer;
                        RecRef: RecordRef;
                    begin
                        RecRef.Get(Rec.RecordId);
                        Evaluate(PageNo, CopyStr(CurrPage.ObjectId(false), 6));
                        EmailCU.SendEmail(EmailCU.FindEmailID(PageNo, 'Purchase Order Email'), RecRef);
                    end;
                }
                action(SDHSimpleEmail)
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Order Email 2';
                    ToolTip = 'Executes the Sample Email action.';
                    Image = Email;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    trigger OnAction()
                    var
                        SDHCustomEmail: Codeunit "SDH Custom Emails";
                    begin
                        SDHCustomEmail.SendPurchaseOrderEmail(Rec);
                    end;
                }

                action("Purchase Order")
                {
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ApplicationArea = All;
                    Image = Email;

                    trigger OnAction()
                    var
                        Purch: Record "Purchase Header";
                    begin
                        purch.reset();
                        purch.SetRange("No.", Rec."No.");
                        report.run(60101, true, false, Purch);
                    end;
                }

                action("Get Purchase Order")
                {
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ApplicationArea = All;
                    Image = Action;

                    trigger OnAction()
                    var
                        PurchaseOrderPage: page "Purchase Order List";
                        PH: Record "Purchase Header";
                        RecRef: RecordRef;
                    // PurchaseOrderPage: page "Purchase Order Subform";
                    // PH: Record "Purchase Line";
                    begin
                        Clear(PurchaseOrderPage);

                        PH.Reset();
                        //PH.SetRange("No.", Rec."No.");
                        if PH.Find('-') then begin

                            PurchaseOrderPage.SetTableView(PH);

                            PurchaseOrderPage.LookupMode := true;

                            if PurchaseOrderPage.RunModal() = Action::LookupOK then begin
                                PurchaseOrderPage.SetSelectionFilter(PH);
                                if PH.FindFirst() then begin
                                    repeat
                                        Message('Clicked OK %1', PH);
                                    until PH.Next() = 0;
                                end;
                            end
                            else begin
                                Message('Clicked CANCEL %1', PH."No.");
                            end;
                        end;
                    end;
                }

                action("Confirm Dialog")
                {
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ApplicationArea = All;
                    Image = Email;

                    trigger OnAction()
                    var
                    begin

                        if Dialog.Confirm('Do you Want to confirm') then begin
                            Message('Clicked OK ');
                        end else begin
                            Message('Clicked CANCEL');
                        end;

                    end;
                }

                action("Confirm Dialog Multiline")
                {
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ApplicationArea = All;
                    Image = Email;

                    trigger OnAction()
                    var
                        Options: Text[30];
                        Selected: Integer;
                        Text000: Label 'Shubham,tanuj,Abhishek,vaibhav';
                        Text001: Label 'You selected option %1.';
                        Text002: Label 'Choose one of the following options:';
                    begin
                        Options := Text000;

                        // Sets the default to option 1 
                        Selected := Dialog.StrMenu(Options, 1, Text002);

                        if Selected <> 0 then begin
                            Message(Text001, Selected);
                        end else begin
                            Message('Clicked CANCEL and Selected %1 Option', Selected);
                        end;

                    end;
                }

                action("Change Company")
                {
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ApplicationArea = All;
                    Image = ChangeDimensions;

                    trigger OnAction()
                    var
                        Changecom: Codeunit Schedulertsk;
                    begin
                        Changecom.Run();
                    end;
                }

                //     action("Change Company 2123")
                //     {
                //         Promoted = true;
                //         PromotedCategory = Process;
                //         PromotedIsBig = true;
                //         PromotedOnly = true;
                //         ApplicationArea = All;
                //         Image = ChangeDimensions;

                //         trigger OnAction()
                //         var
                //             PageQCparameter: Page QCParameter;
                //             RecHardtuning: Record Hardturning;
                //             RecRef: RecordRef;
                //             selection: Codeunit SelectionFilterManagement;
                //             qty: Decimal;
                //         begin

                //             Clear(PageQCparameter);
                //             RecHardtuning.Reset();
                //             RecHardtuning.SetRange("Process Name", Rec."Process Name/ Department");
                //             if RecHardtuning.FindFirst() then begin
                //                 PageQCparameter.SetTableView(RecHardtuning);
                //                 PageQCparameter.Tushar();
                //                 PageQCparameter.LookupMode := true;
                //                 PageQCparameter.Tushar();
                //                 if PageQCparameter.RunModal() = Action::LookupOK then begin

                //                     PageQCparameter.SetSelectionFilter(RecHardtuning);

                //                     RecRef.GetTable(RecHardtuning);
                //                     Rec."QC Parameter TUSHAR" := selection.GetSelectionFilter(RecRef, RecHardtuning.FieldNo(Parameter));

                //                     if RecHardtuning.FindSet() then begin

                //                         repeat
                //                             qty += RecHardtuning.Quantity;
                //                         until RecHardtuning.Next() = 0;
                //                     end;

                //                     if qty <> rec."Defect Qty." then
                //                         Error('Quantity and  Defated Quantity not equal');

                //                 end;
                //             end else begin

                //                 PageQCparameter.SetTableView(RecHardtuning);
                //                 PageQCparameter.Tushar();
                //                 PageQCparameter.LookupMode := true;
                //                 PageQCparameter.Tushar();
                //                 if PageQCparameter.RunModal() = Action::LookupOK then begin
                //                     PageQCparameter.SetSelectionFilter(RecHardtuning);
                //                     RecRef.GetTable(RecHardtuning);
                //                     Rec."QC Parameter TUSHAR" := selection.GetSelectionFilter(RecRef, RecHardtuning.FieldNo(Parameter));
                //                 end;


                //             end;
                //         end;
                //     }
            }
        }
    }
}
