{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/trsdos-0)
  @abstract(Target: Turbo Pascal 7, Free Pascal 3.2)
}

Program LIST(Input,Output);

Var
 I:Integer;
 Handle:Text;
 CurrLine:String;

BEGIN
 If(ParamStr(1)='/?')or(ParamStr(1)='--help')or(ParamStr(1)='-h')or
   (ParamStr(1)='/h')or(ParamStr(1)='/H')Then Begin
  WriteLn('LIST : Cette commande permet d''afficher le contenu du fichier.');
  WriteLn;
  WriteLn('Syntaxe : LIST [fichier]');
 End
  Else
 If ParamCount>0Then Begin
  For I:=1 to ParamCount do Begin
   Assign(Handle,ParamStr(I));
   {$I-}Reset(Handle);{$I+}
   If IOResult=0Then Begin
    While NOT EOF(Handle)do Begin
     ReadLn(Handle,CurrLine);
     WriteLn(CurrLine);
    End;
    Close(Handle);
   End
    Else
   WriteLn('Impossible de lire ',ParamStr(I));
  End;
 End
  Else
 Begin
  Repeat
   ReadLn(Input,CurrLine);
   WriteLn(CurrLine);
  Until EOF;
 End;
END.
