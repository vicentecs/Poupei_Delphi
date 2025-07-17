unit Services.Categoria;

interface

uses Horse,
     System.SysUtils,
     System.JSON,
     Dm.Global;

function Listar(id_usuario: integer): TJsonArray;
procedure ListarId();
procedure Inserir();
procedure Editar();
procedure Excluir();

implementation

function Listar(id_usuario: integer): TJsonArray;
var
  dm: TDmGlobal;
begin
  try
    dm := TDmGlobal.Create(nil);

    Result := dm.ListarCategorias(id_usuario);

  finally
    FreeAndNil(dm);
  end;
end;

procedure ListarId();
begin
  //Res.Send('Vc acessou a rotina ListarId');
end;

procedure Inserir();
begin
//  Res.Send('Vc acessou a rotina Inserir');
end;

procedure Editar();
begin
//  Res.Send('Vc acessou a rotina Editar');
end;

procedure Excluir();
begin
//  Res.Send('Vc acessou a rotina Excluir');
end;

end.

