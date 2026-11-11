# LoL Friend Cleaner - Public Free v1.0
# Requires Windows 10/11, Windows PowerShell 5.1, curl.exe and an active LoL client.
# All requests target the local client on 127.0.0.1. No account password required.

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# Interface francaise par defaut. L'anglais est facultatif.
$script:language = 'fr'
$script:messages = @{
    fr = @{
        Window = 'LoL Friend Cleaner | Gratuit'
        Subtitle = "Version gratuite - suppression de toute la liste d'amis"
        Refresh = '1. Detecter mes amis'
        Save = '2. Exporter la liste (.csv)'
        Delete = '3. Tout supprimer'
        LanguageButton = 'English'
        Initial = 'Ouvre League of Legends, connecte-toi, puis clique sur Detecter.'
        Preview = 'Apercu des comptes detectes'
        Footer = 'Aucune suppression sans confirmation. Une sauvegarde CSV est exigee.'
        Disclaimer = 'Application communautaire independante, non affiliee a Riot Games.'
        ErrorTitle = 'LoL Friend Cleaner - Erreur'
        NoName = '(pseudo indisponible)'
        ClientMissing = 'Client LoL introuvable. Lance League of Legends et connecte-toi.'
        SeveralClients = 'Plusieurs clients LoL detectes. Ferme les clients supplementaires.'
        CredentialsMissing = 'Parametres locaux du client LoL introuvables.'
        CurlMissing = 'curl.exe est absent. Windows 10/11 est requis.'
        RequestFailed = 'Requete {0} echouee (curl code {1}) : {2}'
        NoFriendsExport = 'Aucun ami a exporter.'
        SaveTitle = "Sauvegarder la liste d'amis avant suppression"
        CsvFilter = 'Fichier CSV (*.csv)|*.csv'
        BackupMissing = 'Le fichier de sauvegarde est introuvable.'
        BackupCreated = "Sauvegarde creee :`n{0}"
        BackupTitle = 'Sauvegarde'
        Connecting = 'Connexion locale au client LoL...'
        EmptyResponse = 'Reponse vide du client.'
        InvalidJSON = "Format inattendu : la reponse n'est pas une liste JSON."
        InvalidId = "Un ou plusieurs amis n'ont pas d'identifiant valide. Suppression bloquee."
        Detected = 'Amis detectes : {0}. Verifie la liste avant toute operation.'
        DetectionFailed = 'Echec de la detection.'
        ConfirmPrompt = "Tu vas supprimer {0} amis de ton compte LoL.`n`nCette operation est difficile a annuler.`nUne sauvegarde CSV sera demandee avant de commencer.`n`nContinuer ?"
        ConfirmTitle = 'Confirmation de suppression'
        BackupCancelled = 'Suppression annulee : sauvegarde obligatoire.'
        TypePrompt = 'Tape exactement SUPPRIMER pour lancer la suppression de TOUS les amis.'
        TypeTitle = 'Derniere confirmation'
        DeletionCancelled = 'Suppression annulee. Aucun ami supprime.'
        IdMissing = 'Identifiant manquant.'
        FailedPrefix = 'ECHEC'
        Progress = 'Progression : {0}/{1} | Requetes acceptees : {2} | Echecs : {3}'
        Summary = "Operation terminee.`n`nRequetes acceptees : {0}`nEchecs : {1}`n`nVerifie le resultat dans le client LoL.`n`nSauvegarde : {2}"
        SummaryTitle = 'Bilan'
        Done = 'Termine : {0} requetes acceptees, {1} echec(s). Relance la detection pour verifier.'
    }
    en = @{
        Window = 'LoL Friend Cleaner | Free'
        Subtitle = 'Free edition - remove your entire friends list'
        Refresh = '1. Detect friends'
        Save = '2. Export list (.csv)'
        Delete = '3. Remove all'
        LanguageButton = 'Francais'
        Initial = 'Open League of Legends, sign in, then click Detect friends.'
        Preview = 'Preview of detected accounts'
        Footer = 'No removal without confirmation. A CSV backup is required.'
        Disclaimer = 'Independent community app, not affiliated with Riot Games.'
        ErrorTitle = 'LoL Friend Cleaner - Error'
        NoName = '(name unavailable)'
        ClientMissing = 'LoL client not found. Open League of Legends and sign in.'
        SeveralClients = 'Multiple LoL clients detected. Close the additional clients.'
        CredentialsMissing = 'Local LoL client connection details not found.'
        CurlMissing = 'curl.exe is missing. Windows 10/11 is required.'
        RequestFailed = '{0} request failed (curl code {1}): {2}'
        NoFriendsExport = 'No friends to export.'
        SaveTitle = 'Save a backup of your friends before removal'
        CsvFilter = 'CSV file (*.csv)|*.csv'
        BackupMissing = 'The backup file could not be found.'
        BackupCreated = "Backup created:`n{0}"
        BackupTitle = 'Backup'
        Connecting = 'Connecting to the local LoL client...'
        EmptyResponse = 'Empty response from client.'
        InvalidJSON = 'Unexpected format: response is not a JSON list.'
        InvalidId = 'One or more friends have an invalid ID. Removal blocked.'
        Detected = 'Friends found: {0}. Check the list before proceeding.'
        DetectionFailed = 'Detection failed.'
        ConfirmPrompt = "You are about to remove {0} friends from your LoL account.`n`nThis action is difficult to undo.`nA CSV backup is required before proceeding.`n`nContinue?"
        ConfirmTitle = 'Confirm removal'
        BackupCancelled = 'Removal cancelled: backup is required.'
        TypePrompt = 'Type DELETE exactly to remove ALL friends.'
        TypeTitle = 'Final confirmation'
        DeletionCancelled = 'Removal cancelled. No friends removed.'
        IdMissing = 'Missing identifier.'
        FailedPrefix = 'FAILED'
        Progress = 'Progress: {0}/{1} | Requests accepted: {2} | Failures: {3}'
        Summary = "Operation complete.`n`nRequests accepted: {0}`nFailures: {1}`n`nVerify the result in the LoL client.`n`nBackup: {2}"
        SummaryTitle = 'Summary'
        Done = 'Done: {0} requests accepted, {1} failures. Detect again to verify.'
    }
}
function L([string]$Key) { return [string]$script:messages[$script:language][$Key] }
function LF([string]$Key, [object[]]$ArgsList) { return [string]::Format((L $Key), $ArgsList) }

