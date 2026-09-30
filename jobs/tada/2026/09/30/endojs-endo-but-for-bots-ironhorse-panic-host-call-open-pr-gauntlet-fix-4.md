# Gauntlet fix round 4: PR #1379 (endojs/endo-but-for-bots)

I applied the round-4 panel's must-fix and should-fix items and pushed them to `llm-ironhorse-panic-host-call` (42d86c65e6 → 588cd8f0bf). CI is green: 35 checks, 0 failed.

**Commits:**
- **1f6236befb** — The transcript's store and `xsnap::Machine::suspend_to_cas` both named temporary files `.snapshot.{pid}.{seq}.tmp` from separate counters, so two writers sharing a directory could collide. The transcript's temporaries now use a `.transcript-blob.` prefix. New `tests/cas.rs` covers:
  - a tampered blob is refused as `Corrupt`;
  - a 65-digit name is refused as `InvalidName`;
  - `reclaim` with an empty keep list, with every blob kept, with only orphan temporaries, and with a kept hash that is missing.
- **588cd8f0bf** — five changes:
  - **Reply size limit:** `max_host_bytes` is checked again after the adapter runs, counting the reply. The last or only call in a crank can no longer stage an unbounded reply.
  - **Escaped effects:** a misclassified `pure` call, or a call refused after its live effect ran, no longer drops the resource.
    - An opened resource is now written to disk as a broken handle, under a new `host-escape` event kind and new `Operation::HostEscape`.
    - A closed target is marked broken.
    - Both are recorded outside the crank, so `open_handles()` and `recovery_gate()` report them.
  - **Documentation:**
    - `FrameSink` and `receive_seq` now state that frames must arrive in order.
    - `classify` states that a later registration replaces an earlier one, with a test.
    - `CrankVerdict::Uncaught` no longer claims to terminate the worker.
  - **Uncaught throws:** instead of waiting on #1370, the code and PR body now cite the design's embargo table. That table discards an uncaught throw's output under either answer to the open question. Whether the worker survives is left to the supervisor and #1370.
  - **Renames:** `Seq`→`Sequence`, `tx`→`transaction`, `conn`→`connection`, `stmt`→`statement`, `st`→`state`, `pg`/`pgsz`→`page`/`page_size`.

Locally, crate tests, `cargo fmt` and clippy (all targets) were clean.

**PR body and comment:**
- The PR body is rewritten under the template's seven headings, with the phase and evidence ledger kept.
- I dropped the line listing test counts.
- The body now says `compact` still doesn't prune closed `host_handle` rows, as a deferral with a reason: handle ids come from `MAX(handle_id)`, so pruning could reuse an id. The earlier summary had wrongly said nothing was declined.
- I posted a comment mapping each panel item to its fix: https://github.com/endojs/endo-but-for-bots/pull/1379#issuecomment-5906010112

**Follow-ups:**
- #1370 (the design amendment on uncaught throws) is still an unreviewed draft. This PR no longer depends on it.
- The pruning of closed `host_handle` rows is deferred until handle ids have a separate high-water mark.
- The panel-5 stage re-reviews next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 98 tokens (4483674 cached reads)
- Output: 27223 tokens
- Cost: $2.3420108
- Wall-clock: 3813s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
