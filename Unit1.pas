unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OpenGL, ExtCtrls, XPMan, ElectronsListClass;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    XPManifest1: TXPManifest;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    IsRun:Boolean;
    Electrons:ElectronsList;
    procedure SetDefaultWindowsPos;
    procedure SetDCPixelFormat;
    procedure DrawGrids(a,b,c:Boolean);
    procedure DrawAxis(a,b,c:Boolean);
    procedure Quadrangle(x1,y1,z1,
                         x2,y2,z2,
                         x3,y3,z3,
                         x4,y4,z4:Single);
    procedure DrawBox(x,y,z,xWidth,yWidth,zWidth:Single);
  end;

var
  Form1: TForm1;
  DC:HDC;
  HRC:HGLRC;
  ViewerRotation,ViewerX,ViewerY:Double;
  mouseRF,mouseLF:Boolean;
  preX,preY:Integer;
  material:Array[0..3] of GLFloat;

implementation

uses Unit3, Unit2;

{$R *.dfm}

procedure TForm1.Quadrangle(x1,y1,z1,
                            x2,y2,z2,
                            x3,y3,z3,
                            x4,y4,z4:Single);
begin
  glTexCoord2f(0,1);
  glVertex3f(x1,y1,z1);
  glTexCoord2f(0,0);
  glVertex3f(x2,y2,z2);
  glTexCoord2f(1,0);
  glVertex3f(x3,y3,z3);
  glTexCoord2f(1,1);
  glVertex3f(x4,y4,z4);
end;

procedure TForm1.DrawBox(x,y,z,xWidth,yWidth,zWidth:Single);
begin
  glBegin(GL_QUADS);
    glNormal3f(-1,0,0);
    Quadrangle(x,y,z+zWidth,x,y+yWidth,z+zWidth,x,y+yWidth,z,x,y,z);
    glNormal3f(1,0,0);
    Quadrangle(x+xWidth,y,z+zWidth,x+xWidth,y+yWidth,z+zWidth,
               x+xWidth,y+yWidth,z,x+xWidth,y,z);
    glNormal3f(0,0,-1);
    Quadrangle(x,y,z,x,y+yWidth,z,x+xWidth,y+yWidth,z,x+xWidth,y,z);
    glNormal3f(0,0,1);
    Quadrangle(x,y,z+zWidth,x,y+yWidth,z+zWidth,x+xWidth,y+yWidth,
               z+zWidth,x+xWidth,y,z+zWidth);
    glNormal3f(0,-1,0);
    Quadrangle(x,y,z,x,y,z+zWidth,x+xWidth,y,z+zWidth,x+xWidth,y,z);
    glNormal3f(0,1,0);
    Quadrangle(x,y+yWidth,z,x,y+yWidth,z+zWidth,x+xWidth,y+yWidth,
               z+zWidth,x+xWidth,y+yWidth,z);
  glEnd;
end;

procedure TForm1.DrawGrids(a,b,c:Boolean);
const
  GridAmp=10;
var
  i:Integer;
begin
  if a then
  begin
    for i:=-GridAmp to GridAmp do
    begin
      if i<>0 then
        glColor3f(0.7,0.7,0.7)
      else
        glColor3f(1,0,0);
      glBegin(GL_LINES);
      glVertex3f(-GridAmp,i,0);
      glVertex3f(GridAmp,i,0);
      glEnd;
      if i<>0 then
        glColor3f(0.7,0.7,0.7)
      else
        glColor3f(0,1,0);
      glBegin(GL_LINES);
      glVertex3f(i,-GridAmp,0);
      glVertex3f(i,GridAmp,0);
      glEnd;
    end;
  end;

  if b then
  begin
    for i:=-GridAmp to GridAmp do
    begin
      if i<>0 then
        glColor3f(0.7,0.7,0.7)
      else
        glColor3f(0,1,0);
      glBegin(GL_LINES);
      glVertex3f(0,-GridAmp,i);
      glVertex3f(0,GridAmp,i);
      glEnd;
      if i<>0 then
        glColor3f(0.7,0.7,0.7)
      else
        glColor3f(0,0,1);
      glBegin(GL_LINES);
      glVertex3f(0,i,-GridAmp);
      glVertex3f(0,i,GridAmp);
      glEnd;
    end;
  end;

  if c then
  begin
    glBegin(GL_LINES);
    for i:=-GridAmp to GridAmp do
    begin
      if i<>0 then
        glColor3f(0.7,0.7,0.7)
      else
        glColor3f(1,0,0);
      glBegin(GL_LINES);
      glVertex3f(-GridAmp,0,i);
      glVertex3f(GridAmp,0,i);
      glEnd;
      if i<>0 then
        glColor3f(0.7,0.7,0.7)
      else
        glColor3f(0,0,1);
      glBegin(GL_LINES);
      glVertex3f(i,0,-GridAmp);
      glVertex3f(i,0,GridAmp);
      glEnd;
    end;
  end;
end;

procedure TForm1.DrawAxis(a,b,c:Boolean);
const
  GridAmp=100;
begin
  if a then
  begin
    glColor3f(1,0,0);
    glBegin(GL_LINES);
      glVertex3f(-GridAmp,0,0);
      glVertex3f(GridAmp,0,0);
    glEnd;
  end;

  if b then
  begin
    glColor3f(0,1,0);
    glBegin(GL_LINES);
      glVertex3f(0,-GridAmp,0);
      glVertex3f(0,GridAmp,0);
    glEnd;
  end;

  if c then
  begin
    glColor3f(0,0,1);
    glBegin(GL_LINES);
      glVertex3f(0,0,-GridAmp);
      glVertex3f(0,0,GridAmp);
    glEnd;
  end;
