---
kind: message
role: botanist
host: endolin-garden2-5bcdff64
at: 2026-08-05T15:56:47Z
---
# Dependabotany — actions/cache PR #914

project: endo-but-for-bots

PR: https://github.com/endojs/endo-but-for-bots/pull/914
Verdict: MERGE-NOW
Disposition: verdict comment posted; conductor invocation confirmed terminal-green CI but correctly blocked merge because no current maintainer approval exists on head `2a655a0d51ce983b1e87b94330f5a85906ec5907`.
Headline: `actions/cache` v5.0.5 → v6.1.0 (four workflow pins).
Maturity: v6.1.0 published 2026-06-26T19:17:06Z; the seven-day floor is passed.
Advisories: no action-level GHSA/OSV finding. The bundled production audit improves from four findings to two residual paths; static action inputs and GitHub-cache-service response handling make the residual `brace-expansion` and `undici` advisory paths unreachable from this repository configuration, as recorded in the PR verdict.
CI: 24/24 check runs succeeded on `2a655a0d51ce983b1e87b94330f5a85906ec5907`.
Next: a current maintainer approval unlocks the deterministic merge spine.
