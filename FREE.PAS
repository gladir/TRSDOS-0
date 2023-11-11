{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/trsdos-0)
  @abstract(Target: Turbo Pascal 7, Free Pascal 3.2)
}

Program FREE;

Uses DOS;

Var
 LabelName,FirstParam:String;
 I:Integer;

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
 FirstParam:=ParamStr(1);
 If FirstParam='/?'Then Begin
  WriteLn('FREE  Cette commande permet d''afficher l''espace de libre ',
                 'sur les unit‚s.');
  WriteLn;
  WriteLn('Syntaxe:');
  WriteLn;
  WriteLn('FREE [/?]');
 End
  Else
 Begin
  For I:=0 to 3 do Begin
   If DiskSize(I+1)=-1Then Begin
    WriteLn('Disque :',I,'  [Pas disque]');
   End
    Else
   Begin
    Write('Disque :',I,'  ');
    LabelName:=GetDiskLabel(I+1);
    If LabelName=''Then Write('PAS NOM ')
                   Else Write(LabelName:8);
    Write('  Espace libre = ',(DiskFree(I+1)/1024):0:2,'K/  ',(DiskSize(I+1)/1024):0:2,'K');
    WriteLn;
   End;
  End;
 End;
END.