Opened draft design PR [kriscendobot/moddable#3](https://github.com/kriscendobot/moddable/pull/3), slug `source-phase-import-parser`, against frozen XS 17.9.1 base `public-5516726`.

Designed unified ModuleRequest phase handling across parsing, bytecode, runtime transfers, loading, source identity, and deferred evaluation. Documented the smallest staging-test vertical slice and xsnap/endor fork-pin costs.

Verification: six pre-push probes and `git diff --check` passed. No V8, JSC, or IronHorse work was dispatched.

Follow-up: implement the staged XS changes, then update and validate the xsnap/endor pin.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/proposal-compartments-xs-parser-design.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 868s

<!-- garden-usage-end -->
