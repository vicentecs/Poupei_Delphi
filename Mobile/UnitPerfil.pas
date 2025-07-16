unit UnitPerfil;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  uLoading;

type
  TFrmPerfil = class(TForm)
    Layout1: TLayout;
    lblTitulo: TLabel;
    imgFechar: TImage;
    imgSalvar: TImage;
    Layout2: TLayout;
    edtNome: TEdit;
    edtEmail: TEdit;
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
  FrmPerfil: TFrmPerfil;

implementation

{$R *.fmx}

procedure TFrmPerfil.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FrmPerfil := nil;
end;

procedure TFrmPerfil.FormShow(Sender: TObject);
begin
  CarregarDadosPerfil;
end;

procedure TFrmPerfil.imgFecharClick(Sender: TObject);
begin
  close;
end;

procedure TFrmPerfil.TerminateDadosPerfil(Sender: TObject);
begin
  TLoading.Hide;

  // Se deu erro na thread
  if Assigned(TThread(Sender).FatalException) then
  begin
    showmessage(Exception(TThread(sender).FatalException).Message);
    exit;
  end;

  edtNome.Text := 'Heber Stein Mazutti';
  edtEmail.Text := 'heber@teste.com.br';
end;

procedure TFrmPerfil.CarregarDadosPerfil;
begin
  TLoading.Show(FrmPerfil);

  TLoading.ExecuteThread(procedure
  begin
    Sleep(2000); // Simulando acesso ao servidor...
  end,
  TerminateDadosPerfil);
end;

end.
