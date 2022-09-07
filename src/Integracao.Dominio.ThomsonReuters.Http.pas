unit Integracao.Dominio.ThomsonReuters.Http;

interface

uses
  Classes, SysUtils,
  System.Net.URLClient,
  System.Net.HttpClient,
  System.Net.HttpClientComponent,
  System.Net.Mime,
  System.JSON,
  REST.JSON,
  REST.Types,
  Integracao.Dominio.ThomsonReuters.Consts;

type
  IIntegracaoDominio = interface
    ['{07D8287A-477A-4DC0-BA85-AD8F3BFEFBFD}']
    function GerarToken: TJSONObject;
    function ConfirmarCliente(const AIntegrationKey: string; const AToken: string): TJSONObject;
    function GerarKeyIntegracao(const AIntegrationKey: string; const AToken: string): TJSONObject;
    function EnviarXML(const AFileName: TFileName; const AIntegrationKey: string; const AToken: string; const ABOXAtivo: Boolean = False): TJSONObject;
    function ConsultarEnvioXML(const AIdenvio: string; const AIntegrationKey: string; const AToken: string): TJSONObject;
  end;

  TIntegracaoDominio = class(TInterfacedObject, IIntegracaoDominio)
  private
    FClientId: string;
    FSecretKey: string;

    procedure _ErrorResult(AResponse: IHTTPResponse);
    procedure _SetupAuthentication(const AClient: TNetHTTPClient; const AUser, APassword: string);

  private
    // IIntegracaoDominio implementation
    function GerarToken: TJSONObject;
    function ConfirmarCliente(const AIntegrationKey: string; const AToken: string): TJSONObject;
    function GerarKeyIntegracao(const AIntegrationKey: string; const AToken: string): TJSONObject;
    function EnviarXML(const AFileName: TFileName; const AIntegrationKey: string; const AToken: string; const ABOXAtivo: Boolean = False): TJSONObject;
    function ConsultarEnvioXML(const AIdenvio: string; const AIntegrationKey: string; const AToken: string): TJSONObject;

  public
    constructor Create(const AClientId, ASecretKey: string); overload;
    destructor Destroy; override;
    class function New(const AClientId, ASecretKey: string): IIntegracaoDominio;
  end;

implementation

{ THttpAuthetication }

function TIntegracaoDominio.ConfirmarCliente(const AIntegrationKey: string; const AToken: string): TJSONObject;
var
  LResponse: IHTTPResponse;
  LHttpClient: TNetHTTPClient;
begin
  Result := nil;
  LHttpClient := TNetHTTPClient.Create(nil);
  try
    LHttpClient.HandleRedirects := True;
    LHttpClient.AcceptEncoding := 'gzip';
    LHttpClient.CustomHeaders['Authorization'] := 'Bearer ' + AToken;
    LHttpClient.CustomHeaders['x-integration-key'] := AIntegrationKey;
    try
      LResponse := LHttpClient.Get(UrlConfirmarCliente);
    except
      on E: Exception do
      begin
        if not Assigned(LResponse) then
          raise;
        _ErrorResult(LResponse);
      end;
    end;

    if (LResponse.StatusCode > 0) and (LResponse.StatusCode <> 200) then
      _ErrorResult(LResponse);

    if LResponse.StatusCode = 200 then
    begin
      LResponse.ContentStream.Position := 0;
      Result := TJSONObject.ParseJSONValue(LResponse.ContentAsString) as TJSONObject;
    end;

  finally
    LHttpClient.Free;
  end;
end;


function TIntegracaoDominio.ConsultarEnvioXML(const AIdenvio, AIntegrationKey, AToken: string): TJSONObject;
var
  LResponse: IHTTPResponse;
  LHttpClient: TNetHTTPClient;
