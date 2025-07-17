program ServidorPoupei;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  Controllers.Usuario in 'Controllers\Controllers.Usuario.pas',
  Controllers.Categoria in 'Controllers\Controllers.Categoria.pas',
  Services.Categoria in 'Services\Services.Categoria.pas',
  Dm.Global in 'Repositories\Dm.Global.pas' {DmGlobal: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
