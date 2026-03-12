
# Identity Flow

```mermaid
flowchart TD

User --> EntraID
EntraID --> ConditionalAccess
ConditionalAccess --> MFA
MFA --> DeviceCheck
DeviceCheck --> ApplicationAccess
