unit uFunctions;

interface

uses System.DateUtils, FMX.ListBox, FireDAC.Comp.Client,
     FireDAC.DApt, System.SysUtils;

function UTCtoDateBR(dt: string): string;
function UTCtoShortDateBR(dt: string): string;
function MonthDescription(Data: TDate): string;
procedure MontaCombo(cmb: TCombobox; Tab: TFDMemTable;
                     field_id, field_descr: string;
                     ind_todos: boolean);
procedure ComboSelecionarById(cmb: TComboBox; id: integer);
function ComboGetId(cmb: TComboBox): integer;
function ShortStringUTCToDate(str: string): TDate;

implementation

function UTCtoDateBR(dt: string): string;
begin
    // 2022-05-05 15:23:52.000
    Result := Copy(dt, 9, 2) + '/' + Copy(dt, 6, 2) + '/' + Copy(dt, 1, 4) + ' ' + Copy(dt, 12, 8);
end;

function UTCtoShortDateBR(dt: string): string;
begin
    // 2025-05-25  -->  25/05/2025
    Result := Copy(dt, 9, 2) + '/' + Copy(dt, 6, 2) + '/' + Copy(dt, 1, 4);
end;

function MonthDescription(Data: TDate): string;
const
  Meses: array[1..12] of string = (
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
  );
begin
  Result := Meses[MonthOf(Data)];
end;

procedure MontaCombo(cmb: TCombobox; Tab: TFDMemTable;
                     field_id, field_descr: string;
                     ind_todos: boolean);
begin
  cmb.Items.Clear;

  if ind_todos then
    cmb.Items.AddObject('Todos', TObject(0));

  while NOT Tab.Eof do
  begin
    cmb.Items.AddObject(Tab.FieldByName(field_descr).AsString,
                        TObject(Tab.FieldByName(field_id).AsInteger));
    Tab.Next;
  end;

  cmb.ItemIndex := 0;

end;

procedure ComboSelecionarById(cmb: TComboBox; id: integer);
var
  i: integer;
begin
  for i := 0 to cmb.Items.Count - 1 do
  begin
    if Integer(cmb.Items.Objects[i]) = id then
    begin
      cmb.ItemIndex := i;
      exit;
    end;
  end;
end;

function ComboGetId(cmb: TComboBox): integer;
begin
  try
    Result := Integer(cmb.Items.Objects[cmb.ItemIndex])
  except
    Result := 0;
  end;

end;

// Formato: 2021-10-09  -->  Date
function ShortStringUTCToDate(str: string): TDate;
var
    ano, mes, dia: integer;
begin
    try
        ano := StrToint(Copy(str, 1, 4));
        mes := StrToint(Copy(str, 6, 2));
        dia := StrToint(Copy(str, 9, 2));

        Result := EncodeDateTime(ano, mes, dia, 0, 0, 0, 0);
    except
        Result := 0;
    end;
end;


end.
