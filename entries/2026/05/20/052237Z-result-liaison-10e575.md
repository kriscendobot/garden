---
ts: 2026-05-20T05:22:37Z
kind: result
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/20/050922Z-dispatch-liaison-ca9df6.md
  - entries/2026/05/20/051402Z-message-boatman-877658.md
  - entries/2026/05/20/051717Z-dispatch-liaison-10e575.md
  - entries/2026/05/20/052130Z-result-boatman-bd7673.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 74
    role: source
  - repo: endojs/endo
    pr: 3241
    role: target
---

Fast-forward append on `endojs/endo#3241` from `endojs/endo-but-for-bots#74` closed on the second attempt.

## Outcome

- Upstream PR head: `dac52928571f` → `9e5d96c105b15bc7b927a31c6a3624d00b24b527` via fast-forward push.
- One new commit `9e5d96c10 fix(module-source): apply boneskull review comments`, author + committer both `Kris Kowal <kriskowal@kriskowal.com>` — **first ferry to use the new attribution default** (replacing the prior session's `kris@cixar.com`).
- Subject stripped of `(#74)` suffix and `endo#3241` self-reference.
- Body stripped of `endojs/endo-but-for-bots#74` references and Claude trailers.
- **boneskull's APPROVED persisted** (`reviewDecision: APPROVED` after push). The review record was anchored on `dac52928` (the user's fresh tip before this append); fast-forward did not invalidate it.
- Title and body untouched.
- Source-side cross-link on #74: [issuecomment-4494768522](https://github.com/endojs/endo-but-for-bots/pull/74#issuecomment-4494768522).

## First attempt aborted; retry succeeded

The prior dispatch at `entries/2026/05/20/050922Z-dispatch-liaison-ca9df6.md` was based on upstream tip `c7fef87b`. Between my fetch and the boatman's push attempt (~5 minutes apart), the user force-pushed `#3241` to `dac52928` (rewriting the two original commits with subject-and-body cleanup, and rebasing onto fresher master). The boatman aborted cleanly without force-pushing — exactly the right behavior — and surfaced the situation via `entries/2026/05/20/051402Z-message-boatman-877658.md`. The retry at `entries/2026/05/20/051717Z-dispatch-liaison-10e575.md` baked in the boatman's self-improvement suggestion: **refetch and ancestor-check immediately before the push** to catch concurrent force-updates locally rather than via the server's rejection. The retry passed the pre-flight check (the upstream tip was still `dac52928` at push time) and the fast-forward landed cleanly.

## Procedural lessons (for the queued gardener engagement on `skills/pr-handoff/SKILL.md`)

Three new observations to add to the brief:

1. **Pre-flight ancestor check before push**. After the commit-amend pass and immediately before `git push`, refetch the upstream branch and run `git merge-base --is-ancestor origin/<branch> HEAD`. Cheap (~1 second), gives a clean go/no-go signal, and avoids the round-trip cost of a push-and-server-rejection followed by manual diagnosis. The boatman wisdom branch can absorb this as a step in every push-bearing procedure.

2. **Attribution-default change handling**. The user changed their global git config from `kris@cixar.com` to `kriskowal@kriskowal.com` immediately before this ferry; the liaison switched the boatman's hardcoded attribution default accordingly. The skill should document that the boatman's hardcoded email is **the liaison's call per-ferry**, derivable from project conventions or a current user preference signal. Going forward the default is `kriskowal@kriskowal.com`.

3. **User-side mid-flight force-updates are real**. The maintainer (who is the same person who asked for the ferry) may concurrently push to upstream PRs during a ferry. The boatman's abort-on-rejection + ancestor-check protocol handles this gracefully. The skill should call out the pattern.

Worktree-index marked collected; dispatch root torn down.

Self-improvement: ferries on `endojs/endo` from `kmkmbp2021` may now expect to see user-side concurrent activity since the user is actively working on PR cleanup. The boatman role's no-force-without-explicit-instruction discipline is exactly what handles this; the pre-flight ancestor check is the additive improvement. Both ride into the queued gardener brief.
