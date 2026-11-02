---
handed-off: endopi-provider-registry-and-oauth-build-open-pr
deliverable-complete: false
---
**The code is finished and pushed, but the draft PR isn't open yet.** This host's token gets a 403 on `createPullRequest`, so I handed that step to `endopi-provider-registry-and-oauth-build-open-pr`, pinned to `endolin-garden-ece02cb4`. That job carries the full PR body. It's confirmed on the `journal2` board but not claimed yet.

**The job's premise was wrong.** It called this design the remaining M3 endopi design without a build job, but it has been built three times already (two jobs on 2026-07-10, one on 2026-10-31). Rebuilding would have duplicated work, so I checked each phase and built only the one nobody owned:

| Phase | Status |
|---|---|
| 1. Registry | Lal's agent loop already uses pi-ai's registry; the durable registry is in #1573 |
| 2. API-key providers | Available through pi-ai; brokered adapters are in #1575 |
| 3–4. Subscription OAuth | `designs/hosted-agent-broker-oauth.md` keeps subscription mode closed; the work is in #1587 and #670 |
| 5. Cross-provider handoff | **Built here** |
| 6. Image input | Already landed on `llm` |

**What changed**
- **Head and base:** `feat/lal-model-command` at `379dd71d92`, on the existing frozen base `llm-48d6f3e`.
- **`/model` command:** the host can send `/model <provider>/<model-id>` to move a running Lal worker to another model between rounds, and the conversation carries forward. Bare `/model` reports the current model. The code is in the new `packages/lal/model-switch.js`, wired into `inbox-loop.js` and `agent.js`.
- **Docs:** added a Lal README section and a changeset, and refreshed the design's status, which still cited the removed `packages/genie`.
- **Plan record:** now `In Progress`, with a note not to mint another build.

**Security rules for review**
- **Token leak avoided:** the existing key lookup falls back to `LAL_AUTH_TOKEN` for any provider, so a plain switch would have sent one vendor's key to another. The token now goes only to the provider and base URL it was configured for. Any other model needs its own credential, or the switch is refused.
- **Host only:** from any other sender, `/model` is ordinary mail for the LLM. The check compares formula identity, because `locate()` adds connection hints that a message's `from` lacks, so a plain `===` would reject the real host on a networked daemon.

**Verification**
- **Lal suite:** 206 passed, 1 skipped, including 9 new tests, one of which runs `spawnWorkerLoop` against a local fake OpenAI-compatible server.
- **Mutation checks:** five deliberate breaks each failed the expected tests.
- **Static checks:** `tsc`, eslint on the changed files and the pre-push probes pass, and `ensure-pr.sh`'s phase-evidence gate got as far as the 403 without blocking.
- **Not tested:**
  - No live vendor run: a switch between different providers was only tested with a scripted stream, and the fake-server test switches between two `ollama/` models.
  - No real daemon run: the host check was tested with real locator formats on stubbed powers.
  - No repo-wide lint: it outlasts tool limits on this host, so CI will be the first full lint.

**Follow-ups**
- **Plan record:** set `pr:` once the PR number exists; otherwise it won't flip to Complete automatically.
- **Maintainer decision:** Fae and Jaine still use `createProvider` and have no `/model`, so someone needs to decide whether to retire `packages/lal/providers/`. The refreshed design lists this as an open question.
- **Existing bug, not fixed:** Lal's self-mail check compares `from` to `locate('@self')` with `===`. On a networked daemon that could make a worker treat its own messages as new mail and start LLM rounds.

Self-improvement: added this repeat-build case to the duplicate-build memory.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endopi-provider-registry-and-oauth-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (4422386 cached reads)
- Output: 52596 tokens
- Cost: $3.4019652000000002
- Wall-clock: 2926s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
