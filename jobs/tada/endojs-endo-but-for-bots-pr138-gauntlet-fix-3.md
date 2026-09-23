CI is green (rc 0). All five checks passed. The fix stage is complete.

## Completion report

**Stage:** Gauntlet FIX round 3 — endojs/endo-but-for-bots PR #138 (design doc `designs/ocapn-daemon-integration.md`).

Applied the panel-3 must-fix items in one pass, pushed as a follow-up commit, and watched CI to GREEN.

**Must-fix items resolved:**
1. **critic** — netlayer *registration* had no post-`@nets`-cutover path. Added a new subsection *"Netlayer Registration Moves to a Host-Internal Path"* specifying a host-only `registerNetwork(scheme, networkServiceId)` method (the daemon-internal registry's write side) that the four bootstrap scripts retarget to, replacing `E(powers).move([...], ['@nets','X'])`. Added it to the `HostInterface` block and wired Decision #10 to it.
2. **ergonomist** — `Transports.list()` self-contradicted (`Locator[]` vs scheme enumeration). Fixed the code comment to `string[]` (scheme names) and added a single authoritative return-shape paragraph reconciling it with Decision #10.
3. **copyeditor** — moved the misplaced cross-daemon bullet out of the Same-Daemon sharing section (now a pointer to the Cross-Daemon section).
4. **pedant** — removed all 7 em-dashes (rewritten as commas/colons per `skills/em-dash-style`).

**Also fixed (clearly-correct should-fix citations flagged by critic + skeptic, to converge):** stale `daemon.js:4762 makePeer` → `manager.js:6383` (verified in tree), `@nets` injection `host.js:200` → `host.js:499` (verified), and noted the `daemon.js`→`manager.js` rename in Affected Packages + Internal Callers.

**Pushed:** `435691b48` to `endojs/design/ocapn-daemon-integration` via `safe-push-pr-head.sh` (advance mode).

**CI:** `rollup-terminal … total=5 failed=0 → CI GREEN`, rc 0.

Did NOT re-run the panel (driver re-posts panel-4).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr138-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2183497 cached reads)
- Output: 16939 tokens
- Cost: $2.3064705000000005
- Wall-clock: 681s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
