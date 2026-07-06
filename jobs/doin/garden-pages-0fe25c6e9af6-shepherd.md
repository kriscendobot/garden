# pages-shepherd (auto: red Pages deploy) on kriskowal/garden

The GitHub Pages build/deploy action (`pages-build-deployment`) for the garden site is RED on
its NEWEST completed run — the live site (https://kriskowal.github.io/garden/)
last deploy failed. This is a push WITHOUT a pull request, so wear the
**pages-shepherd** role (roles/pages-shepherd/AGENT.md) — the shepherd applied
to a branch push — and drive the Pages deploy back to green.

Failing run: https://github.com/kriskowal/garden/actions/runs/28790440069
Head SHA:    0fe25c6e9af6cd9e28f7f29e8bde95a284250127
Conclusion:  failure

Classify and act per skills/pages-build-shepherd/SKILL.md:
  - a transient deploy flake ("Deployment failed, try again later") → re-run
    the failed run and verify it goes green (no code change);
  - a real content/build error (a bad docs/ edit, a broken asset path) → fix
    the docs source on the Pages source branch (main2/docs) and push, then
    verify the new deploy is green.
Re-fetch the live run state before acting; a NEWER push may already have
superseded this run (then: nothing to do).

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 14
  claimed_at: 2026-07-06T12:11:47Z
