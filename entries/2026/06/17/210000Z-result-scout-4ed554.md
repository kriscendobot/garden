---
ts: 2026-06-17T21:00:00Z
kind: result
role: scout
host: endolinbot
project: endo-but-for-bots
to: "*"
short_id: 4ed554
refs:
  - entries/2026/06/17/195115Z-dispatch-scout-4ed554.md
  - entries/2026/06/17/203500Z-result-scout-6224bd.md
---

# result: scout — marketplace artifact recon (AWS-first; Azure + GCP parallel later)

Substantive report at
`entries/2026/06/17/203500Z-result-scout-6224bd.md`
(~6,800 words, 936 lines).

## Headline finding

**AWS Marketplace single-AMI is the natural MVP listing**
for the Capability Bridge (not SaaS, not AMI+CFT, not
container variant). Maps directly onto v11's self-custody
promise and the gateway-package design's "one factory, many
configurations" property.

OS-level substrate already exists: PRs #410 (CLI + systemd)
and #412 (.deb / .rpm / PKGBUILD / Dockerfile / Homebrew).
Same OS image works AWS / Azure / GCP; only the outer
wrapper + metering adapter differ.

## Three gating gaps for AWS submission

- **G-tls-firstboot**: bundled Caddy + ACME with
  vendor-delegated DNS-01.
- **G-firstboot**: out-of-band bearer delivery via cloud
  user-data / serial console.
- **G-resource-classes**: the AWS MeterUsage dimension lock
  is the ONLY irreversible commercial decision in O1.
  15-char alphanumeric limit on dimension names —
  `computrons` (10 chars) survives; `cogitrons` (9 chars)
  survives. Must lock the dimension catalog before submit.

## Recommended sequencing

- **Months 0-3**: AWS-first single-AMI listing.
- **Months 3-5**: parallel Azure VHD + GCP GCE listings
  (after AWS is live).
- **Months 5-8**: G-upgrade TUF channel before AWS
  continuous-compliance forces re-submission.
- **Later**: O2 SaaS listings on all three for the Hub.

**Not engage-all-three at MVP** — per-cloud metering
integrations + three simultaneous dimension locks would
magnify any design mistake threefold.

## Seven open questions for maintainer

1. Companion scholar (302d34) still in flight at scout
   write time; Azure / GCP sections need verification when
   scholar's shelf lands.
2. Confirm AMI is the MVP product type (not SaaS).
3. Single-AMI vs AMI+CFT at launch.
4. Custom Metering at launch vs Paid Hourly with Custom
   Metering as v1.1 follow-up.
5. Vendor-delegated DNS for TLS first-boot requires the
   publisher to operate a DNS service for the lifetime of
   every issued node — contradicts the non-custodian
   posture in spirit. (Worth a separate design pass.)
6. Marketplace seller registration needs a commercial-
   entity identity distinct from the maintainer's personal
   identity.
7. Service-adapter choice for MVP (scout recommends
   GitHub).

## Scout's self-improvement signal

Scout and scholar dispatched in the same minute → scout
wrote before scholar's library shelving arrived → scout had
to do its own web research. Recommendation: serial dispatch
(scholar first, then scout) so scout can cite scholar refs
cleanly. Flagged for gardener if pattern recurs.

Dispatch root torn down.
