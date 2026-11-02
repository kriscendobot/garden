## Completion report: `endopi-jsonl-transcript-format-build`

**Outcome: no PR opened, because this job was a stale re-mint.** The plan record still said `Proposed`, but the JSONL format library is already on `llm`, merged on 2026-07-29 as #669. The remaining design work needs a maintainer decision first, so I built nothing new.

**Evidence**
- **Format library:** `packages/jsonl-transcript` has the entry types, writer, reader, graph projection, path helpers and `docs/session-format.md`. Its 27 tests pass on current `llm` (48d6f3e08).
- **Not wired in:** no other package imports `@endo/jsonl-transcript`, so nothing writes session files.
- **CLI (phase 3):** `endo session list` and `endo session show` don't exist.
- **Compaction (phase 4):** this still waits on `endopi-iterative-compaction`, which is `Proposed (partially satisfied)`.

**Why I didn't build the wiring or CLI**
- **The design is out of date:** it assumes a Lal reply-chain graph and a guest-side writer under `$ENDO_STATE`. Lal now runs on a `PiAgent` with a linear in-memory message list and no cross-restart continuity.
- **A maintainer question is open:** kriskowal's review on #669 asked how Chat, Familiar and Gateway integrate, and assumed a surfaced capability. I found no recorded answer, and writing to a state path directly could go against that assumption.
- **The CLI alone would be empty:** there are no session files for it to show until the writer is wired in.

**What changed**
- **Plan record:** `plan/designs/endo-but-for-bots/endopi-jsonl-transcript-format.md` on `journal2` is now `In Progress`, with a note saying what is done, what is blocked, and not to mint another build. I left out `pr:` on purpose, because `reconcile.sh` would flip the record to Complete on the merged #669.
- **Project and garden code:** no commits.
- **Maintainer message:** sent and delivered through `message-user.sh`, with the two decisions below. I didn't wait for a reply; a late one is dead-lettered and promoted to a fresh job.

**Follow-ups for the maintainer (none posted or acted on)**
1. **Session persistence:** decide how agents get it. I recommend a design revision that settles the capability surface, followed by a build for the wiring and the CLI.
2. **Duplicate draft #692:** it implements the same format in `@endo/conversation-tree`, is unreviewed and hasn't changed since July. I recommend closing it as superseded, but left it open.

**Other things I noticed**
- **Stale design docs:** the design's own header on `llm` still says `Proposed`, and `designs/README.md` says `In Progress`. Open draft #1024 proposes `Implemented`, but it hasn't changed since August.
- **Sibling records:** `endopi-edit-tool` also still reads `Proposed` in the plan even though #668 merged, so `endopi-edit-tool-build` may be the same kind of re-mint. I didn't check it further.
- **Fleet tooling:** `ensure-project-worktree.sh` reports repo-lock timeouts as "could not verify whether … exists", which looks like a missing branch. Its `ls-remote` probe gives up after the default 10s `GARDEN_REPO_LOCK_WAIT` while peers hold the bare-repo lock. It needed `GARDEN_REPO_LOCK_WAIT=300` to get through, and setup took about 16 minutes.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endopi-jsonl-transcript-format-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1531083 cached reads)
- Output: 16971 tokens
- Cost: $1.4768366
- Wall-clock: 2217s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
