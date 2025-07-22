unit Controllers.Categoria;

interface

uses Horse,
     Horse.JWT,
     System.SysUtils,
     System.JSON,
     Services.Categoria,
     Controllers.JWT;

procedure RegistrarRotas;
procedure Listar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ListarId(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Inserir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Editar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Excluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure RegistrarRotas;
begin
  THorse.AddCallback(HorseJWT(Controllers.JWT.SECRET,
                     THorseJWTConfig.New.SessionClass(TMyClaims)))
        .get('/categorias', Listar);

  THorse.AddCallback(HorseJWT(Controllers.JWT.SECRET,
                     THorseJWTConfig.New.SessionClass(TMyClaims)))
      .get('/categorias/:id_categoria', ListarId);

  THorse.AddCallback(HorseJWT(Controllers.JWT.SECRET,
                     THorseJWTConfig.New.SessionClass(TMyClaims)))
      .post('/categorias', Inserir);

  THorse.AddCallback(HorseJWT(Controllers.JWT.SECRET,
                     THorseJWTConfig.New.SessionClass(TMyClaims)))
      .put('/categorias/:id_categoria', Editar);

  THorse.AddCallback(HorseJWT(Controllers.JWT.SECRET,
                     THorseJWTConfig.New.SessionClass(TMyClaims)))
    .delete('/categorias/:id_categoria', Excluir);
end;

procedure Listar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  id_usuario: integer;
begin
  try
    id_usuario := Get_Usuario_Request(Req);

    Res.Send<TJsonArray>(Services.Categoria.Listar(id_usuario));

  except on ex:exception do
    Res.Send(ex.message).Status(500);
  end;
end;

procedure Inserir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  descricao: string;
  id_usuario: integer;
  body: TJsonObject;
begin
  try

    body := Req.Body<TJSONObject>;
    descricao := body.GetValue<string>('descricao', '');
    id_usuario := Get_Usuario_Request(Req);

    Res.Send<TJSONObject>(Services.Categoria.Inserir(id_usuario, descricao))
       .Status(201);

  except on ex:exception do
    Res.Send(ex.Message).Status(500);
  end;
end;

procedure Editar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  descricao: string;
  id_usuario, id_categoria: integer;
  body: TJsonObject;
begin
  try
    body := Req.Body<TJSONObject>;
    descricao := body.GetValue<string>('descricao', '');
    id_categoria := Req.Params['id_categoria'].ToInteger;
    id_usuario := Get_Usuario_Request(Req);

    Services.Categoria.Editar(id_usuario, id_categoria, descricao);
    Res.Send('OK');

  except on ex:exception do
    Res.Send(ex.Message).Status(500);
  end;
end;

procedure ListarId(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  id_usuario, id_categoria: integer;
begin
  try
    id_usuario := Get_Usuario_Request(Req);
    id_categoria := Req.Params['id_categoria'].ToInteger;

    Res.Send<TJsonObject>(Services.Categoria.ListarId(id_usuario, id_categoria));

  except on ex:exception do
    Res.Send(ex.Message).Status(500);
  end;
end;

procedure Excluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  id_usuario, id_categoria: integer;
begin
  try

    id_usuario := Get_Usuario_Request(Req);
    id_categoria := Req.Params['id_categoria'].ToInteger;

    Services.Categoria.Excluir(id_usuario, id_categoria);
    Res.Send('OK');

  except on ex:exception do
    Res.Send(ex.Message).Status(500);
  end;
end;


end.

