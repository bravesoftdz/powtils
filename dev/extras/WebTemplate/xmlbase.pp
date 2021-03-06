// ~NRCOL

{****************************************************
 See Licence.txt for details
 Copyright(C) 2007 2008 - Jorge Aldo G. de F. Junior
 Colaborators:
 <put your name here if you improve this software>
*****************************************************}

Unit XMLBase;

Interface

Uses
  Classes,
  PWMain,
  SysUtils,
  Variants;

Type
  EXMLBase = Class(Exception);

  TXMLTag = Class;

  TXMLNode = Procedure(Caller : TXMLTag);

  TXMLNodeEntry = Record
    Name       : String;
    Controller : TXMLNode;
  End;

  TXMLNodeList = Class
  Private
    fNodes : Array Of TXMLNodeEntry;
    Function GetNode(Name : String): TXMLNode;
    Procedure SetNode(Name : String; Controller : TXMLNode);
  Public
    Function Find(Name : String): Boolean;
    Property Nodes[Name : String]: TXMLNode Read GetNode Write SetNode; Default;
  End;

  TXMLRootTag = Class(TObject)
  Public
    Procedure Emit; Virtual; Abstract;
  End;

  TXMLTagCollection = Class(TXMLRootTag)
  Protected
    fChilds: Array Of TXMLRootTag;
    fCurrent: LongWord;
    Function GetChild(I: LongWord): TXMLRootTag;
    Function GetCurrentChild: TXMLRootTag;
  Public
    Procedure Emit; Override;
    Procedure AppendChild(Child: TXMLRootTag);
    Property Childs[Index: LongWord]: TXMLRootTag Read GetChild;
    Property Child: TXMLRootTag Read GetCurrentChild;
    Function GetCount: longword;
    Function Position: LongWord;
    Function EndOfChilds: Boolean;
    Procedure First;
    Procedure Next;
    Procedure EmitChildsIf(Name : String);
  End;

  TXMLTag = Class(TXMLTagCollection)
  Protected
    fTagName:    String;
    fClosing:    Boolean;
    fAttributes: TStringList;
    fNodeController: TXMLNode;
  Public
    Constructor Create(Name: String; Closing: Boolean; NodeCtrl: TXMLNode);
    Destructor Destroy; Override;
    Procedure Emit; Override;
    Procedure EmitChilds;
    Procedure StartEmit;
    Procedure EndEmit;
    Function HasChilds: Boolean;
    Property Attributes: TStringList
      Read fAttributes;
    Property Name : String Read fTagName;
    Function IsAttribute(Name : String): Boolean;
    Function GetAttribute(Name : String): String;
  End;

  TXMLText = Class(TXMLRootTag)
  Protected
    fText: Ansistring;
  Public
    Constructor Create(T: Ansistring);
    Procedure Emit; Override;
  End;

Implementation

Function UnQuote(Line : String): String;
Begin
  UnQuote := Copy(Line, 2, Length(Line) - 2);
End;

Function TXMLTagCollection.GetChild(I: LongWord): TXMLRootTag;
Begin
  If (I >= Low(fChilds)) And (I <= High(fChilds)) Then
    GetChild := fChilds[I]
  Else
    Begin
    GetChild := nil;
    Raise EXMLBase.Create('Theres no child number ' + IntToStr(I) +
      ' in this tag collection.');
    End;
End;

Function TXMLTagCollection.GetCurrentChild: TXMLRootTag;
Begin
  GetCurrentChild := GetChild(fCurrent);
End;

Procedure TXMLTagCollection.Emit;
Var
  Ctrl: LongWord;
Begin
  If Length(fChilds) > 0 Then
    For Ctrl := Low(fChilds) To High(fChilds) Do
      fChilds[Ctrl].Emit;
End;

Procedure TXMLTagCollection.AppendChild(Child: TXMLRootTag);
Begin
  SetLength(fChilds, Length(fChilds) + 1);
  fChilds[High(fChilds)] := Child;
End;

Function TXMLTagCollection.GetCount: longword;
Begin
  GetCount := Length(fChilds);
End;

Function TXMLTagCollection.Position: LongWord;
Begin
  Position := fCurrent;
End;

Function TXMLTagCollection.EndOfChilds: Boolean;
Begin
  EndOfChilds := fCurrent >= GetCount;
