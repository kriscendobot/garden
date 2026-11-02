Viability for #1637 is decided: `proceed`.

**PR state:** open, draft, not merged. Head is `e81150d610`, base is `xs-manager-test-rust-840215a`.

Deciding question: Does `llm` or any other open PR already run the daemon's tests under `endor`'s XS manager in CI, or has the need for that lane (guarding XS host powers such as `removeDirectory`) gone away?

Answer: no to both, so the PR is not superseded and its premise still holds.

Evidence:
- **Not superseded:**
  - `llm` at `48d6f3e08b` has no `test-daemon-rust` job or selector, and `ci.yml` there never mentions `test:rust` or `endor`.
  - A PR search for `test:rust` and `test-daemon-rust` returned nothing else that adds a lane. #1598 only makes `endo.test.js` pass under `test:rust` and doesn't touch CI.
  - #1637 was opened today and has no reviews or comments.
- **Need still holds:**
  - The XS `removeDirectory` is still in `packages/daemon/src/bus-manager-rust-xs-powers.js`, on both `llm` and the current head of #1538 (`f00001ed01`).
  - That head still carries the test `scratch-mount reclamation unlinks symlinks without following them` at `content-store-gc.test.js:256`.
  - The fix-4 report for #1538's gauntlet (2026-11-02) records that no CI job runs this suite, which is why the lane was requested in `ebfb-xs-daemon-start-without-fetch`.
- **Startup premise is settled:** the PR body says `llm` no longer fails daemon startup without `fetch`. I confirmed `manager.js:7181` registers `makeHttpContentDataPlane()` unconditionally, but relied on the body for the throw only happening when `fetch()` is called.

Risks for the gauntlet (none of these overtake the PR):
- **Stacked on an unmerged base:** #1598 is still open and draft at `840215a14`, 8 commits behind `llm`, and the PR body says the lane would be red without it. Its gauntlet halted at the clean stage on 2026-11-01, needs maintainer action, and its only red check is `test-ironhorse-oracle`. #1637 can't land until #1598 does or the fix is re-based.
- **CI on #1637's head:**
  - `test-daemon-rust` hadn't reported a conclusion when I checked.
  - `test-ironhorse-oracle` and `sandbox-drivers` are failing. Both match the known `ubuntu-26.04` runner breakage in my notes, but I didn't open these two logs, so that match is unconfirmed.

I spent no clean, panel, fix, CI-wait or un-draft budget and changed no code.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1637-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (295802 cached reads)
- Output: 4670 tokens
- Cost: $0.5860404
- Wall-clock: 111s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
