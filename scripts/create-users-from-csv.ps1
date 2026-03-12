# =========================================================
# Script: create-users-from-csv.ps1
# Purpose: Create users for the JoshTest366 IAM lab
# Tenant: JoshTest366.onmicrosoft.com
# Notes:
# - Replace the domain if using another tenant
# - CSV must include the headers shown below
# =========================================================

# Required CSV Headers:
# FirstName,LastName,DisplayName,UserPrincipalName,MailNickname,Department,JobTitle,UsageLocation,TemporaryPassword

Import-Module Microsoft.Graph.Users
Import-Module Microsoft.Graph.Identity.DirectoryManagement

Connect-MgGraph -Scopes "User.ReadWrite.All","Directory.ReadWrite.All"

$csvPath = ".\users.csv"

if (!(Test-Path $csvPath)) {
    Write-Host "CSV file not found at $csvPath" -ForegroundColor Red
    exit
}

$users = Import-Csv $csvPath

foreach ($user in $users) {
    try {
        $existingUser = Get-MgUser -Filter "userPrincipalName eq '$($user.UserPrincipalName)'" -ConsistencyLevel eventual -ErrorAction SilentlyContinue

        if ($existingUser) {
            Write-Host "User already exists: $($user.UserPrincipalName)" -ForegroundColor Yellow
            continue
        }

        $params = @{
            AccountEnabled    = $true
            DisplayName       = $user.DisplayName
            GivenName         = $user.FirstName
            Surname           = $user.LastName
            UserPrincipalName = $user.UserPrincipalName
            MailNickname      = $user.MailNickname
            Department        = $user.Department
            JobTitle          = $user.JobTitle
            UsageLocation     = $user.UsageLocation
            PasswordProfile   = @{
                Password = $user.TemporaryPassword
                ForceChangePasswordNextSignIn = $true
            }
        }

        New-MgUser @params | Out-Null
        Write-Host "Created user: $($user.UserPrincipalName)" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to create $($user.UserPrincipalName): $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "User creation process complete." -ForegroundColor Cyan
