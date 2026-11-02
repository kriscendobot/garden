I did not open a PR, because the job asks for an API the maintainer has already retired. Phase 1 no longer exists as work to build. The only change is a corrected plan record, so this job shouldn't get re-minted from it.

**Evidence** (`endojs/endo-but-for-bots`, `origin/llm` at `48d6f3e08`)
- **#287:** kriskowal closed it on 2026-05-20 with the comment "This has been coöpted by editMessage."
- **The design:** `designs/daemon-message-streaming.md` is now titled "Daemon Message Revisions" and marked **Complete**. It says the `streamReply` / `StreamWriter` / `StreamReader` proposal is retired, superseded by whole-message revision. Its Implementation Sketch now describes `editMessage`, `messageHistory` and `done`, so following it would not produce `streamReply`.
- **The replacement:** #125 merged on 2026-06-22 (`65b0abe27`). `editMessage` and `messageHistory` are in `packages/daemon/src/mail.js`, with coverage in `packages/daemon/test/endo.test.js`.
- **Leftover names:** the daemon has no `streamReply` or `StreamWriter`. The `StreamReader` matches under `packages/` are the separate userspace floot/chat streams and a Java class.
- **Prior attempts:** `ensure-pr.sh --find-only` found no PR from this job, so there is nothing to adopt.
- **Earlier no-op:** `build-daemon-message-streaming-phase-2` reached the same conclusion on 2026-10-19.

Building it anyway would reopen an approach the maintainer rejected, as a second protocol alongside the merged one.

**What changed**
- **Plan record:** `plan/designs/endo-but-for-bots/daemon-message-streaming.md` on `journal2` still said `In Progress` and pointed at #287, which is the likely source of this job. It now says `status: Complete` and `pr: #125`, with the Status section matching `llm` and a dated note saying not to re-mint `streamReply` work.
- **Maintainer decision:** earlier grooming passes left the record for the maintainer to choose between re-opening and retiring. I treated the #287 closing comment and the design on `llm` as that decision, and the edit is a single journal commit that's easy to revert.
- **Project repo and `main2`:** no changes, branches or commits.
- **Memory:** I added this case to the duplicate-build note: `In Progress` records can be stale too.

**Follow-ups**
- **Roadmap view:** `plan/README.md` still shows the old row until the next `render.sh` run; I didn't run it.
- **Validation error, not from this edit:** `plan/validate.sh` reports one error, status `Declined` in `daemon-docker-selfhost.md`, which isn't an allowed value. I left it alone as out of scope. The two warnings are unresolved `depends_on` slugs in other records.
- **Remaining streaming work:** the design's Known Gaps (revision log storage and persistence, a revision quota, payload type changes, a live `messageHistory`) are open design questions. They need a design job or a maintainer decision before any build.
- **Chat UI:** that part of the design belongs to the existing PR #305, not a new build.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/daemon-message-streaming-phase-one-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (709774 cached reads)
- Output: 7130 tokens
- Cost: $0.9408588000000001
- Wall-clock: 1095s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
