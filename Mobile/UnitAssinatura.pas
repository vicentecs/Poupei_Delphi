unit UnitAssinatura;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.TabControl, FMX.Edit,
  uLoading, uFunctions;

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
    procedure imgFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    procedure CarregarDadosPerfil;
    procedure TerminateDadosPerfil(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmAssinatura: TFrmAssinatura;

implementation

{$R *.fmx}

uses Dm.Global;

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
