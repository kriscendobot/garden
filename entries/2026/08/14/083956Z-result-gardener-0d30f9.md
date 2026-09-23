---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-14T08:39:57Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
pr: 986
seat: locksmith
panel: gauntlet-panel-3
base: origin/llm
head: afd12fd51c

### locksmith (capability flow and attenuation)

**Verdict:** request-changes

**Findings:**

- `packages/lal/tools/fs.js:99` — `maxResults: M.and(M.gte(0), M.lte(Number.MAX_SAFE_INTEGER))` attenuates the wrong end. The daemon's cap is a **default**, not a ceiling: `packages/daemon/src/mount.js:852` reads `const { maxResults = GREP_MAX_RESULTS } = options` (`GREP_MAX_RESULTS = 1000`, `packages/platform/src/fs/search.js:87`), so any caller-supplied value *replaces* it. The guard therefore rejects the values that break the cap arithmetically (`NaN`, `+/-Infinity`, negatives) but admits every value that defeats it by being large. A model-emitted `grep(cap, pattern, maxResults: 1e9)` makes the daemon walk the whole mount and accumulate every matching line into one array in the shared daemon process, then ship it over CapTP. Verified empirically that the pattern admits `1e15` and `MAX_SAFE_INTEGER` (and correctly rejects bigint/string/bool/null, so the missing `M.number()` is not itself a hole). The tool's principal is LLM output, so the bound should be structural here: `M.lte(GREP_MAX_RESULTS)` (already exported from `@endo/platform/fs`) or an explicit documented tool ceiling. [proposed-rule: when an attenuator forwards a caller-supplied bound to a callee where that bound is a *default* rather than a ceiling, the attenuator must cap at the callee's default, not at the type's maximum.]

- `packages/lal/tools/fs.js:83` and `packages/lal/primer/tools.md:60-65` — the caps are invisible to the receiver. Both summaries mention `maxResults` but state neither default (grep 1000; glob 10000, `packages/daemon/src/mount.js:827`) nor that results are silently truncated with no marker. The daemon's own help text does state it ("default 1000", `packages/daemon/src/help-text-data.js:230`). An agent holding 1000 records cannot distinguish an exhaustive search from a truncated one and will report partial results as complete. Add the defaults to both summaries. [proposed-rule: a tool summary that exposes a capped surface must state the cap's default value so the model can tell truncation from exhaustion.]

**Notes (out of scope but worth flagging):**

- `grep`'s `pattern` reaches `new RegExp(regexSource)` (`packages/platform/src/fs/search.js:463`) and is applied line-by-line across the mount inside the daemon. This PR puts an LLM-authored regexp source on that path, and that model's input includes file content it just read. A catastrophic-backtracking pattern stalls the daemon's event loop for every guest, not just the calling agent. Not fixable by validation at the tool boundary; the durable fix is daemon-side (a step or time budget around the match loop). Recording so the follow-up exists. [proposed-rule: a regexp compiled from model output and run in a shared daemon needs a daemon-side execution budget, not only an input-shape guard.]

- Confinement itself is sound: `confinementRoot`, `deniedSegments`, and realpath cycle detection are enforced in the platform engine below the new tools, and `glob` is hard-capped at `GLOB_MAX_RESULTS` (not overridable). The tools reach only capabilities already in the guest's own name hub via `E(powers).lookup`, and `list` + `readText` already compose to the same read authority, so no new authority is granted. `harden({ maxResults })` and the `glorp(glob, pattern)` argument order both check out against `packages/daemon/src/types.d.ts:1367`.

- `packages/lal/primer/tools.md:58-59` adds an `editText` line. `editText` was already registered (`packages/lal/tools/fs.js:46`) with its summary already shipped to the model, so this grants no new authority, but it raises the discoverability of a **write** tool inside a PR whose changeset declares read-only search parity. Mention it in the changeset or drop it from this PR. [rule: skills/changeset-discipline/SKILL.md]

Self-improvement: the locksmith brief's "runtime-flag attenuation" heuristic did not name the case that mattered here, where an attenuator validates a bound's *shape* while the bound itself is a caller-controlled default rather than a ceiling. Worth adding to `roles/jurors/locksmith/AGENT.md` as a third recurring pattern: for any numeric bound the attenuator forwards, check the callee to see whether it is a default or a ceiling.
