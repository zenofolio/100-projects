import { cn } from "@heroui/theme";
import { motion } from "framer-motion";
import { Icon } from "@iconify/react/dist/iconify.js";

import ActionMenuButtons from "./action-menu-buttons";

import { DEFAULT_RADIUS } from "@/config/defaults";
import { SocketMessage } from "@/types/socket";
import { iconSizes } from "@/config/sizes";

export interface MessageComponentProps {
  msg: SocketMessage;
}

export default function MessageComponent({ msg }: MessageComponentProps) {
  const isAdmin = msg.options?.isAdmin === true;

  return (
    <motion.div
      animate={{
        opacity: 1,
        y: 0,
      }}
      className={cn([
        "w-full  max-w-md flex flex-col gap-1",
        DEFAULT_RADIUS,
        !isAdmin && [" bg-content1 p-3"],
        isAdmin && ["bg-yellow-100 p-2 px-4 gap-0"],
      ])}
      initial={{
        opacity: 0,
        y: 20,
      }}
    >
      <div className="flex items-center justify-between gap-4">
        <div className="flex items-center justify-between gap-2 w-full">
          <span className="text-default-600">{msg.username}</span>

          {isAdmin && (
            <Icon
              icon="fluent-color:megaphone-loud-32"
              width={iconSizes.base}
            />
          )}
        </div>
        {!isAdmin && (
          <ActionMenuButtons
            blockUser={() => {}}
            sendPrivate={() => {}}
            onDelete={() => {}}
          />
        )}
      </div>
      <span className="font-medium">{msg.message}</span>
      <span className="text-xs text-default-500  text-right">
        {msg.createdAt}
      </span>
    </motion.div>
  );
}
