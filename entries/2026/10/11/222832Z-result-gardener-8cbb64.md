---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-11T22:28:34Z
job: improve-dependabot-terminal-close-routing
claim: 5753a1c348e80088
---
# Dependabot terminal-close routing completed

- Updated the watcher to emit host-pinned, machine-readable terminal-close directives for superseded and incompatible outcomes.
- Added a no-LLM gardener execution path that revalidates the live proof and closes the PR on the write-capable host.
- Decoupled verdict commenting from closing: a comment 403 is recorded as `comment-status: failed`, while the close is still attempted and recorded independently.
- Covered Node/peer incompatibility, literal/contained supersession, changed-proof fallback, and the PR #1439 comment-failure regression.
- Verification: `scripts/jobs/test/dependabot-watcher-test.sh` (68 passed); `scripts/jobs/test/dependabot-engine-close-test.sh` (5 passed); `scripts/jobs/test/dependabot-terminal-close-test.sh` (2 scenarios passed); `scripts/jobs/test/dependabotany-preflight-test.sh` (43 passed); `tests/checks/run.sh` (13 suites passed).
- Landed on `main2` as `e5294cb9759`.

Self-improvement: nothing this time.
