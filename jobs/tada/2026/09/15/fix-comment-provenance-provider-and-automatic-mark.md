Inbox empty. Work complete.

## Completion report

Fixed `scripts/jobs/comment-provenance.sh` (the fleet's single `gh` PATH chokepoint for comment footers) with all three requested changes, committed and pushed to `main2` (`4637a85f92`).

**What changed**

1. **`provider` fact, distinct from `harness`.** Added `_prov_provider <worker-kind>`, mirroring `common.sh`'s `worker_kind_field <kind> provider` taxonomy exactly (monk/gardener/opencode-anthropic→anthropic, cleric→openai, hermit→local, mystic→moonshot, fireworker→fireworks, openrouter→openrouter, openrouter-promo→openrouter-promo, friar→ollama-cloud). Rendered as `provider <code>…</code>` between harness and garden. Rationale documented: the `codex` harness fronts several providers by kind, so harness alone can't disambiguate.

2. **Explicit "automatic" marker.** `GARDEN_NO_LLM=1` (read by new `_prov_no_llm`) makes `provenance_line` render `model automatic` and omit harness/provider (garden sha kept), taking precedence over any stray inherited `GARDEN_JOB_MODEL`. Set it in the deterministic no-LLM comment posters found by audit: `pr-receipt.sh`, `handlers/comment-reply-gh.sh`, `handlers/block-pr-comment-gh.sh`, `handlers/mirror-close-gh.sh`, plus `handlers/comment-reactji-gh.sh` (intent/robustness — reactions already pass through). Verified the ci/dependabot/comment/issue-inbox watchers post *jobs to the board* (not `gh` comments), sysop acks go to the bus, and the bulletin posts to the journal README — none post `gh` comments, so none needed marking.

3. **Instrumentation-gap alert.** New `_prov_llm_facts_missing` (not automatic AND no model/harness/provider) + `_prov_gap_check` wired into both rewrite paths (`_prov_rewrite_body_flag` and both `_prov_rewrite_api` body sources). On a gap the comment **still posts** (fail-open preserved), and `_prov_note_gap` raises a throttled, per-host maintainer alert keyed `comment-provenance-gap-<host>` (the `missing-tools-<host>` shape). It's self-contained — no `common.sh` source on the hot `gh` path — reimplementing only a minimal throttle+count and forking `watchdog-notice.sh` on the rare delivery.

**Tests.** Extended `comment-provenance-test.sh` with subtests 8–10: provider taxonomy across all eight worker kinds, the automatic path (incl. overriding an inherited model, and suppressing the gap alert), and the gap path (alert raised via `GARDEN_ALERT_CMD` capture, comment still posts, throttled to one delivery per burst, not raised on non-comment/reactji calls). **43/43 green.** `gh-wrapper-fail-closed-test` (49), `comment-watcher-test` (349), and `flat-provider-censor-test` (17) all unaffected. Subtest 7 already drives the real wrapper with a fake `gh` behind it (the harness's non-network exec path); no new shellcheck findings in the added code (the 7 pre-existing SC2004/SC2015 notes are in untouched argv code).

**Scope note.** Did not retroactively edit already-posted GitHub comments — explicitly out of scope (owned by the audit child of this orchestration).

**Follow-ups.** None required. If a `comment-provenance-gap-<host>` alert ever fires in production, it names the exact remedy (export the job facts or set `GARDEN_NO_LLM=1` in the offending path) — that's the intended durable signal replacing the prior silent degrade.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-comment-provenance-provider-and-automatic-mark.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (4941753 cached reads)
- Output: 45757 tokens
- Cost: $4.919714500000002
- Wall-clock: 656s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
