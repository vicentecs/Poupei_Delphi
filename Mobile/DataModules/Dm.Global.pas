unit Dm.Global;

interface

uses
  System.SysUtils, System.Classes, RESTRequest4D,
  DataSet.Serialize.Adapter.RESTRequest4D,
  DataSet.Serialize.Config, System.JSON, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  uSession;

type
  TDmGlobal = class(TDataModule)
    TabUsuario: TFDMemTable;
    TabLanc: TFDMemTable;
    TabCategoria: TFDMemTable;
    procedure DataModuleCreate(Sender: TObject);
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
  end;

var
  DmGlobal: TDmGlobal;

Const
  BASE_URL = 'http://localhost:3001';

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDmGlobal.DataModuleCreate(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;
  TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator := '.';
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
    json.AddPair('valor', valor);
    json.AddPair('id_categoria', id_categoria);

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

end.
