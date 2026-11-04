---
handed-off: build-api-key-agents-p2-provider-adapters-open-pr
deliverable-complete: false
---
**Phase 2 is not fully delivered yet.** #1575 did not cover the job's listed tests, so I built the missing ones and fixed two bugs they found. The code is pushed, but the PR isn't open because this host's PAT gets a 403 on `createPullRequest`. The relay job `build-api-key-agents-p2-provider-adapters-open-pr`, pinned to endolin, will open it.

**What #1575 already covers:** raw-request refusals, default caps and raise confirmation, reservation and settlement with fake issuers, the owner-wide concurrency refusal, and keeping key material out of the harnesses.

**Listed tests it was missing:**
- A model discovery failure, with only a well-shaped typed id accepted.
- The first successful turn marking a model `verified`. One #1575 test title claims this, but nothing asserts it.
- The owner-wide budget across two providers, and concurrent admissions across them.
- Request rate limits at each scope.
- A harness abort reaching upstream through the real path.
- Log redaction.

**Bugs the real Anthropic issuer exposed, now fixed:**
1. **Upstream refusals were masked:** a 401, 429 or 404 reached the caller as `Provider request failed`, so `model-not-available` and Lal's auth and rate-limit messages never fired on real traffic. The issuer now opts in through a new broker option, off by default. The registry reports fixed codes, and Lal maps those to its messages.
2. **Cancelled streams were undercharged:** they settled at partial usage instead of the full reservation the design requires. They now charge the larger of the two, marked `estimated`.

**What changed:**
- **Branch:** one commit, `e037713894` on `feature/api-key-provider-adapters-acceptance`. Its base is the frozen snapshot `feature/api-key-provider-adapters-0b8d24a`, stacked on #1575.
- **New tests:** `packages/lal/test/brokered-messages-broker.test.js` runs Lal through the real registry and issuer with only `fetch` faked. There are also additions to `inference-provider-registry.test.js`.
- **Changesets:** two added, one each for `hosted-agent` and `lal`.

**Checks:**
- **Tests:** the new Lal file and the Lal adapter, registry and Fae provider tests pass. The full `hosted-agent` suite passes except two `dev-image` tests, which fail because this host's `/tmp` can't execute their stand-in `docker`.
- **Regression evidence:** before the fixes, the new Lal tests failed with the errors described above.
- **Static checks:** `tsc` passes for `hosted-agent` and `lal`. ESLint reports warnings but no errors on the changed tests and registry source. The pre-push gate ran as `--probes-only` and passed, because repo-wide lint auto-fix outlasts tool limits on this host.
- **Not run:** CI, because no PR exists yet.

**Slip:** my first push went out while the spell-out-identifiers probe was failing, because the command didn't stop on it. I fixed that and force-pushed with a lease to my own new branch; the gate then passed.

**Open items:**
- **Follow-up jobs:** the relay job is in `todo` on `journal2`. `weave-api-key-p2-acceptance-after-pr1575` is parked until #1575 merges, then restacks this work onto `llm`.
- **`apiKeyGuestAgents` flag:** it doesn't exist in #1575 or this branch, though the job says everything ships behind it. It isn't a listed test and the companion design never mentions it, so I didn't add it. The p3 and p4 job bodies repeat the requirement, so one of them needs to own it, or the maintainer can confirm that leaving the code unwired is enough for now.
- **Charges on refused turns (maintainer's call):** a refused upstream turn still charges its full reservation under the design's "ends without usage" rule, so a bad key retried repeatedly can use up a daily budget. The PR body flags this.
- **No parent design questions were decided here.**

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-api-key-agents-p2-provider-adapters.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (4089777 cached reads)
- Output: 51870 tokens
- Cost: $3.2414594
- Wall-clock: 1879s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
