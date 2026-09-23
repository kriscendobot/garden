Inbox empty. The fix stage is complete.

## Completion report

**Job:** `endojs-endo-but-for-bots-pr891-gauntlet-fix-5` — FIX round 5 of the PR #891 design-panel gauntlet (`design(zone): back-port portable @endo/zone`, a design-only PR).

**What I did:** Read the round-5 request-changes panel verdict (29 seats), applied every must-fix item as prose edits to `designs/endo-zone.md` (+ `designs/README.md` date bookkeeping), pushed one review-feedback follow-up commit, posted the required summary comment, forwarded the proposed rules, and watched CI to green.

**Must-fix items addressed (commit `7a6a2cd6a`):**
- `makeOnce` state machine reordered **collision-first** so the revival `used` mark is load-bearing.
- `makeAdapterZone` given a **single synchronous return contract**; daemon async revival moved to host bootstrap that resolves before the sync core call.
- Options bag gained `detachedStoreProvider` and an explicit `keyMapper`; `makeSubZone` results now core-wrapped/ancestor-rejected; per-incarnation reverse map catches mapper aliases.
- `isStorable` triple-role disambiguated (`hostIsStorable` option vs `isStorable` export vs composed `zone.isStorable`); composed predicate stated to gate every value-admitting seam; core default fixed as a superset of `@agoric/zone`'s heap admission.
- Hardening made a core-side every-read-path obligation with a `lockdown()` precondition; anti-marshalling argument re-grounded on pass-style rejection.
- Detached brand **survives revival** via adapter re-branding; admit-as-member vs reject-as-name named as distinct predicates.
- Phase-3 write-through failure split into **free** (crash) vs a distinct fatal **failed/poisoned** state (in-incarnation).
- Label injectivity/boundary pinned (well-formed-string validation, property-based test, pet-name-grammar mapping); rank iteration order qualified up to ties; Phase 4 gated on unlanded `@endo/ertp` #778; "heap plus daemon" floor corrected to heap-only; eager-revival cost named/deferred (design + PR body).
- Testing plan strengthened (reentrancy/revival-rejects/spy-provider scenarios, expanded `fc.commands` set, `arb-passable`/`@fast-check/ava`, corrected precedent, `.d.ts`/composite-tsconfig/changeset deliverables).
- **scribe #1:** posted the top-level round-5 summary comment (issue-comment `5549356693`).
- **scribe #2:** forwarded the deduplicated proposed rules to `role/gardener` over the bus (`20260905T043249Z-0b75db`).

**Verification:** Prettier clean; mermaid untouched; CI terminal **GREEN** (5/5, 0 failed).

**Follow-ups:** The driver re-posts panel-6. Deliberately deferred (round-5 `summary-fix`/`comment-only`, not must-fix): `designs/README.md` absolute-count re-anchoring (pre-existing base drift, deltas correct) and the seat self-improvement-note record.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr891-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 108 tokens (6934199 cached reads)
- Output: 52349 tokens
- Cost: $6.3183525000000005
- Wall-clock: 1188s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
