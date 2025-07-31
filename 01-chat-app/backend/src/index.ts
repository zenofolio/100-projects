import chatApp from "./apps/chat-app";
import { http, io, app } from "./servers";

async function main() {
  await chatApp(io);

  app.get("/", (req, res) => {
    res.json({
      message: "Hello World",
    });
  });

  http.listen(3000, () => {
    console.log("Listening on http://localhost:3000");
  });
}

main().catch(console.error);
