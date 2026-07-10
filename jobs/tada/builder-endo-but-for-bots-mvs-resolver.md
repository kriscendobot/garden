Project worktree torn down; my garden worktree is torn down by the harness on completion. Here is my report.

---

## Completion report: `builder-endo-but-for-bots-mvs-resolver`

**Outcome: impasse surfaced to the maintainer — no PR opened, no code written.** Opening a PR would have been the wrong move; the requested algorithm already exists in two open PRs, and the job's own premise is undercut by an unresolved architectural split.

### What I did
Ran the builder's duplicate/impasse pre-flight against `endojs/endo-but-for-bots` before touching code, reading the `designs/mvs-resolver.md` design and the three PRs in play. Set up (and tore down) a project worktree on #671's branch to inspect the actual implementation and tests.

### What I found
- **#671** (OPEN draft, base `llm`, built today) already lands the *complete* mvs-resolver in `packages/daemon/src/registry.js` — npm semver subset, per-`(name,major)` MVS walk, workspace/peer/optional handling, deterministic `resolutionHash` — with `test/registry.test.js` covering the design's entire required test surface. This is a faithful implementation of the design, co-located in the daemon exactly as the design's "JS reference implementation shape" section prescribes. The design's own "Phased implementation" section says the algorithm "lands as Phase 1 … inside the JS reference implementation of registry-capability," and #659's accepted sequencing bundles registry + mvs into one daemon-side phase. So mvs-resolver was never a separately-buildable "layer 2 stacked on registry-capability."
- **#403** (OPEN, ready-for-review, base `llm-c85d618`) independently implements the *same* algorithm as a dedicated `packages/exo-npm/src/mvs-resolver.js` (+ snapshot-mapper, reference-backend, errors) inside a new `@endo/exo-npm` package — the "package boundary" placement.
- **#564** (CLOSED, the prior attempt this job cites) was closed *as superseded by #403*, with the explicit rationale that the resolver does **not** belong in `@endo/daemon`. #671 put it right back into `@endo/daemon`.

All three PRs are fleet-authored (kriscendobot / 0xpatrickbot): the fleet has collided with itself, and there is an unsettled `@endo/daemon` (#671) vs `@endo/exo-npm` (#403) placement disagreement. A fresh mvs-resolver stacked on #671 would be a **third** copy of the algorithm and would silently pick one side of that disagreement.

### What I sent
A decision request to the maintainer inbox (via `message-user.sh`) laying out the collision and asking: (1) which home wins — `@endo/exo-npm` #403 or `@endo/daemon/registry.js` #671 — so the loser is closed/superseded; (2) confirmation that if #671 is the intended home, this job is already satisfied by #671 and needs no separate PR. Their reply routes back and, since this job is completing, will be promoted to a fresh job rather than lost.

### One real gap I noticed (belongs *in #671*, not a new PR)
#671's `test/registry.test.js` "workspace … mismatch diagnosed" test uses a member version (`lib-b@1.0.0`) that actually satisfies `workspace:^`, so the mismatch-diagnostic code path in `registry.js` is not truly exercised. A one-line fixture fix (a member version outside the importer's range) would make that assertion load-bearing. Noted for whoever finishes #671.

### Follow-ups
- Maintainer decision on resolver placement (#403 vs #671), then close the loser.
- If #671 is chosen: harden its workspace-mismatch test (above); this job needs no PR.

**Self-improvement:** the encodable lesson is producer-side — before posting/claiming a "build layer N stacked on PR #M" job, read PR #M's body and the design's phasing: #671's body already announced it "lands the JS reference MVS resolver," and the design says the algorithm ships *inside* registry-capability Phase 1, so the "separate stacked layer" framing was contradicted at the source. I've carried the substance to the maintainer inbox; the liaison reading that note is the right channel to tighten job-posting pre-flight, rather than a role-file edit from here.
