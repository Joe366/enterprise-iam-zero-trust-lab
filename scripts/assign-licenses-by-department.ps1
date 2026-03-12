# =========================================================
# Script: assign-licenses-by-department.ps1
# Purpose: Assign licenses based on department
# Licensing model used in this IAM lab:
# - Microsoft 365 E5 -> Information Technology, Finance, HR
# - Office 365 E5    -> Clinical Operations
#
# IMPORTANT:
# Replace the sample SKU GUIDs below with your real tenant SKU IDs
# You can find them with:
# Get-MgSubscribedSku | Select SkuPartNumber, SkuId
# =========================================================

Import-Module Microsoft.Graph.Users
Import-Module Microsoft.Graph.Identity.DirectoryManagement

Connect-MgGraph -Scopes "User.ReadWrite.All","Organization.Read.All","Directory.Read.All"

# ---------------------------------------------------------
# Replace these with the actual SkuId values from your tenant
# ---------------------------------------------------------
$SkuMap = @{
    "Microsoft365E5" = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"   # Example placeholder
    "Office365E5"    = "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"   # Example placeholder
}

# ---------------------------------------------------------
# Department-to-license mapping for your environment
# ---------------------------------------------------------
$DepartmentLicenseMap = @{
    "Information Technology" = $SkuMap["Microsoft365E5"]
    "Finance"                = $SkuMap["Microsoft365E5"]
    "HR"                     = $SkuMap["Microsoft365E5"]
    "Clinical Operations"    = $SkuMap["Office365E5"]
}

$users = Get-MgUser -All -Property Id,DisplayName,UserPrincipalName,Department

foreach ($user in $users) {
    try {
        if ([string]::IsNullOrWhiteSpace($user.Department)) {
            Write-Host "Skipping $($user.UserPrincipalName) - no department value" -ForegroundColor Yellow
            continue
        }

        if (-not $DepartmentLicenseMap.ContainsKey($user.Department)) {
            Write-Host "Skipping $($user.UserPrincipalName) - no license mapping for $($user.Department)" -ForegroundColor Yellow
            continue
        }

        $skuId = $DepartmentLicenseMap[$user.Department]

        $currentLicenses = Get-MgUserLicenseDetail -UserId $user.Id -ErrorAction SilentlyContinue
        $alreadyAssigned = $currentLicenses | Where-Object { $_.SkuId -eq $skuId }

        if ($alreadyAssigned) {
            Write-Host "$($user.UserPrincipalName) already has target license" -ForegroundColor Yellow
            continue
        }

        Set-MgUserLicense -UserId $user.Id -AddLicenses @{SkuId = $skuId} -RemoveLicenses @()
        Write-Host "Assigned license to $($user.UserPrincipalName)" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed licensing for $($user.UserPrincipalName): $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "License assignment complete." -ForegroundColor Cyan
