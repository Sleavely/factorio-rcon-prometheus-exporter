import { readFile } from 'node:fs/promises'
import { join } from 'node:path'
import { Rcon } from 'rcon-client'

export class FactorioRcon extends Rcon {
  private connected: boolean = false
  private metricsScript: string | undefined

  constructor (host: string, port: number, password: string) {
    super({
      host,
      port,
      password,
    })

    this.on('connect', this.onConnect)
    this.on('end', this.onDisconnect)
    this.on('error', this.onError)
  }

  getHostname (): string {
    return this.config.host + ':' + this.config.port
  }

  async runScript (script: string): Promise<string> {
    if (!this.connected) await this.connect()
    const response = await this.send('/sc ' + script)

    return response
  }

  async getMetrics (): Promise<string> {
    if (!this.connected) await this.connect()
    if (!this.metricsScript) {
      const scriptPath = join(__dirname, 'metrics.lua')
      const originalScript = await readFile(scriptPath, 'utf-8')
      // replace occurrences of process.env.VARIABLE with the actual environment variable values
      this.metricsScript = originalScript.replaceAll(/process\.env\.(\w+)/g, (substr, environmentVariable) => {
        // eslint-disable-next-line @sleavely/js-rules/destructure-env, @sleavely/js-rules/uppercase-env
        return JSON.stringify(process.env[environmentVariable] ?? substr)
      })
    }
    return await this.runScript(this.metricsScript)
  }

  onConnect = (): void => {
    this.connected = true
  }

  onDisconnect = (): void => {
    this.connected = false
  }

  onError = (error: unknown): void => {
    console.log(error)
  }
}
