object DmGlobal: TDmGlobal
  OnCreate = DataModuleCreate
  Height = 410
  Width = 546
  object Conn: TFDConnection
    Params.Strings = (
      'Database=D:\Poupei\Database\BANCO.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Protocol=TCPIP'
      'Server=127.0.0.1'
      'Port=3050'
      'DriverID=FB')
    LoginPrompt = False
    Left = 72
    Top = 64
  end
  object FDPhysFBDriverLink: TFDPhysFBDriverLink
    Left = 176
    Top = 64
  end
end
