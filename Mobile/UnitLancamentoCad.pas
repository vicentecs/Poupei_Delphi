unit UnitLancamentoCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit, FMX.ListBox,
  FMX.DateTimeCtrls, uLoading, uFunctions;

type
  TFrmLancamentoCad = class(TForm)
    Layout1: TLayout;
    lblTitulo: TLabel;
    imgFechar: TImage;
    imgSalvar: TImage;
    Layout2: TLayout;
    edtDescricao: TEdit;
    Layout3: TLayout;
    edtValor: TEdit;
    Rectangle2: TRectangle;
    lblReceita: TLabel;
    lblDespesa: TLabel;
    cmbCategoria: TComboBox;
    dtLanc: TDateEdit;
    Image1: TImage;
    Layout4: TLayout;
    procedure imgFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure lblReceitaClick(Sender: TObject);
    procedure lblDespesaClick(Sender: TObject);
    procedure imgSalvarClick(Sender: TObject);
  private
    Fid_lancamento: integer;
    Ftipo: string;
    procedure CarregarTela;
    procedure TerminateTela(Sender: TObject);
    procedure SetTipo(tp: string);
    procedure TerminateSalvar(Sender: TObject);
    { Private declarations }
  public
    property id_lancamento: integer read Fid_lancamento write Fid_lancamento;
  end;

var
  FrmLancamentoCad: TFrmLancamentoCad;

implementation

{$R *.fmx}

uses Dm.Global;

procedure TFrmLancamentoCad.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FrmLancamentoCad := nil;
end;

procedure TFrmLancamentoCad.FormShow(Sender: TObject);
begin
  CarregarTela;
end;

procedure TFrmLancamentoCad.imgFecharClick(Sender: TObject);
begin
  close;
end;

procedure TFrmLancamentoCad.TerminateSalvar(Sender: TObject);
begin
  TLoading.Hide;

  // Se deu erro na thread
  if Assigned(TThread(Sender).FatalException) then
  begin
    showmessage(Exception(TThread(sender).FatalException).Message);
    exit;
  end;

  close;
end;


procedure TFrmLancamentoCad.imgSalvarClick(Sender: TObject);
begin
  TLoading.Show(FrmLancamentoCad);

  TLoading.ExecuteThread(procedure
  begin
    DmGlobal.InserirLancamamento(edtDescricao.Text,
                                 Ftipo,
                                 FormatDateTime('yyyy-mm-dd', dtLanc.date),
                                 edtValor.Text.ToDouble,
                                 ComboGetId(cmbCategoria)
                                 );
  end,
  TerminateSalvar);
end;


procedure TFrmLancamentoCad.SetTipo(tp: string);
begin
  Ftipo := tp;
end;

procedure TFrmLancamentoCad.lblDespesaClick(Sender: TObject);
begin
  SetTipo('D');
end;

procedure TFrmLancamentoCad.lblReceitaClick(Sender: TObject);
begin
  SetTipo('R');
end;

procedure TFrmLancamentoCad.TerminateTela(Sender: TObject);
begin
  TLoading.Hide;

  // Se deu erro na thread
  if Assigned(TThread(Sender).FatalException) then
  begin
    showmessage(Exception(TThread(sender).FatalException).Message);
    exit;
  end;

  MontaCombo(cmbCategoria, DmGlobal.TabCategoria,
             'id_categoria', 'descricao', false);

end;

procedure TFrmLancamentoCad.CarregarTela;
begin
  TLoading.Show(FrmLancamentoCad);

  TLoading.ExecuteThread(procedure
  begin
    DmGlobal.ListarCategorias;
  end,
  TerminateTela);
end;

end.
