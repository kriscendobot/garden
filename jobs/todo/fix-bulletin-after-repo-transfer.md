role: builder
# Fix the bulletin after the repo transfer, and canonicalize every reference to it

Maintainer directive (kriskowal, 2026-07-28): fix the bulletin and all references to it.

Context: `kriskowal/garden` transferred to `kriscendobot/garden`. GitHub redirects
**repository** URLs but does **not** redirect **Pages** URLs across a transfer, so
<https://kriskowal.github.io/garden/bulletin/> is a hard 404 and the bulletin now
lives at <https://kriscendobot.github.io/garden/bulletin/> (verified 200).

Garden repo, `main2`, **DIRECT push, NO PR** per CLAUDE.md § Conventions.

## Already done - do not redo

`docs/bulletin/config.js` is already correct (`owner: 'kriscendobot'`, `repo:
'garden'`), and job `garden-repo-transfer-followthrough` swept most in-repo
references. Verify rather than assume, but do not churn what is already right.

## 1. The broken Pages URLs

- `docs/bulletin/DESIGN.md` line 44 still asserts "The bulletin lands at
  `https://kriskowal.github.io/garden/bulletin/`". That is now false. Fix it.
- `context/operations/repo-transfer.md` line 29 also names the old URL. Judge it:
  if it is **narrating the transfer** (the old address that died), it is correct
  history and should STAY, perhaps clarified as historical. If it is stating where
  the bulletin *is*, fix it. Say which you concluded.

Sweep for any other `kriskowal.github.io` occurrence and apply the same test.

## 2. The token-scope trap - document it so it cannot recur silently

This is the substantive fix, not a URL edit. A **fine-grained PAT is scoped to a
resource owner**, and that scope does NOT follow a repository transfer. The token
minted under `kriskowal` silently lost the ability to commit to the transferred
repo, so the bulletin's reply boxes fail on save while everything else looks fine.
`docs/bulletin/SETUP.md` never states the resource owner, which is precisely why
this was invisible until it broke.

Update `docs/bulletin/SETUP.md` to state explicitly:

- **Resource owner:** `kriscendobot` (the repo's current owner), Repository access:
  Only select repositories -> `kriscendobot/garden`, Permissions: Repository
  permissions -> **Contents: Read and write**, nothing else.
- A short note that a token is owner-scoped, so **any future transfer invalidates
  it** and it must be re-minted under the new owner. Name the symptom (reads keep
  working, replies fail on save) so the next person recognizes it immediately.

## 3. Make the failure legible in the page itself

Today a stale or wrong-owner token fails at save with no useful signal. Make the
bulletin surface it: on a commit rejection (401/403/404 from the Contents API),
show a clear message saying the token is missing, expired, or scoped to the wrong
resource owner, and point at `docs/bulletin/SETUP.md`. Keep it small and
dependency-free, consistent with the existing page. Do not log or display the
token itself, ever.

## 4. Canonicalize the repository references

Roughly 15 files still contain `kriskowal/garden` (CLAUDE.md, README.md,
context/operations/README.md, several designs/, docs/bulletin/, roles/COMMON.md and
others). These are NOT broken - repo URLs redirect - so this is correctness, not
breakage. Apply judgment per occurrence:

- **Canonical statements of where the repo IS** (for example CLAUDE.md § Conventions
  "pushed directly to `origin` (`github.com/kriskowal/garden`)", README) -> update to
  `kriscendobot/garden`.
- **Historical references** - a design doc recording a past decision, an issue or PR
  link that resolves fine via redirect - may legitimately keep the old form. Do not
  rewrite history to look like it happened at the new address.

State the rule you applied and roughly how many occurrences fell each way.

## 5. Do NOT rewrite the journal

`journal2` holds stale Pages URLs in `jobs/tada/` reports and `inbox/` messages.
Those are a transcript of what was true when written. Leave them alone.

## Out of scope

Re-minting the PAT is the maintainer's action (only kriskowal can mint it) and is
already reported to the maintainer inbox. Do not attempt it, and do not add any
credential to the repo.

## Definition of done

- No document asserts the bulletin lives at a `kriskowal.github.io` address.
- `docs/bulletin/SETUP.md` states the resource owner and the transfer-invalidates-token
  rule with its symptom.
- The page reports a wrong-owner/expired token clearly instead of failing silently.
- Repository references are canonicalized where they are statements of current fact,
  and deliberately preserved where they are history.
- Verify the live page still loads at <https://kriscendobot.github.io/garden/bulletin/>
  after your change deploys, and that reads work with no token at all.
- Run CI-equivalent checks locally before pushing. Direct push to `main2`.

<!-- garden-reaped: 1 -->
