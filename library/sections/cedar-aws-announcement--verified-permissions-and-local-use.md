---
title: "Amazon Verified Permissions, central policy storage, and offline use"
source_kind: web-announcement
source_url: https://aws.amazon.com/about-aws/whats-new/2023/05/cedar-open-source-language-access-control/
source_content_sha256: 0eb61f6668e777d6f6f9f1d5aa9e7c4e7da53eaa72b8671169197e58224a09c9
source_author: AWS
source_date: 2023-05-10
retrieved: 2026-09-04
ingested: 2026-09-04
ingested_by: scholar
topics: [policy-language-authorization]
status: current
---

Cedar ships in two postures: as a managed service (Amazon Verified Permissions, which stores policies centrally and audits them across applications) and as embeddable open-source libraries you can run locally or offline. The **central policy store** is the operationally significant half for the garden's comparison: it is a single administrative surface where all policies live, can be audited together, and are changed by editing the store — the opposite of the ocap model, where authority is distributed as unforgeable references held by the parties that were granted them and there is no central registry to consult or audit.

## Verified Permissions and local use

**Amazon Verified Permissions** uses Cedar to let you manage fine-grained permissions in custom applications. With it you can **store Cedar policies centrally**, get low latency with millisecond processing, and **audit permissions across different applications**.

With the open-source libraries you can **test and validate Cedar policies on a local computer** before deploying them, and adapt the libraries for your own requirements — including use cases such as applications that are **disconnected from the network** (offline authorization, where the engine and policy set travel with the application).

Source: [Cedar, an open-source language for access control](https://aws.amazon.com/about-aws/whats-new/2023/05/cedar-open-source-language-access-control/) (AWS What's New, 2023-05-10), retrieved 2026-09-04, `source_content_sha256` `0eb61f66`.
