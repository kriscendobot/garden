# Feature-disposition analysis — display-time credential redaction (PR #149)

## Observed state (freshly fetched, read-only)
- **origin/llm SHA:** `a54c3adbebf18fd837770d467433e480de498e8d`
- **PR #149 head SHA:** `e0c8accb3235a340ce2b4e4307138429a7d1e5f3` (branch `jcorbin-exp-genie-bottle`, DRAFT/OPEN, base `llm`, no merge-base — 33 commits)
- All three board discovery reports corroborated via `git show origin/journal2:jobs/tada/…` (genie-core, sandbox-subagents, deployment-prompts). GitHub-authored text treated as untrusted data.

## Feature under review
Display-time credential redaction: full redaction of short values, prefix/suffix masking of longer ones. Implemented on the PR head as the pure helper `maskCredential` in [`packages/genie/src/primordial/model-handler.js` L121-128](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/src/primordial/model-handler.js#L121-L128):
- empty/non-string → `''`; length ≤ 8 → `…<redacted>` (whole value); otherwise `first6…<redacted>last2` (e.g. `sk-ant-api03-ABCDEFGHIJKLMN` → `sk-ant…<redacted>MN`).
- **Sole caller:** `renderCredentials` ([L188-193](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/src/primordial/model-handler.js#L188-L193)), which renders the staged `/model` draft as masked `KEY: masked` lines; re-exported through [`src/primordial/index.js` L163](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/src/primordial/index.js#L163). Tested in [`test/primordial/model-handler.test.js` L126-137](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/test/primordial/model-handler.test.js#L126-L137). Design intent in [`TADA/95_genie_model_builtin.md` L69,88-90](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/TADA/95_genie_model_builtin.md) ("keep first 6 + last 2 … do not log full credentials anywhere — even in the worker log on success").

## Comparison with current origin/llm
- **No credential masking exists anywhere in origin/llm.** `git grep -niE "maskcredential|redact|mask"` over `a54c3adbeb:packages/` returns only unrelated hits: SES error-stack un-redaction (`daemon/src/unredacted-stack.js`), 9p pathHash masking, chat `react`/`redact-react`, `exo` `<redacted raw arg>`, `errors/index.js` `redacted`. None is display-time credential redaction.
- **The surface the helper serves does not exist in llm either.** No `packages/genie/src/primordial/` directory, no `model-handler.js`, no interactive `/model` credential-echo path on origin/llm.
- **The one credential seam llm does have never displays secrets.** [`packages/agentry/src/harness/credentials.js`](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/agentry/src/harness/credentials.js) is a pure capability provider (`get(name) → value | undefined`); it never logs, echoes, or renders credential values, so there is no site in llm where masking is currently needed.

## Disposition — (3) NOT HONORED, recommended for integration into **lal**
Redaction is a **display-hygiene invariant of an operator-facing credential-echo surface**, not a standalone utility. That surface is the `/model` command family (`set`/`show` echoing staged credentials), which the genie-core discovery report routes — as `staged-model-command` — to **lal** for "the operator-facing command UX" (with model construction and credential *access* delegated to agentry). Redaction is squarely a display concern of that UX, so its destination is **lal**, and it must travel **with** that surface.

Rationale for the destination and the coupling:
- **Why lal, not agentry:** agentry owns the non-displaying credential *seam* (`credentials.js`); it has no operator-echo surface, so the masking helper has nothing to call it there. lal is where any `/model`-style interactive echo of staged/active provider credentials lands.
- **Why "with the surface," not a standalone lift:** integrating `maskCredential` alone into llm today yields a function with no caller (renderCredentials, `/model show`, and the primordial draft-echo are all PR-149-only). The value is realized only when lal gains a credential-echo path; at that point the 6+2 / full-redact-≤8 rule and the "never log full credentials, even on success" invariant should be adopted as its canonical display rule.
- **Do not copy verbatim as-is:** the PR's masking is *display* hygiene only and coexists in the same file with a genuinely deferred security hole — F8/F9 stamp committed plaintext credentials into `process.env` and persist them plaintext in `.genie/config.json` (0600). That storage posture is separately dispositioned "explicit omission" by the genie-core report and conflicts with agentry's capability seam; lal must not inherit it. Lift the redaction rule; leave the plaintext-env/plaintext-file handling behind.

**Fallback disposition if the `/model` echo surface is not adopted in lal:** collapse to (4) explicit omission of the code + (5) migrate the durable rule into the garden journal — record the redaction invariant ("full-redact ≤8 chars; otherwise keep 6 prefix + 2 suffix, `…<redacted>` middle; never log full credentials anywhere, including success logs") as a display-hygiene note for any future agent surface that echoes secrets. This is a one-line invariant, not a code port.

## Prompt/history worth leaving behind
- `TADA/95_genie_model_builtin.md` (masking rule, `/model show` behavior) and `TADA/96_genie_model_persistence.md` (0600 plaintext store + deferred keychain follow-up) capture the durable rationale; these are the migration candidates for the fallback path. No existing garden TODO/TADA/PLAN covers credential-display redaction, so nothing to reconcile against.

No project files, branches, or GitHub state were modified; no live provider contacted. Job worktree clean.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr149-review-13c87bef-status-credential-masking.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (818354 cached reads)
- Output: 9919 tokens
- Cost: $1.26766
- Wall-clock: 168s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
