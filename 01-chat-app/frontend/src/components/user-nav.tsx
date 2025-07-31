import {
  Dropdown,
  DropdownItem,
  DropdownMenu,
  DropdownTrigger,
} from "@heroui/dropdown";
import { Button } from "@heroui/button";
import { Icon } from "@iconify/react/dist/iconify.js";

import { SocketUser } from "@/types/socket";
import { icons } from "@/config/icons";
import { iconSizes } from "@/config/sizes";

export interface UserNavComponentProps {
  user: SocketUser;
}

export default function UserNavComponent({ user }: UserNavComponentProps) {
  return (
    <Dropdown>
      <DropdownTrigger>
        <Button
          className="p-2 max-h-max w-full justify-between"
          endContent={<Icon icon={icons.arrowDown} width={iconSizes.sm} />}
          variant="light"
        >
          <div className="flex gap-4 items-center">
            <div className="size-2 rounded-full bg-green-600" />
            {user.username}
          </div>
        </Button>
      </DropdownTrigger>
      <DropdownMenu>
        <DropdownItem
          key="private"
          description="create private room"
          startContent={
            <Icon
              className="text-warning"
              icon={icons.plain}
              width={iconSizes.base}
            />
          }
          title="Send Private"
        />
      </DropdownMenu>
    </Dropdown>
  );
}
