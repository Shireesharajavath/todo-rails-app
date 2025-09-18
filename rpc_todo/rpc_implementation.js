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
    api_key: { type: 'string', description: 'API Key', required: true },
    title: { type: 'string', description: 'Title', required: true },
    description: { type: 'string', description: 'Description', required: true },
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
    api_key: { type: 'string', description: 'API Key', required: true },
    id: { type: 'string', description: 'Todo ID', required: true },
    title: { type: 'string', description: 'Title', required: false },
    description: { type: 'string', description: 'Description', required: false },
    completed: { type: 'boolean', description: 'Completed', required: false },
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
    id: { type: 'string', description: 'Todo ID', required: true },
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
  name: 'getUserById',
  arguments: {
    user_id: { type: 'string', description: 'User ID', required: true },
  },
  implementation: async (args, context) => {
    try {
      const response = await axios.get(`http://localhost:3000/users/${args.user_id}`);

      return { success: true, user: response.data.user };
    } catch (error) {
      return { success: false, error: error.response?.data || error.message };
    }
  },
});
