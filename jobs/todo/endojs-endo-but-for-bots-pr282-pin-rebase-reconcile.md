---
tier: mentor
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-16T06:37:04Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Pin the merge base and rebase https://github.com/endojs/endo-but-for-bots/pull/282, reconciling the run-dispatch collision by keeping the registry path as the default.

Maintainer review 2026-08-16T06:28Z (CHANGES_REQUESTED) asked to "pin the merge base to llm-xxxxx and rebase". Maintainer decision 2026-08-16 (liaison session): proceed with the flag-gated option, NOT closure as superseded.

Context you must not rediscover the hard way. #282 is Phase 5 of designs/endor-run-expanded.md (entry-point run walking a LOCAL node_modules tree), stacked on #279 (Phase 4). Both are ~1151 commits behind llm. Meanwhile llm independently shipped the same `endor run <entry.js>` CLI surface by a deliberately OPPOSED design — designs/endor-npm-registry-proxy.md Phases 4/5, merged in #799 #800 #803 #805 #812 #818 #862 — as rust/endo/src/assemble.rs + cmd_run_entry, whose own doc comment states the whole point is that no node_modules tree is consulted.

The rebase conflicts are narrow: designs/README.md (trivial) and five hunks in rust/endo/src/bin/endor.rs. entry_walk.rs, run_input.rs, cas_archive.rs and lib.rs auto-merge because llm has no reference to entry_walk or run_input at all.

THE LOAD-BEARING HUNK is the `run` dispatch, where both sides claim the same input:
  llm:  is_entry_module(p)      -> cmd_run_entry(...)                  (registry path)
  #282: classify_run_input(p)   -> cmd_run_entry_point_with_cas(...)   (node_modules path)
Resolve it ADDITIVELY: llm's registry path stays the DEFAULT for .js/.mjs/.cjs, and #282's node_modules walker is reachable only behind an explicit flag (`endor run --node-modules <entry.js>`), with help text. Roughly 40 lines in endor.rs. Do NOT pick one branch of the dispatch: choosing llm's silently turns #282's ~2300 lines of entry_walk.rs into dead code, and choosing #282's silently deletes a shipped feature.

CI CANNOT CATCH A WRONG RESOLUTION HERE. entry_walk's 35 tests are self-contained lib tests that pass whichever way the dispatch goes, so a green board does not mean the merge was right. Add a test that exercises the dispatch itself: default entry goes to the registry path, --node-modules goes to the walker.

Also note #279 is still OPEN, unapproved and CONFLICTING, and #282 carries #279's commits via the stack merge, so landing #282 lands Phase 4 and Phase 5 together and empties #279. Say so in your report; do not close #279 yourself.

handler-timeout: 7200


<!-- garden-elapsed-constancy: 1 -->

<!-- garden-reaped: 3 -->
