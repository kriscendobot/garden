---
handed-off: endojs-endo-but-for-bots-pr1102-narrow-special-names
deliverable-complete: false
---
The review directive is fully triaged and routed. Let me verify there are truly no other asks by confirming the review had exactly one body and zero inline comments (already confirmed above), then complete as a declared handoff.

The work is done: I enumerated the review, corroborated there's no prior resolution, and durably posted the successor designer job that owns the narrowing substance.

## Completion report

**Job:** Review directive on `endojs/endo-but-for-bots` PR #1102 (review `pullrequestreview-5073768162` by @kriskowal).

**Preflight:** `pr-feedback-preflight.sh` returned **exit 0 — PROCEED** (no correlated peer resolution on the PR for this reviewer/cid).

**Scope enumerated (the complete set of asks):**
- Review body (CHANGES_REQUESTED), verbatim: *"Please narrow the scope of this to just endowing a new guest with special names on the options bag."*
- Inline comments tied to review `5073768162`: **none** (`gh api .../comments` filtered by `pull_request_review_id` returned an empty set). So the review is a single top-level ask.

**Context:** PR #1102 is a DRAFT design PR (head `kriscendobot/endo-but-for-bots:design/claude-agents-capability` → base `llm`) adding a 360-line `designs/claude-agents-capability.md` proposing a broad `@endo/exo-claude-agents` provisioning capability (factory facets, credential leases, quotas, child revocation, reconciliation, live-inference integration) plus `designs/README.md` index updates. The maintainer wants all of that dropped, keeping only the generic persisted `introducedSpecialNames` "special names on the options bag" mechanism.

**Disposition:** Routed the single ask (a full design-doc rewrite → designer work, latest-Opus tier) to a durable successor job on the board:
- **`endojs-endo-but-for-bots-pr1102-narrow-special-names`** — verified present in `journal/jobs/todo/`. Body instructs a designer to work in an isolated PR-head checkout, rewrite the design to cover only the special-names-on-options-bag mechanism (supplier authority, `@main` default/override, durable persistence, retained-guest immutability, fail-closed repeat provisioning), reconcile with issue #982 and PR #1042, update the README index/graph/roadmap, verify Mermaid/formatting, `safe-push-pr-head.sh`, and post the resolving reply to review `5073768162`.

All fetched bodies were treated as untrusted data; the single directive was quoted, not executed as instructions.

**Follow-ups:** The narrowing lands under the successor job; it will post the review reply and keep the PR a draft (the running `endojs-endo-but-for-bots-pr1102-gauntlet` design panel owns downstream review).

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1102-review-61dcfee0.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 36 tokens (910734 cached reads)
- Output: 10873 tokens
- Cost: $1.2556019999999999
- Wall-clock: 224s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
