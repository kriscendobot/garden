---
title: Blob security considerations and possible future changes
source_kind: web
source_url: https://atproto.com/specs/blob
source_content_sha256: e9de13e4d3c516a4e324d59451c017658aeffcc6c1317a6fda056e20b8643d6d
source_authors: [Bluesky Social PBC]
source_date: 2026-07-29
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
topics: [endpoint-security, content-addressed-storage]
status: current
---

> Abstract: Serving arbitrary user-uploaded bytes is treated as an unsafe operation with a mandatory mitigation, not a best practice: a Content Security Policy on `getBlob` is "effectively mandatory", serving blob storage directly to browsers is "effectively not supported", and applications "must proxy blobs, files, and assets through an independent CDN, proxy, or other web service". The page also tells PDS operators not to parse media at all: "PDS instances themselves should not directly implement media resizing or transcoding." Content addressing gives you integrity, and nothing about the safety of interpreting the bytes.

## Content security

> "Serving arbitrary user-uploaded files from a web server raises many content security issues. For example, cross-site scripting (XSS) of scripts or SVG content form the same 'origin' as other web pages. It is effectively mandatory to enable a Content Security Policy for the `getBlob` endpoint. It is effectively not supported to dynamically serve assets directly out of blob storage (the `getBlob` endpoint) directly to browsers and web applications. Applications must proxy blobs, files, and assets through an independent CDN, proxy, or other web service before serving to browsers and web agents, and such services are expected to implement security precautions."

An example set of content security headers for this endpoint:

```
Content-Security-Policy: default-src 'none'; sandbox
X-Content-Type-Options: nosniff
```

## Metadata leakage

> "Some media types may contain sensitive metadata. For example, EXIF metadata in JPEG image files may contain GPS coordinates. Servers might take steps to prevent accidental leakage of such metadata, for example by blocking upload of blobs containing them."

## Media parsing is the attack surface

> "Parsing of media files is a notorious source of memory safety bugs and security vulnerabilities. Even content type detection (or 'sniffing') can be a source of exploits. Servers are strongly recommended against parsing media files (image, video, audio, or any other non-trivial formats) directly, without the use of strong sandboxing mechanisms. In particular, PDS instances themselves should not directly implement media resizing or transcoding."

Richer media types raise the stakes for abusive and illegal content, and services should implement appropriate takedown mechanisms. Servers may also need rate-limits, size limits, and quotas to prevent malicious resource consumption (disk exhaustion, network congestion, bandwidth utilization).

## Possible future changes

- "The allowed CID type is expected to evolve over time. There has been interest in `blake3` for larger file types."
- More specific mitigation of metadata leakage (EXIF stripping) should be recommended or enabled via API changes. "There is a tension between providing default safety, and always intervening to manipulate 'original' uploaded user data."

Source: [https://atproto.com/specs/blob](https://atproto.com/specs/blob), content SHA-256 `e9de13e4`.
