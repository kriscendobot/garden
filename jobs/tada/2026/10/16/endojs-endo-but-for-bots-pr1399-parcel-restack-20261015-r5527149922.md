---
handed-off: endojs-endo-but-for-bots-pr1399-parcel-restack-20261015-finish-endolin
deliverable-complete: false
---
I restacked #1399 onto #1398's current head and revised its design to follow #1460. Moving the PR's base, updating the PR body, CI and the summary comment are not done: this host's token gets HTTP 403 on every write to endojs PRs. I've posted a successor job to finish them on the endolin host.

**Restack (pushed to endojs/endo-but-for-bots)**
- I froze #1398's current head `628a578dd` as `build/sturdyref-daemon-formula-628a578`.
- I rebased only #1399's own commit from the old frozen base `35ccea8` onto it, using `git rebase --onto 628a578 35ccea8`.
- One conflict, in `designs/README.md`. The new base updated the `sturdy-refs-endor-syscall` row and added a `parcel` row; I kept both, with #1399's `sturdyref-agent-api` row after them.
- I force-pushed `design/sturdyref-agent-api` with lease, `bd6265772` → `e9b9ebfc2`. Against the new base the PR changes only `designs/README.md` and `designs/sturdyref-agent-api.md`.

**Design (new commit: `design(parcel): open layer-9 Parcels through the communications vat`)**
This applies #1460, including `b757b8597`, which is the rebased version of `6973c078`, and its rewritten Slot Machine design:
- **Carriage:** Parcels cross the worker connection inline. No slot, no new message type, no Parcel-specific system call.
- **Opening:** a worker opens a Parcel by sending an ordinary message, `E(comms).openParcel(location)`, to a closely held communications capability.
- **Retention:** only the opened result takes part in live retention, through the existing per-agent retention, `drop` and worker-termination rules.
- **Addressing:** the daemon hands formula Parcels to workers through a persistent table keyed by (peer key, secret token), under one key for the host or one per guest shard. Formula IDs never leave the daemon.
- **Removed:** the old `d+`/`d-` slots with `CTP_DROP`, the Parcel `retain`/`release` system calls, and the idea that merely holding a Parcel keeps its formula alive.
- **Open questions:** the old worker-retention question is now answered. Question 4 is now about how long a table entry lives and how it is revoked. I also updated the build plan, tests, ownership map, security section and the README row.

**Checks**
- The cliché check on the changed prose found nothing. The spelling check flagged one British "cancelled", which I fixed.
- No CI has run on `e9b9ebfc2`. The PR still points at its old base, so GitHub reports a merge conflict, and no CI runs started after the push. The last CI on the old head failed only `lint`. This change touches only `designs/`, which Prettier doesn't check.

**Handoff**
The successor job is `endojs-endo-but-for-bots-pr1399-parcel-restack-20261015-finish-endolin`. It is pinned to `host=endolin-garden-ece02cb4` and parked until #1398's own finisher (`…pr1398-parcel-restack-20261015-finish-endolin`) completes. It will:
1. Re-freeze #1398's head and re-run the rebase if that finisher moved it off `628a578`.
2. Move #1399's base to `build/sturdyref-daemon-formula-628a578` (or the newer frozen head).
3. Update the PR body to describe the new design.
4. Get CI green, treating the two failures already seen on the predecessors as inherited: Prettier in `rankCover.test.js` and a macOS timeout in the daemon test.
5. Post the completion summary comment.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1399-parcel-restack-20261015-r5527149922.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (2649159 cached reads)
- Output: 19258 tokens
- Cost: $1.6566238000000002
- Wall-clock: 831s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
