unit UnitCategoriaCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit,
  uLoading, FMX.DialogService;

type
  TExecuteOnClose = procedure of object;

  TFrmCategoriaCad = class(TForm)
    Layout1: TLayout;
    lblTitulo: TLabel;
    imgFechar: TImage;
    imgSalvar: TImage;
    Layout2: TLayout;
    edtDescricao: TEdit;
    Layout4: TLayout;
    imgDelete: TImage;
    procedure imgFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure imgSalvarClick(Sender: TObject);
    procedure imgDeleteClick(Sender: TObject);
  private
    Fid_categoria: integer;
    FExecuteOnClose: TExecuteOnClose;
    procedure DadosCategoria(id_cat: integer);
    procedure TerminateDados(Sender: TObject);
    procedure TerminateSalvar(Sender: TObject);
    procedure ExcluirCategoria(id_cat: integer);
    { Private declarations }
  public
    property id_categoria: integer read Fid_categoria write Fid_categoria;
    property ExecuteOnClose: TExecuteOnClose read FExecuteOnClose write FExecuteOnClose;
  end;

var
  FrmCategoriaCad: TFrmCategoriaCad;

implementation

{$R *.fmx}

uses Dm.Global;

procedure TFrmCategoriaCad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FrmCategoriaCad := nil;
end;

procedure TFrmCategoriaCad.TerminateDados(Sender: TObject);
begin
  TLoading.Hide;

  // Se deu erro na thread
  if Assigned(TThread(Sender).FatalException) then
  begin
    showmessage(Exception(TThread(sender).FatalException).Message);
    exit;
  end;

  edtDescricao.Text := DmGlobal.TabCategoria.FieldByName('descricao').AsString;
end;

procedure TFrmCategoriaCad.DadosCategoria(id_cat: integer);
begin
  TLoading.Show(FrmCategoriaCad);

  TLoading.ExecuteThread(procedure
  begin
    DmGlobal.ListarCategoriaId(id_cat);
  end,
  TerminateDados);
end;

procedure TFrmCategoriaCad.FormShow(Sender: TObject);
begin
  if id_categoria > 0 then
  begin
    imgDelete.Visible := true;
    lblTitulo.Text := 'Editar Categoria';
    DadosCategoria(id_categoria);
  end;
end;

procedure TFrmCategoriaCad.ExcluirCategoria(id_cat: integer);
begin
  TLoading.Show(FrmCategoriaCad);

  TLoading.ExecuteThread(procedure
  begin
    DmGlobal.ExcluirCategoria(id_cat);
  end,
  TerminateSalvar);
end;


procedure TFrmCategoriaCad.imgDeleteClick(Sender: TObject);
begin
  TDialogService.MessageDialog('Confirma exclusão da categoria?',
                     TMsgDlgType.mtConfirmation,
                     [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                     TMsgDlgBtn.mbNo,
                     0,
         procedure(const AResult: TModalResult)
         begin
            if AResult = mrYes then
              ExcluirCategoria(id_categoria);
         end);
end;

procedure TFrmCategoriaCad.imgFecharClick(Sender: TObject);
begin
  close;
end;

procedure TFrmCategoriaCad.TerminateSalvar(Sender: TObject);
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

procedure TFrmCategoriaCad.imgSalvarClick(Sender: TObject);
begin
  TLoading.Show(FrmCategoriaCad);

  TLoading.ExecuteThread(procedure
  begin
    if id_categoria = 0 then
      DmGlobal.InserirCategoria(edtDescricao.Text)
    else
      DmGlobal.EditarCategoria(id_categoria, edtDescricao.Text);
  end,
  TerminateSalvar);
end;

end.