begin
  Result := nil;
  LHttpClient := TNetHTTPClient.Create(nil);
  try
    LHttpClient.HandleRedirects := True;
    LHttpClient.AcceptEncoding := 'gzip';
    LHttpClient.CustomHeaders['Authorization'] := 'Bearer ' + AToken;
    LHttpClient.CustomHeaders['x-integration-key'] := AIntegrationKey;
    try
      LResponse := LHttpClient.Get(UrlConsultarEnviaoXML+AIdenvio);
    except
      on E: Exception do
      begin
        if not Assigned(LResponse) then
          raise;
        _ErrorResult(LResponse);
      end;
    end;

    if (LResponse.StatusCode > 0) and (LResponse.StatusCode <> 200) then
      _ErrorResult(LResponse);

    if LResponse.StatusCode = 200 then
    begin
      LResponse.ContentStream.Position := 0;
      Result := TJSONObject.ParseJSONValue(LResponse.ContentAsString) as TJSONObject;
    end;

  finally
    LHttpClient.Free;
  end;
end;

constructor TIntegracaoDominio.Create(const AClientId, ASecretKey: string);
begin
  FClientId := AClientId;
  FSecretKey := ASecretKey;
end;

destructor TIntegracaoDominio.Destroy;
begin

  inherited;
end;


function TIntegracaoDominio.EnviarXML(const AFileName: TFileName; const AIntegrationKey: string; const AToken: string; const ABOXAtivo: Boolean = False): TJSONObject;
var
  LResponse: IHTTPResponse;
  LHttpClient: TNetHTTPClient;
  LFormData: TMultipartFormData;
  LFileStream: TStringStream;
  LFileNameParamQuery: TFileName;
begin
  Result := nil;
  LHttpClient := TNetHTTPClient.Create(nil);
  LFormData := TMultipartFormData.Create;
  LFileStream := TStringStream.Create(Format('{"boxe/File": %s}', [LowerCase(BoolToStr(ABOXAtivo, True))]));
  try
    LFileNameParamQuery := ExtractFilePath(ParamStr(0))+ 'ABOXAtivo.json';
    LFileStream.SaveToFile(LFileNameParamQuery);
    LFormData.AddFile('file[]', AFileName);
    LFormData.AddFile('query', LFileNameParamQuery);

    LHttpClient.HandleRedirects := True;
    LHttpClient.CustomHeaders['Authorization'] := 'Bearer ' + AToken;
    LHttpClient.CustomHeaders['x-integration-key'] := AIntegrationKey;
    LHttpClient.Accept := '*/*';
    LHttpClient.AcceptEncoding := 'gzip';
    LHttpClient.CustomHeaders['Content-Length'] := IntToStr(LFormData.Stream.Size);

    try
      LResponse := LHttpClient.Post(UrlEnviarXML, LFormData);
    except
      on E: Exception do
      begin
        if not Assigned(LResponse) then
          raise;
        _ErrorResult(LResponse);
      end;
    end;

    if (LResponse.StatusCode > 0) and (LResponse.StatusCode <> 201) then
      _ErrorResult(LResponse);

    if LResponse.StatusCode = 201 then
    begin
      LResponse.ContentStream.Position := 0;
      Result := TJSONObject.ParseJSONValue(LResponse.ContentAsString) as TJSONObject;
    end;

  finally
    LHttpClient.Free;
    LFormData.Free;
    LFileStream.Free;
    DeleteFile(LFileNameParamQuery);
  end;
end;

function TIntegracaoDominio.GerarKeyIntegracao(const AIntegrationKey, AToken: string): TJSONObject;
var
  LResponse: IHTTPResponse;
  LHttpClient: TNetHTTPClient;
  LBody: TMemoryStream;
begin
  Result := nil;
  LHttpClient := TNetHTTPClient.Create(nil);
  LBody := TMemoryStream.Create;
  try
    LHttpClient.HandleRedirects := True;
    LHttpClient.AcceptEncoding := 'gzip';
    LHttpClient.CustomHeaders['Authorization'] := 'Bearer ' + AToken;
    LHttpClient.CustomHeaders['x-integration-key'] := AIntegrationKey;
    try
      LResponse := LHttpClient.Post(UrlGerarKeyIntegracao, LBody);
    except
      on E: Exception do
      begin
        if not Assigned(LResponse) then
          raise;
        _ErrorResult(LResponse);
      end;
    end;

    if (LResponse.StatusCode > 0) and (LResponse.StatusCode <> 200) then
      _ErrorResult(LResponse);

    if LResponse.StatusCode = 200 then
    begin
      LResponse.ContentStream.Position := 0;
      Result := TJSONObject.ParseJSONValue(LResponse.ContentAsString) as TJSONObject;
    end;

  finally
    LHttpClient.Free;
    LBody.Free;
  end;
