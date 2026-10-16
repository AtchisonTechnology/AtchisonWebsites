# Site Registry

The sites in this monorepo and each one's local dev port. Every site has its
own fixed port so all of them can run at once (`make dev`). The port is set in
`<Site>/bin/dev` and `<Site>/config/puma.rb`; `BRIDGETOWN_PORT` overrides it.

| Site (directory) | Live URL | Status | Dev port |
|---|---|---|---|
| `LeeAtchison` | leeatchison.com | Active | 3000 |
| `TheSoftwareConductor` | thesoftwareconductor.com | Active | 8000 |
| `stosa` | stosa.org | Active | 10000 |
| `BusinessBreakthrough30` | businessbreakthrough30.com | Active | 12000 |
| `ArchitectingForScale` | architectingforscale.com | Active | 14000 |
| `AtchisonAcademy` | atchisonacademy.com | Active | 16000 |
| `AtchisonAcademyCourses` | _(removed)_ | **Retired 2026-09-20** | — |
| `SoftwareArchitectureInsights` | softwarearchitectureinsights.com | Active | 20000 |

A new site takes the next unused block (22000 next).
