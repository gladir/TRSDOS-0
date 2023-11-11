{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/trsdos-0)
  @abstract(Target: Turbo Pascal 7, Free Pascal 3.2)
}

Program KILL;

Uses DOS;

Var
 Language:(_French,_English,_Germany,_Italian,_Spain);
 TmpLanguage:String;
 P:Byte;
 Err:Word;
 F:File;
 CurrParam:String;

Function StrToUpper(S:String):String;
Var
 I:Byte;
Begin
 For I:=1 to Length(S)do Begin
  If S[I] in['a'..'z']Then S[I]:=Chr(Ord(S[I])-32);
 End;
 StrToUpper:=S;
End;

Function GetErrorMessage(Code:Word):String;Begin
 Case Code of
  0:GetErrorMessage:='';
  2:GetErrorMessage:='Fichier introuvable';
  3:GetErrorMessage:='Chemin introuvable';
  4:GetErrorMessage:='Trop de fichiers ouvert';
  5:GetErrorMessage:='Acces refuse';
  6:GetErrorMessage:='Handle de fichier invalide';
  12:GetErrorMessage:='Mode d''acces sur disque invalide';
  15:GetErrorMessage:='Num‚ro de disque invalide';
  16:GetErrorMessage:='Impossible de supprimer le r‚pertoire';
  17:GetErrorMessage:='Impossible de renommer sur plusieurs volumes';
  100:GetErrorMessage:='Erreur de lecture … partir du disque';
  101:GetErrorMessage:='Erreur d''ecriture sur le disque';
  102:GetErrorMessage:='Fichier non attribue';
  103:GetErrorMessage:='Le fichier n''est pas ouvert';
  104:GetErrorMessage:='Le fichier n''est pas ouvert … l''entree';
  105:GetErrorMessage:='Le fichier n''est pas ouvert … la sortie';
  106:GetErrorMessage:='Numero invalide';
  150:GetErrorMessage:='Disque protege en ecriture';
  151:GetErrorMessage:='Peripherique est inconnu';
  152:GetErrorMessage:='Disque pas pret';
  153:GetErrorMessage:='Commande inconnue';
  154:GetErrorMessage:='Echec de verification CRC';
  155:GetErrorMessage:='Disque invalide';
  156:GetErrorMessage:='Erreur de recherche sur disque';
  157:GetErrorMessage:='Type de media invalide';
  158:GetErrorMessage:='Secteur introuvable';
  159:GetErrorMessage:='L''imprimante n''a plus de papier';
  160:GetErrorMessage:='Erreur d''ecriture sur le peripherique';
  161:GetErrorMessage:='Erreur de lecture sur le peripherique';
  162:GetErrorMessage:='Defaillance materielle';
  Else GetErrorMessage:='Erreur inconnue';
 End;
End;

BEGIN
 Language:=_French;
 TmpLanguage:=GetEnv('LANGUAGE');
 If TmpLanguage<>''Then Begin
  If TmpLanguage[1]='"'Then TmpLanguage:=Copy(TmpLanguage,2,255);
  If StrToUpper(Copy(TmpLanguage,1,2))='EN'Then Language:=_English Else
  If StrToUpper(Copy(TmpLanguage,1,2))='GR'Then Language:=_Germany Else
  If StrToUpper(Copy(TmpLanguage,1,2))='IT'Then Language:=_Italian Else
  If StrToUpper(Copy(TmpLanguage,1,2))='SP'Then Language:=_Spain;
 End;
 P:=0;
 Repeat
  Inc(P);
  CurrParam:=ParamStr(P);
  If CurrParam=''Then Begin
   If P=1Then Begin
    WriteLn('ParamŠtre requis');
   End;
   Break;
  End
   Else
  If CurrParam='/?'Then Begin
   Case Language of
    _Germany:Begin
     WriteLn('L”scht eine oder mehrere Dateien.');
     WriteLn;
     WriteLn('KILL [/?] Datainame');
    End;
    _English:Begin
     WriteLn('Purpose:  Erase one file');
     WriteLn;
     WriteLn('Format:   KILL [/?] file');
     Exit;
    End;
    Else Begin
     WriteLn('KILL   Cette commande permet d''effectuer la suppression de fichier sur un unit‚ de disque.');
     WriteLn;
     WriteLn('Syntaxe:');
     WriteLn;
     WriteLn('KILL [/?] fichier');
     WriteLn;
     WriteLn('    /?    Ce paramŠtre permet d''afficher l''aide sur cette commande');
     WriteLn(' fichier  Ce paramŠtre permet d''indiquer le nom du fichier a supprimer.');
     Exit;
    End;
   End;
  End;
  {$I-}Assign(F,CurrParam);
  Erase(F);
  {$I+}
  Err:=IoResult;
  If Err=0Then WriteLn('1 fichier de supprime')
          Else WriteLn(GetErrorMessage(Err));
  If P>9Then Break;
 Until CurrParam='';
END.