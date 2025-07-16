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

uses UnitCategoriaCad;

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

  AddCategoriaLv(1, 'Transporte');
  AddCategoriaLv(2, 'Lazer');
  AddCategoriaLv(3, 'Viagem');
  AddCategoriaLv(4, 'Mercado');
  AddCategoriaLv(5, 'Casa');
end;

procedure TFrmCategoria.ListarCategorias;
begin
  TLoading.Show(FrmCategoria);

  TLoading.ExecuteThread(procedure
  begin
    Sleep(2000); // Simulando acesso ao servidor...
  end,
  TerminateCategorias);
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

  FrmCategoriaCad.Show;
end;

procedure TFrmCategoria.imgFecharClick(Sender: TObject);
begin
  close;
end;

end.
