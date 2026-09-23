---
kind: panel-run
repo: kriscendobot/minion.town
pr: 32
panel_kind: code
base_ref: origin/main-b5bfb92
rounds: 1
disposition: must-fix
must_fix_total: 7
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 3eebf7e37aa7
recorded_by: endolin-garden-ece02cb4
---

# Panel run — kriscendobot/minion.town #32 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `9a1011d9`

seat verdicts (29): archivist=pass assessor=must-fix benchmarker=pass breaker=comment changeset-auditor=pass corner-prober=must-fix coverage-auditor=comment curator=pass duality-auditor=pass engine-realist=comment fast-checker=comment gateway=pass integrator=must-fix locksmith=pass migrator=comment packager=pass prover=pass pruner=pass purist=pass releaser=comment saboteur=comment scribe=pass spec-keeper=pass stylist=comment surfacer=pass transplanter=pass typist=comment warden=pass wire-watcher=comment
must-fix items (7):
- assessor: Confirmed this is the exact change in scope. Now producing the final per-juror block.
- corner-prober: `soleCapture` (`test/deploy-coherence.test.ts`) is a new helper whose doc comment claims a specific two-sided contrac...
- corner-prober: `envScopes`/`unitScopes` parse via `^KEY=(.*)$`, greedy to end-of-line. An inline trailing comment on the value line ...
- corner-prober: `describe.skipIf(!hasSystemdAnalyze)` / `describe.skipIf(!hasBash)` silently no-op the "unit-file validity" and "depl...
- corner-prober: The socket-poll retry loop (`for _ in {1..15}; do … done`) has its iteration count and terminator line-matched by r...
- integrator: `deploy/aws/systemd/minion-mcp.service:4-6` adds `Requires=endo-daemon.service` (plus `After=`), reversing a decision...
- integrator: Related, should-fix: the PR body's "What to attend to" section doesn't surface that this is a reversal of a previousl...
