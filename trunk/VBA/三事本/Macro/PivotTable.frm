VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} PivotTable 
   Caption         =   "�s�{�b�g�e�[�u��"
   ClientHeight    =   2010
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   5070
   OleObjectBlob   =   "PivotTable.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "PivotTable"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False




Const filename As String = "Pivot_error.log"
Const msgErr_FieldNotValid As String = "���̃s�{�b�g�e�[�u���̃t�B�[���h���͐���������܂���B�s�{�b�g�e�[�u�� ���|�[�g���쐬����ɂͤ���x���̕t������Ń��X�g�Ƃ��ĕҐ����ꂽ�f�[�^���g�p����K�v������܂���s�{�b�g�e�[�u���̃t�B�[���h����ύX����ꍇ�ͤ�t�B�[���h�̐V�������O����͂���K�v������܂��"
Const msgErr_Reference As String = "�Q�Ƃ�����������܂���B"
Const msgErr_Row As String = "���̃R�}���h�ɂ̓f�[�^ �\�[�X�� 2 �s�ȏ�K�v�ł��B�I�������Z���͈͂� 1 �s�����̏ꍇ�́A���̃R�}���h�����s�ł��܂���B"
Const errMsg As String = "���� �G���["

'****************************************************
'�֐��� �FcmbCancel_Click
'�ϐ�   �F�Ȃ�
'�ԋp   �F�Ȃ�
'�ړI   �F
'�쐬�� �FHuynhTran     ���t�F2011.08.18
'�ύX�� �F              ���t�F
'*************************************************************************
Private Sub cmbCancel_Click()
    Unload Me
End Sub

'****************************************************
'�֐��� �FCreateSheetName
'�ϐ�   �F�Ȃ�
'�ԋp   �F�Ȃ�
'�ړI   �F�V�[�g�����쐬����
'�쐬�� �FHuynhTran     ���t�F2011.08.18
'�ύX�� �F              ���t�F
'*************************************************************************
Private Sub cmbOK_Click()
    Dim namesheet As String '�V�K�̃V�[�g�����i�[����B
    Dim ws As Worksheet
    Dim countCol As Integer
    Dim pos As Integer  '�e�[�u�����쐬����ʒu���i�[����
    Dim c As Integer
    Dim i As Integer
    Dim pvc As PivotCache
    Dim source As String

    Dim rng As Excel.Range
    Dim arrData() As Variant
    Dim lRows As Long
    Dim lCols As Long
    Dim ii As Long, jj As Long
    
    pos = 15
    countCol = 0

     On Error GoTo errMyErrorHandler
     
    
    If refSelectCells.Text = "" Then
     MsgBox msgErr_Reference, vbInformation
     refSelectCells.SetFocus
    Else
    
        'Range(refSelectCells.Text).Select
        If CheckRange(refSelectCells.Text) = False Then
          refSelectCells.SetFocus
          Exit Sub
        End If
        
        '�V�[�g�őI�������s�����i�[����B
        lRows = Selection.Rows.count
        lCols = Selection.Columns.count
        
        If lCols + pos > 255 Then
            MsgBox msgErr_Reference, vbExclamation
            refSelectCells.SetFocus
            Exit Sub
        End If
        
        ReDim arrData(1 To lRows, 1 To lCols)
        
        Set rng = Selection
        arrData = rng.Value
        
        For i = 1 To lCols
            If arrData(1, i) <> "" Then Exit For
        Next i
        
        If i > lCols Then
             MsgBox msgErr_FieldNotValid, vbExclamation
            refSelectCells.SetFocus
            Exit Sub
        End If
    
        'Hide
        '�V�[�g�����쐬����
        namesheet = CreateSheetName()
          
        If namesheet <> "" Then
            '�������V�[�g�ŕ\�������Ȃ�
            Application.ScreenUpdating = False
            
            '�V�[�g��V�K�쐬����B
            Set ws = Sheets.Add
            ws.name = namesheet
            
            If CreateTableForPivot(arrData, countCol, pos) = False Then
                Application.DisplayAlerts = False
                Sheets(namesheet).Delete
                Application.DisplayAlerts = True
                refSelectCells.SetFocus
                 Application.ScreenUpdating = True
                'Unload Me
                Exit Sub
            End If

            '�e�[�u�����쐬����ʒu���i�[����B
            source = namesheet & "!" & "R1C" & pos & ":R" & lRows & "C" & (countCol + pos - 1)
        
            'Check version
            If Application.Version < 12 Then
                'Office 2003
                Set pvc = ActiveWorkbook.PivotCaches.Add(SourceType:=xlDatabase, SourceData:=source)
            Else
                'Office 2007
                Set pvc = ActiveWorkbook.PivotCaches.Create(SourceType:=xlDatabase, SourceData:=source, Version:=xlPivotTableVersion10)
            End If
             
             '�s�{�b�g�e�[�u�����쐬����B
             pvc.CreatePivotTable TableDestination:=Worksheets(namesheet).Range(Cells(1, 1), Cells(1, 1)), _
        TableName:=namesheet, DefaultVersion:=xlPivotTableVersion10
             ActiveWorkbook.ShowPivotTableFieldList = True
             
             '�쐬�����e�[�u�����폜����B
             Range(Cells(1, pos), Cells(lRows, countCol + pos - 1)).Select
             Selection.ClearContents
             
             Range(Cells(1, 1), Cells(1, 1)).Select
             '�\���X�V�̐���
             Application.ScreenUpdating = True
             
             Set rng = Nothing
             '�s�{�b�g�e�[�u���t�H�[�������B
             Unload Me
        Else
            If chkLog.Value = False Then
               MsgBox errMsg
            Else
               Call WriteError(errMsg, ThisWorkbook.Path, filename)
            End If
        End If
       
    End If
 
 
    Exit Sub
    
