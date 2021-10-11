unit ElectronsListClass;

interface

uses
  ElectronsUnit, OpenGL;

type
  vector=record
    x,y,z:Double;
  end;

  ElectronsList=class(TObject)
  public
    koef:Double;
    constructor Create;
    destructor Destroy;override;
    procedure AddElectron;
    procedure CalcElectrons;
    procedure DeleteAllElectrons;
    procedure InitField(katod,anod:Double);
    procedure DrawField;
  private
    ESystem:Array of TElectron;
    NumbOfElectrons:Integer;
    f:Array[-100..100, 0..100] of Double;
  end;

implementation

procedure ElectronsList.DrawField;
var
  i,j:Integer;
begin
  glDisable(GL_LIGHTING);
  glBegin(GL_QUADS);
  for i:=-100 to 99 do
    for j:=0 to 99 do
    begin
      if f[i,j]>0 then
        glColor3f(f[i,j]*koef,0,0)
      else
        glColor3f(0,0,Abs(f[i,j]*koef));
      glVertex3f(i/10,j/10,-2.1);

      if f[i+1,j]>0 then
        glColor3f(f[i+1,j]*koef,0,0)
      else
        glColor3f(0,0,Abs(f[i+1,j]*koef));
      glVertex3f((i+1)/10,j/10,-2.1);

      if f[i+1,j+1]>0 then
        glColor3f(f[i+1,j+1]*koef,0,0)
      else
        glColor3f(0,0,Abs(f[i+1,j+1]*koef));
      glVertex3f((i+1)/10,(j+1)/10,-2.1);

      if f[i,j+1]>0 then
        glColor3f(f[i,j+1]*koef,0,0)
      else
        glColor3f(0,0,Abs(f[i,j+1]*koef));
      glVertex3f(i/10,(j+1)/10,-2.1);
    end;
  glEnd;
  glEnable(GL_LIGHTING);
end;

procedure ElectronsList.InitField(katod,anod:Double);
var
  i,j,k:Integer;
begin
  {обнуляем всё}
  for i:=-100 to 100 do
    for j:=0 to 100 do
      f[i,j]:=0;
  {расчитываем все потенциалы}
  for k:=1 to 1000 do
  begin
    {инициируем катод}
    for i:=-5 to 5 do
      for j:=0 to 5 do
        f[i,j]:=katod;
    {инициируем анод}
    for i:=30 to 100 do
      for j:=0 to 5 do
        f[i,j]:=anod;
    {нулевые потенциалы}
    for i:=-100 to 100 do
      for j:=95 to 100 do
        f[i,j]:=0;
    for i:=-100 to -30 do
      for j:=0 to 5 do
        f[i,j]:=0;
    for i:=-100 to 100 do
    begin
      f[i,0]:=0;
      f[i,100]:=0;
    end;
    for j:=0 to 100 do
    begin
      f[-100,j]:=0;
      f[100,j]:=0;
    end;
    {расчитываем потенциалы}
    for i:=-99 to 99 do
      for j:=1 to 99 do
        f[i,j]:=(f[i-1,j]+f[i+1,j]+f[i,j-1]+f[i,j+1])/4;
  end;
  if Abs(katod)>Abs(anod) then
    koef:=255/Abs(katod)
  else
    koef:=255/Abs(anod);
end;

constructor ElectronsList.Create;
begin
  Inherited Create;
  NumbOfElectrons:=0;
  Finalize(ESystem);
end;

procedure ElectronsList.AddElectron;
const
  EMax=1000;
var
  finded:Boolean;
  i:Integer;
begin
  finded:=False;
  if NumbOfElectrons>0 then
    for i:=0 to NumbOfElectrons-1 do
      if ESystem[i]=NIL then
      begin
        finded:=True;
        ESystem[i]:=
          TElectron.Create(Random(8)-10,Random(50)/100,Random(8)/2-2);
      end;
  if finded=false then
  begin
    if NumbOfElectrons<EMax then
    begin
      inc(NumbOfElectrons);
      SetLength(ESystem,NumbOfElectrons);
      ESystem[NumbOfElectrons-1]:=
        TElectron.Create(Random(8)-10,Random(50)/100,Random(8)/2-2);
    end;
  end;
end;

procedure ElectronsList.CalcElectrons;
const
  e=0.00000000000000000016;
  k=9000000000;
  dd=0.001;
  t=50/1000;
var
  i,j:Integer;
begin
  glDisable(GL_LIGHTING);
  glPointSize(3);
  glColor3f(0.0, 0.0, 1.0);
  glBegin(GL_POINTS);
  for i:=0 to NumbOfElectrons-1 do
  begin
    if ESystem[i]<>NIL then
    begin

      if (Round(ESystem[i].position.x*10)>=-100) and
         ((Round(ESystem[i].position.x*10)+1)<100)and
         (Round(ESystem[i].position.y*10)>=0) and
         ((Round(ESystem[i].position.y*10)+1)<100) then
      begin
        ESystem[i].acceleration.x:=
          -(f[Round(ESystem[i].position.x*10),Round(ESystem[i].position.y*10)]-
          f[Round(ESystem[i].position.x*10+1),Round(ESystem[i].position.y*10)])/dd;
        ESystem[i].acceleration.y:=
          -(f[Round(ESystem[i].position.x*10),Round(ESystem[i].position.y*10)]-
          f[Round(ESystem[i].position.x*10),Round(ESystem[i].position.y*10+1)])/dd;
      end;
      ESystem[i].acceleration.z:=0;

      ESystem[i].Draw;
      if ((ESystem[i].position.x>3) and
          (ESystem[i].position.y<0.5)) then
          begin
            ESystem[i].Destroy;
            ESystem[i]:=NIL;
          end;

      if ESystem[i]<>NIL then
      with ESystem[i] do
      begin
        if (position.x+speed.x*t)<=-10 then speed.x:=Abs(speed.x);
        if (position.x+speed.x*t)>=10 then speed.x:=-Abs(speed.x);
        if (position.y+speed.y*t)<=0 then speed.y:=Abs(speed.y);
        if (position.y+speed.y*t)>=9.5 then speed.y:=-Abs(speed.y);
        if (position.z+speed.z*t)<=-2 then speed.z:=Abs(speed.z);
        if (position.z+speed.z*t)>=2 then speed.z:=-Abs(speed.z);
      end;

      if ESystem[i]<>NIL then
      if ((ESystem[i].position.x>10) or
          (ESystem[i].position.x<-10) or
          (ESystem[i].position.y>10) or
          (ESystem[i].position.y<0)) then
          begin
            ESystem[i].Destroy;
            ESystem[i]:=NIL;
          end;
    end;
  end;
  glEnd;
  glEnable(GL_LIGHTING);
end;

procedure ElectronsList.DeleteAllElectrons;
var
  i:Integer;
begin
  for i:=0 to NumbOfElectrons-1 do
    if ESystem[i]<>NIL then
    begin
      ESystem[i].Destroy;
      ESystem[i]:=NIL;
    end;
  NumbOfElectrons:=0;
  Finalize(ESystem);
end;

destructor ElectronsList.Destroy;
begin
  DeleteAllElectrons;
  Inherited Destroy;
end;

end.
