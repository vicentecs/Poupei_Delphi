unit Controllers.Stripe;

interface

uses Horse,
     Horse.JWT,
     System.SysUtils,
     System.JSON,
     Controllers.JWT,
     uStripe;

procedure RegistrarRotas;
procedure CriarCheckoutSession(Req: THorseRequest; Res: THorseResponse; Next: TProc);

Const
  SecretKeyStripe = '???????????';

implementation

procedure RegistrarRotas;
begin
  THorse.AddCallback(HorseJWT(Controllers.JWT.SECRET,
                     THorseJWTConfig.New.SessionClass(TMyClaims)))
        .post('/assinaturas/url', CriarCheckoutSession);

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
                                         cancel_url, customer);

    Res.Send('{"url": "' + url + '"}');

  except on ex:exception do
    Res.Send(ex.Message).Status(500);
  end;
end;

end.