$form = New-Object System.Windows.Forms.Form
$form.Text = L 'Window'
$form.ClientSize = New-Object System.Drawing.Size(690, 570)
$form.MinimumSize = New-Object System.Drawing.Size(706, 609)
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.Font = New-Object System.Drawing.Font('Segoe UI', 9)
$form.BackColor = [System.Drawing.Color]::FromArgb(18, 23, 32)
$form.ForeColor = [System.Drawing.Color]::White

function New-Label([string]$Text, [int]$X, [int]$Y, [int]$W, [int]$H, [float]$Size, [bool]$Bold) {
    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = $Text
    $lbl.Location = New-Object System.Drawing.Point($X, $Y)
    $lbl.Size = New-Object System.Drawing.Size($W, $H)
    $style = if ($Bold) { [System.Drawing.FontStyle]::Bold } else { [System.Drawing.FontStyle]::Regular }
    $lbl.Font = New-Object System.Drawing.Font('Segoe UI', $Size, $style)
    $lbl.ForeColor = [System.Drawing.Color]::White
    return $lbl
}
function New-Button([string]$Text, [int]$X, [int]$Y, [int]$W, [int]$H) {
    $b = New-Object System.Windows.Forms.Button
    $b.Text = $Text
    $b.Location = New-Object System.Drawing.Point($X, $Y)
    $b.Size = New-Object System.Drawing.Size($W, $H)
    $b.FlatStyle = 'Flat'
    $b.FlatAppearance.BorderSize = 0
    $b.BackColor = [System.Drawing.Color]::FromArgb(48, 66, 90)
    $b.ForeColor = [System.Drawing.Color]::White
    $b.Cursor = [System.Windows.Forms.Cursors]::Hand
    return $b
}
function Show-Error([string]$Message) {
    [void][System.Windows.Forms.MessageBox]::Show($form, $Message, (L 'ErrorTitle'), 'OK', 'Error')
}

