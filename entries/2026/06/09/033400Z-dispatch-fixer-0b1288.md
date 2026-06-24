---
ts: 2026-06-09T03:34:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--0b1288
prs:
  - repo: endojs/endo-but-for-bots
    pr: 401
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/401
  - https://github.com/endojs/endo-but-for-bots/pull/401#pullrequestreview-4454004632
  - https://github.com/endojs/endo-but-for-bots/pull/401#discussion_r3376831072
---

# dispatch: fixer — adopt `die` idiom throughout PR #401 .sh changes (kriskowal RSVP)

User directive (2026-06-09T03:32Z, "rsvp …pull/401#pullrequestreview-4454004632"):
apply kriskowal's CHANGES_REQUESTED review on the shellcheck-CI PR.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#401`
  ("chore(shellcheck): add yarn shellcheck script and CI workflow"),
  DRAFT, base `master-814dfa1` (frozen-base-branch snapshot),
  head `chore/shellcheck-ci` at `46ba165285ae4500a881ec3e3236bbd4cbab0607`
  (`46ba1652`). `mergeable: MERGEABLE`, `mergeStateStatus: UNSTABLE`,
  `reviewDecision: CHANGES_REQUESTED`.
- **Review** `4454004632`, CHANGES_REQUESTED, body **empty** — substance is
  in the inline comment below. Submitted 2026-06-08T23:01:20Z by kriskowal.
- **Inline comments** tied to this review
  (`pull_request_review_id == 4454004632`), enumerated per memory rule
  *Fetch ALL inline comments tied to a review*:
  1. `packages/nat/scripts/npm-audit-fix.sh:3` (id `3376831072`):
     > Early termination should exit non-zero and emit an error message
     > to stderr, as with the `die` pattern from Perl. Please research
     > the appropriate idiom and apply throughout.

Only one inline comment, but the maintainer's `apply throughout` framing
extends the rule beyond `npm-audit-fix.sh:3` to every early-termination
site in the .sh files this PR touched.

## Task

In your `project/` worktree on the `chore/shellcheck-ci` branch
(currently at `46ba1652`):

1. **Research the canonical `die` shell idiom.** Perl's `die "msg\n"`
   writes to STDERR and exits non-zero. The standard shell translation
   is something like:
   ```sh
   die() { printf '%s\n' "$*" >&2; exit 1; }
   ```
   …but verify the project's prevailing style. Grep the tree for
   existing `die()` definitions or any equivalent helper
   (`fail()`, `error_exit()`, etc.). If something canonical already
   exists, use it. If not, the printf-to-stderr-then-exit-1 form is
   the safe pick (avoids `echo -e` portability traps).
2. **Enumerate every early-termination site** the PR touched. The PR
   body lists the seven files with mechanical cleanups; start there:
   - `packages/compartment-mapper/test/neutralize.sh`
   - `packages/nat/scripts/npm-audit-fix.sh`
   - `scripts/check-packages.sh`
   - `scripts/maintenance/check-unused-deps.sh`
   - `scripts/npm-audit-fix.sh`
   - `scripts/posttypedoc.sh`
   - `scripts/set-versions.sh`
   - plus `scripts/shellcheck.sh` (new in this PR — check it too).
   Look for `|| exit` (SC2164 fix sites) and any other place a script
   silently exits non-zero without a stderr message. The maintainer's
   "throughout" is the cue: bare `|| exit` after `cd` is exactly the
   pattern the comment objects to; `cd "$dir" || die "cd: $dir failed"`
   is the upgrade.
3. **Apply the `die` idiom.** Each touched script either defines its
   own `die()` near the top or uses the project's existing helper.
   Replace bare `|| exit` with `|| die "<context>"` (the message
   should name what failed, e.g. `cd "$dir" || die "cd to $dir failed"`).
   Where the script already had a non-zero-exit-without-message
   pattern, upgrade that too.
4. **Re-run `yarn shellcheck`** in the worktree to confirm the changes
   stay green (the gate this PR introduces should still pass).
5. **Commit** with a conventional-commit message scoped to shellcheck,
   e.g. `chore(shellcheck): adopt die idiom for early termination in
   touched .sh files`. One commit covers it; no need to split across
   files since the change is mechanical and motivated by a single
   review ask.
6. **Push** to `chore/shellcheck-ci` (regular append push).
7. **Reply on the inline thread** (`gh api repos/endojs/endo-but-for-bots/pulls/comments/3376831072/replies`)
   citing the addressing commit's SHA and naming the `die` helper
   shape you adopted. If you used an existing project helper, name it.
8. **Post a top-level summary comment** on PR #401 noting which files
   gained `die()` or `|| die "…"`, the chosen helper signature, and
   the addressing commit SHA. Re-request review from `kriskowal`
   because the review was a final CHANGES_REQUESTED (not marked
   partial) — addressing the only inline ask completes the response.

## Authorizations (per-action, forwarded by steward)

- **Push commits** to `chore/shellcheck-ci` (append push). Implicit in
  the fixer dispatch.
- **Reply on inline thread `3376831072`**. The `endo-but-for-bots`
  standing broad-comment authorization covers this.
- **Post a top-level summary comment** on PR #401. Same authorization.
- **Re-request review** from `kriskowal` once both the reply and the
  summary are posted. The review was a final CHANGES_REQUESTED (not
  partial), so re-request is appropriate.

## Out of scope

- Do NOT broaden the change to .sh files this PR did not touch. The
  maintainer's "throughout" reads as "throughout this PR's scope",
  not "throughout the repo". If you spot tempting cleanups elsewhere,
  leave them; a separate dispatch covers cross-tree adoption if the
  maintainer wants it.
- Do NOT change the shellcheck workflow's gating (paths filter,
  severity, action pins). Substance-only fix for the `die` ask.
- Do NOT rebase or force-push. Append-push only.
- Do NOT un-draft the PR; the conductor's unfreeze-before-merge step
  handles base-retarget and live-trunk rebase later.

## Deliverable

A `result` entry under `journal/entries/2026/06/09/` naming:

- Pre/post branch tip SHAs.
- The commit SHA addressing the review.
- The `die` helper shape adopted (or the existing project helper used).
- File-by-file list of sites changed.
- Local `yarn shellcheck` result (PASS expected).
- The reply-on-thread URL.
- The top-level summary comment URL.
- Whether re-request-review was posted (URL/status).
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
