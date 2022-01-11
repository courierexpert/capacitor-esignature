import { WebPlugin } from '@capacitor/core';

import type { EsignaturePlugin } from './definitions';

export class EsignatureWeb extends WebPlugin implements EsignaturePlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
