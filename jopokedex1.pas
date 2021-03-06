unit jopokedex1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.strutils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtDlgs, Vcl.Imaging.pngimage,
  Button2;

type
  TformPokedex = class(TForm)
    eLP: TEdit;
    eNazwa: TEdit;
    Lista: TListView;
    bWczytaj: TButton;
    GatunekBox: TComboBox;
    bZapiszDoPliku: TButton;
    eSzukaj: TEdit;
    Nazwa: TEdit;
    bFiltr: TButton;
    bOdswiez: TButton;
    eDlugosc: TEdit;
    bDlugosc: TButton;
    Image1: TImage;
    pZastosuj: TPanel;
    LbFiltruj: TLabel;
    pUsun: TPanel;
    LbWszystko: TLabel;
    LbLP: TLabel;
    LbGatunek: TLabel;
    LbNazwa: TLabel;
    LbOdswiez: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    LbPomoc: TLabel;
    aaaa1: aaaa;
    Button5: TButton;
    Button6: TButton;
    procedure DodajDoListy(wLP : integer; wNazwa : string; wGatunek : string);
    procedure UsuwaniezPoczatku;
    procedure UsunWybrany;
    procedure WyswietlElement;
    procedure czyscEdit;
    function dlugosc : Integer;
    function Zamien(gatunek : integer) : WideString;
    procedure odswiez;
    procedure sortujLP;
    procedure sortujNazwa;
    procedure sortujGatunek;
    procedure ZapiszDoPliku;
    procedure bWczytajClick(Sender: TObject);
    procedure bZapiszDoPlikuClick(Sender: TObject);
    procedure eLPChange(Sender: TObject);
    procedure eNazwaChange(Sender: TObject);
    procedure eSzukajChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bUsuwaniePoczClick(Sender: TObject);
    procedure bUsunWybranyClick(Sender: TObject);
    procedure ListaColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListaClick(Sender: TObject);
    procedure Edycja;
    procedure filtruj;
    procedure bFiltrClick(Sender: TObject);
    procedure bOdswiezClick(Sender: TObject);
//    procedure bDlugoscClick(Sender: TObject);
    procedure pZastosujClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure pUsunClick(Sender: TObject);
    procedure sprawdzLP;
    procedure aaaa1Click(Sender: TObject);
    procedure aaaa1Enter(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);

 private
    { Private declarations }
 public
    { Public declarations }
 end;



type
  pElement = ^tElement;
  tElement = record
         next   : pElement;
         LP    : integer;
         nazwa : string;
         gatunek : string;
end;



var
  formPokedex: TformPokedex;

 first  :pElement;
 ident : HModule;
 sort : byte;
 filtr : byte;
 filtrc : boolean;
 istnieje : boolean;
 biezacy : integer;
 edytowany : boolean;


