unit uSession;

interface

type
  TSession = class
  private
    class var Ftoken: string;
    class var Femail: string;
    class var Fnome: string;
    class var Fid_usuario: integer;
    class var Fstatus: string;
    class var Fstripe_cliente_id: string;
    class var Fstripe_assinatura_id: string;
  public
    class property id_usuario: integer read Fid_usuario write Fid_usuario;
    class property nome: string read Fnome write Fnome;
    class property email: string read Femail write Femail;
    class property token: string read Ftoken write Ftoken;
    class property status: string read Fstatus write Fstatus;
    class property stripe_cliente_id: string read Fstripe_cliente_id write Fstripe_cliente_id;
    class property stripe_assinatura_id: string read Fstripe_assinatura_id write Fstripe_assinatura_id;
  end;

implementation

end.
