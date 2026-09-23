Done. The maintainer's hunch was correct — there was a live latent defect of the flagged class, now fixed with coverage.

## Completion report

**Directive** (kriskowal, PR #1125 inline comment on `packages/daemon/src/formula-record.js`): "we've added planes. That suggests a latent defect. Please ensure we have coverage."

**Preflight**: `pr-feedback-preflight.sh` exited 2, but the only correlated artifact was our own liaison ack comment (`3996775288` reply id `3996797039`, "On it — I've posted a job…") — not a resolution. Corroboration failed, so I treated it as PROCEED and did the work.

**Root cause found (genuine latent defect).** `formula-record.js` builds the inspector record `EndoHost.getFormula` returns. This PR had just repaired the exact same drift for `planes`/`networks` on the host and guest branches (they were carried and retained by the formulas but absent from the inspector record). Checking for siblings, I found the host formula's **`registry`** slot — required on every host, added with the `@registry` capability in #671, enumerated in the formula dependency graph (`manager.js`) — was **still** missing from the host inspector branch, so the inspector could not reach a host's registry. That commit (#671) added the `registry` *type* branch but never updated the *host* branch.

**Changes** (commit `4ca79d80d` on PR head `bot/build/endo-guest-invite-primitive`):
- `packages/daemon/src/formula-record.js` — add the missing host `registry` reference.
- `packages/daemon/test/formula-record.test.js` — pin the full host and guest record shapes (host: every reference incl. `registry`/`planes`; guest: `networks`/`planes` plus present/absent pin directories; plus the new `read-only-directory` branch), so a future formula slot added without a matching record branch fails loudly in this suite instead of silently vanishing from the inspector.
- `.changeset/guest-owned-invitation.md` — note the inspector fix.

**Race handled honestly.** My first push (`38bb6a2c0`) included a legacy guest-pins coercion test that a concurrent peer commit (`e2b38e8bc refactor(daemon): drop legacy guest-pins formula migration`) had made obsolete — it failed against the rebased source. I removed that test, amended, verified 10/10 pass, and force-with-lease-replaced my own just-pushed commit (lease matched `38bb6a2c0`, so no peer work was clobbered).

**Verification (all clean):** `ava` formula-record suite 10/10; daemon `tsc` (`lint:types`); root `tsc -p tsconfig.json` (checkJs, at 8 GiB heap — the default 2 GiB OOMs, environment limit not a code issue); `eslint` 0 errors.

**Reply posted** to the review thread: https://github.com/endojs/endo-but-for-bots/pull/1125#discussion_r3996831875

**Follow-up (not addressed — out of scope):** the `endo` formula is classified as an empty-state type in `formula-record.js`, yet the dependency graph shows it retains `networks`/`pins`/`peers`/`host`/`leastAuthority`. This may be an intentional "root bootstrap isn't user-inspected" choice rather than drift; worth a maintainer decision if the inspector should surface it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1125-aff3b059.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 110 tokens (4247146 cached reads)
- Output: 28327 tokens
- Cost: $3.8142240000000007
- Wall-clock: 582s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
