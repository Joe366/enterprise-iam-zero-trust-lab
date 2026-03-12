# =========================================================
# Script: assign-users-to-groups.ps1
# Purpose: Assign JoshTest366 users to department/admin groups
# Notes:
# - This script uses explicit user-to-group mappings
# - Group names follow the IAM lab naming convention
# =========================================================

Import-Module Microsoft.Graph.Users
Import-Module Microsoft.Graph.Groups

Connect-MgGraph -Scopes "User.Read.All","Group.ReadWrite.All","Directory.ReadWrite.All"

# ---------------------------------------------------------
# Group lookup table
# Replace these IDs with your actual tenant group IDs
# ---------------------------------------------------------
$GroupMap = @{
    "IT-Admins"            = "11111111-1111-1111-1111-111111111111"
    "IT-Support"           = "22222222-2222-2222-2222-222222222222"
    "Finance-Team"         = "33333333-3333-3333-3333-333333333333"
    "HR-Team"              = "44444444-4444-4444-4444-444444444444"
    "Clinical-Operations"  = "55555555-5555-5555-5555-555555555555"
    "Contractor-Access"    = "66666666-6666-6666-6666-666666666666"
}

# ---------------------------------------------------------
# User-to-group assignments based on your environment
# ---------------------------------------------------------
$Assignments = @(
    @{ UserPrincipalName = "chris.green@joshtest366.onmicrosoft.com";      GroupName = "IT-Admins" },
    @{ UserPrincipalName = "matthew.haney@joshtest366.onmicrosoft.com";    GroupName = "IT-Admins" },

    @{ UserPrincipalName = "patrick.clancy@joshtest366.onmicrosoft.com";   GroupName = "IT-Support" },
    @{ UserPrincipalName = "roxanne.gilbert@joshtest366.onmicrosoft.com";  GroupName = "IT-Support" },

    @{ UserPrincipalName = "betty.villalba@joshtest366.onmicrosoft.com";   GroupName = "Finance-Team" },
    @{ UserPrincipalName = "linda.sanders@joshtest366.onmicrosoft.com";    GroupName = "Finance-Team" },
    @{ UserPrincipalName = "gary.atkin@joshtest366.onmicrosoft.com";       GroupName = "Finance-Team" },

    @{ UserPrincipalName = "jennifer.flores@joshtest366.onmicrosoft.com";  GroupName = "HR-Team" },
    @{ UserPrincipalName = "kelly.caldwell@joshtest366.onmicrosoft.com";   GroupName = "HR-Team" },
    @{ UserPrincipalName = "michelle.hanlon@joshtest366.onmicrosoft.com";  GroupName = "HR-Team" },

    @{ UserPrincipalName = "adriana.tejada@joshtest366.onmicrosoft.com";   GroupName = "Clinical-Operations" },
    @{ UserPrincipalName = "brandy.johnson@joshtest366.onmicrosoft.com";   GroupName = "Clinical-Operations" },
    @{ UserPrincipalName = "jacquelyn.ward@joshtest366.onmicrosoft.com";   GroupName = "Clinical-Operations" },
    @{ UserPrincipalName = "corey.foster@joshtest366.onmicrosoft.com";     GroupName = "Clinical-Operations" },
    @{ UserPrincipalName = "albert.gendreau@joshtest366.onmicrosoft.com";  GroupName = "Clinical-Operations" }
)

foreach ($item in $Assignments) {
    try {
        $user = Get-MgUser -Filter "userPrincipalName eq '$($item.UserPrincipalName)'" -ConsistencyLevel eventual
        if (-not $user) {
            Write-Host "User not found: $($item.UserPrincipalName)" -ForegroundColor Yellow
            continue
        }

        $groupId = $GroupMap[$item.GroupName]
        if (-not $groupId) {
            Write-Host "Group ID not found for: $($item.GroupName)" -ForegroundColor Red
            continue
        }

        $existingMembers = Get-MgGroupMember -GroupId $groupId -All
        $alreadyMember = $existingMembers.Id -contains $user.Id

        if ($alreadyMember) {
            Write-Host "$($item.UserPrincipalName) is already in $($item.GroupName)" -ForegroundColor Yellow
            continue
        }

        New-MgGroupMember -GroupId $groupId -DirectoryObjectId $user.Id
        Write-Host "Added $($item.UserPrincipalName) to $($item.GroupName)" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to add $($item.UserPrincipalName) to $($item.GroupName): $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "Group assignment complete." -ForegroundColor Cyan