errMyErrorHandler:
    If chkLog.Value = True Then
        Call WriteError(errMsg, ThisWorkbook.Path, filename)
    End If
    
    MsgBox Err.Description, vbExclamation + vbOKCancel, "Error: " & CStr(Err.Number)
    Err.Clear
    Unload Me
End Sub

'****************************************************
'�֐��� �FCreateSheetName
'�ϐ�   �F�Ȃ�
'�ԋp   �F�V�[�g��
'�ړI   �F�V�[�g�����쐬����
'�쐬�� �FHuynhTran     ���t�F2011.08.18
'�ύX�� �F              ���t�F
'*************************************************************************
Function CreateSheetName() As String
    Dim i As Integer
    Dim wSheet As Worksheet
    Dim name As String
    Dim sh As Worksheet, flg As Boolean
    
    name = "�s�{�b�g�e�[�u��"
    name1 = name
    CreateSheetName = ""
     On Error Resume Next
     For i = 1 To 100
        For Each sh In Worksheets
           If sh.name = name1 Then flg = True: Exit For
        Next
        If flg = True Then
            name1 = name & i
            flg = False
        Else
            CreateSheetName = name1
            Exit Function
        End If
    Next
End Function

'****************************************************
'�֐��� �FCreateTableForPivot
'�ϐ�   �FstrRange
'�ԋp   �F�n�悪���݂���ꍇ�ATrue
'         �n�悪���݂��Ȃ��ꍇ�False
'�ړI   �F�n��̑��݃`�F�b�N�B
'�쐬�� �FHuynhTran     ���t�F2011.08.18
'�ύX�� �F              ���t�F
'****************************************************
Function CheckRange(strRange As String) As Boolean
    Dim i As Integer
    On Error GoTo errMyErrorHandler
    Range(strRange).Select
    If Selection.Rows.count = 1 Then
        MsgBox msgErr_Row, vbExclamation
        CheckRange = False
        Exit Function
    End If
    CheckRange = True
    Exit Function
errMyErrorHandler:
    MsgBox msgErr_Reference, vbInformation
    CheckRange = False
End Function

