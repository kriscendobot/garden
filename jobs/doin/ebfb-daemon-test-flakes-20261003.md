---
role: fixer
tier: mentor
handler-timeout: 10800
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-03T03:43:34Z cleared=none -->

---
role: fixer
handler-timeout: 10800
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix the flaky @endo/daemon test suite on endojs/endo-but-for-bots (llm)

Maintainer (kriskowal, liaison muster 2026-10-03): "Fix the red-CI gauntlets."

Six gauntlets halted on red CI (endojs/endo-but-for-bots PRs #1417, #1412, #1408,
#1404, #1392, #1396). Every failure was in `@endo/daemon#test`, never in the code
the PRs changed, and the signature varied by matrix cell. Observed:
- `test (22.x, macos-15)`: `daemon-teardown › an orphaned daemon shuts itself down
  instead of lingering` failed its "daemon recorded its pid before its launcher
  exited" check (#1392).
- `test (22.x, ubuntu-latest)`: unhandled rejection `Error: Termination requested`
  after `endo › EndoHost/EndoGuest do not carry readOnly() at runtime today`
  passed (#1396).
- `test (24.x, macos-15)`: unhandled rejection `TypeError: Cannot assign to read
  only property 'message' of object 'ClientDestroyedError'`, twice (#1396). This one
  smells like a real hardening bug (mutating a frozen error), not a timing flake.
- Known prior flake: ws-relay "connect fails gracefully" unhandled rejection on
  22.x/ubuntu.

Task: reproduce from the CI logs of those runs (and local repeated runs), root-cause
each signature, and fix the tests or daemon code so they are deterministic. Do not
paper over with blanket retries or skips; a targeted wait-for-condition is fine.
Open a DRAFT PR against a frozen `llm-<sha7>` base with the fixes and evidence
(repeat-run counts). Report the PR URL. A separate sibling job is resuming the six
gauntlets, so do not push to those PR branches.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-03T03:50:36Z
