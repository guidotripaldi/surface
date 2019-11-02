defmodule Surface.LiveComponent do
  alias Surface.Translator

  defmacro __using__(_) do
    quote do
      use Phoenix.LiveComponent
      use Surface.BaseComponent
      use Surface.EventValidator

      import unquote(__MODULE__)
      @behaviour unquote(__MODULE__)

      def render_code(mod_str, attributes, children, mod, caller) do
        opts = [renderer: "live_component", pass_socket: true, assigns_as_keyword: true]
        Surface.Translator.DefaultComponentTranslator.translate(mod_str, attributes, children, mod, caller, opts)
      end

      defoverridable render_code: 5
    end
  end

  @callback begin_context(props :: map()) :: map()
  @callback end_context(props :: map()) :: map()

  @optional_callbacks begin_context: 1, end_context: 1

  defmacro sigil_H({:<<>>, _, [string]}, _) do
    line_offset = __CALLER__.line + 1
    string
    |> Translator.run(line_offset, __CALLER__)
    |> EEx.compile_string(engine: Phoenix.LiveView.Engine, line: line_offset)
  end
end