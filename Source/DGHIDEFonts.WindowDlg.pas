(**
  
  This module contains a dialogue for configuring which windiws in the IDE are updated.

  @Author  David Hoyle
  @Version 1.0
  @Date    09 Jun 2018
  
**)
Unit DGHIDEFonts.WindowDlg;

Interface

Uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.ComCtrls;

Type
  (** A class which presents a form for querying the user for the windows to update. **)
  TfrmWindowDlg = Class(TForm)
    Label1: TLabel;
    lvWindowList: TListView;
    cbxFontName: TComboBox;
    edtFontSize: TEdit;
    udFontSize: TUpDown;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    chkParentFont: TCheckBox;
  Strict Private
  Strict Protected
    Procedure InitialiseDlg(Const slWindowList : TStringList; Var strFontName : String;
      Var iFontSize : Integer; Var boolParentFont : Boolean);
    Procedure FinaliseDlg(Const slWindowList : TStringList; Var strFontName : String;
      Var iFontSize : Integer; Var boolParentFont : Boolean);
  Public
    { Public declarations }
    Class Function Execute(Const slWindowList : TStringList; Var strFontName : String;
      Var iFontSize : Integer; Var boolParentFont : Boolean) : Boolean;
  End;

Implementation

Uses
  System.Math;

{$R *.dfm}

(**

  This method displays the window list dialogue to allow the user to select the window he or she wishes 
  the change the font size of.

  @precon  slWindowList must be a valid instance.
  @postcon The dialogue is displayed.

  @param   slWindowList   as a TStringList as a constant
  @param   strFontName    as a String as a reference
  @param   iFontSize      as an Integer as a reference
  @param   boolParentFont as a Boolean as a reference
  @return  a Boolean

**)
Class Function TfrmWindowDlg.Execute(Const slWindowList: TStringList; Var strFontName: String;
  Var iFontSize: Integer; Var boolParentFont : Boolean): Boolean;

Var
  F: TfrmWindowDlg;

Begin
  Result := False;
  F := TfrmWindowDlg.Create(Application.MainForm);
  Try
    F.InitialiseDlg(slWindowList, strFontName, iFontSize, boolParentFont);
    If F.ShowModal = mrOK Then
      Begin
        F.FinaliseDlg(slWindowList, strFontName, iFontSize, boolParentFont);
        Result := True;
      End;
  Finally
    F.Free;
  End;
End;

(**

  This method reads the dialogues controls and updates the window list and font name an size accordingly.

  @precon  slWindowList must be a valid instance.
  @postcon The window list and font name and size parameters are updated.

  @param   slWindowList   as a TStringList as a constant
  @param   strFontName    as a String as a reference
  @param   iFontSize      as an Integer as a reference
  @param   boolParentFont as a Boolean as a reference

**)
Procedure TfrmWindowDlg.FinaliseDlg(Const slWindowList : TStringList; Var strFontName : String;
  Var iFontSize : Integer; Var boolParentFont : Boolean);
var
  i: Integer;
  
Begin
  boolParentFont := chkParentFont.Checked;
  strFontName := cbxFontName.Text;
  iFontSize := udFontSize.Position;
  For i := 0 To slWindowList.Count - 1 Do
    slWindowList.Objects[i] := TObject(IfThen(lvWindowList.Items[i].Checked, 1, 0));
End;

(**

  This method loads the dialogue with a list of window names and class names and sets the font name and 
  size controls.

  @precon  slWindowList must be a valid instance.
  @postcon The dialogue is initialised.

  @param   slWindowList   as a TStringList as a constant
  @param   strFontName    as a String as a reference
  @param   iFontSize      as an Integer as a reference
  @param   boolParentFont as a Boolean as a reference

**)
Procedure TfrmWindowDlg.InitialiseDlg(Const slWindowList : TStringList; Var strFontName : String;
  Var iFontSize : Integer; Var boolParentFont : Boolean);

Var
  i: Integer;
  ListItem: TListItem;

Begin
  chkParentFont.Checked := boolParentFont;
  For i := 0 To Screen.Fonts.Count - 1 Do
    cbxFontName.Items.Add(Screen.Fonts[i]);
  cbxFontName.ItemIndex := cbxFontName.Items.IndexOf(strFontName);
  udFontSize.Position := iFontSize;
  lvWindowList.Items.BeginUpdate;
  Try
    For i := 0 To slWindowList.Count - 1 Do
      Begin
        ListItem := lvWindowList.Items.Add;
        ListItem.Caption := slWindowList.Names[i];
        ListItem.SubItems.Add(slWindowList.ValueFromIndex[i]);
        ListItem.Checked := Assigned(slWindowList.Objects[i]);
      End;
  Finally
    lvWindowList.Items.EndUpdate;
  End;
End;

End.
