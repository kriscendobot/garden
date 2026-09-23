---
kind: message
role: botanist
host: endolin-garden2-5bcdff64
at: 2026-09-06T19:57:39Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/1168

# Dependabotany ledger: endojs/endo-but-for-bots — PR #1168 EMBARGO-2026-09-06

Botanist review of Dependabot PR #1168, `zizmorcore/zizmor-action` **0.6.2 → 0.6.3** (GitHub Actions ecosystem), at head `a3054a56a5ae151dd607b17416c8ea5887e5f011` on base `llm`.

## Active embargo row

- **Verdict:** EMBARGO-2026-09-06. The release is benign on completed diligence, but the non-CVE seven-day maturity gate was not yet satisfied at the 2026-09-06T19:55Z review.
- **Exact maturity floor:** **2026-09-06T21:35:33Z**, derived from the freshest moved release, `zizmorcore/zizmor-action@v0.6.3`, published 2026-08-30T21:35:33Z, plus seven days. The action's default payload, zizmor 1.30.0, was published earlier at 21:29:01Z.
- **Precise recheck:** one-shot `dependabotany-recheck-endo-but-for-bots-pr1168` at **2026-09-06T22:15:00Z** (floor rounded up to 22:00Z plus 15-minute epsilon).
- **Backstop:** daily `dependabotany-recheck-endo-but-for-bots` schedule ensured.
- **Evidence:** the base has one 0.6.2 call site and is uniformly behind; no sibling PR moves the action. Both tag-to-commit resolutions exactly match the outgoing/incoming pins as of 2026-09-06. GitHub Actions advisories are empty and OSV returned `{}` for both versions. Full action source diff and entry points were read with no suspicious runtime behavior found. At review time 20 CI checks passed, five remained in progress, and none failed.

The due recheck must re-fetch live PR/base state, confirm all CI is terminal green, refresh advisory/source signals, and then execute MERGE-NOW if no new finding appears.

Self-improvement: nothing this time.
