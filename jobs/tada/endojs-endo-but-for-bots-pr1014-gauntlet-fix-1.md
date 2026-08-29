CI is **GREEN** (rc 0). All panel items applied, pushed, summarized, and CI verified. The macos-15 leg failure was a runner infrastructure flake (`packages/chat`, node24 process-start failure) that cleared on rerun.

## Completion report

Applied the gauntlet panel round-1 verdict on **endojs/endo-but-for-bots PR #1014** and pushed as review-feedback follow-up commit **`1a223fb35`** (advancing `6d71c5c7c`).

**Fixes applied:**
- **archivist #1 (must-fix)** — reconciled the two contradictory `provideHttpClient` supersession claims in `designs/README.md`. Made the tense explicit: the endo-fetch migration is *planned, not yet landed*, so Phase 1 is a deliberate stop-gap on the live daemon wiring. Added a reconciliation subsection to `designs/cli-http-client.md` and tightened the `daemon-agent-tools` README row to "planned to be superseded (not yet landed)".
- **purist #1 (should-fix)** — swapped six `JSON.stringify(...)` error sites in `http-mk-policy.js` for `q()` from `@endo/errors` (the `pet-name.js` convention).
- **archivist #2 / changeset-auditor (should-fix)** — changeset synopsis metavar `[--as <host>]` → `[--as <agent>]`.
- **releaser #1/#2 (should-fix)** — promoted the load-bearing Phase-1 caveat (mint/register works, live outbound request does not yet complete on `llm`) to a user-facing line beside the changeset headline.
- **wire-watcher #1 (should-fix)** — design doc now states plainly that `--acknowledge-unbounded` is CLI-only UX friction, not enforced/recorded at the `provideHttpClient` minting boundary; recording it in the persisted policy is deferred to the inspect/revoke phase.
- **coverage adds (spec-keeper / corner-prober / fast-checker)** — added IPv6 mixed-case-hex fold, trailing-dot FQDN, `MAX_SAFE_INTEGER+1` boundary, case-collision non-dedup, and fast-check property tests for `parsePositiveIntegerFlag` and `collectHttpOrigin`. Test file now locks down (`@endo/init/debug.js`) because `http-mk-policy` imports `@endo/errors`, matching `list-grouping.test.js`.

**Not acted on:** breaker #1 — the supervisor flagged it a false positive (`.map(normalizeHttpClientOrigin)` is already wired at `http-mk-policy.js:194`); left as-is, confirmed.

**Verification:** `@endo/cli` ava suite green locally (35 tests, +4 new), `eslint`/`tsc`/`prettier --check` all clean on touched files. Posted the scribe-requested completion summary comment (`#issuecomment-5461400436`). CI watched to terminal: **26/26 checks green** (rc 0). One `test (22.x, macos-15)` failure on the first run was a runner infra flake in `packages/chat` — unrelated to this `packages/cli` diff — and cleared on `gh run rerun --failed`.

**Follow-ups (out of scope, noted by the panel for later phases):** thread a recorded `acknowledgedUnbounded` bit through the daemon mint; ship `inspect`/`revoke` verbs; add a red regression test in `http-confine`/`exo-http-client` for the frozen-`Headers` `#286` crash. The benchmarker seat's brief still cites nonexistent paths (`skills/benchmark-comparative-report`, `roles/scout`) — a garden-library maintenance item, not PR-attributable.

Per the stage instruction, I applied the fixes once and stopped without re-running the panel (the driver re-posts panel-2).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1014-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 125 tokens (7090544 cached reads)
- Output: 35593 tokens
- Cost: $5.664364
- Wall-clock: 1501s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
