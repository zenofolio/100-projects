import { cn } from "@heroui/theme";
import { Icon } from "@iconify/react";
import { Button } from "@heroui/button";
import { Input } from "@heroui/input";
import { Select, SelectItem } from "@heroui/select";
import { Divider } from "@heroui/divider";
import { useEffect, useMemo, useState } from "react";
import { useNavigate } from "react-router-dom";

import { DEFAULT_RADIUS } from "@/config/defaults";
import { iconSizes } from "@/config/sizes";
import { icons } from "@/config/icons";
import { roomsData } from "@/data/rooms";
import { $string } from "@/common/utils/validation";
import useRoom from "@/hooks/useRoom";
import useHandler from "@/hooks/useHandler";
import { routes } from "@/config/routes";

export default function IndexPage() {
  const hand = useHandler();
  const navigate = useNavigate();

  const [username, setUsername] = useState<string | undefined>();
  const [room, setRoom] = useState(roomsData?.[0].key);

  const { join, state } = useRoom();

  const isValid = useMemo(() => {
    if (!$string(username) || !$string(room)) return false;

    return true;
  }, [username, room]);

  useEffect(() => {
    if (state.joined && state.room) navigate(routes.room(state.room));
  }, [state.joined]);

  ///////////////////////
  /// Handlers
  //////////////////////

  const handleJoinRoom = async () => {
    if (!isValid) return;
    await hand.run(join(room, username!));
  };

  return (
    <div
      className={cn([
        "w-screen min-h-screen bg-content2",
        "flex justify-center items-center",
      ])}
    >
      <div
        className={cn(
          "flex flex-col gap-4 max-w-md bg-content1",
          "justify-center items-center",
          "w-full mx-auto",
          "p-4 lg:p-6",
          DEFAULT_RADIUS,
        )}
      >
        <Icon icon={icons.chat} width={iconSizes.lg} />

        <div className="flex flex-col gap-2 text-center">
          <h1 className="text-2xl font-semibold">SuperChat</h1>
          <p className="text-lg text-default-500">
            Just join a F** room and have fun!
          </p>
        </div>

        <Divider className="my-4" />

        <div className="flex flex-col gap-4 w-full">
          <Input
            className="w-full"
            isDisabled={hand.isLoading}
            label="Username"
            labelPlacement="outside"
            placeholder="Insert username"
            size="lg"
            value={username}
            variant="faded"
            onValueChange={setUsername}
          />

          <Select
            className="w-full"
            isDisabled={hand.isLoading}
            items={roomsData}
            label="Room"
            labelPlacement="outside"
            placeholder="Choose a room"
            selectedKeys={room ? [room] : []}
            size="lg"
            variant="faded"
            onSelectionChange={(v) => {
              if (v.currentKey) setRoom(v.currentKey);
            }}
          >
            {(item) => <SelectItem key={item.key}>{item.name}</SelectItem>}
          </Select>
        </div>

        <Button
          className="w-full mt-4 lg:mt-6"
          color="primary"
          isDisabled={!isValid}
          isLoading={hand.isLoading}
          radius="full"
          size="lg"
          onPress={handleJoinRoom}
        >
          Join Room
        </Button>
      </div>
    </div>
  );
}
