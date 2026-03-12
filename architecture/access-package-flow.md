
---

### architecture/access-package-flow.md

```markdown
# Access Package Flow

```mermaid
flowchart TD

UserRequest --> AccessPackage
AccessPackage --> ManagerApproval
ManagerApproval --> GroupAssignment
GroupAssignment --> AccessExpiration
AccessExpiration --> AccessReview
