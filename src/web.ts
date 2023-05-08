import { WebPlugin } from '@capacitor/core';

import type { EsignaturePlugin } from './definitions';

export class EsignatureWeb extends WebPlugin implements EsignaturePlugin {
  async initialise(): Promise<any> {

    return new Promise( (resolve) => {
      resolve("Not implemented")
    });

  }
  async clearSignature(): Promise<any> {

    return new Promise( (resolve) => {
      resolve("Not implemented")
    });

  }
}
