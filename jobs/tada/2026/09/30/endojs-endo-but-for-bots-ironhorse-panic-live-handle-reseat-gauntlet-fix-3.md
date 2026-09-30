## Gauntlet fix round 3: endojs/endo-but-for-bots PR #1380

I pushed the last open panel-3 must-fix items to the PR, and CI came back green on the new head: `ci-wait-merge` returned rc 0 with 35 of 35 checks passing and 0 failed.

**Already done before I started.** An earlier claimant of this job had pushed `eab58aaef8` after the panel-3 review. It covered these findings:
- **Missing heap hash:** `attach` no longer skips the heap-identity check when the resumed-heap hash is missing (wire-watcher, saboteur, breaker).
- **Handles after a failed attach:** when `attach` fails partway, it now drops the native handles it had re-seated (assessor #1).
- **SQLite writes:** a statement that writes through `sqliteStmtGet`/`sqliteStmtAll` is now refused (breaker).
- **Supervisor ordering:** `Supervisor::retire` records the outcome before unregistering the worker (assessor #4).
- **Stylist renames:** `CasStore` became `Cas`, and the `dir`/`endo_dir`/`msg` names were spelled out.
- **Spelling:** "acknowledgement" was changed to the American spelling (orthographer).
- **PR body:** it is now 320 words, and its ledger says `Disposition: non-deliverable-probe` with acceptance deferred. That answers the blocking phase/evidence gate and the integrator's must-fix.

**What I added.** Commit `343d0143d5` (`fix(xsnap): give each delivery its own crank and refuse unrecordable ones`) covers the findings that were still open:
- **One crank per delivery** (assessor #2, breaker #3, engine-realist #1): envelopes that arrive while the reactive pump is running now close the current crank before they are dispatched. Each delivery's inbound bytes are therefore recorded in the same crank as the host calls it caused. Before this, a second envelope's calls were logged under the first envelope.
- **Refused cranks** (assessor #3): `begin_delivery` now returns a `Result` instead of logging a refusal (for example backpressure) and carrying on. `dispatch_envelope` drops a delivery the transcript refuses to record rather than running it unrecorded, and `host_ledger::call` passes the refusal back to the guest.

**Local testing.** The xsnap host-ledger tests all pass: transcript, reseat, suspend, host_ledger, recovery, barrier and sqlite. The full `xsnap --lib` run segfaulted in `archive_text_endowments_provide_codecs`. That is probably because I copied generated JS bundles from another worktree rather than building them; CI, which builds them, is green.

**Follow-ups (should-fix, not done this round):**
- Two independent code paths write heap blobs to the content-addressed store; they should share one implementation.
- `pub mod host_ledger` exposes more of the xsnap crate's surface than it needs to.
- Hasher descriptors make the transcript grow quadratically.
- Reader and writer handles re-seat without checking the file is the same one (only a writer's length is compared).
- A missing SQLite file re-seats as a new, empty database.
- The worker id in `transcript_path` is not validated before it is joined into a path.
- The branch still needs a linear restack onto #1379.
- There is no test that a refused delivery is actually dropped.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 210 tokens (10875618 cached reads)
- Output: 44421 tokens
- Cost: $4.8161436
- Wall-clock: 8246s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
