import { registerPlugin } from '@capacitor/core';

import type { EsignaturePlugin } from './definitions';

const Esignature = registerPlugin<EsignaturePlugin>('Esignature', {
  web: () => import('./web').then(m => new m.EsignatureWeb()),
});

export * from './definitions';
export { Esignature };