$title = New-Label 'LoL FRIEND CLEANER' 24 18 480 36 20 $true
$subtitle = New-Label (L 'Subtitle') 25 58 630 23 10 $false
$subtitle.ForeColor = [System.Drawing.Color]::FromArgb(170, 185, 200)
$form.Controls.AddRange(@($title, $subtitle))
$langButton = New-Button (L 'LanguageButton') 563 19 103 32
$langButton.BackColor = [System.Drawing.Color]::FromArgb(59, 74, 96)
$form.Controls.Add($langButton)
function Update-Language {
    $form.Text = L 'Window'
    $subtitle.Text = L 'Subtitle'
    $refresh.Text = L 'Refresh'
    $save.Text = L 'Save'
    $delete.Text = L 'Delete'
    $langButton.Text = L 'LanguageButton'
    $previewTitle.Text = L 'Preview'
    $foot.Text = L 'Footer'
    $disclaimer.Text = L 'Disclaimer'
    $status.Text = L 'Initial'
    $status.Refresh()
}
$langButton.Add_Click({
    if ($script:busy) { return }
    if ($script:language -eq 'fr') { $script:language = 'en' } else { $script:language = 'fr' }
    Update-Language
})


$refresh = New-Button (L 'Refresh') 24 101 210 39
$save = New-Button (L 'Save') 245 101 210 39
$delete = New-Button (L 'Delete') 466 101 200 39
$save.Enabled = $false
$delete.Enabled = $false
$delete.BackColor = [System.Drawing.Color]::FromArgb(128, 51, 59)
$form.Controls.AddRange(@($refresh, $save, $delete))

$status = New-Label (L 'Initial') 25 155 640 42 10 $false
$form.Controls.Add($status)

$previewTitle = New-Label (L 'Preview') 25 199 630 26 11 $true
$form.Controls.Add($previewTitle)
$list = New-Object System.Windows.Forms.ListBox
$list.Location = New-Object System.Drawing.Point(24, 231)
$list.Size = New-Object System.Drawing.Size(642, 216)
$list.BackColor = [System.Drawing.Color]::FromArgb(29, 37, 49)
$list.ForeColor = [System.Drawing.Color]::White
$list.BorderStyle = 'FixedSingle'
$list.Font = New-Object System.Drawing.Font('Consolas', 10)
$list.HorizontalScrollbar = $true
$form.Controls.Add($list)

$progress = New-Object System.Windows.Forms.ProgressBar
$progress.Location = New-Object System.Drawing.Point(24, 464)
$progress.Size = New-Object System.Drawing.Size(642, 16)
$progress.Minimum = 0
$progress.Maximum = 100
$form.Controls.Add($progress)

$foot = New-Label (L 'Footer') 24 494 650 25 9 $false
$foot.ForeColor = [System.Drawing.Color]::FromArgb(180, 191, 208)
$form.Controls.Add($foot)
$disclaimer = New-Label (L 'Disclaimer') 24 526 650 24 9 $false
$disclaimer.ForeColor = [System.Drawing.Color]::FromArgb(140, 154, 171)
$form.Controls.Add($disclaimer)

$script:friends = @()
$script:base = $null
$script:auth = $null
$script:backupFile = $null
$script:busy = $false

