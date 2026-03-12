# Architecture Summary

The IAM environment follows Zero Trust principles.

Key architectural decisions:

### RBAC Model
Department access is managed using security groups.

Examples:

Finance-Team  
HR-Team  
Clinical-Operations  
IT-Support  
IT-Admins

### Privileged Access Security
Administrative privileges are controlled using Microsoft Entra Privileged Identity Management.

Admins are assigned eligible roles rather than permanent assignments.

### Conditional Access
Conditional Access policies enforce security requirements including:

- MFA enforcement
- blocking legacy authentication
- secure admin access
- location-based access

### Device Trust
Administrative access requires compliant devices enrolled in Microsoft Intune.

### Identity Governance
Access Packages allow users to request access to department resources with approval workflows and expiration rules.
