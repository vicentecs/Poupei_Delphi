unit UnitLancamentoCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit, FMX.ListBox,
  FMX.DateTimeCtrls, uLoading, uFunctions, FMX.DialogService,
  uCombobox;

type
  TExecuteOnClose = procedure of object;

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
    dtLanc: TDateEdit;
    imgDelete: TImage;
    Layout4: TLayout;
    rectCategoria: TRectangle;
    lblCategoria: TLabel;
    Image1: TImage;
    procedure imgFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure lblReceitaClick(Sender: TObject);
    procedure lblDespesaClick(Sender: TObject);
    procedure imgSalvarClick(Sender: TObject);
    procedure imgDeleteClick(Sender: TObject);
    procedure rectCategoriaClick(Sender: TObject);
  private
    Fid_lancamento: integer;
    Ftipo: string;
    FExecuteOnClose: TExecuteOnClose;
    comboCategoria: TCustomCombobox;

    {$IFDEF MSWINDOWS}
    procedure onClickCategoria(Sender: TObject);
    {$ELSE}
    procedure onClickCategoria(Sender: TObject; const Point: TPointF);
    {$ENDIF}

    procedure CarregarTela;
    procedure TerminateTela(Sender: TObject);
    procedure SetTipo(tp: string);
    procedure TerminateSalvar(Sender: TObject);
    procedure DadosLancamento(id_lanc: integer);
    procedure TerminateDados(Sender: TObject);
    procedure ExcluirLancamento(id_lanc: integer);
    procedure MontaCustomCombo;
    { Private declarations }
  public
    property id_lancamento: integer read Fid_lancamento write Fid_lancamento;
    property ExecuteOnClose: TExecuteOnClose read FExecuteOnClose write FExecuteOnClose;
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

procedure TFrmLancamentoCad.ExcluirLancamento(id_lanc: integer);
begin
  TLoading.Show(FrmLancamentoCad);

  TLoading.ExecuteThread(procedure
  begin
    DmGlobal.ExcluirLancamento(id_lanc);
  end,
  TerminateSalvar);
end;

