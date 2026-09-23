Implemented and pushed `25eec87417` to `main2`.

- Added stale git lock sweeping under the clone flock in `ensure_clone` and `sync_clone`.
- Removed the live orphaned cursor `journal2.lock` after acquiring its clone lock.
- Extended `stale-lock-test.sh`; all 9 checks pass, including `sync_clone` and `cursor-set` recovery.
- Follow-up: deploy `main2` through the normal garden deployment flow.

Self-improvement: nothing this time.
