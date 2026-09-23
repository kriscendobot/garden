---
ts: 2026-05-14T00:55:52Z
kind: dispatch
role: liaison
project: ocapn
to: "*"
---

# Dispatch: builder patches endojs/ocapn-test-suite to delimit messages via @endo/syrups framing

Dispatch root: `dispatches/builder--syrups-framing-ocapn-tests--20260514-005552--b04e93/`. Project worktree at `endojs/ocapn-test-suite@main` (HEAD `74db78f` — the pre-staged baseline hash).

The maintainer surfaced this engagement: an earlier instruction to fork the OCapN test suite and patch it for consistency with our `@endo/syrups` message framing got lost in the noise. Picking it up now. The deliverable is a PR on `endojs/ocapn-test-suite` (the kriscendobot-write-authorized fork; not on `ocapn/ocapn-test-suite` upstream) plus a follow-up PR on `endo-but-for-bots` that consumes the patched branch.

## Per-action authorization (forwarded)

Pre-staged in `journal/README.md` § Pre-staged authorizations (recorded 2026-05-13): kriscendobot may push branches and commits to `endojs/ocapn-test-suite`. Constraint A: baseline is `74db78f08a40efba1e2b975d809374ff0e7acf60` on `ocapn/ocapn-test-suite` (this is the fork's `main` HEAD; you start from there). Constraint B: do NOT open a PR against `ocapn/ocapn-test-suite` upstream. Work stays on `endojs/ocapn-test-suite` only.

## Context

`@endo/syrups` lives in `endojs/endo-but-for-bots@llm:packages/syrups/`. The package implements a message framing convention; the just-landed `endojs/endo#3256` ferried it upstream. The OCapN test suite emits / consumes messages with its own current framing convention. The maintainer wants the test suite's framing brought into consistency with syrups so the bot can validate that our syrups implementation handles the OCapN-protocol test vectors end-to-end.

## Task

1. **Read `@endo/syrups`**: the framing semantics, the wire layout, the README in `packages/syrups/`. You can fetch its current state from the upstream `endojs/endo@master` (now that #3256 is merged) or from `endojs/endo-but-for-bots@llm:packages/syrups/`. Either is fine.

2. **Read the current ocapn-test-suite's message delimitation**: locate where messages are emitted / consumed in tests. The test suite is small (the bot's pre-grant analysis on endo-but-for-bots#109 already mapped it). Look at any framing-shaped code.

3. **Author the patch**:
   - Modify the test suite's framing to align with syrups' message delimitation.
   - Keep the test vectors themselves unchanged (their *content* is the OCapN spec; only the *framing* changes).
   - Be conservative about the diff scope. Out-of-scope code refactors get a separate dispatch.

4. **Push to endojs/ocapn-test-suite**. Topic branch `feat/syrups-framing` (or similar). Identity kriscendobot.

5. **Open a draft PR on endojs/ocapn-test-suite** (NOT on ocapn/ocapn-test-suite upstream; the constraint forbids that). Title: conventional-commits, e.g. `feat: delimit messages with @endo/syrups framing for endo-but-for-bots integration`. Body: cites the maintainer's directive in this session, names the validation goal (endo-but-for-bots will consume the patched branch to validate @endo/syrups end-to-end), and explicitly notes "this PR stays on endojs/ocapn-test-suite; no upstream PR is planned." Per pr-creation-flow: open in **draft**.

6. **Local validation if feasible**: if the test suite has a runnable test harness, run it locally to confirm the framing change doesn't break the suite's self-consistency. The deeper end-to-end validation against @endo/syrups happens in the follow-up endo-but-for-bots dispatch.

## Out of scope

- Do NOT open a PR on `ocapn/ocapn-test-suite` upstream (constraint B).
- Do NOT touch endo-but-for-bots in this dispatch (follow-up dispatch handles consumption).
- Do NOT modify the test vectors' content. Only the framing.

## Report

PR URL on endojs/ocapn-test-suite, topic branch + head SHA, diff summary (which files changed and what shape), local-validation result (if applicable), the exact branch identifier the follow-up endo-but-for-bots builder should consume (commit SHA + branch name).
