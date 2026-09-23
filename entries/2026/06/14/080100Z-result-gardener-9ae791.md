---
ts: 2026-06-14T08:01:00Z
kind: result
role: gardener
host: endolinbot
to: liaison
short_id: 9ae791
project: garden
refs:
  - entries/2026/06/14/075600Z-dispatch-gardener-9ae791.md
  - entries/2026/06/14/075929Z-result-gardener-dc441f.md
  - https://github.com/endojs/endo-but-for-bots/pull/440
---

# Result: dispatch 9ae791 superseded by concurrent gardener landing

## Routing

This is the second result entry against dispatch `9ae791` (the base-branch inference convention per kriskowal's directive on `endojs/endo-but-for-bots#440`). The dispatch fired into two concurrent gardener instances; the peer landed first.

## What I found on convergence

I drafted parallel edits to the same two files (`roles/builder/AGENT.md` § Operating norms, `journal/projects/endo-but-for-bots/README.md` § Rules of engagement) and committed locally. On `git push origin HEAD:main` the push was rejected as non-fast-forward; `git fetch` revealed:

- `origin/main` already carried `bf57d99b roles(builder): infer PR base from package availability (kriskowal #440)`, authored by `endolinbot` 69 seconds before my push attempt.
- `origin/journal` already carried `103496d6 projects(endo-but-for-bots): infer PR base from package availability (per #440)` and `46717f29 result(gardener) [redo]: 9ae791 base-branch inference body` from the same peer.

I compared my draft against the landed version. The peer's version is **strictly more complete**:

- Includes the **mixed-touch impasse case** (`llm`-only + `master`-only in the same touch set) with two resolution paths.
- Includes the **inspection procedure** (`git ls-tree origin/<branch> -- packages/<name>` against both branches, performed before opening the PR).
- The builder role-file bullet cites the per-project README for the full rule rather than restating it.

My version had neither the impasse case nor the procedural probe. The peer's authoring is the better deliverable; I discarded my work without pushing (`git rebase --abort` on the conflict, then `git reset --hard origin/main` on garden and `git reset --hard origin/journal` on journal). No commits authored under my short-id landed.

## Files left as-is

- `roles/builder/AGENT.md` (already updated per `bf57d99b`).
- `journal/projects/endo-but-for-bots/README.md` (already updated per `103496d6`).

## Cross-references

The peer's result (`075929Z-result-gardener-dc441f.md`) is the canonical deliverable for dispatch `9ae791`; this entry is the convergence note from the second instance.

Self-improvement: when two gardener dispatches race against the same liaison directive, the second-to-push must `git pull --rebase` early, compare the landed version against its own draft, and discard if the peer's work subsumes its own. Concurrent dispatch on a single directive is a known cost of the parallel gardener pool; the lesson here is the **discard-cleanly-on-convergence** discipline rather than a new rule for the corpus. Note one already encoded across the gardener pool: when both peers produce, the larger artifact wins by default unless something is missing.
