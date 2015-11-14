unit jopokedex1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.strutils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtDlgs, mojButton//, mojButton;//, ShareMem;// ComboBoxElite ;

type
  TformPokedex = class(TForm)
    Image1: TImage;
    bDodaj: TButton;
    eLP: TEdit;
    eNazwa: TEdit;
    LbLP: TLabel;
    LbNazwa: TLabel;
    LbGatunek: TLabel;
    Lista: TListView;
    bDodajNaKoniec: TButton;
    bKasuj: TButton;
    bUsuwanie: TButton;
    bWczytaj: TButton;
    GatunekBox: TComboBox;
    bZapiszDoPliku: TButton;
    LbSzukaj: TLabel;
    SzukajBox: TComboBox;
    eSzukaj: TEdit;
    bUsuwaniePocz: TButton;
    bUsunWybrany: TButton;
    Nazwa: TEdit;
    bEdycja: TButton;
    bFiltr: TButton;
    bOdswiez: TButton;
    bOdswiezaj: TButton;
    eDlugosc: TEdit;
    bDlugosc: TButton;
    MojButton1: TMojButton;
    procedure DodajDoListy(wLP : integer; wNazwa : string; wGatunek : string);
    procedure DodajNaKoniec(wLP : integer; wNazwa : string; wGatunek : string);
    procedure UsuwanieZKonca;
    procedure UsuwaniezPoczatku;
    procedure UsunWybrany;
    procedure WyswietlElement;
    procedure czyscEdit;
    function dlugosc : Integer;
    procedure odswiez;
    procedure sortujLP;
    procedure sortujNazwa;
    procedure sortujGatunek;
    procedure ZapiszDoPliku;
    procedure bDodajNaKoniecClick(Sender: TObject);
    procedure bKasujClick(Sender: TObject);
    procedure bUsuwanieClick(Sender: TObject);
    procedure bDodajClick(Sender: TObject);
    procedure bWczytajClick(Sender: TObject);
    procedure bZapiszDoPlikuClick(Sender: TObject);
    procedure eLPChange(Sender: TObject);
    procedure eNazwaChange(Sender: TObject);
    procedure eSzukajChange(Sender: TObject);
    procedure SzukajBoxChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bUsuwaniePoczClick(Sender: TObject);
    procedure bUsunWybranyClick(Sender: TObject);
    procedure ListaColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListaClick(Sender: TObject);
    procedure Edycja;
    procedure bEdycjaClick(Sender: TObject);
    procedure filtruj;
    procedure bFiltrClick(Sender: TObject);
    procedure bOdswiezClick(Sender: TObject);
    procedure bDlugoscClick(Sender: TObject);
    procedure joButton1Click(Sender: TObject);

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



 function dlugoscc:integer; stdcall external
        'D:\PROJEKT JoPokedex\joPokedex-DLL\Win32\Debug\joDLL.dll'
        name 'dlugoscc';

 function zamien(gatunek:integer):widestring; stdcall external
        'D:\PROJEKT JoPokedex\joPokedex-DLL\Win32\Debug\joDLL.dll'
        name 'Zamien';

//procedure wyswietlelement(var caption:integer; LP:integer; Nazwa:string; gatunek:string); stdcall external
//        'D:\PROJEKT JoPokedex\joPokedex-DLL\Win32\Debug\joDLL.dll'
//        name 'wyswietlelement';

//procedure dodajdolisty(var wLP: integer; wNazwa: string; wGatunek: string; first: pElement); stdcall external
//        'D:\PROJEKT JoPokedex\joPokedex-DLL\Win32\Debug\joDLL.dll'
//        name 'dodajdolisty';

//procedure zapiszdopliku; stdcall; external
//        'D:\PROJEKT JoPokedex\joPokedex-DLL\Win32\Debug\joDLL.dll'
//        name 'zapiszdopliku';
                {(LP : Integer; Nazwa : String; Gatunek : String; first: pElement)}




