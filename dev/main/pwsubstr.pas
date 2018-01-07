{*******************************************************************************

                           Powtils Substrings

********************************************************************************

  Some algorithms for working with AnsiStrings

  Authors/Credits: Trustmaster (Vladimir Sibirov), L505 (Lars Olson)
  License: Artistic
********************************************************************************}

unit pwsubstr;

{$IFDEF FPC}{$MODE OBJFPC}{$H+}
   {$IFDEF EXTRA_SECURE}{$R+}{$Q+}{$CHECKPOINTER ON}{$ENDIF}
{$ENDIF}

interface
uses pwtypes;


function SubExists(const str, sub: ansistring): boolean;
function SubIexists(const str, sub: ansistring): boolean;
function SubPos(const str, sub: ansistring): int32;
function SubIpos(const str, sub: ansistring): int32;
function SubRpos(const str, sub: ansistring): int32;
function SubIrpos(const str, sub: ansistring): int32;
function SubCount(const str, sub: ansistring): int32;
function SubIcount(const str, sub: ansistring): int32;
function SubReplace(const str, sub, repl: ansistring): ansistring;
function SubIreplace(const str, sub, repl: ansistring): ansistring;
function SubStrip(const str, sub: ansistring): ansistring;
function SubIstrip(const str, sub: ansistring): ansistring;
function SubSplit(const str, delimiter: ansistring): TStrArray;
function SubIsplit(const str, delimiter: ansistring): TStrArray;
function StrComp(const str1, str2: ansistring): shortint;
function StrIcomp(const str1, str2: ansistring): shortint;
function StrNcomp(const str1, str2: ansistring): shortint;
function StrInComp(const str1, str2: ansistring): shortint;
function StrConvInt(const str: ansistring): int32;
function StrConvFloat(const str: ansistring): double;
function StrIsInt(const str: ansistring): boolean;
function StrIsFloat(const str: ansistring): boolean;
function StrReverse(const str: ansistring): ansistring;
function StrTrimLeft(const str: ansistring): ansistring;
function StrTrimRight(const str: ansistring): ansistring;
function StrTrim(const str: ansistring): ansistring;
function LeftStr(const s: ansistring; const cnt: integer): ansistring; {$IFDEF FPC}inline;{$ENDIF}


//backwards compatibility
const
  SubstrExists: function(const str, sub: ansistring): boolean =        {$IFDEF FPC}@{$ENDIF}   SubExists  ;
  SubstrIexists: function(const str, sub: ansistring): boolean =       {$IFDEF FPC}@{$ENDIF}   SubIexists ;
  SubstrPos: function(const str, sub: ansistring): int32 =           {$IFDEF FPC}@{$ENDIF}   SubPos     ;
  SubstrIpos: function(const str, sub: ansistring): int32 =          {$IFDEF FPC}@{$ENDIF}   SubIpos    ;
  SubstrRpos: function(const str, sub: ansistring): int32 =          {$IFDEF FPC}@{$ENDIF}   SubRpos    ;
  SubstrIrpos: function(const str, sub: ansistring): int32 =         {$IFDEF FPC}@{$ENDIF}   SubIrpos   ;
  SubstrCount: function(const str, sub: ansistring): int32 =         {$IFDEF FPC}@{$ENDIF}   SubCount   ;
  SubstrIcount: function(const str, sub: ansistring): int32 =        {$IFDEF FPC}@{$ENDIF}   SubIcount  ;
  SubstrReplace: function(const str, sub, repl: ansistring): ansistring =  {$IFDEF FPC}@{$ENDIF}   SubReplace ;
  SubstrIreplace: function(const str, sub, repl: ansistring): ansistring = {$IFDEF FPC}@{$ENDIF}   SubIreplace;
  SubstrStrip: function(const str, sub: ansistring): ansistring =          {$IFDEF FPC}@{$ENDIF}   SubStrip   ;
  SubstrIstrip: function(const str, sub: ansistring): ansistring =         {$IFDEF FPC}@{$ENDIF}   SubIstrip  ;
  SubstrSplit: function(const str, delimiter: ansistring): TStrArray = {$IFDEF FPC}@{$ENDIF}   SubSplit   ;
  SubstrIsplit: function(const str, delimiter: ansistring): TStrArray ={$IFDEF FPC}@{$ENDIF}   SubIsplit  ;

