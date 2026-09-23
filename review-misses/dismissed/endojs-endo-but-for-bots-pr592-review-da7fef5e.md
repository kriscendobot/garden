---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr592-review-da7fef5e
verdict: not-a-miss
category: new-direction
pr: 592
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/592#pullrequestreview-4629031768
identity: endojs/endo-but-for-bots#592:review:4629031768:retro
producing_role: builder
producing_job: factor-watchdirectory-to-endo-platform
severity: minor
grounds: >
  kriskowal's CHANGES_REQUESTED review on PR #592 (garden-authored: the builder
  job factor-watchdirectory-to-endo-platform factored the watchDirectory
  primitive out of @endo/daemon into @endo/platform) carried two asks
  (paraphrased): (1) top-level body — there should be adequate tests covering
  watchDirectory under ALL platforms including test:xs and test:go; (2) an
  inline exploratory question on the Rust/XS powers stub — is it possible to
  flesh out this stub for a Rust filesystem watcher, does cap-std not surface
  that capacity. This retro judges whether the garden REVIEW PROCESS should have
  anticipated these and concludes it could not have, on four grounds drawn from
  the PR's actual history. (a) The PR is a PURE REFACTOR: it moved
  makeWatchDirectory verbatim and moved all 11 node unit tests with it (the
  build report and the extraction delta confirm byte-for-byte behavior), so the
  faithful-refactor contract "preserve existing coverage" was met; the ask is to
  EXPAND coverage to platforms the code never had, not to restore lost coverage.
  (b) The requested test:xs coverage NEVER EXISTED — the original #277 code
  lacked it too, and there is no XS ava supervisor harness in the repo (the
  fixer ebfb-592-watchdir-crossplatform-fixer confirmed a real test:xs script is
  a separate infra lift), so this is scope expansion / a requirement first stated
  in this comment, not a violated standing bar. (c) NO encoded review-process
  element demonstrably knew a cross-platform-supervisor-coverage convention and
  failed to bind: a grep across every juror seat brief and every skill for
  test:xs / test:go / cross-platform / platform parity returns nothing, and the
  one adjacent skill (node-parity-test) is Node-vs-SES linker parity, not the
  daemon's node/go/xs/rust supervisor matrix; the corner-prober's encoded lens
  is boundary cases within the tested code, not "add a whole new platform's test
  harness." (d) NO panel/gauntlet ran on #592 — the builder correctly left the
  PR DRAFT and explicitly flagged it "ready to run the gamut," and the maintainer
  reviewed the draft first; a maintainer's early direction on a draft that the
  gauntlet has not yet reached is normal steering, not a skipped-panel process
  miss. Ask (2) is exploratory design research ("is it possible ...", "does
  cap-std not surface ...") whose own framing signals a live open question, which
  the fixer then researched and answered on the thread (cap-std surfaces no
  capability-safe directory watch; keep the graceful-degradation stub; durable
  follow-up issue #606) — unanticipatable design discussion, i.e. new direction.
  Both asks are being addressed in the UNCHANGED primary loop (the fixer). This
  is maintainer direction raising the cross-platform test bar on a faithful
  refactor plus a live capability-research question — new direction, not a garden
  review-process miss. Recorded as a durable dismissal so the same review is
  never re-litigated. No cluster minted; no improvement dispatched. Guardrail
  observed: minting a daemon-cross-platform-coverage cluster off this single
  refactor PR — where the requirement was first stated in the comment and no
  prior convention bound — would be the one-PR-masquerading-as-systemic pitfall
  the skill warns against; if a SECOND garden-authored PR later draws the same
  "cover all platforms (test:xs/test:go)" ask on a daemon primitive, that would
  be the moment to record a miss and mint the cluster.
---

# Dismissal: endo-but-for-bots #592 review 4629031768 (retro)

kriskowal's CHANGES_REQUESTED review on the watchDirectory-into-@endo/platform
refactor asked for adequate tests covering watchDirectory under all platforms
(including test:xs and test:go) and, inline, whether the Rust/XS powers stub
could be fleshed out with a cap-std-based watcher. Not a garden review-process
miss: the PR is a faithful refactor that preserved all pre-existing node
coverage (all 11 unit tests moved with the code), the requested cross-platform
coverage never existed and needs supervisor-harness infra that does not yet
exist (scope expansion, first stated in this comment), no juror seat / skill /
standing instruction encodes a cross-platform-supervisor-coverage convention
(grep for test:xs / test:go / cross-platform / platform-parity is empty; the
adjacent node-parity-test skill is Node-vs-SES linker parity, not the daemon
supervisor matrix), and no panel ran because the builder correctly left the PR
DRAFT and flagged the gamut — the maintainer reviewed the draft first, which is
normal direction, not a skipped panel. The inline Rust/cap-std question is
exploratory capability research the fixer answered on the thread (keep the
graceful-degradation stub; follow-up issue #606). Maintainer direction raising
the test bar on a faithful refactor plus a live design question — new direction,
not a miss. See comment_url for the verbatim review.
