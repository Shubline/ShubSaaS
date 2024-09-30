codeunit 50102 "Tata Motors Integration"
{
    trigger OnRun()
    begin

    end;

    procedure GetAccessToken()
    var
        Content: HttpContent;
        HttpClient: HttpClient;
        HttpHeadersContent: HttpHeaders;
        HttpResponse: HttpResponseMessage;
        URL: Text;
        ResponseText: Text;
        Jobject: JsonObject;
        JAccessToken: JsonToken;
        JerrorMessage: JsonToken;
    begin
        URL := 'https://g11.tcsgsp.in/Tax-Tool-Core/services/accessMgmt/generateToken';

        // API Header
        HttpHeadersContent.Clear();
        HttpHeadersContent.Add('Content-Type', 'application/json');
        HttpHeadersContent.Add('username', 'api_sales2@amp-india.com');
        HttpHeadersContent.Add('password', 'May@2023');

        // API Post
        Clear(Content);
        HttpCLient.Post(Url, Content, HttpResponse);

        // API Response Read
        HttpResponse.Content().ReadAs(ResponseText);
        Message('Access Token Response :- ' + ResponseText);

        // In Case of Success
        if (HttpResponse.IsSuccessStatusCode = true) then begin
            if (HttpResponse.HttpStatusCode = 200) then begin

                Jobject.ReadFrom(ResponseText);

                if Jobject.Get('access_token', JAccessToken) then begin
                    if JAccessToken.AsValue().AsText() <> '' then begin
                        // UpdateIRN(DocumentNo, IRN.AsValue().AsText());
                        // GetEinvoice(IRN.AsValue().AsText());
                    end else begin
                        // CreateResponseLog(ResponseText, 'Failure', 'Generate E-Invoice');
                        exit;
                    end;
                end;


            end
            else begin

            end;

        end;
    end;
}