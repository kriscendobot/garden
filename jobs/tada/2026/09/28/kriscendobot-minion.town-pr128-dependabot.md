I merged kriscendobot/minion.town#128 (`@anthropic-ai/claude-code` 2.1.268 → 2.1.278 in `tools/claude-harness`) with a **MERGE-NOW** verdict, after pushing one extra commit to get CI green.

**Why it was safe to merge:**
- **Not superseded:** `main` (f69bf87) still pinned 2.1.268 in `package.json`, the lockfile and `release.json`. The PR was ahead=1, behind=0.
- **Old enough:** the lockfile moved 9 versions, the main package plus 8 platform packages, all from 2.1.268 to 2.1.278. Nothing is new and the license didn't change. The newest is `@anthropic-ai/claude-code-linux-arm64@2.1.278`, published 2026-09-19T01:51Z, so the 7-day waiting period ended 2026-09-26T01:51Z.
- **Publisher:** `wolffiex@anthropic.com` on both versions, with no provenance attestations on either side. Neither version is deprecated.
- **Advisories:** OSV found nothing for either version. Every known GHSA for the package only affects versions below 2.1.163, so neither side is exposed.
- **Code:** I packed both versions with install scripts disabled and diffed them. `install.cjs` (the postinstall script), `cli-wrapper.cjs` and `bin/` are byte-identical. Only the version pins in `package.json` and the type declarations in `sdk-tools.d.ts` changed.

**The CI fix I pushed:** CI's `test` check first failed with "`@anthropic-ai/claude-code` must exactly match `release.json`". That is expected: Dependabot only updates the npm pin, and `release.json` is the pin the runtime actually uses. I ran the harness README's documented refresh step, `refresh.mjs`. It verified Anthropic's signed 2.1.278 release manifest against the tracked key (fingerprint 31DD…CACE, unchanged), checked the checksums and sizes of both Linux downloads, and regenerated `release.json` (release commit `809c9806…`). I pushed that as commit 6e2afca to the PR branch; no other code changed.
- Locally, the pin check passes and all 30 harness tests pass.
- CI was green on 6e2afca: https://github.com/kriscendobot/minion.town/actions/runs/36409948535

**What I executed:**
- Posted the verdict comment: https://github.com/kriscendobot/minion.town/pull/128#issuecomment-5868198880
- Merged through `ci-wait-merge.sh --dependabot-auto-merge`. The PR is MERGED at 2026-09-28T10:34:16Z, merge commit `19cb5b80b92a`.
- The merge set off the continuous deploy, which succeeded. The follow-up test run on `main` also passed, all 3 jobs.
- Wrote the ledger entry at `entries/2026/09/28/103430Z-message-botanist-fff568.md`. There is no embargo, so no recheck is scheduled.

**Follow-ups:** npm `latest` is already 2.1.283, so Dependabot will likely open the next bump soon, and it will need the same `release.json` refresh. The refresh could be automated, but I haven't posted a job for that.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr128-dependabot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (2119879 cached reads)
- Output: 9946 tokens
- Cost: $1.2930798
- Wall-clock: 728s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
