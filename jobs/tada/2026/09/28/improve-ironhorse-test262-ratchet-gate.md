The gate is built and pushed to main2 as `0f692b171eb`. Its 18-case fixture test passes.

The new command is `scripts/jobs/ironhorse-test262-ratchet-gate.sh`. It runs no model and makes no network calls, and anything it can't read or verify comes back as `error` or `incompatible`, never `pass`.

- **`pin`** freezes a floor, from a sweep's `report.json` or from an in-tree `baseline/refresh-<date>/` directory. It writes `pin.json` plus a byte-sorted `covered.txt`, and records everything a later sweep must match to be comparable:
  - the test262 and oracle pins, runner, modes and scope;
  - every run parameter except the engine commit (so `case-timeout` and the batch cap count);
  - the category names in use and the total case count;
  - a classifier fingerprint: the git hashes of the runner's verdict sources (`full-run.sh`, `endot_ih.rs`, `report.rs`, `xst.rs`) at the measured engine commit.
- **Deliberate floor moves:** `--supersedes <old-pin> --note "<decision>"` records every old covered path the new floor drops, with its new category and reason, so the historical losses stay on record.
- **`check`** compares a sweep against a pin and prints one JSON record:
  - `pass` (exit 0): comparable, and no pinned path lost; with `--require-growth`, at least one path gained.
  - `fail` (exit 1): comparable, but a pinned path was lost, or nothing grew.
  - `incompatible` (exit 2): the classifier or run setup differs. The path diff is attached as information only.
  - `error` (exit 3): an input is missing, unreadable, tampered with, or inconsistent.

  The record lists every lost path with its new category and reason, and totals by category and by reason. `--record` also writes it to a file.

**Results on the real round-3 data:**
- **Old floor vs today's `llm` (`47f6965d88`):** comparing `refresh-20260904` to the branch-point sweep gives `incompatible` for three reasons: the new `case-timeout=60` run parameter, the new `refused` category, and changes to all four classifier sources. The 906 lost paths appear only as information: 443 `ironhorse-aborted-limit`, 397 `shared-positive-test-failure`, 66 others.
- **Branch-point pin vs round-3 head (`9df05366b3`):** the round-3 head passes against a pin made from the branch-point sweep, with 74 paths gained and none lost.

**Also changed:**
- New operator page `context/operations/ironhorse-test262-ratchet-gate.md`, linked from `context/operations/README.md`.
- The test is `scripts/jobs/test/ironhorse-test262-ratchet-gate-test.sh`. I added it to `.github/workflows/checks.yml` for shellcheck and the focused test run.
- `scripts/checks/run-all.sh` fails on the maintainer-inbox gate. The leaks it flags are in `roles/botanist` and `skills/foreign-content-preclassification`, already committed and not from these changes. I stopped `tests/checks/run.sh` after about 13 minutes without a result.

**Follow-ups:**
- **Which pin to enforce is the maintainer's call.** The gate only reports whether a sweep is comparable. The round-3 job asked the maintainer whether the 36,599 branch-point floor may replace the historical one, and that question is still open. Once they decide, `pin --supersedes` records it.
- **Classifier edits:** any crank PR that edits a verdict source will come back `incompatible` and needs a maintainer re-pin. This is deliberate, but the autopilot will halt on such PRs rather than merge them.
- **Autopilot coordination:** I sent the interface and the landed commit to `build-ironhorse-ratchet-autopilot` over the bus. Its watcher should act only on `verdict == "pass"`.
- **Stray job:** my copy to `ironhorse-test262-ratchet-round3-20260928` was dead-lettered because that job had already finished. The system will turn it into a new job, which can be closed as an informational no-op.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-ironhorse-test262-ratchet-gate.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (3466967 cached reads)
- Output: 36393 tokens
- Cost: $2.3868053999999996
- Wall-clock: 1208s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
