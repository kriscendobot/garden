Both asks are satisfied. No garden-library commit was needed (the brief strengthening already landed in `c7aa363e09` under the prior job). Nothing to push to `main2`.

## Completion report

**Directive** (kriskowal, PR #1125 review thread [r4040732326](https://github.com/endojs/endo-but-for-bots/pull/1125#discussion_r4040732326)): "let's verify that a re-run would flag it, then pass to a fixer" — re the bare `Far('ReadableNameHub', …)` at `packages/daemon/src/directory.js:41`.

**Preflight:** exit 2 (HINT). The correlated post-feedback reply it detected was this job's own auto-ack (4040803129), not a peer resolution. Corroborated: no peer had done the work, so I proceeded.

**Ask 1 — verify a re-run would flag it: PASS (2/2).** Re-ran the two strengthened seats (`locksmith`, `warden`) **blind** over the PR diff, same posture as the first gauntlet:
- **locksmith → must-fix:** flags directory.js:41 as an unguarded guest-facing attenuation, recommends `makeExo('ReadableNameHub', ReadableNameHubInterface, …)`, and found the guard record already exists unused at `interfaces.js:89`.
- **warden → request-changes:** now *refuses* to endorse the bare `Far` as "properly hardened" — the exact prior failure inverted.

Versus 0/4 before the brief strengthening (`c7aa363e09`). The strengthened briefs work.

**Ask 2 — pass to a fixer: DONE.** Posted fixer job `endojs-endo-but-for-bots-pr1125-fix-readonly-hub-makeexo-guard` (identity `endojs/endo-but-for-bots#1125:fix:readonly-hub-makeexo-guard`), confirmed live on the board via idempotent re-post. The body scopes the required change (bare `Far` → guarded `makeExo` using the existing `ReadableNameHubInterface`), names the real implementation wrinkle (the `Far` is inside the `readOnlyDirectorySource` eval string, whose worker compartment lacks `makeExo`/`M`/the guard record — endow-into-eval vs. incarnate daemon-side like the sibling hubs), and preserves the `isReadOnlyDirectoryFormula` durable-identity recognizer. Two comment-only secondary findings (shallow read-only attenuation; guest-driven root `addPeerInfo`) are included as maintainer-facing notes, explicitly out of the fixer's required scope.

**Follow-up posted:** threaded reply [r4040878878](https://github.com/endojs/endo-but-for-bots/pull/1125#discussion_r4040878878) reporting the verification outcome and the fixer dispatch (guarded by marker `garden-verify-fixer-dispatch:4040732326`).

**Follow-ups:** the fixer job now owns the code change; the two secondary notes await the maintainer's call.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1125-bc369e99.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2042032 cached reads)
- Output: 22834 tokens
- Cost: $4.69452625
- Wall-clock: 536s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
