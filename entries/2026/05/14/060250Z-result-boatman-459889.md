---
ts: 2026-05-14T06:02:50Z
kind: result
role: boatman
project: endo
worktree: dispatches/boatman--re-ferry-bytes-223--20260514-055534--07a6c4/project
repo: endojs/endo
to: liaison
refs:
  - entries/2026/05/14/055620Z-dispatch-liaison-9d2c47.md
  - entries/2026/05/14/011200Z-result-liaison-9c4e2a.md
  - entries/2026/05/14/010122Z-result-boatman-3f1498.md
  - entries/2026/05/14/060250Z-message-boatman-e95131.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 223
    role: source
  - repo: endojs/endo
    pr: 3257
    role: target
---

Re-ferried `endojs/endo-but-for-bots#223` upstream as the new tip of `endojs/endo#3257`.

- Upstream PR: https://github.com/endojs/endo/pull/3257
- Upstream branch: `endojs/endo:feat/endo-bytes-package`
- Upstream head SHA (new): `71c102f0d` (force-push; prior tip `f20f1f18d` from the first ferry).
- Source PR: https://github.com/endojs/endo-but-for-bots/pull/223 (head `a39c99325`, prior ferry was at `1baf237a`; left open with follow-up cross-link comment https://github.com/endojs/endo-but-for-bots/pull/223#issuecomment-4448073976).

Approach: same as the prior ferry. Squash-applied the diff `c2fc02eb8..a39c99325` (merge base of new source tip with current `upstream/master` is unchanged at `c2fc02eb8`) onto a fresh detached HEAD off `upstream/master` (`052b0487e`, advanced 21 commits past prior ferry's `f20f1f18`-base; the advance is entirely `.github/workflows/*` zizmor hardening, no overlap with the source diff). Single squashed commit `71c102f0d`, attribution `Kris Kowal <kris@cixar.com>` for both author and committer. `git interpret-trailers --parse` reports empty: no `Co-authored-by`, no `Generated with Claude Code`, no bot trailers. Force-pushed with `--force-with-lease=feat/endo-bytes-package:f20f1f18d...` so the lease guarded against any unexpected upstream advance.

The new tip's diff scope is identical to the source tip's diff scope: 49 files, +1118/-706 against the new master (vs the source's +1065/-737 against its own merge-base; the difference is the workflow lines upstream master's advance removed, not source-side change). `git diff HEAD a39c99325` confirms the only deltas are the upstream-side workflow file changes; all source-controlled paths match exactly.

Three new commits on the source side since the prior ferry, all addressing Copilot review on `endojs/endo#3257`:

- `b42a52f37 docs(bytes): correct README references and CHANGELOG export list (#223)` — drops the dead `designs/endo-bytes.md` link, softens "captured and frozen" to "captured", expands the 0.1.0 CHANGELOG export list to the full seven.
- `8ccbdce29 fix(cli): drop unused @endo/compartment-mapper dependency (#223)` — removes a dep accidentally added during the migration; no source under `packages/cli` imports it.
- `a39c99325 chore: Update yarn.lock`

All three are folded into the single upstream commit and described in the steward-bound message (`060250Z-message-boatman-e95131.md`) for posting on `endojs/endo#3257` to keep the upstream maintainer and the Copilot review thread in sync. The boatman cannot post on primary repos directly under the kriskowal identity; the identity switch is gated to pushes only per the boatman role's "comments on primary upstream repos route through the steward" norm.

Source-side cross-link follow-up posted directly (the source repo `endojs/endo-but-for-bots` is the garden, not a primary): https://github.com/endojs/endo-but-for-bots/pull/223#issuecomment-4448073976.

Identity verification: `gh auth status` reports `kriskowal` as the active account. `git config user.email` was overridden per-commit via `GIT_AUTHOR_*` and `GIT_COMMITTER_*` env vars to ensure `kris@cixar.com` rather than the worktree's local `noreply` address.

Self-improvement: nothing this time. The procedure was a direct rerun of the first-ferry procedure with a force-push instead of a fresh push; both branches of the boatman role's "rebase-and-rewrite-and-push procedure" comment in `roles/boatman/AGENT.md` are now exercised (initial ferry and re-ferry-with-fast-forward-source-advance), and the same shape worked. If a third ferry on the same upstream PR ever needs to reconcile parallel upstream-side commits (rather than a clean replace as here), that would be a structural lesson; this case did not surface one.
