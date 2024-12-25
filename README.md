# OpenSSH Server Configuration Script

This repository contains a PowerShell script to automate the installation, configuration, and setup of OpenSSH Server on Windows. The script performs the following tasks:

1. Verifies if OpenSSH Server is installed.
2. Installs OpenSSH Server if it's missing.
3. Starts the OpenSSH Server service.
4. Configures the Windows Firewall to allow SSH connections.
5. Updates the SSH configuration file to enable root login and password authentication.

## Prerequisites

- Windows 10 or Windows Server 2019/2022.
- PowerShell with administrative privileges.

## Steps Performed by the Script

### 1. Verify and Install OpenSSH Server
The script checks if OpenSSH Server is installed. If not, it installs the capability using the following commands:

```powershell
Get-WindowsCapability -Online | ? Name -like 'OpenSSH*'
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
```

### 2. Start the SSH Service
The script ensures that the SSH service is running:

```powershell
Get-Service sshd
Start-Service sshd
```

### 3. Configure the Firewall
The script creates a firewall rule to allow inbound SSH connections on port 22 if the rule does not already exist:

```powershell
New-NetFirewallRule -Name "OpenSSH Server (TCP)" -DisplayName "OpenSSH Server (TCP)" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
```

### 4. Update SSH Configuration
The script updates the `sshd_config` file to enable root login and password authentication:

- Sets `PermitRootLogin` to `yes`.
- Sets `PasswordAuthentication` to `yes`.

If the file does not exist, the script outputs an error message and stops further execution.

### 5. Restart SSH Service
The script restarts the SSH service to apply the configuration changes:

```powershell
Restart-Service sshd
```

## Usage

1. Clone this repository or copy the script to your local machine.
2. Open PowerShell as Administrator.
3. Run the script:

   ```powershell
   .\setup.ps1
   ```

4. Verify that OpenSSH Server is installed and running by connecting via SSH to the machine's IP or hostname.

## Notes

- The script modifies the following file:
  ```
  C:\ProgramData\ssh\sshd_config
  ```
- Ensure that the `sshd_config` file exists before running the script.
- Modifying `PermitRootLogin` and `PasswordAuthentication` settings may reduce security. Use with caution in production environments.

## Troubleshooting

If you encounter issues:

- Ensure PowerShell is run as Administrator.
- Check the Windows Event Logs for SSH-related errors.
- Verify that port 22 is open and not blocked by other firewall rules.

## License

This project is licensed under the MIT License. See the LICENSE file for details.
