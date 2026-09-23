Everything is verified complete: PR #1102 is DRAFT, head `a1f172b20`, only the 2 design files changed, inbox empty.

## Completion report

**Job:** Narrow design PR #1102 (`endojs/endo-but-for-bots`) to the special-names-on-options-bag mechanism, per @kriskowal's CHANGES_REQUESTED review `pullrequestreview-5073768162`.

**State on resume:** A prior session (before the two reaper requeues) had already performed the bulk of the rewrite and pushed it. I verified that work was correct and complete, closed the one genuine gap against the ask (explicit #982/#1042 reconciliation), and finalized.

**What changed:**
- The broad 360-line `designs/claude-agents-capability.md` was replaced by `designs/introduced-special-names.md` (title: *"Endow a new agent with indelible special names on provisioning"*). Its sole subject is the generic `introducedSpecialNames` option on the shared provisioning options bag (`MakeHostOrGuestOptions`, honored by `provideGuest`/`provideHost`): who may supply it (only the providing host/creating authority), omitted-config-preserves-`@main` vs explicit introduce/override, one-time resolution, formula persistence + re-supply across daemon reincarnation, indelibility, and fail-closed behavior on an unresolvable source or a differing re-provide.
- **Dropped entirely:** factory facets, credential-account scopes, single-use leases, quotas, child lifecycle/revocation, reconciliation, and the live-inference integration.
- `designs/README.md` fully updated: index entry, dependency-graph node (`isn`, `eclaude --> isn`), milestone-table row rewrite, and roadmap prose all narrowed.
- **My additions this session (commit `a1f172b20`):** explicit citations making step 3's reconciliation traceable — #982 named as the driving issue, #1042 (`feat(daemon): retain guests with introducedNames and code-mode globals`) named as the `EndoHost.provideGuest`/`introducedNames` API this design *extends* rather than paralleling. The doc already adopted that API surface; the change makes the lineage explicit.

**Verification:** PR is DRAFT, base `llm`, exactly 2 files changed, head `a1f172b20`. No Mermaid diagrams in the doc (nothing to validate). Pushed via `safe-push-pr-head.sh --mode advance` (`5f79ac9ff..a1f172b20`).

**Review reply (step 7):** Prior narrowing reply exists (`issuecomment-5536029278`); I posted a follow-up naming the final head and the reconciliation: https://github.com/endojs/endo-but-for-bots/pull/1102#issuecomment-5538836389

**Follow-ups:** none — the design gauntlet/panel already running on #1102 owns downstream review; PR intentionally stays DRAFT.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1102-narrow-special-names.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 46 tokens (1271996 cached reads)
- Output: 12382 tokens
- Cost: $1.3084155
- Wall-clock: 216s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
