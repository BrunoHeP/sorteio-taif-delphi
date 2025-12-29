object dmConexao: TdmConexao
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 261
  Width = 328
  object Conn: TFDConnection
    ConnectionName = 'Firebird'
    Params.Strings = (
      'Password=masterkey'
      
        'Database=C:\Users\Kenps\Documents\Embarcadero\Studio\Projects\So' +
        'rteioTaif\SORTEIO_TAIF.FDB'
      'User_Name=SYSDBA'
      'DriverID=FB'
      'CharacterSet=UTF8'
      'SQLDialect=3')
    Left = 64
    Top = 32
  end
  object ExecutarConsulta: TFDQuery
    ConnectionName = 'Firebird'
    Left = 64
    Top = 104
  end
  object ExecutaComando: TFDQuery
    ConnectionName = 'Firebird'
    Left = 64
    Top = 168
  end
  object dsConsulta: TDataSource
    DataSet = ExecutarConsulta
    Left = 192
    Top = 32
  end
end
