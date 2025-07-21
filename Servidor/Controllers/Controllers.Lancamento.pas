unit Controllers.Lancamento;

interface

uses Horse,
     Horse.JWT,
     System.SysUtils,
     System.JSON,
     Services.Lancamento,
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
        .get('/lancamentos', Listar);

  THorse.AddCallback(HorseJWT(Controllers.JWT.SECRET,
                     THorseJWTConfig.New.SessionClass(TMyClaims)))
      .get('/lancamentos/:id_lancamento', ListarId);

  THorse.AddCallback(HorseJWT(Controllers.JWT.SECRET,
                     THorseJWTConfig.New.SessionClass(TMyClaims)))
      .post('/lancamentos', Inserir);

  THorse.AddCallback(HorseJWT(Controllers.JWT.SECRET,
                     THorseJWTConfig.New.SessionClass(TMyClaims)))
      .put('/lancamentos/:id_lancamento', Editar);

  THorse.AddCallback(HorseJWT(Controllers.JWT.SECRET,
                     THorseJWTConfig.New.SessionClass(TMyClaims)))
    .delete('/lancamentos/:id_lancamento', Excluir);
end;

procedure Listar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  id_usuario, id_categoria: integer;
  dt_de, dt_ate: string;
begin
  try
    id_usuario := Get_Usuario_Request(Req);

    try
      id_categoria := Req.Query['id_categoria'].ToInteger;
    except
      id_categoria := 0;
    end;

    dt_de := Req.Query['dt_de'];
    dt_ate := Req.Query['dt_ate'];


    Res.Send<TJsonArray>(Services.Lancamento.Listar(id_usuario, id_categoria, dt_de, dt_ate));

  except on ex:exception do
    Res.Send(ex.message).Status(500);
  end;
end;

procedure Inserir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  descricao, tipo, dt_lancamento: string;
  valor: double;
  id_usuario, id_categoria: integer;
  body: TJsonObject;
begin
  try

    body := Req.Body<TJSONObject>;
    descricao := body.GetValue<string>('descricao', '');
    tipo := body.GetValue<string>('tipo', '');
    dt_lancamento := body.GetValue<string>('dt_lancamento', '');
    valor := body.GetValue<double>('valor', 0);
    id_categoria := body.GetValue<integer>('id_categoria', 0);

    id_usuario := Get_Usuario_Request(Req);

    Res.Send<TJSONObject>(Services.Lancamento.Inserir(id_usuario, id_categoria, descricao,
                                                      tipo, dt_lancamento, valor))
       .Status(201);

  except on ex:exception do
    Res.Send(ex.Message).Status(500);
  end;
end;

procedure Editar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  descricao, tipo, dt_lancamento: string;
  valor: double;
  id_usuario, id_categoria, id_lancamento: integer;
  body: TJsonObject;
begin
  try
    body := Req.Body<TJSONObject>;
    descricao := body.GetValue<string>('descricao', '');
    tipo := body.GetValue<string>('tipo', '');
    dt_lancamento := body.GetValue<string>('dt_lancamento', '');
    valor := body.GetValue<double>('valor', 0);
    id_categoria := body.GetValue<integer>('id_categoria', 0);

    id_lancamento := Req.Params['id_lancamento'].ToInteger;
    id_usuario := Get_Usuario_Request(Req);

    Services.Lancamento.Editar(id_usuario, id_lancamento, id_categoria,
                               descricao, tipo, dt_lancamento, valor);
    Res.Send('OK');

  except on ex:exception do
    Res.Send(ex.Message).Status(500);
  end;
end;

procedure ListarId(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  id_usuario, id_lancamento: integer;
begin
  try
    id_usuario := Get_Usuario_Request(Req);
    id_lancamento := Req.Params['id_lancamento'].ToInteger;

    Res.Send<TJsonObject>(Services.Lancamento.ListarId(id_usuario, id_lancamento));

  except on ex:exception do
    Res.Send(ex.Message).Status(500);
  end;
end;

procedure Excluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  id_usuario, id_lancamento: integer;
begin
  try

    id_usuario := Get_Usuario_Request(Req);
    id_lancamento := Req.Params['id_lancamento'].ToInteger;

    Services.Lancamento.Excluir(id_usuario, id_lancamento);
    Res.Send('OK');

  except on ex:exception do
    Res.Send(ex.Message).Status(500);
  end;
end;


end.

