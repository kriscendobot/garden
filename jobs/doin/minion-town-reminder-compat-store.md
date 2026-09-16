---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot-minion.town. Design doc `designs/endo-reminder-minion-town.md` §8.7 (landed at commit 528c8ce, "docs: redirect reminder work after revival failure") redirects the `@endo/reminder` plan away from the daemon migration after the authorized 2026-09-16 state-revival dry-run failed (§8.6). Do NOT retry the production daemon redeploy.

Implement the next step per §8.7:
1. Promote `deploy/aws/reminder/store-deployed-daemon-shim.js` from an experimental source overlay to a reviewed, explicitly pinned compatibility store for this deployment.
2. Add conformance coverage that runs the upstream store and this compatibility store through the same config/write/list/remove/restart scenarios and proves identical JSON layout and atomic write-then-move behavior.
3. Keep the plugin source pin and compatibility-adapter provenance visible in the staged artifact.
4. Then exercise `@pins` revival on a throwaway guest using the existing (already-deployed) daemon — this is the remaining lifetime gate the production experiment did not test.

Do not attempt any live-state migration, formula rewrite, or daemon pin bump — the 2026-09-16 authorization covered only the exact `0eb88836` procedure and does not extend here. Read the full design doc (especially §8.7 and §8.6) before starting.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-16T06:02:57Z
