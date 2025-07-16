unit UnitLancamentoCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit, FMX.ListBox,
  FMX.DateTimeCtrls;

type
  TFrmLancamentoCad = class(TForm)
    Layout1: TLayout;
    lblTitulo: TLabel;
    imgFechar: TImage;
    imgSalvar: TImage;
    Layout2: TLayout;
    Edit1: TEdit;
    Layout3: TLayout;
    Edit2: TEdit;
    Rectangle2: TRectangle;
    Label1: TLabel;
    Label2: TLabel;
    ComboBox1: TComboBox;
    DateEdit1: TDateEdit;
    Image1: TImage;
    Layout4: TLayout;
    procedure imgFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLancamentoCad: TFrmLancamentoCad;

implementation

{$R *.fmx}

procedure TFrmLancamentoCad.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FrmLancamentoCad := nil;
end;

procedure TFrmLancamentoCad.imgFecharClick(Sender: TObject);
begin
  close;
end;

end.
