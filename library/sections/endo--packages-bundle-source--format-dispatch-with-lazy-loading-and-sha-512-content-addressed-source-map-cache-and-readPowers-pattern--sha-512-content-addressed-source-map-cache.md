---
title: §SHA-512-content-addressed-source-map-cache
source-slug: endo--packages-bundle-source
section-id: format-dispatch-with-lazy-loading-and-sha-512-content-addressed-source-map-cache-and-readPowers-pattern
url: https://github.com/endojs/endo/tree/master/packages/bundle-source
authors: [Endo contributors]
repo: endojs/endo
path: packages/bundle-source/src/{bundle-source.js,zip-base64.js,script.js,endo.js,fs.js,main.js,is-entrypoint.js,tool.js,index.js}
status: shipping
ingest-cycle: 221
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-bundle-source--format-dispatch-with-lazy-loading-and-sha-512-content-addressed-source-map-cache-and-readPowers-pattern
---

The most structurally novel move in this package. Source maps are §cached-by-SHA-512-of-content + §tracked-by-SHA-512-of-location. Two parallel directories:

- `<cache>/source-map/<sha512Head>/<sha512Tail>.map.json` — the source map content, addressed by content sha-512.
- `<cache>/source-map-track/<locationSha512Head>/<locationSha512Tail>` — the tracker file at location-sha-512 contains the current content-sha-512 for that location.

§Two-letter-prefix-sharding (using the first two chars of the sha-512) avoids one giant directory.

§The-cache-update-protocol:
1. Read the tracker file (if any) → §old-content-sha-512.
2. If old equals new, no-op (§the-content-already-cached).
3. Otherwise, §delete-the-old-source-map (and rmdir the directory if empty), then §write-the-new-source-map + §update-the-tracker.

§Borrowable-pattern: §content-addressed-cache-with-a-location-to-content-tracker. §The-tracker-IS-the-mutation-point + §the-cache-IS-the-immutable-store. §Sibling to cycle 200's §retention-path-notation (content-addressed file references) and cycle 203 cache-map (different shape — in-memory ring-buffer cache, but same §don't-establish-entry-until-prior-steps-succeed discipline).

§The-trickiest-part: §rmdir-the-old-source-map-directory-if-it-becomes-empty-after-deletion. §The-directory-sharding-means-old-files-leak-without-this-cleanup-step. §Borrowable-pattern: §directory-sharding-needs-an-empty-directory-cleanup-step (otherwise the cache leaks empty directories).

§The-tolerate-ENOENT pattern: `.catch(error => { if (error.code !== 'ENOENT') throw error; })`. §Borrowable-pattern: §the-first-time-the-cache-is-populated, §the-tracker-file-doesn't-exist-yet — §ignore-the-ENOENT + §don't-conflate-it-with-other-errors.
