# fixer: address kriskowal's #594 CHANGES_REQUESTED — rewrite the lint driver in JavaScript

**Repo:** `endojs/endo-but-for-bots`, **PR #594**, base `master` (bot-pushable; standing comment auth on this repo — reply + summary + re-request are all authorized). No upstream `endojs/endo` touch.

**Priority: respond promptly and VISIBLY on the PR.** The maintainer has re-flagged this review three times; it has had no response yet. Your deliverable is a push to #594 **plus a reply on the review thread**, not a background analysis.

## The review to address

kriskowal, CHANGES_REQUESTED, 2026-07-02T10:14:32Z, review `4616520025`:
> "Please use JavaScript for the driver script. Use zx if that helps keep it concise, or drive eslint by API if that is more concise."
<https://github.com/endojs/endo-but-for-bots/pull/594#pullrequestreview-4616520025>

## What #594 currently has (head `3473f5df2`)

A **bash** `scripts/eslint-repo.sh` that lints in bounded package buckets (`ESLINT_BUCKET_SIZE`, default 10) to stay under the typescript-eslint project-service ceiling, with `package.json` `lint:eslint` delegating to it, plus a changeset.

## Task

Replace the bash driver with a **JavaScript** driver that preserves the exact behavior (bucketed per-package linting, `ESLINT_BUCKET_SIZE`/equivalent override, `--fix` passthrough, the root-dirs batch, byte-identical coverage including `packages/where` and `packages/zip`):

- **Prefer the ESLint Node API** (programmatic `ESLint`/`loadESLint`, lint each bucket in-process or via a small concurrency pool) — the maintainer flagged it as likely most concise, and it avoids a shell subprocess per bucket. Use **zx** only if it genuinely reads cleaner. Keep it a single, concise driver file (replace `scripts/eslint-repo.sh`; do not leave both).
- Update `package.json` `lint:eslint` to invoke the JS driver (`node scripts/eslint-repo.mjs` or the zx equivalent). Update the changeset wording.
- Match the repo's module conventions (ESM/`.mjs` as the repo uses); keep it lint-clean itself.

## Verify (cite real evidence per `garden/roles/COMMON.md` § Reporting)

Run the JS driver over the repo → **0 errors** (warnings only), coverage byte-identical to `eslint .` including `where`/`zip`, and confirm the bucketing still caps project-service size. If the sandbox blocks a bin shim, drive ESLint via the Node API / `yarn` route as prior #594/#597 jobs did and say so. Do not write "verified" without the cited run.

## Close the loop on the PR (all standing-authorized here)

1. Push the JS driver to #594's head branch (`chore/lint-eslint-per-package-batches`).
2. **Reply on kriskowal's review thread** (`skills/pr-review-thread-replies`) confirming the driver is now JavaScript (name the approach: ESLint API or zx) and citing the addressing SHA.
3. Post a **top-level summary comment** (`skills/pr-completion-summary-comment`): head SHA, the bash→JS conversion, verification status.
4. Re-request kriskowal's review once CI `lint` is green.
5. Do **NOT** un-draft or merge #594 (the maintainer's call).

## Coordination (avoid collision)

The bucket-vs-shard **strategy** question is a separate, advisory job (`ebfb-lint-master-strategy-evidence`) — it will recommend, not push. **You own the #594 branch** for this review response. Implement the JS driver for the current bucketed approach now; if the evidence job later recommends sharding, that layers on top separately. Do not wait for it.

## Definition of done

#594's lint driver is JavaScript, pushed to the PR; kriskowal's review thread has a reply citing the SHA; a top-level summary is posted; CI `lint` is green and review re-requested; #594 remains draft. Journal a `result` entry with the comment/commit URLs.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolinbot2
  gardener: 3
  claimed_at: 2026-07-02T17:37:31Z
