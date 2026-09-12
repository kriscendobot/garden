---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardening/pre-push-gates.sh
Add a deterministic changed-source probe that rejects literal NUL bytes in text source/test files before push, with an escape-based remediation message. A fixer committed NUL bytes that made GitHub and git diff treat the test as binary, hiding the PR’s primary evidence.