function Set-Status([string]$Message) {
    $status.Text = $Message
    $status.Refresh()
}
function Display-Name($Friend) {
    $name = if ($Friend.gameName) { [string]$Friend.gameName } elseif ($Friend.name) { [string]$Friend.name } else { (L 'NoName') }
    if ($Friend.gameTag) { return "$name#$($Friend.gameTag)" }
    return $name
}
function Get-ClientCredentials {
    $candidates = @(Get-CimInstance Win32_Process -Filter "name = 'LeagueClientUx.exe'" |
        Where-Object { $_.CommandLine -match '--remoting-auth-token=' -and $_.CommandLine -match '--app-port=' })
    if ($candidates.Count -eq 0) { throw (L 'ClientMissing') }
    if ($candidates.Count -ne 1) { throw (L 'SeveralClients') }
    $cmd = $candidates[0].CommandLine
    $mToken = [regex]::Match($cmd, '--remoting-auth-token=(?:"([^"]+)"|([^\s"]+))')
    $mPort = [regex]::Match($cmd, '--app-port=(\d+)')
    $token = if ($mToken.Groups[1].Success) { $mToken.Groups[1].Value } else { $mToken.Groups[2].Value }
    $port = $mPort.Groups[1].Value
    if ([string]::IsNullOrEmpty($token) -or [string]::IsNullOrEmpty($port)) { throw (L 'CredentialsMissing') }
    $script:auth = [Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("riot:$token"))
    $script:base = "https://127.0.0.1:$port"
    $token = $null
}
function Invoke-ClientRequest([string]$Uri, [string]$Method) {
    if (-not (Get-Command curl.exe -ErrorAction SilentlyContinue)) { throw (L 'CurlMissing') }
    # -k only for League's self-signed LOCAL loopback certificate.
    # No redirects, proxies or remote endpoints.
    $response = & curl.exe --noproxy '*' --insecure --silent --show-error --fail --max-redirs 0 `
        --connect-timeout 5 --max-time 20 --request $Method `
        --header "Authorization: Basic $script:auth" --header 'Accept: application/json' $Uri 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw (LF 'RequestFailed' @($Method, $LASTEXITCODE, ($response -join ' ')))
    }
    return ($response -join "`n")
}
function Export-Friends {
    if ($script:friends.Count -lt 1) { throw (L 'NoFriendsExport') }
    $dlg = New-Object System.Windows.Forms.SaveFileDialog
    $dlg.Title = L 'SaveTitle'
    $dlg.Filter = L 'CsvFilter'
    $dlg.DefaultExt = 'csv'
    $dlg.AddExtension = $true
    $dlg.FileName = 'LoL_amis_avant_suppression_' + (Get-Date -Format 'yyyyMMdd_HHmmss') + '.csv'
    if ($dlg.ShowDialog($form) -ne [System.Windows.Forms.DialogResult]::OK) { return $false }
    $records = @($script:friends | ForEach-Object {
        [pscustomobject]@{
            Pseudo = Display-Name $_
            IdentifiantLocal = [string]$_.id
            GameName = [string]$_.gameName
            GameTag = [string]$_.gameTag
        }
    })
    $records | Export-Csv -Path $dlg.FileName -NoTypeInformation -Delimiter ';' -Encoding UTF8 -ErrorAction Stop
    if (-not (Test-Path -LiteralPath $dlg.FileName)) { throw (L 'BackupMissing') }
    $script:backupFile = $dlg.FileName
    [void][System.Windows.Forms.MessageBox]::Show($form, (LF 'BackupCreated' @($script:backupFile)), (L 'BackupTitle'), 'OK', 'Information')
    return $true
}

