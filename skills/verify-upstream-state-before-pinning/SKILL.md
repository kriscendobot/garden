---
created: 2026-05-13
updated: 2026-06-24
author: gardener
---

# Skill: verify-upstream-state-before-pinning

Adopted from `references/endo-but-for-bots/skills/verify-upstream-state-before-pinning.md`.

## Trigger

A reviewer, an inbox message, or a `build`/dependency-triage job asks to pin an external dependency to a specific version, capture a sha256, or embed metadata about an upstream artifact. Consumed by the dependency-triage jobs a gardener claims off the board (the v2 equivalent of the botanist / major-general dependency-survey work) and by any gardening step that writes a version pin.

## Why

Job payloads and reviewer suggestions often quote a version or release date the agent guessed from training data, not from a fresh fetch of the upstream. The guess is frequently months stale. Committing the guess ships wrong metadata in workflow comments and can silently mismatch a download cache.

## What to do

1. Fetch the upstream's directory listing or release page yourself. `curl`, `gh release list`, or the project's downloads index, depending on the source.
2. Read the actual current release: name, date, URL, sha256.
3. Compute the sha256 from a fresh download (`curl -fsSL <url> | sha256sum`); do not trust a sha256 from elsewhere.
4. Embed the version and sha256 as workflow-level env vars so a future bump is a two-line change.
5. Key any download cache by both the version *and* the sha256 so a stale blob cannot shadow a version bump.
6. Cite the verification source in the commit message body (the directory listing URL, the release page).

## Output shape

A pinned version + sha256 pair that was fetched (not guessed), a download cache keyed by both, and a commit message body citing the verification source. The fetched values are what a reviewer or panel seat can re-verify against the same upstream.

## Notes from the field

- _2026-05-13_: adopted from the reference.
- _2026-06-24_: migrated into v2. The discipline is unchanged; the trigger now arrives as a dependency-triage job a gardener claims (or an inbox message) rather than a dispatched botanist / major-general brief.
