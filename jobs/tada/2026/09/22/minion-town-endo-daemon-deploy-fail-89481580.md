The incident is fully resolved. Here is my completion report.

---

## Completion report: minion.town endo-daemon deploy failure (89481580)

**Incident:** Post-merge CD run 35738152776 (`kriscendobot/minion.town#110`, endo pin bump to `89481580a86c`) failed at *Deploy Endo daemon* — `systemctl is-active endo-daemon` reported `activating` (exit 3), stalling the whole stack (minion-mcp, endo-gateway, login gate, Caddy, landing page all skipped).

**Root cause (upstream endo defect).** The daemon was crash-looping (restart counter 563). The journal showed `Invalid formula identifier "[undefined]"` at `seedFormulaGraphFromPersistence → onFormulaAdded → extractLabeledDeps`. Commit `89481580` makes `registry` a **required** `HostFormula` field (`designs/registry-capability.md § Migration for already-formulated hosts`) and adds fail-fast guards — but the one-shot on-start registry **upgrade pass that its own design promises was never implemented**. minion.town's pre-existing production DB has host formulas that predate `registry`, so:
1. graph seeding unconditionally emits `['registry', formula.registry]` → an undefined dep id → `parseId` crash; and even past that,
2. host incarnation throws `Host formula missing registry (@registry required)`.

The daemon can never start on a pre-registry DB. Not a code-review nit — a genuine incompatibility in the pinned commit.

**What I did:**
1. **Restored service immediately** — the intact prior build was still on the box at `/opt/endo.old` (f665050). Stopped the crash loop, swapped it back to `/opt/endo`, restarted → daemon `active`, socket present. This also matched the still-deployed pre-#110 app client (minion-mcp's deploy had been skipped).
2. **Made it durable** — opened and merged `kriscendobot/minion.town#111`, a clean revert of #110 rolling all three pin locations (deploy script, `captp-client.ts` `PINNED_ENDO_COMMIT`, CI `test.yml` ref) + the paired test changes back to f665050.
3. **Re-greened CD** — the merge triggered deploy run 35743826944, which completed **success** with every step green (Endo daemon, minion-mcp, endo-gateway, login gate, Caddy DNS + config, landing page).
4. **Verified** — endo-daemon `active (running)` on f665050 with socket present; minion-mcp `active`. Removed the broken 89481580 build from the box.
5. **Notified the maintainer** via the bus with the diagnosis and follow-up.

**Changed:** `kriscendobot/minion.town` main — PR #111 (revert of #110), merged.

**Follow-ups (maintainer's call):** Re-attempt the `89481580` bump **only after** `endojs/endo-but-for-bots@llm` lands the promised host-formula `registry` migration (idempotent, must run before host-map exposure). Alternatively fix-forward by implementing that migration upstream rather than reverting. Flagged both to the maintainer.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-endo-daemon-deploy-fail-89481580.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (3495485 cached reads)
- Output: 33374 tokens
- Cost: $3.5532545
- Wall-clock: 796s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
