unit UnitCategoria;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  uLoading;

type
  TFrmCategoria = class(TForm)
    Layout1: TLayout;
    Label7: TLabel;
    imgFechar: TImage;
    imgAdd: TImage;
    lvCategoria: TListView;
    procedure FormShow(Sender: TObject);
    procedure imgFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure imgAddClick(Sender: TObject);
    procedure lvCategoriaItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    procedure AddCategoriaLv(id_categoria: integer; descricao: string);
    procedure ListarCategorias;
    procedure TerminateCategorias(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCategoria: TFrmCategoria;

implementation

{$R *.fmx}

uses UnitCategoriaCad, Dm.Global;

procedure TFrmCategoria.AddCategoriaLv(id_categoria: integer;
                                       descricao: string);
var
  item: TListViewItem;
begin
  item := lvCategoria.Items.Add;
  item.Height := 50;
  item.Tag := id_categoria;
  item.Text := descricao;
end;

procedure TFrmCategoria.TerminateCategorias(Sender: TObject);
begin
  TLoading.Hide;

  // Se deu erro na thread
  if Assigned(TThread(Sender).FatalException) then
  begin
    showmessage(Exception(TThread(sender).FatalException).Message);
    exit;
  end;

  while NOT DmGlobal.TabCategoria.Eof do
  begin
    AddCategoriaLv(DmGlobal.TabCategoria.FieldByName('id_categoria').AsInteger,
                   DmGlobal.TabCategoria.FieldByName('descricao').AsString);

    DmGlobal.TabCategoria.Next;
  end;

end;

procedure TFrmCategoria.ListarCategorias;
begin
  lvCategoria.Items.Clear;
  TLoading.Show(FrmCategoria);

  TLoading.ExecuteThread(procedure
  begin
    DmGlobal.ListarCategorias;
  end,
  TerminateCategorias);
end;

procedure TFrmCategoria.lvCategoriaItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  if NOT Assigned(FrmCategoriaCad) then
    Application.CreateForm(TFrmCategoriaCad, FrmCategoriaCad);

  FrmCategoriaCad.ExecuteOnClose := ListarCategorias;
  FrmCategoriaCad.id_categoria := Aitem.Tag;
  FrmCategoriaCad.Show;
end;

procedure TFrmCategoria.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FrmCategoria := nil;
end;

procedure TFrmCategoria.FormShow(Sender: TObject);
begin
  ListarCategorias;
end;


procedure TFrmCategoria.imgAddClick(Sender: TObject);
begin
  if NOT Assigned(FrmCategoriaCad) then
    Application.CreateForm(TFrmCategoriaCad, FrmCategoriaCad);

  FrmCategoriaCad.ExecuteOnClose := ListarCategorias;
  FrmCategoriaCad.id_categoria := 0;
  FrmCategoriaCad.Show;
end;

procedure TFrmCategoria.imgFecharClick(Sender: TObject);
begin
  close;
end;

end.
