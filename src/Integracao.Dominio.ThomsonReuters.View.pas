unit Integracao.Dominio.ThomsonReuters.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.JSON,
  Vcl.ComCtrls, System.IniFiles;

type
  TFormMain = class(TForm)
    Panel1: TPanel;
    botaoAutenticar: TButton;
    ClientId: TLabeledEdit;
    SecretKey: TLabeledEdit;
    botaoConfirmarIntegrationKey: TButton;
    PageControlData: TPageControl;
    TabSheetToken: TTabSheet;
    MemoToken: TMemo;
    TabSheetConfirmacaoCliente: TTabSheet;
    MemoConfirmacaoCliente: TMemo;
    TabSheetHome: TTabSheet;
    panelHome: TPanel;
    LabelUrlDoc: TLabel;
    IntegrationKey: TLabeledEdit;
    TabSheetKeyIntegracao: TTabSheet;
    MemoKeyIntegracao: TMemo;
    botaoGerarKeyIntegracao: TButton;
    CheckBoxSalvarCredenciais: TCheckBox;
    TabSheetEnvioXML: TTabSheet;
    GridPanel: TGridPanel;
    Panel2: TPanel;
    MemoArquivoXML: TMemo;
    LabelArquivoXML: TLabel;
    Panel3: TPanel;
    Label1: TLabel;
    MemoRespostaProcessamento: TMemo;
    botaoEnviarArquivo: TButton;
    OpenDialog1: TOpenDialog;
    botaoConsultarEnvioXML: TButton;
    TabSheetConsultarEnvioXML: TTabSheet;
    MemoConsultarEnvioXML: TMemo;
    procedure botaoAutenticarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ClientIdChange(Sender: TObject);
    procedure SecretKeyChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LabelUrlDocMouseEnter(Sender: TObject);
    procedure LabelUrlDocMouseLeave(Sender: TObject);
    procedure botaoConfirmarIntegrationKeyClick(Sender: TObject);
    procedure botaoGerarKeyIntegracaoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure botaoEnviarArquivoClick(Sender: TObject);
    procedure botaoConsultarEnvioXMLClick(Sender: TObject);
  private
    FJsonToken: TJSONValue;
    FJsonConfirmacaoCliente: TJSONObject;
    FJsonKeyIntegracao: TJSONObject;
    FJsonResponseFile: TJSONObject;
    FJsonConsultarEnvioXML: TJSONObject;
    procedure _PodeAutenticar;
    procedure _PodeConfirmarIntegrationKey;
    procedure _SalvarCredenciais;
    procedure _CarregarCredenciais;
    function _StringToStream(const AStr: string; AStream: TStringStream): TStream;
    function _StreamToString(AStream: TStringStream): string;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}


uses
  REST.JSON, Integracao.Dominio.ThomsonReuters.Http;

const
  SectionCredenciais = 'CREDENCIAIS';
  _StoreFileName = 'store.dat';

function StoreFileName: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + _StoreFileName;
end;

procedure TFormMain.botaoAutenticarClick(Sender: TObject);
var
  LIntegracao: IIntegracaoDominio;
begin
  try
    Screen.Cursor := crHourGlass;
    MemoToken.Clear;
    if Assigned(FJsonToken) then
      FJsonToken.Free;

    LIntegracao := TIntegracaoDominio.New(Trim(ClientId.Text), Trim(SecretKey.Text));
    FJsonToken := LIntegracao.GerarToken;

    if Assigned(FJsonToken) then
    begin
      MemoToken.Text := TJson.Format(FJsonToken);
      _PodeConfirmarIntegrationKey;
      TabSheetToken.TabVisible := True;
      PageControlData.ActivePage := TabSheetToken;
      if CheckBoxSalvarCredenciais.Checked then
      begin
        _SalvarCredenciais;
      end;

    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFormMain.botaoConfirmarIntegrationKeyClick(Sender: TObject);
var
  LIntegracao: IIntegracaoDominio;
