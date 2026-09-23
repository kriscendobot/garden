---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-29T16:25:42Z
---
---
project: endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/867
seat: scribe
dispatch: fix-botanist-scripts-enabled-install-gap-gauntlet
verdict: request-changes
---

# Scribe seat, panel on PR 867 (@noble/curves 1.9.0 → 2.2.0)

Originating dispatch: `jobs/doin/fix-botanist-scripts-enabled-install-gap-gauntlet.md`
(auto-gauntlet handoff, `build_job: fix-botanist-scripts-enabled-install-gap`).

## Knowledge-capture closure — CLEAN, both asks closed

PR 867 carries **no inline review comments** and **one bodiless APPROVE**
(`rev4803540376`, kriskowal, 2026-07-29T02:46:21Z), so it contains no direct
"note this" ask. The note-this traffic ran the other direction: the gardener
working this PR reported two botany lessons, and the liaison verified and
boarded both (`msgs/role/liaison/20260729T014106Z-f1ac28.md`).

| Ask | Closure | State |
| --- | --- | --- |
| Botanist role mandates a scripts-disabled install 4× while the spine ran a plain scripts-enabled `yarn install` | `71ff9cb89b` (`roles/botanist/AGENT.md`, `roles/gardener/AGENT.md`, `ensure-project-worktree.sh`, both handlers) + `e30fa588f2` (real-npm sentinel regression) | **CLOSED** — standing-orders edit |
| Step 6 conflates shepherd-scope repair with fixer escalation | `4f7525c214` (`roles/botanist/AGENT.md`) | **CLOSED** — standing-orders edit |

Both jobs sit in `jobs/tada/`. This is the closure shape the seat exists to
check, achieved without a scribe finding — worth recording as the positive case.

## PR-communication closure — one open finding

The completion summary for the migration push is exemplary
(`#issuecomment-5111717289`, 2026-07-29T01:33:43Z): head SHA, per-file change,
declined alternatives, verification status.

What is open is the **state reversal after the approval**. Timeline:

- 02:46:21Z — kriskowal APPROVES.
- 16:04:59Z — the gauntlet job is claimed.
- 16:06:03Z — `convert_to_draft` by kriscendobot.
- Comments posted after 02:46:21Z: **none**.

`reviewDecision` now reads `""` — re-drafting cleared the approval the botanist
had explicitly named as the sole remaining gate ("Once approved, the conductor
spine merges it with no further botany"). The maintainer answered that gate and
the bot silently voided the answer.

The re-draft also rests on a false premise the record never corrects: the job
body asserts "The build opened ... pull/867", but `fix-botanist-scripts-enabled-install-gap`
was a garden-repo change landed on `main2` and opened no PR. 867 is Dependabot's
PR that merely *surfaced* the lesson.

Self-improvement: the seat's completion-summary rule is written against pushes,
and I nearly filed a clean sheet because no push followed the approval. The
maintainer-visible harm here came from a *state change* — a draft toggle that
cleared a review decision — which the rule's wording does not reach. I have
proposed the extension in the block rather than stretching the existing citation
to cover it.
