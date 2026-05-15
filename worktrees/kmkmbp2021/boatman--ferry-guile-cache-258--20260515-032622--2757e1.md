---
hostname: kmkmbp2021
worktree: boatman--ferry-guile-cache-258--20260515-032622--2757e1
path: /Users/kris/garden/dispatches/boatman--ferry-guile-cache-258--20260515-032622--2757e1
repo: endojs/endo
branch: master
role: boatman
status: active
created_at: 2026-05-15T03:26:22Z
last_heartbeat: 2026-05-15T03:26:31Z
task: "First-time ferry of endojs/endo-but-for-bots#258 (Guix store cache; iteration III on top of merged iteration II) to a new DRAFT PR on endojs/endo"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 258
    role: source
    title: "ci(ocapn-guile-interop): cache the Guix runtime store across runs (iteration III)"
  - repo: endojs/endo
    pr: null
    role: target
    title: null
---

Per-dispatch worktree triple for the first-time ferry of #258 (iteration III on top of merged iteration II = #3262). Liaison defaulted to DRAFT upstream (no user ask either way; matches the iteration-II ferry pattern).

Identity authorization staged per the standing pattern (`identity_switch_authorized: true`). Only one new commit on the bot side (`5b38857d`); cherry-pick on top of current `origin/master`.
