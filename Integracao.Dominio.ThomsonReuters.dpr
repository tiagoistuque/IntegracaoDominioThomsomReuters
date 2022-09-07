program Integracao.Dominio.ThomsonReuters;

uses
  Vcl.Forms,
  Integracao.Dominio.ThomsonReuters.View in 'src\Integracao.Dominio.ThomsonReuters.View.pas' {FormMain},
  Integracao.Dominio.ThomsonReuters.Consts in 'src\Integracao.Dominio.ThomsonReuters.Consts.pas',
  Integracao.Dominio.ThomsonReuters.Http in 'src\Integracao.Dominio.ThomsonReuters.Http.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
