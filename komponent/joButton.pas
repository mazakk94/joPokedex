unit joButton;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls;

type
  TjoButton = class(TButton)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
//    constructor Create(AOwner : TComponent); override;
 //   destructor Destroy; override; { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TjoButton]);
end;

end.
