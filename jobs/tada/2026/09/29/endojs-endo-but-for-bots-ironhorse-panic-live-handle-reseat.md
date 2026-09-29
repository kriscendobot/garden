The live xsnap worker now records its native handles in the host transcript, rebuilds them on resume, and can suspend with handles open. It's in draft PR https://github.com/endojs/endo-but-for-bots/pull/1380. But no daemon code turns this on yet, so live workers behave as before until the supervisor attaches a transcript.

**Stack:** branch `llm-ironhorse-panic-live-handle-reseat`, based on `llm-1706e63`. It is #1379 (the host-call transcript) with #1374 merged in. The merge had one conflict, in `ci.yml`, and I kept both sides' test filters. I left out #989 because it is a design document only, with no code this change needs. Only the last commit, `93e73e1caa`, is new work.

**What changed:**
- **Classification:** every callback in each `powers/*::CALLBACKS` list now has one of the five classes, and they all pass admission for a retryable worker. File and guest-SQLite writes are `barrier`; reads, handle opens and randomness are `read`; hashing, signing, path joining and module resolution are `pure`.
- **Routing:** a new `host-transcript` control message tells a worker to attach its transcript. After that, the file reader/writer, directory, SQLite database/statement and hasher callbacks go through `Transcript::host_call`. The guest holds a logical handle id.
- **Descriptors:** each handle's descriptor stores where the resource came from, its path, and its committed position. For a reader or writer that is the byte offset. A hasher records the bytes fed to it, up to 1 MiB; past that it has no descriptor and comes back broken.
- **Cranks:** each delivery is one crank. A delivery that runs out of meter or kills the worker aborts its crank.
- **Resume:** attaching calls `reseat_handles` before any delivery runs. A handle that can't be rebuilt, such as an in-memory database, is refused with "handle N was not re-seated" and the resource is never touched. Closing it records the loss, which lets recovery proceed again.
- **Suspend:** with a transcript attached, suspend is allowed with handles open; it commits the current delivery and records the snapshot in the transcript. Without a transcript it still refuses, as before.
- **Transcript crate:** two small additions. A call can now update its handle's descriptor when the crank commits, and closing a database also closes its statements.
- **Design doc:** I updated the paragraph in `designs/ironhorse-panic.md` that described the suspend refusal.

**Tests:**
- **Suspend and resume:** a live XS worker opens handles, suspends, and resumes in a fresh thread. Each handle picks up where it left off: the reader reads `efgh` after `abcd` and the writer appends. The in-memory database is refused, and closing it lets recovery proceed again.
- **Aborted delivery:** a file write in a delivery that aborts stops recovery for the next worker run.
- **Old refusal:** the existing suspend-refusal test is unchanged and passes.
- **Load-bearing:** when I made the reader restart at offset 0, the resume test failed.
- **Results:** `cargo test -p slot-machine-transcript` passes. `cargo test -p xsnap --lib` has 143 passing and 2 failing. Both failures need the generated JS bundles, which I replaced with empty files for this local build. `cargo check --locked -p endo --features ironhorse-engine --tests` is clean.
- **CI gap:** CI only compiles the xsnap crate, so these xsnap tests don't run there.

**Not done (listed in the PR body):**
- **Supervisor opt-in:** the supervisor still needs to send `host-transcript` when it starts or restores a worker.
- **Replay after restart:** host calls are recorded, but nothing replays deliveries through `HostReplay` yet.
- **Whole-file writes:** `writeFileText`, `appendFile`, `mkdir`, `remove`, `rename`, `symlink` and `link` are classified `barrier` but not routed. They read guest arguments inside their bodies, so those reads have to be moved out first.
- **Stack record:** I didn't write this stack into the journal's PR dependency registry (step 6 of the stacked-PR skill).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 158 tokens (12974358 cached reads)
- Output: 87029 tokens
- Cost: $6.121779600000002
- Wall-clock: 1165s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
