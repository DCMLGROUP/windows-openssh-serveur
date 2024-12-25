# Vérifier et installer OpenSSH Server si nécessaire
Get-WindowsCapability -Online | ? Name -like 'OpenSSH*'
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Vérifier et démarrer le service SSH
Get-Service sshd
Start-Service sshd

# Configurer le pare-feu pour OpenSSH Server
$firewallRuleName = "OpenSSH Server (TCP)"
$sshPort = 22
Write-Host "Configuration du pare-feu pour OpenSSH Server..." -ForegroundColor Green

if (-not (Get-NetFirewallRule | Where-Object { $_.Name -eq $firewallRuleName })) {
    New-NetFirewallRule -Name $firewallRuleName -DisplayName "OpenSSH Server (TCP)" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort $sshPort
    Write-Host "Règle de pare-feu ajoutée pour le port $sshPort." -ForegroundColor Green
} else {
    Write-Host "La règle de pare-feu existe déjà." -ForegroundColor Green
}

# Définir le chemin du fichier de configuration SSH
$sshdConfigPath = "C:\ProgramData\ssh\sshd_config"

# Vérifier si le fichier de configuration existe
if (Test-Path $sshdConfigPath) {
    # Lire le contenu du fichier
    $configContent = Get-Content -Path $sshdConfigPath

    # Décommente et configure PermitRootLogin
    if ($configContent -match "#?PermitRootLogin") {
        $configContent = $configContent -replace "#?PermitRootLogin.*", "PermitRootLogin yes"
    } else {
        $configContent += "`nPermitRootLogin yes"
    }

    # Décommente et configure PasswordAuthentication
    if ($configContent -match "#?PasswordAuthentication") {
        $configContent = $configContent -replace "#?PasswordAuthentication.*", "PasswordAuthentication yes"
    } else {
        $configContent += "`nPasswordAuthentication yes"
    }

    # Écrire les modifications dans le fichier
    Set-Content -Path $sshdConfigPath -Value $configContent

    # Redémarrer le service SSH pour appliquer les modifications
    Restart-Service sshd
    Write-Host "Configuration SSH mise à jour et service redémarré." -ForegroundColor Green
} else {
    Write-Host "Le fichier de configuration SSH ($sshdConfigPath) n'existe pas. Assurez-vous que le serveur OpenSSH est installé." -ForegroundColor Red
}
