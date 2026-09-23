Empty inbox. Job complete.

## Completion report

**Job:** `improve-journal-outage-classification` — harden journal-fetch outage classification so recurring ambiguous transport failures return the shared temporary-unavailable status and open one host cooldown, preserve loud handling for local-clone/auth/upstream failures, and add regression coverage for the observed rc=1 fetch-failure shape.

**Finding:** The substantive implementation had already landed on `main2` before this job was claimed (19:21Z), in two commits earlier the same day:
- `fab63b7af6` — latched journal-read outages into a host-shared cooldown (`cursor-get.sh` + `common.sh` helpers).
- `beb9fc3ede` — classified the ambiguous rc=1 fetch-failure shape into that cooldown, bounded away from auth/upstream/corrupt/local-state faults.

I verified the classifier (`scripts/jobs/cursor-get.sh:60-84`) and its `scripts/jobs/test/cursor-outage-cooldown-test.sh` (33 passing assertions): a live latch short-circuits without a fetch (herd suppression), a bare rc=1 with the bounded-retry line becomes one warned temporary-unavailable episode, and auth + local-clone failures stay loud and never latch.

**Gap closed:** The job explicitly names **upstream** among the three loud-handling cases to preserve, but the test only exercised the auth and local-clone loud paths — the `_fetch_stderr_is_upstream_gone` exclusion (`cursor-get.sh:64`) was unverified. I added subtest (i): an rc=1 fetch whose diagnostic carries the *same* bounded-retry wrapper as an ambiguous outage but reports "Repository not found" must stay loud (rc=1), preserve its diagnostic, and never latch the cooldown. I confirmed the injected-fetch path emits the bounded-retry line (`common.sh:4010`), so the case genuinely reaches the ambiguous branch and is held loud *only* by the upstream-gone guard — a real guard, not a vacuous pass.

**Changed:** `scripts/jobs/test/cursor-outage-cooldown-test.sh` (+22 lines, subtest i). Test now 36/36 pass. Committed `347f8b5ad5`, pushed to `main2`.

**Follow-ups:** None. Coverage for all three named loud paths (local clone, auth, upstream) and the ambiguous/herd path is now present.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-journal-outage-classification.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (779242 cached reads)
- Output: 9656 tokens
- Cost: $1.177816
- Wall-clock: 147s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
