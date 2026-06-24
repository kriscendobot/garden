# Garden bulletin

_As of 2026-06-24T23:04:31Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh, with a
journalist's narrative in the Latest section. This page (the journal's README.md)
IS the bulletin; the journal's layout and design narrative lives in [DESIGN.md](DESIGN.md).

## Messages to the maintainer

- `20260624T223047Z-ff38ba` — from gardener:harden-fleet-gh-identity, reply_to `harden-fleet-gh-identity` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260624T223047Z-ff38ba.md)

> Heads-up from job harden-fleet-gh-identity (gardener-21): the live tree
> /home/kris/scripts/jobs/common.sh has SUBSTANTIAL UNCOMMITTED work — a flock-based
> "per-clone serialization (shared-clone race fix)" adding clone_lock/clone_unlock
> and rewiring ensure_clone/sync_clone/commit_and_push — that is NOT in origin/main2.
>
> Impact: this dirty file WEDGES garden-watchman (its fast-forward aborts on a dirty
> tree), so NO origin/main2 change is auto-deploying to the live /home/kris tree for
> ANY job, garden-wide — it has been stuck at 51030653 while origin advanced.
>
> I did NOT touch/clobber that WIP. I deployed my own fix non-destructively (added
> scripts/jobs/bin/gh; applied my PATH hunk to a different region of the live
> common.sh), so the gh-identity fix is live now and the flock WIP is intact.
>
> Needs a human/owner call: is that flock work an in-flight job that should be
> committed to origin/main2, or abandoned? Until it's committed (or reverted) the
> watchman stays wedged and the live tree won't track origin. I left it untouched
> because committing someone else's untested WIP isn't mine to decide.


## Board
### todo (0)
(none)

### doin (6)
- `address-review-ebfb-pr513` — Address kriskowal's CHANGES_REQUESTED review on endo-but-for-bots #513
- `design-siwe-ymax-mcp-auth` — Design: integrate SIWE with ymax for an MCP that authenticates the caller per...
- `finish-ebfb-pr96` — Finish endo-but-for-bots #96 implementation as designed
- `harden-producer-push-path` — Harden the producer push path: confirm the push landed; fix the shared-clone ...
- `scholar-ingest-cask-5` — Scholar: continue the library ingest of kriskowal/cask (cycle 6)
- `scholar-ingest-cask` — Scholar: deepen the library ingest of kriskowal/cask

### tada (87)
- `fix-comment-watcher-timer-and-classification` — Completion report: fix-comment-watcher-timer-and-classification
- `apply-503-feedback` — Completion report — apply-503-feedback
- `scholar-ingest-cask-4` — Scholar cycle 5 — cask doc/design/trace2.md ingest + cask--trace supersession
- `bulletin-message-links-or-body` — Completion report: bulletin-message-links-or-body
- `research-frb-endo-exo-collections` — Done. The deliverable is live on origin/journal2 and the temp worktree, stale...
- … and 82 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners

## Recent progress
- 224645Z-result-scholar-3840b7.md: # Result: cask library ingest cycle 4 — the GC family, dbstore, and cryptography.md
- 224647Z-progress-gardener-b6b4c0.md: gardener-29 on endolinbot claimed job fix-comment-watcher-timer-and-classification
- 224655Z-progress-gardener-bb7521.md: gardener-67 on endolinbot claimed job research-frb-endo-exo-collections
- 224707Z-progress-gardener-f6906b.md: gardener-17 on endolinbot claimed job bulletin-message-links-or-body
- 224955Z-progress-gardener-23a5b3.md: gardener-15 on endolinbot claimed job scholar-ingest-cask-4
- 225100Z-progress-gardener-032196.md: gardener-62 on endolinbot completed job scholar-ingest-cask-3
- 225605Z-progress-gardener-4688a1.md: gardener-67 on endolinbot completed job research-frb-endo-exo-collections
- 225705Z-progress-gardener-e706f7.md: gardener-17 on endolinbot completed job bulletin-message-links-or-body
- 225808Z-progress-gardener-9cb4b7.md: gardener-76 on endolinbot claimed job address-review-ebfb-pr513
- 225830Z-result-scholar-893212.md: # Result — cask doc/design ingest cycle 5: trace2.md + the cask--trace supersession
- 230006Z-progress-gardener-bcdd79.md: gardener-35 on endolinbot claimed job scholar-ingest-cask-5
- 230047Z-progress-gardener-e106d1.md: gardener-15 on endolinbot completed job scholar-ingest-cask-4
- 230341Z-progress-gardener-9f46e7.md: gardener-30 on endolinbot completed job apply-503-feedback
- 230400Z-progress-gardener-3448f7.md: gardener-86 on endolinbot claimed job design-siwe-ymax-mcp-auth
- 230414Z-progress-gardener-0f1348.md: gardener-29 on endolinbot completed job fix-comment-watcher-timer-and-classification
## Latest

Two jobs landed: `fix-comment-watcher-timer-and-classification` and `apply-503-feedback` both completed, and `design-siwe-ymax-mcp-auth` was claimed into `doin`, leaving the board with six in flight and nothing waiting in todo. The item that needs a human first is the new maintainer message from gardener-21 (`harden-fleet-gh-identity`): the live `/home/kris/scripts/jobs/common.sh` carries substantial uncommitted flock-based "per-clone serialization" WIP that is not on `origin/main2`, and that dirty tree is wedging `garden-watchman` — its fast-forward aborts, so no `origin/main2` change has auto-deployed garden-wide while origin advanced past `51030653`. The gardener deployed its own gh-identity fix non-destructively and left the WIP intact, so the owner call is whether to commit that flock work or revert it; until then the live tree won't track origin.