'****************************************************
'�֐��� �FCreateTableForPivot
'�ϐ�   �FarrData
'         countCol
'         pos
'�ԋp   �F�Ȃ�
'�ړI   �F�B
'�쐬�� �FHuynhTran     ���t�F2011.08.18
'�ύX�� �F              ���t�F
'****************************************************
Private Function CreateTableForPivot(arrData() As Variant, countCol As Integer, pos As Integer)
    Dim countColT As Integer
    On Error GoTo errMyErrorHandler
    
    countColT = UBound(arrData, 2) + pos - 1
    
    If countColT + pos > 255 Then
        MsgBox msgErr_Reference, vbExclamation
        CreateTableForPivot = False
        Exit Function
    End If
    Range(Cells(1, pos), Cells(UBound(arrData, 1), countColT)).Select
    Set rng = Selection
    rng.Value = arrData
    
    '�Z���̒l�� ""�̏ꍇ�A�Y���̗���폜����B
    c = pos
    For i = pos To countColT Step 1
        If Cells(1, c) = "" Then
            Columns(c).Delete
        Else
            c = c + 1
        End If
    Next i
     
    '�󔒈ȊO�̒l�̂���Z���̍��v���i�[����B
    For i = pos To countColT Step 1
        If Cells(1, i) = "" Then
           Exit For
        Else
            countCol = countCol + 1
        End If
    Next i
    
    If countCol < 1 Then
        If chkLog.Value = False Then
            MsgBox msgErr_FieldNotValid, vbExclamation
         Else
            Call WriteError(msgErr_FieldNotValid, ThisWorkbook.Path, filename)
        End If
        
        'Unload Me
        CreateTableForPivot = False
        Exit Function
    ElseIf countCol = 1 Then
        For i = 2 To UBound(arrData, 1) Step 1
            If Cells(i, pos) <> "" Then
               Exit For
            End If
        Next i
        
        If i > UBound(arrData, 1) Then
            MsgBox msgErr_FieldNotValid, vbExclamation
            CreateTableForPivot = False
            Exit Function
        End If
    
    End If
    CreateTableForPivot = True
    Exit Function
    
errMyErrorHandler:

    CreateTableForPivot = False
    If chkLog.Value = True Then
        Call WriteError(errMsg, ThisWorkbook.Path, filename)
    End If
    
    MsgBox Err.Description, vbExclamation + vbOKCancel, "Error: " & CStr(Err.Number)
    Err.Clear
    Unload Me
End Function

'****************************************************
'�֐��� �FUserForm_Initialize
'�ϐ�   �F�Ȃ�
'�ԋp   �F�Ȃ�
'�ړI   �F�B
'�쐬�� �FHuynhTran     ���t�F2011.08.18
'�ύX�� �F              ���t�F
'****************************************************
Private Sub UserForm_Initialize()
    refSelectCells.SetFocus
    refSelectCells.Text = ActiveSheet.name & "!" & Selection.Address
End Sub

'****************************************************
'�֐��� �FWriteError
'�ϐ�   �Fmessage ���O���b�Z�[�W
'         folder ���O�t�H���_
'         filename ���O�t�@�C����
'�ԋp   �F�Ȃ�
'�ړI   �F���O�ɏ������݁B
'�쐬�� �FHuynhTran     ���t�F2011.08.18
'�ύX�� �F              ���t�F
'****************************************************
Public Sub WriteError(message As String, folder As String, filename As String)
        
    Dim logFilePath As String
    
    logFilePath = folder & "\" & filename
        
    Open logFilePath For Append As #1
        
    Print #1, "----------------------------------------------------------------"
    Print #1, " �G���[�̔�����              : " & Application.Text(Now(), "yyyy/MM/dd HH:mm:ss")
    Print #1, " �G���[�ԍ�                    : " & Err.Number
    Print #1, " �G���[�Ɋ֘A���������: " & Err.Description
    Print #1, " �G���[�̔�����              : " & Err.source
    Print #1, " �G���[�̓��e                  : " & message

    Print #1, "----------------------------------------------------------------" & vbNewLine
    
    Close #1

End Sub
