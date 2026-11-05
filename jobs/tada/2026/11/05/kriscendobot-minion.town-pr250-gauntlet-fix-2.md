I applied the panel-2 fixes to kriscendobot/minion.town#250 and pushed them. CI is green (3/3 checks passed, `ci-wait-merge` rc 0).

**Fix commit:** `2b86e725` on `design/api-key-agent-directory-authorization` (advanced from `01825bba` with `safe-push-pr-head.sh`). It touches only `designs/api-key-agent-directory-authorization.md`. This round had no pre-pass block, so the input was the latest "Must-fix before merge" review (5780149290). I made the doc changes below:

- **skeptic:** The Verification section no longer claims the boundary is covered. It now says the current tests run against `FakeAgents` and only show that the HTTP layer derives the owner key from the signed-in identity. Decision claims 4 and 5 are now marked as resting on the factory's design, not on a test. The doc now requires a test against the real factory covering:
  - two owners who cannot list, read or change each other's agents, with a foreign id answered the same way as an unknown one;
  - agent guests that cannot reach the factory or any `OwnerAgents` directory.
- **decomplector:** Authentication and ownership checks are now described as admission checks that happen before execution. The agent guest and the inference broker each report how their own execution ended. The factory turns those results into operation status and decides commit or discard and retry.
- **ergonomist and novice (rubric):** The transport section now links the garden's `api-transport-rubric` skill at a pinned commit (`d3604334`). It also briefly states rows 1, 4, 5, 6 and 7 and the "CapTP inside" default.
- **novice (deputy):** A new section, "Why a per-agent facet behind the route is not attenuation", defines "deputy". It walks one real request (`/account/providers/agents/:agentId/wake`) through the handler and contrasts it with a client that holds a capability for one agent.
- **copyeditor:**
  - "broad across" is now "spans".
  - The long compromise sentence is split.
  - "owner chrome" is defined on first use, replacing "same-origin chrome".
  - The "call returns and exercises" phrasing is rewritten.
  - The verification sentence now reads "an `agent-not-found` response", without the repeated "verifies".
- **pedant:** The baseline link to the provider design now points to endojs/endo-but-for-bots at the pinned commit `069b429c…`.

**PR body:** For the pruner findings, I removed the "What to attend to" checklist and the "Verification" paragraph with its inline test count. The `garden-job` marker is still in place.

**Follow-up:** The doc now calls for the real-factory integration test, but it has not been written or posted as a job. It would target `agent-factory.js` in endojs/endo-but-for-bots.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr250-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1143763 cached reads)
- Output: 7605 tokens
- Cost: $0.9358446
- Wall-clock: 550s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
