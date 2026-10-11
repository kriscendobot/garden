---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/dependabot-watcher.sh
scripts/jobs/dependabot-watcher.sh:723 assigns terminal closes to an arbitrary botanist; at 2026-10-11T22:16:16Z a host lacking comment permission hit 403, failed the handler, and left PR #1439 open. For incompatible and superseded outcomes, emit a deterministic close directive pinned to a host with the required GitHub write capability, and make its scripted executor attempt the close even if the verdict comment fails. Record partial comment failure separately so a terminal PR cannot remain open solely because commentary is unauthorized.
