Attribute VB_Name = "ModuleSort"
Option Explicit

Public Const SHEET_SORT = "�w�EPJ�ꗗ"
Public Const SHEET_REFLECT = "Reflect Pattern"
Public Const NUM_PATTERN = "[0-9]+"
Private Const SORT_BUTTONCAPTION = "�\�[�g"
Private Const SORT_BUTTONNAME = "sortButton"
Private Const SORT_ACTION = "SortButton_Click"

'****************************************************
'�֐��� �FSort
'�ϐ�   �FrowPjBangou�AcolPjBangou
'�ԋp   �F�Ȃ�
'�ړI   �F�\�[�g����B
'�쐬�� �Fphuonghtt     ���t�F2011.08.15
'�ύX�� �F              ���t�F
'****************************************************
Public Sub Sort(rowPjBangou As Long, colPjBangou As Long, key1 As String, asc1 As XlSortOrder, _
    key2 As String, asc2 As XlSortOrder, key3 As String, asc3 As XlSortOrder)
        
    Dim sortSheet As Worksheet      ' �\�[�g�V�[�g
    Dim usedColIdx As Long          ' �e�[�u���̏�Ɏg�p������
    Dim usedRowIdx As Long          ' �e�[�u���̏�Ɏg�p�����s
    Dim haveMergeCell As Boolean    ' �Z�����}�[�W����K�v������܂�
    Dim arrayMergeInfo() As String
    Dim startColumnIdx As Long
    
    ' sortSheet���u�w�EPJ�ꗗ�v�V�[�g�Ƃ��Đݒ肷��B
    Set sortSheet = ActiveWorkbook.Sheets(SHEET_SORT)
    sortSheet.Select
    
    ' usedColIdx���A�g��ꂽ��̐��Ƃ��Đݒ肷��B(UsedRange.Column.Count)
    usedColIdx = sortSheet.UsedRange.Columns.Count
     
    ' usedRowIdx���A�Y���̃e�[�u���̍s�̐��Ƃ��Đݒ肷��B
    usedRowIdx = FindUsedRowIndex(rowPjBangou, colPjBangou)
    
    startColumnIdx = 1
    
    ' �\�[�g����ɂ͑I���͈̔�
    Range(Cells(rowPjBangou - 1, startColumnIdx), Cells(usedRowIdx, usedColIdx)).Select

    haveMergeCell = HaveMergeCellInSelection

    If haveMergeCell Then

        ' ��̃}�[�W�̃��X�g���擾����
        arrayMergeInfo = GetArrayMergeInfo(rowPjBangou - 1, startColumnIdx)

        ' �A���}�[�W
        UnmergeSelection

    End If

    ' ���בւ�
    If key2 = "" And key3 = "" Then
        Selection.Sort key1:=Range(key1 & rowPjBangou - 1), order1:=asc1, Header:=xlYes
    Else
        If key2 <> "" And key3 <> "" Then
            Selection.Sort _
                key1:=Range(key1 & rowPjBangou - 1), order1:=asc1, _
                key2:=Range(key2 & rowPjBangou - 1), order2:=asc2, _
                key3:=Range(key3 & rowPjBangou - 1), order3:=asc3, Header:=xlYes
        Else
            If key2 <> "" Then
                Selection.Sort _
                    key1:=Range(key1 & rowPjBangou - 1), order1:=asc1, _
                    key2:=Range(key2 & rowPjBangou - 1), order2:=asc2, Header:=xlYes
            Else
                Selection.Sort _
                    key1:=Range(key1 & rowPjBangou - 1), order1:=asc1, _
                    key3:=Range(key3 & rowPjBangou - 1), order3:=asc3, Header:=xlYes
            End If
        End If
    End If

    If haveMergeCell Then
        ReMergeSelection arrayMergeInfo, rowPjBangou - 1, usedRowIdx
    End If
        
End Sub

'****************************************************
'�֐��� �FFindUsedRowIndex
'�ϐ�   �FstartRow�AcolumnIdx
'�ԋp   �FLong
'�ړI   �F�g�p�����s�̃C���f�b�N�X��������
'�쐬�� �Fphuonghtt     ���t�F2011.08.13
'�ύX�� �F              ���t�F
'****************************************************
Function FindUsedRowIndex(ByVal startRow As Long, ByVal columnIdx As Long) As Long
    
    Dim cell As Range
    Dim haveFound As Boolean
    Dim maxRow As Long
    
    maxRow = Rows.Count
    
    If startRow > maxRow Then
        FindUsedRowIndex = maxRow
        Exit Function
    End If
    
    Set cell = Cells(startRow, columnIdx)
        
    haveFound = cell.Value = "" And cell.Borders.LineStyle < 0
    
    Do While Not haveFound
        
        '�J�n�̗�Ƀf�[�^���Z�b�g����B
        startRow = startRow + 1
        
        If startRow > maxRow Then
            FindUsedRowIndex = maxRow
            Exit Function
        End If
        
        Set cell = Cells(startRow, columnIdx)
        
        haveFound = cell.Value = "" And cell.Borders.LineStyle < 0
        
    Loop
        
    '�ԋp����B
    FindUsedRowIndex = startRow - 1
    
