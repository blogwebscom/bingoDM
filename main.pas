unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, Buttons,
  DBGrids, Grids, StdCtrls, ExtCtrls, JLabeledIntegerEdit, JLabeledFloatEdit,
  JLabeledDateEdit, ZConnection, ZDataset, Math, MMSystem, LCLIntf, caja;

type

  { Tf_main }

  Tf_main = class(TForm)
    b_cgen: TBitBtn;
    b_vcaj: TBitBtn;
    b_lin: TBitBtn;
    b_ok: TBitBtn;
    b_close: TBitBtn;
    b_bola: TBitBtn;
    b_ini: TBitBtn;
    b_bin: TBitBtn;
    ck_caj: TCheckBox;
    ck_grab: TCheckBox;
    ck_db: TCheckBox;
    ck_voz: TCheckBox;
    idb3: TLabel;
    grilla: TStringGrid;
    bola: TLabel;
    idb: TLabel;
    cb: TLabel;
    idb1: TLabel;
    bg_bola: TImage;
    idb2: TLabel;
    idb4: TLabel;
    img_icon: TImageList;
    fec: TJLabeledDateEdit;
    pl: TLabel;
    ncar: TJLabeledIntegerEdit;
    pcaja: TJLabeledIntegerEdit;
    pb: TLabel;
    pl1: TLabel;
    pl2: TLabel;
    Shape4: TShape;
    snro: TJLabeledIntegerEdit;
    Shape2: TShape;
    Shape3: TShape;
    trec: TJLabeledFloatEdit;
    plin: TJLabeledIntegerEdit;
    orden: TLabeledEdit;
    pbin: TJLabeledIntegerEdit;
    qsorteo: TZQuery;
    bord_bol: TShape;
    conex: TZConnection;
    qexe: TZQuery;
    tlin: TJLabeledFloatEdit;
    tbin: TJLabeledFloatEdit;
    vcar: TJLabeledFloatEdit;
    tcaja: TJLabeledFloatEdit;
    procedure b_binClick(Sender: TObject);
    procedure b_cgenClick(Sender: TObject);
    procedure b_closeClick(Sender: TObject);
    procedure b_iniClick(Sender: TObject);
    procedure b_linClick(Sender: TObject);
    procedure b_okClick(Sender: TObject);
    procedure b_bolaClick(Sender: TObject);
    procedure b_vcajClick(Sender: TObject);
    procedure ck_cajChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ncarExit(Sender: TObject);
    procedure pbinClick(Sender: TObject);
    procedure pbinEnter(Sender: TObject);
    procedure plinClick(Sender: TObject);
    procedure plinEnter(Sender: TObject);
    procedure trecExit(Sender: TObject);
  private
    procedure tira_bola();
    procedure voz_bola();
    procedure nuevo_juego();
    procedure graba_juego();
    procedure graba_bola();
    procedure vacia_temp();

  public

  end;

var {variables globales}
  f_main: Tf_main;
  i, n, col, fil: byte;
  dir, bgc, ncol, voz: string;
  segs, glin, gbin: integer;

implementation

{$R *.lfm}

{ Tf_main }

procedure Tf_main.FormActivate(Sender: TObject);
begin
  // Conecta con la B.D.
  f_main.conex.LibLocation:= ExtractFilePath(Application.EXEName)+'db\sqlite3.dll';
  f_main.conex.Database:= ExtractFilePath(Application.EXEName)+'db\bingo.db';
  try
    f_main.conex.Connect;
    ck_db.Checked:= true;
    b_ini.SetFocus;
  except
    showmessage('Error! No se pudo conectar con la Base de Datos!');
    ck_db.Checked:= false;
  end;
end;

procedure Tf_main.tira_bola();
var
  otra: char;
  sn: string; // fix string para pantallas.
