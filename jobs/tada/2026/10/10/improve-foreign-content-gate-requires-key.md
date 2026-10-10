# Completion report: improve-foreign-content-gate-requires-key

The classifier now has an opt-in strict mode, and every `scholar-ingest-*` job runs in it. A worker without the TypeSafe key no longer claims those jobs. If the classifier can't run during an ingest anyway, the job stops and requeues instead of reading sources unclassified. Pushed to `main2` as `592f66b2a04`.

**What changed**
- **`classify-foreign-content.sh`:** with `CLASSIFY_REQUIRE=1`, every "classifier unavailable" case now reports `classify_policy=halt_unclassified` and exits **4** instead of 0. That covers a missing key, a failed API call and a malformed response. Exit 4 is separate from exit 3, which means the content itself was flagged. The default (fail-open) behaviour is unchanged.
- **`fetch-source.sh`:** honors the same flag. In strict mode with no key it refuses before fetching anything and exits 4. `check-source-children.sh` turns strict mode off for its own calls, because nothing an agent reads comes from those reachability checks.
- **Claim check (`common.sh`):** a new `typesafe` host capability, met when the worker's environment has `TYPESAFE_API_KEY`. It is checked fresh every time rather than cached, because the cache is host-wide and the key is per worker. `scholar-ingest-*` jobs require it automatically even with no `requires:` header, so claiming and the post-claim re-check both skip workers without the key. Any other job can opt in with `requires: typesafe`.
- **`gardener.sh`:** sets `CLASSIFY_REQUIRE=1` for the job runner of any job that requires `typesafe`.
- **`requirements-watch.sh`:** now counts the automatic requirement too, so a scholar ingest that no host can claim still alerts the maintainer.
- **Docs:** the scholar role brief and the foreign-content-preclassification skill now say what to do on exit 4: don't ingest, and end without the completion signal so the job requeues. The job-board skill lists the known capability tokens.

**Tests** (all passing): classifier 16/16 (3 new strict-mode cases), fetch-source 106/106 (new case 27), check-source-children 22/22, host-requirements 14/14 (8 new `typesafe` cases). The host-requirements suite had one existing failure: it looked for the blocked report at the old flat `tada/aws.md` path, and completed reports are now filed under dated folders. I fixed the lookup.

**Follow-ups**
- **Scholar ingest may stall:** if no host in the fleet has `TYPESAFE_API_KEY`, every `scholar-ingest-*` job will now sit in `todo/`. The requirements watcher alerts the maintainer after its wait window (900s by default). The cure is giving at least one host the key.
- **Repeated requeues possible:** on a host that has the key, a failing TypeSafe API makes the job requeue repeatedly rather than ingest. That's what the job asked for, but it can cycle while the API is down.
- **Gap in testing:** no end-to-end test checks that `gardener.sh` actually passes `CLASSIFY_REQUIRE=1` to the job runner. I checked that by reading the code only, not by running it.
- **Hazard in the host-requirements test:** it runs a real `gardener.sh` with worker id 1. On startup that cleanup killed 275 leftover processes in this worker's process group (`garden-monk@1`). That behaviour predates this change, but running the suite from inside a live worker can kill unrelated processes. It deserves its own fix.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-foreign-content-gate-requires-key.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (3829277 cached reads)
- Output: 22164 tokens
- Cost: $2.1449673999999996
- Wall-clock: 272s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
