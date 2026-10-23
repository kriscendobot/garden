Fix round 2 for endojs/endo-but-for-bots PR #1543 is done: the panel-2 must-fix items are applied and pushed, and CI is green on the new head.

The job had no pre-pass block, so I worked from the latest panel verdict (review 5624110374, "Must-fix before merge"). I pushed one follow-up commit, `52d4f03a1`, to `design/claude-api-key-agents` with `safe-push-pr-head.sh`; the head moved forward from `42ed60c66`. The PR changes only design documents, and the commit edits two of them.

**`designs/api-key-inference-providers-and-pinned-agents.md`**
- **critic (harness bridge):** New § Harness adapter boundary. `AgentInference` is now defined as the issuer's `InferenceEndpoint` grant (`request` / `requestByteStream`). The section specifies a `brokered-messages` provider adapter, modelled on the existing `makeSubscriptionResponsesProvider`. Fae accepts it as a new provider kind and so never reads the stored secret. Lal gets a broker-backed `streamFn` for `makePiAgent` and no `getApiKey`. The section also covers revocation, accounting, cancellation, and the agent factory refusing any configuration that carries a key. I added matching phase 1 and phase 2 tests to the build plan.
- **decomplector and novice (agent creation):** New § Agent creation, wake, and dismissal operations. The agent factory now owns an agent registry with an `AgentOperation` record. Creation steps through guest, inference grant, responder, name, then commit. Each step reuses a name chosen up front, so a retry finds the earlier effect instead of making a second one. Recovery always rolls forward, and permanent failures are undone in reverse order. Wake changes and dismissal are covered too, along with an ownership-map row and crash-injection tests in phase 4.
- **decomplector (usage ownership):** The usage ledger is now the single source of truth for usage, and no other store keeps a copy.
- **ergonomist:** New § Agent management. Wake can be turned on or off later; while it is off, mail stays unread in the guest's inbox and is processed oldest first once it is back on. New § Keyboard and assistive technology covers semantic controls, focus movement and return, and announced errors and progress, matching the Chat wizard. Phase 3 now includes keyboard-only and screen-reader tests.
- **skeptic (secret-retention check):** The zero-copy requirement now covers only storage the application controls. Browser-managed state (autofill, password managers, session restore) is handled by mitigations plus per-browser profile-search evidence, which is recorded but does not certify anything.
- **copyeditor:** Fixed the subject-verb disagreement in the cross-reference.

**`designs/claude-bare-course-correction.md`**
- **skeptic should-fix:** The invalid-token probe is now described as negative evidence only. Retirement rests on the help text, the upstream report and the README note.
- **copyeditor:** The entitlement and positive-canary gates are now explained, with a link to `endo-claude.md`.
- **decomplector:** The ownership prose now matches the companion document (the ledger owns usage; the factory owns agent operations).

**CI:** My first wait timed out locally after about 9 minutes with only `lint` still pending. I re-ran `ci-wait-merge.sh`, which returned rc 0: 30 checks, 0 failed.

Nothing else is needed from this stage; the driver posts panel round 3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1543-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2337926 cached reads)
- Output: 22380 tokens
- Cost: $1.7004571999999996
- Wall-clock: 1236s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
