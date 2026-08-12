---
gate: orchestrated
orchestrated_by: dependabot-auto-merge-rollout
priority: normal
role: builder
posted_by: liaison
posted_at: 2026-08-12T05:14:12Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# builder: dependabot MERGE-NOW auto-conducts — retire the maintainer-approval gate for dependabotany

Maintainer directive (kriskowal, liaison session 2026-08-12), verbatim:

> I would like to adjust our stance on dependabotany. If a dependabot PR achieves
> a MERGE NOW verdict, I would like to automatically merge the proposed change to
> the llm branch. Manual review will not economically increase our confidence but
> will uneconomically expose us to risk.

Encode that. Work directly on `main2` of the garden's own repo (no PR workflow for
ourselves, CLAUDE.md § Conventions).

## The change

Today a botanist MERGE-NOW on a bot-owned repo conducts through
`scripts/jobs/gardening/ci-wait-merge.sh`, which calls
`scripts/jobs/handlers/pr-maintainer-approval-gh.sh` and refuses to merge without a
current APPROVED review from a journal maintainer on the exact head. That gate is
what has left SEVEN terminal MERGE-NOW rows sitting open on
`endojs/endo-but-for-bots` (#867, #868, #912, #913, #914, #915, #916 — journal
entry `2026/08/11/162510Z-message-gardener-98b82c.md`; each re-verified green and
each "approval gate fails closed"). The directive says that wait is a net risk,
not a net safety: an open Dependabot PR suppresses the proposal of a NEWER bump for
the same dependency, which is exactly the bump that usually clears the residual
advisories (botanist anti-pattern, "Do not leave a dependabot PR open without a
terminal verdict").

Remove the approval requirement for this ONE case, deterministically, in code.

## Constraints — the bypass must be narrow and must live in plain shell, not prose

1. **Scope it by author, not by caller trust alone.** The bypass applies only when
   the PR's author is the dependabot login (`$GARDEN_DEPENDABOT_LOGIN` /
   `dependabot[bot]`), read live from `gh pr view --json author`. FAIL CLOSED: an
   unreadable author is not a dependabot PR and keeps the gate.
2. **Scope it to bot-owned repos.** The autonomous-disposition authority is already
   scoped to repos where the bot holds merge authority; the bypass inherits that
   scope and must not widen it. Do not let it reach an upstream the bot does not own.
3. **Require an explicit opt-in from the caller** (a flag on `ci-wait-merge.sh`, or
   an equivalently explicit signal) so an ordinary conductor merge of a
   human-authored PR cannot pick this path up by accident. Decide the exact spelling
   yourself; keep it legible in the exit-code/behaviour contract in the file header.
4. **`CHANGES_REQUESTED` STILL BLOCKS ABSOLUTELY.** The maintainer keeps a veto: a
   requested-changes review on a dependabot PR must continue to stall the merge
   (that guard predates the approval gate and exists for a different reason —
   kriscendobot/minion.town#7). Do not fold the two guards together.
5. **Every other leg of the conductor spine stays**: CI terminal-green, the
   unfreeze-to-live base rewrite (so the merge lands on live `llm`, never a frozen
   snapshot), the shared-stack refusal, the stacked-PR branch-retention guard, and
   the post-merge state verification.
6. **The botanist's own gate is untouched and is now the whole of the confidence.**
   MERGE-NOW still requires all of: CI green, the maturity floor satisfied (7 days
   past the freshest version moved anywhere in the lockfile) or a real CVE closed,
   the source read clean, and the full transitive set benign. Say this plainly where
   you document the change: what was removed is a human signature, not a check, and
   the diligence that was actually carrying the confidence is unchanged.

## Documentation that must move with the code

- `roles/botanist/AGENT.md` § Autonomous disposition — the MERGE-NOW bullet
  ("reusing the conductor's standing merge discipline and its maintainer-approval
  gate") and the opening paragraph ("This is not an approval bypass: … requires a
  current maintainer approval") are now wrong. Rewrite them to state the new stance
  and its rationale in the maintainer's terms. Keep the REJECT and EMBARGO
  dispositions exactly as they are.
- The § Anti-patterns bullet about "#269's MERGE-NOW blocked at the approval gate is
  the cheapest moment to catch this" — its lesson (a verdict is a position, not a
  commitment; supersede it in writing when a later check overturns it) SURVIVES and
  gets MORE important now that nothing external pauses the merge. Rewrite the bullet
  so the lesson stands without leaning on a gate that no longer fires; the
  base-ref census must happen BEFORE conducting, not after.
- `scripts/jobs/dependabot-watcher.sh` `write_full_body()` tells every
  auto-posted botanist job "EXECUTE the disposition through the conductor
  deterministic spine (maintainer-approval gate intact)". Update that sentence.
- `roles/conductor/AGENT.md` and anywhere else asserting the gate is universal —
  grep for it and make the claim accurate (the conductor's own gate for
  human-authored PRs is UNCHANGED).
- Write `designs/dependabot-auto-merge.md`: the directive, the risk argument in both
  directions (what an open dependabot PR costs vs. what an unreviewed auto-merge
  risks), the exact scope of the bypass, and what deliberately did NOT change
  (CHANGES_REQUESTED veto, the botanist criteria gate, non-owned upstreams, and any
  human-authored PR). Link it from `roles/botanist/AGENT.md`.

## Definition of done

- The bypass implemented, with its conditions enforced in shell and failing closed.
- A local exercise of the new path proving it (a) merges nothing when the author is
  not dependabot, (b) still refuses on CHANGES_REQUESTED, (c) takes the merge path
  with no approval present on a dependabot PR. Do not merge a live PR from this
  job — the sweep job that follows does that.
- Docs above updated; `designs/dependabot-auto-merge.md` written.
- Pushed to `main2`. Report the commit(s) and name explicitly which guards remain.
