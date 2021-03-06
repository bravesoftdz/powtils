{ Simple web based command line utility to control a web server that doesn't 
  have shell/ssh/telnet access available

  Notes:
    -tested on linux
    -does not work on windows

  Author: 
    Lars (L505
    http://z505.com
}
program webcmd1;
{$mode objfpc} {$H+}

uses  {$ifdef unix}unix, baseunix,{$endif}
  pwinit in '..\..\main/pwinit.pas',
  pwmain in '..\..\main/pwmain.pas',
  pwenvvar in '..\..\main\pwenvvar.pas',
  compactsysutils in '..\..\main\compactsysutils.pas',
  pwsubstr in '..\..\main\pwsubstr.pas',
  pwfileutil in '..\..\main\pwfileutil.pas',
  htmout;

procedure err(const s: string);
begin
  out('<br><b>Error:</b> ' + s);
end;

procedure RunAndShowCmd(const cmd: string);
var err : Longint;
begin
  out('<hr style="border-style: solid;">');
  out('Output of command: <b>'+ cmd + '</b>');
  outln('<textarea style="width:100%; font-size:0.9em; font-family:courier new;" ROWS=80>');
  err:=   fpSystem(cmd); //ls -l *.pp
  outln(  '-------------------------------------------------------------------------');
  outln(  'WEBCMD NOTE: command exited with status: ' + inttostr(err));
  outln('</textarea>');
end;

function FormPosted: boolean;
begin
  result:= false;
  if IsCgiVar('form1posted') then result:= true;
end;

type
  THtmForm = record
    cmd: string;
  end;

var
  htmform: THtmForm;

{ get incoming cmd and params }
procedure GetPostedVars;
  { first handle macrovars, exe can be installed relative to document root }
  procedure FilterMacroVar(var s: string);
  begin
    s:= SubstrReplace(s, '{$DOCROOT}', CgiEnvVar.DocRoot() );
    s:= SubstrReplace(s, '$DOCROOT', CgiEnvVar.DocRoot() );
  end;

begin
  htmform.cmd:= GetCgiVar_S('ed1', 0);
  FilterMacroVar(htmform.cmd);
end;

{ process command, notify it was attempted }
procedure ProcessCommand;
begin
  RunAndShowCmd(htmform.cmd);
  Notify;
end;

procedure Setup;
begin
  GetPostedVars;
  // setup $remembercmd macro var for later use with OutF or TemplateOut
  setvar('remembercmd', htmform.cmd);
end;

begin
  StartPage;
  Setup;
  JotForm;
  if FormPosted then ProcessCommand;
  EndPage;
end.
