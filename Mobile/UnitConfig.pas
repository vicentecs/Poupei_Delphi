unit UnitConfig;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts;

type
  TFrmConfig = class(TForm)
    Layout1: TLayout;
    Label7: TLabel;
    imgFechar: TImage;
    rectMenuPerfil: TRectangle;
    Image1: TImage;
    Label1: TLabel;
    Image2: TImage;
    rectMenuSair: TRectangle;
    Image3: TImage;
    Label2: TLabel;
    Image4: TImage;
    rectMenuAssinatura: TRectangle;
    Image5: TImage;
    Label3: TLabel;
    Image6: TImage;
    rectMenuSenha: TRectangle;
    Image7: TImage;
    Label4: TLabel;
    Image8: TImage;
    rectMenuCategoria: TRectangle;
    Image9: TImage;
    Label5: TLabel;
    Image10: TImage;
    procedure imgFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rectMenuCategoriaClick(Sender: TObject);
    procedure rectMenuPerfilClick(Sender: TObject);
    procedure rectMenuSenhaClick(Sender: TObject);
    procedure rectMenuAssinaturaClick(Sender: TObject);
    procedure rectMenuSairClick(Sender: TObject);
  private
    procedure Logout;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmConfig: TFrmConfig;

implementation

{$R *.fmx}

uses UnitCategoria, UnitPerfil, UnitSenha, UnitAssinatura, Dm.Global, UnitLogin,
  UnitPrincipal;

procedure TFrmConfig.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FrmConfig := nil;
end;

procedure TFrmConfig.imgFecharClick(Sender: TObject);
begin
  close;
end;

procedure TFrmConfig.rectMenuAssinaturaClick(Sender: TObject);
begin
  if NOT Assigned(FrmAssinatura) then
    Application.CreateForm(TFrmAssinatura, FrmAssinatura);

  FrmAssinatura.Show;
end;

procedure TFrmConfig.rectMenuCategoriaClick(Sender: TObject);
begin
  if NOT Assigned(FrmCategoria) then
    Application.CreateForm(TFrmCategoria, FrmCategoria);

  FrmCategoria.Show;
end;

procedure TFrmConfig.rectMenuPerfilClick(Sender: TObject);
begin
  if NOT Assigned(FrmPerfil) then
    Application.CreateForm(TFrmPerfil, FrmPerfil);

  FrmPerfil.Show;
end;

procedure TFrmConfig.Logout;
begin
  try
    DmGlobal.ExcluirUsuarioLocal;

    if NOT Assigned(FrmLogin) then
      Application.CreateForm(TFrmLogin, FrmLogin);

    Application.MainForm := FrmLogin;
    FrmLogin.Show;

    FrmPrincipal.Close;
    FrmConfig.Close;

  except on ex:exception do
    showmessage(ex.Message);
  end;
end;

procedure TFrmConfig.rectMenuSairClick(Sender: TObject);
begin
  Logout;
end;

procedure TFrmConfig.rectMenuSenhaClick(Sender: TObject);
begin
  if NOT Assigned(FrmSenha) then
    Application.CreateForm(TFrmSenha, FrmSenha);

  FrmSenha.Show;
end;

end.
