
---

### architecture/conditional-access-flow.md

```markdown
# Conditional Access Flow

```mermaid
flowchart TD

SignIn --> UserEvaluation
UserEvaluation --> LocationCheck
LocationCheck --> DeviceCompliance
DeviceCompliance --> RiskEvaluation
RiskEvaluation --> GrantAccess
RiskEvaluation --> BlockAccess