end;

procedure TIntegracaoDominio._ErrorResult(AResponse: IHTTPResponse);
var
  LError: TStringStream;
begin
  LError := TStringStream.Create;
  try
    AResponse.ContentStream.Position := 0;
    LError.CopyFrom(AResponse.ContentStream, AResponse.ContentStream.Size);
    raise Exception.CreateFmt('Falha ao processar a requisição: %d - %s - %s', [AResponse.StatusCode, AResponse.StatusText, LError.DataString]);
  finally
    LError.Free;
  end;
end;

function TIntegracaoDominio.GerarToken: TJSONObject;
var
  LBody: TStringList;
  LResponse: IHTTPResponse;
  LHttpClient: TNetHTTPClient;
begin
  Result := nil;
  LBody := TStringList.Create;
  LHttpClient := TNetHTTPClient.Create(nil);
  try
    LBody.Add('grant_type=client_credentials');
    LBody.Add('client_id=' + FClientId);
    LBody.Add('client_secret=' + FSecretKey);
    LBody.Add('audience=' + Integracao.Dominio.ThomsonReuters.Consts.Audience);

    _SetupAuthentication(LHttpClient, FClientId, FSecretKey);

    LHttpClient.HandleRedirects := True;
    LHttpClient.AcceptEncoding := 'gzip';
    try
      LResponse := LHttpClient.Post(UrlAutenticar, LBody);
    except
      on E: Exception do
      begin
        if not Assigned(LResponse) then
          raise;
        _ErrorResult(LResponse);
      end;
    end;

    if (LResponse.StatusCode > 0) and (LResponse.StatusCode <> 200) then
      _ErrorResult(LResponse);

    if LResponse.StatusCode = 200 then
    begin
      LResponse.ContentStream.Position := 0;
      Result := TJSONObject.ParseJSONValue(LResponse.ContentAsString) as TJSONObject;
    end;

  finally
    LHttpClient.Free;
    LBody.Free;

  end;

end;

class function TIntegracaoDominio.New(const AClientId, ASecretKey: string): IIntegracaoDominio;
begin
  Result := Self.Create(AClientId, ASecretKey);
end;

procedure TIntegracaoDominio._SetupAuthentication(const AClient: TNetHTTPClient; const AUser, APassword: string);
var
  LCookie1: TCookie;
  LCookie2: TCookie;
begin
  AClient.ContentType := REST.Types.CONTENTTYPE_APPLICATION_X_WWW_FORM_URLENCODED;
  AClient.CredentialsStorage.ClearCredentials;
  AClient.CredentialsStorage.AddCredential(TCredentialsStorage.TCredential.Create(TAuthTargetType.Server, '', '', AUser, APassword));
  LCookie1.Name := 'did';
  LCookie1.Value := 's%3Av0%3A145b8a90-ea57-11eb-ae8a-877f15a4a518.QhUcTCGsMP28yWAB%2BYsUUZ5Gw4Srxf%2F0IDRkKPUQQHs';
  AClient.CookieManager.AddServerCookie(LCookie1, TURI.Create(Integracao.Dominio.ThomsonReuters.Consts.UrlAutenticar));
  LCookie2.Name := 'did_compat';
  LCookie2.Value := 's%3Av0%3A145b8a90-ea57-11eb-ae8a-877f15a4a518.QhUcTCGsMP28yWAB%2BYsUUZ5Gw4Srxf%2F0IDRkKPUQQHs';
  AClient.CookieManager.AddServerCookie(LCookie2, TURI.Create(Integracao.Dominio.ThomsonReuters.Consts.UrlAutenticar));
end;

end.
