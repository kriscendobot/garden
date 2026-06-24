---
hostname: kmkmbp2021
worktree: boatman--ferry-guile-cache-258--20260515-032622--2757e1
path: /Users/kris/garden/dispatches/boatman--ferry-guile-cache-258--20260515-032622--2757e1
repo: endojs/endo
branch: master
role: boatman
status: collected
created_at: 2026-05-15T03:26:22Z
last_heartbeat: 2026-05-15T03:31:33Z
task: "First-time ferry of endojs/endo-but-for-bots#258 (Guix store cache; iteration III on top of merged iteration II) to a new DRAFT PR on endojs/endo"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 258
    role: source
    title: "ci(ocapn-guile-interop): cache the Guix runtime store across runs (iteration III)"
  - repo: endojs/endo
    pr: 3264
    role: target
    title: "ci(ocapn-guile-interop): cache the Guix runtime store across runs"
---

Per-dispatch worktree triple for the first-time ferry of #258 (iteration III on top of merged iteration II = #3262). Liaison defaulted to DRAFT upstream.

Outcome: upstream PR `endojs/endo#3264` opened as DRAFT on branch `kriskowal-ocapn-guile-interop-cache-store` at head `9f1ac2ddc`. Single commit, `Kris Kowal <kris@cixar.com>`. Full reports at `../../entries/2026/05/15/033302Z-result-liaison-2757e1.md` and `../../entries/2026/05/15/033133Z-result-boatman-8651d3.md`.

Torn down via `skills/dispatch-worktree/dispatch-teardown.sh`.
