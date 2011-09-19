VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} FrmSort 
   Caption         =   "���בւ�"
   ClientHeight    =   4335
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4725
   OleObjectBlob   =   "FrmSort.frx":0000
   StartUpPosition =   2  'CenterScreen
End
Attribute VB_Name = "FrmSort"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Private Const BLANK_LINE = ""
Private Const SORT_COLUMN1 = "D"
Private Const SORT_COLUMN2 = "F"
Private Const SORT_COLUMN3 = "G"

Private Const COL_PJBANGOU = "A"
Private Const ROW_PJBANGOU = "B"

Private Const MSG_WARNING01 = "�u�ŗD�悳���L�[�v�I�����Ȃ���΂Ȃ�܂���B"
Private Const MSG_WARNING02 = "�Q�ԖڂɍŗD�悳���L�[�̃R���{�{�b�N�X�ɓ��͂����l��" & vbNewLine & "�ŗD�悳���L�[�̃R���{�{�b�N�X�ɓ��͂����l�ƈႤ�ׂ��ł���B"
Private Const MSG_WARNING03 = "�R�ԖڂɍŗD�悳���L�[�̃R���{�{�b�N�X�ɓ��͂����l��" & vbNewLine & "��L�̂Q�̃R���{�{�b�N�X�ƈႤ�ׂ��ł���B"

'****************************************************
'�֐��� �FUserForm_Initialize
'�ϐ�   �F�Ȃ�
'�ԋp   �F�Ȃ�
'�ړI   �F��ʂ�����������B
'�쐬�� �Fphuonghtt     ���t�F2011.08.12
'�ύX�� �F              ���t�F
'****************************************************
Private Sub UserForm_Initialize()
    
    ' ComboSource���쐬����
    Dim comboSource() As Variant
    comboSource = Array(BLANK_LINE, SORT_COLUMN1, SORT_COLUMN2, SORT_COLUMN3)
    
    ' ComboBox�Ƀf�[�^���Z�b�g����B
    cboSortBy.List = comboSource
    cboThenBy1.List = comboSource
    cboThenBy2.List = comboSource

End Sub

'****************************************************
'�֐��� �FbtnOk_Click
'�ϐ�   �F�Ȃ�
'�ԋp   �F�Ȃ�
'�ړI   �FOK�{�^�����I�����ꂽ�ꍇ
'�쐬�� �Fphuonghtt     ���t�F2011.08.15
'�ύX�� �F              ���t�F
'****************************************************
Private Sub btnOk_Click()
        
    Dim waitCursor As Hourglass
    Set waitCursor = New Hourglass
            
    ' ���בւ�
    ' �f�B�X�v���C�̌x���𖳌���
    Application.DisplayAlerts = False
    Application.ScreenUpdating = False
            
    Dim reflectSheet As Worksheet   '[Reflect Pattern] �V�[�g
    Dim colPjBangou As Long         '�s��PJ�ԍ�
    Dim rowPjBangou As Long         '���PJ�ԍ�
    Dim order1 As XlSortOrder
    Dim order2 As XlSortOrder
    Dim order3 As XlSortOrder
    Dim rowIdx As Long
    
    ' �P�̂��`�F�b�N����B
    '�u�ŗD�悳���L�[�v�Ƀf�[�^����͂������m�F����B
    If cboSortBy.Text = "" Then
        MsgBox MSG_WARNING01
        cboSortBy.SetFocus
        
        Exit Sub
    End If
    
    '�u�Q�ŗD�悳��邫�[�v�Ƀf�[�^����͂������m�F����B
    If cboThenBy1.Text <> "" And cboThenBy1.Text = cboSortBy.Text Then
        MsgBox MSG_WARNING02
        cboThenBy1.SetFocus
        
        Exit Sub
    End If
    
    '�u�R�ŗD�悳��邫�[�v�Ƀf�[�^����͂������m�F����B
    If cboThenBy2.Text <> "" And (cboThenBy2.Text = cboSortBy.Text Or cboThenBy2.Text = cboThenBy1.Text) Then
        MsgBox MSG_WARNING03
        cboThenBy2.SetFocus
        
        Exit Sub
    End If
        
    If Not IsSheetExists(SHEET_REFLECT) Then
        Unload Me
        Exit Sub
    End If
        
    '�uReflect Pattern�v�V�[�g���Z�b�g����B
    Set reflectSheet = ActiveWorkbook.Sheets(SHEET_REFLECT)
    
    If sortByAsc.Value Then
        order1 = xlAscending    '����
    Else
        order1 = xlDescending   '�~��
    End If
    
    If thenByAsc1.Value Then
        order2 = xlAscending    '����
    Else
        order2 = xlDescending   '�~��
    End If
            
    If thenByAsc2.Value Then
        order3 = xlAscending    '����
    Else
        order3 = xlDescending   '�~��
    End If
    
    For rowIdx = 1 To reflectSheet.UsedRange.Rows.count Step 2
        
        'PJ�ԍ��̗�
        colPjBangou = reflectSheet.Range(COL_PJBANGOU & rowIdx)
        'PJ�ԍ��̍s
        rowPjBangou = reflectSheet.Range(ROW_PJBANGOU & rowIdx)
        
        '���בւ�
        Sort rowPjBangou, colPjBangou, cboSortBy.Text, order1, cboThenBy1.Text, order2, cboThenBy2.Text, order3

    Next
                
    Application.DisplayAlerts = True
    Application.ScreenUpdating = True
    
    '�\�[�g�@�\��ʂ��I������B
    '�I������B
    Unload Me
    
End Sub

'****************************************************
'�֐��� �FbtnCancel_Click
'�ϐ�   �F�Ȃ�
'�ԋp   �F�Ȃ�
'�ړI   �F�L�����Z�{�^����I�����ꂽ����B
'�쐬�� �Fphuonghtt     ���t�F2011.08.02
'�ύX�� �F              ���t�F
'****************************************************
Private Sub btnCancel_Click()
    Unload Me
End Sub
