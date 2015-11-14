library joDLL;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  System.SysUtils,
  System.Classes,
  windows;//, ShareMem;



type
 pElement=^tElement;
 tElement=record
         next    : pElement;
         LP      : integer;
         nazwa   : string;
         gatunek : string;
end;
var
 first  :pElement;


{$R *.res}

function Zamien(gatunek : integer) : WideString; stdcall;
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


function pierwszy() : pelement; stdcall;
begin
  Result := first;
end;


function dlugoscc(first2 : pElement):integer;stdcall;
var
  i:integer;
  temp: pElement;
begin
i := 0;
temp:=first2;
   while temp<>nil do
   begin
     temp:=temp^.next;
     i := i+1;
   end;
   dlugoscc:=i;
end;


procedure dodajdollisty(var head:pelement; elem:Pelement);stdcall;
var
prev : pelement ;

begin
if head = nil then
  head:=elem
else
  begin
    prev  :=head;

    while prev^.next<>nil do
      prev:=prev^.next;

    prev^.next:=elem;
  end ;
end;


procedure WyswietlElementt(var caption:integer; LP:integer; Nazwa:string; gatunek:string ); stdcall;
var
 wyswietlany : pElement;

begin
wyswietlany:=first;
  while wyswietlany^.LP <> (caption) do
    begin
      wyswietlany := wyswietlany^.next;
    end;
  if wyswietlany <> nil then
    begin
      LP:=(wyswietlany^.LP);
      nazwa:=wyswietlany^.nazwa;
      Gatunek:=(wyswietlany^.Gatunek);
    end;
end;

procedure zapiszdoplliku; stdcall;
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



exports
  Zamien, dlugoscc, dodajdollisty, wyswietlelementt, zapiszdoplliku, pierwszy;




begin
end.
