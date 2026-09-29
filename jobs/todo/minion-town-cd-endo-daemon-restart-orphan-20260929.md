---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix the endo-daemon restart orphan that wedges minion.town CD

Every push-triggered `deploy (continuous deployment)` run on
kriscendobot/minion.town executes deploy-endo-daemon.sh step 4g
(`systemctl restart endo-daemon`) unconditionally. On 2026-09-28/29 three
consecutive runs failed there (runs 36481737780, 36488380806, 36504041503):
the restart orphans the daemon's manager-node child (PPID 1, spawned via
/opt/endo/packages/daemon/src/manager-node.js), which keeps 127.0.0.1:8920
bound, so the restarted daemon dies with EADDRINUSE and crash-loops; the
script's rollback cannot heal it either (same orphan). Manual recovery
applied 2026-09-29 ~00:41Z: stop unit, kill the PPID-1 orphan holding :8920,
start, restart minion-mcp (its CapTP session dies with the daemon).

Task: make the restart path reliably reap the manager-node child so CD stops
wedging. Likely fixes, pick after diagnosis on the unit file installed by
deploy/aws/scripts/deploy-endo-daemon.sh: KillMode/ExecStop that covers the
child, or a pre-start guard in the script (kill any orphan manager-node
bound to the daemon port before systemctl start), plus a regression check in
the deploy script. Note the daemon was at pin f9cbcfc and healthy before each
wedge — this is a shutdown-ordering defect, not a pin problem.

Minor rider (same surface, optional): the minion-git-remote unit's git child
logs `warning: unable to access '/home/minion-git/.config/git/attributes':
Permission denied` on every served request (ProtectHome + no home dir);
setting Environment=HOME=/var/lib/minion-git (or GIT_CONFIG_GLOBAL=/dev/null)
in deploy/aws/systemd/minion-git-remote.service silences it.
