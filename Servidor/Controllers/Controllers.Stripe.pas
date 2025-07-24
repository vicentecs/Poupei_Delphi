unit Controllers.Stripe;

interface

uses Horse,
     Horse.JWT,
     System.SysUtils,
     System.JSON,
     Controllers.JWT,
     uStripe,
     Services.Stripe;

procedure RegistrarRotas;
procedure CriarCheckoutSession(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure WebhookStripe(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure CancelarAssinatura(Req: THorseRequest; Res: THorseResponse; Next: TProc);

Const
  SecretKeyStripe = '';

implementation

uses UnitPrincipal;

procedure RegistrarRotas;
begin
  THorse.AddCallback(HorseJWT(Controllers.JWT.SECRET,
                     THorseJWTConfig.New.SessionClass(TMyClaims)))
        .post('/assinaturas/url', CriarCheckoutSession);

  THorse.AddCallback(HorseJWT(Controllers.JWT.SECRET,
                     THorseJWTConfig.New.SessionClass(TMyClaims)))
        .post('/assinaturas/cancelamento', CancelarAssinatura);

  THorse.post('/webhook/stripe', WebhookStripe);
end;

procedure CriarCheckoutSession(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  secret_key, price_id, success_uRL, cancel_url, url, customer: string;
  id_usuario: integer;
  body: TJsonObject;
begin

  price_id := 'price_1RnpkaGIxmEKMVIq9OWO80wL';
  success_url := 'https://99club.alpaclass.com/';
  cancel_url := 'http://www.99coders.com.br/';

  try
    body := Req.Body<TJSONObject>;
    customer := body.GetValue<string>('customer', '');
    id_usuario := Get_Usuario_Request(Req);

    url := TStripe.CreateCheckoutSession(SecretKeyStripe, price_id, success_url,
                                         cancel_url, customer, id_usuario);

    Res.Send('{"url": "' + url + '"}');

  except on ex:exception do
    Res.Send(ex.Message).Status(500);
  end;
end;

procedure CancelarAssinatura(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  id_usuario: integer;
  stripe_assinatura_id: string;
  body: TJSONObject;
begin
  try
    body := Req.Body<TJSONObject>;

    stripe_assinatura_id := body.GetValue<string>('stripe_assinatura_id', '');
    id_usuario := Get_Usuario_Request(Req);


    TStripe.CancelarAssinaturaFinalPeriodo(SecretKeyStripe, stripe_assinatura_id);

    Services.Stripe.CancelarAssinatura(id_usuario);

    Res.Status(200).Send('Assinatura cancelada com sucesso')

  except on ex:exception do
    Res.Send(ex.Message).Status(500);
  end;

end;

procedure WebhookAssinaturaCriada(json: TJSONObject);
var
  DataObj, ObjectObj, PlanObj, MetadataObj : TJSONObject;
  StripeCustomerID, StripeAssinaturaID: string;
  VlAssinatura: double;
  id_usuario: integer;
begin
   // Campo             Caminho no JSON
  //----------------------------------------------------
  // id. cliente       data -> object -> customer
  // id. assinatura    data -> object -> id
  // valor do plano    data -> object -> plan -> amount
  // id. usuario       data -> object -> metadata -> id_usuario

  DataObj := json.GetValue<TJSONObject>('data');
  ObjectObj := DataObj.GetValue<TJSONObject>('object');
  PlanObj := ObjectObj.GetValue<TJSONObject>('plan');
  MetadataObj := ObjectObj.GetValue<TJSONObject>('metadata');

  StripeCustomerID := ObjectObj.GetValue<string>('customer', '');
  StripeAssinaturaID := ObjectObj.GetValue<string>('id', '');
  VlAssinatura := PlanObj.GetValue<double>('amount', 0) / 100;
  id_usuario := MetadataObj.GetValue<integer>('id_usuario', 0);

  Services.Stripe.WebhookAssinaturaCriada(id_usuario,
                                          StripeCustomerID,
                                          StripeAssinaturaID,
                                          VlAssinatura);

end;

procedure WebhookNovoPagamento(json: TJSONObject);
var
  ObjectObj: TJSONObject;
  StripeCustomerID: string;
begin
  // Campo             Caminho no JSON
  //----------------------------------------------------
  // id. cliente       data.object.customer

  ObjectObj  := json.GetValue<TJSONObject>('data')
                    .GetValue<TJSONObject>('object');

  StripeCustomerID := ObjectObj.GetValue<string>('customer', '');

  Services.Stripe.WebhookNovoPagamento(StripeCustomerID);

end;

procedure WebhookAssinaturaCancelada(json: TJSONObject);
var
  DataObj, ObjectObj : TJSONObject;
  StripeCustomerID, StripeAssinaturaID: string;
begin
  // Campo             Caminho no JSON
  //----------------------------------------------------
  // id. cliente       data -> object -> customer
  // id. assinatura    data -> object -> id

  //"cancel_at_period_end": true

  DataObj := json.GetValue<TJSONObject>('data');
  ObjectObj := DataObj.GetValue<TJSONObject>('object');

  StripeCustomerID := ObjectObj.GetValue<string>('customer', '');
  StripeAssinaturaID := ObjectObj.GetValue<string>('id', '');

  FrmPrincipal.Memo1.Lines.Add('****************************');
  FrmPrincipal.Memo1.Lines.Add(StripeCustomerID + ' - ' + StripeAssinaturaID);
  FrmPrincipal.Memo1.Lines.Add('****************************');

  //Services.Stripe.WebhookAssinaturaCancelada(StripeCustomerID, StripeAssinaturaID);
end;

procedure WebhookStripe(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  json_body: TJSONObject;
  event_type: string;
begin
  // Salvar log -> Req.body
  FrmPrincipal.Memo1.Lines.Add(Req.body);


  try
    json_body := Req.Body<TJSONObject>;
    try
      event_type := json_body.GetValue<string>('type', '');

      // Criacao de nova assinatura
      if event_type = 'customer.subscription.created' then
        WebhookAssinaturaCriada(json_body)

      // Novo pagamento
      else if event_type = 'invoice.paid' then
        WebhookNovoPagamento(json_body);

      // Novo pagamento
      //else if event_type = 'customer.subscription.deleted' then
      //  WebhookAssinaturaCancelada(json_body);

      Res.Send('OK');
    finally
      FreeAndNil(json_body);
    end;

  except on ex:exception do
    Res.Send(ex.Message).Status(500);
  end;


end;

end.

