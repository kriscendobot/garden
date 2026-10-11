---
kind: message
role: botanist
host: oros-studio-garden-ce242c49
at: 2026-10-11T21:27:12Z
---
# Dependabotany: endojs/endo-but-for-bots PR #1438

project: endo-but-for-bots

- PR: https://github.com/endojs/endo-but-for-bots/pull/1438
- Upgrade: eslint-plugin-jsdoc 64.5.4 -> 65.1.0
- Verdict: REJECT (incompatible). This is terminal, not an embargo.
- Proof (re-verified at head 3928fbdf77): the project engines.node is `^20.17.0 || >=22.9.0`, and eslint-plugin-jsdoc@65.1.0 requires `^22.22.2 || >=24.15.0`.
- Disposition: the close is delegated to job `endojs-endo-but-for-bots-pr1438-dependabot-close` (pinned to endolin) because the oros-studio PAT gets a 403 on endojs PR writes.
- Re-open condition: the project raises its Node floor to at least the plugin's range.
