PR #130 is open but overtaken: its fixes already reached `main` through #139 and #137. I spent no clean, panel, fix or CI-wait budget.

**PR facts:** kriscendobot/minion.town#130, "fix(deploy): avoid daemon health-probe spawn race". It is open, not draft and unmerged. The head is `d24effe2` and the base is the frozen `main-b32291d`. kriskowal approved it on 2026-09-29 and asked for it to be conducted.

Deciding question: Does current `main`'s `deploy/aws/scripts/deploy-endo-daemon.sh` still lack both protections #130 adds: (a) the health probe must not call the auto-starting `endo list` until the supervised socket is live, and (b) stray or orphaned daemon workers must be reaped before the tree swap and restart?

Evidence: No. Two later PRs merged both protections into `main`, in a stronger form than #130's:
- **The probe guard came from kriscendobot/minion.town#139, merged 2026-09-29T21:59Z.** It is titled "endo daemon probes must not auto-start a stray daemon" and covers the same incident.
  - It adds `sock_accepts`, which checks that the socket actually accepts a connection. That is stronger than #130's `[ -S sock ]`, which only checks the file exists.
  - Its `endo_probe` runs any probe in a sandbox: separate state, cache and run directories, and `ENDO_ADDR=127.0.0.1:0` so it can never take port 8920.
  - Its `reap_strays` kills daemon-user Endo processes running outside the two systemd units. It runs after the preflight, before a rollback restart, and after a healthy swap.
- **The restart and reaping came from kriscendobot/minion.town#137, merged 2026-10-04.**
  - It replaces `systemctl restart` with stop, then `endo-daemon-reap-port-orphans`, then start.
  - The unit's `ExecStartPre` also reaps any orphan holding the port.
  - This covers #130's `stop_endo_daemon` / `endo stop` worker-reaping and its restart→start change.
- **#130 no longer fits `main`.** It patches the old inline `endo_as_daemon … list` probe lines, which `main` has since rewritten. Its static test asserts strings like `[ -S "\$PF/endo.sock" ] && endo_as_daemon` that `main` will never contain. Applying it would mean conflicts, and the result would duplicate weaker guards.
- **The approval is stale.** kriskowal's "conduct" approval (2026-09-29T21:39Z) came before #139 merged. The longer-term fix (making Endo's daemon controls idempotent) is tracked separately in endojs/endo-but-for-bots#1383.

Option: close as superseded

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr130-screen-d24effe2-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (168367 cached reads)
- Output: 1918 tokens
- Cost: $0.4643454
- Wall-clock: 26s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
