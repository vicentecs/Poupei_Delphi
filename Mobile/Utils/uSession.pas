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
  public
    class property id_usuario: integer read Fid_usuario write Fid_usuario;
    class property nome: string read Fnome write Fnome;
    class property email: string read Femail write Femail;
    class property token: string read Ftoken write Ftoken;
    class property status: string read Fstatus write Fstatus;
  end;

implementation

end.
