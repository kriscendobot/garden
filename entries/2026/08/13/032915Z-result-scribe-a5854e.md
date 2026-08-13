---
kind: result
role: scribe
host: endolin-garden2-5bcdff64
at: 2026-08-13T03:29:17Z
---
# scribe review — endojs/endo-but-for-bots PR #977 (panel seat)

Dispatch: jury seat `scribe`, gauntlet `ebfb-guest-unconfined-from-tree-gauntlet`.
Worktree reviewed: `scratch/project-wt-ebfb-guest-unconfined-from-tree-6af9e48f`
(HEAD `dad2cf084e`), base `origin/llm-0ac48c5`.

Verdict: comment-only.

Knowledge-capture closure, ask by ask:

- **Maintainer note-this asks: none.** `pulls/977/comments` is empty; the only
  entry in `issues/977/comments` is the bot's own fix-round summary; every
  `pulls/977/reviews` entry is the panel-1 bot review. No maintainer (kriskowal)
  comment exists on this PR, so this seat's primary surface is empty and nothing
  is open on it.
- **Deployment-path escape (PR body: "tracked privately and is deliberately not
  described here") — CLOSED.** Journal record exists:
  `inbox/maintainer/read/20260813T025443Z-6342c1.md` names the confirmed
  minion.town gateway escape and the remediation PR
  (private `kriscendobot/minion.town#44`); `jobs/tada/minion-town-weblet-powers-host-escape-fix.md`
  carries the completion.
- **assessor's `[proposed-rule]` (panel-1) on daemon socket-path length — already
  captured.** `skills/local-verify/SKILL.md:449-459` (landed 2026-07-28) documents
  the 108-byte `sun_path` limit against the ~90-byte per-job worktree path and
  assigns the fix to `scripts/jobs/ensure-project-worktree.sh`. Accepted as
  standing-orders closure. **Open, low:** the build round's *working* workaround
  (a temporary short socket directory, which got the full 228-test file green) is
  recorded only in the PR body — the existing note still reads "NOT yet closed"
  and has no operative workaround. `summary-fix`.
- **Completion-summary closure — SATISFIED.** The panel-1 request-changes review
  drew a responding push (`76b26a3f36`, 2026-08-13T03:16:53Z) and the doer posted
  a top-level summary comment `#issuecomment-5275541597` naming the SHA, the
  per-seat itemization, and the verification status, per
  `skills/pr-completion-summary-comment/SKILL.md`. Not inline-only.

Process alert raised to the judge: the worktree this seat was pointed at is at
`dad2cf084e`, the **pre-fix** commit; the PR head is `76b26a3f36`. Every seat in
this round is reading a diff the fix round already superseded. No standing rule
in `skills/panel/SKILL.md` or `skills/worktree-per-pr/SKILL.md` requires a panel
stage to re-sync its worktree to the PR head before dispatching seats;
`[proposed-rule]` filed in the per-juror block.

Self-improvement: the note-this surface was empty, so the load-bearing check this
round was the *freshness of the reviewed tree* — a precondition no seat's brief
tells it to verify. Proposing that check as a panel-stage rule is the durable
form; adding it to this seat's brief alone would leave the other 30-odd seats
reading stale diffs silently.
