import OpenAI from "openai";
import { openAIKey } from "../config";

const openai = new OpenAI({
  apiKey: openAIKey,
});

export const generateDailyQuestion = async (): Promise<string> => {
  try {
    const response = await openai.chat.completions.create({
      model: "gpt-3.5-turbo",
      messages: [
        {
          role: "user",
          content:
            "Generate a fun and engaging daily question for a chat conversation.",
        },
      ],
      max_tokens: 50,
    });

    console.log("generateDailyQuestion - openAI called: ");
    console.log(response.choices[0]?.message?.content);

    return (
      response.choices[0]?.message?.content?.trim() ||
      "What's your favorite hobby?"
    );
  } catch (error) {
    console.error("Error generating daily question:", error);
    const questions = [
      "What's your favorite book?",
      "What's your dream travel destination?",
      "What's your happiest childhood memory?",
      "What motivates you every day?",
      "What's your favorite movie of all time?",
      "If you could have dinner with any historical figure, who would it be?",
      "What's the best advice you've ever received?",
      "What's your go-to comfort food?",
      "What's a skill you'd like to learn?",
      "What's your favorite way to spend a weekend?",
      "What’s the most memorable gift you’ve ever received?",
      "What inspires your creativity?",
      "If you won the lottery, what would you do first?",
      "What’s your favorite type of music or artist?",
      "If you could live anywhere in the world, where would it be?",
      "What’s one goal you’re working on right now?",
      "If you could switch lives with anyone for a day, who would it be?",
      "What’s the most adventurous thing you’ve done?",
      "What’s your favorite holiday or celebration?",
      "What’s a random fact about yourself?",
      "If you could master any instrument, what would it be?",
      "What’s a book or show you’ve recently enjoyed?",
      "What’s your favorite outdoor activity?",
      "What’s your biggest accomplishment so far?",
      "What’s a small thing that makes you happy?",
      "What’s your favorite type of cuisine?",
      "If you could have any superpower, what would it be?",
      "What’s something you’re grateful for today?",
      "What’s a dream you’ve had but haven’t pursued yet?",
      "If you could relive any moment, what would it be?",
    ];

    const randomQuestion =
      questions[Math.floor(Math.random() * questions.length)];
    return randomQuestion;
  }
};