implementation

{$ifndef fpc} // Delphi 5 compat: function val(): boolean; overload;
uses sysutils;
{$endif}

const
  STR_CONST_DIGITS = '1234567890';
  STR_CONST_INT = '-1234567890';

function LeftStr(const s: ansistring; const cnt: integer): ansistring; {$IFDEF FPC}inline;{$ENDIF}
begin result:= copy(s, 1, cnt);
end;

// Finds if sub exists in str
function SubExists(const str, sub: ansistring): boolean;
begin
  if substrpos(str, sub) > 0 then result:= true
  else result:= false;
end;

// Case insensitive substr_exists
function SubiExists(const str, sub: ansistring): boolean;
begin
  if substrpos(lowercase(str), lowercase(sub)) > 0 then result:= true
  else result:= false;
end;

// Returns position of first occurance of sub in str
// I know, pos() exists, but this is done to see the logic
function SubPos(const str, sub: ansistring): int32;
var spos, len, sublen: int32;
begin
  result:= 0;
  spos:= 1;
  len:= length(str);
  sublen:= length(sub);
  while (spos + sublen - 1) <= len do if copy(str, spos, sublen) = sub then 
  begin
    result:= spos;
    break;
  end
    else inc(spos);
end;

// Case insensitive substrpos
function SubIpos(const str, sub: ansistring): int32;
begin result:= SubPos(lowercase(str), lowercase(sub));
end;

// Returns position of last occurance of sub in str
// Ha-ha, you won't find it in system unit :)
function SubRpos(const str, sub: ansistring): int32;
var spos, len, sublen: int32;
begin
  result:= 0;
  len:= length(str);
  sublen:= length(sub);
  spos:= len - sublen + 1;
  while spos > 0 do
    if copy(str, spos, sublen) = sub then begin
      result:= spos;
      break;
    end
      else dec(spos);
end;

// Case insensitive substrrpos
function SubiRPos(const str, sub: ansistring): int32;
begin result:= subrpos(lowercase(str), lowercase(sub));
end;

// Returns number of occurances of sub in str
function SubCount(const str, sub: ansistring): int32;
var temp: ansistring;
    sublen: int32;
begin
  result:= 0;
  temp:= str;
  sublen:= length(sub);
  while pos(sub, temp) > 0 do begin
    inc(result);
    delete(temp, pos(sub, temp), sublen);
  end;
end;

// Case insensitive SubstrCount
function SubIcount(const str, sub: ansistring): int32;
begin result:= subcount(lowercase(str), lowercase(sub));
end;

// Replaces all the sub substrings in str with repl substrings
function SubReplace(const str, sub, repl: ansistring): ansistring;
var posn, sublen, len, replen: int32;
begin
  result:= str;
  posn:= 1;
  sublen:= length(sub);
  replen:= length(repl);
  repeat
    if copy(result, posn, sublen) = sub then begin
      delete(result, posn, sublen);
      insert(repl, result, posn);
      posn:= posn + replen;
    end
      else inc(posn);
    len:= length(result);
  until posn > len;
end;

// Case insensitive substrreplace
function SubIreplace(const str, sub, repl: ansistring): ansistring;
var posn, sublen, len, replen: int32;
    lsub: ansistring;
begin
  result:= str;
  posn:= 1;
  sublen:= length(sub);
  replen:= length(repl);
  lsub:= lowercase(sub);
  repeat
    if lowercase(copy(result, posn, sublen)) = lsub then begin
      delete(result, posn, sublen);
      insert(repl, result, posn);
      posn:= posn + replen;
    end 
      else inc(posn);
    len:= length(result);
  until posn > len;
end;

// Removes all occurances of sub in the string
function SubStrip(const str, sub: ansistring): ansistring;
var len: int32;
begin
  result:= str;
  len:= length(sub);
  while pos(sub, result) > 0 do delete(result, pos(sub, result), len);
end;

