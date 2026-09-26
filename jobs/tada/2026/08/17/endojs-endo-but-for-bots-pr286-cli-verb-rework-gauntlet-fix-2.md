CI is GREEN on my head `1f394cd03f` — all 26 checks pass, including the macos-15/node-24 test that the counterexample had failed. The fix stage is complete.

## Completion report

Applied the panel's **round-2** verdict on endojs/endo-but-for-bots PR #1014 (`feat/cli-http-mk-on-policy-client`), pushed as review-feedback follow-up commits, and drove CI to green.

**Must-fix (both applied):**
1. **archivist** — dropped the dangling "write-once log" cross-reference in `designs/cli-http-client.md`; now states plainly that Phase-1 `tofu-auto` is a distinct, narrower mechanism from the trust-on-first-bind addendum.
2. **fast-checker** — added two property tests over `normalizeHttpClientOrigin`: idempotence over the accepted-origin space (the docstring's canonical-form claim) and refusal of any path/query/fragment/userinfo suffix (the false-confinement security boundary). Added `@fast-check/ava` (catalog:dev) to the CLI package.

**Should-fix (also applied):**
3. **prover** — extracted the `--origin` collector, the `--policy-mode` validator, and the opts→args mapping into pure `http-mk-policy.js` helpers (`collectHttpOrigin` / `parsePolicyModeFlag` / `httpMkArgsFromOpts`) and unit-tested them, pinning the last-wins accumulation regression and the swapped-destructure regression the daemon-driven test can't see.
4. **scribe** — added the metering/rate-limiting forward link (endojs/endo-but-for-bots#992) to the Landed CLI surface section.
5. **changeset-auditor** — rewrapped the changeset one sentence per line.
6. **packager** — fixed the stale `<url>` metavar to `<origin>` in the design synopsis.
7. **typist** — retyped `args.allowedOrigins` as `{string[] | undefined}` in both `http-mk-policy.js` and `commands/http-mk.js`.

**Course-correction during CI:** the reject-partition property found a genuine counterexample on CI (`http://host/..`) that my local seed missed — a dot-segment path collapses to the bare-origin root under URL normalization, so that input is a correct *acceptance*, not a reject. The function is correct; I hardened the test's arbitrary (lead each generated suffix segment with a literal non-dot character) and re-pushed.

**Commits pushed to PR head:** `fix(cli): apply panel round-2 review to endo http mk`, `chore: Update yarn.lock`, `test(cli): harden the reject-partition property arbitrary`.

**Verification:** CLI package `tsc` clean, eslint clean (no new problems), local `ava` green (21 tests, 3× repeat). Full PR CI green on head `1f394cd03f` — all 26 checks SUCCESS, including `test (24.18.0, macos-15)`.

No follow-ups; the panel driver re-posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr286-cli-verb-rework-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (1 unmetered)
- Input: 152 tokens (7257407 cached reads)
- Output: 52094 tokens
- Cost: $6.190398500000001 (1 engagement(s) unpriced)
- Wall-clock: 1453s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
