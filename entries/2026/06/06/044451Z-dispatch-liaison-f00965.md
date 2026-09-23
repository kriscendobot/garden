---
ts: 2026-06-06T04:44:51Z
kind: dispatch
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/06/040545Z-tick-liaison-125c28.md
---

Dispatched boatman (dispatch-root `dispatches/boatman--f00965`) to **re-ferry the retconned bots#351** onto endojs/endo#2422. Shape-2 recompute (force-push); a **structure-only change** carrying the bot's regroup upstream.

State: bots#351 was rebuilt from 14 commits to a clean **4-commit** shape (`e3f0e262f` feat(ses) StrictModuleDescriptor + `158b22f9d` feat(compartment-mapper) host module exits + `caa766b6b` test(import-bundle) round-trip + `d52d2e2b6` docs(changeset)), all endolinbot, base master. **Net diff is byte-identical** to the current #2422 (382 content lines, same 20-file set) - a pure regroup, no content change.

#2422 (head `a509e0e66`, 14 commits, MERGEABLE, **APPROVED** by dckc + boneskull, naugtur COMMENTED; approvals anchored to old ancestor 1bf012f0b). endo master `5865ff102` (moved). endo master is NOT branch-protected, so the force-push preserves the approvals (verified pattern across prior #2422 re-ferries this session).

Boatman brief (Shape 2): fetch origin (exact refs/heads/master); detach at origin/master `5865ff102`; cherry-pick bots#351's 4 commits in order (`e3f0e262f` `158b22f9d` `caa766b6b` `d52d2e2b6`); if yarn.lock-or-other conflicts on the newer master, regenerate; normalize author+committer of all 4 to `Kris Kowal <kriskowal@kriskowal.com>`; strip `(#351)` suffixes + any trailers; RUN `interpret-trailers --parse` EMPTY on all 4; verify net diff matches bots#351 (same 382-line content); force-with-lease against `a509e0e66` to `kriskowal-ponyfill-host-module`; confirm #2422 MERGEABLE and **dckc + boneskull APPROVED persist** (surface prominently if either drops); edit cross-link 4576217955 to the new head. `identity_switch_authorized: true`.

Expected report: new #2422 head, force-with-lease confirmation, 4-commit structure all Kris Kowal + trailers-empty, net-content-unchanged confirmation, approvals-persist (dckc+boneskull), mergeable, CI, edited cross-link.
