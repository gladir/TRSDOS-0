{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/trsdos-0)
  @abstract(Target: Turbo Pascal 7, Free Pascal 3.2)
}

Program VERIFY;

Uses DOS;

Var
 X:Boolean;

Function StrToUpper(S:String):String;
Var
 I:Byte;
Begin
 For I:=1 to Length(S)do Begin
  If S[I] in['a'..'z']Then S[I]:=Chr(Ord(S[I])-32);
 End;
 StrToUpper:=S;
End;

BEGIN
 If ParamStr(1)='/?'Then Begin
  WriteLn('VERIFY  : Cette commande permet de fixer ou de demander l''‚tat du ',
          'drapeau de v‚rification de lecture de secteur d''unite ',
          'd''allocation du systŠme d''exploitation.');
  WriteLn;
  WriteLn('Syntaxe:');
  WriteLn;
  WriteLn('VERIFY [/?] [(OFF)|(ON)]');
  WriteLn;
  WriteLn('  /?    Ce parametre permet d''afficher l''aide sur cette commande');
  WriteLn(' (OFF)  Ce parametre permet d''activer la verification');
  WriteLn(' (ON)   Ce parametre permet de desactiver la verification');
 End
  Else
 If StrToUpper(ParamStr(1))='(OFF)'Then SetVerify(False) Else
 If StrToUpper(ParamStr(1))='(ON)'Then SetVerify(True)
  Else
 Begin
  GetVerify(X);
  Write('VERIFY = ');
  If(X)Then WriteLn('on')
       Else WriteLn('off');
 End;
END.