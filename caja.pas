unit caja;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, Buttons, ExtCtrls,
  DBGrids, StdCtrls, ZDataset, JLabeledDateEdit, JLabeledFloatEdit;

type

  { Tf_caja }

  Tf_caja = class(TForm)
    b_loc: TBitBtn;
    ck_cero: TCheckBox;
    data: TDataSource;
    Label1: TLabel;
    can: TLabel;
    lista: TDBGrid;
    fd: TJLabeledDateEdit;
    fh: TJLabeledDateEdit;
    Shape1: TShape;
    tcaja: TJLabeledFloatEdit;
    qexe: TZQuery;
    procedure b_locClick(Sender: TObject);
  private

  public

  end;

var
  f_caja: Tf_caja;

implementation

{$R *.lfm}

{ Tf_caja }

procedure Tf_caja.b_locClick(Sender: TObject);
var
  total: real;
  no_cero: string;
begin
  if (fd.Value <> 0) and (fh.Value <> 0) then
  begin
    if ck_cero.Checked then no_cero:= ' AND caja<>0 '
    else no_cero:= ' ';
    // -- SQL
    qexe.Close;
    qexe.SQL.Text:= 'SELECT * FROM juegos '+
    'WHERE fec BETWEEN :FD AND :FH'+no_cero+'ORDER BY fec DESC';
    qexe.ParamByName('FD').AsDate:= fd.Value;
    qexe.ParamByName('FH').AsDate:= fh.Value;
    qexe.Open;
    can.Caption:= inttostr(qexe.RecordCount);
    total:= 0;
    if not qexe.IsEmpty then
    begin
      while not qexe.EOF do
      begin
        total:= total + qexe.FieldByName('caja').Value;
       qexe.Next;
      end;
      qexe.First;
    end;
    tcaja.Value:= total;
    // -----------
  end else
    showmessage('Debe llenar los datos de fechas!');;
end;

end.

