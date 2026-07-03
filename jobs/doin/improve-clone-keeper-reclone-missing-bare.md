Harden `scripts/jobs/clone-keeper.sh` so a tracked bare clone that is missing (currently `keep_clone` logs `WARN: tracked clone $dir is missing or not a git repo … skipping` and returns) is re-created rather than abandoned. The canonical `worktrees/endojs-endo.git` feeds the whole library fleet's upstream history, so a missing clone silently voids the keeper's entire purpose (its own header records this clone blocking endo work for six weeks). Extend the `GARDEN_TRACKED_CLONES` spec from `<dir>|<remote>|<branch>` to `<dir>|<remote>|<branch>|<url>` (url optional; parse the 4th field in the `while read` loop and in `keep_clone`), and when the clone is absent and a url is present, `git clone --bare "$url" "$abs"` (bounded by `timeout GARDEN_FETCH_TIMEOUT`, self-contained failure logging like the existing paths, still `return 0` so one clone never aborts the rest) before falling through to the fetch/fast-forward. Set the default endo url in the `: "${GARDEN_TRACKED_CLONES:=...}"` line. When no url is available, keep the existing skip but escalate it (WARN is not enough for a total-outage condition).

---
claim:
  host: endolinbot2
  gardener: 4
  claimed_at: 2026-07-03T04:52:07Z
