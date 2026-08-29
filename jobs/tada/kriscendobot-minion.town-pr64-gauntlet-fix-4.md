CI is green (rc 0). The fix is pushed and CI passed.

## Completion report

**Job:** kriscendobot/minion.town PR #64 gauntlet — FIX round 4 (`designs/claude-agents-capability.md`).

**What I did:** Read the round-4 panel verdict (5 request-changes: critic, skeptic, decomplector, ergonomist, novice; 1 comment-only: copyeditor; 1 approve: pedant) and applied every must-fix / should-fix item in one follow-up commit (`c2d15ad`) to the PR head `design/claude-agents-capability`.

**Changes applied:**
- **critic** — added `{ type: "unavailable" }` to both `ClaudeAgents.create` and `ClaudeAgent.infer` return unions so their types carry the never-reject contract the `ClaudeAccount` comment claims; gave the per-subscription inference slot a full atomicity + reconciliation story matching the retained-child counter.
- **decomplector** — renamed the busy sentinel `inference-busy` → `subscription-busy` and documented that it reflects tree-global (per-subscription) contention, not the `ClaudeAgent`'s own state; sharpened the concurrent-inference acceptance bullet to specify unrelated descendants of the same subscription.
- **skeptic** — named the load-bearing ToS/entitlement premise as an explicit stop gate in production step 1; added sibling-guest confinement to the canary (step 4) and acceptance evidence; named the divergence-detection mechanism (periodic reconciliation sweep) and added acceptance evidence for the non-restart no-strand path.
- **ergonomist** — added `dismiss` and `models` methods to the factory surface; moved the `create` idempotency note onto the interface doc-comment.
- **novice** — glossed "guest formula"/"formula identifier" at first use; added a forward pointer for the two-name split; introduced setup-token vs browser paths before the hedge (also removing the dangling forward reference).
- **copyeditor** — fixed the open-questions sentence fragment, the circular self-referential hedge, and the elliptical colon-fragment after the diagram.

Verified no em/en dashes or typist-hostile code points were introduced (I caught and removed four em-dashes I had initially added, per the em-dash-style / typist-friendly-code-points rules the pedant seat checks).

**Push:** `5528673..c2d15ad` advanced cleanly via `safe-push-pr-head.sh` (advance mode).

**CI:** GREEN at deadline (rc 0, 1 check, 0 failed).

**Follow-ups:** None from this stage. The driver re-posts panel-5; I did not re-run the panel. pedant's lone comment-only heading nit (the one gerund-phrase heading) was left as-is since it was explicitly not a must/should-fix.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr64-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2399474 cached reads)
- Output: 23938 tokens
- Cost: $2.557284999999999
- Wall-clock: 384s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
