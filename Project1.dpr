library Project1;

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
  System.Classes;

type
  pElement = ^tElement;
  tElement = record
         next   : pElement;
         LP    : integer;
         nazwa : string;
         gatunek : string;
end;
var
 first  :pElement;


{$R *.res}

procedure zapisz(plik : string; poczPL : pelement);
var
    wyjscie : TextFile;
    teraz : pelement;
begin
  try
    AssignFile(wyjscie, plik);
    Rewrite(wyjscie);
    teraz := poczPL;
    while teraz <> nil do
    begin
      WriteLn(wyjscie, teraz^.LP);
      WriteLn(wyjscie, teraz^.nazwa);
      WriteLn(wyjscie, teraz^.gatunek);
      teraz := teraz^.next
    end;

  except
  on EInOutError do
      begin
        closefile(wyjscie);
      end;
      on exception do
      begin
        closefile(wyjscie);
      end
  end;
  closefile(wyjscie);
end;

exports zapisz;
begin
end.
