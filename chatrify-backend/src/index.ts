import express from "express";
import { json } from "body-parser";
import authRoutes from "./routes/authRoutes";
import conversationRoutes from "./routes/conversationRoutes";
import messageRoutes from "./routes/messageRoutes";
import http from "http";
import { Server } from "socket.io";
import { error } from "console";
import { saveMessage } from "./controllers/messageController";
import contactRoutes from "./routes/contactRoutes";
import "./cron/cronJob";

const app = express();

const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: "*",
  },
});

app.use(json());

app.use("/auth", authRoutes);
app.use("/conversations", conversationRoutes);
app.use("/messages", messageRoutes);
app.use("/contacts", contactRoutes);

io.on("connection", (socket) => {
  console.log("A user connected:", socket.id);

  socket.on("joinConversation", (conversationId) => {
    socket.join(conversationId);
    console.log("User joined conversation: " + conversationId);
  });

  socket.on("sendMessage", async (message) => {
    const { conversationId, senderId, content } = message;

    try {
      const savedMessage = await saveMessage(conversationId, senderId, content);
      console.log("snedMessage: ");
      console.log(savedMessage);

      io.to(conversationId).emit("newMessage", savedMessage);

      io.emit("conversationUpdated", {
        conversationId,
        lastMessage: savedMessage.content,
        lastMessageTime: savedMessage.created_at,
      });
    } catch (err) {
      console.error("Failed to save message:", error);
    }
  });

  socket.on("disconnect", () => {
    console.log("User disconnected: ", socket.id);
  });
});

const PORT = process.env.PORT || 6000;
server.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
