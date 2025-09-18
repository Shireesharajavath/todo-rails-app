import { RetoolRPC } from "retoolrpc";

export const rpc = new RetoolRPC({
  apiToken: 'retool_01k0evfddn0begk04435phht6t',   
  host: 'https://zetaglobalcustomerengineeringintern.retool.com',
  resourceId: '6e6c9b04-b2f6-49ba-a7d0-1711e96efad8',
  environmentName: 'production',
  pollingIntervalMs: 1000,
  version: '0.0.1',
  logLevel: 'info',
});