End Function

'****************************************************
'�֐��� �FHaveMergeCellInSelection
'�ϐ�   �F�Ȃ�
'�ԋp   �FLong
'�ړI   �F�I�𒆂̃Z�����}�[�W�����Ă���
'�쐬�� �Fphuonghtt     ���t�F2011.08.14
'�ύX�� �F              ���t�F
'****************************************************
Function HaveMergeCellInSelection() As Long
    
    Dim cell As Range
    
    For Each cell In Selection
        If cell.MergeCells Then
            HaveMergeCellInSelection = True
            Exit Function
        End If
    Next
    
End Function
 
'****************************************************
'�֐��� �FUnmergeSelection
'�ϐ�   �F�Ȃ�
'�ԋp   �F�Ȃ�
'�ړI   �F�A���}�[�W�Z���N�V����
'�쐬�� �Fphuonghtt     ���t�F2011.08.15
'�ύX�� �F              ���t�F
'****************************************************
Sub UnmergeSelection()
    
    With Selection
        .WrapText = False
        .Orientation = 0
        .AddIndent = False
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = False
    End With

End Sub

'****************************************************
'�֐��� �FReMergeSelection
'�ϐ�   �F�Ȃ�
'�ԋp   �F�Ȃ�
'�ړI   �F�}�[�W��
'�쐬�� �Fphuonghtt     ���t�F2011.08.15
'�ύX�� �F              ���t�F
'****************************************************
Sub ReMergeSelection(arrayMergeInfo() As String, ByVal startRow As Long, ByVal endRow As Long)
    
    Dim info As Variant
    Dim i As Long
    
    'Nothing���`�F�b�N����B
    If IsArrayEmpty(arrayMergeInfo) Then Exit Sub
            
    For i = startRow To endRow
        For Each info In arrayMergeInfo
            If info <> "" Then
                info = RegExpReplace(CStr(info), NUM_PATTERN, CStr(i))
                Range(info).Merge
            End If
        Next
    Next
    
End Sub

'****************************************************
'�֐��� �FGetArrayMergeInfo
'�ϐ�   �F�Ȃ�
'�ԋp   �F�Ȃ�
'�ړI   �F�z��}�[�W���̎擾
'�쐬�� �Fphuonghtt     ���t�F2011.08.16
'�ύX�� �F              ���t�F
'****************************************************
Function GetArrayMergeInfo(ByVal rowIdx As Long, ByVal startColumnIdx As Long) As String()
    
    Dim mergeArrayInfo() As String  ' ����
    Dim n As Long                   '�z��̃T�C�Y
    Dim i As Long

    Dim rng As Range
    Dim rngStart As Range
    Dim rngEnd As Range
    Dim cell As Range
    
    n = 0
    
    For i = startColumnIdx To Selection.Columns.Count
        
        Set cell = Range(Cells(rowIdx, i), Cells(rowIdx, i))
        
        If cell.MergeCells And cell.Text <> "" Then
            
            Set rng = cell.MergeArea
            Set rngStart = rng.Cells(1, 1)
            Set rngEnd = rng.Cells(rng.Rows.Count, rng.Columns.Count)
                
            n = n + 1
            ReDim Preserve mergeArrayInfo(n)
            
            mergeArrayInfo(n) = rngStart.Address & ":" & rngEnd.Address
                    
        End If
    Next
    
    GetArrayMergeInfo = mergeArrayInfo
    
End Function

'****************************************************
'�֐��� �FIsArrayEmpty
'�ϐ�   �FVariant
'�ԋp   �F�Ȃ�
'�ړI   �F�z��͋�ł�
'�쐬�� �Fphuonghtt     ���t�F2011.08.16
'�ύX�� �F              ���t�F
'****************************************************
Function IsArrayEmpty(anArray As Variant)

    Dim i As Integer
    
    On Error Resume Next
        i = UBound(anArray, 1)
    
    IsArrayEmpty = False
    
    If err.Number <> 0 Then
        IsArrayEmpty = True
    End If

End Function

'****************************************************
'�֐��� �FRegExpReplace
'�ϐ�   �FLookIn�APatternStr�AReplaceWith�AReplaceAll�AMatchCase
'�ԋp   �FString
'�ړI   �F���K�\���Œu��������
'�쐬�� �Fphuonghtt     ���t�F2011.08.15
'�ύX�� �F              ���t�F
'****************************************************
Function RegExpReplace(LookIn As String, PatternStr As String, Optional ReplaceWith As String = "", _
    Optional ReplaceAll As Boolean = True, Optional MatchCase As Boolean = True)
     
    Dim RegX As Object
     
    Set RegX = CreateObject("VBScript.RegExp")
    With RegX
        .Pattern = PatternStr
        .Global = ReplaceAll
        .IgnoreCase = Not MatchCase
    End With
     
    RegExpReplace = RegX.Replace(LookIn, ReplaceWith)
     
    Set RegX = Nothing
     
