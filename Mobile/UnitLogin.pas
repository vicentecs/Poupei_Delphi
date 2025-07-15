unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit;

type
  TFrmLogin = class(TForm)
    TabControl: TTabControl;
    TabBoasVindas: TTabItem;
    TabLogin: TTabItem;
    TabNovaConta: TTabItem;
    Layout1: TLayout;
    Image1: TImage;
    Label1: TLabel;
    rectAcessarLogin: TRectangle;
    btnAcessarLogin: TSpeedButton;
    Rectangle1: TRectangle;
    SpeedButton1: TSpeedButton;
    Layout2: TLayout;
    Image2: TImage;
    Label2: TLabel;
    Rectangle2: TRectangle;
    SpeedButton2: TSpeedButton;
    Edit1: TEdit;
    Edit2: TEdit;
    lblNovaConta: TLabel;
    Layout3: TLayout;
    Image3: TImage;
    Label4: TLabel;
    Rectangle3: TRectangle;
    SpeedButton3: TSpeedButton;
    Edit3: TEdit;
    Edit4: TEdit;
    Label5: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    procedure btnAcessarLoginClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure lblNovaContaClick(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

procedure TFrmLogin.btnAcessarLoginClick(Sender: TObject);
begin
  TabControl.GotoVisibleTab(1);
end;

procedure TFrmLogin.FormShow(Sender: TObject);
begin
  TabControl.ActiveTab := TabBoasVindas;
end;

procedure TFrmLogin.Label5Click(Sender: TObject);
begin
  TabControl.GotoVisibleTab(1);
end;

procedure TFrmLogin.lblNovaContaClick(Sender: TObject);
begin
  TabControl.GotoVisibleTab(2);
end;

procedure TFrmLogin.SpeedButton1Click(Sender: TObject);
begin
  TabControl.GotoVisibleTab(2);
end;

end.
