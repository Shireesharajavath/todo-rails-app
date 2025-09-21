import axios from "axios";
import { rpc } from "./rpc_config.js";

// ---------------- TODO CRUD ----------------

rpc.register({
  name: "fetchTodos",
  arguments: {
    api_key: { type: "string", required: true, description: "API Key" },
  },
  implementation: async (args) => {
    try {
      const res = await axios.get("http://localhost:3000/todos", {
        headers: { Authorization: `Bearer ${args.api_key}` },
      });
      return { success: true, todos: res.data };
    } catch (err) {
      return { success: false, error: err.response?.data || err.message };
    }
  },
});

rpc.register({
  name: "createTodo",
  arguments: {
    title: { type: "string", required: true },
    description: { type: "string", required: true },
    priority: { type: "string", required: false },
    status: { type: "string", required: false },
    scheduled_time: { type: "string", required: false },
    expected_completion: { type: "string", required: false },
    api_key: { type: "string", required: true },
  },
  implementation: async (args) => {
    try {
      const res = await axios.post(
        "http://localhost:3000/todos",
        {
          todo: {
            title: args.title,
            description: args.description,
            priority: args.priority,
            status: args.status,
            scheduled_time: args.scheduled_time,
            expected_completion: args.expected_completion,
          },
        },
        { headers: { Authorization: `Bearer ${args.api_key}` } }
      );
      return { success: true, todo: res.data };
    } catch (err) {
      return { success: false, error: err.response?.data || err.message };
    }
  },
});

rpc.register({
  name: "updateTodo",
  arguments: {
    id: { type: "string", required: true },
    title: { type: "string", required: false },
    description: { type: "string", required: false },
    priority: { type: "string", required: false },
    status: { type: "string", required: false },
    scheduled_time: { type: "string", required: false },
    expected_completion: { type: "string", required: false },
    api_key: { type: "string", required: true },
  },
  implementation: async (args) => {
    try {
      const res = await axios.put(
        `http://localhost:3000/todos/${args.id}`,
        {
          todo: {
            title: args.title,
            description: args.description,
            priority: args.priority,
            status: args.status,
            scheduled_time: args.scheduled_time,
            expected_completion: args.expected_completion,
          },
        },
        { headers: { Authorization: `Bearer ${args.api_key}` } }
      );
      return { success: true, updatedTodo: res.data };
    } catch (err) {
      return { success: false, error: err.response?.data || err.message };
    }
  },
});

rpc.register({
  name: "deleteTodo",
  arguments: {
    id: { type: "string", required: true },
    api_key: { type: "string", required: true },
  },
  implementation: async (args) => {
    try {
      await axios.delete(`http://localhost:3000/todos/${args.id}`, {
        headers: { Authorization: `Bearer ${args.api_key}` },
      });
      return { success: true, message: "Todo deleted successfully" };
    } catch (err) {
      return { success: false, error: err.response?.data || err.message };
    }
  },
});


rpc.register({
  name: "getApiKeyByEmail",
  arguments: {
    email: { type: "string", required: true },
  },
  implementation: async (args) => {
    try {
      const res = await axios.post("http://localhost:3000/get_api_key", { email: args.email });
      const user = res.data?.user;
      if (res.data.success && user?.api_key) {
        return { success: true, api_key: user.api_key };
      } else {
        return { success: false, error: res.data.error || "API key not found" };
      }
    } catch (err) {
      return { success: false, error: err.response?.data?.error || err.message || "Unknown error" };
    }
  },
});
