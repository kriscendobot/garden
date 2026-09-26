Press tick complete for the npm-via-CAS registry-proxy arc.

**Assessment.** The arc's PR stack is #276 (Phase 2 fetch) → #772 (Phase 4 MVS resolver) → #782 (Phase 5 offline/.npmrc) → #785 (Phase 4 assembly) → #787 (Phase 4 XS execution, pressed last tick). #787 declared the finish line reached. No peer was live on any of these branches; inbox empty.

**Verification (real execution, not code-reading).** Built `endor` from the stack top in my isolated worktree (had to init the `c/moddable` submodule and recover the gitignored xsnap boot bundles from git history — the documented bundler script no longer exists on `llm`). Independently reproduced the finish line from a **cold CAS against the live registry**: `endor run main.js` fetched `is-odd@3.0.1`/`is-number@6.0.0`, printed tree hashes byte-identical to #772/#785/#787's runs, executed over XS, exit 0; `--offline` replay identical with zero network. Both crate suites passed (129 endo + 117 xsnap).

**Defects found and pressed (new draft PR #791, stacked on #787).** Running programs through the binary exposed two execution-hardening bugs:
1. **Any throw in the program being run segfaulted the runner** (exit 139) — a throw unwinding out of `machine.eval` into the host frame crashes XS. The entry-compartment and entry-import evals in `install_archive` now go through the inline try/catch `eval_wrapped`; a throwing entry now prints the ReferenceError and exits 1. (The declaration evals must stay unwrapped — function declarations inside `try` don't hoist to global in XS.)
2. **`console` was not endowed**, so the single most common npm entry idiom, `console.log`, hit bug 1 and crashed. The archive runner now endows a `console` whose log/info/debug/trace write formatted output to real stdout via a new `stdoutLine` host function (appended snapshot-safely to the callback table); warn/error go to stderr.

Evidence in the PR: 131/131 endo + 118/118 xsnap tests (3 new), the previously-segfaulting `console.log` demo now running cold-fetch-then-offline with program output cleanly on stdout, and the throwing case failing cleanly.

**Follow-ups.** Next unblocked increment for a future tick: conditional/subpath `exports` maps (top recorded design gap). Separately, I messaged the live `xs2rust-endor-build-stage2` peer that the xsnap boot-bundle generators are broken/missing on `llm` (bundles only recoverable from git history; README stale) — that's their arc to fix. The registry-capability edge (#671/#403) remains under the byte-array arc; nothing here duplicated it.
