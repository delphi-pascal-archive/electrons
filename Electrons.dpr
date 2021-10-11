program Electrons;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {frmOptions},
  Unit3 in 'Unit3.pas' {frmAbout},
  ElectronsUnit in 'ElectronsUnit.pas',
  ElectronsListClass in 'ElectronsListClass.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Электроны в электрическом поле';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmOptions, frmOptions);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.Run;
end.
