---
kind: dispatch
role: cleaner
host: endolinbot
posture: liaison
short_id: 638ea4
dispatch_root: dispatches/cleaner--638ea4
repo: endojs/endo-but-for-bots
branch: feat/cli-http-client-mk-phase-1
pr_number: 286
slot: 1
---

Cleaner stage for slot 1 PR #286 (cli-http-client Phase 1, llm base).
Builder shipped controller + client cap pair, new CLI verb `endo http
mk`, origin allowlist policy enforcement. 17 files, +1232/-9, 22 new
tests. Cleaner brief: lint/format pass, coverage audit on the new
`http-client.js` module, adversarial sweep on the origin allowlist
(SSRF stepping-stone, scheme spoof, hostname normalization, IDN /
punycode, IPv6 literal, mixed-case scheme), pair invariant check
(controller bears policy / client uses it), drift check against the
design's deferral list.
