---
hostname: kmkmbp2021
worktree: boatman--ferry-ocapn-guile-resilience-ii-255--20260514-235748--02ccd8
path: /Users/kris/garden/dispatches/boatman--ferry-ocapn-guile-resilience-ii-255--20260514-235748--02ccd8
repo: endojs/endo
branch: master
role: boatman
status: collected
created_at: 2026-05-14T23:57:48Z
last_heartbeat: 2026-05-15T00:03:19Z
task: "Ferry endojs/endo-but-for-bots#255 (ocapn-guile-interop iteration II) to a new DRAFT PR on endojs/endo"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 255
    role: source
    title: "ci(ocapn-guile-interop): harden against bordeaux.guix.gnu.org outages (iteration II)"
  - repo: endojs/endo
    pr: 3262
    role: target
    title: "ci(ocapn-guile-interop): reorder substitute servers and widen sturdyref wait"
---

Per-dispatch worktree triple for the first-time ferry of #255. The bot-side PR was a draft hardening `ocapn-guile-interop.yml` against bordeaux-down (the symmetric case to iteration I, which kriskowal direct-pushed to upstream master as `246c6a6c` on 2026-05-02). The user opted for a DRAFT upstream PR (offered: normal / draft / direct-push) when asked.

Outcome: upstream PR `endojs/endo#3262` opened as DRAFT on branch `kriskowal-ocapn-guile-interop-resilience-ii` at head `407d25c5b7`. Full reports at `../../entries/2026/05/15/000521Z-result-liaison-02ccd8.md` and `../../entries/2026/05/15/000319Z-result-boatman-d0adfe.md`.

Torn down via `skills/dispatch-worktree/dispatch-teardown.sh`.
