program Poupei;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FrmLogin},
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  UnitLancamento in 'UnitLancamento.pas' {FrmLancamento},
  UnitConfig in 'UnitConfig.pas' {FrmConfig},
  UnitLancamentoCad in 'UnitLancamentoCad.pas' {FrmLancamentoCad},
  UnitCategoria in 'UnitCategoria.pas' {FrmCategoria},
  UnitCategoriaCad in 'UnitCategoriaCad.pas' {FrmCategoriaCad},
  UnitPerfil in 'UnitPerfil.pas' {FrmPerfil},
  UnitSenha in 'UnitSenha.pas' {FrmSenha},
  uLoading in 'Utils\uLoading.pas',
  uSession in 'Utils\uSession.pas',
  Dm.Global in 'DataModules\Dm.Global.pas' {DmGlobal: TDataModule},
  uFunctions in 'Utils\uFunctions.pas',
  UnitAssinatura in 'UnitAssinatura.pas' {FrmAssinatura};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TFrmLancamento, FrmLancamento);
  Application.CreateForm(TFrmConfig, FrmConfig);
  Application.CreateForm(TFrmLancamentoCad, FrmLancamentoCad);
  Application.CreateForm(TFrmCategoria, FrmCategoria);
  Application.CreateForm(TFrmCategoriaCad, FrmCategoriaCad);
  Application.CreateForm(TFrmPerfil, FrmPerfil);
  Application.CreateForm(TFrmSenha, FrmSenha);
  Application.CreateForm(TDmGlobal, DmGlobal);
  Application.CreateForm(TFrmAssinatura, FrmAssinatura);
  Application.Run;
end.
