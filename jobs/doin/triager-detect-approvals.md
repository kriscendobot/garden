# Triager/comment-watcher: NOTICE a maintainer approval and dispatch the finalization-to-merge

Wear the **mentor** role. The comment-watcher/triager has **no APPROVED handling** — a clean
maintainer approval falls through, so an approved, mergeable PR just sits (observed on
**endo-but-for-bots #528**: APPROVED + MERGEABLE + all asks done, but left DRAFT because nothing
noticed the approval). Add this sophistication, on top of `reinforce-cw-maintainer-reviews` /
`comment-watcher-capture-full-review`. Infrastructure on `main2` (bot identity; isolated worktree
off `origin/main2`; redeploy). The maintainer's word for the finalization owner is "curator";
the garden's merge role is the **conductor** — there is a curator *juror* seat but no orchestrator
curator role. Map the finalization to the **conductor** (and note in the design whether a distinct
orchestrator "curator" role is worth defining — that is a follow-up, not this job).

## Behavior to add

When a **trusted maintainer approves** a PR — i.e. the review state is **APPROVED**, or the PR's
**reviewDecision becomes APPROVED** — the triager dispatches the **finalization-to-merge**:
- If there are **inline asks** bundled with the approval (e.g. #528's "express types in .d.ts"),
  treat those as the capture-full-review path FIRST (a fixer addresses them), then finalize.
- When the PR is **APPROVED, mergeable, checks green, and all asks addressed**: dispatch the
  **conductor** to **un-draft (if draft) and merge**. This is the curation step.
- Post a job with a deterministic basename per PR (e.g. `endojs-endo-but-for-bots-pr<N>-conduct`),
  idempotent — do NOT re-dispatch a merge for a PR already merging/merged/closed.

## Guards (critical)

- **Bot repos only** (`endojs/endo-but-for-bots` and bot forks). **Never** autonomously
  merge/finalize on `agoric-sdk` or the `endojs/endo` upstream — those are out of scope.
- **Trusted sender** only (the approval must come from a maintainer on the allowlist / org).
- Merge only when **mergeable + checks green**; if not, dispatch the shepherd/fixer instead of
  forcing. Never name the merge method (the conductor owns that).

## Tests & verification

- A trusted-maintainer APPROVED review on a mergeable bot-repo PR → exactly one conductor/finalize
  job (idempotent on re-poll). APPROVED-with-inline-asks → the asks route first, then finalize.
  APPROVED on a non-bot repo or from an untrusted sender → no merge dispatch. An already-merged PR
  → nothing. `shellcheck`/`bash -n` clean.

## Definition of done

The triager detects maintainer approvals and dispatches the conductor to finalize (un-draft +
merge) approved, mergeable, all-asks-addressed bot-repo PRs, idempotent and guarded (bot repos
only, trusted sender, green+mergeable), tests added — committed/pushed to `origin/main2`,
redeployed. Report the SHA and the dispatch behavior. Note whether a distinct orchestrator
"curator" role is worth defining as a follow-up.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 43
  claimed_at: 2026-06-25T22:02:03Z
