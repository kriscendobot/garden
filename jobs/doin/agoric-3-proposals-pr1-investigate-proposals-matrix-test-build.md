# Investigate upstream #320 `proposals-matrix-test / build` failure; propose fixes on mirror PR #1
Repo: **kriscendobot/agoric-3-proposals** (BOT FORK; bot identity). PR #1 (mirror of upstream #320) —
branch `add-proposals-111-116`, head e32d6ca43, MERGEABLE/CLEAN —
https://github.com/kriscendobot/agoric-3-proposals/pull/1.
**Status:** upstream Agoric/agoric-3-proposals#320 CI — `test-packages` now PASSES (fixed earlier), but
**`proposals-matrix-test / build` STILL FAILS**, even though a prior job reported it fixed. That "fixed"
claim did not hold — likely because it wasn't verified against the REAL upstream check (the fork's CI may
not run Agoric's full matrix). Do it properly this time.
**HARD SCOPE:** read #320 + its failing CI logs **READ-ONLY**. No upstream Agoric contact. Fixes + summary
on the FORK PR #1 only.
**Task:**
1. Read the upstream #320 **`proposals-matrix-test / build`** job log (read-only) for the concrete error.
2. **Reproduce it locally / on the fork** — actually run the `proposals-matrix-test` build step against the
   branch. A green fork check is NOT proof (the earlier failure recurred exactly because a code-level
   "fixed" wasn't reproduced against the real matrix — same trap as PR #58's test-harness-vs-real bug).
3. Diagnose the root cause and **propose + apply the fix** on `add-proposals-111-116`, push to the fork.
4. **Confirm the reproduced failure now passes locally.** Verification-integrity: do NOT report fixed
   without a reproduced-then-green run; if you cannot reproduce the matrix build locally, say so honestly
   and state exactly what's needed (env, the a3p tooling) rather than asserting.
5. Post a **summary comment on fork PR #1**: the diagnosis, the fix, and the reproduced-then-passing
   evidence (or the honest can't-reproduce). Preserve the retconned structure + net diff (proposals
   111–116, bundles, documented 113, changeset).

---
claim:
  host: endolinbot2
  gardener: 71
  claimed_at: 2026-07-01T23:42:37Z
