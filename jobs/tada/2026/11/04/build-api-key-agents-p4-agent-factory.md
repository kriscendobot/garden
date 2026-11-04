---
handed-off: build-api-key-agents-p4-agent-factory-open-pr
deliverable-complete: false
---
The phase 4 code is finished and pushed in both repos, but only the minion.town draft PR is open. The bot token gets a 403 creating PRs on endojs, so I posted a relay job, pinned to endolin, to open the Endo one. I haven't looked at CI on either side.

## PRs
- **minion.town:** draft https://github.com/kriscendobot/minion.town/pull/244, stacked on #229's frozen head (`feat/claude-api-provider-ui-637a9a0`).
- **Endo:** branch `feature/api-key-agent-factory` at `a46a836e92`, based on `feature/api-key-provider-adapters-0b8d24a` (#1575's frozen head). `build-api-key-agents-p4-agent-factory-open-pr` carries the finished PR body and also updates #244's ledger link. `ensure-pr.sh` accepted that body before GitHub refused the create.

## What changed
- **Endo (`packages/hosted-agent`):**
  - The agent factory: Lal/Fae catalog, request validation, idempotent operation records and a reconciler.
  - Exact powers profiles per harness, and a daemon caplet.
  - A subagent-creation slot that is filled only when the request names it.
  - Per-agent inference that follows reattachment, and the owner binding.
  - The registry gains `listGrants`, and `InferenceProviderUse` gains `describe`.
- **minion.town:**
  - Step 2 of the dialog and the agent detail view: wake toggle with queued-mail confirmation, limits, reattach, delete.
  - Routes under `/account/providers/agents`, off unless `API_KEY_GUEST_AGENTS` is set.
  - With the flag on, Replace key moves agents through the factory.

## Checks
| Check | Result |
|---|---|
| Endo factory tests (crash at every discovered boundary, recovered by retry and by reconciler; fake responder and spawner) | 32 pass |
| Real-daemon restart test (confinement, unread mail, rebinding, deletion) | passes |
| Existing registry tests | pass, except that the registry and module unit suites last ran before the final queue change |
| `tsc` for `hosted-agent` and minion.town | clean |
| Agent browser tests in Chromium | 8 pass |
| minion.town full suite | 1,717 pass, 1 fails: `test/git-remote/capability.test.ts` |

- **The one failure:** this diff doesn't touch that test, but I didn't confirm it also fails on the base.
- **Mutation checks:** I broke 12 behaviours on purpose. Ten were caught straight away. The other two exposed missing tests:
  - The step 2 Enter handling is now covered and I confirmed the new test catches it.
  - The abort-after-naming test is added, but I didn't re-run that mutation.

**Not run:**
- Firefox and WebKit, which couldn't launch here. I added the agent UI tests to `browser-gate.yml`, so #244's CI will be their first run.
- Repo-wide lint auto-fix: pre-push gates ran `--probes-only`, and I only ran `eslint` on the Endo files I changed.
- The full `hosted-agent` and `daemon` suites.
- Any real upstream turn.

## For the maintainer
- **Duplicate orchestrations:** `claude-api-p4-agent-factory` is still parked under `claude-api-build-20261027-resume`. If that orchestration advances, it will rebuild this work. The p3 job already raised this, and no reply has reached this job's inbox.
- **Evaluation path for Lal:** the powers facet refuses every `@` name, because `@host` on these guests is the root host. Lal's `define`/`request`/`form` therefore reach only pet names the agent holds, and phase 5 needs a route to the owner. Phase 5 may also find harnesses calling methods outside the exact profiles, such as `locate` or `lookupById`.
- **Spawner not deployed:** a request naming the subagent endowment is refused with `subagent-creation-unavailable`, and the box shows disabled and unchecked. I chose this over silently dropping the endowment.
- **Other known gaps:**
  - An owner with no guest yet gets `owner-not-provisioned`.
  - The detail view opens from the Providers page, not the shell inventory.
  - No deployment creates the factory formula yet.
  - Phase 5 must supply the real responder launcher, which the caplet requires, and should stack on this branch.

No parent-design open questions were decided. Phases 1–3 are still unmerged, so both ledgers read `orchestrated-slice`.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-api-key-agents-p4-agent-factory.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 106 tokens (11609550 cached reads)
- Output: 158729 tokens
- Cost: $8.111874
- Wall-clock: 3783s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
