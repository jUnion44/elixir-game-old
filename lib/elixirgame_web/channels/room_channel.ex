defmodule ElixirgameWeb.RoomChannel do
    use Phoenix.Channel

    def handleRegistry() do
        {:ok,pid} = Registry.start_link(keys: :unique, name: ElixirgameWeb.LobbyRegistry)
        {:ok, _} = Registry.register(ElixirgameWeb.LobbyRegistry, "test", "HECK YEAH")
        {:ok, _} = Registry.register(ElixirgameWeb.LobbyRegistry, "next", 1)
        :global.register_name(:lobbyData,pid)
        Process.sleep(:infinity)
    end

    @after_compile __MODULE__
    def __after_compile__(env, _bytecode) do
        spawn fn -> handleRegistry() end
    end

    def getNext() do
        toReturn = getReg("next")
        addReg("next",1)
        toReturn
    end

    def getReg(key) do
        Enum.at(Tuple.to_list(Enum.at(Registry.lookup(ElixirgameWeb.LobbyRegistry,key),0)),1)
    end

    def createReg(key,val) do
        {:ok, _} = Registry.register(ElixirgameWeb.LobbyRegistry,key,val)
    end

    def putReg(key,val) do
        {:ok, _} = Registry.update_value(ElixirgameWeb.LobbyRegistry,key,val)
    end

    def addReg(key,increment) do
        Registry.register(ElixirgameWeb.LobbyRegistry,key,getReg(key)+increment)
    end
    
  
    def join("room:" <> roomId, _message, socket) do
        if not Enum.any?(Registry.keys(ElixirgameWeb.LobbyRegistry,self()),fn x -> x== "room:" <> roomId <> ".sockets" end) do
            createReg("room:" <> roomId <> ".sockets",[])
        end
        putReg("room:" <> roomId <> ".sockets",Enum.concat(getReg("room:" <> roomId <> ".sockets"),[socket]))
        IO.puts(length(getReg("room:" <> roomId <> ".sockets")))
        {:ok, socket}
    end

    def terminate(reason, socket) do
        
    end
end
