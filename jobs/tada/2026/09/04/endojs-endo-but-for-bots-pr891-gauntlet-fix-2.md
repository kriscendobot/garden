Round-2 FIX stage complete for endojs/endo-but-for-bots PR #891 (`design(zone): back-port portable @endo/zone`).

**What I did:** Read the panel-2 request-changes verdict (~30 juror blocks) and applied its must-fix items to the design doc in one review-feedback follow-up commit (`d8dcb76c5`), pushed to the PR head `origin/design/endo-zone` via `safe-push-pr-head.sh`.

**Changes to `designs/endo-zone.md`:**
- **detached brand** — replaced the erased type-level tag with a runtime-observable, core-held per-incarnation `WeakSet`; enforcement moved core-side (core wraps host named-store providers + `makeOnce`, rejects before delegating). Scoped the restriction to "named, revivable system of record" so the ERTP per-instance recovery-set idiom (detached store embedded in exo `init` state) stays legal — explicitly resolving the migrator-vs-assessor panel disagreement in the prose.
- **makeOnce** — three-state key (free/in-progress/used) closing the reentrancy window; mark used on the revival path too; retry guarantee scoped to allocation-free makers (or adapter atomicity); maker stated synchronous; revival stated eager for durable adapters, no re-validation.
- **Isolation** — label derivation stated injective + host key-mappers must preserve it; per-incarnation set keyed by fully-scoped label.
- Added Zone **passability** and the **harden** invariant; `isStorable` stated as a **conjunction** (core ∧ host), never replacement.
- Added `detached` to the compat surface with its narrowing; reconciled the Phase-1 test list with body prose; two-Zone fallback acceptance for Phase 4/testing; shared conformance-suite shape.
- **Prompt section** — replaced the synthesized paraphrase with both maintainer comments quoted verbatim + correct `#discussion_r...` anchors.

**Changes to `designs/README.md`:** added `Updated 2026-09-04` and synced the summary row; fixed the count-ledger chain (195→196 stated on the 09-03 entry); stated the M10 aggregate is unchanged; moved the endo-zone estimate row into the M10 block.

**PR body:** swept "useful"→"existing", added the `detached` narrowing note and the explicit no-changeset statement.

Prettier clean; all referenced in-repo paths verified to resolve.

**CI:** GREEN — all 5 checks pass on head `d8dcb76c5` (test, lint, build, zizmor, browser-tests, verified via REST check-runs after a GraphQL secondary-rate-limit blocked `gh pr checks`).

**Follow-ups (not this stage):** several should-fix/comment-only items remain for future rounds (e.g. `makeAdapterZone` naming, `watchPromise` observable-contract details, the broader pre-existing README count drift of 202 table rows vs. claimed 197). The driver re-posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr891-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s)
- Input: 128 tokens (7181877 cached reads)
- Output: 36210 tokens
- Cost: $8.979041500000003
- Wall-clock: 1255s
- Model(s): claude-opus-4-8 ×4

<!-- garden-usage-end -->