End Function

'****************************************************
'�֐��� �FGetStartColumnIdx
'�ϐ�   �FcolPjBangou�ArowIdx
'�ԋp   �FLong
'�ړI   �F�R�������X�^�[�g����
'�쐬�� �Fphuonght      ���t�F2011.08.15
'�ύX�� �F              ���t�F
'****************************************************
Function GetStartColumnIdx(ByVal colPjBangou As Long, ByVal rowIdx As Long)
    
    Dim i As Long
    
    For i = 1 To colPjBangou
        If Cells(rowIdx, i).Text <> "" Then
            GetStartColumnIdx = i
            Exit Function
        End If
    Next
    
End Function

'****************************************************
'�֐��� �FCreateButtonSort
'�ϐ�   �F�Ȃ�
'�ԋp   �F�Ȃ�
'�ړI   �F�{�^���̃\�[�g���쐬����B
'�쐬�� �Fphuonghtt     ���t�F2011.08.15
'�ύX�� �F              ���t�F
'****************************************************
Private Sub CreateButtonSort()

    ActiveWorkbook.Sheets(SHEET_SORT).Select
    
    ActiveSheet.Buttons.Add(500, 2, 120, 30).Select
    
    Selection.Name = SORT_BUTTONNAME
    Selection.Characters.Text = SORT_BUTTONCAPTION
    
    With Selection.Characters(Start:=1, Length:=3).Font
        .Name = "�l�r �o�S�V�b�N"
        .FontStyle = "�W�� Bold"
        .Size = 18
        .Strikethrough = False
        .Superscript = False
        .Subscript = False
        .OutlineFont = True
        .Shadow = True
        .Underline = xlUnderlineStyleNone
        .ColorIndex = 5
    End With
    
    Selection.OnAction = SORT_ACTION
    
    Range("A1").Select
        
End Sub

'****************************************************
'�֐��� �FsortButton_Click
'�ϐ�   �F�Ȃ�
'�ԋp   �F�Ȃ�
'�ړI   �F�\�[�g�̃{�^����I�����邪�ꍇ�B
'�쐬�� �Fphuonghtt     ���t�F2011.08.15
'�ύX�� �F              ���t�F
'****************************************************
Public Sub SortButton_Click()
    
    Dim sortForm As frmSort
    Set sortForm = New frmSort
    
    '�\�[�g�̉�ʂ�\������B
    sortForm.Show vbModal
    
End Sub

'****************************************************
'�֐��� �FDeleteButtonSort
'�ϐ�   �F�Ȃ�
'�ԋp   �F�Ȃ�
'�ړI   �F�\�[�g�̃{�^�����폜����B
'�쐬�� �Fphuonghtt     ���t�F2011.08.15
'�ύX�� �F              ���t�F
'****************************************************
Private Sub DeleteButtonSort()
    
    '�\�[�gSheet���I������B
    ActiveWorkbook.Sheets(SHEET_SORT).Select
    
    On Error Resume Next

        '�\�[�g�̃{�^�����폜����B
        ActiveSheet.Shapes(SORT_BUTTONNAME).Delete
    
End Sub

'****************************************************
'�֐��� �FPutButtonSortInTheSheet
'�ϐ�   �F�Ȃ�
'�ԋp   �F�Ȃ�
'�ړI   �F�\�[�g�̃{�^����ǉ�����B
'�쐬�� �Fphuonghtt     ���t�F2011.08.15
'�ύX�� �F              ���t�F
'****************************************************
Sub PutButtonSortInTheSheet()
    
    If Not IsSheetExists(SHEET_SORT) Then Exit Sub
    
    '�\�[�g�̃{�^�����폜����B
    DeleteButtonSort
    
    '�\�[�g�̃{�^����ǉ�����B
    CreateButtonSort
    
End Sub

'****************************************************
'�֐��� �FIsSheetExists
'�ϐ�   �F�Ȃ�
'�ԋp   �F�Ȃ�
'�ړI   �F
'�쐬�� �Fphuonghtt     ���t�F2011.08.15
'�ύX�� �F              ���t�F
'****************************************************
Function IsSheetExists(SheetName As String) As Boolean

    IsSheetExists = False
    
    On Error GoTo NoSuchSheet
    If Len(Sheets(SheetName).Name) > 0 Then
        IsSheetExists = True
        Exit Function
    End If
NoSuchSheet:

End Function