//WSKAèNIKI =))







//KONIEC WSKAèNIK”W

implementation


{$R *.dfm}


procedure TFormPokedex.edycja;
var
  edytowany : pElement;
begin
if Lista.SelCount<>1 then showmessage('zaznacz element do edycji!')
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


procedure TformPokedex.odswiez;
var
wsk: pElement;
element : TListItem;
begin
 //Lista.Clear;
  wsk := first;
  while wsk<>nil do
    begin
    element := Lista.Items.Add;
    element.Caption := inttostr(wsk^.LP);
    element.SubItems.Add(wsk^.nazwa);
    element.SubItems.Add(zamien(strtoint(wsk^.gatunek)));
    wsk := wsk^.next;
    end;
end;



procedure TformPokedex.filtruj;
var
wsk: pElement;
element : TListItem;
wyswietl : boolean;
begin
// Lista.Clear;
  wsk := first;
  while wsk<>nil do
    begin
    wyswietl:=true;
    if eSzukaj.text <> '' then
      begin
        Lista.Clear;
        if SzukajBox.ItemIndex=1 then
          wyswietl:= AnsiContainsText(inttostr(wsk^.LP),eSzukaj.text)
        else if SzukajBox.ItemIndex=2 then
          wyswietl:= AnsiContainsText(wsk^.Nazwa,eSzukaj.text)
        else if SzukajBox.ItemIndex=3 then
          wyswietl:= AnsiContainsText(zamien(strtoint(wsk^.gatunek)),eSzukaj.text)
        else if SzukajBox.ItemIndex=0 then
          wyswietl:= AnsiContainsText(inttostr(wsk^.LP),eSzukaj.text) or
                     AnsiContainsText(wsk^.Nazwa,eSzukaj.text) or
                     AnsiContainsText(zamien(strtoint(wsk^.gatunek)),eSzukaj.text)
      end
      else
        begin
          showmessage('wpisz coú!');
          break;
        end;
    if wyswietl=false then
      begin
        showmessage('nic nie znaleziono!');
        odswiez;
        break;
      end
    else
      begin
        element := Lista.Items.Add;
        element.Caption := inttostr(wsk^.LP);
        element.SubItems.Add(wsk^.nazwa);
        element.SubItems.Add(zamien(strtoint(wsk^.gatunek)));
      end;
      wsk := wsk^.next

    end;
end;


//              dodawanie do listy



procedure TformPokedex.bDlugoscClick(Sender: TObject);
begin
eDlugosc.Text := inttostr(dlugoscc);
end;




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
end;



procedure TformPokedex.bDodajClick(Sender: TObject);
begin
//if Lista.SelCount<>1 then
  DodajDoListy(strtoint(eLP.text),
              (eNazwa.Text),
              IntToStr(gatunekbox.itemindex));

//else edycja;
   lista.Clear;
   odswiez;
   czyscEdit;
   bDodaj.Enabled := False;
end;


//           dodawanie do listy




procedure TformPokedex.ListaClick(Sender: TObject);
begin
 eLP.Clear;
 eNazwa.Clear;
 GatunekBox.ItemIndex:=0;
 if Lista.SelCount<>0 then
 WyswietlElement;
end;


procedure TFormPokedex.WyswietlElement;
var
 wyswietlany : pElement;

begin
wyswietlany:=first;
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
    pokemony = 'D:\PROJEKT JoPokedex\pokemony.dicx';
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





procedure TformPokedex.bDodajNaKoniecClick(Sender: TObject);
begin
DodajNaKoniec(strtoint(eLP.Text),
              eNazwa.Text,
              GatunekBox.Text);
   lista.Clear;
   odswiez;
end;

procedure TformPokedex.bKasujClick(Sender: TObject);
begin
  UsuwanieZKonca;
end;



procedure TformPokedex.bOdswiezClick(Sender: TObject);
begin
lista.Clear;
odswiez;
end;



