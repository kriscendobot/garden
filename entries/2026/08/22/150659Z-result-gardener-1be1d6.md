---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-22T15:07:01Z
---
---
ts: 2026-08-22T00:00:00Z
kind: result
role: scribe
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

# scribe seat — code panel, endojs/endo-but-for-bots#881

Diff base `origin/build-endo-google-sheets-client`; head `d1f7b1fe54` (branch
`build-exo-google-sheets-facets`, post-weave). Verdict: **request-changes**.

## Note-this asks — closure state

dckc's four inline comments, none of which is a literal "add to CLAUDE.md" ask,
but three of which ask for a rationale to be written down:

| Ask | Closure |
| --- | --- |
| `r3667026735` "`if (readOnly)` is a smell … study disciplined-python-attenuation" | **closed** — README module/authority table + source credit (README.md:23, :101-104); design doc `setReadOnly(flag)` → `revokeWrites()` |
| `r3667066973` "mereology builder pattern `whole.part('A')`" | **closed** — design doc records `part()` and the two-axis orthogonality |
| `r3667766692` "setTimeout? so this module is expected to be unconfined?" | **closed** — README states the no-global claim (README.md:31-35) |
| `r3667771718` "why the separate powers layer?" | **closed** — README carries the rationale and the pola-io cost/benefit (README.md:40-66) |

Knowledge capture is unusually strong on this PR; every "why" was answered in a
durable doc, not only in a thread reply.

## Communication closure — the gap

Round 1 (dckc 15:43/15:48) drew two top-level summaries (`#issuecomment-5106507616`,
`#issuecomment-5106587591`). Round 2 (dckc 17:23, both comments) drew three
responding commits and **inline replies only** — no top-level summary. Last
top-level comment is 16:02, ~5h before the round-2 pushes. This is the PR #474 gap.

Two maintainer-facing questions are buried in those inline replies and were never
surfaced: whether `follow()` should ship as a local-only affordance, and whether
the powers layer should collapse.

## Records

No `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--881.md`
(69 sibling ledgers exist), despite two public deferrals of the `setReadOnly`
shape in `@endo/exo-playwright` and the `endoclaw-*` designs.

All six SHAs cited in the posted summaries and inline replies (`a690aca1a3`,
`c2ba34f3ae`, `2f496e52d6`, `58705a1`, `0980d9f`, `789fbe386a`) were rebased
away and are no longer ancestors of the PR head.

Self-improvement: the scribe brief covers the *absence* of a summary but not a
summary whose SHA map is invalidated by a later weave; proposed as a rule to the
gardener in the block.
