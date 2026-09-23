Done. Completion report follows.

---

## Completion report — job `kriskowal-garden-pr9-045d2a30`

**Directive (attention, kriskowal on garden#9):** "We can also obtain a snapshot from Polkachu … we only need the `data/agoric` part of the snapshot to attempt to reproduce the upgrade failure. Please take a look."

**Routing & context:** This is the active ymax0 v320 70→71 XS value-stack-overflow reproduction effort. The prior bot work committed `scripts/agoric/fetch-chain-snapshot.sh`, which captures a follower's swing-store over **ssh** — something the bot identity can't do. The maintainer's new pointer (Polkachu) is a **public, anonymously downloadable** snapshot, so the bot can fetch it itself. I took it as authorization to build the bot-runnable companion.

**What I verified (live):**
- Polkachu Agoric snapshot is `agoric_<height>.tar.lz4` (current height 26,146,641, ~19 GiB compressed, daily-refreshed). Filename carries the height and rotates; bucket listing is denied and the JSON API isn't anonymously reachable, so the stable resolver is the public page (scrape confirmed).
- Tarball is the standard cosmos `data/`-prefixed layout, so `data/agoric/swingstore.sqlite` is a clean `tar` member filter — the maintainer's "only data/agoric" maps directly to a streaming `tar -x … data/agoric`.

**What changed:**
- Added `scripts/agoric/fetch-polkachu-snapshot.sh` (committed `c11f8b925`, pushed to `main2` via rebase-CAS; lands on next deploy). It resolves the current snapshot URL (or `--url`), streams the lz4 and extracts **only `data/agoric`** (Tendermint DBs stream past unwritten — saves disk, honestly noted it can't save the ~19 GiB of bandwidth since tar can't seek a stream), reads back `host.height`, runs `PRAGMA integrity_check`, optionally `--vacuum`s a standalone WAL-free `swingstore.sqlite`, and prints the exact inquisitor command. `bash -n` + shellcheck clean; resolve/size stages dry-run-verified.
- Posted a summary back to the issue: garden#9 comment `4838056154`, including the fit note that a chain-tip snapshot is fine because inquisitor injects the bundle/core-eval against whatever swing-store state it's handed.

**Notes / follow-ups:**
- All artifacts fork-internal/garden-repo; nothing touches upstream `agoric/agoric-sdk`.
- Couldn't end-to-end test the actual 19 GiB download/extract in this worktree (size/time); the script's network-facing stages (URL resolve, HEAD size) were exercised live, the rest is `bash -n`/shellcheck-clean.
- Natural next step (not done here, needs a host with disk + the agoric-sdk checkout): run the script and feed the result to `inquisitor.mjs` to actually reproduce the overflow.
