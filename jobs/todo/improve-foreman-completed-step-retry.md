---
posted_at: 2026-10-27T14:51:31Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/foreman.sh
Defect: `scripts/jobs/foreman.sh:573-582` turns a completed-basename collision into a maintainer notice; at 2026-10-27T14:39:44Z it re-proposed the already-completed `...pr1349-fix-remaining-panel-findings-20261027-expanded-window`.
Include completed job bases in the deterministic handler digest and, on rc=79, make one bounded re-prompt that excludes the rejected base rather than escalating routine candidate selection.
Preserve the anti-flap guard and only surface a maintainer note if the replacement proposal is absent or also invalid.
