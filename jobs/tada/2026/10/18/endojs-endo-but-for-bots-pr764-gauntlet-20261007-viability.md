**Viability report: endojs/endo-but-for-bots PR #764**

PR facts: the PR is OPEN, not merged, and not a draft. It is mergeable. Head `02b806d2f4` is on `mirror/endo-2780-cache-globals` and the base is the frozen `master-2708cac`. It changes three files and adds 11 lines. It mirrors upstream endojs/endo#2780 ("wip Cache globals"), which caches `URL`, `Function`, `Promise`, `Proxy` and `Set` from `globalThis` when three `compartment-mapper` modules first load. That way, someone changing `globalThis` later can't swap them out.

Deciding question: Does upstream `endojs/endo` master still leave these intrinsics uncached in `import-hook.js`, `node-powers.js` and `parse-cjs-shared-export-wrapper.js`, with no newer change that replaces the work, and do those modules still use them?

Evidence:
- **Upstream PR:** endojs/endo#2780 is still an open draft, last updated 2025-05-05. Nothing has closed it or replaced it.
- **Still not cached:** upstream master is 96 commits past the frozen base. Its current versions of all three files still have no `globalThis` caching. The only destructured globals are `Reflect`/`Object` ones like `apply`, `keys` and `create`.
- **Still used:** those files still call `new URL(...)` (all three files), `Promise.resolve` and `Function.prototype` (`node-powers.js`), and `new Set()` and `new Proxy(...)` (`parse-cjs-shared-export-wrapper.js`). So caching them still does something.
- **No competing PR:** searching endo-but-for-bots for "cache globals" found no other PR. Searching endojs/endo found nothing that does this; #2988 is a hooks and type overhaul and didn't touch it.
- **Prior review:** a 2026-07-17 code panel approved the PR with no must-fix items and all 15 CI checks green.

Decision: proceed. Nothing has replaced the PR, and the reason for it still holds. I spent no clean, panel, fix, CI-wait or un-draft budget, and I changed nothing.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr764-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (177192 cached reads)
- Output: 1646 tokens
- Cost: $0.42908640000000003
- Wall-clock: 31s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
