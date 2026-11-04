---
handed-off: build-api-key-agents-p5-pinned-responder-open-pr
deliverable-complete: false
---
Phase 5 code is finished and pushed in both repos, but only the minion.town draft PR is open. The bot token gets a 403 creating PRs on endojs, so I posted `build-api-key-agents-p5-pinned-responder-open-pr`, pinned to endolin, to open the Endo one. `ensure-pr.sh` accepted that body before GitHub refused the create. I haven't looked at CI on either side.

## PRs
- **minion.town:** draft https://github.com/kriscendobot/minion.town/pull/245, stacked on #244's frozen head (`feat/api-key-agent-ui-e9d0a15`).
- **Endo:** branch `feature/api-key-agent-responder` at `52d32b7790`, based on `feature/api-key-agent-factory-a46a836` (the frozen head of phase 4's branch, whose own PR is also still waiting on a relay job).

## What changed
- **Endo:**
  - **Responder core (`packages/hosted-agent`):** the generalized responder, plus caplets for the responder, launcher, provisioner and a one-agent endowment facet.
  - **Harnesses:** `@endo/lal` and `@endo/fae` each gain an `agent-responder.js` entry point that runs real one-at-a-time turns through the agent's grant.
  - **Agent summaries and retry:** summaries now list deferred and refused messages, and the directory gains `retryMail`.
- **minion.town:** the detail view shows each held message's reason and next retry time, with **Retry now** and **Dismiss**. The inventory entry shows the counts, and there is a new `/mail/:number/retry` route. It stays behind `API_KEY_GUEST_AGENTS`, and `src/endo/claude` is untouched, so the legacy path remains the rollback.

## Checks
| Check | Result |
|---|---|
| Real-daemon responder tests: Lal and Fae wake, real refused admission deferring then processing, Retry now, restart with a deferred queue, retirement, Dismiss, deletion cancelling a held upstream request | 4 pass |
| Fake-clock responder tests: backoff, budget reset, eighth refusal, 72-hour limit, duplicate delivery, crash recovery | 23 pass |
| Factory, registry and issuer suites in `hosted-agent` | 93 pass, counted with the responder tests above, on a run before later lint and type edits |
| `lal` and `fae` suites | 233 and 237 pass, 1 skipped, before later lint and type edits |
| `tsc` | Clean for `hosted-agent` and minion.town, apart from existing `base64` errors in `hosted-agent`. Filtered to the new files, the two `fae` errors were fixed but not re-run; `lal` showed none |
| Agent browser tests in Chromium | Pass, including the new held-mail test |
| minion.town full suite | 1,718 pass, 1 fails: `test/git-remote/capability.test.ts`. Two `tools/claude-harness` files also fail with "No test suite found". This diff touches none of them, but I didn't confirm they fail on the base |
| Mutation checks | 5 on the responder and 1 on the endpoint, all caught. The 72-hour one is caught only because the test hangs, not by an assertion |

**Not run:**
- The full `hosted-agent` and `daemon` suites.
- Firefox and WebKit, so CI will be their first run of the new test.
- Repo-wide lint auto-fix. Pre-push gates ran `--probes-only`, and I only ran `eslint` on the Endo files I changed.
- Any real upstream turn.

## For the maintainer
These are also in the Endo PR body, because each goes beyond a literal reading of the design:
- **Workers die when a formula is collected:** the daemon terminates any worker holding a reference to a formula it collects, and that worker doesn't come back until a restart.
  - A launcher holding responders killed the worker running the factory on the first deletion. Deleting an agent that never received mail did the same through the factory's reference to its guest, which is a latent defect in the phase 4 branch.
  - I worked around this without changing the daemon: a provisioner runs inside each agent's own worker, and responders register a control object instead of being looked up.
  - A released guest is emptied and its formula kept until the next daemon start.
  - **Your call:** you may prefer to narrow the daemon rule instead.
- **Admission refusals change code:** they now carry the specific reason, such as `agent-rate-limited`, instead of `inference-request-refused`, which the design treats as terminal.
- **Root pin added:** the daemon revives only the root's `@pins` at startup, so the responder is pinned there as well as in the guest's `@pins`.
- **Failures with no fixed code:** a failure with no fixed code counts as transient (`turn-failed`), so it is bounded and visible rather than silently stuck. This goes beyond the design, which covers only admission refusals.

**Known gaps:**
- The harness transcript doesn't survive a restart, or a reattachment that changes the model, though the design says it should.
- The real-daemon turns are text-only, so no harness tool ran against the powers profiles. Lal's `define`, `request` and `form` still have no route to the owner, as phase 4 reported.
- No deployment creates the factory or launcher formulas yet, so no browser has seen the view and a live responder together.

**Duplicate orchestration:** `claude-api-p5-responder` is still parked under `claude-api-build-20261027-resume`, and if that orchestration advances it would rebuild this work. p3 and p4 already raised the same risk.

No parent-design open questions were decided. Phases 1–4 are unmerged, so both ledgers read `orchestrated-slice`.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-api-key-agents-p5-pinned-responder.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 166 tokens (19966682 cached reads)
- Output: 163424 tokens
- Cost: $10.023896400000003
- Wall-clock: 5820s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
