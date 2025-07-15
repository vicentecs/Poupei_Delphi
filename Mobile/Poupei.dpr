program Poupei;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FrmLogin},
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  UnitLancamento in 'UnitLancamento.pas' {FrmLancamento},
  UnitConfig in 'UnitConfig.pas' {FrmConfig};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.CreateForm(TFrmLancamento, FrmLancamento);
  Application.CreateForm(TFrmConfig, FrmConfig);
  Application.Run;
end.
