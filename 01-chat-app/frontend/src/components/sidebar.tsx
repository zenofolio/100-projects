import { Button } from "@heroui/button";
import { Divider } from "@heroui/divider";
import { cn } from "@heroui/theme";
import { Icon } from "@iconify/react/dist/iconify.js";

import UserNavComponent from "./user-nav";

import { iconSizes } from "@/config/sizes";
import { icons } from "@/config/icons";
import useRoom from "@/hooks/useRoom";

export default function Sidebar() {
  const { state, roomData } = useRoom();

  if (!state.joined) return null;

  return (
    <aside
      className={cn(
        "w-full flex-1 flex flex-col justify-between gap-4 max-w-[250px]",
        "bg-content1",
        "h-screen",
      )}
    >
      <div className="w-full">
        <div
          className={cn([
            "flex flex-col justify-center items-center gap-4",
            " w-full text-center p-4 ",
          ])}
        >
          <Icon icon={icons.chat} width={iconSizes.lg} />
          <div>
            <h1 className="text-2xl font-semibold">{state.room}</h1>
            <h2 className="font-light text-lg">@{state.username}</h2>
          </div>
        </div>
        <Divider className="my-4" />

        {roomData && (
          <div className="flex flex-col px-4">
            <span className="text-default-500">Users</span>
            <ul className="list-users">
              {roomData.users.map((item) => (
                <li key={item.username} className="flex items-center gap-2">
                  <UserNavComponent user={item} />
                </li>
              ))}
            </ul>
          </div>
        )}
      </div>

      <div className="flex  gap-4 p-4">
        <Button
          className="w-full"
          color="danger"
          startContent={<Icon icon={icons.logout} width={iconSizes.base} />}
          variant="flat"
        >
          Leave Room
        </Button>
      </div>
    </aside>
  );
}
