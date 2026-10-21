**Undraft stage: endojs/endo-but-for-bots#1521 is now ready for review.** The PR is "feat(endor): directory input for endor run", Phase 3 of endor-run-expanded.

- **Check before the change:** `gh pr view` showed the PR OPEN and still a draft, with head `0300b55f9f2be62358231bba50fcfc03979027d7`. That is exactly the commit the panel passed.
- **Change:** I ran `gh pr ready`, and it succeeded.
- **Check after the change:** `isDraft` is false and the head is still `0300b55f9f2be62358231bba50fcfc03979027d7`.

**Advisory appellate pass** (a light `claude -p` review of the 4-file, 586-line diff). These are notes only and did not block the undraft:
- **Symlinks:** a symlinked input root is followed because of `dir.is_dir()`, but the design doc says symlinks are not followed. There is also a small window where a file could be swapped for a symlink between the file-type check and `std::fs::read`. That only matters if the input directory is writable by an attacker.
- **Same hash for directory and ZIP input:** this is claimed but only tested on the simple layout. Odd ZIP entry names (backslash separators, `./` prefixes, duplicate entries) are not covered.
- **Uneven strictness:** non-UTF-8 names and unreadable files abort the ingest, while symlinks and special files are skipped silently. An abort part-way through can leave orphan blobs in the content store (CAS).
- **Shared temp store:** the store path `temp_dir()/endor-cas` is predictable in a shared `/tmp`, so another user on the host could pre-create or tamper with it. This was already true for ZIP input; the PR extends it to directory input.
- **Minor:**
  - A compartment or entry missing from the map is reported by `load_archive_from_cas`, so the error message may be less clear.
  - The `--no-cas` help text mentions `--node-modules`; that wording should be checked.

No follow-up jobs were posted, and the garden repo was not changed.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1521-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (228117 cached reads)
- Output: 1581 tokens
- Cost: $0.4231794
- Wall-clock: 43s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
