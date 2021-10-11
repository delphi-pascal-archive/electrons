unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons;

type
  TfrmOptions = class(TForm)
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    GroupBox2: TGroupBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    GroupBox3: TGroupBox;
    TrackBar1: TTrackBar;
    GroupBox4: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    GroupBox5: TGroupBox;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    GroupBox6: TGroupBox;
    CheckBox7: TCheckBox;
    Button4: TButton;
    GroupBox7: TGroupBox;
    CheckBox8: TCheckBox;
    procedure TrackBar1Change(Sender: TObject);
    procedure LabeledEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure LabeledEdit2KeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private

  public

  end;

var
  frmOptions: TfrmOptions;

implementation

uses Unit1, Unit3;

{$R *.dfm}

procedure TfrmOptions.TrackBar1Change(Sender: TObject);
begin
  GroupBox3.Caption:=' Дистанция: '+IntToStr(TrackBar1.Position)+' ';
end;

procedure TfrmOptions.LabeledEdit1KeyPress(Sender: TObject; var Key: Char);
var
  tck:Char;
  s:ShortString;
begin
  s:=FloatToStr(0.1);
  tck:=s[2];
  if ((not (Key in ['0'..'9',#8,tck,'-'])) or
    ((Pos(tck,String(Text))>0) and
    (Key=tck))) then
  begin
    Key:=#0;
    Beep;
  end;
end;

procedure TfrmOptions.LabeledEdit2KeyPress(Sender: TObject; var Key: Char);
var
  tck:Char;
  s:ShortString;
begin
  s:=FloatToStr(0.1);
  tck:=s[2];
  if ((not (Key in ['0'..'9',#8,tck,'-'])) or
    ((Pos(tck,String(Text))>0) and
    (Key=tck))) then
  begin
    Key:=#0;
    Beep;
  end;
end;

procedure TfrmOptions.Button1Click(Sender: TObject);
begin
  Form1.Electrons.InitField(StrToFloat(LabeledEdit1.Text),
    StrToFloat(LabeledEdit2.Text));
  Form1.IsRun:=True;
end;

procedure TfrmOptions.Button2Click(Sender: TObject);
begin
  Form1.IsRun:=False;
end;

procedure TfrmOptions.Button3Click(Sender: TObject);
begin
  Form1.Electrons.DeleteAllElectrons;
  Form1.IsRun:=False;
end;

procedure TfrmOptions.Button4Click(Sender: TObject);
begin
  Beep;
  with frmAbout do
  begin
    Position:=poScreenCenter;
    Show;
  end;
end;

procedure TfrmOptions.FormResize(Sender: TObject);
begin
  Button4.Top:=ClientHeight-Button4.Height-8;
  Button4.Width:=ClientWidth-16;
end;

end.
