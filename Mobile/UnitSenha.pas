unit UnitSenha;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  uLoading;

type
  TFrmSenha = class(TForm)
    Layout1: TLayout;
    lblTitulo: TLabel;
    imgFechar: TImage;
    imgSalvar: TImage;
    Layout2: TLayout;
    edtSenha1: TEdit;
    edtSenha2: TEdit;
    procedure imgFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure imgSalvarClick(Sender: TObject);
  private
    procedure TerminateSenha(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmSenha: TFrmSenha;

implementation

{$R *.fmx}

uses Dm.Global;

procedure TFrmSenha.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FrmSenha := nil;
end;

procedure TFrmSenha.imgFecharClick(Sender: TObject);
begin
  close;
end;

procedure TFrmSenha.TerminateSenha(Sender: TObject);
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

procedure TFrmSenha.imgSalvarClick(Sender: TObject);
begin
  if (edtSenha1.Text <> edtSenha2.Text) then
  begin
    showmessage('As senhas não conferem. Digite novamente.');
    exit;
  end;

  TLoading.Show(FrmSenha);

  TLoading.ExecuteThread(procedure
  begin
    DmGlobal.EditarSenha(edtSenha1.Text);
  end,
  TerminateSenha);
end;

end.
