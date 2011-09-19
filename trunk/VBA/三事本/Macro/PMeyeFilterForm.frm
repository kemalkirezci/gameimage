VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} PMeyeFilterForm 
   Caption         =   "�t�B���^"
   ClientHeight    =   2070
   ClientLeft      =   45
   ClientTop       =   360
   ClientWidth     =   3375
   OleObjectBlob   =   "PMeyeFilterForm.frx":0000
   StartUpPosition =   1  '�I�[�i�[ �t�H�[���̒���
End
Attribute VB_Name = "PMeyeFilterForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False


Dim selectData As String
Dim selectFilter As Integer
Dim PMDic, DIVDic, datalines As Integer
Dim ws As Worksheet

Private Sub PMeye_cbBOX_Change()
    
    selectData = PMeye_cbBOX.Value

End Sub

Private Sub PMeye_filterON_Click()

Dim i, j As Integer
Dim sFilter As String

'�\���X�V�̐���
    Application.ScreenUpdating = False

    If selectFilter = 0 Then
        j = 6
        sFilter = "PM"
    Else
        j = 5
        sFilter = "���喼"
    End If
    
    For i = 8 To datalines
        With pWS
            If .Cells(i, j) = sFilter Or .Cells(i, j) = "" Then
            ElseIf .Cells(i, j) <> selectData Then
                .Rows(i & ":" & i).EntireRow.Hidden = True
            Else
                .Rows(i & ":" & i).EntireRow.Hidden = False
            End If
        End With
    Next
    
'�\���X�V�̐���
    Application.ScreenUpdating = True
    
'���[�U�t�H�[���̏���
    Unload Me

End Sub
Private Sub PMeye_filterOFF_Click()

Dim i As Integer

'�\���X�V�̐���
    Application.ScreenUpdating = False

    With pWS
        .Rows(8 & ":" & datalines).EntireRow.Hidden = False
    
'�\���X�V�̐���
        Application.ScreenUpdating = True
    
    End With

'���[�U�t�H�[���̏���
    Unload Me

End Sub

Private Sub PMeye_opDIV_Click()

    selectFilter = 1 '����
    PMeye_cbBOX.List = DIVDic.keys

End Sub

Private Sub PMeye_opPM_Click()

    selectFilter = 0 'PM
    PMeye_cbBOX.List = PMDic.keys

End Sub

Private Sub UserForm_Initialize()

Dim i As Integer
Dim bufPM, bufDIV As String

'   �f�[�^�̂l�`�w���m�F
    Set ws = ActiveSheet
    With ws
        datalines = .Range("F65536").End(xlUp).Row

        Set PMDic = CreateObject("Scripting.Dictionary")
        Set DIVDic = CreateObject("Scripting.Dictionary")

        For i = 8 To datalines
            bufPM = .Cells(i, 6).Value
            If Not PMDic.Exists(bufPM) Then
                PMDic.Add bufPM, bufPM
            End If
            bufDIV = .Cells(i, 5).Value
            If Not DIVDic.Exists(bufDIV) Then
                DIVDic.Add bufDIV, bufDIV
            End If
        Next
    End With
    
    PMDic.Remove ("PM")
    DIVDic.Remove ("���喼")
    If DIVDic.Exists("�Ȃ��B") Then
        DIVDic.Remove ("�Ȃ��B")
    End If
    If DIVDic.Exists("") Then
        DIVDic.Remove ("")
    End If
    If PMDic.Exists("") Then
        PMDic.Remove ("")
    End If

End Sub
