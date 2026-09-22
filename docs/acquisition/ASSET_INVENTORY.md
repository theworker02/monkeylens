# Asset inventory â€” monkeylens

## Repository surfaces

| Asset | Location / notes |
|-------|------------------|
| Source tree | Repository root / language packages |
| Tests | `test/`, `tests/`, CI workflows if present |
| Docs | `README.md`, `docs/` |
| Diligence room | `docs/acquisition/` |
| License / notices | `LICENSE`, transition notices if present |
| Funding | `.github/FUNDING.yml` |
| CI | `.github/workflows/` if present |
| Branding | logos/assets folders if present |

## Capability highlights

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

## Usually excluded

Seller personal accounts, unrelated repos, and unreissued registry tokens â€” unless listed in the definitive agreement.

*Updated: 2026-09-22*
