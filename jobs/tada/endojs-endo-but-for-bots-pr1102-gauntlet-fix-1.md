Head confirmed as my commit `b84551a20`, CI green, note posted. The FIX stage is complete.

## Completion report

**Job:** Gauntlet FIX round 1 — endojs/endo-but-for-bots PR #1102.

**What I found.** The maintainer's standing `CHANGES_REQUESTED` (2026-09-01) asked to *"narrow the scope of this to just endowing a new guest with special names on the options bag."* The round-1 panel itself flagged that most of its must-fix items landed on sections the narrowing would delete. So the correct one-shot fix was to perform the narrowing, which both honors the maintainer and moots the discardable findings.

**What I did.**
- Renamed `designs/claude-agents-capability.md` → `designs/introduced-special-names.md` and rewrote it to specify **only** the generic daemon seam: an `introducedSpecialNames` option on the shared `MakeHostOrGuestOptions` provisioning bag (`provideGuest`/`provideHost`) that indelibly binds `@`-prefixed special names in a newly provisioned agent — resolved once, persisted in the agent formula, re-supplied across reincarnation, GC-enumerated.
- Dropped the `@endo/exo-claude-agents` package, recursive factory, credential leases/epochs, and child lifecycle (deployment concerns), which mooted the panel must-fix items on those sections (ClaudeAgent remotable discrimination, InferResult union, subscription-busy vs pool-exhausted, credential-lease surface, create/dismiss name grammar, export inventory, scaling measurement).
- **Addressed the must-fix items that survive the narrowing**, grounded in the real daemon code: unresolvable source name now *rejects* provisioning (vs `introducedNames`' silent skip at `host.js:1766-1769`); the option's presence on the shared options type is a deliberate, stated widening (no type split); persisted identifiers are enumerated in the GC reachability (`manager.js` `extractLabeledDeps` `'guest'`/`'host'`) and formula-record tables with a retention test.
- Reconciled `designs/README.md` against llm's advanced state, keeping my footprint off the fragile effort/schedule arithmetic (left at llm's baseline, so no double-count and no new numbers to defend); updated the M3 client-side-bridge carve block (llm's 2026-09-03 groom) from the old broad `endo-claude-agents-capability` scope to the narrowed `introduced-special-names`, plus the summary-table row, recently-added entry, and mermaid node.

**Unblocking CI.** The PR was `CONFLICTING`/`DIRTY` against the advanced `llm` base, which suppressed the merge ref so **no CI ran** (that was the real blocker across the interrupted sessions, not a code failure). I squashed to one commit and rebased onto current `upstream/llm`, resolved the `designs/README.md` conflict, and force-pushed via `safe-push-pr-head.sh --mode rewrite`.

**Result.** Head `b84551a20`, PR `MERGEABLE`, Prettier clean, **CI green (5/5: build, test, lint, browser-tests, zizmor)**. Title updated and two explanatory comments posted. Stopped here per stage contract — did not re-run the panel (the driver re-posts panel-2).

**Follow-ups / notes.** llm's `designs/README.md` carries pre-existing prose-vs-table lag (e.g. `endo-claude` counted in both the M3 carve prose and the M6 effort table); I deliberately did not groom that, only avoided adding to it. The broad Claude-agent child-guest provisioning factory is now explicitly deferred to a deployment (Minion Town) in the design and index.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1102-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 194 tokens (11888197 cached reads)
- Output: 89865 tokens
- Cost: $11.914665
- Wall-clock: 1941s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
