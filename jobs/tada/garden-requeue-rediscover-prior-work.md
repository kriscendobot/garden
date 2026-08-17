Done. Committed as `33127fab91`, pushed to `main2`.

## Completion report

**Job:** Investigate and fix the cross-host requeue defect where a re-claimed job re-opened a duplicate PR (`endojs/endo-but-for-bots#999`/`#1000`).

**Key investigation finding (reframes the defect):** The garden *already* has a deterministic cross-host duplicate-PR converger — `scripts/jobs/gardening/ensure-pr.sh` adopts a prior claimant's PR by its `<!-- garden-job: <base> -->` body marker, surviving requeue, a different head branch, and total loss of local state. It didn't fire because that marker is written only by `ensure-pr.sh`, and a **bare `gh pr create`** (still a documented follow-up/stacked path, and how `#999` was opened) writes none. The reaper also deletes `work/<base>` on requeue (`reaper.sh:1001`), so the journal PR record doesn't survive across incarnations either. The real gap: PR creation isn't universally funneled through the existing rediscovery mechanism, so the rediscovery key is missing on the very PRs that need it.

**What I built (Stage 1 — contained, at the worker spine so every role inherits it):**
- `scripts/jobs/pr-job-marker.sh` — a self-contained library (mirroring `comment-provenance.sh`) that rewrites a `gh pr create` argv to inject `<!-- garden-job: $GARDEN_JOB_BASE -->`, byte-identical to `ensure-pr.sh`'s marker. Add-only: invisible HTML comment, never blocks, only `pr create`, fail-open on any doubt, idempotent.
- `scripts/jobs/bin/gh` — wired it into the one PATH chokepoint every fleet gh call crosses (where the identity pin and provenance footer already live), before the provenance step.
- `scripts/jobs/handlers/worker-common.sh` — the shared spine prompt now tells any PR-opening job to open only through `ensure-pr.sh`, naming the defect.
- `scripts/jobs/test/pr-job-marker-test.sh` — 14 cases, all passing (every body form marked once, source `--body-file` never mutated, idempotent, fail-open passthroughs, end-to-end through the real wrapper).
- `designs/requeue-rediscover-prior-work.md` — journal evidence, the analysis, and the **Stage 2** proposal (discover-and-adopt at create time, surfacing the existing PR rather than refusing silently) with its false-positive/cost tradeoffs left as a follow-up.

**Verification:** New test 14/14; existing `comment-provenance-test.sh` (28/28) and `gh-wrapper-fail-closed-test.sh` (49/49) still pass; `bash -n` clean. The one failing grep-gate suite (`maintainer-inbox-information-hiding`, flagging `roles/scholar/AGENT.md`) is **pre-existing** — a file I never touched.

**Follow-up:** Stage 2 (wrapper delegates to `ensure-pr.sh`'s discovery to *prevent* rather than merely make-discoverable a duplicate) is specified in the design doc but deliberately not built now — it carries real false-positive and exit-code-contract tradeoffs and is best done once Stage 1 has confirmed the marker is universally present.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-requeue-rediscover-prior-work.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 91 tokens (5351594 cached reads)
- Output: 48336 tokens
- Cost: $5.189852000000001
- Wall-clock: 742s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
