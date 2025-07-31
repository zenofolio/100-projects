import { Route, Routes } from "react-router-dom";

import { routes } from "./config/routes";
import ChatRoomPage from "./pages/room";

import IndexPage from "@/pages/index";

function App() {
  return (
    <Routes>
      <Route element={<IndexPage />} path={routes.home} />
      <Route element={<ChatRoomPage />} path={routes.room(":id")} />
    </Routes>
  );
}

export default App;
