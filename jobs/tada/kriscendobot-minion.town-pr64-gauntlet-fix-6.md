CI is green. The fix round is complete.

## Completion report

Applied the panel round-6 must-fix items to `designs/claude-agents-capability.md` on PR #64 (kriscendobot/minion.town, a design-doc-only PR), pushed one follow-up commit, and watched CI to terminal green.

**Substantive fixes (request-changes seats):**
- **critic** — (1) named the `ClaudeCredentials` caplet's at-rest substrate (daemon persisted formula-graph state under `/var/lib/endo-daemon`, per-`iss+sub`, `0600`/`0700` perms, durable across restart via reincarnation — explicitly not the deploy-time Secrets Manager pattern); (2) reworded the possessive "descendant's own `iss+sub`" phrasings (interface comment, prose, production-sequence, acceptance-evidence) to "the root user's `iss+sub` that this descendant's tree shares"; (3) specified the host-side form-send trigger on `create()` admission failure and its per-`iss+sub` dedup/idempotency.
- **skeptic** — added acceptance-evidence for the decline branch, connect-link reuse-after-consumption/use-after-expiry, and per-plan `models()` scoping proven across two principals on different plans; added a step-1 gate re-confirming PR 1015's `infer` exo shape.
- **decomplector** — replaced the pid+start-time process-liveness oracle with a value-oriented expiring lease (opaque epoch token, persisted, checked as data against a monotonic clock), so both admission resources reconcile under one discipline.
- **copyeditor / novice** — split the dense diagram-reading paragraph and the `disconnect` sentence (quota moved to its own sentence), glossed `InferResult`, named the section in the "step 4 below" forward reference, added a paragraph break in the quota-admission block, fixed the "sketched"→"noted" forward-reference mismatch and the "Its description"→"The form's description" antecedent.

**should-fix / comment-only:**
- **ergonomist** — dropped the undocumented `guest(): Promise<EndoGuest>` accessor (leftover contrary to the confinement story) with a sentence stating why no raw guest accessor exists; acknowledged the `@claude-`prefix lexical-proximity hazard in Decisions.
- **pedant** — converted all seven all-caps emphasis words to italics.
- **critic note** — flagged the single-inference-slot throughput ceiling explicitly as a user-facing bound.

Commit `b7b2b73` advanced `origin/design/claude-agents-capability`; CI GREEN (1/1). No follow-ups outstanding. Panel re-run (panel-7) is the driver's responsibility, not mine.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr64-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 83 tokens (3630249 cached reads)
- Output: 25645 tokens
- Cost: $3.2980675
- Wall-clock: 421s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
