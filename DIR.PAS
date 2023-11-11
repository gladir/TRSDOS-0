{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/trsdos-0)
  @abstract(Target: Turbo Pascal 7, Free Pascal 3.2)
}

Program DIR;

Uses DOS;

Const
 Mon:Array[1..12]of String[3]=('Jan','Fev','Mar','Avr','Mai','Jui',
                               'Jul','Aou','Sep','Oct','Nov','Dec');
Var
 P:Byte;
 NumFiles:LongInt;
 Info:SearchRec;
 T:DateTime;
 Option:Set of (Pause,Subdirectory,Lower,Brief,Description);
 Column:Set Of (Double,Width);
 TotalNumFiles,TotalSize:LongInt;
 CurrName,CurrParam,ShowDir,CurrLabel:String;
 CurrDrive:Char;

Function PadRight(S:String;Space:Byte):String;
Var
 I:Byte;
Begin
 If Length(S)<Space Then For I:=Length(S)+1 to Space do S:=S+' ';
 PadRight:=S;
End;

Function PadZeroLeft(Value:Integer;Space:Byte):String;
Var
 S:String;
Begin
 Str(Value,S);
 While Length(S)<Space do S:='0'+S;
 PadZeroLeft:=S;
End;

Procedure ChangeChar(Var Str:String;OldChar,NewChar:Char);
Var
 I:Byte;
Begin
 For I:=1 to Length(Str)do Begin
  If Str[I]=OldChar Then Str[I]:=NewChar;
 End;
End;

Function DuplicateChar(Chr:Char;Count:Byte):String;
Var
 S:String;
 I:Byte;
Begin
 S:='';
 For I:=1 to Count do S:=S+Chr;
 DuplicateChar:=S;
End;

Function Path2Drive(Path:String):Char;Begin
 Path:=FExpand(Path);
 Path2Drive:=Path[1];
End;

Function Path2Ext(Const Path:String):String;
Var
 D:DirStr;
 N:NameStr;
 E:ExtStr;
Begin
 FSplit(Path,D,N,E);
 Path2Ext:=E;
End;

Function GetDiskLabel(Dsk:Byte):String;
Var
 Info:SearchRec;
 CurrentDir:String;
Begin
 If Dsk=0Then GetDir(0,CurrentDir)
         Else CurrentDir:=Char(Dsk+64);
 FindFirst(CurrentDir[1]+':\*.*',VolumeID,Info);
 While DosError=0do Begin
  If(Info.Attr = VolumeID)Then Begin
   GetDiskLabel:=Info.Name;
   Exit;
  End;
  FindNext(Info);
 End;
 GetDiskLabel:=''
End;

BEGIN
 Option:=[];
 Column:=[];
 P:=0;
 ShowDir:='*.*';
 Repeat
  Inc(P);
  CurrParam:=ParamStr(P);
  If Length(CurrParam)=0Then Break;
  If CurrParam='/?'Then Begin
   WriteLn('DIR   Cette commande permet d''afficher le contenu d''un repertoire dans l''unite de disque.');
   WriteLn;
   WriteLn('Syntaxe:');
   WriteLn;
   WriteLn('DIR [/?] [chemin]');
   WriteLn;
   WriteLn(' /?   Ce parametre permet d''afficher l''aide sur cette commande');
   Halt;
  End
   Else
  ShowDir:=CurrParam;
  If P>99Then Break;
 Until CurrParam='';
 CurrDrive:=Path2Drive(ShowDir);
 CurrLabel:=GetDiskLabel(Byte(CurrDrive)-64);
 P:=0;
 FindFirst(ShowDir,AnyFile,Info);
 Write('Unite :',Byte(CurrDrive)-65,', DDEN, Libre = ');
 Write(DiskFree(Byte(CurrDrive)-64)/1024:0:2,'K / ');
 WriteLn(DiskSize(Byte(CurrDrive)-64)/1024:0:2,'K');
 WriteLn('Specfichier  MOD Attr   Prot  LRL  #Enrs   EOF   Taille fichier  Ext  Date mod');
 WriteLn(DuplicateChar('-',79));
 NumFiles:=0;
 While DOSError=0 do Begin
  If Not((Info.Name='.')or(Info.Name='..'))Then Begin
   If(Info.Attr and Directory<>Directory)Then Inc(NumFiles);
   CurrName:=Info.Name;
   ChangeChar(CurrName,'.','/');
   Write(PadRight(CurrName,16));
   If(Info.Attr and ReadOnly=ReadOnly)Then Write('P':7)
                                      Else Write(' ':7);
   Write(' ');
   If Path2Ext(Info.Name)='.EXE'Then Write('EXEC')
                                Else Write('READ');
   Write(' ',256:4);
   Write(Info.Size shr 9:7);
   Write(0:6);
   Write(Info.Size/1024:16:2,'K');
   Write(1:5,' ');
   UnpackTime(Info.Time,T);
   Write(' ',T.Day:2,'-',Mon[T.Month],'-',Copy(PadZeroLeft(T.Year,2),3,2));
   WriteLn;
  End;
  FindNext(Info);
 End;
 WriteLn(DuplicateChar('=',79));
 WriteLn(' ':12,NumFiles,' f1ichiers');
END.