end;

procedure TForm1.SetDCPixelFormat;
var
  nPixelFormat:Integer;
  pfd:TPixelFormatDescriptor;
begin
  FillChar(pfd,SizeOf(pfd),0);
  pfd.dwFlags:=PFD_DOUBLEBUFFER or
               PFD_SUPPORT_OPENGL or
               PFD_DRAW_TO_WINDOW;
  nPixelFormat:=ChoosePixelFormat(DC,@pfd);
  SetPixelFormat(DC,nPixelFormat,@pfd);
end;

procedure TForm1.SetDefaultWindowsPos;
const
  lp=200;
begin
  frmAbout.Hide;
  with frmOptions do
  begin
    Left:=0;
    Top:=0;
    Width:=lp;
    Height:=Screen.Height;
    Show;
  end;
  with Form1 do
  begin
    Left:=lp;
    Top:=0;
    Width:=Screen.Width-lp;
    Height:=Screen.Height;
    Show;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  SetDefaultWindowsPos;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Electrons:=ElectronsList.Create;
  IsRun:=False;
  ViewerRotation:=-30;
  mouseRF:=False;
  mouseLF:=False;
  ViewerX:=0;
  ViewerY:=-5;
  material[0]:=0.1;
  material[1]:=0.1;
  material[2]:=0.1;
  material[3]:=0.1;

  DC:=GetDC(Handle);
  SetDCPixelFormat;
  HRC:=wglCreateContext(DC);
  wglMakeCurrent(DC,HRC);
  glEnable(GL_DEPTH_TEST);
  glClearColor(0,0,0,1);
  glEnable(GL_LIGHTING);
  glEnable(GL_LIGHT0);
  glEnable(GL_COLOR_MATERIAL);
  glEnable(GL_POINT_SMOOTH);
  glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, @material);

  Timer1.Enabled:=True;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Timer1.Enabled:=False;
  Electrons.Destroy;
  wglMakeCurrent(DC,HRC);
  wglDeleteContext(HRC);
  ReleaseDC(Handle,DC);
  DeleteDC(DC);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  ps:TPaintStruct;
begin
  BeginPaint(Handle,ps);
  glClear(GL_COLOR_BUFFER_BIT or
          GL_DEPTH_BUFFER_BIT);
  glLoadIdentity;

  if frmOptions.CheckBox7.Checked then
    ViewerRotation:=ViewerRotation+0.3;
  if ViewerRotation>=360 then ViewerRotation:=0;

  glTranslatef(ViewerX,ViewerY,-frmOptions.TrackBar1.Position);
  glRotatef(ViewerRotation,0,1,0);

  glDisable(GL_LIGHTING);
  glColor3f(1,1,1);
  DrawGrids(frmOptions.CheckBox1.Checked,
            frmOptions.CheckBox2.Checked,
            frmOptions.CheckBox3.Checked);
  DrawAxis(frmOptions.CheckBox4.Checked,
           frmOptions.CheckBox5.Checked,
           frmOptions.CheckBox6.Checked);
  glEnable(GL_LIGHTING);

  glColor3f(0.5,0.5,0.5);
  DrawBox(-10,0,-2,7,0.5,4);
  DrawBox(-10,9.5,-2,20,0.5,4);
  glColor3f(0,0,1);
  DrawBox(-0.5,0,-2,1,0.5,4);
  glColor3f(1,0,0);
  DrawBox(3,0,-2,7,0.5,4);
  glColor3f(0.7,0.7,0.7);
  glLineWidth(3);
  glBegin(GL_LINES);
    glVertex3f(-10,10,2);
    glVertex3f(-10,0,2);
    glVertex3f(-10,10,-2);
    glVertex3f(-10,0,-2);
    glVertex3f(10,10,2);
    glVertex3f(10,0,2);
    glVertex3f(10,10,-2);
    glVertex3f(10,0,-2);
  glEnd;
  glLineWidth(0.5);

  if IsRun then
  begin
    Electrons.AddElectron;
    Electrons.CalcElectrons;
    if frmOptions.CheckBox8.Checked then
      Electrons.DrawField; 
  end;


  EndPaint(Handle,ps);
  SwapBuffers(DC);
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  glViewPort(0,0,ClientWidth,ClientHeight);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  gluPerspective(30,ClientWidth/ClientHeight,1,200);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbLeft then
  begin
    mouseRF:=False;
    mouseLF:=True;
  end;
  if Button=mbRight then
  begin
    mouseLF:=False;
    mouseRF:=True;
  end;
  preX:=X;
  preY:=Y;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbLeft then
    mouseLF:=False;
  if Button=mbRight then
    mouseRF:=False;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if mouseLF then
  begin
    ViewerRotation:=ViewerRotation+(X-PreX);
  end;
  if mouseRF then
  begin
    ViewerX:=ViewerX+(PreX-X)/8;
    ViewerY:=ViewerY+(Y-PreY)/8;
  end;
  PreX:=X;
  PreY:=Y;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=112 then
    MessageBox(Handle,
      'Разработчик: Макаров М.М.'+#13#10+
      'Дата создания: Сентябрь 2004',
      'О программе',0);
end;

end.
 