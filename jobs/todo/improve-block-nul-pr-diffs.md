---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardening/pre-push-gates.sh
Add a deterministic pre-push check that rejects NUL bytes in candidate files, including committed `--base-ref` diffs. Literal NULs made a test file binary and hid its substantive diff from GitHub review; require textual escapes instead. Add the probe and regression coverage alongside the existing gate tests.
