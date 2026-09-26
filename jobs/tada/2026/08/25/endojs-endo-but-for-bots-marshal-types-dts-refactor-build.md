Opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1061 at commit `f5b159eb7`, based on frozen upstream `master-8c402ee`.

Converted marshal’s typedef-only module to `types.d.ts`, retained the empty runtime twin and existing module specifiers, updated TypeScript/ignore configuration, and added public API type tests. OCapN remains unchanged.

Marshal type checks, full SES/coverage matrices, lint, formatting, docs, packaging, runtime-contract checks, pre-push gates, and the automatic gauntlet passed. All GitHub CI checks are green across Node 22/24 on Linux and macOS. The long-path daemon test environment issue was independently rerun from a socket-safe path, passing all 119 tests.

The PR remains draft for the standard downstream panel and un-draft stage. No reusable garden changes were needed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-marshal-types-dts-refactor-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 2477s

<!-- garden-usage-end -->
