Attribute VB_Name = "Module1"
'*************************************************************************
' �O���[�o���萔�^�ϐ�
'�@11/03/07�@�V�K�쐬
'*************************************************************************
Const GcnstStrMenuGrayDispOFF As String = "�O���[�A�E�g���\��"
Const GcnstStrMenuGrayDispON  As String = "�S�f�[�^�ĕ\��"
Const GcnstStrMenuFilterForm  As String = "�t�B���^���j���["
Const GcnstStrMenuPivotTable As String = "�s�{�b�g�e�[�u��"

Public pWS As Worksheet

Dim obj As New Class1
Dim Newb
Dim ws As Worksheet

Sub Auto_Open()

    Application.CommandBars("Cell").Reset

    Set obj.wsevent = Sheets("G�ʏW�v�ꗗ")

    Set Newb = Application.CommandBars("Cell").Controls.Add(Temporary:=True)
    With Newb
        .Caption = GcnstStrMenuFilterForm
        .OnAction = "PMeyeFilterFormOpen"   '�R�}���h��ǉ�
        .BeginGroup = True                  '��؂��
    End With
    
    Set Newb = Application.CommandBars("Cell").Controls.Add(Temporary:=True)
    With Newb
        .Caption = GcnstStrMenuGrayDispOFF
        .OnAction = "GrayDispOFF" '�R�}���h��ǉ�
        .BeginGroup = False       '��؂������
    End With
    
    Set Newb = Application.CommandBars("Cell").Controls.Add(Temporary:=True)
    With Newb
        .Caption = GcnstStrMenuGrayDispON
        .OnAction = "GrayDispON" '�R�}���h��ǉ�
        .BeginGroup = False      '��؂������
    End With
    
    '2011/08/10 HuynhTran �ǉ�
    Set Newb = Application.CommandBars("Cell").Controls.Add(Temporary:=True)
    With Newb
        .Caption = GcnstStrMenuPivotTable
        .OnAction = "PivotTableFormOpen" '�R�}���h��ǉ�
        .BeginGroup = False      '��؂������
    End With
        
        PutButtonSortInTheSheet

End Sub


'*************************************************************************
'�u�b�N�����O�̏���
'
'�@11/03/04�@�V�K�쐬
'*************************************************************************
Sub Auto_Close()

    Application.CommandBars("Cell").Reset
    '�E�N���b�N���j���[�ɒǉ��������j���[�������ꍇ�G���[�ɂȂ�̂ŃG���[�g���b�v����
    '�i�t�@�C������悤�Ƃ��āA�L�����Z�������ꍇ�A���L�̃��\�b�h����x���s����邽��
    '�@���̏ꍇ�ǉ��������j���[�����݂��Ȃ��ꍇ������A�G���[�ƂȂ邽�߁j
    On Error Resume Next
        '�E�N���b�N���j���[�ɒǉ��������j���[���폜����i�폜���Ȃ��Ǝ���c���Ă��܂����߁j
        Application.CommandBars("Cell").Controls(GcnstStrMenuGrayDispOFF).Delete
        Application.CommandBars("Cell").Controls(GcnstStrMenuGrayDispON).Delete
        Application.CommandBars("Cell").Controls(GcnstStrMenuFilterForm).Delete
        Application.CommandBars("Cell").Controls(GcnstStrMenuPivotTable).Delete
        
    On Error GoTo 0
    
End Sub

Sub GrayDispOFF()

Dim i, maxline As Integer
Dim cellFlag As String


'�\���X�V�̐���
    Application.ScreenUpdating = False

'   �f�[�^�̂l�`�w���m�F
    Set ws = ActiveSheet
    With ws
        maxline = .Range("F65536").End(xlUp).row
        
        If ws.name = "�w�EOD�ꗗ" Or ws.name = "�w�EPJ�ꗗ" Then
            For i = 8 To maxline
                cellFlag = .Cells(i, 4).Value
                Select Case cellFlag
                    Case "��\PJ"
                        .Rows(i & ":" & i).EntireRow.Hidden = True
                    Case "�qPJ"
                        .Rows(i & ":" & i).EntireRow.Hidden = True
                    Case "�V�F�APJ"
                        .Rows(i & ":" & i).EntireRow.Hidden = True
                    Case "���ԌnPJ"
                        .Rows(i & ":" & i).EntireRow.Hidden = True
                    Case "PP�J��"
                        .Rows(i & ":" & i).EntireRow.Hidden = True
                    Case "PP�ێ�"
                        .Rows(i & ":" & i).EntireRow.Hidden = True
                    Case "�Г��t��"
                        .Rows(i & ":" & i).EntireRow.Hidden = True
                    Case "�ێ�x���̂�"
                        .Rows(i & ":" & i).EntireRow.Hidden = True
                    Case "FS�̂�"
                        .Rows(i & ":" & i).EntireRow.Hidden = True
                    Case "�O���[�A�E�g"
                        .Rows(i & ":" & i).EntireRow.Hidden = True
                    Case Else
                End Select
            Next
        Else
            Exit Sub
        End If
    
    '�\���X�V�̐���
        Application.ScreenUpdating = True

        .Range("A4").Select
    End With
    
End Sub

Sub GrayDispON()

Dim i, maxline As Integer

'�\���X�V�̐���
    Application.ScreenUpdating = False

    Set ws = ActiveSheet
    With ws
        If ws.name = "�w�EOD�ꗗ" Or ws.name = "�w�EPJ�ꗗ" Then
        
'   �f�[�^�̂l�`�w���m�F
            maxline = .Range("F65536").End(xlUp).row

            .Rows(8 & ":" & maxline).EntireRow.Hidden = False

    '�\���X�V�̐���
            Application.ScreenUpdating = True

            .Range("A4").Select
        End If
    End With
    
End Sub

Sub PMeyeFilterFormOpen()
            
    Set ws = ActiveSheet
    With ws
        If ws.name = "�w�EOD�ꗗ" Or ws.name = "�w�EPJ�ꗗ" Then
            Set pWS = ActiveSheet
            PMeyeFilterForm.Show
        End If
    End With
    
End Sub

Sub RightClickMenuDelete()

    '�E�N���b�N���j���[�ɒǉ��������j���[�������ꍇ�G���[�ɂȂ�̂ŃG���[�g���b�v����
    '�i�t�@�C������悤�Ƃ��āA�L�����Z�������ꍇ�A���L�̃��\�b�h����x���s����邽��
    '�@���̏ꍇ�ǉ��������j���[�����݂��Ȃ��ꍇ������A�G���[�ƂȂ邽�߁j
    On Error Resume Next
        '�E�N���b�N���j���[�ɒǉ��������j���[���폜����i�폜���Ȃ��Ǝ���c���Ă��܂����߁j
        Application.CommandBars("Cell").Controls(GcnstStrMenuGrayDispOFF).Delete
        Application.CommandBars("Cell").Controls(GcnstStrMenuGrayDispON).Delete
        Application.CommandBars("Cell").Controls(GcnstStrMenuFilterForm).Delete
        
    On Error GoTo 0
    
End Sub

'****************************************************
'�֐��� �FPivotTableFormOpen
'�ϐ�   �F�Ȃ�
'�ԋp   �F�Ȃ�
'�ړI   �F
'�쐬�� �FHuynhTran     ���t�F2011.08.18
'�ύX�� �F              ���t�F
'*************************************************************************
Sub PivotTableFormOpen()
 PivotTable.Show
End Sub


