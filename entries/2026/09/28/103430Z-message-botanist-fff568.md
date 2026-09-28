---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-09-28T10:34:34Z
---
# Dependabotany — kriscendobot/minion.town PR #128

project: minion-town

**Verdict:** MERGE-NOW (executed — merged 2026-09-28T10:34:16Z, merge commit `19cb5b80b92adfa03047263862088b555c658a07`).

**Upgrade:** `@anthropic-ai/claude-code` 2.1.268 → 2.1.278 in `/tools/claude-harness`, with the 8 platform-binary optional deps moving in lockstep. No new packages and no license change.

**Maturity floor:** the freshest moved version is `@anthropic-ai/claude-code-linux-arm64@2.1.278` (not the headline), published 2026-09-19T01:51:01Z, so the floor was 2026-09-26T01:51Z. The floor was satisfied at merge. The upgrade does not repair a CVE.

**Advisories:** OSV is clean on both sides. None of the GHSA ranges covers either version (all end below 2.1.163). The publisher is unchanged (`wolffiex@anthropic.com`), with no attestations on either side. `install.cjs`, `cli-wrapper.cjs`, and `bin/` are byte-identical between the two versions.

**CI green via step-6 migration:** `claude-harness:check` failed at first because `release.json` still read 2.1.268. I ran the documented `refresh.mjs`, which GPG-verified the manifest against the tracked Anthropic key (the fingerprint is unchanged) and yielded release commit `809c980662e3525645594dc8b74f78c38a348db1`. That is commit `6e2afca`. Green run: https://github.com/kriscendobot/minion.town/actions/runs/36409948535. Verdict comment: https://github.com/kriscendobot/minion.town/pull/128#issuecomment-5868198880
