---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-10-04T20:38:09Z
---
# Dependabotany — endojs/endo-but-for-bots PR #1420 — MERGE-NOW (merged)

project: endo-but-for-bots

The `all-minor-patch` group, 20 headline updates, moved 59 lockfile resolutions: `@anthropic-ai/sdk` 0.128.0, `@earendil-works/*` 0.87.1, `rollup` 4.63.5 (+25 platform binaries), `turbo` 2.11.4 (+6), `@types/node` 26.6.3, `typescript-eslint` 8.70.1, `amaro` 1.2.1, `dompurify` 3.4.15, `marked` 18.0.14, `monaco-editor` 0.57.0, `openai` 7.23.0, `prettier` 3.9.9, `ws` 8.22.0. Verdict **MERGE-NOW**, executed: conducted onto `llm` via `ci-wait-merge.sh --dependabot-auto-merge`, CI 35/35 green with 0 failed, state=MERGED.

- Maturity floor: the freshest moved version is `ws@8.22.0` (2026-09-26T15:00:57Z, not a group anchor), so the floor was 2026-10-03T15:00:57Z, already past at review.
- No new package names (the `@typescript-eslint/*@8.70.1` entries duplicate the 8.70.0 copies), no license changes, no install scripts, and publishers unchanged on every package.
- Advisories: only dompurify has any. The bump is a strict reduction: outgoing 3.4.8 had GHSA-55q2 (medium), GHSA-cmwh / CVE-2026-65898 (medium), GHSA-c2j3 (low), and GHSA-vxr8 (low); incoming 3.4.15 has GHSA-p98j (low, fixed in 3.4.16). The residual is unreachable because it needs `IN_PLACE` sanitize, and the only consumer (monaco's vendored copy, `domSanitize.js`) uses `RETURN_DOM_FRAGMENT`/`RETURN_TRUSTED_TYPE` only. 3.4.16 is blocked by monaco's exact pin.
- Source tarball diffs: no new URL hosts; the spawn/exec surface is unchanged.
- Verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1420#issuecomment-5983967212

Terminal row; no recheck scheduled.
