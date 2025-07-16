unit UnitLancamento;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  uLoading;

type
  TFrmLancamento = class(TForm)
    Layout1: TLayout;
    imgFechar: TImage;
    Label7: TLabel;
    Rectangle2: TRectangle;
    Label8: TLabel;
    rectMeses: TRectangle;
    Image2: TImage;
    Image3: TImage;
    rectAbas: TRectangle;
    Layout2: TLayout;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lvLancamentos: TListView;
    procedure FormShow(Sender: TObject);
    procedure imgFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure AddLancamentoLv(id_lancamento: integer; descricao, categoria,
      dt: string; valor: double);
    procedure ListarLancamentos;
    procedure TerminateLancamentos(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLancamento: TFrmLancamento;

implementation

{$R *.fmx}

procedure TFrmLancamento.AddLancamentoLv(id_lancamento: integer;
                                        descricao, categoria,
                                        dt: string;
                                        valor: double);
var
  item: TListViewItem;
begin
  item := lvLancamentos.Items.Add;
  item.Height := 50;
  item.Tag := id_lancamento;

  TListItemText(item.Objects.FindDrawable('txtDescricao')).Text := descricao;
  TListItemText(item.Objects.FindDrawable('txtCategoria')).Text := categoria;
  TListItemText(item.Objects.FindDrawable('txtData')).Text := dt;
  TListItemText(item.Objects.FindDrawable('txtValor')).Text := FormatFloat('R$#,##0.00', valor);
end;

procedure TFrmLancamento.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FrmLancamento := nil;
end;

procedure TFrmLancamento.FormShow(Sender: TObject);
begin
  ListarLancamentos;
end;

procedure TFrmLancamento.imgFecharClick(Sender: TObject);
begin
  close;
end;

procedure TFrmLancamento.TerminateLancamentos(Sender: TObject);
begin
  TLoading.Hide;

  // Se deu erro na thread
  if Assigned(TThread(Sender).FatalException) then
  begin
    showmessage(Exception(TThread(sender).FatalException).Message);
    exit;
  end;

  AddLancamentoLv(1, 'Compra de Passagem', 'Transporte', '15/05', 45);
  AddLancamentoLv(1, 'Compra de Passagem', 'Transporte', '15/05', 45);
  AddLancamentoLv(1, 'Compra de Passagem', 'Transporte', '15/05', 45);
  AddLancamentoLv(1, 'Compra de Passagem', 'Transporte', '15/05', 45);
  AddLancamentoLv(1, 'Compra de Passagem', 'Transporte', '15/05', 45);
  AddLancamentoLv(1, 'Compra de Passagem', 'Transporte', '15/05', 45);
  AddLancamentoLv(1, 'Compra de Passagem', 'Transporte', '15/05', 45);
end;

procedure TFrmLancamento.ListarLancamentos;
begin
  TLoading.Show(FrmLancamento);

  TLoading.ExecuteThread(procedure
  begin
    Sleep(2000); // Simulando acesso ao servidor...
  end,
  TerminateLancamentos);
end;


end.
