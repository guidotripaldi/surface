defmodule Surface.BaseComponent do
  alias Surface.BaseComponent.LazyContent

  @callback translator() :: module

  # TODO: Remove all this stuff
  defmodule DataContent do
    defstruct [:data, :component]

    defimpl Phoenix.HTML.Safe do
      def to_iodata(data) do
        data
      end
    end
  end

  defmodule LazyContent do
    defstruct [:func]

    defimpl Phoenix.HTML.Safe do
      def to_iodata(data) do
        data
      end
    end
  end

  defmacro __using__(_) do
    quote do
      use Surface.Properties

      import unquote(__MODULE__)
      @behaviour unquote(__MODULE__)

      import Phoenix.HTML
    end
  end

  def lazy(func) do
    %LazyContent{func: func}
  end

  def lazy_render(content) do
    [%LazyContent{func: render}] = non_empty_children(content)
    render
  end

  def non_empty_children([]) do
    []
  end

  def non_empty_children({:safe, content}) do
    for child <- content, !is_binary(child) || String.trim(child) != "" do
      child
    end
  end

  def non_empty_children(%Phoenix.LiveView.Rendered{dynamic: content}) do
    for child <- content, !is_binary(child) || String.trim(child) != "" do
      child
    end
  end
end
