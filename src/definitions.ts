export interface EsignaturePlugin {
  initialise(): Promise<any>;
  clear(): Promise<any>;
}
