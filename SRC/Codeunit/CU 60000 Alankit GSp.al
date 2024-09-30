codeunit 60000 AlankitGSp
{
    Access = Public;
    InherentEntitlements = X;
    InherentPermissions = X;

    trigger OnRun()
    begin

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

        TokenString: Text;

        ResponseText: Text;

        Jobject: JsonObject;
        JsonOBJ_1: JsonObject;

        AccessTokenString: Text;
        JAccessToken: JsonToken;
        AccessToken: Text;
        JerrorMessage: JsonToken;
        errorMessage: Text;
    begin
        URL := 'https://developers.eraahi.com/eInvoiceGateway/eivital/v1.04/auth';

        // Create Json Body
        TokenString := CreateJsonBody();

        Content.WriteFrom(TokenString);
        content.GetHeaders(HttpHeadersContent);

        // API Header
        HttpHeadersContent.Clear();
        HttpHeadersContent.Add('Content-Type', 'application/x-www-form-urlencoded');
        HttpHeadersContent.Add('Ocp-Apim-Subscription-Key', 'AL8m6Z9r0C0v7u0N8I');
        HttpHeadersContent.Add('Gstin', '07AGAPA5363L002');

        // API Post
        HttpCLient.Post(Url, Content, HttpResponse);

        // API Response Read
        HttpResponse.Content().ReadAs(ResponseText);
        Jobject.ReadFrom(ResponseText);

        Message('Access Token Response :- ' + ResponseText);
        if Jobject.Get('access_token', JAccessToken) then
            AccessToken := JAccessToken.AsValue().AsText()
        else
            if Jobject.Get('errorMessage', JerrorMessage) then begin
                errorMessage := JerrorMessage.AsValue().AsText();
                Message(errorMessage);
            end;

        // exit(AccessToken);

    end;



    procedure CreateJsonBody(): Text
    var
        AppKey: Text;
        Base64AppKey: Text;
        Base64Json: Text;
        EncryptBase64Json: Text;
        Base64: Codeunit "Base64 Convert";
        JGenerateAccessToken: JsonObject;
        JRequest: Text;
    begin
        AppKey := GenerateKey();
        Base64AppKey := Base64.ToBase64(AppKey, true);

        Clear(JGenerateAccessToken);
        JGenerateAccessToken.Add('UserName', 'AL001');
        JGenerateAccessToken.Add('Password', 'Alankit@123');
        JGenerateAccessToken.Add('AppKey', Base64AppKey);
        JGenerateAccessToken.Add('ForceRefreshAccessToken', false);

        JGenerateAccessToken.WriteTo(JsonText);

        Base64Json := Base64.ToBase64(JsonText, true);
        EncryptBase64Json := RSA(Base64Json);

        Clear(JGenerateAccessToken);
        Clear(Base64Json);
        JGenerateAccessToken.Add('Data', EncryptBase64Json);
        // JGenerateAccessToken.Add('Data', 'Pq54nKnxbZ449vuHRTdcbYk78Pg8nFnmEyrhRaNj/EeA/UcyW2tqrtTpicUHw3VtpwwOlEVbRTE1Y2KZz3/3/bwEdCa8Jt2+lChpsKT8ujwFq8IE4neTIpdbSqTW/heKj9o2e4dWdNLkq1mDAw6EBJ0iEawqXWFCbORxI8QeqiOKwhxmpxBsrOq0FKx2Ha2NM2pvVdZAie9Iz1Q4onemmbLQrCMGTRllfi3MaSM51IBA2gYMZKnQX8UUDjTsL7CS4dM5IXfmJIKinS5sLknCtAkgyTwhuFtggUSS1LfTrVA5oaWBzfi8UIQ4YCCFZpFyoVI3T5n6u1ei9tO4015OIQ==');
        JGenerateAccessToken.WriteTo(Base64Json);

        exit(Base64Json);
    end;


    procedure RSA(Base64Json: Text): Text
    var
        CryptographyManagement: Codeunit "Cryptography Management";
        HashAlgorithmType: Option AES,RSA,MD5,SHA1,SHA256,SHA384,SHA512;
        ExportFileName: Text;
        ClientFileName: Text;
        PublicKey: Text;
        EncryptJson: Text;
        Instr: InStream;
        Outstr: OutStream;
        TempBlob: Codeunit "Temp Blob";

        RSAEncryption: Codeunit "RSACryptoServiceProvider";
    //   RSACryptoServiceProviderImpl: Codeunit "RSACryptoServiceProvider Impl.";
    begin
        PublicKey := 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArxd93uLDs8HTPqcSPpxZrf0Dc29r3iPp0a8filjAyeX4RAH6lWm9qFt26CcE8ESYtmo1sVtswvs7VH4Bjg/FDlRpd+MnAlXuxChij8/vjyAwE71ucMrmZhxM8rOSfPML8fniZ8trr3I4R2o4xWh6no/xTUtZ02/yUEXbphw3DEuefzHEQnEF+quGji9pvGnPO6Krmnri9H4WPY0ysPQQQd82bUZCk9XdhSZcW/am8wBulYokITRMVHlbRXqu1pOFmQMO5oSpyZU3pXbsx+OxIOc4EDX0WMa9aH4+snt18WAXVGwF2B4fmBk7AtmkFzrTmbpmyVqA3KO2IjzMZPw0hQIDAQAB';

        Clear(Instr);
        Clear(Outstr);
        Clear(TempBlob);
        TempBlob.CreateInStream(Instr);
        TempBlob.CreateOutStream(Outstr);

        Outstr.WriteText(Base64Json);

        RSAEncryption.Encrypt(PublicKey, Instr, false, Outstr);

        Instr.ReadText(EncryptJson);

        //EncryptJson := CryptographyManagement.GenerateBase64KeyedHash(Base64Json, PublicKey, HashAlgorithmType::SHA256);

        exit(EncryptJson);
    end;


    procedure GenerateKey(): Text[32]
    var
        RandomNumber: Integer;
        RandomString: Text[32];
        i: Integer;
    begin
        Clear(RandomString);

        for i := 1 to 32 do begin
            RandomString := RandomString + Format(Random(9));
        end;

        AppKeyGlobal := RandomString;

        exit(RandomString);
    end;

    var
        AppKeyGlobal: Text[32];
        JsonText: Text;
}