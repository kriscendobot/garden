# Fix round 1: endojs/endo-but-for-bots#1380

I applied the panel's must-fix items as one follow-up commit, `936da2ecf2`, pushed with `safe-push-pr-head.sh` (`dcbd82cc16` → `936da2ecf2`). CI is green: 35/35 checks, and `ci-wait-merge.sh --no-merge` returned rc 0. The first run had one failure, `test (22.x, ubuntu-latest)`, in the `@endo/daemon` JS tests; the PR changes no JS, so I re-ran only that job and it passed. One must-fix item is only partly resolved (the replay claim, below) and needs a maintainer decision.

## Fixed

- **Filesystem mutations skipped the transcript** (breaker; wire-watcher should-fix). `writeFileText`, `appendFile`, `mkdir`, `remove`, `rename`, `symlink` and `link` were classified as barriers but never recorded. They now run through `host_ledger::call` via a new `mutate` helper in `powers/fs.rs`. Guest arguments are all read before the ledger call.
- **Writer re-seat destroyed data** (wire-watcher; saboteur, breaker and engine-realist should-fixes). Re-seating no longer cuts the file back with `set_len`. If the file's length is not the committed position, the writer is re-seated as broken and the file is left alone.
- **Private SQLite databases were reopened as empty** (breaker). An empty path, `:memory:` or any `file:` URI now gets no descriptor, so the handle is re-seated as broken.
- **Hasher descriptors grew quadratically** (saboteur; breaker and engine-realist). The hasher keeps its fed bytes natively and is redescribed once per crank at commit, through a new `Transcript::redescribe`. Cost is now linear in bytes fed.
- **A mid-pump suspend stranded promise jobs** (engine-realist). A host call made outside any delivery now opens its own crank, which the worker loop commits or aborts as usual.
- **Broken design reference** (archivist). "§ Backend selection and snapshot ordering (Q3)" now points to § Slot Machine per-worker write-ahead transcript. The CAS directory sync also calls `sync_dir`, which has a non-Unix branch (transplanter).
- **PR body and title** (template pre-pass, integrator, pruner). I rewrote the body under the seven template headings. It names this PR's own commits, drops the pass count, and states which parts are follow-up work. The title now says "…under it". The design doc says what the new behavior is.

## Tests

- **New:** `writer_reseat_refuses_a_file_of_another_length` and `private_and_uri_databases_are_not_reopenable`.
- **Extended:** the barrier test now also covers `writeFileText` and `mkdir`. The resume test no longer opens a delivery by hand, so it runs through the new outside-a-delivery crank.
- **Local results:** `cargo test -p xsnap --lib` passed 146. I skipped `archive_text_endowments_provide_codecs`, which crashes against the placeholder JS bundle generated locally. `slot-machine-transcript` passes and `cargo check -p endo --tests` is clean.

## Needs a maintainer decision

- **Replay claim (integrator must-fix 2):** only partly resolved. The design's two replay checks ("replay == live" and "a barrier halts replay") need a supervisor replay driver that doesn't exist yet. I narrowed the evidence section so it no longer claims them, but left the disposition as `deliverable`. Changing it to `non-deliverable-probe` would take the PR out of the gauntlet, so the maintainer should choose: accept the narrowed claim, relabel as a probe, or require the replay driver here.

## Deferred

- **Code from the lower PRs in the stack** (#1379 and the transcript and embargo commits): renaming `CasStore` and the other abbreviated names (stylist), and "acknowledgement" → "acknowledgment" (orthographer). These belong in those PRs' own rounds.
- **Should-fix and comment-only items not taken this round:**
  - checking which heap was resumed on attach;
  - the worker identity coming from the transcript's file stem;
  - SQLite transaction state across re-seat;
  - one shared encoding for request bytes;
  - rebasing the stack linearly to remove the merge commit.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 158 tokens (11058172 cached reads)
- Output: 43888 tokens
- Cost: $4.4992744
- Wall-clock: 7022s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
