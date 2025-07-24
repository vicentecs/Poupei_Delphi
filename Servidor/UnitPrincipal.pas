unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  DataSet.Serialize.Config;

type
  TFrmPrincipal = class(TForm)
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses Horse,
     Horse.Jhonson,
     Horse.CORS,
     Controllers.Usuario,
     Controllers.Categoria,
     Controllers.Lancamento,
     Controllers.Stripe;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  THorse.Use(Jhonson());
  THorse.Use(CORS);

  TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;
  TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator := '.';

  Controllers.Usuario.RegistrarRotas;
  Controllers.Categoria.RegistrarRotas;
  Controllers.Lancamento.RegistrarRotas;
  Controllers.Stripe.RegistrarRotas;

  THorse.Listen(3001);
end;

end.