// Case insensitive substrstrip
function SubIstrip(const str, sub: ansistring): ansistring;
var len, posn: int32;
begin
  result:= str;
  len:= length(sub);
  repeat
    posn:= pos(lowercase(sub), lowercase(result));
    if posn > 0 then delete(result, posn, len);
  until posn <= 0;
end;

// Splits str into array by string delimiter
function SubSplit(const str, delimiter: ansistring): TStrArray;
var temp: ansistring;
    i, len: int32;
begin
  SetLength(result, 0);
  temp:= str;
  len:= length(delimiter);
  i:= 1;
  // Splitting while delemiter presents in temp
  while pos(delimiter, temp) > 0 do begin
    i:= pos(delimiter, temp);
    SetLength(result, length(result) + 1);
    result[length(result) - 1]:= copy(temp, 1, i - 1);
    delete(temp, 1, (i - 1) + len);
  end;
  // Just copying the last part
  SetLength(result, length(result) + 1);
  result[length(result) - 1]:= temp;
end;

// Case insensitive strsplit
function SubIsplit(const str, delimiter: ansistring): TStrArray;
var temp: ansistring;
    i, len: int32;
begin
  SetLength(result, 0);
  temp:= str;
  len:= length(delimiter);
  i:= 1;
  // Splitting while delemiter presents in temp
  while pos(lowercase(delimiter), lowercase(temp)) > 0 do begin
    i:= pos(lowercase(delimiter), lowercase(temp));
    SetLength(result, length(result) + 1);
    result[length(result) - 1]:= copy(temp, 1, i - 1);
    delete(temp, 1, (i - 1) + len);
  end;
  // Just copying the last part
  SetLength(result, length(result) + 1);
  result[length(result) - 1]:= temp;
end;

// String comparsion
function StrComp(const str1, str2: ansistring): shortint;
var
  i, lim: int32;
begin
  result:= 0;
  if length(str1) > length(str2) then lim:= length(str1)
  else lim:= length(str2);
  for i:= 1 to lim do begin
    if ord(str1[i]) > ord(str2[i]) then begin result:= 1; break; end;
    if ord(str1[i]) < ord(str2[i]) then begin result:= -1; break; end;
  end;
  if (result = 0) and (length(str1) > length(str2)) then result:= 1;
  if (result = 0) and (length(str1) < length(str2)) then result:= -1;
end;

// String comparsion, case insensitive
function StrIcomp(const str1, str2: ansistring): shortint;
begin result:= strcomp(lowercase(str1), lowercase(str2));
end;

// String comparsion, natural algoritm
function StrNcomp(const str1, str2: ansistring): shortint;
var i, j, len1, len2, num1, num2: int32;
    lex1, lex2, lex3, lex4: ansistring;
    sub: shortint;
    err: integer;
begin
  result:= 0;
  i:= 1;
  j:= 1;
  len1:= length(str1);
  len2:= length(str2);
  while (i <= len1) and (j <= len2) do
  begin
    if (pos(str1[i], STR_CONST_DIGITS) > 0) 
      and (pos(str2[j], STR_CONST_DIGITS) > 0) 
    then begin
      // Natural number comparsion
      lex1:= '';
      while (i <= len1) and (pos(str1[i], STR_CONST_DIGITS) > 0) do begin
        SetLength(lex1, length(lex1) + 1);
        lex1[length(lex1)]:= str1[i];
        inc(i);
      end;
      val(lex1, num1, err);
      if err <> 0 then exit;
      lex1:= '';
      while (j <= len2) and (pos(str2[j], STR_CONST_DIGITS) > 0) do begin
        SetLength(lex1, length(lex1) + 1);
        lex1[length(lex1)]:= str2[j];
        inc(j);
      end;
      val(lex1, num2, err);
      if err <> 0 then exit;
      if num1 > num2 then begin result:= 1; break; end;
      if num1 < num2 then begin result:= -1; break; end;
    end else
    begin
      // Alpha order comparsion
      lex1:= '';
      // Getting numeric part if exists
      while (i <= len1) and (pos(str1[i], STR_CONST_DIGITS) > 0) do begin
        SetLength(lex1, length(lex1) + 1);
        lex1[length(lex1)]:= str1[i];
        inc(i);
      end;
      lex3:= '';
      // Then getting the string part
      while (i <= len1) and (pos(str1[i], STR_CONST_DIGITS) <= 0) do begin
        SetLength(lex3, length(lex3) + 1);
        lex3[length(lex3)]:= str1[i];
        inc(i);
      end;
      lex2:= '';
      // Getting numeric part if exists
      while (j <= len2) and (pos(str2[j], STR_CONST_DIGITS) > 0) do begin
        SetLength(lex2, length(lex2) + 1);
        lex2[length(lex2)]:= str2[j];
        inc(j);
      end;
      lex4:= '';
      // Then getting the string part
      while (j <= len2) and (pos(str2[j], STR_CONST_DIGITS) <= 0) do begin
        SetLength(lex4, length(lex4) + 1);
        lex4[length(lex4)]:= str2[j];
        inc(j);
      end;
      if lex3 = lex4 then
      begin
        // Natural hint
        val(lex1, num1, err);
        if err <> 0 then exit;
        val(lex2, num2, err);
        if err <> 0 then exit;
        if num1 > num2 then begin result:= 1; break; end;
        if num1 < num2 then begin result:= -1; break; end;
        if num1 = num2 then begin result:= 0; continue; end;
      end;
      sub:= strcomp(lex1, lex2);
      if sub > 0 then begin result:= 1; break; end;
      if sub < 0 then begin result:= -1; break; end;
    end;
  end;
