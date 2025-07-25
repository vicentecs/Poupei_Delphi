unit UnitLancamento;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  uLoading, System.StrUtils, System.DateUtils, uFunctions;

type
  TFrmLancamento = class(TForm)
    Layout1: TLayout;
    imgFechar: TImage;
    Label7: TLabel;
    Rectangle2: TRectangle;
    lblData: TLabel;
    rectMeses: TRectangle;
    imgPrior: TImage;
    imgNext: TImage;
    rectAbas: TRectangle;
    Layout2: TLayout;
    Label1: TLabel;
    lblTotRec: TLabel;
    Label3: TLabel;
    lblTotDesp: TLabel;
    Label5: TLabel;
    lblSaldo: TLabel;
    lvLancamentos: TListView;
    imgAdd: TImage;
    procedure FormShow(Sender: TObject);
    procedure imgFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure imgPriorClick(Sender: TObject);
    procedure imgNextClick(Sender: TObject);
    procedure imgAddClick(Sender: TObject);
    procedure lvLancamentosItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    FData: TDateTime;
    procedure AddLancamentoLv(id_lancamento: integer;
                              descricao, categoria,
                              dt, tipo: string;
                              valor: double);
    procedure ListarLancamentos;
    procedure TerminateLancamentos(Sender: TObject);
    procedure NavegacaoMes(param: integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLancamento: TFrmLancamento;

implementation

{$R *.fmx}

uses Dm.Global, UnitLancamentoCad;

procedure TFrmLancamento.AddLancamentoLv(id_lancamento: integer;
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

procedure TFrmLancamento.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FrmLancamento := nil;
end;

procedure TFrmLancamento.FormShow(Sender: TObject);
begin
  FData := now;
  ListarLancamentos;
end;

procedure TFrmLancamento.imgAddClick(Sender: TObject);
begin
  if NOT Assigned(FrmLancamentoCad) then
    Application.CreateForm(TFrmLancamentoCad, FrmLancamentoCad);

  FrmLancamentoCad.ExecuteOnClose := ListarLancamentos;
  FrmLancamentoCad.id_lancamento := 0;
  FrmLancamentoCad.Show;
end;

procedure TFrmLancamento.imgFecharClick(Sender: TObject);
begin
  close;
end;

procedure TFrmLancamento.NavegacaoMes(param: integer);
begin
  FData.AddMonth(param);
  ListarLancamentos;
end;

procedure TFrmLancamento.imgNextClick(Sender: TObject);
begin
  NavegacaoMes(1);
end;

procedure TFrmLancamento.imgPriorClick(Sender: TObject);
begin
  NavegacaoMes(-1);
end;

procedure TFrmLancamento.TerminateLancamentos(Sender: TObject);
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

procedure TFrmLancamento.ListarLancamentos;
begin
  lvLancamentos.Items.Clear;
  lblData.Text := MonthDescription(FData) + ' / ' + FormatDateTime('yyyy', FData);
  TLoading.Show(FrmLancamento);

  TLoading.ExecuteThread(procedure
  begin
    DmGlobal.ListarLancamentos(0,
                               FormatDateTime('yyyy-mm-dd', StartOfTheMonth(FData)),
                               FormatDateTime('yyyy-mm-dd', EndOfTheMonth(FData)));
  end,
  TerminateLancamentos);
end;


procedure TFrmLancamento.lvLancamentosItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  if NOT Assigned(FrmLancamentoCad) then
    Application.CreateForm(TFrmLancamentoCad, FrmLancamentoCad);

  FrmLancamentoCad.ExecuteOnClose := ListarLancamentos;
  FrmLancamentoCad.id_lancamento := AItem.Tag;
  FrmLancamentoCad.Show;
end;

end.
