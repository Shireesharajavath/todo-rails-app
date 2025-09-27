import axios from "axios";
import { rpc } from "./rpc_config.js";

/**************** TODOS RPCs ****************/

rpc.register({
  name: "fetchTodos",
  arguments: {
    api_key: { type: "string", required: true, description: "User API Key" },
    page: { type: "number", required: false, description: "Page number" },
    per_page: { type: "number", required: false, description: "Items per page" }
  },
  implementation: async (args) => {
    try {
      const res = await axios.get("http://localhost:3000/api/todos", {
        params: {
          page: args.page || 1,
          per_page: args.per_page || 10
        },
        headers: {
          Authorization: `Bearer ${args.api_key}`
        }
      });

      return {
        success: true,
        todos: res.data.todos,
        pagination: res.data.pagination
      };
    } catch (err) {
      return {
        success: false,
        error: err.response?.data || err.message
      };
    }
  },
});

// ✅ Create a Todo
rpc.register({
  name: "createTodo",
  arguments: {
    title: { type: "string", required: true },
    description: { type: "string", required: true },
    priority: { type: "string" },
    status: { type: "string" },
    scheduled_time: { type: "string" },
    expected_completion: { type: "string" },
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

// ✅ Update a Todo
rpc.register({
  name: "updateTodo",
  arguments: {
    id: { type: "string", required: true },
    title: { type: "string" },
    description: { type: "string" },
    priority: { type: "string" },
    status: { type: "string" },
    scheduled_time: { type: "string" },
    expected_completion: { type: "string" },
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

// ✅ Delete a Todo
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

/**************** AUTH RPCs ****************/

// ✅ Login
rpc.register({
  name: "login",
  arguments: {
    email: { type: "string", required: true },
    password: { type: "string", required: true },
  },
  implementation: async (args) => {
    try {
      const res = await axios.post("http://localhost:3000/api/login", {
        email: args.email,
        password: args.password,
      });
      if (res.data.success && res.data.api_key) {
        return { success: true, api_key: res.data.api_key };
      } else {
        return { success: false, error: res.data.error || "Login failed" };
      }
    } catch (err) {
      return { success: false, error: err.response?.data || err.message };
    }
  },
});

rpc.register({
  name: "signup",
  arguments: {
    name: { type: "string", required: true },
    email: { type: "string", required: true },
    password: { type: "string", required: true },
    password_confirmation: { type: "string", required: true },
  },
  implementation: async (args) => {
    try {
      const res = await axios.post("http://localhost:3000/api/signup", {
        name: args.name,
        email: args.email,
        password: args.password,
        password_confirmation: args.password_confirmation,
      }, {
        headers: { "Content-Type": "application/json" },
      });

      if (res.data.success && res.data.user?.api_key) {
        return { success: true, api_key: res.data.user.api_key };
      } else {
        return { success: false, error: res.data.error || res.data.message || "Signup failed" };
      }
    } catch (err) {
      return { success: false, error: err.response?.data || err.message };
    }
  },
});


// ✅ Get Users
rpc.register({
  name: "getUsers",
  arguments: {
    api_key: { type: "string", required: true },
  },
  implementation: async (args) => {
    try {
      const res = await axios.get("http://localhost:3000/api/users", {
        headers: { Authorization: `Bearer ${args.api_key}` },
      });
      return { success: true, users: res.data.users };
    } catch (err) {
      return { success: false, error: err.response?.data || err.message };
    }
  },
});

// ✅ Logout (frontend-only)
rpc.register({
  name: "logout",
  arguments: {},
  implementation: async () => {
    return { success: true, message: "Logout successful (frontend only)" };
  },
});
