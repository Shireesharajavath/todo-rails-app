import axios from "axios";
import { rpc } from './rpc_config.js';




rpc.register({
  name: 'fetchTodos',
  arguments: {
    api_key: { type: 'string', description: 'API Key', required: true },
  },
  implementation: async (args, context) => {
    try {
      const response = await axios.get('http://localhost:3000/todos', {
        headers: { Authorization: `Bearer ${args.api_key}` },
      });

      return { success: true, todos: response.data };
    } catch (error) {
      return { success: false, error: error.response?.data || error.message };
    }
  },
});


rpc.register({
  name: 'createTodo',
  arguments: {
    title: { type: 'string', description: 'Title', required: true },
    description: { type: 'string', description: 'Description', required: true },
    created_at : { type: 'string', description: 'Creation Date', required: false },
    updated_at : { type: 'string', description: 'Update Date', required: false },
    priority : { type: 'string', description: 'Priority', required: false },
    api_key: { type: 'string', description: 'API Key', required: true },
    status: { type: 'string', description: 'Status', required: false } // New argument for
  },
  implementation: async (args, context) => {
    try {
      const response = await axios.post(
        'http://localhost:3000/todos',
        { todo: { title: args.title, description: args.description } },
        { headers: { Authorization: `Bearer ${args.api_key}` } }
      );

      return { success: true, todo: response.data };
    } catch (error) {
      return { success: false, error: error.response?.data || error.message };
    }
  },
});


rpc.register({
  name: 'updateTodo',
  arguments: {
    id: { type: 'string', description: 'Todo ID', required: true },
    title: { type: 'string', description: 'Title', required: false },
    description: { type: 'string', description: 'Description', required: false },
    created_at : { type: 'string', description: 'Creation Date', required: false },
    updated_at : { type: 'string', description: 'Update Date', required: false },
    priority : { type: 'string', description: 'Priority', required: false },
    status: { type: 'string', description: 'Status', required: false },
    api_key: { type: 'string', description: 'API Key', required: true }
  },
  implementation: async (args, context) => {
    try {
      const response = await axios.put(
        `http://localhost:3000/todos/${args.id}`,
        { todo: { title: args.title, description: args.description, completed: args.completed } },
        { headers: { Authorization: `Bearer ${args.api_key}` } }
      );

      return { success: true, updatedTodo: response.data };
    } catch (error) {
      return { success: false, error: error.response?.data || error.message };
    }
  },
});


rpc.register({
  name: 'deleteTodo',
  arguments: {
    api_key: { type: 'string', description: 'API Key', required: true },
    id: { type: 'string', description: 'Todo ID', required: true }
  },
  implementation: async (args, context) => {
    try {
      await axios.delete(`http://localhost:3000/todos/${args.id}`, {
        headers: { Authorization: `Bearer ${args.api_key}` },
      });

      return { success: true, message: 'Todo deleted successfully.' };
    } catch (error) {
      return { success: false, error: error.response?.data || error.message };
    }
  },
});

rpc.register({
  name: 'getApiKeyByEmail',
  arguments: {
    email: { type: 'string', description: 'User email', required: true },
  },
  implementation: async (args, context) => {
    try {
      // Call your Rails endpoint
      const response = await axios.post(
        'http://localhost:3000/get_api_key', 
        { email: args.email }
      );

      // Check if the response has the user and api_key
      const user = response.data?.user;
      if (response.data.success && user?.api_key) {
        return { success: true, api_key: user.api_key };
      } else {
        return { success: false, error: response.data.error || 'API key not found for this email' };
      }
    } catch (error) {
      return {
        success: false,
        error: error.response?.data?.error || error.message || 'Unknown error',
      };
    }
  },
});


