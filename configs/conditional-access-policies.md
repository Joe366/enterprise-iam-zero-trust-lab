# Conditional Access Policies

## CA001 – Require MFA for All Users
- Users: All users
- Exclusions: Emergency admin / break-glass account
- Apps: All cloud apps
- Grant control: Require MFA

## CA002 – Block Legacy Authentication
- Users: All users
- Exclusions: Emergency admin / break-glass account
- Apps: All cloud apps
- Condition: Legacy authentication clients
- Grant control: Block access

## CA003 – Require MFA Outside Trusted Locations
- Users: All users
- Exclusions: Emergency admin / break-glass account
- Apps: All cloud apps
- Condition: Any location excluding trusted location
- Grant control: Require MFA

## CA004 – Secure Administrative Accounts
- Users: Directory roles
- Roles: Global Administrator, User Administrator, Security Administrator, Helpdesk Administrator
- Grant controls:
  - Require MFA
  - Require device to be marked as compliant
- Session control:
  - Sign-in frequency enforced

## CA005 – Block High-Risk Sign-Ins
- Users: All users
- Exclusions: Emergency admin / break-glass account
- Condition: High sign-in risk
- Grant control: Block access

## CA006 – Force Password Reset for High-Risk Users
- Users: All users
- Exclusions: Emergency admin / break-glass account
- Condition: High user risk
- Grant control: Require password change
