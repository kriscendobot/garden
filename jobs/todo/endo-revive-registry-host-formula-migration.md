---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: endojs/endo-but-for-bots @ llm (HEAD 2d0f7fb7f0). Revive the closed PR #899 "fix(daemon): migrate persisted host formulas missing registry" (branch build/registry-host-formula-migration, currently 2 ahead / 2243 behind llm) — rebase it onto current llm, re-verify its test (packages/daemon/test/registry-endo.test.js, strips `registry` off a persisted host formula and asserts in-place migration), and open a fresh PR.

Context: #899 was closed 2026-07-31 by 0xpatrickbot with the explicit rationale "this migration services a compatibility window with no known occupants ... If a real deployment with pre-#671 persisted state ever surfaces, this branch has a complete, tested implementation to pick back up." That occupant has now surfaced: kriscendobot-minion.town landed the `registry`-required daemon pin (89481580, PR #110) in production and it crash-looped — `manager.js` line ~3819 still throws `Host formula missing registry (@registry required)` fast on any pre-existing host formula, with no upgrade pass, because minion.town's production daemon DB predates `registry`. minion.town reverted the pin back to f665050 to restore service (PR #111) and states it will "re-attempt the 89481580 bump only after endo-but-for-bots@llm implements the promised host-formula registry upgrade pass" (designs/registry-capability.md § Migration for already-formulated hosts).

Cite kriscendobot-minion.town#111 (revert) and #110 (original pin bump) in the new PR body as the real-world occupant justifying reviving #899. After it merges to llm, notify so minion.town can re-attempt the daemon pin bump.
