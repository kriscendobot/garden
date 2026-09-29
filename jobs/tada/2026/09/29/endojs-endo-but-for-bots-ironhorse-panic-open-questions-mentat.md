Opened draft [PR #1370](https://github.com/endojs/endo-but-for-bots/pull/1370) against `llm`, commit `8936e8acbf`. Posted the [numbered answers on #1018](https://github.com/endojs/endo-but-for-bots/pull/1018#issuecomment-5886418488).

1. **Decode/StepLimit:** retain panic membership; preserve structured reasons and operation provenance.
2. **MeterAbort:** terminate; refill gates admission, not interrupted execution.
3. **Backend:** XS/CAS first, with durable watermark publication and directory sync; ATTACH is not mandatory.
4. **Integration:** filed concrete host-power, SES, and delivery-protocol dependencies in the engine design.
5. **Throw:** normal CapTP rejections commit and continue; genuinely escaped delivery throws discard and terminate.
6. **Transcript I/O:** supervisor-owned `TranscriptFault`; isolate failure, withhold release, reconcile before retry.
7. **fsync:** retain FULL durability; account separately for admission, host calls, release, and snapshots. Maintainer rollout throughput/p99 targets remain open.
8. **PanicKind:** adopt payload-preserving nesting of all panic variants before production outcome consumption.

Scope-split #989’s quiescence/parity work and #1016’s rejection-reporting work from durable recovery and the Coda.

Validation: diagrams, relative links, and diff checks passed. Documentation build passed with 0 errors and 145 warnings after increasing Node’s heap. Runtime implementation remains with the follow-up legs.

Self-improvement: reported the stale-base PR-gate issue through the [self-improvement workflow](/home/kris/garden/skills/self-improvement/SKILL.md).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-open-questions-mentat.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 667s

<!-- garden-usage-end -->
