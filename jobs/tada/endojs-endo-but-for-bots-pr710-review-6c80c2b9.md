Both follow-up jobs are on the board and already claimed by peer gardeners (`jobs/doin/`). The work is complete.

## Completion report

**Job:** Review directive on `endojs/endo-but-for-bots` PR #710 (kriskowal's approving review `#pullrequestreview-4681138662`).

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED) — no peer had resolved this feedback.

**Enumerated the whole review as the unit of work:**
- **Review body** (approval): *"Approved with nits. Please absorb the fixes and conduct to the llm branch."*
- **1 inline comment** (`designs/cbor-codec.md:280`, id 3567494447): the framing siblings this design named `@endo/cbors` / `@endo/syrups` actually landed as `@endo/cbor-frame` / `@endo/syrup-frame`; amend the proposals to reflect the implementation.

**Untrusted-input discipline:** I treated the review/comment text as data and independently verified the package names against the repo before acting — confirmed `@endo/syrup-frame` exists on `origin/llm` (`packages/syrup-frame`) and `@endo/cbor-frame` is implemented on `feat/cbors-package` / PR #288 (open, base `llm`).

**Absorbed the nit (commit `ee3bde9c57`, pushed to `design/cbor-codec`):** reconciled `designs/cbor-codec.md` — Naming section, Scope list, migration phase 4, the Relationship-to-existing-packages table, Design Decision #2, and Open Question #1 (now *resolved*: the `-frame` suffix retires the `@endo/cbor` vs `@endo/cbors` near-collision the question weighed) — plus the in-PR `designs/README.md` summary row. The primitive codec `@endo/cbor` is unchanged; historical "proposed as" notes retained.

**Inline reply posted** (comment id 3567507059) citing the absorb commit and pointing to the follow-up.

**Follow-up posted** (reviewer's literal "post a follow-up to amend the design proposals"): job `endojs-endo-but-for-bots-frame-naming-proposals` to reconcile the *sibling* proposal docs (`cbors.md`, `syrups.md`, `ocapn-tcp-syrups-framing.md`) and their pre-existing README rows — deliberately kept out of PR #710's scope.

**Primary action — conduct:** dispatched job `endojs-endo-but-for-bots-pr710-conduct` for the conductor to un-draft (PR is currently draft) and merge to `llm` once CI is green (my push kicked a fresh run; `build`/`zizmor` pass, `lint`/`test`/`browser-tests` were pending at hand-off). No merge method named — the conductor owns that. Bot repo; no upstream ferry.

**Board state:** both follow-up jobs already claimed by peers (`jobs/doin/`). Inbox empty.

**Follow-ups (owned by dispatched jobs, not open work for me):**
- Conductor drives PR #710 to merge once checks pass.
- `frame-naming-proposals` job amends the sibling design docs.
