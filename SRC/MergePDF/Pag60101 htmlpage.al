page 60101 htmlpage
{
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'htmlpage';
    PageType = Card;

    layout
    {
        area(content)
        {
            usercontrol(HTML; HTML)
            {
                ApplicationArea = all;
                trigger ControlReady()
                var
                    htmltxt: Text;
                begin
                    HTMLtxt := '<html> <head> <style></style> </head> <body> <div id="clock">8:10:45</div>	</body></html>';
                    CurrPage.HTML.Render(htmltxt);
                end;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SHOwtime)
            {
                ApplicationArea = All;
                Image = Order;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    Recref1: RecordRef;
                begin

                end;
            }
        }
    }
}