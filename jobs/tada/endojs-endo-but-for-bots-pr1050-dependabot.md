The `journal-entry.sh` "posted" line confirms the CAS push to `origin/journal2` landed (the local deployed-root journal worktree just hasn't re-synced, and I won't run git there). The entry body carries both `project: endojs-endo-but-for-bots` and the `# Dependabotany` heading, satisfying the recovery grep. Job complete.

---

## Completion report — botanist on endojs/endo-but-for-bots PR #1050

**Verdict: MERGE-NOW — executed (MERGED).**

`actions/checkout` 6.0.2 → 7.0.1 (`github-actions`, one call site). Re-derived from scratch (fresh worktree, no prior committed work, no prior verdict comment, no ledger row).

**Diligence:**
- **Base-ref census (repo-shaped leg):** Not superseded and not a no-op. Of 32 `actions/checkout` pins across every workflow on base `llm`, **31 already read v7.0.1**; `ci.yml:788` (the `fuzz-ironhorse` job) was the **last v6.0.2 straggler**. This PR advanced it to the repo-wide version. Head 1 ahead / 0 behind.
- **SHA→tag provenance (both sides):** v7.0.1 → `3d3c42e5aac5ba805825da76410c181273ba90b1` (= PR pin, lightweight tag); v6.0.2 outgoing → `de0fac2e…` (= diff's outgoing pin). Both MATCH. Owner canonical (`actions/checkout`).
- **Advisories:** none for actions/checkout on either version (net exposure nil → nil).
- **Source read:** v7.0.0 = ESM migration + dep refresh + a security *hardening* (blocks fork-PR checkout under `pull_request_target`/`workflow_run`); v7.0.1 = unsafe-pr-check skip, ASCII-branch trim, `--unset` escaping. The consuming job triggers on `push`/`pull_request` only, so the hardening doesn't affect it; inputs unchanged.
- **Maturity:** v7.0.1 published 2026-07-20, 34 days past the 7-day floor.
- **CI:** shepherded to 25/25 green on head `0c05fc8f` (waited out the last `fuzz-ironhorse` run, which itself exercises the bumped checkout). No migration push needed.

**Executed disposition:** verdict comment posted (`#issuecomment-5388243251`); conducted via `ci-wait-merge.sh … --dependabot-auto-merge` → **MERGED 2026-08-23T20:17:53Z**, merge commit `ffdd6bf70fdd62c16883015dbfc408183c6b1232`. Confirmed zero v6.0.2 sites remain on `llm`. Dependabotany ledger row written to the journal. No embargo/recheck wiring (terminal verdict).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1050-dependabot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 45 tokens (1605141 cached reads)
- Output: 14754 tokens
- Cost: $1.8053024999999998 (2 engagement(s) unpriced)
- Wall-clock: 328s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
