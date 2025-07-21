unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit,
  uLoading, uSession;

type
  TFrmLogin = class(TForm)
    TabControl: TTabControl;
    TabBoasVindas: TTabItem;
    TabLogin: TTabItem;
    TabNovaConta: TTabItem;
    Layout1: TLayout;
    Image1: TImage;
    Label1: TLabel;
    rectAcessarLogin: TRectangle;
    btnAcessarLogin: TSpeedButton;
    Rectangle1: TRectangle;
    SpeedButton1: TSpeedButton;
    Layout2: TLayout;
    Image2: TImage;
    Label2: TLabel;
    Rectangle2: TRectangle;
    btnLogin: TSpeedButton;
    edtEmail: TEdit;
    edtSenha: TEdit;
    lblNovaConta: TLabel;
    Layout3: TLayout;
    Image3: TImage;
    Label4: TLabel;
    Rectangle3: TRectangle;
    btnCriarConta: TSpeedButton;
    edtContaNome: TEdit;
    EdtContaSenha: TEdit;
    Label5: TLabel;
    EdtContaEmail: TEdit;
    EdtContaSenha2: TEdit;
    procedure btnAcessarLoginClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure lblNovaContaClick(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure btnCriarContaClick(Sender: TObject);
  private
    procedure OpenMainForm;
    procedure TerminateLogin(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

uses UnitPrincipal, Dm.Global;

procedure TFrmLogin.btnAcessarLoginClick(Sender: TObject);
begin
  TabControl.GotoVisibleTab(1);
end;

procedure TFrmLogin.OpenMainForm;
begin
  if NOT Assigned(FrmPrincipal) then
    Application.CreateForm(TFrmPrincipal, FrmPrincipal);

  FrmPrincipal.Show;
end;

procedure TFrmLogin.TerminateLogin(Sender: TObject);
begin
  TLoading.Hide;

  // Se deu erro na thread
  if Assigned(TThread(Sender).FatalException) then
  begin
    showmessage(Exception(TThread(sender).FatalException).Message);
    exit;
  end;

  // Login valido...
  TSession.id_usuario := DmGlobal.TabUsuario.FieldByName('id_usuario').AsInteger;
  TSession.nome := DmGlobal.TabUsuario.FieldByName('nome').AsString;
  TSession.email := DmGlobal.TabUsuario.FieldByName('email').AsString;
  TSession.token := DmGlobal.TabUsuario.FieldByName('token').AsString;
  TSession.status := '??????';

  OpenMainForm;
end;

procedure TFrmLogin.btnCriarContaClick(Sender: TObject);
begin
  if EdtContaSenha.Text <> EdtContaSenha2.Text then
  begin
    showmessage('As senhas~não conferem. Digite novamente');
    exit;
  end;

  TLoading.Show(FrmLogin);

  TLoading.ExecuteThread(procedure
  begin

    DmGlobal.CriarConta(edtContaNome.Text, edtContaEmail.Text, edtSenha.Text);
  end,
  TerminateLogin);
end;

procedure TFrmLogin.btnLoginClick(Sender: TObject);
begin
  TLoading.Show(FrmLogin);

  TLoading.ExecuteThread(procedure
  begin

    DmGlobal.Login(edtEmail.Text, edtSenha.Text);
  end,
  TerminateLogin);
end;

procedure TFrmLogin.FormShow(Sender: TObject);
begin
  TabControl.ActiveTab := TabBoasVindas;
end;

procedure TFrmLogin.Label5Click(Sender: TObject);
begin
  TabControl.GotoVisibleTab(1);
end;

procedure TFrmLogin.lblNovaContaClick(Sender: TObject);
begin
  TabControl.GotoVisibleTab(2);
end;

procedure TFrmLogin.SpeedButton1Click(Sender: TObject);
begin
  TabControl.GotoVisibleTab(2);
end;

end.
