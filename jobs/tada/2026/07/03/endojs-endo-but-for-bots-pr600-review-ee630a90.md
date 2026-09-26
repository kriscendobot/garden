Completion report:

## What was asked
A trusted-maintainer (kriskowal) review on endojs/endo-but-for-bots PR #600 (the `xs2rust-endor` XS→Rust engine design+build program). The whole-review directive: *"Please note that we have packages/test262-hardness and should use this to drive endor XS parity tests. Carry on."* No inline comments were tied to the review (`pull_request_review_id==4621929016` returned an empty comment set) — a single body-level directive.

## What I found
- **Preflight** (`pr-feedback-preflight.sh … 600 4621929016 kriskowal`) → exit 0 = PROCEED; no peer had resolved it.
- The named package is actually **`packages/test262-runner`** (no `test262-hardness` exists; the reviewer's recollection of the name was imprecise). It carries a checked-in, pinned test262 subset (`test262/{test,harness}` + Moddable + HardenedJS tests) and a `test262-harness`-driven runner that proves XS↔Node HardenedJS parity on the `ses-xs-parity`-tagged tests via the `xst` and `node` hosts.
- The design (§ test262 conformance, requirement 6) had planned to pin a **separate** test262 submodule "like `c/moddable`" and drive parity from a bespoke curated corpus — exactly what the maintainer is redirecting away from.

## What changed (commit `be08ab8ae`, pushed to `xs2rust-endor`)
- **`designs/xs2rust-endor-engine.md`** § test262 conformance: recorded the directive as a resolved design decision — endor-262 drives its endor↔C-XS `(pass-vector, computron)` parity off `packages/test262-runner`'s existing tree and `ses-xs-parity` feature markers, superseding the separate-submodule plan; one shared corpus serves both parity axes (XS↔Node at the SES surface; endor↔C-XS at the bytecode/meter surface), with endor becoming a third host alongside `xst`/`node` once its SES/Compartment surface lands (stage 4). Curated `corpora/` remain the stage bootstrap.
- **`rust/engine/README.md`** and the **`endor-262` crate doc-comment**: aligned to the same plan so code and design agree.
- Posted a resolution comment on PR #600 ([#issuecomment-4871599573](https://github.com/endojs/endo-but-for-bots/pull/600#issuecomment-4871599573)).

## Notes / scope
- This was a **design amendment**, not a build wiring change: the `ses-xs-parity` corpus today is only SES-level Compartment tests, far beyond stage-1's proven arithmetic/logic/branch subset, so actually running those on endor is a stage-4 concern the amendment now describes. No behavior change to the shipped interpreter; the doc-comment/markdown edits cannot affect compilation, so I did not re-run the Rust build.
- Push landed via rebase-CAS on top of current `xs2rust-endor` HEAD; inbox drained clean at start, mid-point, and end.
- Follow-up (owned by later stages, not this job): once stage 4 lands `lockdown`/`Compartment`, add endor as a `test262-runner` host and switch endor-262's whole-section runs onto the shared tree.
