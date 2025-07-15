unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView;

type
  TFrmPrincipal = class(TForm)
    lytToolbar1: TLayout;
    Image1: TImage;
    Layout1: TLayout;
    lytSaldo: TLayout;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    lytTotalReceitas: TLayout;
    Image3: TImage;
    Label3: TLabel;
    Label4: TLabel;
    lytTotalDesepsas: TLayout;
    Image4: TImage;
    Label5: TLabel;
    Label6: TLabel;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Label7: TLabel;
    Label8: TLabel;
    lvLancamentos: TListView;
    rectBottomAbas: TRectangle;
    rectAbas: TRectangle;
    Layout3: TLayout;
    Image5: TImage;
    imgAbaHome: TImage;
    imgAbaLanc: TImage;
    imgAbaConfig: TImage;
    Layout4: TLayout;
    procedure FormShow(Sender: TObject);
    procedure Label8Click(Sender: TObject);
    procedure imgAbaConfigClick(Sender: TObject);
  private
    procedure AddLancamentoLv(id_lancamento: integer; descricao,
                            categoria, dt: string; valor: double);
    procedure ListarUltLancamentos;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitLancamento, UnitConfig;

procedure TFrmPrincipal.AddLancamentoLv(id_lancamento: integer;
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

procedure TFrmPrincipal.Label8Click(Sender: TObject);
begin
  if NOT Assigned(FrmLancamento) then
    Application.CreateForm(TFrmLancamento, FrmLancamento);

  FrmLancamento.Show;
end;

procedure TFrmPrincipal.ListarUltLancamentos;
begin
  AddLancamentoLv(1, 'Compra de Passagem', 'Transporte', '15/05', 45);
  AddLancamentoLv(1, 'Compra de Passagem', 'Transporte', '15/05', 45);
  AddLancamentoLv(1, 'Compra de Passagem', 'Transporte', '15/05', 45);
  AddLancamentoLv(1, 'Compra de Passagem', 'Transporte', '15/05', 45);
  AddLancamentoLv(1, 'Compra de Passagem', 'Transporte', '15/05', 45);
  AddLancamentoLv(1, 'Compra de Passagem', 'Transporte', '15/05', 45);
  AddLancamentoLv(1, 'Compra de Passagem', 'Transporte', '15/05', 45);
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

end.
