---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
skills/gardener-inbox-error-reporting/report-error.sh
The 2026-10-13T16:15:36Z gardener error names capture `a26a843…`, but it is not resolvable in the mentor journal; `report-error.sh:173-188` suppresses commit/push failures yet returns the SHA. Return nonzero unless the capture-and-inbox commit is durably pushed, so `gardener.sh:1917-1930` uses its fallback instead of publishing an unusable diagnostic reference.
