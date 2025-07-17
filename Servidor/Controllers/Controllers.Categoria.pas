unit Controllers.Categoria;

interface

uses Horse,
     System.SysUtils,
     System.JSON,
     Services.Categoria;

procedure RegistrarRotas;
procedure Listar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ListarId(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Inserir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Editar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Excluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure RegistrarRotas;
begin
  THorse.get('/categorias', Listar);
  THorse.get('/categorias/:id_categoria', ListarId);
  THorse.post('/categorias', Inserir);
  THorse.put('/categorias/:id_categoria', Editar);
  THorse.delete('/categorias/:id_categoria', Excluir);
end;

procedure Listar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  id_usuario: integer;
begin
  try
    id_usuario := 1; // pegaremos do token JWT


    Res.Send<TJsonArray>(Services.Categoria.Listar(id_usuario));

  except on ex:exception do
    Res.Send(ex.message).Status(500);
  end;
end;

procedure ListarId(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('Vc acessou a rotina ListarId');
end;

procedure Inserir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('Vc acessou a rotina Inserir');
end;

procedure Editar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('Vc acessou a rotina Editar');
end;

procedure Excluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('Vc acessou a rotina Excluir');
end;

end.

