---
created: 2026-08-31
updated: 2026-08-31
author: designer
---

# Ironhorse fuzz triage and batch repair

| Field | Value |
| --- | --- |
| Status | Proposed |
| Scope | Garden producer, journal records, and Ironhorse repair-job shape |
| Replaces | Per-finding release in Sections 4 and 6 of the continuous fuzz design |

This design replaces the release and repair contracts in Sections 4 and 6 of
[continuous-ironhorse-fuzz.md](continuous-ironhorse-fuzz.md).

The Ironhorse campaign will capture findings first, triage them in bounded groups,
and open repair work only for clusters of probable port defects. Exact inputs,
oracle artifacts, and already-covered defect variants must not each buy a builder,
gauntlet, panel, and fixer loop.

## Evidence and available signals

The pause on 2026-08-31 found 73 quarantined repair jobs across three targets.
The durable state continued to change before this design was written: the journal
now has 100 finding markers and 74 quarantined repair jobs (67 policy refusals and
7 requeue-exhausted jobs), plus two old-shape repairs in `jobs/todo/`.
Migration must enumerate current state rather than embed either count.

Every existing marker has the same twelve fields: finding ID, target, project SHA,
toolchain, artifact SHA-256 and byte count, reproduction command, discovering host,
generation, repair basename, artifact path, and inert base64.
There is no stack, crash site, failure category, or root-cause signature to cluster
on today. The minimized inputs are small, but byte length and input hash do not
identify a cause. Completed repairs reveal recurring families that the current
schema misses, including XS result-buffer truncation, 32-bit oracle meter
truncation, and non-shortest `fx_dtoa` spelling of an otherwise identical double.

The new lane therefore has five states:

`captured -> triage-pending -> genuine -> clustered -> repaired`

Triage may instead terminate a finding as `artifact` or `duplicate`.
An inconclusive triage remains pending and cannot become repair work.

## Capture and durable triage records

Capture keeps the current identity
`sha256(target + NUL + minimized-input)[:16]` and the existing finding marker.
That is exact-input deduplication, not root-cause deduplication.
The producer continues to pass bytes only by file path, verify their SHA-256, and
keep base64 as inert journal data. It never puts artifact bytes in a shell word,
job body, or model prompt.

Triage writes a separate whole-file record at
`ironhorse-fuzz/triage/<finding-id>.md`; capture markers remain provenance records.
The record contains bounded fields rather than raw diagnostic output:

```yaml
schema: 1
finding_id: 493390fc03979205
status: artifact
target: differential_regexp_surface
failure_kind: result
failure_site: differential_check_with_symbols
semantic_relation: oracle-result-truncated
input_shape: regexp-source-long-result
root_signature: 9d60d2f9a881f405
canonical_finding: 493390fc03979205
evidence_sha256: <sha256-of-local-triage-log>
evidence_path: <durable-path>
classified_at_project_sha: <sha>
reason: xs-oracle-artifact
```

`status` is one of `pending`, `genuine`, `artifact`, or `duplicate`.
An artifact record needs a named reason and reproducible evidence. A duplicate
record needs `canonical_finding` and evidence that the canonical fix or the same
normalized failure covers it. Similar-looking bytes are not enough.

One triage job handles at most 12 oldest pending markers, grouped by target.
It verifies each artifact hash, reproduces by path at the recorded SHA, and reruns
the case at the current campaign head. A target-specific diagnostic adapter emits:

- `failure_kind`: completion, result, computrons, compile-decision, matched,
  capture, match-meter, panic, signal, or timeout;
- `failure_site`: the named differential check or first stable Ironhorse frame;
- `semantic_relation`: a bounded relation such as equal IEEE-754 bits,
  oracle-result-truncated, or meter-equal-modulo-32-bits; and
- `input_shape`: a safe harness-produced summary such as generator arm, regexp
  feature family, and size bucket. It is never the input text.

Known artifact relations are deterministic checks. For example, numeric result
spellings are equivalent only when both parse to the same IEEE-754 bits, and a
meter-wrap classification requires equality modulo `2^32` plus agreement with the
widened oracle. A new relation may be classified by the triager, but it does not
become an automatic suppression until a versioned deterministic matcher exists.

## Root signatures, suppression, and clustering

The diagnostic adapter computes
`root_signature = sha256(schema, target, failure_kind, failure_site,
semantic_relation)[:16]`. `input_shape` breaks ties when one broad signature has
more than one plausible cause; it does not override target or failure behavior.
This uses signals the triage run can actually produce instead of assuming today's
markers contain a stack.

Artifact dispositions also create versioned records under
`ironhorse-fuzz/suppressions/`. A suppression names its target, diagnostic schema,
semantic predicate, project/toolchain scope, canonical finding, and evidence.
On a future candidate the producer runs the diagnostic adapter before queueing
triage. A matching active suppression records the new input as terminal artifact
evidence and posts no job. The identical input is cheaper still: its existing
finding marker makes capture skip it. The campaign checkout advances to the latest
standing-branch head after every successful cluster, so fixed harness and oracle
classes normally stop reproducing at source rather than relying on suppression.

