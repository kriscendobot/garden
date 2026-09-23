---
child-endo-minion-town-federation-endo-build-host: endolin-garden-ece02cb4
child-endo-minion-town-federation-endo-build-reap-count: 0
order: serial
children: endo-minion-town-federation-endo-build endo-minion-town-federation-town-build endo-minion-town-federation-release-gate endo-minion-town-federation-deploy endo-minion-town-federation-live-acceptance
on-child-failure: halt
state: running
created_by: orchestrator
created_at: 2026-09-23T20:54:43Z
---

# Minion Town guest-locator federation

Maintainer priority 2026-09-23, launched by endo-minion-town-guest-locator-federation-supervisor. Plan and ledger change: https://github.com/endojs/endo-but-for-bots/pull/1332 (draft, ec51cecdcf).

Serial: Endo daemon/CLI integration → account locator/public endpoint wiring → reviewed release gate → SSM deployment → actual authenticated browser + separate local endo CLI acceptance. Halt on a failed child. Draft build completion is intentional and never a production approval; release-gate child must block durably on concrete unmet PR dependencies without completing. Manual gauntlet triggers remain with the maintainer. The last child's real-account evidence, not this launcher, is the acceptance verdict.

Rechecked: #340 merged; #684/#688/#693/#990/#1124 draft. Existing browser reveal emits only a raw identifier; CLI adopt is message-only, host adoptFromLocator is available; nonce adapter is unmerged; demo endpoint and account daemon are distinct in checked-in topology. Current town pins f665050 after #111 rollback. No new protocol project or all-M4 completion is implied.
