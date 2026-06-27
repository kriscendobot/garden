Completed `improve-source-slug-prefix-divergence-check`. Pushed commit `4fe28d91a` to `main2`.

## What I did

Added a deterministic slug-prefix-divergence check to the library tooling and wired it into the scholar's pre-land gate, so the "what prefix do siblings use for this host?" decision is moved off the agent's head and into code — preventing the reland+supersede cycle that the `erights-org--` vs `erights--` incident caused.

## What changed

**New: `scripts/jobs/library-slug-prefix-check.sh`** (no writes, no network — same invariant as its companion `library-link-check.sh`). It parses `library/sources/README.md`, maps each source row's upstream **host/domain** to the set of slug **prefixes** already in use for that host, and flags divergence. Host derivation: a web row's URL → hostname (`www.`/port stripped); an `owner/name` repo cell → that repo (trailing `(branch)` stripped); a paper's author cell or `{N files}` aggregate → no host, skipped. Prefix = slug substring before the first `--`. Three modes:
- `--propose <slug> [--host H | --url U]` — pre-land check for one slug; fails (exit 1) on divergence naming the canonical (highest-use) sibling prefix; `--allow-new-prefix` downgrades to a warning for a deliberate new thematic cluster. A brand-new host can't diverge.
- `--changed [base]` — producer gate: derives each NEW row's host+prefix and checks against the host's established prefixes recorded at `origin/journal2` (the row excludes itself, so it can't self-establish).
- `--audit` — standing scan flagging any singleton prefix sitting beside an established (>1-use) prefix for the same host.

Verified against the real corpus: the erights.org case fails with `Canonical sibling prefix: 'erights'` exactly as intended.

**New: `scripts/jobs/test/library-slug-prefix-check-test.sh`** — 12 hermetic cases (divergence detect/name, matching prefixes pass, multi-prefix hosts, new host, `--allow-new-prefix`, repo-host divergence, `--url`/own-row host derivation, `--changed` gate both directions, `--audit` singleton, paper-row skip). All 12 pass.

**Edited: `roles/scholar/AGENT.md`** — added the prefix check at slug-computation time (step 4, `--propose`), re-ran it over the cycle's new rows in the post-ingest gate (step 8, `--changed`), and added a definition-of-done line.

## Follow-ups (optional, not done)
- `conventions.md` § Slug pattern (library content on `journal2`, the scholar's province via the lander) could cite the tool as the enforcement of the existing "thematic cluster vs bare prefix" rule — a one-line scholar edit, not a main2 change.
- A standing `--audit` could be hung off a systemd timer like `library-source-drift-scan` if a periodic convention-drift signal is wanted; the pre-land gates already cover the producing-side defect, so I left this as a deliberate non-goal to keep the change bounded.
