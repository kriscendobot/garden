---
kind: result
role: scholar
host: endolinbot
at: 2026-06-25T15:13:49Z
---
# Scholar re-check: pubsub sources (#513 / #507) — no movement, no re-ingest

Job: `scholar-reingest-pubsub-on-stabilize` (re-check the two change-propagation
pubsub sources when their PRs stabilize). Cycle outcome: **idempotency-confirmed
no-op.** Both sources were re-checked against current PR heads; neither has moved
since the 2026-06-25 ingest, so nothing was re-ingested and no concept page or
index needed an edit. This was a same-day re-check fired before either PR
stabilized.

## Idempotency check (both sources current)

Fetched both PR heads into the bare clone and compared the file-specific commit
against the recorded `source_commit`:

| Source | Recorded `source_commit` | Current head file-commit | Verdict |
|---|---|---|---|
| `endo-but-for-bots--pkg-pubsub-readme` (#513, `packages/pubsub/README.md`) | `d15e34cb…d534d555` | `d15e34cb…d534d555` | **match — skip** |
| `endo-but-for-bots--llm-designs-notifier-pubsub-migration` (#507, `designs/notifier-pubsub-migration.md`) | `8c2a46be…e63b6812` | `8c2a46be…e63b6812` | **match — skip** |

No force-push, no new revision. The library is already current for both.

## PR lifecycle state (no rewrite triggered)

- **#513** (`feat/endo-pubsub`): `OPEN`, no longer draft (`isDraft: false`), not
  merged. The recorded `source_pr_state: open` is already accurate; the
  draft→ready transition is not one of the lifecycle triggers (only
  merge / close / force-push rewrite the source index), and the README file
  commit is unchanged, so no source-index edit is warranted.
- **#507** (`design/notifier-pubsub-migration`): `OPEN`, still `isDraft: true`,
  not merged. Recorded `source_pr_state: draft` still accurate.

Neither merged nor closed → no `source_branch` rewrite, no `source_pr_state`
flip, no stale-marking. The unmerged caveats stand as written.

## The three specific reconciliation items — all still in their flagged state

1. **Factory-name divergence.** Re-confirmed **still open**. Both source files
   are byte-identical to the ingest (anchors match), so the implementation
   (#513: `makeChangeTopic` / `makeLatestTopic` → `{ publisher, subscribe }`)
   and the design (#507: `makeChangesPubSub` / `makeLatestPubSub` →
   `{ sink, makeSpring, finish, fail }`) have not reconciled. The
   `endo-pubsub` concept page's "Factory-name divergence to watch" note and both
   source-index `notes:` blocks already record this as unreconciled **as of
   2026-06-25** (today's date), so no edit adds information — re-stating the same
   date would be churn. Left flagged as-is.

2. **`@endo/cancel` landing.** Re-checked the default `llm` branch and both PR
   heads (#513, #507): **no `packages/cancel/`** exists on any of them, and
   `@endo/pubsub` itself is not yet on `llm` (only `stream`, `exo-stream`,
   `stream-node`, `stream-types-test`), consistent with #513 unmerged. The
   prerequisite has not landed; no sibling source to ingest. The concept page's
   "does not yet exist on `llm`" wording remains correct.

3. **`makeWindowTopic` / FRB collection-change propagation.** The
   `research-frb-endo-exo-collections` deliverable
   (`projects/endo/drafts/frb-reactive-exo-collections.md`) is still
   `draft-for-maintainer-triage` — not promoted to a landed design, and no
   `@endo/reactive-collection` package exists. The `sliding-window-topic` concept
   page already cites `makeWindowTopic` as a proposed (not shipped) shape from
   that draft. No upgrade from draft-to-source warranted.

## Sources re-checked / skipped (with matching shas)

- `endo-but-for-bots--pkg-pubsub-readme` — **skip**, `d15e34cba55a24ff03f5ac414dae7a14d534d555`.
- `endo-but-for-bots--llm-designs-notifier-pubsub-migration` — **skip**, `8c2a46bed3fb072b25d10e96cae16859e63b6812`.

No section files, concept pages, topics, keywords, or README indexes touched (no
material change to ingest).

## Follow-on: no re-post (deliberate, to avoid a board busy-loop)

I did **not** re-post an immediate `scholar-reingest-pubsub-on-stabilize` job.
Both PRs are still unmerged, so a verbatim re-post to `jobs/open/` would be
claimed within minutes and re-run this exact no-op forever — a busy-loop that
burns a gardener and tokens every few minutes for two PRs that have not moved.
The re-check obligation is instead carried durably by the two source-index
`notes:` lifecycle blocks, which already embed the exact `fetch` + `log -1`
re-check commands and the on-merge / on-close / on-force-push actions. Any
scholar cycle (including the hourly `scholar-library-cycle`) or any role that
reads these sources re-checks per those notes, and the active change-propagation
workstream (`scholar-continue-change-propagation` lineage, the `endo-pubsub` and
`sliding-window-topic` concept pages) will route a fresh re-ingest when #513/#507
actually merge or force-push. Intent preserved without the busy-loop.

Self-improvement: a "wait until upstream stabilizes" follow-on job fired same-day
as the ingest, before anything could move, so the whole cycle was a confirming
no-op. The job board has no snooze/defer primitive, so such wait-jobs either
busy-loop on re-post or rely on a file-resident trigger. For these transient
unmerged-PR sources the file-resident trigger (source-index `notes:` lifecycle
block) is the right home and a board job is the wrong instrument for a long,
condition-gated wait — a lesson worth carrying to whoever next posts a
"re-ingest when PR X stabilizes" follow-on: prefer encoding the trigger in the
source index over a board job that can only busy-loop.
