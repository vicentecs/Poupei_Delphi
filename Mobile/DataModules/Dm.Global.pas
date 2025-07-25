unit Dm.Global;

interface

uses
  System.SysUtils, System.Classes, RESTRequest4D,
  DataSet.Serialize.Adapter.RESTRequest4D,
  DataSet.Serialize.Config, System.JSON, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  uSession, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait,
  System.IOUtils, FireDAC.DApt;

type
  TDmGlobal = class(TDataModule)
    TabUsuario: TFDMemTable;
    TabLanc: TFDMemTable;
    TabCategoria: TFDMemTable;
    Conn: TFDConnection;
    qryUsuario: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure ConnBeforeConnect(Sender: TObject);
    procedure ConnAfterConnect(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Login(email, senha: string);
    procedure CriarConta(nome, email, senha: string);
    procedure ListarLancamentos(id_categoria: integer; dt_de,
                                dt_ate: string);
    procedure ListarCategorias;
    procedure InserirLancamamento(descricao, tipo, dt: string; valor: double;
                                  id_categoria: integer);
    procedure ListarLancamentoId(id_lancamento: integer);
    procedure EditarLancamamento(id_lancamento: integer; descricao, tipo,
                                 dt: string; valor: double; id_categoria: integer);
    procedure ExcluirLancamento(id_lancamento: integer);
    procedure DadosUsuario;
    procedure EditarUsuario(nome, email: string);
    procedure EditarSenha(senha: string);
    procedure EditarCategoria(id_categoria: integer; descricao: string);
    procedure InserirCategoria(descricao: string);
    procedure ListarCategoriaId(id_categoria: integer);
    procedure ExcluirCategoria(id_categoria: integer);
    function GerarURLCheckout(): string;
    procedure CancelarAssinatura;
    procedure InserirUsuarioLocal(id_usuario: integer; nome, email, senha,
                                  token, status, stripe_cliente_id,
                                  stripe_assinatura_id: string);
    procedure ListarUsuarioLocal;
    procedure ExcluirUsuarioLocal;
  end;

var
  DmGlobal: TDmGlobal;

Const
  BASE_URL = 'http://localhost:3001';
  //BASE_URL = 'http://23.22.2.201:3001';


{
Configurar o AndroidManifestTemplate com:
android:usesCleartextTraffic="true"
}

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDmGlobal.DataModuleCreate(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;
  TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator := '.';

  Conn.Connected := true;
end;

procedure TDmGlobal.Login(email, senha: string);
var
  resp: IResponse;
  json: TJsonObject;
begin
  if TabUsuario.Active then
    TabUsuario.EmptyDataSet;

  TabUsuario.FieldDefs.Clear;

  json := TJsonObject.Create;
  try
    json.AddPair('email', email);
    json.AddPair('senha', senha);

    resp := TRequest.New.BaseURL(BASE_URL)
                        .Resource('/usuarios/login')
                        .AddBody(json.ToJSON)
                        .Accept('application/json')
                        .Adapters(TDataSetSerializeAdapter.New(TabUsuario))
                        .Post;

    if resp.StatusCode <> 200 then
      raise Exception.Create(resp.Content);

  finally
    FreeAndNil(json);
  end;
end;

procedure TDmGlobal.ConnAfterConnect(Sender: TObject);
begin
  Conn.ExecSQL('create table if not exists USUARIO ( ' +
                            'ID_USUARIO    INTEGER NOT NULL PRIMARY KEY, ' +
                            'NOME           VARCHAR (100), ' +
                            'EMAIL          VARCHAR (100), ' +
                            'SENHA          VARCHAR (100), ' +
                            'TOKEN          VARCHAR (100), ' +
                            'STATUS         VARCHAR (20), ' +
                            'STRIPE_CLIENTE_ID VARCHAR (1000), ' +
                            'STRIPE_ASSINATURA_ID VARCHAR (1000));'
                );
end;

procedure TDmGlobal.ConnBeforeConnect(Sender: TObject);
begin
  Conn.DriverName := 'SQLite';

  {$IFDEF MSWINDOWS}
  Conn.Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\poupei.db';
  {$ELSE}
  Conn.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'poupei.db');
  {$ENDIF}
end;

procedure TDmGlobal.CriarConta(nome, email, senha: string);
var
  resp: IResponse;
  json: TJsonObject;
begin
  if TabUsuario.Active then
    TabUsuario.EmptyDataSet;

  TabUsuario.FieldDefs.Clear;

  json := TJsonObject.Create;
  try
    json.AddPair('nome', nome);
    json.AddPair('email', email);
    json.AddPair('senha', senha);

    resp := TRequest.New.BaseURL(BASE_URL)
                        .Resource('/usuarios/cadastro')
                        .AddBody(json.ToJSON)
                        .Accept('application/json')
                        .Adapters(TDataSetSerializeAdapter.New(TabUsuario))
                        .Post;

    if resp.StatusCode <> 201 then
      raise Exception.Create(resp.Content);

  finally
    FreeAndNil(json);
  end;
end;

procedure TDmGlobal.ListarLancamentos(id_categoria: integer;
                                      dt_de, dt_ate: string);
var
  resp: IResponse;
begin
  if TabLanc.Active then
    TabLanc.EmptyDataSet;

  TabLanc.FieldDefs.Clear;

  resp := TRequest.New.BaseURL(BASE_URL)
                      .Resource('/lancamentos')
                      .AddParam('id_categoria', id_categoria.ToString)
                      .AddParam('dt_de', dt_de)
                      .AddParam('dt_ate', dt_ate)
                      .Accept('application/json')
                      .TokenBearer(TSession.token)
                      .Adapters(TDataSetSerializeAdapter.New(TabLanc))
                      .Get;

  if resp.StatusCode <> 200 then
    raise Exception.Create(resp.Content);

end;

procedure TDmGlobal.ListarLancamentoId(id_lancamento: integer);
var
  resp: IResponse;
begin
  if TabLanc.Active then
    TabLanc.EmptyDataSet;

  TabLanc.FieldDefs.Clear;

  resp := TRequest.New.BaseURL(BASE_URL)
                      .Resource('/lancamentos')
                      .ResourceSuffix(id_lancamento.ToString)
                      .Accept('application/json')
                      .TokenBearer(TSession.token)
                      .Adapters(TDataSetSerializeAdapter.New(TabLanc))
                      .Get;

  if resp.StatusCode <> 200 then
    raise Exception.Create(resp.Content);

end;

procedure TDmGlobal.InserirLancamamento(descricao, tipo, dt: string;
                                        valor: double;
                                        id_categoria: integer);
var
  resp: IResponse;
  json: TJsonObject;
begin
  json := TJsonObject.Create;
  try
    json.AddPair('descricao', descricao);
    json.AddPair('tipo', tipo);
    json.AddPair('dt_lancamento', dt);
    json.AddPair('valor', valor.ToString);
    json.AddPair('id_categoria', id_categoria.ToString);

    resp := TRequest.New.BaseURL(BASE_URL)
                        .Resource('/lancamentos')
                        .AddBody(json.ToJSON)
                        .Accept('application/json')
                        .TokenBearer(TSession.token)
                        .Post;

    if resp.StatusCode <> 201 then
      raise Exception.Create(resp.Content);

  finally
    FreeAndNil(json);
  end;
end;

procedure TDmGlobal.EditarLancamamento(id_lancamento: integer;
                                       descricao, tipo, dt: string;
                                       valor: double;
                                       id_categoria: integer);
var
  resp: IResponse;
  json: TJsonObject;
begin
  json := TJsonObject.Create;
  try
    json.AddPair('descricao', descricao);
    json.AddPair('tipo', tipo);
    json.AddPair('dt_lancamento', dt);
    json.AddPair('valor', valor.ToString);
    json.AddPair('id_categoria', id_categoria.ToString);

    resp := TRequest.New.BaseURL(BASE_URL)
                        .Resource('/lancamentos')
                        .ResourceSuffix(id_lancamento.ToString)
                        .AddBody(json.ToJSON)
                        .Accept('application/json')
                        .TokenBearer(TSession.token)
                        .Put;

    if resp.StatusCode <> 200 then
      raise Exception.Create(resp.Content);

  finally
    FreeAndNil(json);
  end;
end;

procedure TDmGlobal.ExcluirLancamento(id_lancamento: integer);
var
  resp: IResponse;
begin
  resp := TRequest.New.BaseURL(BASE_URL)
                      .Resource('/lancamentos')
                      .ResourceSuffix(id_lancamento.ToString)
                      .Accept('application/json')
                      .TokenBearer(TSession.token)
                      .Delete;

  if resp.StatusCode <> 200 then
    raise Exception.Create(resp.Content);
end;

procedure TDmGlobal.DadosUsuario;
var
  resp: IResponse;
begin
  if TabUsuario.Active then
    TabUsuario.EmptyDataSet;

  TabUsuario.FieldDefs.Clear;

  resp := TRequest.New.BaseURL(BASE_URL)
                      .Resource('/usuarios')
                      .Accept('application/json')
                      .TokenBearer(TSession.token)
                      .Adapters(TDataSetSerializeAdapter.New(TabUsuario))
                      .Get;

  if resp.StatusCode <> 200 then
    raise Exception.Create(resp.Content);
end;

procedure TDmGlobal.EditarUsuario(nome, email: string);
var
  resp: IResponse;
  json: TJsonObject;
begin
  json := TJsonObject.Create;
  try
    json.AddPair('nome', nome);
    json.AddPair('email', email);

    resp := TRequest.New.BaseURL(BASE_URL)
                        .Resource('/usuarios')
                        .AddBody(json.ToJSON)
                        .Accept('application/json')
                        .TokenBearer(TSession.token)
                        .Put;

    if resp.StatusCode <> 200 then
      raise Exception.Create(resp.Content);

  finally
    FreeAndNil(json);
  end;
end;

procedure TDmGlobal.EditarSenha(senha: string);
var
  resp: IResponse;
  json: TJsonObject;
begin
  json := TJsonObject.Create;
  try
    json.AddPair('senha', senha);

    resp := TRequest.New.BaseURL(BASE_URL)
                        .Resource('/usuarios/password')
                        .AddBody(json.ToJSON)
                        .Accept('application/json')
                        .TokenBearer(TSession.token)
                        .post;

    if resp.StatusCode <> 200 then
      raise Exception.Create(resp.Content);

  finally
    FreeAndNil(json);
  end;
end;

procedure TDmGlobal.ListarCategorias;
var
  resp: IResponse;
begin
  if TabCategoria.Active then
    TabCategoria.EmptyDataSet;

  TabCategoria.FieldDefs.Clear;

  resp := TRequest.New.BaseURL(BASE_URL)
                      .Resource('/categorias')
                      .Accept('application/json')
                      .TokenBearer(TSession.token)
                      .Adapters(TDataSetSerializeAdapter.New(TabCategoria))
                      .Get;

  if resp.StatusCode <> 200 then
    raise Exception.Create(resp.Content);

end;

procedure TDmGlobal.ListarCategoriaId(id_categoria: integer);
var
  resp: IResponse;
begin
  if TabCategoria.Active then
    TabCategoria.EmptyDataSet;

  TabCategoria.FieldDefs.Clear;

  resp := TRequest.New.BaseURL(BASE_URL)
                      .Resource('/categorias')
                      .ResourceSuffix(id_categoria.toString)
                      .Accept('application/json')
                      .TokenBearer(TSession.token)
                      .Adapters(TDataSetSerializeAdapter.New(TabCategoria))
                      .Get;

  if resp.StatusCode <> 200 then
    raise Exception.Create(resp.Content);

end;

procedure TDmGlobal.InserirCategoria(descricao: string);
var
  resp: IResponse;
  json: TJsonObject;
begin
  json := TJsonObject.Create;
  try
    json.AddPair('descricao', descricao);

    resp := TRequest.New.BaseURL(BASE_URL)
                        .Resource('/categorias')
                        .AddBody(json.ToJSON)
                        .Accept('application/json')
                        .TokenBearer(TSession.token)
                        .post;

    if resp.StatusCode <> 201 then
      raise Exception.Create(resp.Content);

  finally
    FreeAndNil(json);
  end;
end;

procedure TDmGlobal.EditarCategoria(id_categoria: integer; descricao: string);
var
  resp: IResponse;
  json: TJsonObject;
begin
  json := TJsonObject.Create;
  try
    json.AddPair('descricao', descricao);

    resp := TRequest.New.BaseURL(BASE_URL)
                        .Resource('/categorias')
                        .ResourceSuffix(id_categoria.tostring)
                        .AddBody(json.ToJSON)
                        .Accept('application/json')
                        .TokenBearer(TSession.token)
                        .put;

    if resp.StatusCode <> 200 then
      raise Exception.Create(resp.Content);

  finally
    FreeAndNil(json);
  end;
end;

procedure TDmGlobal.ExcluirCategoria(id_categoria: integer);
var
  resp: IResponse;
begin
  resp := TRequest.New.BaseURL(BASE_URL)
                      .Resource('/categorias')
                      .ResourceSuffix(id_categoria.tostring)
                      .Accept('application/json')
                      .TokenBearer(TSession.token)
                      .delete;

  if resp.StatusCode <> 200 then
    raise Exception.Create(resp.Content);

end;

function TDmGlobal.GerarURLCheckout(): string;
var
  resp: IResponse;
  json: TJsonObject;
begin
  if TabUsuario.Active then
    TabUsuario.EmptyDataSet;

  TabUsuario.FieldDefs.Clear;

  json := TJsonObject.Create;
  try
    json.AddPair('customer', TSession.stripe_cliente_id);

    resp := TRequest.New.BaseURL(BASE_URL)
                        .Resource('/assinaturas/url')
                        .AddBody(json.ToJSON)
                        .Accept('application/json')
                        .TokenBearer(TSession.token)
                        .Adapters(TDataSetSerializeAdapter.New(TabUsuario))
                        .post;

    if resp.StatusCode <> 200 then
      raise Exception.Create(resp.Content);

    Result := TabUsuario.FieldByName('url').AsString;

  finally
    FreeAndNil(json);
  end;
end;

procedure TDmGlobal.CancelarAssinatura;
var
  resp: IResponse;
  json: TJsonObject;
begin
  json := TJsonObject.Create;
  try
    json.AddPair('stripe_assinatura_id', TSession.stripe_assinatura_id);

    resp := TRequest.New.BaseURL(BASE_URL)
                        .Resource('/assinaturas/cancelamento')
                        .AddBody(json.ToJSON)
                        .Accept('application/json')
                        .TokenBearer(TSession.token)
                        .post;

    if resp.StatusCode <> 200 then
      raise Exception.Create(resp.Content);

  finally
    FreeAndNil(json);
  end;
end;

procedure TDmGlobal.InserirUsuarioLocal(id_usuario: integer;
                                        nome, email, senha, token, status,
                                        stripe_cliente_id, stripe_assinatura_id: string);
begin
    qryUsuario.Active := false;
    qryUsuario.SQL.Clear;
    qryUsuario.SQL.Add('insert into usuario(id_usuario, nome, email, senha, token, status, stripe_cliente_id, stripe_assinatura_id)');
    qryUsuario.SQL.Add('values(:id_usuario, :nome, :email, :senha, :token, :status, :stripe_cliente_id, :stripe_assinatura_id)');
    qryUsuario.ParamByName('id_usuario').Value := id_usuario;
    qryUsuario.ParamByName('nome').Value := nome;
    qryUsuario.ParamByName('email').Value := email;
    qryUsuario.ParamByName('senha').Value := senha;
    qryUsuario.ParamByName('token').Value := token;
    qryUsuario.ParamByName('status').Value := status;
    qryUsuario.ParamByName('stripe_cliente_id').Value := stripe_cliente_id;
    qryUsuario.ParamByName('stripe_assinatura_id').Value := stripe_assinatura_id;
    qryUsuario.ExecSQL;
end;

procedure TDmGlobal.ListarUsuarioLocal;
begin
    qryUsuario.Active := false;
    qryUsuario.SQL.Clear;
    qryUsuario.SQL.Add('select * from usuario');
    qryUsuario.active := true;
end;

procedure TDmGlobal.ExcluirUsuarioLocal;
begin
    qryUsuario.Active := false;
    qryUsuario.SQL.Clear;
    qryUsuario.SQL.Add('delete from usuario');
    qryUsuario.ExecSQL;
end;


end.