procedure TformPokedex.bUsuwanieClick(Sender: TObject);
begin
  UsuwanieZKonca;
  lista.Clear;
  odswiez;
end;



procedure TformPokedex.bUsuwaniePoczClick(Sender: TObject);
begin
  UsuwaniezPoczatku;
  lista.Clear;
  odswiez;
end;






procedure TformPokedex.bEdycjaClick(Sender: TObject);
begin
edycja;
 eLP.Clear;
 eNazwa.Clear;
 GatunekBox.ItemIndex:=0;
//odswiez;
filtruj;
end;

procedure TformPokedex.bFiltrClick(Sender: TObject);
begin
filtruj;
end;

//               wczytywanie

procedure TformPokedex.bWczytajClick(Sender: TObject);
const
  pokemony = 'D:\PROJEKT JoPokedex\pokemony.dicx';
var
  nowy, nastepny : pElement;
  wejscie : TextFile;
begin
  AssignFile (wejscie, pokemony);
  Reset(wejscie);
//first := nil;  //trzeba bÍdzie jeszcze zwolniÊ pamiÍÊ po wszystkich elementach
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





procedure TformPokedex.DodajNaKoniec(wLP: Integer; wNazwa: string; wGatunek: string);
var
  newone,temp: pElement;
begin
  new(newone);
  newone^.next := nil;
  newone^.LP := wLP;
  newone^.nazwa := wNazwa;
  newone^.gatunek := wGatunek;
  temp := first;
if temp = nil then
  first := newone
else
  begin
  while temp^.next <> nil do temp := temp^.next;
  temp^.next := newone;
  end;
end;





procedure TformPokedex.eLPChange(Sender: TObject);
begin
   if (Length(eLP.Text) > 0) and ({IntToStr}(eLP.Text)<>'') and (Length(eNazwa.Text) > 0) then
   bDodaj.Enabled := True
end;


procedure TformPokedex.eNazwaChange(Sender: TObject);
begin
   if (Length(eLP.Text) > 0) and ({IntToStr}(eLP.Text)<>'') and (Length(eNazwa.Text) > 0) then
   bDodaj.Enabled := True
end;




procedure TformPokedex.eSzukajChange(Sender: TObject);
begin
if length(eSzukaj.Text)>0 then
end;

procedure TformPokedex.FormCreate(Sender: TObject);
  const
  pokemony = 'D:\PROJEKT JoPokedex\pokemony.dicx';
var
  nowy, nastepny : pElement;
  wejscie : TextFile;
begin
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
  Szukajbox.ItemIndex:=0;

//lista.itemindex:=1;

 {Lista.items.item[0].Selected :=true;
 // Lista.items.item[5].Selected :=true;
  for I:=0 to Lista.Items.Count -1 do
begin
if I <> lista.Selected.Index then

 }
end;


procedure TformPokedex.joButton1Click(Sender: TObject);
begin
close;
end;

procedure TformPokedex.ListaColumnClick(Sender: TObject; Column: TListColumn);
begin
  if Column.index=0 then
    sortujLP
  else if Column.Index=1 then
    sortujNazwa
  else
    sortujGatunek;
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
if Lista.SelCount<>0  then
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
else showmessage('Zaznacz jakiú element!!!')
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

procedure TformPokedex.UsuwanieZKonca;
var
  temp: pElement;
begin
temp := first;
  if temp <> nil then
  begin
    if temp^.next <> nil then
      begin
        while temp^.next^.next <> nil do
          temp := temp^.next;
        dispose(temp^.next);
        temp^.next := nil
      end
      else
      begin
        dispose(temp);
        first := nil;
      end
    end;
end;



procedure TformPokedex.SzukajBoxChange(Sender: TObject);
begin
if SzukajBox.ItemIndex<>0 then
eSzukaj.Enabled := True;
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
  eLP.Clear;
  eNazwa.Clear;
  GatunekBox.itemindex := 0;
end;

end.
