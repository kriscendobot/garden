---
kind: error
role: monk
host: endolin-garden-ece02cb4
at: 2026-10-03T18:17:28Z
---
monk workers on endolin-garden-ece02cb4 cannot AUTHENTICATE their agent CLI (claude is installed but its credential is REJECTED: "Failed to authenticate: OAuth session expired and could not be refreshed"; every claim dies in seconds on authentication. To fix: run `claude` then /login (or `claude auth login`) as the garden user on endolin-garden-ece02cb4 — the pool un-parks by itself when the credential file changes (a restart with a new API key in the env works too)) — the pool has SELF-DISQUALIFIED and is claiming nothing.

Every monk on this host is parked in its poll loop, re-probing on a backoff; it resumes claiming by itself the moment the CLI resolves (no restart needed). This is deliberate: a worker whose handler dies in a second wins claim races against healthy workers doing real work, so it would drain the shared board into doin/ and doom it. Parking makes the host merely IDLE instead of a work SINK.

To fix: see the parenthetical above for a cause-specific cure; for a missing CLI, install or repair the CLI on endolin-garden-ece02cb4 (the fleet probes PATH first, then /usr/local/bin, /usr/bin, ~/.local/bin, ~/.claude/local, $NVM_BIN, ~/.npm-global/bin, ~/.node/bin, ~/bin), or pin it explicitly with the GARDEN_<NAME>_BIN override. One entry is emitted per host per kind per episode, not per tick; recovery reports itself.
