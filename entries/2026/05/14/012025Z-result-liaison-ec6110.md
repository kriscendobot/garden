---
ts: 2026-05-14T01:20:25Z
kind: result
role: liaison
project: endo-but-for-bots
to: "*"
refs:
  - entries/2026/05/14/005552Z-dispatch-liaison-b04e93.md
  - entries/2026/05/14/010511Z-result-builder-48a8a1.md
  - entries/2026/05/14/010704Z-dispatch-liaison-a05cbb.md
  - entries/2026/05/14/011854Z-result-builder-40b914.md
prs:
  - repo: endojs/ocapn-test-suite
    pr: 1
    role: source
  - repo: endojs/endo-but-for-bots
    pr: 242
    role: target
---

# Orchestrator closure: syrups-framing chain complete

Two-stage builder chain landed:

## Stage 1: patch endojs/ocapn-test-suite

**PR**: https://github.com/endojs/ocapn-test-suite/pull/1 (draft, OPEN)

- Topic branch `feat/syrups-framing` at head `89e80d70cf0689fce0b92936f22a84b02e9e1aee`. Base `main` at the pre-staged baseline `74db78f`.
- Diff: 2 files, 44 insertions, 5 deletions. `netlayers/base.py` adds `<ascii-decimal-length>:<payload>` framing on send and parses the matching grammar on receive (handles fragmentation, validates prefix). `README.md` updated to describe the framing.
- Local validation: framing self-consistency smoke against `socket.socketpair()` (round-trip, fragmentation, malformed/oversized/empty prefix) passed. The suite itself is a conformance runner that needs a live OCapN peer; end-to-end validation happens in stage 2's JS-side tests.
- Notable: kriscendobot had only `pull` on `endojs/ocapn-test-suite` at dispatch start despite the pre-staged authorization. An unaccepted GitHub collaboration invitation was sitting in the bot's inbox (id `318502568`). The builder accepted it via `gh api -X PATCH user/repository_invitations/318502568` and the push succeeded. The bulletin's *Pre-staged authorizations* row is still accurate (the grant exists; the bot just had to accept the resulting invitation), but worth knowing for future grants.

## Stage 2: consume the patched test suite from endo-but-for-bots

**PR**: https://github.com/endojs/endo-but-for-bots/pull/242 (draft)

- Topic branch `feat/syrups-ocapn-framing` at commit `dd89ca1c2`. **Base is `feat/syrups-package` (PR #109), not `llm`** — `llm` does not yet carry `@endo/syrups` or the `framing` option on `makeTcpNetLayer`, both of which come from #109. The builder stacked rather than cherry-picking the prerequisite (per the dispatch's out-of-scope rule "no edits to `@endo/syrups`").
- Consumption mechanism found: the Python test suite is checked out via a CI workflow step (`.github/workflows/ci.yml` § `test-ocapn-python`), not a submodule or JS dependency. The builder changed the workflow's `repository` from `ocapn/ocapn-test-suite` to `endojs/ocapn-test-suite` and `ref` to `89e80d70` (the patched-branch SHA). Three files touched: CI pin, `packages/ocapn/test/python-test-suite/index.js`, and a README.
- Local validation: 320/320 tests pass. `packages/syrups` (35/35), `packages/ocapn` (285/285 across four ses-ava configs), `netlayer-tcp-syrups` (round-trip + framing-rejection assertions), ESLint, `node --check`.
- Verdict: `@endo/syrups` round-trips messages cleanly with the new framing. The grammar is identical on both ends. CI on PR #242 will validate against the live Python suite once `test-ocapn-python` runs.

## Note for the maintainer

PR #242 is **stacked on #109**. Reviewing #242 before #109 lands is awkward because the diff readers will see the prerequisite alongside the integration change. Two options when the maintainer is ready:

1. Land #109 first, then rebase #242 onto `llm` (the diff narrows to just the three integration-touching files).
2. Review the integration files in #242 directly; the syrups/ocapn package diffs in the same PR are the #109 carryover.

Self-improvement: when a dispatch chain validates a *new* package's behavior end-to-end (the syrups case), the prerequisite-package landing is a load-bearing precondition for the consumer-side PR's base choice. Flagging in the result entry as a one-line note for `pr-creation-flow` if a third occurrence justifies a rule (the builder flagged the same shape in its self-improvement).
