# Vendored schemas

`zerops-yml.schema.json` is Zerops' own schema for `zerops.yml`, fetched from
<https://api.app-prg1.zerops.io/api/rest/public/settings/zerops-yml-json-schema.json>.

It is vendored rather than fetched at check time for two reasons. A check that
reaches the network fails when the network does, and a check validating against
a schema that moves goes red without anything in this repository having
changed.

Refresh it with:

```bash
pnpm schema:refresh
```

Fetched on 2026-09-21.
