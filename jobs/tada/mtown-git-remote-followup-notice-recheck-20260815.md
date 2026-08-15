Verified on `origin/journal2`. The notice is re-armed and the chain remains live.

## Completion report

**Job:** Notice/sentinel recheck (N) of the D→N→F chained follow-up for the daemon commit-formula design.

**What I did — the deterministic "advanced to build?" check on D (PR #988, `endojs/endo-but-for-bots`):**
- PR state (`gh pr view 988 --json`): **OPEN, still `isDraft: true`**, `mergedAt: null`, `closedAt: null`. Design has neither merged nor been declined.
- Cross-reference timeline (`gh api repos/endojs/endo-but-for-bots/issues/988/timeline`): **no `cross-referenced`/`connected`/`referenced` events** — only `committed`/`reviewed`/`commented`. No build PR references or implements the design.
- Corroborating search (`gh search prs "commit formula"`): #988 is the sole match, still open.

**Branch taken — "not yet built" (design in active review, 4 reviews, not merged, not declined):** kept the LLM out of the gate; the decision was pure `gh` metadata.

**What changed:** Re-armed the notice as a one-time journal schedule (no garden `main2` change was needed — this is a pure board/journal operation):
- `schedules/mtown-git-remote-commit-formula-notice-20260816.md` on `origin/journal2` — `once: 2026-08-16T03:06:59Z` (~6h out), dispatched base `mtown-git-remote-followup-notice-recheck-20260816`, carrying the full recheck body (D identity, the mechanical check, the exact F body for the yes-branch, and the re-arm/decline instructions for the no-branches). Verified present on the remote.

**Follow-ups / thread state:** The chain is live, not dropped. On its next fire the recheck will either mint F (`mtown-git-remote-commit-formula-act`) once a build lands, re-arm again if still unbuilt, or end the chain with a maintainer note if #988 closes unmerged. No F posted (correct — no implementation exists yet). No maintainer message (design is not declined).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/mtown-git-remote-followup-notice-recheck-20260815.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 29 tokens (710848 cached reads)
- Output: 7495 tokens
- Cost: $0.972783
- Wall-clock: 237s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