begin
  n:= RandomRange(1,91); {primera}
  //showmessage('Control, se tira una bola > '+inttostr(n));
  // ----- no es un ciclo automatico!
  if i <= 90 then {90 bolas}
  begin
    otra:= 'S'; // para continuar o no
    if b_bola.Caption <> 'Siguiente' then b_bola.Caption:= 'Siguiente'; // va cambiando!
    while otra = 'S' do
    begin
      // Buscamos repetido
      qexe.Close;
      qexe.SQL.Text:= 'SELECT bola FROM temp WHERE bola=:B';
      qexe.ParamByName('B').AsInteger:= n;
      qexe.Open;
      // Grabamos la Bola
      if qexe.IsEmpty then
      begin
        //showmessage('Ok bola no repetida, queda');
        if n < 10 then sn:= '0'+ inttostr(n)
        else sn:= inttostr(n);
        orden.Caption:= orden.Caption + '('+sn+') ';
        orden.SelStart:= Length(orden.Text); {se va hacia el final!}
        // Guardamos en la tabla Temp -------//
        qexe.Close;
        qexe.SQL.Text:= 'INSERT INTO temp(nro,bola) VALUES(:N,:B)';
        qexe.ParamByName('N').AsInteger:= i;
        qexe.ParamByName('B').AsInteger:= n;
        qexe.ExecSQL;
        // Mostramos Datos ----------------- //
        bg_bola.Picture.LoadFromFile(dir+'img\'+bgc);
        bola.Caption:= inttostr(n);
        cb.Caption:= inttostr(strtoint(cb.Caption) + 1);
        // Color de la bola ----------------- //
        if bgc = 'b_rojo_200.png' then bgc:= 'b_azul_200.png' else
          if bgc = 'b_azul_200.png' then bgc:= 'b_verde_200.png' else
            if bgc = 'b_verde_200.png' then bgc:= 'b_rojo_200.png';
        // Sonido de VOZ ----------------- //
        if ck_voz.Checked then voz_bola();
        // ------- pantalla de Bolas ------- //
        // Posicion..... FILA
        case n of
         1..10: fil:= 0;
         11..20: fil:= 1;
         21..30: fil:= 2;
         31..40: fil:= 3;
         41..50: fil:= 4;
         51..60: fil:= 5;
         61..70: fil:= 6;
         71..80: fil:= 7;
         81..90: fil:= 8;
        end;
        // Posicion..... COLUMNA
        ncol:= Copy(inttostr(n),length(inttostr(n)),1);
        case ncol of
         '1': col:= 0;
         '2': col:= 1;
         '3': col:= 2;
         '4': col:= 3;
         '5': col:= 4;
         '6': col:= 5;
         '7': col:= 6;
         '8': col:= 7;
         '9': col:= 8;
         '0': col:= 9;
        end;
        grilla.Cells[col, fil]:= sn;
        // ------- pantalla de Bolas ------- //
        if col < 9 then inc(col)
        else begin
          col:= 0;
          inc(fil);
        end;
        // ------- Otras Acciones ------- //
        otra:= 'N'; // sale del bucle
        inc(i);
        if i = 6 then b_lin.Enabled:= true;
        if i = 16 then b_bin.Enabled:= true;
        Application.ProcessMessages;
      end else begin
        //showmessage('Tiramos de nuevo!');
        n:= RandomRange(1,91); // tira de nuevo
      end;
      //----------------------
    end;
  end else begin
    showmessage('Se han tirado las 90 Bolas!'+#13+'Juego Finalizado.');
    b_ini.Enabled:= true;
    b_bola.Enabled:= false;
    b_ini.SetFocus;
  end;
end;

procedure Tf_main.b_iniClick(Sender: TObject);
begin
  // Vaciamos la Tabla Temporal!
  vacia_temp();
  // ----- Iniciales ------ //
  tlin.Value:= 0; tbin.Value:= 0;
  vcar.Value:= 0; ncar.Value:= 0;
  trec.Value:= 0; grilla.Clean;
  nuevo_juego();
  fec.Value:= date();
  dir:= ExtractFilePath(Application.EXEName);
  Randomize; // reinici el random
  i:= 1; col:= 0; fil:= 0;
  orden.Caption:= '';
  bgc:= 'b_rojo_200.png';
  // Habilitaciones
  b_ini.Enabled:= false; b_ok.Enabled:= true; ck_caj.Enabled:= true;
  plin.Enabled:= true; pbin.Enabled:= true; pcaja.Enabled:= true;
  fec.Enabled:= true; vcar.Enabled:= true; ncar.Enabled:= true;
  b_vcaj.Enabled:= false; b_cgen.Enabled:= true;
  pl.Visible:= false; pb.Visible:= false;
  pl.Caption:= '[Jugando]';
  pb.Caption:= '[Jugando]';
  vcar.SetFocus;
  //showmessage('Indique el Total Recaudado para obtener los Premios');
end;

procedure Tf_main.b_linClick(Sender: TObject);
begin
  // Aviso de PREMIO DE LINEA
  if ck_voz.Checked then sndPlaySound(PChar(dir+'son\hay_linea.wav'), snd_Async or snd_NoDefault);
  if MessageDlg('Se ha cantado LINEA!', 'Se confirma el premio ?',mtConfirmation,[mbYes, mbNo],0) = mrYes then
  begin
    // Determina en que bola salio la linea para grabar juego en la BD
    glin:= strtoint(cb.Caption);
    pl.Caption:= '[Confirmado]';
    if ck_voz.Checked then
    begin
      sndPlaySound(PChar(dir+'son\confirma_linea.wav'), snd_Async or snd_NoDefault);
      sleep(2000);
    end;
    if ck_voz.Checked then sndPlaySound(PChar(dir+'son\sigue_bingo.wav'), snd_Async or snd_NoDefault);
    b_lin.Enabled:= false;
    b_bin.Enabled:= true;
    b_bola.SetFocus;
  end else
    if ck_voz.Checked then sndPlaySound(PChar(dir+'son\no_gana.wav'), snd_Async or snd_NoDefault);
end;

procedure Tf_main.b_binClick(Sender: TObject);
begin
  // Aviso de PREMIO DE BINGO
  if ck_voz.Checked then sndPlaySound(PChar(dir+'son\hay_bingo.wav'), snd_Async or snd_NoDefault);
  if MessageDlg('Se ha cantado BINGO!', 'Se confirma el premio ?',mtConfirmation,[mbYes, mbNo],0) = mrYes then
  begin
    // Determina en que bola salio el bingo para grabar juego en la BD
    gbin:= strtoint(cb.Caption);
    pb.Caption:= '[Confirmado]';
    if ck_voz.Checked then
    begin
      sndPlaySound(PChar(dir+'son\confirma_bingo.wav'), snd_Async or snd_NoDefault);
      sleep(2000);
    end;
    if ck_voz.Checked then sndPlaySound(PChar(dir+'son\finalizado.wav'), snd_Async or snd_NoDefault);
    // GRABA EL JUEGO EN LA B.D.
    if ck_grab.Checked then
    begin
      graba_juego();
      graba_bola();
    end;
    // Des-Habilita
    b_ini.Enabled:= true; b_bola.Enabled:= false;
    b_bin.Enabled:= false; b_vcaj.Enabled:= true;
  end else
    if ck_voz.Checked then sndPlaySound(PChar(dir+'son\no_gana.wav'), snd_Async or snd_NoDefault);
end;

procedure Tf_main.b_cgenClick(Sender: TObject);
begin
  showmessage('Por el momento se va abrir un enlace externo.');
  OpenURL('https://www.bingo.es/cartones-bingo/');
end;

procedure Tf_main.b_bolaClick(Sender: TObject);
begin
  // Aviso de comienzo
  if b_bola.Caption = '1ra Bola!' then // Solo ocurre la primera bola!
  begin
    if ck_voz.Checked then
    begin
      sndPlaySound(PChar(dir+'son\comenzamos.wav'), snd_Async or snd_NoDefault);
      sleep(4000); {necesario para que se escuche}
    end else
      showmessage('Presione Aceptar y el Juego del BINGO comienza,'+#13+'Esperando...');
  end;
  tira_bola();
end;

procedure Tf_main.b_vcajClick(Sender: TObject);
begin
  f_caja:= Tf_caja.Create(Self);
  f_caja.ShowModal;
end;

procedure Tf_main.ck_cajChange(Sender: TObject);
begin
  if ck_caj.Checked then
  begin
    pcaja.Value:= 0;
    pcaja.Enabled:= false;
    plin.SetFocus;
  end else begin
    pcaja.Enabled:= true;
    pcaja.SetFocus;
  end;
  showmessage('Redetermine los Porcentajes de Linea/Bingo');
end;

procedure Tf_main.b_okClick(Sender: TObject);
begin
  if (pcaja.Value + plin.Value + pbin.Value) > 100 then
  begin
    showmessage('La suma de los 3 porcentajes es superior a 100,'+#13+
    'Revise los datos e Intente nuevamente!');
    plin.SetFocus;
  end else begin
    // Total Linea
    tlin.Value:= trec.Value * (plin.Value/100);
    // Total Bingo
    tbin.Value:= trec.Value * (pbin.Value/100);
    // Total CAJA
    tcaja.Value:= trec.Value - tlin.Value - tbin.Value;
    // Ok, activamos el comienzo del sorteo...
    pl.Visible:= true; pb.Visible:= true;
    plin.Enabled:= false; pbin.Enabled:= false; pcaja.Enabled:= false;
    fec.Enabled:= false; vcar.Enabled:= false; ncar.Enabled:= false;
    trec.Enabled:= false; b_cgen.Enabled:= false;
    b_ok.Enabled:= false; b_bola.Enabled:= true; b_bola.SetFocus;
  end;
end;

procedure Tf_main.graba_juego();
begin
  qexe.Close;
  qexe.SQL.Text:= 'INSERT INTO juegos(fec,cartones,bolas,linea,bingo,caja,trec,lgana,bgana) '+
  'VALUES(:FE,:CA,:BO,:LI,:BI,:PC,:TR,:GL,:GB)';
  qexe.ParamByName('FE').AsDate:= fec.Value;
  qexe.ParamByName('CA').AsInteger:= ncar.Value;
  qexe.ParamByName('BO').AsInteger:= strtoint(cb.Caption);
  qexe.ParamByName('LI').AsFloat:= tlin.Value;
  qexe.ParamByName('BI').AsFloat:= tbin.Value;
  qexe.ParamByName('PC').AsFloat:= tcaja.Value;
  qexe.ParamByName('TR').AsFloat:= trec.Value;
  qexe.ParamByName('GL').AsInteger:= glin; //global
  qexe.ParamByName('GB').AsInteger:= gbin; //global
  qexe.ExecSQL;
end;

procedure Tf_main.graba_bola();
begin
  qsorteo.Close;
  qsorteo.SQL.Text:= 'SELECT * FROM temp';
  qsorteo.Open;
  while not qsorteo.EOF do
  begin
    qexe.Close;
    qexe.SQL.Text:= 'INSERT INTO sorteos(id_ju,nro,bola) VALUES(:IJ,:NR,:BO)';
    qexe.ParamByName('IJ').AsInteger:= snro.Value;
    qexe.ParamByName('NR').AsInteger:= qsorteo.FieldByName('nro').Value; // numero orden
    qexe.ParamByName('BO').AsInteger:= qsorteo.FieldByName('bola').Value; // numero de bola
    qexe.ExecSQL;
   qsorteo.Next;
  end;
  vacia_temp();
end;

procedure Tf_main.vacia_temp();
begin
  qexe.Close;
  qexe.SQL.Text:= 'DELETE FROM temp';
  qexe.ExecSQL;
end;

procedure Tf_main.voz_bola();
begin
  case n of
   1: voz:= 'son\1.wav'; 2: voz:= 'son\2.wav'; 3: voz:= 'son\3.wav'; 4: voz:= 'son\4.wav'; 5: voz:= 'son\5.wav';
   6: voz:= 'son\6.wav'; 7: voz:= 'son\7.wav'; 8: voz:= 'son\8.wav'; 9: voz:= 'son\9.wav'; 10: voz:= 'son\10.wav';
   11: voz:= 'son\11.wav'; 12: voz:= 'son\12.wav'; 13: voz:= 'son\13.wav'; 14: voz:= 'son\14.wav'; 15: voz:= 'son\15.wav';
   16: voz:= 'son\16.wav'; 17: voz:= 'son\17.wav'; 18: voz:= 'son\18.wav'; 19: voz:= 'son\19.wav'; 20: voz:= 'son\20.wav';
   21: voz:= 'son\21.wav'; 22: voz:= 'son\22.wav'; 23: voz:= 'son\23.wav'; 24: voz:= 'son\24.wav'; 25: voz:= 'son\25.wav';
   26: voz:= 'son\26.wav'; 27: voz:= 'son\27.wav'; 28: voz:= 'son\28.wav'; 29: voz:= 'son\29.wav'; 30: voz:= 'son\30.wav';
   31: voz:= 'son\31.wav'; 32: voz:= 'son\32.wav'; 33: voz:= 'son\33.wav'; 34: voz:= 'son\34.wav'; 35: voz:= 'son\35.wav';
   36: voz:= 'son\36.wav'; 37: voz:= 'son\37.wav'; 38: voz:= 'son\38.wav'; 39: voz:= 'son\39.wav'; 40: voz:= 'son\40.wav';
   41: voz:= 'son\41.wav'; 42: voz:= 'son\42.wav'; 43: voz:= 'son\43.wav'; 44: voz:= 'son\44.wav'; 45: voz:= 'son\45.wav';
   46: voz:= 'son\46.wav'; 47: voz:= 'son\47.wav'; 48: voz:= 'son\48.wav'; 49: voz:= 'son\49.wav'; 50: voz:= 'son\50.wav';
   51: voz:= 'son\51.wav'; 52: voz:= 'son\52.wav'; 53: voz:= 'son\53.wav'; 54: voz:= 'son\54.wav'; 55: voz:= 'son\55.wav';
   56: voz:= 'son\56.wav'; 57: voz:= 'son\57.wav'; 58: voz:= 'son\58.wav'; 59: voz:= 'son\59.wav'; 60: voz:= 'son\60.wav';
   61: voz:= 'son\61.wav'; 62: voz:= 'son\62.wav'; 63: voz:= 'son\63.wav'; 64: voz:= 'son\64.wav'; 65: voz:= 'son\65.wav';
   66: voz:= 'son\66.wav'; 67: voz:= 'son\67.wav'; 68: voz:= 'son\68.wav'; 69: voz:= 'son\69.wav'; 70: voz:= 'son\70.wav';
   71: voz:= 'son\71.wav'; 72: voz:= 'son\72.wav'; 73: voz:= 'son\73.wav'; 74: voz:= 'son\74.wav'; 75: voz:= 'son\75.wav';
   76: voz:= 'son\76.wav'; 77: voz:= 'son\77.wav'; 78: voz:= 'son\78.wav'; 79: voz:= 'son\79.wav'; 80: voz:= 'son\80.wav';
   81: voz:= 'son\81.wav'; 82: voz:= 'son\82.wav'; 83: voz:= 'son\83.wav'; 84: voz:= 'son\84.wav'; 85: voz:= 'son\85.wav';
   86: voz:= 'son\86.wav'; 87: voz:= 'son\87.wav'; 88: voz:= 'son\88.wav'; 89: voz:= 'son\89.wav'; 90: voz:= 'son\90.wav';
  end;
  sndPlaySound(PChar(dir+voz), snd_Async or snd_NoDefault);
end;

procedure Tf_main.nuevo_juego();
begin
  qexe.Active:= false;
  qexe.SQL.Text:= 'SELECT MAX(id_ju) AS ULT FROM juegos';
  qexe.Open;
  if qexe.FieldByName('ULT').Value = Null then snro.Value:= 1
  else snro.Value:= qexe.FieldByName('ULT').Value + 1;
end;

procedure Tf_main.ncarExit(Sender: TObject);
begin
  trec.Value:= vcar.Value * ncar.CurrentValue;
end;

procedure Tf_main.pbinClick(Sender: TObject);
begin
  pbin.SelectAll;
end;

procedure Tf_main.pbinEnter(Sender: TObject);
begin
  pbin.SelectAll;
end;

procedure Tf_main.plinClick(Sender: TObject);
begin
  plin.SelectAll;
end;

procedure Tf_main.plinEnter(Sender: TObject);
begin
  plin.SelectAll;
end;

procedure Tf_main.trecExit(Sender: TObject);
begin
  b_ok.SetFocus;
end;

procedure Tf_main.b_closeClick(Sender: TObject);
begin
  close();
end;

end.

