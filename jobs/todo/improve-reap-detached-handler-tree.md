---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardener.sh
Defect: `scripts/jobs/gardener.sh:778` reaps only the handler process group, so `setsid` descendants escape; at 2026-10-23T00:06:35 systemd reported 151 leftover node/MainThread processes across cleric workers. Replace this call with the existing bounded `reap_process_tree` helper and add a regression test for a detached descendant.