End;

Procedure TXMLTagCollection.First;
Begin
  fCurrent := Low(fChilds);
End;

Procedure TXMLTagCollection.Next;
Begin
  Inc(fCurrent);
End;

Procedure TXMLTagCollection.EmitChildsIf(Name : String);
Var
  Ctrl: LongWord;
Begin
  If Length(fChilds) > 0 Then
    For Ctrl := Low(fChilds) To High(fChilds) Do
      If (Child Is TXMLTag) And ((Child As TXMLTag).Name = Name) Then
        (Child As TXMLTag).Emit;
End;

Constructor TXMLTag.Create(Name: String; Closing: Boolean; NodeCtrl: TXMLNode);
Begin
  Inherited Create;
  fTagName := Name;
  fClosing := Closing;
  fNodeController := NodeCtrl;
  fAttributes := TStringList.Create;
  fAttributes.Delimiter := ' ';
  fAttributes.QuoteChar := '"';
  fAttributes.CaseSensitive := False;
  fAttributes.Duplicates := dupIgnore;
  fAttributes.Sorted := False;
End;

Destructor TXMLTag.Destroy;
Begin
  fAttributes.Free;
  Inherited Destroy;
End;

Procedure TXMLTag.StartEmit;
Begin
  Out('<' + fTagName);
  If fAttributes.Count > 0 Then
    OutF(' ' + fAttributes.DelimitedText);
  If fClosing Then
    Out('>')
  Else
    Out('/>');
End;

Procedure TXMLTag.EndEmit;
Begin
  If fClosing Then
    Out('</' + fTagName + '>');
End;

Procedure TXMLTag.Emit;
Begin
  If Not(Assigned(fNodeController)) Then
  Begin
    StartEmit;
    EmitChilds;
    EndEmit;
  End
  Else
    fNodeController(Self);
End;

Procedure TXMLTag.EmitChilds;
Begin
  If HasChilds Then
    Inherited Emit;
End;

Function TXMLTag.HasChilds: Boolean;
Begin
  HasChilds := Length(fChilds) > 0;
End;

Function TXMLTag.IsAttribute(Name : String): Boolean;
Begin
  IsAttribute := fAttributes.IndexOfName(Name) > -1;
End;

Function TXMLTag.GetAttribute(Name : String): String;
Begin
  If IsAttribute(Name) Then
    GetAttribute := UnQuote(fAttributes.Values[Name])
  Else
    GetAttribute := '';
End;

Constructor TXMLText.Create(T: Ansistring);
Begin
  Inherited Create;
  fText := T;
End;

Procedure TXMLText.Emit;
Begin
  OutF(fText);
End;

Function TXMLNodeList.GetNode(Name : String): TXMLNode;
Var
	Ctrl  : Cardinal;
	Found : Boolean;
Begin
	Found := False;
	GetNode := Nil;
	For Ctrl := Low(fNodes) To High(fNodes) Do
		If fNodes[Ctrl].Name = Name Then
		Begin
			GetNode := fNodes[Ctrl].Controller;
			Found := True;
			Exit;
		End;
	If Not(Found) Then
		Raise EXMLBase.Create('No node controller named ' + Name + ' found !');
End;

Procedure TXMLNodeList.SetNode(Name : String; Controller : TXMLNode);
Var
	Ctrl  : LongWord;
	Found : Boolean;
Begin
        Found := False;
        If Length(fNodes) > 0 Then
          For Ctrl := Low(fNodes) To High(fNodes) Do
		If fNodes[Ctrl].Name = Name Then
		Begin
			fNodes[Ctrl].Controller := Controller;
			Found := True;
			Exit;
		End;
	If Not(Found) Then
	Begin
		SetLength(fNodes, Length(fNodes) + 1);
		fNodes[High(fNodes)].Name := Name;
		fNodes[High(fNodes)].Controller := Controller;
	End;
End;

Function TXMLNodeList.Find(Name : String): Boolean;
Var
	Ctrl : Cardinal;
Begin
  Find := False;
	For Ctrl := Low(fNodes) To High(fNodes) Do
		If fNodes[Ctrl].Name = Name Then
		Begin
			Find := True;
			Exit;
		End;
End;

End.
