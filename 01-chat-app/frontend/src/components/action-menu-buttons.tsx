import { Button } from "@heroui/button";
import {
  Dropdown,
  DropdownItem,
  DropdownMenu,
  DropdownSection,
  DropdownTrigger,
} from "@heroui/dropdown";
import { Icon } from "@iconify/react/dist/iconify.js";

import { iconSizes } from "@/config/sizes";
import { icons } from "@/config/icons";

export interface ActionMenuButtonsProps {
  isMe?: boolean;
  onDelete: () => void;
  sendPrivate: () => void;
  blockUser: () => void;
}

export default function ActionMenuButtons({
  onDelete,
  sendPrivate,
  blockUser,
}: ActionMenuButtonsProps) {
  return (
    <Dropdown>
      <DropdownTrigger>
        <Button isIconOnly radius="full" size="sm" variant="light">
          <Icon icon={icons.menu} width={iconSizes.sm} />
        </Button>
      </DropdownTrigger>
      <DropdownMenu>
        <DropdownItem
          key="remove"
          color="danger"
          description="Delete this message for"
          startContent={
            <Icon
              className="text-danger"
              icon={icons.trash}
              width={iconSizes.base}
            />
          }
          title="Delete"
          variant="flat"
          onPress={onDelete}
        />

        <DropdownItem
          key="private"
          description="Send private messages"
          startContent={
            <Icon
              className="text-warning"
              icon={icons.plain}
              width={iconSizes.base}
            />
          }
          title="Private Chat"
          onPress={sendPrivate}
        />

        <DropdownSection
          className="border-t-1 border-default-300 my-2 pt-2"
          title="Danger zone"
        >
          <DropdownItem
            key="block"
            description="Block this user"
            startContent={
              <Icon
                className="text-danger"
                icon={icons.block}
                width={iconSizes.md}
              />
            }
            title="Block User"
            onPress={blockUser}
          />
        </DropdownSection>
      </DropdownMenu>
    </Dropdown>
  );
}