begin
  try
    Screen.Cursor := crHourGlass;
    MemoConfirmacaoCliente.Clear;
    if Assigned(FJsonConfirmacaoCliente) then
      FJsonConfirmacaoCliente.Free;

    LIntegracao := TIntegracaoDominio.New(Trim(ClientId.Text), Trim(SecretKey.Text));
    FJsonConfirmacaoCliente := LIntegracao.ConfirmarCliente(Trim(IntegrationKey.Text), FJsonToken.GetValue<string>('access_token'));

    if Assigned(FJsonConfirmacaoCliente) then
    begin
      MemoConfirmacaoCliente.Text := TJson.Format(FJsonConfirmacaoCliente);
      TabSheetConfirmacaoCliente.TabVisible := True;
      PageControlData.ActivePage := TabSheetConfirmacaoCliente;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFormMain.botaoConsultarEnvioXMLClick(Sender: TObject);
var
  LArquivo: TFileName;
  LIntegracao: IIntegracaoDominio;
begin
  try
    Screen.Cursor := crHourGlass;
    if Assigned(FJsonConsultarEnvioXML) then
      FJsonConsultarEnvioXML.Free;

    LIntegracao := TIntegracaoDominio.New(Trim(ClientId.Text), Trim(SecretKey.Text));
    FJsonConsultarEnvioXML := LIntegracao.ConsultarEnvioXML(FJsonResponseFile.GetValue<string>('id'), FJsonKeyIntegracao.GetValue<string>('integrationKey'), FJsonToken.GetValue<string>('access_token'));

    if Assigned(FJsonConsultarEnvioXML) then
    begin
      MemoConsultarEnvioXML.Text := TJson.Format(FJsonConsultarEnvioXML);
      TabSheetConsultarEnvioXML.TabVisible := True;
      PageControlData.ActivePage := TabSheetConsultarEnvioXML;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFormMain.botaoEnviarArquivoClick(Sender: TObject);
var
  LArquivo: TFileName;
  LIntegracao: IIntegracaoDominio;
begin
  if OpenDialog1.Execute(Self.Handle) then
  begin
    LArquivo := OpenDialog1.FileName;
  end;
  if FileExists(LArquivo) then
  begin
    try
      Screen.Cursor := crHourGlass;
      MemoArquivoXML.Lines.LoadFromFile(LArquivo);
      if Assigned(FJsonResponseFile) then
        FJsonResponseFile.Free;

      LIntegracao := TIntegracaoDominio.New(Trim(ClientId.Text), Trim(SecretKey.Text));
      FJsonResponseFile := LIntegracao.EnviarXML(LArquivo, FJsonKeyIntegracao.GetValue<string>('integrationKey'), FJsonToken.GetValue<string>('access_token'));

      if Assigned(FJsonResponseFile) then
      begin
        MemoRespostaProcessamento.Text := TJson.Format(FJsonResponseFile);
        TabSheetEnvioXML.TabVisible := True;
        PageControlData.ActivePage := TabSheetEnvioXML;
        botaoConsultarEnvioXML.Enabled := True;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TFormMain.botaoGerarKeyIntegracaoClick(Sender: TObject);
var
  LIntegracao: IIntegracaoDominio;
begin
  try
    Screen.Cursor := crHourGlass;
    MemoKeyIntegracao.Clear;
    if Assigned(FJsonKeyIntegracao) then
      FJsonKeyIntegracao.Free;

    LIntegracao := TIntegracaoDominio.New(Trim(ClientId.Text), Trim(SecretKey.Text));
    FJsonKeyIntegracao := LIntegracao.GerarKeyIntegracao(Trim(IntegrationKey.Text), FJsonToken.GetValue<string>('access_token'));

    if Assigned(FJsonKeyIntegracao) then
    begin
      MemoKeyIntegracao.Text := TJson.Format(FJsonKeyIntegracao);
      TabSheetKeyIntegracao.TabVisible := True;
      PageControlData.ActivePage := TabSheetKeyIntegracao;
      botaoEnviarArquivo.Enabled := True;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFormMain.ClientIdChange(Sender: TObject);
begin
  _PodeAutenticar;
end;

