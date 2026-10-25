---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-10-25T20:40:43Z
---
# Dependabotany: endojs/endo-but-for-bots PR #1553 — EMBARGO-2026-10-26 (CI-infra blocked)

project: endo-but-for-bots
repo: endojs/endo-but-for-bots

- PR: https://github.com/endojs/endo-but-for-bots/pull/1553 (head ba26b7472a, base llm d5ac41980a)
- Bump: eslint-plugin-jsdoc 64.5.4 -> 65.3.12 (major), plus @typescript-eslint/* 8.70.0 -> 8.71.2 (7 packages, transitive via jsdoc's ^8.70.1)
- Row: EMBARGO-2026-10-26. Maturity floor 2026-10-25T15:17:50Z already passed (freshest moved = headline eslint-plugin-jsdoc@65.3.12, 2026-10-18T15:17:50Z). The embargo is an escalation row, not a maturity row: CI is red only from the Ubuntu 26.04 runner migration (build: tred -> #1546; sandbox-drivers/cover: bwrap ulimit -u -> #1542; browser-tests: Playwright chromium unsupported on ubuntu26.04 -> job endojs-endo-but-for-bots-ci-ubuntu2604-browser-tests-playwright). lint is green, so no migration is needed.
- Diligence clean: no OSV/GHSA advisories on any moved version, all trusted-published with SLSA provenance, no install hooks, no license change, no new packages, source diff benign.
- Recheck: when infra reds clear on llm, conduct MERGE-NOW via ci-wait-merge.sh --dependabot-auto-merge (rebases onto live llm first). Daily backstop dependabotany-recheck-endo-but-for-bots is installed.
- Verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1553#issuecomment-6402966822
