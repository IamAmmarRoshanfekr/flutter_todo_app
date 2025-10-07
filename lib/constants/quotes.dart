import 'dart:math';

final List<Map<String, String>> motivationalQuotes = [
  {
    "quote": "Believe you can and you're halfway there.",
    "author": "Theodore Roosevelt",
  },
  {
    "quote": "Don't watch the clock; do what it does. Keep going.",
    "author": "Sam Levenson",
  },
  {
    "quote":
        "Success doesn't come from what you do occasionally, it comes from what you do consistently.",
    "author": "Marie Forleo",
  },
  {
    "quote": "The future depends on what you do today.",
    "author": "Mahatma Gandhi",
  },
  {"quote": "Dream big. Work hard. Stay focused.", "author": "Unknown"},
  {
    "quote": "Push yourself, because no one else is going to do it for you.",
    "author": "Unknown",
  },
  {
    "quote": "Great things never come from comfort zones.",
    "author": "Roy T. Bennett",
  },
  {
    "quote": "Discipline is the bridge between goals and accomplishment.",
    "author": "Jim Rohn",
  },
  {
    "quote":
        "It's not about being the best. It's about being better than you were yesterday.",
    "author": "Unknown",
  },
  {"quote": "Your only limit is your mind.", "author": "Unknown"},
  {
    "quote": "Wake up with determination. Go to bed with satisfaction.",
    "author": "George Lorimer",
  },
  {
    "quote": "Do something today that your future self will thank you for.",
    "author": "Sean Patrick Flanery",
  },
  {
    "quote":
        "The harder you work for something, the greater you’ll feel when you achieve it.",
    "author": "Unknown",
  },
  {
    "quote": "Success is what comes after you stop making excuses.",
    "author": "Luis Galarza",
  },
  {"quote": "Small steps every day lead to big results.", "author": "Unknown"},
  {"quote": "Stay positive. Work hard. Make it happen.", "author": "Unknown"},
  {
    "quote": "You don’t have to be extreme, just consistent.",
    "author": "Unknown",
  },
  {"quote": "Fall seven times, stand up eight.", "author": "Japanese Proverb"},
  {
    "quote": "Action is the foundational key to all success.",
    "author": "Pablo Picasso",
  },
  {
    "quote": "You are capable of more than you know.",
    "author": "Glenda Jackson",
  },
];

Map<String, String> getRandomQuote() {
  final random = Random();
  return motivationalQuotes[random.nextInt(motivationalQuotes.length)];
}