procedure TFrmLancamentoCad.imgDeleteClick(Sender: TObject);
begin
  TDialogService.MessageDialog('Confirma exclusão do lançamento?',
                     TMsgDlgType.mtConfirmation,
                     [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                     TMsgDlgBtn.mbNo,
                     0,
         procedure(const AResult: TModalResult)
         begin
            if AResult = mrYes then
              ExcluirLancamento(id_lancamento);
         end);
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

  if Assigned(ExecuteOnClose) then
    ExecuteOnClose;

  close;
end;

procedure TFrmLancamentoCad.TerminateDados(Sender: TObject);
begin
  TLoading.Hide;

  // Se deu erro na thread
  if Assigned(TThread(Sender).FatalException) then
  begin
    showmessage(Exception(TThread(sender).FatalException).Message);
    exit;
  end;

  with DmGlobal.TabLanc do
  begin
    edtDescricao.Text := FieldByName('descricao').AsString;
    edtValor.Text := FieldByName('valor').AsString;
    SetTipo(FieldByName('tipo').AsString);
    //ComboSelecionarById(cmbCategoria, FieldByName('id_categoria').AsInteger);
    lblCategoria.Text := FieldByName('categoria').AsString;
    lblCategoria.Tag := FieldByName('id_categoria').AsInteger;
    dtLanc.Date := ShortStringUTCToDate(FieldByName('dt_lancamento').AsString);
  end;
end;

procedure TFrmLancamentoCad.imgSalvarClick(Sender: TObject);
begin
  if lblCategoria.Tag = 0 then
  begin
    showmessage('Escolha uma categoria');
    exit;
  end;

  TLoading.Show(FrmLancamentoCad);

  TLoading.ExecuteThread(procedure
  begin
    if id_lancamento = 0 then
      DmGlobal.InserirLancamamento(edtDescricao.Text,
                                   Ftipo,
                                   FormatDateTime('yyyy-mm-dd', dtLanc.date),
                                   edtValor.Text.ToDouble,
                                   lblCategoria.Tag // id_categoria
                                   //ComboGetId(cmbCategoria)
                                   )
    else
      DmGlobal.EditarLancamamento(id_lancamento,
                                  edtDescricao.Text,
                                  Ftipo,
                                  FormatDateTime('yyyy-mm-dd', dtLanc.date),
                                  edtValor.Text.ToDouble,
                                  lblCategoria.Tag // id_categoria
                                  //ComboGetId(cmbCategoria)
                                  );
  end,
  TerminateSalvar);
end;


procedure TFrmLancamentoCad.SetTipo(tp: string);
begin
  Ftipo := tp;
  lblReceita.FontColor := $FF959595; // cinza...
  lblDespesa.FontColor := $FF959595;

  if Ftipo = 'R' then
    lblReceita.FontColor := $FF4EB939
  else
    lblDespesa.FontColor := $FF4EB939;
end;

procedure TFrmLancamentoCad.lblDespesaClick(Sender: TObject);
begin
  SetTipo('D');
end;

procedure TFrmLancamentoCad.lblReceitaClick(Sender: TObject);
begin
  SetTipo('R');
end;

procedure TFrmLancamentoCad.DadosLancamento(id_lanc: integer);
begin
  TLoading.Show(FrmLancamentoCad);

  TLoading.ExecuteThread(procedure
  begin
    DmGlobal.ListarLancamentoId(id_lanc);
  end,
  TerminateDados);
end;

{$IFDEF MSWINDOWS}
procedure TFrmLancamentoCad.onClickCategoria(Sender: TObject);
{$ELSE}
procedure TFrmLancamentoCad.onClickCategoria(Sender: TObject; const Point: TPointF);
{$ENDIF}
begin
    comboCategoria.HideMenu;
    lblCategoria.Text := comboCategoria.DescrItem;  // Mercado
    lblCategoria.Tag := comboCategoria.CodItem.ToInteger; // 1
end;

procedure TFrmLancamentoCad.rectCategoriaClick(Sender: TObject);
begin
  comboCategoria.ShowMenu;
end;

procedure TFrmLancamentoCad.MontaCustomCombo;
begin
  comboCategoria := TCustomCombobox.Create(FrmLancamentoCad);

  comboCategoria.TitleMenuText := 'Categorias';
  //comboCategoria.TitleFontSize := 16;
  //comboCategoria.TitleFontColor := $FF4162FF;

  //comboCategoria.SubTitleMenuText := 'Escolha um endereço abaixo:';
  //comboCategoria.SubTitleFontSize := 10;
  //comboCategoria.SubTitleFontColor := $FFA3A3A3;

  comboCategoria.BackgroundColor := $FFFFFFFF;
  comboCategoria.ItemBackgroundColor := $FFF2F2F8;
  //comboCategoria.ItemFontSize := 15;
  comboCategoria.ItemFontColor := $FF020202;

  comboCategoria.OnClick := onClickCategoria;

  comboCategoria.ClearAll;
  with DmGlobal.TabCategoria do
  begin
    while NOT eof do
    begin
      comboCategoria.AddItem(FieldByName('id_categoria').AsString,
                             FieldByName('descricao').AsString);

      Next;
    end;
  end;

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

  //MontaCombo(cmbCategoria, DmGlobal.TabCategoria,
  //           'id_categoria', 'descricao', false);

  MontaCustomCombo;

  // Modo edicao
  if id_lancamento > 0 then
    DadosLancamento(id_lancamento);
end;

procedure TFrmLancamentoCad.CarregarTela;
begin
  if id_lancamento > 0 then
  begin
    imgDelete.Visible := true;
    lblTitulo.Text := 'Editar Lançamento';
  end;

  TLoading.Show(FrmLancamentoCad);

  TLoading.ExecuteThread(procedure
  begin
    DmGlobal.ListarCategorias;
  end,
  TerminateTela);
end;

end.
