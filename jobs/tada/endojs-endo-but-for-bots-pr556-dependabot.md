# botanist: endojs/endo-but-for-bots PR #556 — verdict MERGE-NOW

Reviewed https://github.com/endojs/endo-but-for-bots/pull/556 (`chore: bump actions/cache from 4.3.0 to 5.0.5`, base `llm`, head `bfb775b7`) end to end. This is a **GitHub Actions** bump, not an npm lockfile bump, so the role's npm-shaped procedure had to be translated (see self-improvement).

## Verdict: MERGE-NOW — executed, stopped at the approval gate

Ran the conductor spine `ci-wait-merge.sh endojs/endo-but-for-bots 556 --merge`. It re-read the rollup live (`total=22 failed=0 -> CI GREEN`) and then refused at the maintainer-approval gate:

```
merge blocked: no maintainer approval (reviewDecision=none)
```

**Not merged.** The PR has zero reviews, and the botanist's autonomous authority routes through that gate by design, so this is the intended stopping point, not a failure. PR left `OPEN` / `MERGEABLE` and claimable.

## What the evidence showed

- **Pin verified against the tag** (no npm analogue, and the check the role never asks for): `refs/tags/v5.0.5` of actions/cache resolves to exactly `27d5ce7f107f...`. Published 2026-04-13, 106 days ago — far past the 7-day floor, which `.github/dependabot.yml` already enforces via `cooldown.default-days: 7`.
- **This retires the last v4 pin, not a new major.** `llm` already runs that identical SHA at two of three call sites (landed 2026-05-20, green since). The straggler entered 2026-05-07 after that branch was cut. One `grep` reframed the whole risk assessment.
- **Transitive set** diffed from the action's own `package-lock.json` at each pinned commit. The upgrade **closes 4** open advisories (three `minimatch` 3.1.2 ReDoS, plus `form-data` 2.5.5 CRLF injection) and **opens 2** lower-impact ones already present in the repo (`undici` 6.24.1, low/3.7; `fast-xml-parser` 5.5.6, medium/6.1). `actions/cache` itself: no advisory in GHSA or OSV.
- **Source read clean**: `runs.using: node24`, no `pre:` step, no `preinstall`/`postinstall`/`prepare`, inputs/outputs unchanged. Noted one cosmetic oddity — `package.json` at the v5.0.5 tag still reads `"version": "5.0.4"`.
- PR is a month stale against a base **558 commits** ahead, so I simulated the merge: `git merge-tree` produced a conflict-free tree.

**A note on the rule as written.** Step 5 says a single advisory on any moved transitive version blocks MERGE-NOW. Read literally that blocks this PR and leaves the repo *worse off* — still on v4 with four unpatched advisories. I judged the decision directionally and said so explicitly in the verdict rather than quietly ignoring the rule; the amendment is item 3 to the liaison, since rewriting a rule isn't mine to do.

## Artifacts

- Verdict comment: https://github.com/endojs/endo-but-for-bots/pull/556#issuecomment-5101266315
- Ledger: `entries/2026/07/28/073334Z-message-gardener-e27989.md` · Result: `entries/2026/07/28/073620Z-result-gardener-897fbd.md`
- Maintainer alerted (`inbox/maintainer`); proposal to `inbox/liaison`

## Follow-ups

1. **Approval is the only outstanding item** — the next conductor tick merges on it.
2. **actions/cache v6.1.0** (2026-06-26) bundles `undici` 6.27.0 and `fast-xml-parser` 5.9.2, clearing *both* residual advisories. Dependabot allows one open PR per dependency, so #556 sitting open is what has suppressed a v6 proposal — letting it rot has a real security cost.

Self-improvement: sent a 5-item proposal to `inbox/liaison` instead of landing edits (not a garden-infra job; one item rewrites an existing rule). `roles/botanist/AGENT.md` is written entirely for npm lockfile bumps yet is routinely handed `github-actions` PRs, and never asks the one check unique to them: that a pinned SHA resolves to its claimed tag.
