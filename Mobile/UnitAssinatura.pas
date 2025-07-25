unit UnitAssinatura;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.TabControl, FMX.Edit,
  uLoading, uFunctions, FMX.WebBrowser, uSession;

type
  TFrmAssinatura = class(TForm)
    Layout1: TLayout;
    Label7: TLabel;
    imgFechar: TImage;
    TabControl: TTabControl;
    TabAssinar: TTabItem;
    TabCancelar: TTabItem;
    TabCancelado: TTabItem;
    Layout2: TLayout;
    Image2: TImage;
    Label2: TLabel;
    Rectangle2: TRectangle;
    btnAssinar: TSpeedButton;
    Layout3: TLayout;
    Image1: TImage;
    lblAssinaturaValor: TLabel;
    Rectangle1: TRectangle;
    btnCancelar: TSpeedButton;
    lblAssinaturaProxCobr: TLabel;
    Layout4: TLayout;
    Image3: TImage;
    lblCanceladoValor: TLabel;
    Rectangle3: TRectangle;
    lblCanceladoData: TLabel;
    Label1: TLabel;
    TabNavegador: TTabItem;
    TabSucesso: TTabItem;
    WebBrowser: TWebBrowser;
    Layout5: TLayout;
    Image4: TImage;
    lblMsg: TLabel;
    Rectangle4: TRectangle;
    btnSucesso: TSpeedButton;
    procedure imgFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnAssinarClick(Sender: TObject);
    procedure WebBrowserDidStartLoad(ASender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSucessoClick(Sender: TObject);
  private
    url_checkout: string;
    procedure CarregarDadosPerfil;
    procedure TerminateDadosPerfil(Sender: TObject);
    procedure TerminateURL(Sender: TObject);
    procedure TerminateCancelamento(Sender: TObject);
    procedure Mensagem(msg: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmAssinatura: TFrmAssinatura;

implementation

{$R *.fmx}

uses Dm.Global, UnitPrincipal;

procedure TFrmAssinatura.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FrmAssinatura := nil;
end;

procedure TFrmAssinatura.TerminateDadosPerfil(Sender: TObject);
begin
  TLoading.Hide;

  // Se deu erro na thread
  if Assigned(TThread(Sender).FatalException) then
  begin
    showmessage(Exception(TThread(sender).FatalException).Message);
    exit;
  end;


  with DmGlobal.TabUsuario do
  begin
    TSession.id_usuario := FieldByName('id_usuario').AsInteger;
    TSession.nome := FieldByName('nome').AsString;
    TSession.email := FieldByName('email').AsString;
    TSession.status := FieldByName('status').AsString;
    TSession.stripe_cliente_id := FieldByName('stripe_cliente_id').AsString;
    TSession.stripe_assinatura_id := FieldByName('stripe_assinatura_id').AsString;

    btnAssinar.Text := 'QUERO ASSINAR (' +
                  FormatFloat('R$#,##0.00', FieldByName('vl_assinatura').AsFloat) + ')';
    lblAssinaturaValor.Text := 'Valor Assinatura: ' +
                  FormatFloat('R$#,##0.00', FieldByName('vl_assinatura').AsFloat);
    lblAssinaturaProxCobr.Text := 'Próx. Cobrança: ' +
                  UTCtoShortDateBR(FieldByName('dt_termino_acesso').AsString);
    lblCanceladoValor.Text := 'Valor Assinatura: ' +
                  FormatFloat('R$#,##0.00', FieldByName('vl_assinatura').AsFloat);
    lblCanceladoData.Text := 'Acesso até: ' +
                  UTCtoShortDateBR(FieldByName('dt_termino_acesso').AsString);

    // Decide qual aba abrir...
    if (ShortStringUTCToDate(FieldByName('dt_termino_acesso').AsString) <
        ShortStringUTCToDate(FieldByName('dt_referencia').AsString)) or
         (FieldByName('status').AsString = 'TESTE') then
        TabControl.ActiveTab := TabAssinar
      else if FieldByName('status').AsString <> 'INATIVO' then
        TabControl.ActiveTab := TabCancelar
      else
        TabControl.ActiveTab := TabCancelado;
    end;
end;

procedure TFrmAssinatura.TerminateURL(Sender: TObject);
begin
  // Se deu erro na thread
  if Assigned(TThread(Sender).FatalException) then
  begin
    TLoading.Hide;
    showmessage(Exception(TThread(sender).FatalException).Message);
    exit;
  end;

  WebBrowser.Navigate(url_checkout);
  TabControl.GotoVisibleTab(3);
  TLoading.Hide;
end;


procedure TFrmAssinatura.TerminateCancelamento(Sender: TObject);
begin
  TLoading.Hide;

  // Se deu erro na thread
  if Assigned(TThread(Sender).FatalException) then
  begin
    showmessage(Exception(TThread(sender).FatalException).Message);
    exit;
  end;

  //Mensagem('Uma pena que você se foi. O cancelamento foi feito com sucesso.');
  showmessage('Sua assinatura foi cancelada com sucesso');
  CarregarDadosPerfil;
end;

procedure TFrmAssinatura.Mensagem(msg: string);
begin
  lblMsg.Text := msg;
  TabControl.GotoVisibleTab(4);
end;

procedure TFrmAssinatura.WebBrowserDidStartLoad(ASender: TObject);
begin
  if Pos('sucesso', WebBrowser.URL) > 0 then
    Mensagem('Tudo certo! Agora você é membro do Poupei.');
end;

procedure TFrmAssinatura.btnAssinarClick(Sender: TObject);
begin
  TLoading.Show(FrmAssinatura);

  TLoading.ExecuteThread(procedure
  begin
    url_checkout := DmGlobal.GerarURLCheckout;
  end,
  TerminateURL);
end;

procedure TFrmAssinatura.btnCancelarClick(Sender: TObject);
begin
  TLoading.Show(FrmAssinatura);

  TLoading.ExecuteThread(procedure
  begin
    DmGlobal.CancelarAssinatura;
  end,
  TerminateCancelamento);
end;

procedure TFrmAssinatura.btnSucessoClick(Sender: TObject);
begin
  if NOT Assigned(FrmPrincipal) then
    Application.CreateForm(TFrmPrincipal, FrmPrincipal);

  Application.MainForm := FrmPrincipal;
  FrmPrincipal.Show;
  FrmAssinatura.Close;
end;

procedure TFrmAssinatura.CarregarDadosPerfil;
begin
  TLoading.Show(FrmAssinatura);

  TLoading.ExecuteThread(procedure
  begin
    DmGlobal.DadosUsuario;
  end,
  TerminateDadosPerfil);
end;

procedure TFrmAssinatura.FormShow(Sender: TObject);
begin
  CarregarDadosPerfil;
end;

procedure TFrmAssinatura.imgFecharClick(Sender: TObject);
begin
  close;
end;

end.
