// ~NRCOL
Unit PWVL;

Interface
Uses
  WebApplication,
  WebTemplate,
  XMLBase,
  PWMain,
  Sysutils,
  Classes;

Type
  TArrayGrid = Array Of Array Of String;

  TWebArrayGrid = Class(TWebComponent)
  Private
    fMatrix   : TArrayGrid;
    fCurRow,
    fCurCol   : LongInt;
    Function GridConditionals(Name : String): Boolean;
    Procedure GridRows(Caller : TXMLTag);
    Procedure GridCols(Caller : TXMLTag);
    Procedure GridElement(Caller : TXMLTag);
    Procedure GridEdit;
  Public
    Constructor Create(Name, Tmpl : String; Owner : TWebComponent);
    Property Matrix : TArrayGrid Read fMatrix Write fMatrix;
  End;

Implementation

Function TWebArrayGrid.GridConditionals(Name : String): Boolean;
Begin
  If Name = 'editmode' Then
    GridConditionals := GetCGIVar('action') = 'edit'
  Else
    GridConditionals := False;
End;

Procedure TWebArrayGrid.GridRows(Caller : TXMLTag);
Begin
  fCurRow := Low(fMatrix);
  While fCurRow <= High(fMatrix) Do
  Begin
    Caller.EmitChilds;
    Inc(fCurRow);
  End;
End;

Procedure TWebArrayGrid.GridCols(Caller : TXMLTag);
Begin
  fCurCol := Low(fMatrix[fCurRow]);
  While fCurCol <= High(fMatrix[fCurRow]) Do
  Begin
    Caller.EmitChilds;
    Inc(fCurCol);
  End;
End;

Procedure TWebArrayGrid.GridElement(Caller : TXMLTag);
Begin
  WebWrite(
  '<a href="' + SelfReference + '?action=' + InstanceName + '_edit&' +
  'row=' + IntToStr(fCurRow) + '&col=' + IntToStr(fCurCol) + '">');
  WebWrite(fMatrix[fCurRow][fCurCol]);
  WebWrite('</a>');
End;

Constructor TWebArrayGrid.Create(Name, Tmpl : String; Owner : TWebComponent);
Begin
  Inherited Create(Name, Tmpl, Owner);
  Template.Tag['grid'] := Self.GridRows;
  Template.Tag['gridrow'] := Self.GridCols;
  Template.Tag['gridelement'] := Self.GridElement;
End;

End.
