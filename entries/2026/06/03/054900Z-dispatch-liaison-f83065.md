---
ts: 2026-06-03T05:49:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--f83065
prs:
  - repo: endojs/endo-but-for-bots
    pr: 379
    role: target
refs:
  - https://github.com/endojs/endo/pull/3276
  - https://github.com/endojs/endo-but-for-bots/pull/379
---

# dispatch: fixer — #379 audit naugtur+kriskowal feedback completeness; fill any gaps; document parity-test concept

User explicit ask:

> Please dispatch a fixer to review naugtur's feedback on
> https://github.com/endojs/endo/pull/3276 again and ensure
> that we have addressed all of it on our mirror. I am not
> seeing CommonJS parity or disparity validation tests.

## Liaison's pre-dispatch sweep findings

### naugtur's 3 inline asks on endo#3276 (review 4388440170 + 4388454369 + 4388479313)

1. **`packages/ses/src/module-instance.js:379`** (comment
   `3323491701`): "Is a situation possible where all calls to
   the deferring notify happen before `upstreamNotify` can be
   obtained? ... unused live bindings."
   → APPEARS ADDRESSED via commit `96ea2c59c test(ses):
   unused-live-binding parity for #59 cyclic star-export`.
   Verify the test actually exercises the unused-live-binding
   path.

2. **Fixture for longer-cycle CJS** (comment `3323503838`):
   "Would it still work if the cycle was longer and a cjs
   module was involved in it? Would you be so kind to ask a
   clanker for a fixture for that?"
   → APPEARS ADDRESSED via:
   - `f89afdb78 test(compartment-mapper): cyclic CommonJS
     reexporter parity fixture + tests (#59 follow-up)` (3-
     module CJS reexporter cycle).
   - `340479b2e test(compartment-mapper): ESM-in-CJS-cycle
     divergence parity test (#59 follow-up)` (ESM-in-CJS
     cycle).
   Verify both shapes are present AND exercise longer cycles
   (specifically 3+ modules with at least one CJS link in the
   chain).

3. **Notifier refactor for parity** (comment `3323524839`):
   shared notifier primitive between `makeModuleInstance` and
   `makeVirtualModuleInstance` to reduce interop failure risk.
   → PARTIALLY ADDRESSED via `6b80ac3ee refactor(ses):
   extract makeNotifierWithResolver helper (issue #59)`. The
   bot applied to `makeModuleInstance` but NOT to
   `makeVirtualModuleInstance` (judgment call: different
   semantics — one-shot redirect vs live-cell fan-out; bot's
   reply at comment `3338583474` explains).
   No further action needed unless re-reading the bot's reply
   surfaces a contradiction with naugtur's intent. The
   judgment call is reasonable; leave as-is unless audit
   reveals otherwise.

### kriskowal's 5 mirror-side inline asks on #379

1. **`module-instance.js:389`** (`3338365530`): makeNotifierWithResolver refactor. Bot replied at `3338583474` — partially applied per above. Likely closed.

2. **(bot's own reply 3338583474)**: not actionable.

3. **`import-gauntlet.test.js`** (`3338677487`): "Please reframe as primarily an explanation of the test rather than emphasizing the procedural impetus for making the test. Also, please commit and refer to a test that substantiates the claim that the Node.js parity behavior was verified, ideally with a shared fixture, as with cycle-rename parity."
   → APPEARS ADDRESSED via commit `4d4953dcb test(ses):
   reframe cyclic CJS reexporter test prose; reference
   compartment-mapper parity` and the new
   `cycle-cjs-reexporter-node-parity.test.js` (shared-fixture
   pattern).
   Verify the prose reframe took AND the cross-reference
   points at the right file.

4. **`import-cjs.test.js`** (`3338682426`): "If I am reading
   this correctly, this is a case where SES does not have
   Node.js parity and we should state and verify this claim
   plainly and programmatically."
   → APPEARS ADDRESSED via
   `cycle-esm-in-cjs-node-parity.test.js` (spawns Node,
   asserts `ERR_REQUIRE_CYCLE_MODULE` rejection while the SES
   side accepts the same fixture; disparity verified
   programmatically).
   Verify the disparity is stated plainly in test prose AND
   verified programmatically.

5. **`import-cjs.test.js`** (`3338685696`): "Parity claims
   should be substantiated with parity tests. Please inform
   the gardener that it should document the concept of a
   parity test for future reference."
   → FIRST PART APPEARS ADDRESSED (parity tests exist).
   → SECOND PART (inform the gardener) NOT YET DONE — this is
   a garden-meta follow-up.

## Procedure

1. **Audit each of naugtur's 3 asks** against the current
   mirror state (head `4d4953dcb`). For each:
   - Read the addressing commit's diff.
   - Run the relevant tests locally (e.g., `yarn workspace
     @endo/ses test packages/ses/test/import-cjs.test.js`).
   - Confirm the ask is GENUINELY addressed, not just
     superficially marked done.
   - If a gap is found, write the minimal test/code change to
     close it.

2. **Audit each of kriskowal's 5 mirror-side asks** similarly.

3. **Add the gardener message** (kriskowal's ask 5, second
   part). This is on the GARDEN repo (`kriskowal/garden`),
   not endo-but-for-bots. The dispatch authorization extends
   only to journaling a message-entry that points the
   gardener at the parity-test concept. Do NOT modify the
   garden directly here — that's a separate gardener
   dispatch the steward queues.
   - Write a `message` journal entry under
     `journal/entries/2026/06/03/` directed to the gardener,
     describing the parity-test concept (a paired SES-side
     and Node-side test pair that share a fixture; passing
     together verifies parity by construction).

4. **Post a comprehensive top-level PR comment** on #379
   listing each of naugtur's + kriskowal's asks and the
   status of each, with commit SHAs for the addressing work.
   This is the audit report the user is asking for. If you
   found and closed any gap, include the new SHA.

5. **CI**: confirm only test-xs is still failing
   post-rebase (which is a known/cleared flake category per
   the recent llm sync). Don't re-enqueue.

## Per-action authorizations

- Read all relevant files. Authorized.
- Run tests locally. Authorized.
- Add new test code OR test prose changes to close any
  genuinely missing gap. Authorized.
- One regular-append commit + push (only if a gap was
  closed). Authorized.
- Top-level PR comment on #379. Authorized.
- Reactji acknowledgments on naugtur's and kriskowal's
  comments (optional).

## Not authorized

- Modifying any file outside `packages/ses/` or
  `packages/compartment-mapper/` (unless a clear cross-package
  fix is needed; surface as escalation if so).
- Force-pushing.
- Touching upstream endojs/endo (no bot credentials there;
  the boatman will re-ferry from kmkmbp2021).
- Un-drafting / re-drafting / merging.
- Editing the garden directly (gardener message is journaled
  only; garden edits are a separate dispatch).

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--f83065/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--f83065/garden/roles/fixer/AGENT.md`
3. Other skills referenced just-in-time.

Project worktree at `project/` on `fix/issue-59-star-export-cycle`
(head `4d4953dcb`).

## Report

A `result` journal entry. Include:

- Per-ask audit verdict (genuinely addressed / partial / gap
  closed).
- If a gap was closed: new head SHA + summary of the change.
- Top-level PR comment ID.
- Reactji actions.
- The gardener message journal entry path (for the steward to
  queue a gardener dispatch).
- Any judgment calls.
