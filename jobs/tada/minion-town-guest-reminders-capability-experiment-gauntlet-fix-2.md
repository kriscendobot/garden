All 5 checks are SUCCESS with zero non-success checks. CI is GREEN (rc 0 equivalent). The fix is pushed and terminal-green.

## Completion report

**Stage:** FIX round 2 of the `minion-town-guest-reminders-capability-experiment-gauntlet`, PR [endojs/endo-but-for-bots#935](https://github.com/endojs/endo-but-for-bots/pull/935) (`design(reminder): integrate @endo/reminder into Chat`, docs-only, head `kriscendobot:design/reminder-integration-chat`).

**Panel-2 must-fix items applied** to `designs/reminder-integration-chat.md` (commit `011ed670d`):

- **Style sweep (pedant, copyeditor):** Rewrote all **85 em-dashes** to periods/parentheses/colons per `em-dash-style` (judgment, not mechanical). Fixed the `→` arrow (line 385) to `->` and the `…` ellipsis to ASCII per `typist-friendly-code-points`. Fixed the garden-path clause to "Every reminder **that** `makeReminder` creates recurs".
- **Verb collision (ergonomist):** Renamed the new scheduler verbs `cancel(id)`/`setPeriod(id, periodMs)` → **`cancelReminder(id)`/`retune(id, periodMs)`** everywhere (lifecycle bullet, Reminder-side section, open question, tests), so they no longer collide with the live `Reminder` exo's `cancel()`/`setPeriod(newPeriodMs)`. Added the missing error-visibility and return contracts: both return `undefined` on success and **throw a `TypeError`** on an unknown/stale/already-cancelled id.
- **Attenuation fork (decomplector, critic):** Resolved the contradictory "required / escape-hatch" framing by pinning it to a named cut. The self-contained `@endo/chat` fallback (the default first-to-ship substrate per § Ordering) now **ships attenuation-free by decision** (UI under `@agent` holds full control, config-corruption risk accepted); real two-principal attenuation is stated as deferred sibling-owned follow-up. Made § Provisioning, § What has to change item 2, § Ordering, and § Open questions internally consistent with that decision.
- **Test-catalog completeness (skeptic):** Added a **slow-send deadline** courier test (the "ordinary degraded case"), extended the **opaque-label** test to cover markdown-syntax escaping and literal U+E000 stripping, added a **negative attenuation-boundary** test (scoped to the attenuated cut), and extended the lifecycle test to assert the throw-on-stale-id contract.

**Verification:** Post-edit, zero typographic glyphs remain (only `§` section signs, unflagged). All `file:line` citations are identical (same set + counts, no drift), both mermaid diagrams intact, no residual bare verbs. The `typist-friendly-code-points` gate probe passes.

**CI:** GREEN. All 5 checks (browser-tests, build, lint, test, zizmor) COMPLETED / SUCCESS on head `011ed670d`; zero non-success checks.

**Note:** Per stage instructions, I did **not** re-run the panel — the driver re-posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-guest-reminders-capability-experiment-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 58 tokens (2685491 cached reads)
- Output: 48328 tokens
- Cost: $4.8672345
- Wall-clock: 750s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
