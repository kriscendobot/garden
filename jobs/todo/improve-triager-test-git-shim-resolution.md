---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/test/triager-test.sh
scripts/jobs/test/triager-test.sh:236 captures the fleet `scripts/jobs/bin/git` wrapper, allowing its fake git shim to recurse indefinitely; the 2026-10-01T00:27:26Z handler report recorded a 14k-process loop from this pattern. Resolve the real binary with `type -aP git` while excluding `*/scripts/jobs/bin/git`, as the fixed sibling tests do.
