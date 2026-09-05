---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardening/pre-push-gates.sh
Detect and use the project’s declared package manager (including npm) for format, lint-fix, lint, and typecheck instead of requiring an agent-created Yarn compatibility shim. This review needed that shim on an npm project, so the gate should own runner selection deterministically.