procedure TFormMain.SecretKeyChange(Sender: TObject);
begin
  _PodeAutenticar;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;
  PageControlData.ActivePage := TabSheetHome;
  TabSheetToken.TabVisible := False;
  TabSheetConfirmacaoCliente.TabVisible := False;
  TabSheetKeyIntegracao.TabVisible := False;
  TabSheetEnvioXML.TabVisible := False;
  TabSheetConsultarEnvioXML.TabVisible := False;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  if Assigned(FJsonToken) then
    FJsonToken.Free;
  if Assigned(FJsonConfirmacaoCliente) then
    FJsonConfirmacaoCliente.Free;
  if Assigned(FJsonKeyIntegracao) then
    FJsonKeyIntegracao.Free;
  if Assigned(FJsonResponseFile) then
    FJsonResponseFile.Free;
  if Assigned(FJsonConsultarEnvioXML) then
    FJsonConsultarEnvioXML.Free;
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
  _CarregarCredenciais;
end;

procedure TFormMain.LabelUrlDocMouseEnter(Sender: TObject);
begin
  LabelUrlDoc.Font.Color := clWhite;
end;

procedure TFormMain.LabelUrlDocMouseLeave(Sender: TObject);
begin
  LabelUrlDoc.Font.Color := clBlack;
end;

procedure TFormMain._CarregarCredenciais;
var
  LStream: TStringStream;
  LIni: TIniFile;
begin
  LStream := TStringStream.Create;
  LIni := TIniFile.Create(StoreFileName);
  try
    LStream.Clear;
    if LIni.ReadBinaryStream(SectionCredenciais, ClientId.Name, LStream) > 0 then
      ClientId.Text := _StreamToString(LStream);

    LStream.Clear;
    if LIni.ReadBinaryStream(SectionCredenciais, SecretKey.Name, LStream) > 0 then
      SecretKey.Text := _StreamToString(LStream);

    LStream.Clear;
    if LIni.ReadBinaryStream(SectionCredenciais, IntegrationKey.Name, LStream) > 0 then
      IntegrationKey.Text := _StreamToString(LStream);

    CheckBoxSalvarCredenciais.Checked := Trim(ClientId.Text) <> EmptyStr;
  finally
    LStream.Free;
    LIni.Free;
  end;
end;

procedure TFormMain._PodeAutenticar;
var
  LHabilitar: Boolean;
begin
  LHabilitar := (not Trim(ClientId.Text).IsEmpty) and (not Trim(SecretKey.Text).IsEmpty);
  botaoAutenticar.Enabled := LHabilitar;
  CheckBoxSalvarCredenciais.Enabled := LHabilitar;
end;

procedure TFormMain._PodeConfirmarIntegrationKey;
var
  LHabilitar: Boolean;
begin
  LHabilitar := Assigned(FJsonToken);
  botaoConfirmarIntegrationKey.Enabled := LHabilitar;
  botaoGerarKeyIntegracao.Enabled := LHabilitar;
end;

function TFormMain._StreamToString(AStream: TStringStream): string;
begin
  AStream.Position := 0;
  Result := AStream.ReadString(AStream.Size);
end;

function TFormMain._StringToStream(const AStr: string; AStream: TStringStream): TStream;
begin
  AStream.Clear;
  AStream.WriteString(AStr);
  AStream.Position := 0;
  Result := AStream;
end;

procedure TFormMain._SalvarCredenciais;
var
  LStream: TStringStream;
  LIni: TIniFile;
begin
  LStream := TStringStream.Create;
  LIni := TIniFile.Create(StoreFileName);
  try
    LIni.WriteBinaryStream(SectionCredenciais, ClientId.Name, _StringToStream(ClientId.Text, LStream));
    LIni.WriteBinaryStream(SectionCredenciais, SecretKey.Name, _StringToStream(SecretKey.Text, LStream));
    LIni.WriteBinaryStream(SectionCredenciais, IntegrationKey.Name, _StringToStream(IntegrationKey.Text, LStream));
  finally
    LStream.Free;
    LIni.Free;
  end;

end;

end.
