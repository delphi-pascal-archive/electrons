unit ElectronsUnit;

interface

uses OpenGL;

type
  vector=record
    x,y,z:Double;
  end;

  TElectron=class
  private
    mass:Double;
  public
    position,
    speed,
    acceleration:vector;
    constructor Create(x,y,z:Double);
    procedure Calc;
    procedure Draw;
  end;

implementation

constructor TElectron.Create(x,y,z:Double);
begin
  Inherited Create;
  position.x:=x;
  position.y:=y;
  position.z:=z;
  with speed do
  begin
    x:=(Random(5)+1)/5;
    y:=(Random(5)+1)/5;
    z:=(Random(5)+1)/5;
    {x:=0;
    y:=0;
    z:=0;}
  end;
  with acceleration do
  begin
    x:=0;
    y:=0;
    z:=0;
  end;
end;

procedure TElectron.Calc;
const
  t=50/1000;
begin
  speed.x:=speed.x+acceleration.x*t;
  speed.y:=speed.y+acceleration.y*t;
  speed.z:=speed.z+acceleration.z*t;

  position.x:=position.x+speed.x*t;
  position.y:=position.y+speed.y*t;
  position.z:=position.z+speed.z*t;
end;

procedure TElectron.Draw;
begin
  Calc;
  if (position.x<10) and
     (position.x>-10) and
     (position.y<10) and
     (position.y>0) then
       glVertex3f(position.x, position.y, position.z);
end;

end.
