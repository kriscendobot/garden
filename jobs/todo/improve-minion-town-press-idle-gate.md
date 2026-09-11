---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/minion-town-press-preflight.sh
Harden idle detection so repeated completed press reports waiting on unchanged maintainer re-review are treated as no-work instead of unmarked reports defaulting to “advanced.” The digest shows three clean no-op presses in one window; move this recurring pause decision into the deterministic preflight and suppress further dispatches until relevant state changes.
