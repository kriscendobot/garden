---
title: Analysis — Cloudflare's measured Content-Type distribution for `.js` and `.json`
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-import-attributes/master/content-type-vs-file-extension.md
source_content_sha256: 517bae82cc71751c9f0b557df479b01ee1cac0d720dbc2c468e324d496011d29
source_commit: 9015a79a2c28
source_authors: [Sven Sauleau]
source_date: 2020-06-26
ingested: 2026-07-29
ingested_by: scholar
topics: [module-harmony]
status: current
notes: "The measurement half of the document. The tables are transcribed rather than shape-summarized (conventions.md § Shape, not content, for upstream meta-tables) because they are a frozen 2019/2020 observation, not a mirror of a row set that drifts upstream: the file's last commit is 2020-06-26 and the numbers are the evidence itself, not an index of it."
---

Abstract: The evidence behind the import-attributes motivation, measured at Cloudflare's traffic scale and stated as a percentage distribution of the `Content-Type` header actually served for URLs ending in `.js` and `.json`. The headline is that the "obvious" mapping is a minority-to-two-thirds affair, not a rule: only **61.8%** of `.js` responses carry `application/javascript`, and **20.1%** carry an *empty* Content-Type; only **67.6%** of `.json` responses carry `application/json`, while **14.7%** carry `text/html` and 8.8% carry nothing. The tail is the part that matters for the security argument, because it is populated by types that are actively wrong rather than merely vague: `.js` served as `text/html` (2.5%), as `application/json` (1.1%), and as images and video down in the thousandths of a percent; `.json` served as `application/javascript` or `text/javascript` (0.66% combined — the confusion direction that gets *data* evaluated as *code*), and as `application/octet-stream` (2.0%). The document's own framing of why a small percentage still matters: "Considering Cloudflare's scale, even a very small percentage can reprensent a lot of requests."

## Analysis

> This analysis demonstrates that on internet (as seen by Cloudflare at least) the file extension may not be served with its corresponding mimetype.
>
> Considering Cloudflare's scale, even a very small percentage can reprensent a lot of requests.

### `.js`

Content-Type header for files ending with `.js`:

| mimetype                 | %                |
|--------------------------|------------------|
| application/javascript   | 61.82757604      |
| empty                    | 20.11803875      |
| text/javascript          | 6.980723063      |
| application/x-javascript | 6.544467745      |
| text/html                | 2.518384529      |
| application/json         | 1.10533001       |
| text/plain               | 0.697906732      |
| unknown                  | 0.0559300176     |
| application/xml          | 0.03160118805    |
| application/octet-stream | 0.02865532793    |
| application/ecmascript   | 0.005831504263   |
| video/mp2t               | 0.004634268927   |
| image/png                | 0.002653832304   |
| image/gif                | 0.001813563585   |
| text/x-c                 | 0.0009681784766  |
| text/css                 | 0.0007277081314  |
| image/jpeg               | 0.0006049147636  |
| image/webp               | 0.000348701679   |
| video/mp4                | 0.00006926805361 |
| text/x-asm               | 0.00003384688983 |

### `.json`

Content-Type header for files ending with `.json`:

| mimetype                 | %                  |
|--------------------------|--------------------|
| application/json         | 67.62137903        |
| text/html                | 14.67113587        |
| empty                    | 8.77703774         |
| text/plain               | 3.087589957        |
| unknown                  | 3.045687106        |
| application/octet-stream | 2.034226667        |
| application/javascript   | 0.3646704983       |
| text/javascript          | 0.2912919013       |
| application/xml          | 0.09035178168      |
| application/x-javascript | 0.01219521326      |
| image/gif                | 0.001177305887     |
| image/jpeg               | 0.001159044755     |
| text/css                 | 0.0003426647608    |
| image/png                | 0.00004726410493   |
| application/xhtml+xml    | 0.00003974481551   |
| text/xml                 | 0.00003974481551   |
| image/jpg                | 0.00002255786826   |
| application/pdf          | 0.000005370921015  |
| application/zip          | 0.000003222552609  |
| audio/x-wav              | 0.0000001074184203 |

Two readings are worth separating. Most of the spread is **benign vagueness**: the four JavaScript spellings (`application/javascript`, `text/javascript`, `application/x-javascript`, `application/ecmascript`) plus `empty` account for over 95% of `.js`, and a client that sniffs or defaults gets the right answer. The security argument rests on the remainder — the rows where the served type is a *different* type a client would act on differently. In the `.json` table that is the 0.66% served as some flavor of JavaScript, which is exactly the direction the proposal guards: a resource the importing developer intends as inert data arriving with a type that invites evaluation. The document does not claim these are attacks; it claims only that the extension cannot be relied on as the type, which is enough to require a syntactic marker rather than a filename convention.

Source: [content-type-vs-file-extension.md](https://github.com/tc39/proposal-import-attributes/blob/master/content-type-vs-file-extension.md) at content sha256 `517bae82`, file commit `9015a79a`. Stage 4; retrieved 2026-07-29.
