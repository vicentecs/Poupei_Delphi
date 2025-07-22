unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, uLoading, System.DateUtils, uFunctions, System.StrUtils;

type
  TFrmPrincipal = class(TForm)
    lytToolbar1: TLayout;
    Image1: TImage;
    Layout1: TLayout;
    lytSaldo: TLayout;
    Image2: TImage;
    Label1: TLabel;
    lblSaldo: TLabel;
    lytTotalReceitas: TLayout;
    Image3: TImage;
    Label3: TLabel;
    lblTotRec: TLabel;
    lytTotalDesepsas: TLayout;
    Image4: TImage;
    Label5: TLabel;
    lblTotDesp: TLabel;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Label7: TLabel;
    lblTodos: TLabel;
    lvLancamentos: TListView;
    rectBottomAbas: TRectangle;
    rectAbas: TRectangle;
    Layout3: TLayout;
    imgAdd: TImage;
    imgAbaHome: TImage;
    imgAbaLanc: TImage;
    imgAbaConfig: TImage;
    Layout4: TLayout;
    procedure FormShow(Sender: TObject);
    procedure lblTodosClick(Sender: TObject);
    procedure imgAbaConfigClick(Sender: TObject);
    procedure imgAddClick(Sender: TObject);
    procedure imgAbaHomeClick(Sender: TObject);
    procedure lvLancamentosItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    procedure AddLancamentoLv(id_lancamento: integer; descricao,
                            categoria, dt, tipo: string; valor: double);
    procedure ListarUltLancamentos;
    procedure TerminateLancamentos(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitLancamento, UnitConfig, UnitLancamentoCad, Dm.Global;

procedure TFrmPrincipal.AddLancamentoLv(id_lancamento: integer;
                                        descricao, categoria,
                                        dt, tipo: string;
                                        valor: double);
var
  item: TListViewItem;
begin
  item := lvLancamentos.Items.Add;
  item.Height := 50;
  item.Tag := id_lancamento;

  TListItemText(item.Objects.FindDrawable('txtDescricao')).Text := descricao;
  TListItemText(item.Objects.FindDrawable('txtCategoria')).Text := categoria;
  TListItemText(item.Objects.FindDrawable('txtData')).Text := Copy(dt, 1, 5);


  TListItemText(item.Objects.FindDrawable('txtValor')).Text :=
                    ifthen(tipo = 'D', '-', '') +
                    FormatFloat('R$#,##0.00', valor);
end;

procedure TFrmPrincipal.lblTodosClick(Sender: TObject);
begin
  if NOT Assigned(FrmLancamento) then
    Application.CreateForm(TFrmLancamento, FrmLancamento);

  FrmLancamento.Show;
end;

procedure TFrmPrincipal.TerminateLancamentos(Sender: TObject);
var
  tot_rec, tot_desp: double;
begin
  TLoading.Hide;

  // Se deu erro na thread
  if Assigned(TThread(Sender).FatalException) then
  begin
    showmessage(Exception(TThread(sender).FatalException).Message);
    exit;
  end;

  tot_rec := 0;
  tot_desp := 0;
  while NOT DmGlobal.TabLanc.Eof do
  begin
    AddLancamentoLv(DmGlobal.TabLanc.FieldByName('id_lancamento').AsInteger,
                    DmGlobal.TabLanc.FieldByName('descricao').AsString,
                    DmGlobal.TabLanc.FieldByName('categoria').AsString,
                    UTCtoShortDateBR(DmGlobal.TabLanc.FieldByName('dt_lancamento').AsString),
                    DmGlobal.TabLanc.FieldByName('tipo').AsString,
                    DmGlobal.TabLanc.FieldByName('valor').AsFloat);

    if DmGlobal.TabLanc.FieldByName('tipo').AsString = 'D' then
      tot_desp := tot_desp + DmGlobal.TabLanc.FieldByName('valor').AsFloat
    else
      tot_rec := tot_rec + DmGlobal.TabLanc.FieldByName('valor').AsFloat;


    DmGlobal.TabLanc.Next;
  end;

  lblTotRec.Text := FormatFloat('R$#,##0.00', tot_rec);
  lblTotDesp.Text := FormatFloat('R$#,##0.00', tot_desp);
  lblSaldo.Text := FormatFloat('R$#,##0.00', tot_rec - tot_desp);

end;

procedure TFrmPrincipal.ListarUltLancamentos;
begin
  TLoading.Show(FrmPrincipal);
  lvLancamentos.Items.Clear;

  TLoading.ExecuteThread(procedure
  var
    dt_de, dt_ate: string;
  begin
    dt_de := FormatDateTime('yyyy-mm-dd', StartOfTheMonth(date));
    dt_ate := FormatDateTime('yyyy-mm-dd', EndOfTheMonth(date));

    DmGlobal.ListarLancamentos(0, dt_de, dt_ate);
  end,
  TerminateLancamentos);
end;

procedure TFrmPrincipal.lvLancamentosItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  if NOT Assigned(FrmLancamentoCad) then
    Application.CreateForm(TFrmLancamentoCad, FrmLancamentoCad);

  FrmLancamentoCad.ExecuteOnClose := ListarUltLancamentos;
  FrmLancamentoCad.id_lancamento := AItem.Tag;
  FrmLancamentoCad.Show;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  ListarUltLancamentos;
end;

procedure TFrmPrincipal.imgAbaConfigClick(Sender: TObject);
begin
  if NOT Assigned(FrmConfig) then
    Application.CreateForm(TFrmConfig, FrmConfig);

  FrmConfig.Show;
end;

procedure TFrmPrincipal.imgAbaHomeClick(Sender: TObject);
begin
  ListarUltLancamentos;
end;

procedure TFrmPrincipal.imgAddClick(Sender: TObject);
begin
  if NOT Assigned(FrmLancamentoCad) then
    Application.CreateForm(TFrmLancamentoCad, FrmLancamentoCad);

  FrmLancamentoCad.ExecuteOnClose := ListarUltLancamentos;
  FrmLancamentoCad.id_lancamento := 0;
  FrmLancamentoCad.Show;
end;

end.
