import { readFile } from 'node:fs/promises'
import { join } from 'node:path'
import { Rcon } from 'rcon-client'

export class FactorioRcon extends Rcon {
  public connected: boolean = false

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
    const scriptPath = join(__dirname, 'metrics.lua')
    const script = await readFile(scriptPath, 'utf-8')
    return await this.runScript(script)
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
