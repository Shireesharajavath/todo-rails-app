import { rpc } from './rpc_config.js';
import './rpc_implementation.js';  

rpc.listen();
console.log(' Retool RPC Backend is running...');
