
---

### architecture/privileged-access-flow.md

```markdown
# Privileged Access Flow

```mermaid
flowchart TD

AdminUser --> PIMEligibleRole
PIMEligibleRole --> RequestActivation
RequestActivation --> MFA
MFA --> Approval
Approval --> TemporaryAdminAccess
TemporaryAdminAccess --> RoleExpiration
