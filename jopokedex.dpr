program jopokedex;

uses
  Vcl.Forms,
  jopokedex1 in 'D:\PROJEKT JoPokedex\jopokedex1.pas' {formPokedex};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TformPokedex, formPokedex);
  Application.Run;
end.