end;

// String comparsion, natural algoritm, case insensitive
function StrIncomp(const str1, str2: ansistring): shortint;
begin
  result:= strncomp(lowercase(str1), lowercase(str2));
end;

// Converts a string into int else returns zero
function StrConvInt(const str: ansistring): int32;
var err: integer;
begin
  result:= 0;
  if strisint(str) then val(str, result, err);
  if err <> 0 then begin result:= 0; exit; end;
end;

// Converts a string into float it is a real float
function StrConvFloat(const str: ansistring): double;
var err: integer;
begin
  result:= 0.0;
  if strisfloat(str) then val(str, result, err);
  if err <> 0 then begin
    result:= 0.0;
    exit;
  end;
end;

// Whether it is a string representation of integer type
function StrIsInt(const str: ansistring): boolean;
var i: int32;
begin
  result:= true;
  for i:= 1 to length(str) do
    if pos(str[i], STR_CONST_INT) = 0 then begin result:= false; break; end;
end;

// Whether it is a string representation of float type
function StrIsFloat(const str: ansistring): boolean;
var i, p: int32;
    tmp: ansistring;
begin
  p:= pos('.', str);
  if p <= 0 then
  begin
    result:= false;
    exit;
  end;
  result:= true;
  tmp:= copy(str, 1, p - 1);
  for i:= 1 to length(tmp) do
    if pos(tmp[i],STR_CONST_DIGITS) <= 0 then begin result:= false; break; end;
  tmp:= copy(str, p + 1, length(str) - p);
  for i:= 1 to length(tmp) do
    if pos(tmp[i],STR_CONST_DIGITS) <= 0 then begin result:= false; break; end;
end;

// Returns reversed string
function StrReverse(const str: ansistring): ansistring;
var i, len: int32;
begin
  len:= length(str);
  SetLength(result, len);
  for i:= 1 to len do result[i]:= str[len - i + 1];
end;

// Removes whitespaces and tab chars from the beginning of the line
function StrTrimLeft(const str: ansistring): ansistring;
var i: int32;
begin
  i:= 0;
  while (str[i + 1] = #32) or (str[i + 1] = #9) do inc(i);
  result:= copy(str, i + 1, length(str) - i);
end;

// Removes whitespaces and tab chars from the end of the line
function StrTrimRight(const str: ansistring): ansistring;
var i, len: int32;
begin
  len:= length(str);
  i:= 0;
  while (str[len - i] = #32) or (str[len - i] = #9) do inc(i);
  result:= copy(str, 1, len - i);
end;

// Removes whitespaces and tab chars from beginning and end of the line
function StrTrim(const str: ansistring): ansistring;
begin result:= strtrimright(strtrimleft(str));
end;



end.
