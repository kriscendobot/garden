CI is underway (24 checks kicked off, MERGEABLE, draft held). Inbox stayed empty at every checkpoint. Work is complete — writing the report.

# Press report — npm-via-CAS registry proxy (tick 2026-07-28, 06:51Z)

## Assessment

`llm` HEAD unchanged at `7f8c08d74f` (#862). All five design phases remain merged; the seven gap drafts from prior ticks (#857 peer/optional deps, #859 process shim, #860 npmrc auth, #873 workspace protocol, #875 imports field, #876 conditions/webcrypto, #877 dual-build execution) are all still OPEN, MERGEABLE/CLEAN, zero maintainer reviews. #877's CI finished fully green (24/24); a peer (ps23 gardener 5) holds the `fu-…-004711-1` follow-up job that confirms exactly that, so I left it to them and touched neither #877's branch nor its report. Nothing blocked on the registry-capability edge (#403/#671 stay with the byte-array arc).

## What I did — pressed the next recorded web-global gap: draft PR #878

Probed the finish line with **normalize-url@^8.0.0** (popular, zero-dependency, URL-heavy ESM): cold isolated state, real registry — fetch and assembly succeeded, execution died with `ReferenceError: get URL: undefined variable`. Fixed in **draft PR https://github.com/endojs/endo-but-for-bots/pull/878** (branch `feat/endor-npm-url-globals`, commit `4cff9d57f3`, base `llm`, kept draft):

- **WHATWG `URL`/`URLSearchParams` endowed to archive compartments** as a thin JS veneer (`url_globals.js`, WeakMap-backed state) over the host's spec-faithful parser — **rust-url**, already in the dependency tree via the fetch layer — through four new host functions: `hostUrlParse`/`hostUrlSet` ride `url::quirks` (the getter/setter surface rust-url maintains precisely for implementing the URL class), `hostFormUrlDecode`/`hostFormUrlEncode` ride `form_urlencoded`. Spec contracts kept: component setters silently ignore invalid values, `href` setter throws, `searchParams` is a live two-way view (including `sort()`), `URL.canParse`/`parse` provided, IDNA validation real (an invalid `xn--` label throws, as in browsers). Wired into both archive run paths as separate statements beside the endowments blob to keep the conflict surface with #876/#877 minimal.
- **Real-execution evidence:** cold state, real registry — `endor run entry.js` fetched `normalize-url@8.1.1` into the CAS and printed correct normalizations (case, default-port strip, `/foo/../bar` collapse, query sort, www strip, utm-param removal via regex option) plus correct raw `URL`/`URLSearchParams` behavior (`é` decode, `+`-space serialization); replayed **byte-identical under `--offline`**. The `semver@^7.5.4` CJS regression probe stays green from a cold state. Tests: `cargo test -p endo` 174/174, `-p xsnap` 121/121 single-threaded (one new test each: full veneer exercise; archive-runner endowment integration). Design doc Known gaps + Updated stamped in the same commit.

## Follow-ups for the next tick

- Confirm CI on **#878** lands green (checks were IN_PROGRESS at report time; state MERGEABLE, draft held). If any check is red, diagnose and push a fix to `feat/endor-npm-url-globals`; if green, leave the draft as-is. Note #878 composes with #876/#877 around `__archiveEndowments` — whichever lands later takes a trivial rebase; do not land any of them.
- **Eight** gap drafts now held for maintainer promotion: #857, #859, #860, #873, #875, #876, #877, and new **#878**. Remaining web-global gaps: `crypto.subtle`, streaming/`fatal` `TextDecoder` fidelity, `encodeInto`; the default-conditions policy still awaits maintainer word on #876.
- Worktree note: my worktree (`project-wt-…-065010-f4d57e5d`) carries the built release binary, populated `c/moddable`, and the generated bootstrap JS (hardlink-copied from the 00:47Z worktree); the URL probe lives in `scratch/npm-cas-probe-20260728/app-url` (its first version used an invalid `xn--example.com` hostname — the resulting IDNA throw was correct behavior, not a bug).
