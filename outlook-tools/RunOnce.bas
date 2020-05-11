Attribute VB_Name = "RunOnce"
Sub RunOnceRules()
Dim myRules As Outlook.Rules
Dim rl As Outlook.Rule
Dim rulesExecutedCount As Integer
Dim rulename As String

rulename = "[RunOnce]"
Set myRules = Application.Session.DefaultStore.GetRules

Dim trashedItems As Integer
trashedItems = Application.Session.GetDefaultFolder(olFolderDeletedItems).Items.Count
Dim inboxItemsCount As Integer
inboxItemsCount = Application.Session.GetDefaultFolder(olFolderInbox).Items.Count

rulesExecutedCount = 0

For Each rl In myRules
    If rl.RuleType = olRuleReceive Then
        Dim contains As Integer
        contains = InStr(rl.Name, rulename)
        
        If contains > 0 Then
            rl.Execute ShowProgress:=True, RuleExecuteOption:=olRuleExecuteReadMessages
            rulesExecutedCount = rulesExecutedCount + 1
        End If
    End If
Next

Dim movedItems As Integer
Dim deletedItems As Integer
deletedItems = Application.Session.GetDefaultFolder(olFolderDeletedItems).Items.Count - trashedItems
movedItems = inboxItemsCount - Application.Session.GetDefaultFolder(olFolderInbox).Items.Count - deletedItems

ruleList = "Executed " & rulesExecutedCount & " rules. " & vbCrLf & vbCrLf & "Items deleted: " & deletedItems & vbCrLf & "Items moved: " & movedItems
MsgBox ruleList, vbInformation, "Clean Inbox done"

Set rl = Nothing
Set st = Nothing
Set myRules = Nothing
End Sub

