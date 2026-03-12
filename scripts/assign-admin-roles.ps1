# =========================================================
# Script: assign-admin-roles.ps1
# Purpose: Assign core administrative roles in the IAM lab
#
# IMPORTANT:
# This script uses placeholder role definition IDs.
# Replace the IDs below with the roleDefinitionId values
# from your tenant before use.
#
# To find role IDs:
# Get-MgRoleManagementDirectoryRoleDefinition | Select DisplayName, Id
# =========================================================

Import-Module Microsoft.Graph.Identity.Governance
Import-Module Microsoft.Graph.Users

Connect-MgGraph -Scopes "RoleManagement.ReadWrite.Directory","User.Read.All","Directory.Read.All"

# ---------------------------------------------------------
# Replace these with actual role definition IDs from your tenant
# ---------------------------------------------------------
$RoleDefinitionMap = @{
    "Global Administrator"   = "99999999-9999-9999-9999-999999999999"
    "User Administrator"     = "88888888-8888-8888-8888-888888888888"
    "Helpdesk Administrator" = "77777777-7777-7777-7777-777777777777"
}

# ---------------------------------------------------------
# Role assignments based on your environment
# ---------------------------------------------------------
$RoleAssignments = @(
    @{ UserPrincipalName = "chris.green@joshtest366.onmicrosoft.com";     RoleName = "Global Administrator" },
    @{ UserPrincipalName = "matthew.haney@joshtest366.onmicrosoft.com";   RoleName = "User Administrator" },
    @{ UserPrincipalName = "patrick.clancy@joshtest366.onmicrosoft.com";  RoleName = "Helpdesk Administrator" },
    @{ UserPrincipalName = "roxanne.gilbert@joshtest366.onmicrosoft.com"; RoleName = "Helpdesk Administrator" }
)

foreach ($assignment in $RoleAssignments) {
    try {
        $user = Get-MgUser -Filter "userPrincipalName eq '$($assignment.UserPrincipalName)'" -ConsistencyLevel eventual
        if (-not $user) {
            Write-Host "User not found: $($assignment.UserPrincipalName)" -ForegroundColor Yellow
            continue
        }

        $roleDefinitionId = $RoleDefinitionMap[$assignment.RoleName]
        if (-not $roleDefinitionId) {
            Write-Host "Role definition ID not found for $($assignment.RoleName)" -ForegroundColor Red
            continue
        }

        $scheduleParams = @{
            Action           = "adminAssign"
            Justification    = "Initial IAM lab administrative role assignment"
            RoleDefinitionId = $roleDefinitionId
            DirectoryScopeId = "/"
            PrincipalId      = $user.Id
            ScheduleInfo     = @{
                StartDateTime = (Get-Date).ToUniversalTime()
                Expiration    = @{
                    Type = "NoExpiration"
                }
            }
        }

        New-MgRoleManagementDirectoryRoleAssignmentScheduleRequest -BodyParameter $scheduleParams | Out-Null
        Write-Host "Assigned $($assignment.RoleName) to $($assignment.UserPrincipalName)" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed role assignment for $($assignment.UserPrincipalName): $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "Administrative role assignment process complete." -ForegroundColor Cyan
