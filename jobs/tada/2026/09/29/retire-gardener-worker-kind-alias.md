---
handed-off: retire-gardener-worker-kind-alias-split
deliverable-complete: false
---
**Completion report: `retire-gardener-worker-kind-alias` (overrun split)**

The remaining work divides into two independent parts, so I split it into two child jobs. I did not implement any of the original work in this claim.

**What's already done:** most of the original job landed on `main2` three days ago in `02513cd130f` ("refactor(jobs): retire gardener worker kind"), which is an ancestor of HEAD. That commit:
- removed the `gardener` kind from `common.sh`;
- deleted `handlers/gardener-claude.sh`, `set-gardeners.sh` and `migrate-host-to-monk.sh`;
- dropped the dual projection in `reputation-reduce.sh`;
- added `garden-gardener@.service` to `install-units.sh`'s `RETIRED_UNITS`;
- removed the compat and cutover tests.

Neither `journal/hosts/*` file still has a `gardeners:` line, and this host has no `garden-gardener@N` units.

**What's left:**
- The legacy env alias `GARDEN_GARDENER_CLONE` is still read and exported in several scripts. `usage-append.sh`, `regenerate-topics-counts.sh`, `regenerate-sections-index.sh`, `library-slug-prefix-check.sh` and `library-link-check.sh` read only the legacy variable.
- About a dozen tests still set it, and several comments still name the deleted `gardener-claude.sh`.
- Nobody has checked `endolin-garden2-5bcdff64` directly for leftover units or markers.
- The design doc's status section and the operator docs haven't been updated.

**What I posted (on `origin/journal2`):**
- Two children parked in `plan/` with `gate=orchestrated`, owned by `retire-gardener-worker-kind-alias-split`:
  1. `retire-gardener-worker-kind-alias-env-fallback`: remove `GARDEN_GARDENER_CLONE` everywhere, switch readers to `GARDEN_WORKER_CLONE`, fix the stale comments, update the tests, then run the regression sweep.
  2. `retire-gardener-worker-kind-alias-verify-docs`: check the follower host directly for legacy units and markers, then update `designs/anthropic-worker-kind-monk.md` (status, and the decision on reading old `worker_kind: gardener` records) and the `CLAUDE.md` and `context/` docs.
- Orchestration record `jobs/orch/retire-gardener-worker-kind-alias-split.md`: serial, halts if a child fails. I didn't pass a description to `post-orchestration.sh`; the full context is in the child bodies.

No `main2` commits were made in this claim.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/retire-gardener-worker-kind-alias.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 10 on 2 host(s) (6 unmetered)
- Input: 18 tokens (505624 cached reads)
- Output: 6196 tokens
- Cost: $0.6832208 (6 engagement(s) unpriced)
- Wall-clock: 2905s
- Model(s): claude-opus-4-8 ×1, claude-opus-5-5 ×3

<!-- garden-usage-end -->
