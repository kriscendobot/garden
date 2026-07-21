role: conductor

# Conduct: un-draft and merge endojs/endo-but-for-bots PR #809 (persistent-stores design)

PR: https://github.com/endojs/endo-but-for-bots/pull/809
Branch `daemon-persistent-stores` -> base `llm`. This is a design-doc PR
(design(daemon): persistent @agoric/store-style stores in the pet daemon) plus
two CI-workflow touches. It is a **bot repo** — merge is authorized. NEVER touch
agoric/agoric-sdk or endojs/endo upstream.

## Why it's ready
The approving review 4749706542 by @kriskowal is an APPROVAL bundled with asks,
and every ask is resolved:
- Inline comment (keys must be encoded passable/equivalent; values free to be any
  passable codec) — already folded into the design by commit `f9ad77780`
  ("require ordered key encoding"); resolution reply posted on the thread.
- Review-body ask ("dispatch an orchestrator to supervise builders over all
  phases") — the `daemon-store-family-build` serial orchestration is recorded and
  already driving Phase 1 (child `daemon-store-phase1-mapstore`).
At claim time the PR was `mergeable_state: clean` with all five checks green
(browser-tests, build, lint, test, zizmor). Re-verify current CI before merging.

## Task
Un-draft PR #809 (it is currently a draft), confirm CI is green on the current
head, and merge it into `llm`. You own the merge method. After merge, sweep any
frozen-base branches per your role's discipline. The phased implementation is
already orchestrated (`daemon-store-family-build`); nothing else to post here.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 10
  worker_kind: cleric
  claimed_at: 2026-07-21T23:26:38Z
