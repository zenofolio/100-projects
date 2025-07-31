import { Button } from "@heroui/button";
import { Textarea } from "@heroui/input";
import { cn } from "@heroui/theme";
import { Icon } from "@iconify/react/dist/iconify.js";
import { useNavigate } from "react-router-dom";
import { useEffect, useMemo, useState } from "react";
import toast from "react-hot-toast";

import { iconSizes } from "@/config/sizes";
import { $string } from "@/common/utils/validation";
import { DEFAULT_RADIUS } from "@/config/defaults";
import useRoom from "@/hooks/useRoom";
import { $try } from "@/common/utils/try";
import { routes } from "@/config/routes";
import MessageComponent from "@/components/message";
import Sidebar from "@/components/sidebar";
import { icons } from "@/config/icons";

export default function ChatRoomPage() {
  const navigate = useNavigate();

  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState("");

  const { sendMessage, state, lastestMessages } = useRoom();

  const isValid = useMemo(() => {
    return $string(message) && message.length > 1;
  }, [message]);

  useEffect(() => {
    if (!state.joined || !state.room) return navigate(routes.home);
  }, [state.joined]);

  ////////////////////
  /// Handlers
  ////////////////////

  const handleSendMessage = async () => {
    if (!isValid || loading) return;

    setLoading(true);

    const [err] = await $try(sendMessage(message));

    setLoading(false);

    if (err) return toast.error(err.message);
    setMessage("");
  };

  return (
    <div
      className={cn([
        "w-screen h-screen flex items-start justify-start overflow-hidden",
        "bg-gradient-to-b from-cyan-300 to-blue-300",
      ])}
    >
      <Sidebar />

      <div
        className={cn([
          "flex-1 flex flex-col min-h-full overflow-hidden",
          "bg-gradient-to-b from-cyan-300 to-blue-300",
          "relative",
        ])}
      >
        <div className="messages flex flex-col p-4 lg:p-6 gap-6">
          {lastestMessages.map((message) => (
            <MessageComponent
              key={message.createdAt + message.username}
              msg={message}
            />
          ))}
        </div>

        <div className="compose absolute bottom-0 w-full p-4 lg:p-6">
          <div
            className={cn([
              "bg-content2 p-4",
              "flex items-center gap-4",
              DEFAULT_RADIUS,
            ])}
          >
            <Textarea
              className="w-full"
              label="Message"
              name="text"
              value={message}
              variant="faded"
              onValueChange={setMessage}
            />

            <Button
              isIconOnly
              className="z-10 reative"
              color="primary"
              isDisabled={!isValid}
              isLoading={loading}
              radius="full"
              value={message}
              variant="flat"
              onPress={() => handleSendMessage()}
            >
              <Icon icon={icons.plain} width={iconSizes.base} />
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}
