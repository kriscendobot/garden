---
ts: 2026-05-19T06:39:36Z
kind: result
role: fixer
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 252
    role: target
---

# PR #252 fix-up: kriskowal CHANGES_REQUESTED round (14 inline comments)

## Outcome

All 14 inline comments from kriskowal's 2026-05-19T06:06:04Z review
addressed in nine commits pushed to
`design/ocapn-noise-session-reconnect` (head `b497f6903`). 14 inline
thread replies posted citing addressing SHAs. Top-level summary
comment posted
(<https://github.com/endojs/endo-but-for-bots/pull/252#issuecomment-4485069936>).
kriskowal re-requested via `gh pr edit --add-reviewer`. No CI runs
for design-only PRs on this repo (verified: zero check-runs, zero
statuses on the head SHA); CI convergence is trivial. PR is OPEN,
not-draft, mergeable state DIRTY (base `llm` is behind; weaver
follow-up if maintainer needs it before next review pass).

## Per-comment disposition

| Comment | Action | SHA |
|---|---|---|
| L14 citation TCP keepalive | Linux `tcp_keepalive_time` 7200 s, `man 7 tcp`, ip-sysctl.rst | `47153eb` |
| L16 citation 4-day kernel idle | RFC 1122 R2, Linux `tcp_retries2` | `47153eb` |
| L31 procedural cruft | Removed (garden's senior contributor) | `6ca3801` |
| L117 procedural cruft | Removed (2026-05-14 maintainer directive) | `6ca3801` |
| L121 codec coverage | All codecs incl. CBOR | `832c4c6` |
| L128 single op:ping | P1 settled (single op:ping for liveness) | `4242daa` |
| L135 inside only | P2 settled (heartbeat inside Noise) | `4242daa` |
| L203 designator material | IK ephemeral x25519, not signing Ed25519 | `ad10df7` |
| L247 Noise IK | Replaced "XX (or whichever pattern)" | `eeccc1f` |
| L327 exhaustive tests | Acknowledged on-thread | (no commit) |
| L330 resume good | Acknowledged on-thread | (no commit) |
| L337 op:pong | C2 settled (op:pong as explicit ack carrier) | `4242daa` |
| L642 op:pong for ack | Same as L337 | `4242daa` |
| L663 provisional Noise-only | § Compatibility leads with explicit scoping bullet | `12944b6` |

Additional commits: `ede792f` (designs/README.md Updated date),
`b497f69` (tidy two stale § 1 references to settled C2).

## Gardener-shaped notes

1. **Local project worktree was at a stale tip.** The dispatch's
   `project/` worktree HEAD was `5cadc3b42` ("design(ocapn,noise):
   session reconnect with heartbeat"); the actual PR head on origin
   was `94ad5162a` plus 10 follow-up commits. `5cadc3b42` had a
   wildly different working-tree state (hundreds of unrelated files:
   PLAN/, TADA/, packages/genie/, etc.) versus the 709-line design
   doc the review comments referenced. Fixed by `git checkout
   94ad5162a` (after fetching origin) before applying any edits.
   This may indicate the `dispatch-prepare.sh` did not pin the
   project subworktree to the PR's actual head, or the branch local
   pointer drifted. Worth a gardener look at whether the
   per-dispatch project worktree should always `git fetch origin
   <branch>` and `git checkout origin/<branch>` rather than rely on
   a possibly-stale local branch pointer.

2. **No-CI design PRs and the "drive CI to green before re-request"
   norm.** `roles/fixer/AGENT.md` § Operating norms says "drive CI
   to green BEFORE re-requesting maintainer review." On
   endojs/endo-but-for-bots design-only PRs, the head SHA has zero
   check-runs and zero statuses (CI is not configured for design-doc
   paths). The norm reads cleanly: "green" is vacuously true when
   no checks exist, so re-requesting is fine. Worth a one-sentence
   clarification in the norm: "When no checks are configured for the
   branch (zero check-runs and zero statuses on the head SHA), CI
   convergence is trivial and the fixer may re-request immediately."
   The current prose does not say this and a future fixer might
   sit waiting for CI that will never run.

3. **Procedural cruft pattern in design docs.** Two of the 14
   comments (L31, L117) and a third paragraph I dropped under the
   same heading (the post-prompt "Maintainer directive 2026-05-14,
   relaying erights' framing" footer) flagged the same anti-pattern:
   designer-authored design docs were attributing the directive's
   source as in-prose body text. The designer's role file could
   carry a "do not embed dispatch provenance in the design doc"
   norm: the journal carries the provenance; the design doc carries
   only the substance. Worth a small note on `roles/designer/AGENT.md`.

Self-improvement: nothing structural this time; the three notes
above are routed to the liaison as recommendations for the
gardener / designer-role file rather than as immediate fixer-skill
edits. The fixer skill stack (`pr-review-thread-replies`,
`review-feedback-followup-commits`) worked cleanly as documented for
this 14-comment, design-only round; the per-skill "Notes from the
field" did not need new entries.
