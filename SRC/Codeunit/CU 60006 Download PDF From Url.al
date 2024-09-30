codeunit 60006 "Download PDF From Url"
{
    var
        ResponseInStream: InStream;

    procedure DownloadPdf(URL: Text; FileName: Text) ReturnInStream: InStream
    var
        HttpClient: HttpClient;
        ResponseHeader: HttpHeaders;
        ResponseMessage: HttpResponseMessage;
        ResponseHeaders: array[9] of Text;
        ResponseText: Text;
        OutStr: OutStream;
        TempBlob: Codeunit "Temp Blob";
    begin
        Clear(HttpClient);

        HttpClient.Get(URL, ResponseMessage);
        ResponseMessage.Content.GetHeaders(ResponseHeader);
        ResponseHeader.GetValues('Content-Type', ResponseHeaders);
        case ResponseHeaders[1] of
            'application/pdf', 'application/octet-stream':
                begin
                    //Store response stream directly
                    ResponseMessage.Content.ReadAs(ResponseInStream);
                    DownloadFromStream(ResponseInStream, 'Download', '', '', FileName);
                    exit(ResponseInStream);
                end;
            else begin
                ResponseMessage.Content.ReadAs(ResponseText);
                TempBlob.CreateOutStream(OutStr);
                TempBlob.CreateInStream(ResponseInStream);
                OutStr.WriteText(ResponseText)
            end;
        end;
        //Otherwise return response as text
        exit(ResponseInStream);
    end;
}