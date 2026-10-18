---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-10-18T21:48:41Z
---
# Dependabotany: endojs/endo-but-for-bots PR #1490 — MERGED

project: endo-but-for-bots

- PR: https://github.com/endojs/endo-but-for-bots/pull/1490
- Headline: actions/setup-node v7.0.0 (820762786026) -> v7.1.0 (949feb2413d6), github-actions, 26/26 base call sites on llm moved uniformly (not superseded).
- Verdict: MERGE-NOW (terminal). Tag hash verified 2026-10-18; published 2026-10-08T02:52:34Z, maturity floor 2026-10-15T02:52:34Z passed.
- Advisory note: bundled smol-toml 1.7.1 is in GHSA-r4xh-jqrq-34v2 (quadratic TOML parse, fixed 1.9.0); judged non-exploitable here, because the only inputs are trusted one-line .node-version files. A future setup-node bump should carry smol-toml >= 1.9.0. undici 6.27.0->6.29.0 clears GHSA-r53p-7pc4-xj5r.
- CI: 40/40 green on fbe1c5c2; conducted via ci-wait-merge.sh --dependabot-auto-merge; merged 2026-10-18T21:48:17Z as c63bf3d8965b.
- Verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1490#issuecomment-6255328424
