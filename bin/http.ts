#!/usr/bin/env node
import express from 'express'
import { FactorioRcon } from '../src/rcon'

const {
  /**
   * Host to bind the HTTP server to
   */
  HOST = '0.0.0.0',
  /**
   * Port for the HTTP server
   */
  PORT = '3000',
  /**
   * IP or Hostname for the RCON server
   */
  RCON_HOST = 'localhost',
  /**
   * RCON port
   */
  RCON_PORT = '27015',
  /**
   * RCON password
   */
  RCON_PASSWORD = '',
} = process.env

const app = express()
const rcon = new FactorioRcon(RCON_HOST, parseInt(RCON_PORT, 10), RCON_PASSWORD)

app.get('/', (_req, res) => {
  res.send(`<html lang="en">
  <head>
    <title>Factorio RCON Prometheus Exporter</title>
  </head>
  <body>
    <h1>Factorio RCON Prometheus Exporter</h1>
    <p><a href="/metrics">Metrics</a></p>
  </body>
</html>
`)
})

app.get('/metrics', (_req, res) => {
  rcon.getMetrics()
    .then((metrics) => {
      // res.set('Content-Type', 'plain/text')
      res.end(metrics)
    })
    .catch((err: unknown) => {
      console.error(err)
      if (err instanceof Error) {
        res.status(500).end(`# ${err.message}`)
      } else {
        res.status(500).end(`# ${String(err)}`)
      }
    })
})

app.listen(parseInt(PORT, 10), HOST, () => {
  console.log(`Server running at http://${HOST}:${PORT}/`)
})

// Listen for SIGINT (Ctrl+C) and SIGTERM (docker stop)
process.on('SIGINT', () => {
  process.exit()
})
process.on('SIGTERM', () => {
  process.exit()
})
