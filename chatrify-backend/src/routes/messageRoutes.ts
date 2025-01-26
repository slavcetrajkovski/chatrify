import { Router } from "express";
import { fetchAllMessagesByConversationId } from "../controllers/messageController";
import { verifyToken } from "../middlewares/authMiddleware";

const router = Router();

router.get("/:conversationId", verifyToken, fetchAllMessagesByConversationId);

export default router;
