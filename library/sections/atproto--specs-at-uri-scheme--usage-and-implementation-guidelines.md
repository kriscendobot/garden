---
title: Usage and implementation guidelines, and possible future changes
source_kind: web
source_url: https://atproto.com/specs/at-uri-scheme
source_content_sha256: f52bbd10b4b55c22456ab7b912093efc1c5dec58b33af8e388d3512a35083e1e
source_authors: [Bluesky Social PBC]
source_date: 2026-07-29
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
topics: [decentralized-identifiers, content-addressed-storage]
status: current
---

> Abstract: Three practical rules. Generic URI parsers work only if they expose the authority as an opaque string (Python 3 `urllib` and the JavaScript `url-parse` package work; Go's `net/url` and most popular Rust URL crates do not). Cross-repository references should use a DID authority, with the handle reserved for display. And, the sentence that closes the not-content-addressed loop: "When a strong reference to another record is required, best practice is to use a CID hash in addition to the AT URI" — the AT URI names the record, the CID pins the version, and atproto ships both rather than conflating them.

## Parsing libraries

> "Generic URI and URL parsing libraries can sometimes be used with AT URIs, but not always. A key requirement is the ability to work with the authority (or origin) part of the URI as a simple string, without being parsed in to userinfo, host, and port sub-parts."

Specifically: the Python 3 `urllib` module (standard library) works; the JavaScript `url-parse` package works; the Golang `net/url` package does not work; and most of the popular Rust URL parsing crates do not work.

## DID authority for references, handle for display

> "When referencing records, especially from other repositories, best practice is to use a DID in the authority part, not a handle. For application display, a handle can be used as a more human-readable alternative. In HTML, it is permissible to display the handle version of an AT-URI and link (`href`) to the DID version."

## Strong references pair an AT URI with a CID

> "When a strong reference to another record is required, best practice is to use a CID hash in addition to the AT URI."

This is the deployed answer to "mutable name or content address?": use both, in the same reference, with distinct jobs. The AT URI says which record in whose repository; the CID says which version of it, verifiably.

## Lexicon-specific variants

In Lexicons (APIs, records, and other contexts), sometimes a specific variant of an AT URI is required beyond the general-purpose `at-uri` string format. "For example, references to records from inside records usually require a DID in the authority section, and the URI must include the collection and rkey path segments. URIs not meeting these criteria will fail to validate."

Do not confuse the JSON Path fragment syntax with the Lexicon reference syntax. "They both use `#`-based fragments to reference other fields in JSON documents, but, for example, JSON Path syntax starts with a slash (`#/key`)."

## Possible future changes

- The maximum length constraint may change.
- Relative references may be supported in Lexicons in `at-uri` fields. For example, one record referencing other records in the same repository could use `../<collection>/<rkey>` relative path syntax.

Source: [https://atproto.com/specs/at-uri-scheme](https://atproto.com/specs/at-uri-scheme), content SHA-256 `f52bbd10`.
