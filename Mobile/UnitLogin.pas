unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit,
  uLoading, uSession, uFunctions;

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
    Fsenha: string;
    procedure OpenMainForm;
    procedure TerminateLogin(Sender: TObject);
    procedure OpenFormAssinatura;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

uses UnitPrincipal, Dm.Global, UnitAssinatura;

procedure TFrmLogin.btnAcessarLoginClick(Sender: TObject);
begin
  TabControl.GotoVisibleTab(1);
end;

procedure TFrmLogin.OpenMainForm;
begin
  if NOT Assigned(FrmPrincipal) then
    Application.CreateForm(TFrmPrincipal, FrmPrincipal);

  Application.MainForm := FrmPrincipal;
  FrmPrincipal.Show;
  FrmLogin.Close;
end;

procedure TFrmLogin.OpenFormAssinatura;
begin
  if NOT Assigned(FrmAssinatura) then
    Application.CreateForm(TFrmAssinatura, FrmAssinatura);

  FrmAssinatura.Show;
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
  with DmGlobal.TabUsuario do
  begin
    DmGlobal.InserirUsuarioLocal(FieldByName('id_usuario').AsInteger,
                  FieldByName('nome').AsString,
                  FieldByName('email').AsString,
                  Fsenha,
                  FieldByName('token').AsString,
                  FieldByName('status').AsString,
                  FieldByName('stripe_cliente_id').AsString,
                  FieldByName('stripe_assinatura_id').AsString);

    TSession.id_usuario := FieldByName('id_usuario').AsInteger;
    TSession.nome := FieldByName('nome').AsString;
    TSession.email := FieldByName('email').AsString;
    TSession.token := FieldByName('token').AsString;
    TSession.status := FieldByName('status').AsString;
    TSession.stripe_cliente_id := FieldByName('stripe_cliente_id').AsString;
    TSession.stripe_assinatura_id := FieldByName('stripe_assinatura_id').AsString;

    if ShortStringUTCToDate(FieldByName('dt_termino_acesso').AsString) >=
       ShortStringUTCToDate(FieldByName('dt_referencia').AsString) then
      OpenMainForm
    else
      OpenFormAssinatura;
  end;

end;

procedure TFrmLogin.btnCriarContaClick(Sender: TObject);
begin
  if EdtContaSenha.Text <> EdtContaSenha2.Text then
  begin
    showmessage('As senhas~não conferem. Digite novamente');
    exit;
  end;

  Fsenha := edtContaSenha.Text;
  TLoading.Show(FrmLogin);

  TLoading.ExecuteThread(procedure
  begin

    DmGlobal.CriarConta(edtContaNome.Text, edtContaEmail.Text, edtSenha.Text);
  end,
  TerminateLogin);
end;

procedure TFrmLogin.btnLoginClick(Sender: TObject);
begin
  Fsenha := edtSenha.Text;
  TLoading.Show(FrmLogin);

  TLoading.ExecuteThread(procedure
  begin
    DmGlobal.Login(edtEmail.Text, edtSenha.Text);

    DmGlobal.ExcluirUsuarioLocal;
  end,
  TerminateLogin);
end;

procedure TFrmLogin.FormShow(Sender: TObject);
var
  email, senha: string;
begin
  TabControl.ActiveTab := TabBoasVindas;

  // Descobrir se ele ja esta logado...
  try
    DmGlobal.ListarUsuarioLocal;

    email := DmGlobal.qryUsuario.FieldByName('email').AsString;
    senha := DmGlobal.qryUsuario.FieldByName('senha').AsString;

    if (email <> '') and (senha <> '') then
    begin
      TabControl.ActiveTab := TabLogin;
      edtEmail.Text := email;
      edtSenha.Text := senha;
      btnLoginClick(Sender);
    end;

  except on ex:exception do
    showmessage(ex.Message);
  end;
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
