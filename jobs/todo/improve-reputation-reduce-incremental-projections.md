---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/reputation-reduce.sh
Make projection recomputation bounded and resumable: track changed/finalized event arms and recompute only affected projections, with a clean checkpoint/defer path. The full-history reducer has timed out twice in fifteen minutes, so repeated complete scans no longer fit its service window.
