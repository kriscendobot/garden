CI is green ("pass"). The build is complete. Let me write the completion report.

---

## Completion report — `minion-town-formula-graph-content-gc`

**Re-derived state:** No prior PR existed for this job (the reaper requeue lost the earlier attempt's tree). The sibling *design* job `minion-town-clip-formula-id-origin-gc` was running concurrently on another host and had not landed a GC design doc, so per the spec I implemented directly from this job's maintainer direction.

**Delivered — draft PR [kriscendobot/minion.town#83](https://github.com/kriscendobot/minion.town/pull/83)** (branch `build/clip-content-gc`), a mark-and-sweep GC for the clip content store:

- **`src/endo/gateway/content-gc.ts`** — the collector. Root set = the live **vhost table** (the gateway-side projection of the daemon's formula graph: a live record ⇔ a live retaining directory formula). Mark = each live record's `contentRoot` (manifest blob) ∪ the blobs the manifest names; sweep unlinks the rest. Fails **open** on an unreadable manifest.
- **In-flight-publish interlock** — an mtime age gate (default 1h). `publish` interns blobs *then* writes the record, so a mid-publish, not-yet-linked blob is protected; `.tmp-*` intern siblings are structurally excluded.
- **`content-gc-main.ts`** — CLI/systemd entrypoint, **dry-run by default**; deletion armed only via `--sweep`/`CONTENT_GC_SWEEP=1`.
- **`endo-content-gc.{service,timer}` + `deploy-endo-content-gc.sh` + a CD workflow step** — a daily dry-run-by-default sweep, wired into the app-artifact deploy.
- **`test/gateway/content-gc.test.ts`** — 10 cases incl. the four required properties (referenced blob survives; upgrade-orphaned collected; unregister-orphaned collected; in-flight intern survives). **Regression evidence** captured: breaking the mark step fails (a)/(b)/(d), revert restores green.
- **`designs/clip-content-gc.md`** — retention model, interlock justification, cadence rationale, and the **stranded directory-formula sibling gap**: `unregister` leaves the guest's own `clip-<n>` directory formula alive, but it retains *no* fs blob, so it never blocks content reclamation (dropping the guest pet name on unpublish is a scoped follow-up, not required here).

**Production dry-run evidence** (read-only SSM audit of `i-0380cd68b90020fad`, 2026-09-03, counts/bytes only — injection-safe): 39 live records → 106 reachable blobs; **177 blobs on disk (0.50 MiB), 71 reclaimable (0.22 MiB, ~40%)**, `manifestMiss: 0`, `retainedYoung: 0`, all blobs accounted for. Dry run **clean** — deletion can be armed by an operator; this build deliberately does *not* flip `CONTENT_GC_SWEEP=1`, per the mandate.

**Verification:** `tsc` clean; `npm test` green (309 passed / 5 skipped, incl. the 10 new); PR #83 CI **green**.

**Follow-ups:** (1) operator arms real deletion once the maintainer reviews the clean dry-run; (2) strand-free unpublish (drop the guest directory pet name); (3) optional on-unpublish incremental reclaim atop the periodic backstop. The normal builder gauntlet (panel → fix-loop → un-draft) is the downstream step for the draft PR.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-formula-graph-content-gc.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 100 tokens (5726271 cached reads)
- Output: 46715 tokens
- Cost: $5.464278499999997
- Wall-clock: 777s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
