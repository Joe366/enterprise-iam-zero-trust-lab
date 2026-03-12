
---

### architecture/device-compliance-flow.md

```markdown
# Device Compliance Flow

```mermaid
flowchart TD

Device --> IntuneEnrollment
IntuneEnrollment --> CompliancePolicy
CompliancePolicy --> Compliant
CompliancePolicy --> NonCompliant
Compliant --> ConditionalAccess
ConditionalAccess --> AccessGranted
