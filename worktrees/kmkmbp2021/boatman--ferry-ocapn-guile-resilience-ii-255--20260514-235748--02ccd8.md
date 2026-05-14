---
hostname: kmkmbp2021
worktree: boatman--ferry-ocapn-guile-resilience-ii-255--20260514-235748--02ccd8
path: /Users/kris/garden/dispatches/boatman--ferry-ocapn-guile-resilience-ii-255--20260514-235748--02ccd8
repo: endojs/endo
branch: master
role: boatman
status: active
created_at: 2026-05-14T23:57:48Z
last_heartbeat: 2026-05-14T23:58:02Z
task: "Ferry endojs/endo-but-for-bots#255 (ocapn-guile-interop iteration II) to a new DRAFT PR on endojs/endo"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 255
    role: source
    title: "ci(ocapn-guile-interop): harden against bordeaux.guix.gnu.org outages (iteration II)"
  - repo: endojs/endo
    pr: null
    role: target
    title: null
---

Per-dispatch worktree triple for the first-time ferry of #255. The bot-side PR is a draft hardening `ocapn-guile-interop.yml` against bordeaux-down (the symmetric case to iteration I, which kriskowal direct-pushed to upstream master as `246c6a6c` on 2026-05-02). The user opted for a DRAFT upstream PR (offered: normal / draft / direct-push) when asked.

Identity authorization staged in the dispatch prompt per the standing pattern (`identity_switch_authorized: true`).

The boatman picks the upstream branch name; the dispatch prompt suggests `kriskowal-ocapn-guile-interop-resilience-ii` as a starting point but doesn't force it.
