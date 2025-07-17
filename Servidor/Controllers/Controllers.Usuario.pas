unit Controllers.Usuario;

interface

uses Horse;

procedure RegistrarRotas;
procedure Login(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure InserirUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure EditarSenha(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ListarUsuarioId(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure EditarUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure RegistrarRotas;
begin
  THorse.post('/usuarios/login', Login);
  THorse.post('/usuarios/cadastro', InserirUsuario);
  THorse.post('/usuarios/password', EditarSenha);
  THorse.get('/usuarios', ListarUsuarioId);
  THorse.put('/usuarios', EditarUsuario);
end;

procedure Login(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('Vc acessou a rotina de login');
end;

procedure InserirUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('Vc acessou a rotina de inserir usuário');
end;

procedure EditarSenha(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('Vc acessou a rotina EditarSenha');
end;

procedure ListarUsuarioId(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('Vc acessou a rotina ListarUsuarioId');
end;

procedure EditarUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('Vc acessou a rotina EditarUsuario');
end;

end.
