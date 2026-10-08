## Fix round 1 for endojs/endo-but-for-bots#1379: done, CI green

I applied the panel's must-fix items and pushed them to `llm-ironhorse-panic-host-call`. The head is now `4e8d7490303`, and all 35 checks pass.

**Changes for the must-fix items**
- **Decomplector (the transactional-write closure):** a transactional callback now returns plain data: a list of `(key, Option<value>)` entries, where a value means "put" and `None` means "delete". The crank's commit applies that list with the transcript's own statements to a new transcript-owned `host_store` table. Because the adapter never gets the database connection, I removed the SQLite authorizer and everything that existed only to support it. I also deleted the authorizer and shadowing tests that no longer apply, and rewrote the `put_row`/`applied` test helpers to use the new table.
- **Stylist (abbreviated names):** across the `slot-machine-transcript` crate and its tests, `seq` became `sequence`. The variants (`request_`, `reply_`, `last_`, `watermark_`, `receive_`) changed the same way. `pending_acks` became `pending_acknowledgments`, and `TEMPORARY_SEQ`/`VFS_SEQ` became `TEMPORARY_SEQUENCE`/`VFS_SEQUENCE`. SQL column names are unchanged, and I updated the one external user, `rust/endo/tests/ironhorse_embargo_coverage.rs`.
- **Packager (`fixup!` commits):** I folded all the `fixup!` commits into `fix(daemon): eliminate orphan pid test race`, which meant a history rewrite and a force-push.
- **Packager and integrator (unrelated daemon commit):** I left the daemon commit in this PR. The PR description now names it as a test-only change that can be split into its own PR on request.
- **Integrator (phase ledger):** the ledger now reads `Disposition: orchestrated-slice`, with `Successor: endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat`. Acceptance is now `partial`, and it says the live "replay == live" check is not covered here.

**Should-fix items I also did**
- The daemon teardown test now registers `t.teardown(() => launcher.kill('SIGTERM'))` right after `fork`, so a failed wait no longer leaks the launcher process.
- I deleted three docstrings that only restated their method names.
- In the PR description, I removed the Documentation Considerations section, shortened Upgrade Considerations, and updated the Security and Testing text for the new design.

**Commits on the PR head**
- `25f442f2da` fix(daemon), with its fixups squashed in
- `e716cd2b22` refactor(slot-machine): apply transactional effects as a declarative write set
- `4e8d749030` test(endo): follow the sequence rename in the embargo coverage test

**CI:** the first run was red because the `build-xsnap` job failed to compile. I had missed one `f.seq` inside a `format!` call in `ironhorse_embargo_coverage.rs`, and the third commit fixes it. That run also failed `test (22.x, ubuntu-latest)`, in `test/endo.test.js` in the daemon package, and cancelled `test-ironhorse-macos`. Both passed on the rerun, so they look like flakes. The rerun was fully green, with ci-wait-merge returning rc 0. Locally, `cargo test` passes for the `slot-machine-transcript` crate. I couldn't build `ironhorse_embargo_coverage` locally because xsnap needs a submodule, so CI is the only check of that file.

**Follow-ups**
- These should-fix items are still open for the next panel round:
  - the stylist's single-letter bindings (`t`, `r`, `err`)
  - splitting `Cargo.lock` into its own commit
  - the saboteur's report that restart re-seats escaped handles
  - replacing `HostOutcome.opens`, an `Option<Option<…>>` that encodes three states, with an enum
- The schema change adds a table but keeps version 2. That is fine because nothing is deployed.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1379-gauntlet-20261007-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (3245096 cached reads)
- Output: 17959 tokens
- Cost: $1.7425432
- Wall-clock: 4892s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
