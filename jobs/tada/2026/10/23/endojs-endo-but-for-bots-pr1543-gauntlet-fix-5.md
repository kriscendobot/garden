## Gauntlet FIX round 5: endojs/endo-but-for-bots PR #1543

I applied every finding from the latest panel verdict, pushed one follow-up commit to the PR head, and CI came back green: all 30 checks finished with 0 failures.

**Source:** The job carried no deterministic pre-pass block, so I worked from review 5627704208 ("Must-fix before merge", 2026-10-23T11:39Z).

**Pushed:** Commit `81e5e47ae` moved `design/claude-api-key-agents` forward from `07904eb4d` using `safe-push-pr-head.sh` in advance mode, so no history was rewritten.

### `designs/api-key-inference-providers-and-pinned-agents.md`
- **critic (must-fix):** Added an **Admission refusal** section under Confinement and wake-on-message. When the broker refuses to admit a message's turn, the message now gets a durable disposition:
  - **Deferred** for temporary limits. Rate and concurrency refusals retry with backoff from 1 minute up to 1 hour. Budget refusals wait for the budget period to reset.
  - Retries stop after 8 attempts or 72 hours, and the message is marked `retry-exhausted`.
  - **Refused** for permanent causes.
  - The owner sees each message's status and can choose **Retry now** or **Dismiss**. Phase 5 has matching tests.
- **critic (should-fix):** Split acceptance into two gates:
  - **Launch acceptance:** phases 1–6, with the legacy path still available.
  - **Legacy-retirement completion:** phase 7 plus the parent design's steps 6–8.
- **skeptic (must-fix):** Each agent now has an immutable `AgentRecord.ownerId` that records its owning principal. Provider checks at creation, reattachment and recovery use that field, never the separate agent guest's identity. The recovery reconciler revokes and reports any grant whose owner doesn't match. Phase 4 has tests.
- **ergonomist:** Chat's wizard picks the harness first; this dialog picks the provider first. To avoid one label with two meanings, this dialog is now a distinct operation called **New API-key agent**, and **Add agent** stays with Chat's wizard.
- **copyeditor:** Rewrote the three passages they flagged: the "how that holds" sentence, the long two-choices sentence, and "both say so".
- **orthographer:** Changed labelled→labeled, cancelling→canceling and cancelled→canceled.

### `designs/claude-bare-course-correction.md`
- **skeptic (must-fix):** The retirement is now framed as a **supportability policy**, not an observed rejection. The only test used a deliberately invalid token, so it can't show rejection. The changes:
  - New title: "Course correction: retire subscription credentials under `claude --bare`". The companion design's link to it is updated.
  - A note that treating the route as technically closed would need an authorized probe with a valid token.
  - The positive-canary reasoning is reframed as policy.
  - Step 1 now records the supportability decision and adds a probe that fails if the binary's `--bare` help text changes its credential list.
- **copyeditor:** Used their suggested wording for the "supersedes an earlier statement" sentence.
- **novice (must-fix):** Step 5 now says directly that the root principal of each delegation chain owns and attaches the replacement provider.

### `designs/README.md`
- **pedant:** The 34 Proposed / 253 records figures already added up (32+2 and 251+2). I made the arithmetic explicit and listed every other change: In Progress 83→82, Superseded 5→6, and a date-only update to the endo-claude-inference-backends row. I also removed the two em dashes from the rewritten endo-claude roadmap row and rewrapped the two prose lines over 100 columns.

The panel was not re-run, as this stage requires; the driver re-posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1543-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (3083164 cached reads)
- Output: 20479 tokens
- Cost: $1.9843967999999992
- Wall-clock: 1596s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