$refresh.Add_Click({
    if ($script:busy) { return }
    $refresh.Enabled = $false
    $save.Enabled = $false
    $delete.Enabled = $false
    $list.Items.Clear()
    $script:friends = @()
    $script:backupFile = $null
    $script:base = $null
    $script:auth = $null
    $progress.Value = 0
    try {
        Set-Status (L 'Connecting')
        Get-ClientCredentials
        $json = Invoke-ClientRequest -Uri "$script:base/lol-chat/v1/friends" -Method 'GET'
        if ([string]::IsNullOrWhiteSpace($json)) { throw (L 'EmptyResponse') }
        if (-not $json.TrimStart().StartsWith('[')) { throw (L 'InvalidJSON') }
        $parsed = ConvertFrom-Json -InputObject $json
        $script:friends = [object[]]$parsed
        if (@($script:friends | Where-Object { -not $_.id }).Count -gt 0) {
            throw (L 'InvalidId')
        }
        foreach ($friend in $script:friends) { [void]$list.Items.Add((Display-Name $friend)) }
        Set-Status (LF 'Detected' @($script:friends.Count))
        $save.Enabled = ($script:friends.Count -gt 0)
        $delete.Enabled = ($script:friends.Count -gt 0)
    } catch {
        $script:friends = @()
        $script:base = $null
        $script:auth = $null
        Set-Status (L 'DetectionFailed')
        Show-Error $_.Exception.Message
    } finally {
        $refresh.Enabled = $true
    }
})
$save.Add_Click({
    if ($script:busy) { return }
    try { [void](Export-Friends) } catch { Show-Error $_.Exception.Message }
})
$delete.Add_Click({
    if ($script:busy -or $script:friends.Count -eq 0) { return }
    $count = $script:friends.Count
    $confirm = [System.Windows.Forms.MessageBox]::Show(
        $form,
        (LF 'ConfirmPrompt' @($count)),
        (L 'ConfirmTitle'), 'YesNo', 'Warning'
    )
    if ($confirm -ne [System.Windows.Forms.DialogResult]::Yes) { return }
    # Require a fresh export at time of deletion. The export does not authorize deletion.
    try {
        if (-not (Export-Friends)) { Set-Status (L 'BackupCancelled'); return }
    } catch { Show-Error $_.Exception.Message; return }
    $typed = [Microsoft.VisualBasic.Interaction]::InputBox((L 'TypePrompt'), (L 'TypeTitle'), '')
    $expected = if ($script:language -eq 'fr') { 'SUPPRIMER' } else { 'DELETE' }
    if ($typed -cne $expected) { Set-Status (L 'DeletionCancelled'); return }

    $script:busy = $true
    $refresh.Enabled = $false
    $save.Enabled = $false
    $delete.Enabled = $false
    $form.ControlBox = $false
    $langButton.Enabled = $false
    $success = 0
    $failed = 0
    try {
        for ($i = 0; $i -lt $script:friends.Count; $i++) {
            $friend = $script:friends[$i]
            $display = Display-Name $friend
            try {
                $id = [uri]::EscapeDataString([string]$friend.id)
                if ([string]::IsNullOrEmpty($id)) { throw (L 'IdMissing') }
                [void](Invoke-ClientRequest -Uri "$script:base/lol-chat/v1/friends/$id" -Method 'DELETE')
                $success++
                $list.Items[$i] = "[OK] $display"
            } catch {
                $failed++
                $list.Items[$i] = '[' + (L 'FailedPrefix') + '] ' + $display
            }
            $progress.Value = [int][Math]::Round((($i + 1) / $count) * 100)
            Set-Status (LF 'Progress' @(($i + 1), $count, $success, $failed))
            $list.TopIndex = $i
            $form.Refresh()
            if ($i -lt ($count - 1)) { Start-Sleep -Milliseconds 500 }
        }
        $message = LF 'Summary' @($success, $failed, $script:backupFile)
        [void][System.Windows.Forms.MessageBox]::Show($form, $message, (L 'SummaryTitle'), 'OK', 'Information')
        Set-Status (LF 'Done' @($success, $failed))
    } finally {
        $script:busy = $false
        $form.ControlBox = $true
        $langButton.Enabled = $true
        $refresh.Enabled = $true
        # Must re-detect fresh list after destructive operation.
        $save.Enabled = $false
        $delete.Enabled = $false
        $script:friends = @()
    }
})

# InputBox is provided by Microsoft.VisualBasic, included with Windows .NET Framework.
Add-Type -AssemblyName Microsoft.VisualBasic
[void]$form.ShowDialog()
