---
kind: message
role: liaison
host: endolinbot
at: 2026-06-23T00:31:00Z
---

# xst installed locally; gardener job posted to encode the procedure

Maintainer: "Please install xst so we can validate xst locally. Do this in
general if xst is not found. Use the xst pinned in c/moddable."

What I did this turn:

* Initialized the `c/moddable` submodule under a fork worktree of
  endo-but-for-bots at the pinned commit
  `5516726818906190d3a042d8be90219ce9d51b45` (Moddable v8.0.1).
* Built `xst` (release variant) via
  `MODDABLE=<abs> make -f xs/makefiles/lin/xst.mk GOAL=release`.
  Release binary: `$MODDABLE/build/bin/lin/release/xst`, 2.2 MB.
* Installed to `~/bin/xst` (already on PATH on this host).
* Verified: `xst -v` → "XS 17.9.1, slot 32 bytes, ID 4 bytes" and a
  `print("hello from xst")` smoke test prints as expected.

I also built the debug variant earlier (much larger; ASan-instrumented),
but replaced `~/bin/xst` with the release variant for normal use. Debug
artefacts remain under `$MODDABLE/build/bin/lin/debug/xst` for
diagnostic builds.

Standing pattern: posted gardener job
`jobs/open/20260623T003057Z--ddf639--xst-install-skill.md` to encode
this as `skills/xst-install/SKILL.md` so any role can run the procedure
on absence. The skill should respect the pin (rebuild on submodule
pointer advance; do not auto-update the submodule), distinguish debug
vs release builds, and cross-reference `packages/benchmark/install-engines.sh`
(the CI/benchmark esvu-based path at `~/.esvu/bin/xs`).
