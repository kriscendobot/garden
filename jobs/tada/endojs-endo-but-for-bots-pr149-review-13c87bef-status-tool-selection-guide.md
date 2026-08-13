Disposition: **2. partially honored**.

Fresh refs:

- [`origin/llm` at `a54c3adbebf18fd837770d467433e480de498e8d`](https://github.com/endojs/endo-but-for-bots/commit/a54c3adbebf18fd837770d467433e480de498e8d)
- [PR 149 head at `e0c8accb3235a340ce2b4e4307138429a7d1e5f3`](https://github.com/endojs/endo-but-for-bots/commit/e0c8accb3235a340ce2b4e4307138429a7d1e5f3)

Current `origin/llm` already builds its system-prompt Tools section from the registered `toolList` and obtains that list from the actual tool registry: [prompt builder](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/src/system/index.js#L243-L249), [registry projection](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/src/tools/registry.js#L248-L252). Its tool help already carries small-model disambiguation, including `readFile` versus `listDirectory`: [read guidance](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/src/tools/filesystem.js#L83-L99), [directory guidance](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/src/tools/filesystem.js#L438-L459).

The remaining gap is strict availability-aware guidance. Current `origin/llm` has no compact task-first Tool Selection Guide, and individual summaries can recommend an unavailable alternative. A live probe with `include: ['webFetch']` produced registered names `["webFetch"]`, still mentioned `webSearch`, and contained no Tool Selection Guide. The PR implementation supplies the compact section, but its first gate checks `listDirectory || readFile` while always recommending `listDirectory`, so it can also advertise an unregistered tool: [PR implementation](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/src/system/index.js#L226-L256).

Follow-up: generate each task-first row only when its recommended tool is registered, suppress unavailable cross-references in summaries, and test reduced registries such as `readFile`-only and `webFetch`-only. Do not cherry-pick the PR implementation unchanged.

All three journal discovery reports were read from freshly fetched `origin/journal2`. The Genie-core report did not enumerate this feature, the sandbox report explicitly excluded it from that extraction, and the deployment-prompts report correctly identified it as F17. Existing history is already retained in [`TADA/genie/35_genie_use_dev_repl.md`](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/TADA/genie/35_genie_use_dev_repl.md#L59-L61) and [`TADA/genie/62_genie_small_model_tools.md`](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/TADA/genie/62_genie_small_model_tools.md#L47-L68). The latter's claim that the compact guide exists is stale against current source. No related TODO or PLAN needs migration to the garden journal.

Changes: none. Both worktrees remained clean; nothing was committed, pushed, or posted to GitHub.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr149-review-13c87bef-status-tool-selection-guide.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 361s

<!-- garden-usage-end -->
