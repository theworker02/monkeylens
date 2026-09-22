# Acquisition Brief â€” monkeylens

**Date:** 2026-09-22  
**Repository:** https://github.com/theworker02/monkeylens  
**Default branch:** `main`  
**Primary language:** Ruby  
**Status:** Diligence briefing only. **No acquisition has occurred** by virtue of this file.  
**License:** Proprietary â€” sale, written commercial license, or completed asset transfer required (see root `LICENSE`).  
**Valuation:** Not stated.  
**Contact:** GitHub [@theworker02](https://github.com/theworker02) Â· [thanks.dev/u/gh/theworker02](https://thanks.dev/u/gh/theworker02)

> Cloning or forking this repository does **not** grant production, redistribution, SaaS, OEM, or commercial rights.

---

## 1. Executive thesis

<img src="assets/brand/monkeylens-lockup.svg" alt="MonkeyLens Ã¢â‚¬â€ make runtime patches visible" width="760"> <strong>Audit monkey patches, method ownership, prepend layers, and Ruby runtime drift.</strong> <a href="https://github.com/theworker02/monkeylens/actions/workflows/ci.yml"><img alt="CI" src="https://github.com/theworker02/monkeylens/actions/workflows/ci.yml/badge.svg"></a>

**Why a buyer cares:** monkeylens packages transferable product IP â€” source, docs, in-repo brand assets, and a diligence room under `docs/acquisition/` â€” under a clear proprietary posture so diligence can proceed without mistaking the repo for open source.

---

## 2. Product snapshot

| Item | Detail |
|------|--------|
| Product | monkeylens |
| Repo | `theworker02/monkeylens` |
| Language | Ruby |
| Open source? | **No** â€” proprietary |
| Rightsholder | theworker02 |
| Diligence pack | `docs/acquisition/` |

### Capability highlights (from current materials)

- Which methods were added, removed, or redefined?
- Which module currently owns the method Ruby will dispatch?
- Did a `prepend` layer enter or leave the ancestor chain?
- Did arity, parameters, visibility, or source location change?
- Does CI boot with the same runtime shape as the approved baseline?
- Does not execute arbitrary project files unless explicitly passed with `--require`.
- Does not upload runtime information.
- Produces deterministic JSON for the same runtime state.
- Uses Ruby's public reflection APIs.
- Supports Ruby 3.2 and newer.
- [Configuration](docs/configuration.md)
- [Architecture](docs/architecture.md)

---

## 3. Problem / opportunity

Teams evaluating monkeylens typically need either (a) a commercial right to run or embed it, or (b) outright ownership of the Product IP for strategic build-out. Public GitHub visibility without a proprietary license creates false assumptions about free production use. This brief and the linked data room make the commercial path explicit.

---

## 4. What ships today

Honest maturity: treat repository contents, README claims, tests, and release tags as the source of truth. Do not assume production customers, ARR, filed patents, or SLAs unless separately evidenced in diligence.

Typical transferable surfaces:

- Source tree and build/test scripts present in-repo
- Documentation and design notes
- Acquisition / diligence markdown under `docs/acquisition/`
- Branding assets committed to the repository (if any)

---

## 5. Demo / evaluation path (buyer)

Minimal path (no secrets required unless README says otherwise):

```
```ruby
gem "monkey_lens"
```
```bash
bundle install
```
```bash
gem install monkey_lens
```
```yaml
targets:
  - String
  - Array
  - MyApp::User
fail_on: high
format: text
```
```bash
bundle exec monkeylens capture --output .monkeylens.json
```
```bash
bundle exec monkeylens check
```
```text
monkeylens capture   Capture a runtime baseline
monkeylens check     Compare the current runtime with a baseline
monkeylens diff      Compare two saved snapshots
monkeylens inspect   Explain one target's effective method table
monkeylens doctor    Validate configuration and runtime support
monkeylens version   Print the installed version
```
```bash
bundle exec monkeylens capture \
  --require ./config/environment \
  --output .monkeylens.json
```
```bash
bundle exec monkeylens check --format json
bundle exec monkeylens check --format sarif > monkeylens.sarif
```
```

Extended evaluation: `docs/acquisition/BUYER_EVALUATION.md`. Written NDA / evaluation grants may be required for private materials.

---

## 6. What a transaction typically includes

Subject to definitive schedules:

| Included (typical) | Excluded (typical) |
|--------------------|--------------------|
| Repo materials + asserted original IP | Seller personal accounts / unrelated repos |
| Docs + diligence room at closing | Third-party dependency source under separate licenses |
| In-repo brand marks as assigned | Secrets without rotation plan |
| Know-how captured in docs | Fabricated revenue, user, or adoption metrics |

---

## 7. Suggested deal structures

| Structure | When it fits |
|-----------|--------------|
| Non-exclusive commercial license | Deploy/run under seat or environment terms |
| Exclusive field-of-use license | Buyer wants exclusivity; seller may retain entity |
| Asset / IP assignment | Buyer wants ownership of Materials outright |
| OEM / redistribution | Separate agreement â€” not implied here |

Commercial terms (price, earnouts, escrow) are negotiated under NDA with counsel.

---

## 8. Buyer diligence checklist

- [ ] Confirm Rightsholder identity and authority to sell/license
- [ ] Inventory Materials (`docs/acquisition/ASSET_INVENTORY.md`)
- [ ] Review IP posture (`IP_PROVENANCE.md`) and dependencies (`DEPENDENCY_INVENTORY.md`)
- [ ] Run evaluation script (`BUYER_EVALUATION.md`)
- [ ] Review risks (`RISK_REGISTER.md`)
- [ ] Agree transfer scope (`TRANSFER_MANIFEST.md`) and handoff (`HANDOFF_CHECKLIST.md`)
- [ ] Supersede root `LICENSE` at closing via definitive agreement

---

## 9. Related documents

| Document | Purpose |
|----------|---------|
| `LICENSE` | Proprietary â€” no default grant |
| `docs/acquisition/README.md` | Data-room index |
| `docs/acquisition/EXECUTIVE_SUMMARY.md` | One-page thesis |
| `README.md` | Product overview |
| `SECURITY.md` | Vulnerability reporting |
| `COMMERCIAL.md` | Licensing contact path |
| `.github/FUNDING.yml` | Sponsors / thanks.dev |

---

## 10. Disclaimer

This package is informational and **does not** create a binding offer, grant of rights, or investment advice. Engage counsel for any transaction.

---

*Document version: 2.0.0 / 2026-09-22 Â· Classification: acquisition briefing*
