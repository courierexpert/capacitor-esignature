export interface EsignaturePlugin {
  initialise(): Promise<any>;
  clearSignature(): Promise<any>;
}