The batcher groups genuine findings by generation, target, and root signature.
A cluster contains at most eight findings and has one record at
`ironhorse-fuzz/clusters/<cluster-id>.md`. If a signature has more than eight
pending findings, the oldest eight form the cluster and the rest wait. After that
cluster lands, the overflow is re-triaged against the new standing head. Cases the
fix clears become duplicates of the cluster's canonical finding. Only cases that
still fail may form another cluster. This prevents a common root cause from
creating several repair jobs before its first fix is available.

## Repair job contract

There is one builder job per cluster, named
`ironhorse-fuzz-<target>-<cluster-id>-repair`. Only one cluster repair may be live
for a standing generation. Its body contains the cluster-record path, cluster
record SHA-256, target, project and standing-head SHAs, and each member's finding
path and artifact SHA-256. It contains no artifact bytes or diagnostic transcript.

The builder reproduces all members from files, identifies one causal change,
selects the smallest set of regression cases that distinguishes the behaviors,
and amends the one standing fuzz branch and pull request. One cluster receives one
gauntlet and panel. If some members survive the fix, the builder records them as
unresolved; the batcher returns those members to triage instead of silently
claiming the whole cluster fixed. Successful completion stamps every cleared
member with `resolved_by_cluster` and the fixing commit.

The standing PR lifecycle remains generation-based and uses `ensure-pr.sh` with
the generation marker. Batch repair changes the unit of work, not the one-PR
invariant. The fuzzer runner must test the current standing branch when it exists,
falling back to the roadmap base only before the generation has a branch. This
closes the observed loop where fixes accumulated on the standing branch while the
campaign kept fuzzing old `llm` and rediscovering the same classes.

## Backpressure

Before running any target, the producer counts nonterminal findings: triage-pending
findings plus genuine findings not resolved by a completed cluster.

- High water is 24 total or 8 for any one target. At either limit the tick skips
  every fuzz run. It may still release one triage or cluster job.
- Fuzzing resumes only below 12 total and below 4 for every target. The low-water
  threshold prevents one completion from making the timer flap on and off.
- At most one triage job and one cluster repair are live, and triage release pauses
  while a cluster repair is changing the standing head. Queue depth therefore
  grows only through bounded capture before the next high-water check.

These defaults are configuration values, but changing them requires tests that
preserve the high/low ordering and per-target cap. The service logs the counts and
the exact reason for every skipped tick.

## Migration of the legacy backlog

Migration runs while the timer remains paused and is one idempotent journal CAS
operation followed by normal bounded triage:

1. Enumerate every legacy `ironhorse-fuzz-????????????????-repair` in
   `jobs/plan/`, `jobs/todo/`, and `jobs/doin/`, and require a matching finding
   marker. Write `ironhorse-fuzz/migrations/triage-batch-v1.md` with the exact
   basename-to-finding mapping and source state.
2. Remove those old-shape jobs from claimable board states without deleting their
   finding markers. Record each as `superseded-by-triage-batch` in the migration
   manifest. A migration rerun must produce no additional records or jobs.
3. Mark `ironhorse-fuzz-repromote-quarantined` superseded. It must never promote
   the old files one by one. The policy-template rewrite remains useful framing,
   but its repromotion follow-up is replaced by this migration.
4. Seed triage records for all unresolved markers. Distill deterministic matchers
   for the three already-proven artifact families from completed repair evidence,
   then process the remainder in 12-finding triage jobs.
5. Release clusters under the eight-finding cap and the single-live-repair rule.
   Reconcile the manifest when every legacy member is artifact, duplicate, in a
   cluster, or explicitly still pending triage.

The migration command reports source counts, terminal dispositions, cluster
membership, and pending remainder. It fails closed on a missing marker, malformed
hash, or live old-shape job rather than losing ownership of a finding.

## Implementation and re-arming

The build updates the producer, runner, tests, and operator documentation. Its
acceptance suite must cover exact-input deduplication, all three seeded artifact
matchers, stable root signatures, the 12-item triage bound, the eight-item cluster
bound and overflow reconciliation, high/low-water hysteresis, migration
idempotency, one standing PR, and a probe that rejects job bodies containing input
bytes.

Landing this design does not re-arm the paused service. Re-arming requires all of:

1. land and deploy the implementation;
2. run the migration and reduce unresolved backlog below low water;
3. remove both `garden-ironhorse-fuzz.timer` and
   `garden-ironhorse-fuzz.service` from `EXCLUDED_UNITS` in
   [`install-units.sh`](../scripts/jobs/install-units.sh), then deploy that change;
   and
4. on the leader host run
   `systemctl --user enable --now garden-ironhorse-fuzz.timer` and confirm the
   first tick reports the triage-and-batch schema.

The two-part pause remains deliberate: repository exclusion prevents a deploy from
undoing the pause, and the host-local enable is the operator's explicit activation.

## Rejected alternatives

- Re-promote the quarantined jobs with safer wording. The wording fix addresses
  provider acceptance but retains one full engagement per input.
- Cluster only by target or minimized-input hash. Target alone is too broad; the
  hash recognizes only the exact input and already exists as the finding ID.
- Put crash output or bytes in the triage prompt to improve clustering. Structured
  adapters, durable paths, and hashes supply the needed evidence without creating a
  command or prompt injection surface.
- Hide the nature of the lane from the provider. Repair jobs describe ordinary JS
  engine correctness work plainly; batching reduces repeated work instead of
  disguising it.
