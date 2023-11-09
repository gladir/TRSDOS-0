{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/trsdos-0)
  @abstract(Target: Turbo Pascal 7, Free Pascal 3.2)
}

Program ATTRIB;

Uses DOS;

Var
 AttrAdd,AttrRemove:Word;
 I:Integer;
 SubDirectory,ReadOnlyFlag:Boolean;

Function PadRight(S:String;Space:Byte):String;
Var
 I:Byte;
Begin
 If Length(S)<Space Then For I:=Length(S)+1 to Space do S:=S+' ';
 PadRight:=S;
End;

Function StrToUpper(S:String):String;
Var
 I:Byte;
Begin
 For I:=1 to Length(S)do Begin
  If S[I] in['a'..'z']Then S[I]:=Chr(Ord(S[I])-32);
 End;
 StrToUpper:=S;
End;

Function Path2Dir(Const Path:String):String;
Var
 D:DirStr;
 N:NameStr;
 E:ExtStr;
Begin
 Path2Dir:='';
 If Path=''Then Exit;
 FSplit(Path,D,N,E);
 If E=''Then Begin
  If D[Length(D)]<>'\'Then D:=D+'\';
  D:=D+E;
 End;
 If D=''Then Path2Dir:='' Else
 If D[Length(D)]<>'\'Then D:=D+'\';
 Path2Dir:=D;
End;

Function SetPath4AddFile(Path:String):String;Begin
 If Path=''Then GetDir(0,Path);
 If Path[Length(Path)]<>'\'Then Path:=Path+'\';
 SetPath4AddFile:=Path;
End;

Procedure SetAttribut(Var F:File);
Var
 CurrAttr:Word;
Begin
 GetFAttr(F,CurrAttr);
 If AttrRemove and ReadOnly=ReadOnly Then CurrAttr:=CurrAttr and Not ReadOnly;
 If AttrRemove and Archive=Archive Then CurrAttr:=CurrAttr and Not Archive;
 If AttrRemove and Hidden=Hidden Then CurrAttr:=CurrAttr and Not Hidden;
 If AttrRemove and SysFile=SysFile Then CurrAttr:=CurrAttr and Not SysFile;

 If AttrAdd and ReadOnly=ReadOnly Then CurrAttr:=CurrAttr or ReadOnly;
 If AttrAdd and Archive=Archive Then CurrAttr:=CurrAttr or Archive;
 If AttrAdd and Hidden=Hidden Then CurrAttr:=CurrAttr or Hidden;
 If AttrAdd and SysFile=SysFile THen CurrAttr:=CurrAttr or SysFile;
 SetFAttr(F,CurrAttr);
End;

Procedure SetAttributFiles(FileSpec:String);
Var
 Info:SearchRec;
 CurrFile:File;
 Found:Boolean;
Begin
 FileSpec:=FExpand(FileSpec);
 FindFirst(FileSpec,AnyFile,Info);
 Found:=False;
 While DOSError=0 do Begin
  Found:=True;
  If Info.Attr and Directory=Directory Then Begin
   If(SubDirectory)Then Begin
    If Not((Info.Name='.')or(Info.Name='..')or(Info.Name=''))Then Begin
     SetAttributFiles(SetPath4AddFile(Path2Dir(FileSpec)+Info.Name)+'*.*');
    End;
   End;
  End
   Else
  Begin
   Assign(CurrFile,Path2Dir(FileSpec)+Info.Name);
   SetAttribut(CurrFile);
  End;
  FindNext(Info);
 End;
 If Not Found Then WriteLn('Aucun resultat trouve');
End;

Procedure ShowAttribut;
Var
 Info:SearchRec;
Begin
 FindFirst('*.*',AnyFile and Not Directory,Info);
 While DOSError=0 do Begin
  Write(PadRight(Info.Name,18));
  If Info.Attr and ReadOnly=ReadOnly Then Write('P') Else Write(' ');
  Write(' ');
  FindNext(Info);
 End;
End;

BEGIN
 If ParamStr(1)='/?'Then Begin
  WriteLn('ATTRIB : Cette commande permet de fixer les attributs de ',
                    'protection');
  WriteLn;
  WriteLn('Syntaxe: ATTRIB [/?]');
  WriteLn('         ATTRIB filespec (PROT=READ)');
  WriteLn;
  WriteLn(' (PROT=READ)  Fixe en lecture seulement');
 End
  Else
 If ParamCount>0Then Begin
  SubDirectory:=False;
  For I:=1 to ParamCount do Begin
   If StrToUpper(ParamStr(I))='(PROT=READ)'Then Begin
    ReadOnlyFlag:=True;
   End;
  End;
  If(ReadOnlyFlag)Then AttrAdd:=ReadOnly
                  Else AttrRemove:=ReadOnly;
  For I:=1 to ParamCount do Begin
   If StrToUpper(ParamStr(I))<>'(PROT=READ)'Then Begin
    SetAttributFiles(ParamStr(I));
   End;
  End;
 End
  Else
 ShowAttribut;
END.