unit Button2;

interface

uses
   System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls,Windows,Vcl.Styles,
  Vcl.Themes,Graphics;

type
  aaaa = class(TButton)

  private

  protected

  public
    procedure LosujTop;
  published

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [aaaa]);
end;

procedure aaaa.LosujTop;
var
  x:byte;
  y:TColor;
begin
  Randomize();
  //TButton(TButtonProc).Top:=random(720);
  //TButton(TButtonProc).Left:=Random(530);
  //TButton(TButtonProc).Font.Color:= RGB(Random(254),Random(254),Random(254));
  Left:=Random(773);
  Top:=Random(547);
  x:=Random(11);

case x of
  1:y:=clGray;
  2:y:=clAqua;
  3:y:=clCream;
  4:y:=clPurple;
  5:y:=clSilver;
  6:y:=clWhite;
  7:y:=clYellow;
  8:y:=clNavy;
  9:y:=clLime;
  10:y:=clFuchsia;
  11:y:=clMedGray;
end;

Font.Color:=y;

end;
end.
