# Script de Configuration OpenSSH Server

Ce dépôt contient un script PowerShell pour automatiser l'installation, la configuration et la mise en place du serveur OpenSSH sur Windows. Le script réalise les tâches suivantes :

1. Vérifie si OpenSSH Server est installé.
2. Installe OpenSSH Server s'il manque.
3. Démarre le service OpenSSH Server.
4. Configure le pare-feu Windows pour autoriser les connexions SSH.
5. Met à jour le fichier de configuration SSH pour activer la connexion root et l'authentification par mot de passe.

## Prérequis

- Windows 10 ou Windows Server 2019/2022.
- PowerShell avec des privilèges administratifs.

## Étapes réalisées par le script

### 1. Vérifier et installer OpenSSH Server
Le script vérifie si OpenSSH Server est installé. Sinon, il installe la fonctionnalité à l'aide des commandes suivantes :

```powershell
Get-WindowsCapability -Online | ? Name -like 'OpenSSH*'
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
```

### 2. Démarrer le service SSH
Le script s'assure que le service SSH est en cours d'exécution :

```powershell
Get-Service sshd
Start-Service sshd
```

### 3. Configurer le pare-feu
Le script crée une règle de pare-feu pour autoriser les connexions SSH entrantes sur le port 22 si la règle n'existe pas déjà :

```powershell
New-NetFirewallRule -Name "OpenSSH Server (TCP)" -DisplayName "OpenSSH Server (TCP)" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
```

### 4. Mettre à jour la configuration SSH
Le script met à jour le fichier `sshd_config` pour activer la connexion root et l'authentification par mot de passe :

- Définit `PermitRootLogin` sur `yes`.
- Définit `PasswordAuthentication` sur `yes`.

Si le fichier n'existe pas, le script affiche un message d'erreur et arrête l'exécution.

### 5. Redémarrer le service SSH
Le script redémarre le service SSH pour appliquer les modifications de configuration :

```powershell
Restart-Service sshd
```

## Utilisation

1. Clonez ce dépôt ou copiez le script sur votre machine locale.
2. Ouvrez PowerShell en tant qu'administrateur.
3. Exécutez le script :

   ```powershell
   .\setup.ps1
   ```

4. Vérifiez que le serveur OpenSSH est installé et en cours d'exécution en vous connectant via SSH à l'adresse IP ou au nom d'hôte de la machine.

## Notes

- Le script modifie le fichier suivant :
  ```
  C:\ProgramData\ssh\sshd_config
  ```
- Assurez-vous que le fichier `sshd_config` existe avant d'exécuter le script.
- Modifier les paramètres `PermitRootLogin` et `PasswordAuthentication` peut réduire la sécurité. À utiliser avec précaution dans des environnements de production.

## Résolution des problèmes

Si vous rencontrez des problèmes :

- Assurez-vous d'exécuter PowerShell en tant qu'administrateur.
- Vérifiez les journaux des événements Windows pour les erreurs liées à SSH.
- Vérifiez que le port 22 est ouvert et non bloqué par d'autres règles de pare-feu.

## Licence

Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.
