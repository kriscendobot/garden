---
id: fragment-held-credential
aliases: [fragment credential, URL fragment secret, hash-fragment bearer, fragment-held key]
topics: [http-secret-handling, capability-security]
---

# fragment-held-credential

A bearer credential or decryption key carried after a URL's `#`. Browsers normally omit it from HTTP request targets and referrers, but page code, extensions, history, copied URLs, crash reporting, and Performance Timeline entries can retain or reveal it. It is best limited to short-lived, single-use bootstrap material followed by navigation to a clean document.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [URL fragments and split knowledge](../sections/web--secret-seal--url-fragments-and-split-knowledge.md) | Explains fragment exposure and why same-document cleanup does not clear Navigation Timing. |

## See also

- [[web-key]] — a URL whose unguessable component is itself authority.
- [[request-carrier-leakage]] — the broader carrier comparison.