{
 function dlugoscc(first2:pelement):integer; stdcall external
        '\PROJEKT JoPokedex\joPokedex-DLL\Win32\Debug\joDLL.dll'
        name 'dlugoscc';

 function zamien(gatunek:integer):widestring; stdcall external
        '\PROJEKT JoPokedex\joPokedex-DLL\Win32\Debug\joDLL.dll'
        name 'Zamien';

 function pierwszy():pElement; stdcall external
        '\PROJEKT JoPokedex\joPokedex-DLL\Win32\Debug\joDLL.dll'
        name 'pierwszy';

procedure wyswietlelementt(var caption:integer; LP:integer; Nazwa:string; gatunek:string); stdcall external
        '\PROJEKT JoPokedex\joPokedex-DLL\Win32\Debug\joDLL.dll'
        name 'wyswietlelementt';

procedure dodajdolisty(var wLP: integer; wNazwa: string; wGatunek: string; first: pElement); stdcall external
        '\PROJEKT JoPokedex\joPokedex-DLL\Win32\Debug\joDLL.dll'
        name 'dodajdollisty';

procedure zapiszdoplliku; stdcall; external
        '\PROJEKT JoPokedex\joPokedex-DLL\Win32\Debug\joDLL.dll'
        name 'zapiszdoplliku';
                {(LP : Integer; Nazwa : String; Gatunek : String; first: pElement)}





implementation


{$R *.dfm}

function tformpokedex.Zamien(gatunek : integer) : WideString;
begin
case gatunek of
 1: result:='Grass';
 2: result:='Fire';
 3: result:='Water';
 4: result:='Bug';
 5: result:='Normal';
 6: result:='Fairy';
 7: result:='Poison';
 8: result:='Electric';
 9: result:='Ground';
 10: result:='Fighting';
 11: result:='Psychic';
 12: result:='Rock';
 13: result:='Ghost';
 14: result:='Mime';
 15: result:='Ice';
 16: result:='Dragon';
 else result:=' ';
 end;
end;


procedure TFormPokedex.edycja;
var
  edytowany : pElement;
begin
if Lista.SelCount<>1 then showmessage('Zaznacz element do edycji!')
else
  begin
  edytowany := first;
  while edytowany^.LP <> strtoint(lista.selected.caption) do
    begin
      edytowany := edytowany^.next;
    end;
    edytowany^.LP:=strtoint(eLP.text);
    edytowany^.Nazwa:=eNazwa.Text;
    edytowany^.Gatunek:=inttostr(GatunekBox.itemindex);
  end;
end;


procedure Tformpokedex.odswiez;
var
wsk: pElement;
element : TListItem;
begin
  wsk := first;
  if wsk=nil then
    showmessage('Lista nie posiada element�w!')
  else
    begin
      while wsk<>nil do
        begin
          element := Lista.Items.Add;
          element.Caption := inttostr(wsk^.LP);
          element.SubItems.Add(wsk^.nazwa);
          element.SubItems.Add(zamien(strtoint(wsk^.gatunek)));
          wsk := wsk^.next;
        end;
    end;
end;



procedure TformPokedex.pUsunClick(Sender: TObject);
begin
 UsunWybrany;
 filtruj;
 //czyscedit;
 zapiszdopliku;
end;

procedure TformPokedex.pZastosujClick(Sender: TObject);
begin

if eLP.text='' then
  showmessage('wprowad� dane!(LP)')
else if eNazwa.Text='' then
  showmessage('wprowad� dane!(nazwa)')
else if gatunekbox.itemindex=0 then
  showmessage('wprowad� dane!(gatunek)')
else
  begin
    sprawdzLP;
    if istnieje = true then
      showmessage('Pokemon o podanym LP ju� istnieje!')
    else
      begin
        if Lista.SelCount<>1 then
            DodajDoListy(strtoint(eLP.text),
              (eNazwa.Text),
              IntToStr(gatunekbox.itemindex))
        else
          begin
            edycja;
            filtruj;
          end;
        czyscedit;
        if sort=1 then
          sortujLP
        else if sort=2 then
          sortujnazwa
        else sortujgatunek;
      end;
  end;
  filtruj;
  biezacy:=333;
  zapiszdopliku;

end;

procedure TFormPokedex.sprawdzLP;
var
  LP : integer;
  wsk : pElement;

begin
istnieje := false;

if Lista.SelCount<>0 then
  edytowany:=true
else edytowany:= false;

LP := strtoint(eLP.Text);
wsk := first;


  while wsk<>nil do
    begin
      //
      if (LP <> wsk^.LP) or ( (biezacy = LP) and (edytowany = true) ) then
        wsk:= wsk^.next
      else
        begin
          istnieje := true;
          break;
        end;
    end;
end;

procedure TformPokedex.filtruj;
var
wsk: pElement;
element : TListItem;
wyswietl : boolean;
nic : boolean;
begin
nic:=true;
Lista.Clear;
  wsk := first;
  if wsk=nil then
    begin
      showmessage('lista jest pusta!');
      odswiez;
    end;
  while wsk<>nil do
    begin
    wyswietl:=true;
    if eSzukaj.text <> '' then
      begin
        if filtr=1 then
          wyswietl:= AnsiContainsText(inttostr(wsk^.LP),eSzukaj.text)
        else if filtr=2 then
          wyswietl:= AnsiContainsText(wsk^.Nazwa,eSzukaj.text)
        else if filtr=3 then
          wyswietl:= AnsiContainsText(zamien(strtoint(wsk^.gatunek)),eSzukaj.text)
        else if filtr=0 then
          wyswietl:= AnsiContainsText(inttostr(wsk^.LP),eSzukaj.text) or
                     AnsiContainsText(wsk^.Nazwa,eSzukaj.text) or
                     AnsiContainsText(zamien(strtoint(wsk^.gatunek)),eSzukaj.text)
      end
      else
        begin
          if filtrc=true then

          showmessage('wpisz co�!');
          nic:=false;
          odswiez;
          break;
        end;
    if wyswietl=true then
      begin
        element := Lista.Items.Add;
        element.Caption := inttostr(wsk^.LP);
        element.SubItems.Add(wsk^.nazwa);
        element.SubItems.Add(zamien(strtoint(wsk^.gatunek)));
        nic:=false;
      end;
      wsk := wsk^.next

    end;

    if nic=true then
    begin
      showmessage('nic nie znaleziono!');
      eszukaj.Text:='';
      odswiez;
    end;
 filtrc:=false;
end;

procedure TformPokedex.aaaa1Click(Sender: TObject);
begin
aaaa1.LosujTop;
end;

procedure TformPokedex.aaaa1Enter(Sender: TObject);
begin
aaaa1.LosujTop;
end;
           {
procedure TformPokedex.bDlugoscClick(Sender: TObject);
begin
eDlugosc.Text := inttostr(dlugoscc(first));
end;
           }

procedure TformPokedex.DodajDoListy(wLP: integer; wNazwa: string; wGatunek: string);
var
  NewOne: pElement;
begin
  new(newone);
  newone^.next := first;
  first := newone;
  newOne^.LP:= wLP;
  newOne^.nazwa:= wNazwa;
  newOne^.gatunek:= wGatunek;
  biezacy:=999;
end;

procedure TformPokedex.ListaClick(Sender: TObject);
begin
czyscedit;
if Lista.SelCount<>0 then
 begin
   WyswietlElement;
   biezacy:= strtoint(eLP.text);{if eLP.text<>'' then}
 end;
end;

procedure TFormPokedex.WyswietlElement;
var
 wyswietlany : pElement;

begin
wyswietlany:=first;
czyscedit;
  while wyswietlany^.LP <> strtoint(lista.selected.caption) do
    begin
      wyswietlany := wyswietlany^.next;
    end;
  if wyswietlany <> nil then
    begin
      eLP.Text:=inttostr(wyswietlany^.LP);
      eNazwa.Text:=wyswietlany^.nazwa;
      GatunekBox.itemindex:=strtoint(wyswietlany^.Gatunek);
    end;
end;


//          zapisywanie do pliku



procedure TFormPokedex.ZapiszDoPliku;
const
    pokemony = 'pokemony.dicx';
var wyjscie : Textfile;
    temp : pElement;
Begin
    AssignFile(wyjscie, pokemony);
    rewrite(wyjscie);
    temp := first;
    while temp <> nil do
    begin
      Writeln(wyjscie, temp^.LP);
      Writeln(wyjscie, temp^.gatunek);
      WriteLn(wyjscie, temp^.nazwa);
      temp := temp^.next;
    end;
    closefile(wyjscie);
end;

 //             koniec zapisywania


procedure TFormPokedex.bZapiszDoPlikuclick(Sender:Tobject);
begin
 zapiszdopliku;
end;

procedure TformPokedex.bOdswiezClick(Sender: TObject);
begin
lista.Clear;
eszukaj.Text:='';
czyscedit;

if eLP.text='' then
  biezacy:=0
else
  biezacy:= strtoint(eLP.text);

odswiez;
end;


procedure TformPokedex.Button1Click(Sender: TObject);
begin
filtr:=1;
LbPomoc.Caption:='(LP)';
end;

procedure TformPokedex.Button2Click(Sender: TObject);
begin
filtr:=2;
LbPomoc.Caption:='(Nazwa)';
end;

procedure TformPokedex.Button3Click(Sender: TObject);
begin
filtr:=3;
LbPomoc.Caption:='(Gatunek)';
end;

procedure TformPokedex.Button4Click(Sender: TObject);
begin
filtr:=0;
LbPomoc.Caption:='(Wszystko)';
end;


procedure TformPokedex.Button5Click(Sender: TObject);
begin
Application.Minimize;
end;

procedure TformPokedex.Button6Click(Sender: TObject);
begin
close;
end;

procedure TformPokedex.bUsuwaniePoczClick(Sender: TObject);
begin
  UsuwaniezPoczatku;
  lista.Clear;
  odswiez;
end;


procedure TformPokedex.bFiltrClick(Sender: TObject);
begin
 filtrc := true;
 filtruj;
 czyscedit;
end;

//               wczytywanie

procedure TformPokedex.bWczytajClick(Sender: TObject);
const
  pokemony = '\PROJEKT JoPokedex\pokemony.dicx';  //    D:\PROJEKT JoPokedex\
var
  nowy, nastepny : pElement;
  wejscie : TextFile;
begin
  AssignFile (wejscie, pokemony);
  Reset(wejscie);
//first := nil;  //trzeba b�dzie jeszcze zwolni� pami�� po wszystkich elementach
nastepny := nil;
    while not Eof(wejscie) do
      begin
            New(nowy);
            Readln(wejscie, nowy^.LP);
            Readln(wejscie, nowy^.gatunek);
            Readln(wejscie, nowy^.nazwa);
            nowy^.next := nastepny;
            first := nowy;
            nastepny := nowy;
            //odswiez;
      end;
  CloseFile(wejscie);
  lista.Clear;
  odswiez;
end;

//                koniec wczytywania





//                                SORTOWANIE
procedure TformPokedex.sortujLP;
  var
  zmiana : boolean;
  jeden,dwa : pElement;
    LP    : integer;
    nazwa : string;
    gatunek : string;
begin


repeat

  jeden := first;
  zmiana := false;

      while jeden^.next<>nil do                //przechodzenie przez liste
      begin
        dwa:=jeden^.next;

        if jeden^.LP > dwa^.LP then         //ZAMIANKA
          begin
            LP:=dwa^.LP;
            Nazwa:=dwa^.Nazwa;
            Gatunek:=dwa^.Gatunek;

            dwa^.LP:=jeden^.LP;
            dwa^.Nazwa:=jeden^.Nazwa;
            dwa^.Gatunek:=jeden^.Gatunek;

            jeden^.LP:=LP;
            jeden^.Nazwa:=Nazwa;
            jeden^.Gatunek:=Gatunek;

            zmiana:=true;
          end;    // KONIEC ZAMIANKI

        jeden:=dwa;        //tu musimy przesunac sie o jedno w prawo/dol
      end;

  until zmiana=false;
lista.Clear;
odswiez;
end;



procedure TformPokedex.sortujNazwa;
  var
  zmiana : boolean;
  jeden,dwa : pElement;
    LP    : integer;
    nazwa : string;
    gatunek : string;
begin


repeat

  jeden := first;
  zmiana := false;

      while jeden^.next<>nil do                //przechodzenie przez liste
      begin
        dwa:=jeden^.next;

        if AnsiCompareText(jeden^.Nazwa,dwa^.Nazwa)>0 then         //ZAMIANKA
          begin
            LP:=dwa^.LP;
            Nazwa:=dwa^.Nazwa;
            Gatunek:=dwa^.Gatunek;

            dwa^.LP:=jeden^.LP;
            dwa^.Nazwa:=jeden^.Nazwa;
            dwa^.Gatunek:=jeden^.Gatunek;

            jeden^.LP:=LP;
            jeden^.Nazwa:=Nazwa;
            jeden^.Gatunek:=Gatunek;

            zmiana:=true;
          end;    // KONIEC ZAMIANKI

        jeden:=dwa;        //tu musimy przesunac sie o jedno w prawo/dol
      end;

  until zmiana=false;
lista.Clear;
odswiez;
end;

procedure TformPokedex.sortujGatunek;
var
  zmiana : boolean;
  jeden,dwa : pElement;
    LP    : integer;
    nazwa : string;
    gatunek : string;
begin


repeat

  jeden := first;
  zmiana := false;

      while jeden^.next<>nil do                //przechodzenie przez liste
      begin
        dwa:=jeden^.next;

        if jeden^.Gatunek > dwa^.Gatunek then         //ZAMIANKA
          begin
            LP:=dwa^.LP;
            Nazwa:=dwa^.Nazwa;
            Gatunek:=dwa^.Gatunek;

            dwa^.LP:=jeden^.LP;
            dwa^.Nazwa:=jeden^.Nazwa;
            dwa^.Gatunek:=jeden^.Gatunek;

            jeden^.LP:=LP;
            jeden^.Nazwa:=Nazwa;
            jeden^.Gatunek:=Gatunek;

            zmiana:=true;
          end;    // KONIEC ZAMIANKI

        jeden:=dwa;        //tu musimy przesunac sie o jedno w prawo/dol
      end;

  until zmiana=false;
lista.Clear;
odswiez;
end;
//                              koniec sortowania

procedure TformPokedex.eLPChange(Sender: TObject);
begin
  if (Length(eLP.Text) > 0) then
  begin
  biezacy:= strtoint(eLP.text);
  nazwa.text:=inttostr(biezacy);
  end;
end;


procedure TformPokedex.eNazwaChange(Sender: TObject);
begin
   if (Length(eLP.Text) > 0) and ({IntToStr}(eLP.Text)<>'') and (Length(eNazwa.Text) > 0) then
   //bDodaj.Enabled := True
end;




procedure TformPokedex.eSzukajChange(Sender: TObject);
begin
if length(eSzukaj.Text)>0 then
//filtruj;
end;

procedure TformPokedex.FormCreate(Sender: TObject);
const

  pokemony = 'pokemony.dicx';  //D:\PROJEKT JoPokedex\
var
  nowy, nastepny : pElement;
  wejscie : TextFile;
begin

CreateMutex(nil, FALSE, 'PROJEKT'); //sprawdzanie czy nie jest juz uruchomiony
  if GetLastError() <> 0 then
  begin
        MessageBox(0, 'Program jest ju� uruchomiony!', 'B��d', MB_OK);
        Halt;
  end;


  AssignFile (wejscie, pokemony);
  Reset(wejscie);
  nastepny := nil;
    while not Eof(wejscie) do
      begin
            New(nowy);
            Readln(wejscie, nowy^.LP);
            Readln(wejscie, nowy^.gatunek);
            Readln(wejscie, nowy^.nazwa);
            nowy^.next := nastepny;
            first := nowy;
            nastepny := nowy;
            //odswiez;
      end;
  CloseFile(wejscie);
  lista.Clear;
  odswiez;
  sortujLP;
  sort := 1;
  filtr := 0;
  filtrc := false;
  istnieje := false;
 // edycja:=false;
//lista.itemindex:=1;

 {Lista.items.item[0].Selected :=true;
 // Lista.items.item[5].Selected :=true;
  for I:=0 to Lista.Items.Count -1 do
begin
if I <> lista.Selected.Index then

 }
end;








procedure TformPokedex.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbLeft
     then begin
            SendMessage(Handle, WM_LButtonUp, 0, 0);
            SendMessage(Handle, WM_NCLButtonDown, htCaption, 0 );
          end;
end;

procedure TformPokedex.ListaColumnClick(Sender: TObject; Column: TListColumn);
begin
  if Column.index=0 then
    begin
      sortujLP;
      sort:=1;
    end
  else if Column.Index=1 then
    begin
      sortujNazwa;
      sort:=2;
    end
  else
    begin
      sortujGatunek;
      sort:=3;
    end;
end;



procedure TformPokedex.bUsunWybranyClick(Sender: TObject);
begin
UsunWybrany;
//odswiez;
filtruj;
end;


procedure TformPokedex.UsunWybrany;
var
 todel,temp : pElement;
begin
if Lista.SelCount=1  then
  begin
  todel:=first;
    if todel^.LP = strtoint(lista.selected.caption) then UsuwaniezPoczatku
    else
     begin
      while (todel^.LP <> strtoint(Lista.Selected.caption)) and (todel^.next<>nil) do
        begin
          temp := todel;
          todel := todel^.next;
        end;

      if todel^.LP = strtoint(Lista.Selected.caption) then
        begin
          temp^.next := todel^.next;
          dispose(todel);
        end;
     end;
  end
else showmessage('Zaznacz jaki� element!!!')
end;


procedure TformPokedex.UsuwaniezPoczatku;
var
  temp : pElement;
begin
  temp := first;
  if temp <> nil then
  begin
    first := temp^.next;
    dispose(temp);
  end;
end;


function TformPokedex.dlugosc;
var
  i:integer;
  temp: pElement;
begin
i := 0;
temp:=first;
   while temp<>nil do
   begin
     temp:=temp^.next;
     i := i+1;
   end;
   dlugosc:=i;
end;

procedure TformPokedex.czyscEdit;
begin
  eLP.text:='';
  eNazwa.text:='';
  GatunekBox.itemindex := 0;
end;

end.
