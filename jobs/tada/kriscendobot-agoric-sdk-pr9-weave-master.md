The weave is complete. The branch touches no orchestration files and its `fetched-chain-info.js` is now byte-identical to current master, so the `test-codegen` non-determinism (stale-base dirty `fetched-chain-info.js`) is resolved. This was a pure project-repo operation — no garden library changes to commit.

---

## Completion report

**Job:** Rebase kriscendobot/agoric-sdk PR #9 (`garden29-promote-ymax-critical`) onto current master.

**Root cause of the base lag:** The PR branch sat on the fork's `origin/master`, which was **505 commits behind** upstream `master` (`ef8eb1c174`) — exactly the "~500-commit base lag." The branch itself was already on top of the *stale* fork master (0 behind it), so the lag was entirely in the fork's master pointer.

**What I did:**
- Rebased all 10 branch commits onto current master (`upstream/master` = `ef8eb1c174`). **Zero conflicts** — clean replay across all 10 commits.
- Verified net intent preserved **verbatim**: identical 10-file diff, `527 insertions / 6 deletions` before and after (ymax contract-vat → `critical` promotion at chain upgrade + the `n:upgrade-next` a3p critical-vat rehearsal test). No substantive change.
- Fast-forwarded the fork's `master` to current (`37a4fa3196..ef8eb1c174`) so the PR base is current and the diff recomputes to just the 10 commits (otherwise it would show 505+10). Confirmed it was a clean fast-forward (fork's master was a strict ancestor of upstream — no fork-authored master changes, just catching up to Agoric).
- Force-pushed the rebased head with `--force-with-lease` against the old SHA (`95130d9fed…78d700703a`).

**Guardrail honored:** All pushes targeted the `kriscendobot` fork only. Never touched, commented on, or linked upstream `agoric/agoric-sdk` (the upstream ref was fetched read-only).

**Result:**
- **New head SHA:** `78d700703a43f507f7b61b0e409a72f95708ba59`
- PR #9: `base=master`, 10 commits, **MERGEABLE** (state UNSTABLE = CI re-running against the new base, not a conflict).

**CI expectation:** The lone remaining red (`test-codegen`) was a stale-base artifact — `packages/orchestration/src/fetched-chain-info.js` reporting dirty after `yarn codegen`. Confirmed the rebased branch touches **no** orchestration files and its `fetched-chain-info.js` is now byte-identical to current master, so `yarn codegen` will produce no diff. That red is cleared. Every other PR-scope check was already green, so the PR is expected to go fully green (subject to the usual chance that master's 505-commit advance introduced new baseline checks; none apply to this diff's scope).

**Follow-ups:** None required. PR is review-ready.
