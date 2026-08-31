---
kind: result
role: locksmith
host: endolin-garden-ece02cb4
at: 2026-08-31T08:40:39Z
---
# locksmith review — kriscendobot/minion.town PR #69 (panel seat)

Dispatch: jury seat `locksmith`, gauntlet `minion-town-weblet-ocap-synthesis-units-4-5`.
Worktree reviewed: `.` (HEAD `d454e6c`), base `origin/main`.

### locksmith

**Verdict:** approve

**Findings:**

- None must-fix. The diff's central capability-flow change —
  `src/endo/gateway/publish.ts:79-96` (`assertPowerPetName`) dropping the
  `name.startsWith("@")` rejection — looks at first read like a new grant (a
  caller can now request a `@`-prefixed special reference), but it is not: the
  actual resolution happens inside the guest's own `E(self).copy([powerPetName],
  …)` (`src/endo/gateway/daemon-site-registry.ts:207`, unchanged by this PR),
  where `self` is bound to the caller's own `@agent`. Resolution never leaves
  guest scope, so `@self`/`@host`/`@agent` there designate only what that guest
  already holds, never a gateway- or top-host-scoped lookup. This matches
  `designs/weblet-ocap-synthesis.md` § 1's "guest can only publish powers it
  holds — synthesis, not amplification" and is exercised by the new
  guest-scoped-rejection test in `test/gateway/publish.test.ts` ("accepts a held
  @ name and rejects an unheld name in the guest"). No new grant. [rule:
  designs/weblet-ocap-synthesis.md]
- `src/endo/gateway/vhost-table.ts:118-124,215-224` tightens (not loosens) the
  fail-closed predicate: a record carrying both a valid `directoryId` and a
  legacy `powers` string is now unservable outright, where the prior `&&`-gated
  condition would have let such a mixed record fall through to the
  directory-backed path. Confirmed by the new `mixedId` case in
  `test/gateway/publish.test.ts`. Good tightening, no action needed. [rule:
  designs/weblet-ocap-synthesis.md § 6 fail-closed]
- `src/endo/gateway/powers-plane.ts`: `back` is read from the introduced
  directory and handed to `terminateCapTP` as the CapTP bootstrap
  (`powers-plane.ts:163-168`). This is the same capability the pre-existing
  `Promise.resolve(back)` path already exposed; the diff only removes the
  now-dead buffer/promise machinery around an already-resolved value, no
  widened surface at the boundary crossing (WS → CapTP bootstrap). [rule:
  designs/weblet-ocap-synthesis.md § 2.3]

**Notes (out of scope but worth flagging):**

- None.

Self-improvement: no gap found in the brief; the recurring "docs-only PR
grants an undocumented capability" and "runtime-flag attenuation" patterns this
seat watches for did not apply here — the actual pattern (a blocklist replaced
by removing a redundant belt-and-suspenders check once the guest-scoped
enforcement was verified to already exist) isn't in the brief's list of
recurring findings. Worth a one-line addition to the brief's recurring-findings
section if this shape (relying on an already-reviewed inner enforcement point
instead of a duplicate outer blocklist) recurs across other PRs; not urgent
enough to action now.
