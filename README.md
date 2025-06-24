# factorio-rcon-prometheus-exporter

A Prometheus Exporter that generates metrics by connecting to a Factorio server over RCON and executing a Lua script.

[ ![npm version](https://img.shields.io/npm/v/factorio-rcon-prometheus-exporter.svg?style=flat) ](https://npmjs.org/package/factorio-rcon-prometheus-exporter "View this project on npm") [ ![Docker Image Version](https://img.shields.io/docker/v/sleavely/factorio-rcon-prometheus-exporter?label=Docker)
](https://hub.docker.com/r/sleavely/factorio-rcon-prometheus-exporter) [ ![Issues](https://img.shields.io/github/issues/Sleavely/factorio-rcon-prometheus-exporter.svg?label=Github+issues) ](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/issues)

![Sample Grafana dashboard using the metrics recorded by factorio-rcon-prometheus-exporter](https://i.imgur.com/77quJe2.png)

## Usage

> [!CAUTION]
> This will disable achievements because Factorio does not differentiate between reading and writing when using the Lua API.

With Docker Compose:

```yaml
  factorio-rcon-prometheus-exporter:
    image: sleavely/factorio-rcon-prometheus-exporter:latest
    restart: unless-stopped
    environment:
      # HTTP server options for Prometheus to scrape
      - HOST=0.0.0.0
      - PORT=9772
      # Factorio RCON params
      - RCON_HOST=my-factorio-server
      - RCON_PORT=27015
      - RCON_PASSWORD=
```

Then, in your Prometheus configuration:

```yaml
scrape_configs:
  - job_name: factorio
    scrape_interval: 60s
    static_configs:
    - targets:
      - factorio-rcon-prometheus-exporter:9772
```

## Related

These repositories also export metrics using the RCON approach:

- [janten/factorio-stats](https://github.com/janten/factorio-stats)
- [Duko/factorio-rcon-prom](https://github.com/Duko/factorio-rcon-prom)

The more popular approach and most complete exporter requires you to install a mod:

- [remijouannet/graftorio2](https://github.com/remijouannet/graftorio2) which
