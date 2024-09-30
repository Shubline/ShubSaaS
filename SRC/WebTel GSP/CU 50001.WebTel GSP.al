codeunit 60078 WebtelGSp
{
    trigger OnRun()
    begin
    end;

    var
        JsonText: Text;
        DocumentNo: Code[25];

    procedure SetDocNo(DocNo: Code[25])
    begin
        DocumentNo := DocNo;
    end;

    procedure GetAccessToken()
    var
        Content: HttpContent;
        HttpClient: HttpClient;
        HttpHeadersContent: HttpHeaders;
        HttpResponse: HttpResponseMessage;
        ResponseMsg: HttpResponseMessage;

        URL: Text;
        JsonBody: Text;

        JsonRequest: Text;

        ResponseText: Text;

        Jobject: JsonObject;

        AccessJsonRequest: Text;
        JAccessToken: JsonToken;
        AccessToken: Text;
        JerrorMessage: JsonToken;
        errorMessage: Text;
        WebTelIntegration: Record "Webtel Integration Setup";
    begin
        if WebTelIntegration.Get() then
            URL := WebTelIntegration."URL to Generate IRN";

        // Create Json Body
        JsonRequest := CreateJsonBody();

        Message('E-Invoice Payload :- ' + JsonText);

        Content.WriteFrom(JsonRequest);
        content.GetHeaders(HttpHeadersContent);

        // API Header
        HttpHeadersContent.Clear();
        HttpHeadersContent.Add('Content-Type', 'application/json');
        HttpHeadersContent.Add('Return-Type', 'application/json');

        // API Post
        HttpCLient.Post(Url, Content, HttpResponse);

        // API Response Read
        HttpResponse.Content().ReadAs(ResponseText);
        Message('Access Token Response :- ' + ResponseText);

    end;


    local procedure CreateJsonBody(): Text
    var
        JDataObject: JsonObject;
        JObject: JsonObject;
        JGenerateAccessToken: JsonObject;
        JDataArray: JsonArray;
        JRequest: Text;
        WebTelIntegration: Record "Webtel Integration Setup";
    begin
        Clear(JDataObject);

        JDataObject.Add('Gstin', '29AAACW3775F000');
        JDataObject.Add('Irn', '');
        JDataObject.Add('Tran_SupTyp', 'B2B');
        JDataObject.Add('Tran_RegRev', 'N');
        JDataObject.Add('Tran_Typ', 'REG');
        JDataObject.Add('Tran_EcmGstin', '');
        JDataObject.Add('Tran_IgstOnIntra', 'N');
        JDataObject.Add('Doc_Typ', 'INV');
        JDataObject.Add('Doc_No', DocumentNo);
        JDataObject.Add('Doc_Dt', '10/01/2024');
        JDataObject.Add('BillFrom_Gstin', '29AAACW3775F000');
        JDataObject.Add('BillFrom_LglNm', 'Webtel Electrosoft P. Ltd.');
        JDataObject.Add('BillFrom_TrdNm', 'Webtel Electrosoft P. Ltd.');
        JDataObject.Add('BillFrom_Addr1', '110-114');
        JDataObject.Add('BillFrom_Addr2', '');
        JDataObject.Add('BillFrom_Loc', 'Raje Place');
        JDataObject.Add('BillFrom_Pin', '562160');
        JDataObject.Add('BillFrom_Stcd', '29');
        JDataObject.Add('BillFrom_Ph', '');
        JDataObject.Add('BillFrom_Em', '');
        JDataObject.Add('BillTo_Gstin', '07AAACW3775F1Z8');
        JDataObject.Add('BillTo_LglNm', 'Webtel Electrosoft P. Ltd.');
        JDataObject.Add('BillTo_TrdNm', 'Webtel Electrosoft P. Ltd.');
        JDataObject.Add('BillTo_Pos', '07');
        JDataObject.Add('BillTo_Addr1', '110-114');
        JDataObject.Add('BillTo_Addr2', '');
        JDataObject.Add('BillTo_Loc', 'Rajendra Place');
        JDataObject.Add('BillTo_Pin', '110008');
        JDataObject.Add('BillTo_Stcd', '07');
        JDataObject.Add('BillTo_Ph', '');
        JDataObject.Add('BillTo_Em', '');
        JDataObject.Add('Item_SlNo', '1');
        JDataObject.Add('Item_PrdDesc', 'Web-e-Invoice Solution');
        JDataObject.Add('Item_IsServc', 'Y');
        JDataObject.Add('Item_HsnCd', '9963');
        JDataObject.Add('Item_Barcde', '');
        JDataObject.Add('Item_Qty', '');
        JDataObject.Add('Item_FreeQty', '');
        JDataObject.Add('Item_Unit', '');
        JDataObject.Add('Item_UnitPrice', '100000');
        JDataObject.Add('Item_TotAmt', '100000');
        JDataObject.Add('Item_Discount', '');
        JDataObject.Add('Item_PreTaxVal', '100000');
        JDataObject.Add('Item_AssAmt', '100000');
        JDataObject.Add('Item_GstRt', '18');
        JDataObject.Add('Item_IgstAmt', '18000');
        JDataObject.Add('Item_CgstAmt', '');
        JDataObject.Add('Item_SgstAmt', '');
        JDataObject.Add('Item_CesRt', '');
        JDataObject.Add('Item_CesAmt', '');
        JDataObject.Add('Item_CesNonAdvlAmt', '');
        JDataObject.Add('Item_StateCesRt', '');
        JDataObject.Add('Item_StateCesAmt', '');
        JDataObject.Add('Item_StateCesNonAdvlAmt', '');
        JDataObject.Add('Item_OthChrg', '');
        JDataObject.Add('Item_TotItemVal', '118000');
        JDataObject.Add('Item_OrdLineRef', '');
        JDataObject.Add('Item_OrgCntry', '');
        JDataObject.Add('Item_PrdSlNo', '');
        JDataObject.Add('Item_Attrib_Nm', 'Support Type^Tenure');
        JDataObject.Add('Item_Attrib_Val', 'On-Site^1-Year');
        JDataObject.Add('Item_Bch_Nm', '');
        JDataObject.Add('Item_Bch_ExpDt', '');
        JDataObject.Add('Item_Bch_WrDt', '');
        JDataObject.Add('Val_AssVal', '100000');
        JDataObject.Add('Val_CgstVal', '');
        JDataObject.Add('Val_SgstVal', '');
        JDataObject.Add('Val_IgstVal', '18000');
        JDataObject.Add('Val_CesVal', '');
        JDataObject.Add('Val_StCesVal', '');
        JDataObject.Add('Val_Discount', '');
        JDataObject.Add('Val_OthChrg', '');
        JDataObject.Add('Val_RndOffAmt', '');
        JDataObject.Add('Val_TotInvVal', '118000');
        JDataObject.Add('Val_TotInvValFc', '');
        JDataObject.Add('Pay_Nm', '');
        JDataObject.Add('Pay_AccDet', '');
        JDataObject.Add('Pay_Mode', '');
        JDataObject.Add('Pay_FinInsBr', '');
        JDataObject.Add('Pay_PayTerm', '');
        JDataObject.Add('Pay_PayInstr', '');
        JDataObject.Add('Pay_CrTrn', '');
        JDataObject.Add('Pay_DirDr', '');
        JDataObject.Add('Pay_CrDay', '');
        JDataObject.Add('Pay_PaidAmt', '');
        JDataObject.Add('Pay_PaymtDue', '');
        JDataObject.Add('Ref_InvRm', '');
        JDataObject.Add('Ref_InvStDt', '');
        JDataObject.Add('Ref_InvEndDt', '');
        JDataObject.Add('Ref_PrecDoc_InvNo', '');
        JDataObject.Add('Ref_PrecDoc_InvDt', '');
        JDataObject.Add('Ref_PrecDoc_OthRefNo', '');
        JDataObject.Add('Ref_Contr_RecAdvRefr', '');
        JDataObject.Add('Ref_Contr_RecAdvDt', '');
        JDataObject.Add('Ref_Contr_TendRefr', '');
        JDataObject.Add('Ref_Contr_ContrRefr', '');
        JDataObject.Add('Ref_Contr_ExtRefr', '');
        JDataObject.Add('Ref_Contr_ProjRefr', '');
        JDataObject.Add('Ref_Contr_PORefr', '');
        JDataObject.Add('Ref_Contr_PORefDt', '');
        JDataObject.Add('AddlDoc_Url', 'www.webtel.in^www.gstinindia.in');
        JDataObject.Add('AddlDoc_Docs', '');
        JDataObject.Add('AddlDoc_Info', '');
        if WebTelIntegration.Get() then begin
            JDataObject.Add('CDKey', WebTelIntegration.CDKEY);
            JDataObject.Add('EInvUserName', WebTelIntegration.EINVUSERNAME);
            JDataObject.Add('EInvPassword', WebTelIntegration.EINVPASSWORD);
            JDataObject.Add('EFUserName', WebTelIntegration.EFUSERNAME);
            JDataObject.Add('EFPassword', WebTelIntegration.EFPASSWORD);
        end;

        Clear(JDataArray);
        JDataArray.Add(JDataObject);

        Clear(JObject);
        JObject.Add('Data', JDataArray);

        Clear(JGenerateAccessToken);
        JGenerateAccessToken.Add('Push_Data_List', JObject);
        JGenerateAccessToken.WriteTo(JsonText);

        exit(JsonText);
    end;
}