---
ts: 2026-05-22T22:11:50Z
kind: result
role: fixer
host: endolinbot
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
to: general-contractor
refs:
  - entries/2026/05/22/220800Z-dispatch-general-contractor-195ead.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 134
    role: target
---

# Fixer on PR #134: no code push; review items resolved via deferral path

PR #134 (`feat(docker,daemon): docker self-hosting`, base `llm`, head `feat/docker-selfhost@b25a2dc41`) is `isDraft: true`, `reviewDecision: CHANGES_REQUESTED`. HEAD already addresses every actionable review item; the remaining maintainer ask is "wait for upstream Endo Gateway work," which the fixer cannot satisfy with a commit on this PR.

## Inline comment inventory

`GET /repos/endojs/endo-but-for-bots/pulls/134/comments` returns `[]`. There are no inline review-comment threads to address or resolve.

## Review-body inventory and per-item resolution

Two `CHANGES_REQUESTED` reviews from @kriskowal, both review-body only:

1. **2026-05-08T01:21:04Z** (id 4248762221): "Please add a CI test that validates the Docker deployment of a daemon and exercises it from outside the container."
   - **Already addressed** before this dispatch. Commit `bdda0d8e7e` (per the PR body's "Forwarded conversation") added `.github/workflows/docker.yml`: validates `docker-compose.yml`, builds the image, smoke-tests with `ENDO_GATEWAY_REMOTE=1` + HTTP `/` body assertion. Strengthened by `5e052f7d3f` (HTTP `/` + WS-101 upgrade probe + `docker inspect` liveness) and current HEAD `b25a2dc41` ("ci(docker): make docker-deploy job pass and exercise daemon end-to-end"). Verified outcome.

2. **2026-05-13T20:32:41Z** (id 4285132459): "Please return this to draft. We need to make progress on the Endo Gateway concept before we can sensibly run under Docker. The Gateway subsumes the ws-gateway.js here with the Weblet virtual host and will require its own entrypoint."
   - **Out-of-scope per dispatch instruction.** This is a re-design ask the fixer cannot land in-place on PR #134; doing so would re-design daemon's ws-gateway around an Endo Gateway implementation that does not yet exist. Status of the deferral path:
     - PR `isDraft: true` (return-to-draft honored).
     - Issue #173 ("Endo Gateway: system-service HTTP virtual host for OCapN, separate from per-user Daemon") filed 2026-05-10, closed 2026-05-12 by the design PR.
     - Design PR #199 (`design(daemon): endo-gateway system-service HTTP virtual host (closes #173)`) merged 2026-05-12T00:21:00Z (`reviewDecision: APPROVED`).
     - Roadmap PR #236 (`chore(designs): raise Endo Gateway to milestone 1 per #134#issuecomment-4444987124`) merged 2026-05-21T11:59:12Z; merge-commit body annotates "unblocks PR #134".
     - The Gateway *implementation* PR (whatever it is named) has not landed; until it does, the ws-gateway.js code in this PR remains the surface kriskowal asked to defer.
   - **Cross-PR coordination surfaced** (no fixer action): the next stage is a builder dispatched against `designs/endo-gateway.md`, then PR #134 either rebases on top of that work or is closed and superseded. Neither is the fixer's lane.

No commits authored this dispatch. No top-level summary comment posted; the dispatch prompt did not authorize a new PR comment and there are no inline threads to reply on.

## CI on `b25a2dc41`

`gh pr checks 134`: 27 pass, 2 fail.

- `lint`: fail (TS2322 in `packages/daemon/test/ws-gateway-static.test.js:77,151,186`; typedoc API-docs converter rejects the test's `gateway` fixture against `EndoBootstrap | FarRef<EndoBootstrap>`). Real regression introduced by this PR's static-file-serving tests; not a flake. **Not fixed in this dispatch:** pushing a fix to a "paused, wait for Gateway" PR contradicts the standing maintainer instruction, and the test file in question is precisely the ws-gateway code the Gateway redesign subsumes. The right time to fix the type signature is when the PR rebases atop the landed Gateway implementation (or never, if PR #134 is superseded).
- `test (22.x, macos-15)`: fail (CapTP "No unclaimed invitation exists" / "Channel member 'Bob' has been disabled" noise). Pre-existing macos-15-only flake; the same matrix on ubuntu and the 18/20/24 macos slots all pass.

## Outcome

`verified, deferred per reviewer-authorized path` for both reviews. No SHA to cite, no thread to reply on, no comment authorized. The PR remains DRAFT with `CHANGES_REQUESTED` pending the upstream Gateway implementation; the orchestrator's next cycle should treat #134 as parked on the design-dependency, not re-dispatch a fixer.

Recommendation to the contractor: do **not** chain a justice / barrister / appellate behind this fixer. The PR is parked, not advancing; the next legitimate stage is whichever role implements `designs/endo-gateway.md`, after which #134 is rebased or superseded.

Self-improvement: when a `CHANGES_REQUESTED` review's substantive ask is "stop and wait for upstream design X," the fixer's correct artifact is the journal result documenting the deferral path's status (issue filed? design merged? milestone raised? implementation pending?); no commit, no comment. The pattern is already a fixer norm ("surface but do not act" + "verified, no change needed is a first-class outcome"); a one-line mention in `roles/fixer/AGENT.md` § Operating norms naming "stop-and-wait re-design asks" alongside the existing skip-with-reason and verified-no-change cases would shorten the next fixer's deliberation. Promoted to a `message: fixer → liaison` if the pattern recurs.
