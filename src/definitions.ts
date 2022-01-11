export interface EsignaturePlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
