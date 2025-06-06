#!/usr/bin/env node
import { FactorioRcon } from '../src/rcon'

const {
  /**
   * IP or Hostname for the RCON server
   */
  RCON_HOST = '0.0.0.0',
  /**
   * RCON port
   */
  RCON_PORT = '27015',
  /**
   * RCON password
   */
  RCON_PASSWORD = '',
} = process.env

;(async () => {
  const rcon = new FactorioRcon(RCON_HOST, parseInt(RCON_PORT, 10), RCON_PASSWORD)
  const metrics = await rcon.getMetrics()
  await rcon.end()
  console.log(metrics)
})().catch(e => {
  console.error(e)
  process.exit(1)
})
